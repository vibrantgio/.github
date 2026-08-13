# Exploration: macOS file drops without forking Gio

**Status:** proposed, not started
**Author:** drafted 2026-08-11
**Shape:** written in `PLAN.md`'s task shape (`####` headings, `- [ ]` steps) so a
successful spike can be lifted into the plan as a phase without rewriting it.
It is *not* in `PLAN.md` yet and `mdplan` does not see it.

---

## The question

**Can a Vibrant Gio application accept files dragged from Finder, using only
public `gioui.org` API and no patched or forked Gio?**

Falsifiable, one bit. Everything below exists to answer it, and §11 says what
each answer obliges us to do next.

The spike is deliberately scoped to macOS. It is a probe of a *technique* —
"take the native handle Gio hands out and augment it in place" — and macOS is
where that technique is cheapest to test. §12 covers generalising it.

---

## 1. Why this is worth a spike

Gio has no OS-level drag-and-drop on any desktop platform. `io/transfer` looks
like it should cover it, but every `transfer.DataEvent` the platform layer emits
is a **clipboard** read:

| File | Line | Context |
| --- | --- | --- |
| `app/os_macos.go` | 406 | inside `ReadClipboard()` |
| `app/os_windows.go` | 728 | inside `processDataEvent`, after a `GlobalLock` |
| `app/os_x11.go` | 688 | selection/clipboard path |
| `app/os_ios.go` | 293 | pasteboard |

Wayland is the proof. Gio registers a complete `wl_data_device` listener and
implements only the clipboard half — the three drag callbacks are empty
(`app/os_wayland.go:738-748`):

```go
//export gio_onDataDeviceLeave
func gio_onDataDeviceLeave(data unsafe.Pointer, dataDev *C.struct_wl_data_device) {}

//export gio_onDataDeviceMotion
func gio_onDataDeviceMotion(data unsafe.Pointer, dataDev *C.struct_wl_data_device, t C.uint32_t, x, y C.wl_fixed_t) {}

//export gio_onDataDeviceDrop
func gio_onDataDeviceDrop(data unsafe.Pointer, dataDev *C.struct_wl_data_device) {}
```

So no arrangement of `transfer.TargetFilter` will ever see a dropped file. The
feature has to come from outside Gio, be patched into Gio, or not exist.

---

## 2. The hook, and why it is a legitimate one

`app` will not instantiate a view class we supply. `app/os_macos.m:392` is
unconditional:

```objc
CFTypeRef gio_createView(int presentWithTrans) {
    GioView* view = [[GioView alloc] initWithFrame:frame];
```

with `@interface GioView : NSView <CALayerDelegate,NSTextInputClient>` at
`app/os_macos.m:17`. There is no option, callback or registration point;
`app.Config` carries `CustomRenderer`, `Decorated`, `TopMost` and nothing about
the view.

But Gio **hands out the pointer**, and does so on a lifecycle boundary rather
than once at startup (`app/os_macos.go:983`):

```go
//export gio_onAttached
func gio_onAttached(h C.uintptr_t, attached C.int) {
	w := windowFor(h)
	if attached != 0 {
		layer := C.layerForView(w.view)
		w.ProcessEvent(AppKitViewEvent{View: uintptr(w.view), Layer: uintptr(layer)})
	} else {
		w.ProcessEvent(AppKitViewEvent{})
		w.SetAnimating(w.anim)
	}
}
```

fired from `-viewDidMoveToWindow` (`app/os_macos.m:96`). The zero-valued event
is the detach signal; `ViewEvent.Valid()` (`app/app.go:73`) exists precisely so
a client can drop its references. Gio's own April 2024 newsletter states the
intent: *"Applications performing custom rendering use `app.ViewEvent` to
acquire the platform handles necessary to construct their own graphics
contexts."*

We are using it for a different purpose than graphics contexts, but the same
contract: **the handle is public, its lifetime is announced, and invalidation is
signalled.** That is what makes this out-of-tree work rather than a hack against
private state.

The technique is then: do not subclass `GioView` — **augment the class of the
instance we are given**, once, at runtime, via the Obj-C runtime. This is the
same manoeuvre gogpu performs on its own view class in
`internal/platform/darwin/view.go`; it works identically on a class we did not
write, because Obj-C dispatch is by selector, not by declared conformance.

---

## 3. End-to-end mechanism

```
  Finder drag
      │
      ▼
  GioView (Gio's NSView) ── methods added by us at runtime
      │   draggingEntered:  draggingUpdated:  draggingExited:  performDragOperation:
      │
      ▼  (AppKit main thread — must not block)
  our IMP  ──► read NSPasteboard file URLs ──► convert point to Gio px
      │
      ▼  non-blocking send
  buffered chan dropEvent
      │
      ▼  rx.Recv
  rx.Observable[mvu.Message]
      │
      ▼  merged into mvu.Loop's messages
  Update(model, FilesDropped{Paths, Pos})
      │
      ▼
  View renders; zone registry (recorded last frame) resolves which target was hit
```

Two facts fix this shape and are not negotiable:

- The Obj-C callbacks arrive on the **AppKit main thread**, not on the mvu loop
  goroutine. Delivery must be asynchronous and non-blocking.
- `performDragOperation:` must return `BOOL` **synchronously**. We return `YES`
  after successfully reading the pasteboard, before the message has been
  reduced. The return value means "I accepted the data", not "the app finished
  handling it".

---

## 4. What we must build, precisely

### 4.1 Method table

Six selectors, with their 64-bit type encodings. `NSDragOperation` is
`NSUInteger` (`unsigned long`, `Q`); `BOOL` is `signed char` (`c`).

| Selector | Returns | Encoding | Required? | Purpose |
| --- | --- | --- | --- | --- |
| `draggingEntered:` | `NSDragOperation` | `Q@:@` | yes | accept/refuse; first hover feedback |
| `draggingUpdated:` | `NSDragOperation` | `Q@:@` | for hover | per-motion feedback |
| `draggingExited:` | `void` | `v@:@` | for hover | clear hover state |
| `prepareForDragOperation:` | `BOOL` | `c@:@` | optional | last chance to refuse |
| `performDragOperation:` | `BOOL` | `c@:@` | yes | the actual drop |
| `concludeDragOperation:` | `void` | `v@:@` | optional | post-drop cleanup |

Plus one call, not a method: `[view registerForDraggedTypes:@[NSPasteboardTypeFileURL]]`.
Without it none of the above ever fires.

`NSPasteboardTypeFileURL` is the 10.13+ type. Do **not** use
`NSFilenamesPboardType` — deprecated, and it hands back paths rather than URLs.

### 4.2 Reading the pasteboard

```objc
NSPasteboard *pb = [sender draggingPasteboard];
NSArray *urls = [pb readObjectsForClasses:@[NSURL.class]
                                  options:@{NSPasteboardURLReadingFileURLsOnlyKey: @YES}];
```

`NSPasteboardURLReadingContentsConformToTypesKey` filters by UTI if we ever want
"images only". Out of scope for the spike; note it in the API design so the
option has somewhere to live later.

### 4.3 The coordinate transform — copy Gio's, exactly

`draggingLocation` is in **window** coordinates, same as `locationInWindow`. Gio
already does this conversion for mouse events and we must match it bit for bit
or drops will land a few pixels off from clicks. `app/os_macos.m:65-74`:

```objc
NSPoint p = [view convertPoint:[event locationInWindow] fromView:nil];
CGFloat height = view.bounds.size.height;
gio_onMouse(view.handle, ..., p.x, height - p.y, ...);
```

then, Go side, `app/os_macos.go:684`:

```go
xf, yf := float32(x)*w.scale, float32(y)*w.scale
```

So the full transform is:

1. `[view convertPoint:draggingLocation fromView:nil]` → view points, lower-left origin
2. `y' = view.bounds.size.height - y` → upper-left origin
3. multiply both axes by the backing scale factor → Gio pixels

`w.scale` comes from `getViewBackingScale`; we get the same number from
`[view.window backingScaleFactor]` or `view.window.screen.backingScaleFactor`.
**Re-read it on every drop** — the window can move between a Retina and a
non-Retina display mid-drag.

### 4.4 Registration, once, on the right thread

`registerForDraggedTypes:` and `class_addMethod` are AppKit calls and must run
on the main thread. Gio gives us the door: `app.Window.Run(f)` —
*"Run f in the same thread as the native window event loop"* (`app/window.go:325`),
and `mvu.Window.Window()` already exposes the `*app.Window`.

Two different scopes, and conflating them is the likeliest bug in this spike:

- **`class_addMethod` is per-class and therefore process-global.** Every Gio
  window in the process shares `GioView`. Guard with `sync.Once`, and check
  `class_respondsToSelector` first so we never clobber an implementation Gio
  might add upstream.
- **`registerForDraggedTypes:` is per-instance.** It must run for every view,
  every time a valid `AppKitViewEvent` arrives.

---

## 5. Decisions to make, with recommendations

Each of these is a real fork in the road. Recommendations are starting
positions, not conclusions — the spike exists partly to test them.

### D1 — Where does the code live?

| Option | Pros | Cons |
| --- | --- | --- |
| a. inside `mvu` root module | no new module, no gates, no tag | forces cgo/Obj-C into tier 0, which everything imports |
| b. nested module `mvu/desktop` | cgo opt-in; org already has ten nested modules; tags carry the dir prefix | `check-layers.sh` walks *root* modules — unclear if it judges this |
| c. new repo `vibrantgio/filedrop`, tier 1 | clean charter, own cadence, own `AGENTS.md` | 21st repo, new tier row, `repos.tsv` row, full gate rollout |

**Recommendation: (b), but decide in S5, not now.** The spike itself should live
in a throwaway module so placement never blocks the technical question. Note
that (b) raises a real gate question — see §10.

### D2 — cgo Obj-C, or a pure-Go Obj-C runtime binding?

Gio is already cgo on darwin, so cgo costs us nothing new and a `.m` file is the
most legible form. gogpu's pure-Go route (goffi) exists to keep *zero* CGO,
which is their constraint and not ours.

**Recommendation: cgo with a `.m` file**, behind `//go:build darwin`, with a
no-op stub for every other platform so the package compiles everywhere.
Mixing a goffi-style binding with a cgo-created object in one process is
possible but puts the ABI risk on us for no benefit.

### D3 — How does a drop reach `Update`?

`mvu.Loop` takes `messages rx.Observable[Message]` (`mvu/loop.go:33`), so an
application can pass `rx.Merge(window.Messages(), fileDrops)` with **no change
to mvu at all**. That is the clean half.

The awkward half: the *view handle* only ever arrives through
`app.Window.Event()`, and `mvu.Window.Render` switches on exactly two event
types (`mvu/window.go:~80`) — `app.DestroyEvent` and `app.FrameEvent`. Every
other event, `AppKitViewEvent` included, falls through and is discarded.

So mvu must forward it. Options: a dedicated `ViewEvents() rx.Observable[app.ViewEvent]`
on `Window`, or a general "events we did not consume" observable.

**Recommendation: a narrow `ViewEvents()`**, backed by a buffered channel in the
same style as the existing `messageOps`. ADR-008 forbids bare `rx.Subject`s and
exported package-level observables, and `check-subjects.sh` enforces it — a
per-`Window` channel wrapped in `rx.Recv` is the idiom already in the file and
passes the gate.

A general unhandled-events stream is tempting and should be resisted: it makes
every future Gio event type an implicit part of mvu's public surface.

### D4 — How does a drop find its target widget?

The drop point arrives out-of-band, not inside a frame, so there is no `gtx` to
hit-test against at the moment it happens.

| Option | Assessment |
| --- | --- |
| Window-level only: deliver `{Paths, Pos}` and let the app sort it out | Trivial. Enough for the spike. Useless for a real IDE. |
| Zone registry: components record their rects each frame; the resolver hit-tests against the **last** frame's rects | Correct-enough — a target that moved within one frame of the drop is a non-problem in practice. Mirrors `prism/layout.FocusGroup`'s existing shape. |
| Synthesise a Gio pointer event into `input.Router` | Cleanest conceptually, but `Router` is not reachable from outside the frame loop. |

**Recommendation: window-level for S1–S3, zone registry from S4.** Ship the
registry as `Zone(gtx, tag)` recording into a per-frame slice, mirroring
`FocusGroup.Tag(i)` so it reads like the rest of the components layer.

### D5 — Hover feedback in v1?

`draggingEntered:`/`Updated:` must return an `NSDragOperation` **synchronously**,
before we know whether any zone accepts. Fully honest feedback needs the zone
registry, which lands in S4.

**Recommendation:** return `NSDragOperationCopy` whenever the pasteboard carries
file URLs at all, and refine to per-zone answers in S4 once the registry exists.
Ship enter/exit *messages* from S4 so the UI can highlight, even while the
cursor answer stays coarse.

### D6 — Multiple windows

`class_addMethod` is global, `registerForDraggedTypes:` is per-view, and the
callbacks receive `self`. Per-instance state must be keyed by view pointer.

**Recommendation:** a package-level `map[uintptr]*dropState` behind a mutex,
populated on valid `AppKitViewEvent` and deleted on the invalid one. This is the
one place a package-level mutable is warranted; document why, because
`check-subjects.sh`'s sibling concern is exactly this shape.

---

## 6. The spike, in order

### S0: Scaffold

- [ ] Create a throwaway module outside the workspace — placement is D1 and must not gate the technical question.
- [ ] Minimal Gio app: one window, `mvu.NewWindow`, a label showing "no files yet".
- [ ] Confirm it builds and runs on macOS before touching any Obj-C.

### S1: Prove the handle arrives

The cheapest possible falsification of the whole idea. If `AppKitViewEvent`
never shows up, stop here.

- [ ] Bypass mvu: drive `app.Window.Event()` directly in a loop, log every event with `%T`.
- [ ] Confirm an `app.AppKitViewEvent` with non-zero `View` and `Layer` arrives at startup.
- [ ] Confirm a second, zero-valued one arrives on window close, and that `Valid()` distinguishes them.
- [ ] Record whether it arrives before or after the first `FrameEvent` — registration ordering depends on it.

### S2: Accept a drop, print the paths

- [ ] Write the `.m` file: `registerForDraggedTypes:`, `draggingEntered:`, `performDragOperation:`, guarded by `//go:build darwin`.
- [ ] Add the methods with `class_addMethod` on `object_getClass(view)`, behind `sync.Once`, after a `class_respondsToSelector` check.
- [ ] Run all AppKit calls inside `app.Window.Run(func(){ ... })`.
- [ ] Read file URLs via `readObjectsForClasses:options:` with `NSPasteboardURLReadingFileURLsOnlyKey`.
- [ ] `NSLog` the paths. **Success criterion: dragging three files from Finder prints three absolute paths.**
- [ ] Verify a drag of non-file content (selected text from TextEdit) is refused rather than crashing.

### S3: Deliver into MVU

- [ ] Add `ViewEvents() rx.Observable[app.ViewEvent]` to `mvu.Window`, plus the `case app.ViewEvent:` in `Render`'s switch (D3).
- [ ] Buffered `chan dropEvent`; non-blocking send from the Obj-C callback; document the drop-on-full policy in the code, not just here.
- [ ] Wrap with `rx.Recv`, map to a `FilesDropped{Paths []string, Pos image.Point}` message.
- [ ] Merge into `mvu.Loop`'s messages; render the dropped paths as a list.
- [ ] **Success criterion: dropped files appear in the UI without an explicit `Invalidate` call.** If a redraw is needed, note it — it means the rx path is not waking the window and that is a finding.
- [ ] Confirm the `AutoConnect(N)` count is still correct after adding a subscriber — `mvu/doc.go` is explicit that both failure modes here are silent.

### S4: Zones and hit-testing

- [ ] Implement the coordinate transform of §4.3 and unit-test it against known inputs at scale 1 and 2.
- [ ] `Zone(gtx, tag)` recording rects per frame; resolver hit-tests the last frame's set.
- [ ] Deliver `FilesEntered` / `FilesExited` messages so a zone can highlight.
- [ ] Two zones side by side in the demo; confirm the correct one highlights and receives.
- [ ] Confirm a drop in dead space between zones produces no message rather than a wrong one.

### S5: Harden, then decide placement

- [ ] Re-registration on every valid `AppKitViewEvent`; teardown on the invalid one; no leak of the `dropState` entry.
- [ ] Two windows simultaneously; drop into each; confirm no cross-talk.
- [ ] Move the window between a Retina and a non-Retina display mid-session; confirm the drop point stays correct (validates re-reading the backing scale).
- [ ] Resolve D1 and move the code to its home; add whatever the gates in §10 demand.
- [ ] Write `doc.go` covering the pitfalls in §7 — those are exactly the non-guessable facts `llms.txt` is supposed to carry.

---

## 7. Threading and lifecycle rules

Collected because each one is silent when violated.

1. **AppKit calls on the main thread only.** `app.Window.Run` is the only
   sanctioned door. Calling `registerForDraggedTypes:` from the mvu goroutine
   will appear to work and then fail intermittently.
2. **Never block in a drag callback.** They run on the main thread; blocking
   freezes the compositor mid-drag. Non-blocking send, always.
3. **`performDragOperation:` returns before the message is reduced.** `YES`
   means "pasteboard read succeeded", nothing more. Do not try to make it
   report application-level success.
4. **`class_addMethod` is global and permanent** for the process lifetime. Once,
   guarded, after a `respondsToSelector` check.
5. **The invalid `AppKitViewEvent` is a real event, not an error.** It means the
   view left its window. Drop every reference; a retained stale `NSView` is a
   use-after-free waiting for a window close.
6. **Re-read the backing scale per drop.** Displays change under a window.
7. **`MessageOp` cannot carry this.** `mvu/doc.go` is explicit that a `MessageOp`
   added against any `op.Ops` other than the current frame's is dropped
   silently — and a drop callback has no frame at all. The channel path is not
   a stylistic preference; it is the only correct one.

---

## 8. Testing

Honest about what is automatable:

| Layer | Testable? | How |
| --- | --- | --- |
| Coordinate transform | yes | table test, scale 1 and 2, known view heights |
| URL → path decoding | yes | feed fixture URL strings incl. spaces, unicode, `%20` escapes |
| Zone hit-testing | yes | pure function over a rect slice |
| Registration idempotence | yes | call twice, assert one `class_addMethod` |
| `AppKitViewEvent` plumbing | partly | fake the event type into mvu's switch |
| An actual OS drag | **no** | manual script, §8.1 |

`components/golden` cannot help here — and note it already skips in CI for want
of a GL driver, so even the parts it could cover would not gate anything.

### 8.1 Manual test script

Written down because it will be run dozens of times:

1. Drag one file from Finder → paths appear.
2. Drag three files at once → three paths, in Finder's order.
3. Drag a folder → its path, not its contents.
4. Drag selected text from TextEdit → refused, no crash, no message.
5. Drag over a zone and out again without releasing → enter then exit, no drop.
6. Drop between two zones → nothing.
7. Drop with two windows open → only the target window reacts.
8. Move window to a second display of different scale, repeat 1 → point still correct.
9. Close the window mid-drag → no crash.

---

## 9. Risks

| Risk | Severity | Mitigation |
| --- | --- | --- |
| Gio adds its own drag support upstream and our methods collide | med | `class_respondsToSelector` before adding; prefer upstreaming (§12) |
| `GioView` does not declare `NSDraggingDestination` conformance | low | Obj-C dispatches by selector; works today, but it is undeclared surface — pin the Gio version and re-test on upgrade |
| Adding a case to mvu's event switch changes `AutoConnect` arithmetic | **high** | both failure modes are silent (`mvu/doc.go`); assert the subscription count in a test, do not tune by hand |
| cgo enters a module that did not have it | med | D1(b)/(c) keeps it out of tier 0's root module |
| Stale `NSView` pointer after detach | med | rule 5 of §7; exercised by test 9 |
| Main-thread violation that only fails under load | med | route every AppKit call through `app.Window.Run`, no exceptions |

---

## 10. Org gates this must pass before it lands

Not spike work — landing work. Listed so S5 has no surprises.

- [ ] `check-layers.sh` — a new tier row if D1(c). **Open question: does it judge nested modules at all?** It walks *root* modules per ADR-001; D1(b) may slip past it silently, which is its own small problem worth reporting either way.
- [ ] `check-no-workspace.sh` — must build and test with `GOWORK=off`; no `replace` directives.
- [ ] `go.work` — add the new `use` line; it is generated by `scripts/clone-all.sh` from the go.mod files present, so regenerate rather than hand-edit.
- [ ] `check-agents.sh` — a new repo needs a `templates/repos.tsv` row (role sentence + tier) and a rendered `AGENTS.md`. Editing the rendered file is the org's known silent no-op.
- [ ] `check-subjects.sh` — no bare `rx.Subject`, no exported package-level observable. The D6 pointer map is a package-level mutable and will need its justification written down.
- [ ] `check-versions.sh` / `llms.txt` — a new module means a new inventory row and tag; versions are measured, never typed.
- [ ] CI: macOS runner, or the package is never compiled by CI at all. Decide explicitly rather than discovering it.

---

## 11. Exit criteria — what each outcome obliges

**S2 prints paths.** The core claim holds: OS file drops are reachable from
outside Gio. Continue to S3.

**S2 fails because the handle is unusable** (wrong class, view replaced under
us, methods never fire). The out-of-tree route is dead; fall back to patching
Gio and upstreaming. Record *why* it failed — that finding is the whole value of
the spike, and it belongs in `llms.txt` so nobody spends the week again.

**S3 works but needs a manual `Invalidate`.** Acceptable, but it means the rx
path does not wake the window; document it as a known wart and open a follow-up.

**S4 hit-testing proves too coarse** (visible one-frame lag on fast drags).
Ship window-level drops, and revisit only if a real workbench app is hurt by it.

**Everything passes.** Land it per §10 — *and still open the upstream patch*
(§12). Out-of-tree is a bridge, not a destination.

---

## 12. Beyond macOS

The technique generalises, because every backend publishes its handle:

| Platform | Event | Handle | Native work |
| --- | --- | --- | --- |
| macOS | `AppKitViewEvent` | `NSView`, `CALayer` | this document |
| Windows | (HWND via ViewEvent) | `HWND` | `RegisterDragDrop` + an `IDropTarget` COM vtable |
| X11 | `X11ViewEvent` (`app/os_unix.go:14`) | display + window id | XDND destination handshake |
| Wayland | `WaylandViewEvent` (`app/os_unix.go:27`) | surface | **blocked** — the `wl_data_device` listener is Gio's, and it already owns the callbacks we would need |

Wayland is the one that cannot be done from outside, because Gio has already
claimed the listener and stubbed the methods. That asymmetry is the argument for
upstreaming regardless of how well this spike goes: three platforms can be
bolted on, one cannot, and a feature that works on three quarters of the desktop
is a support burden rather than a feature.

gogpu's implementations are the reference for each protocol — MIT, and a working
Go implementation beats a specification: `internal/platform/x11/xdnd.go` (500 L),
`xdnd_source_linux.go` (421 L), `drag_windows.go` (577 L),
`darwin/drag_source.go` (171 L), `wayland/libwayland_dnd.go` (337 L). Clone at
`/Users/rene/code/w/gogpu/gogpu`.

Two things to *not* inherit from them: their public API exposes only the final
drop (`App.OnDragDrop(func(paths []string, x, y float64))`) even though their
platform layer already models `EventDragEnter`/`Move`/`Leave` — so there is no
hover feedback — and their payload type is `[]string`. Gio's `transfer` is
MIME-typed, and ours should be too, with file URLs as one registered kind rather
than the only one.

---

## 13. Out of scope

- Outgoing drags (app → Finder). Different protocol half, `NSDraggingSource`.
- Non-file payloads: text, images, custom UTIs.
- iOS. `UIKitViewEvent` yields the *ViewController* (`app/os_ios.go:103`), not
  the view; and the sanctioned iOS embedding story is the framework build.
- Any change to how `patterns`/`components` are styled. This is plumbing.

---

## 14. Open questions

1. Does `check-layers.sh` judge nested modules, or only the nineteen roots?
   Decides D1(b)'s viability and is worth answering regardless.
2. Does `AppKitViewEvent` arrive before or after the first `FrameEvent`? S1
   answers it; registration ordering depends on it.
3. Has anyone upstream already proposed Gio file-drop support? Check the
   sourcehut tracker before writing the patch in §12 —
   [gio-plugins](https://github.com/gioui-plugins/gio-plugins) is prior art for
   the out-of-tree approach generally and may already have attempted this.
4. Should `FilesDropped` be one message or a pair (`FilesDropped` +
   `FilesRejected`)? Cheap to decide once a real app consumes it; defer to S4.

---

## 15. Reference index

Everything asserted above, with its source, so no one re-derives it.

**Gio v0.10.1** (`~/go/pkg/mod/gioui.org@v0.10.1`)

| Fact | Location |
| --- | --- |
| `ViewEvent` interface, `Valid()` contract | `app/app.go:73` |
| `AppKitViewEvent{View, Layer}` | `app/os_macos.go:351` |
| emitted from `gio_onAttached` | `app/os_macos.go:983` |
| triggered by `-viewDidMoveToWindow` | `app/os_macos.m:96` |
| `GioView` class declaration | `app/os_macos.m:17` |
| view creation, hard-coded | `app/os_macos.m:392` |
| mouse point → Gio px | `app/os_macos.m:65`, `app/os_macos.go:684` |
| `Window.Run` main-thread door | `app/window.go:325` |
| `CustomRenderer` option | `app/window.go:952` |
| clipboard-only `DataEvent`s | `app/os_macos.go:406`, `os_windows.go:728`, `os_x11.go:688` |
| Wayland DnD callbacks are empty | `app/os_wayland.go:738-748` |
| `X11ViewEvent` / `WaylandViewEvent` | `app/os_unix.go:14`, `:27` |
| `UIKitViewEvent` gives the controller | `app/os_ios.go:103` |
| external GPU contexts (`Metal{Device,Queue,PixelFormat}`) | `gpu/internal/driver/api.go:65` |

**Vibrant Gio**

| Fact | Location |
| --- | --- |
| event switch that drops unknown events | `mvu/window.go`, `Render` |
| `Messages()` channel idiom to copy | `mvu/window.go` |
| `Loop(messages, init, update)` | `mvu/loop.go:33` |
| `AutoConnect(N)`, both failures silent | `mvu/doc.go` |
| `MessageOp` dies outside its frame's `op.Ops` | `mvu/doc.go` |
| focus-tag registry to mirror for zones | `components/layout/focus.go` |
| tier table | `PLAN.md`, ADR-001 |
| module rename (spectrum→theme etc.) | `PLAN.md`, ADR-009 |

**External**

- [Gio Newsletter, April 2024](https://gioui.org/news/2024-04) — ViewEvent's stated purpose
- [gio-example/glfw](https://github.com/gioui/gio-example/blob/main/glfw/main.go) — the heavier "own the window" route, rejected here
- [gio-plugins](https://github.com/gioui-plugins/gio-plugins) — prior art for out-of-tree platform extensions

---

## Addendum, 2026-08-13 — two questions closed from outside this spike

Recorded when Phase H entered `PLAN.md`. The spike itself (S0–S5) remains
unrun; what changed is its ground.

**D1 is resolved: `mvu/desktop`.** Not by this spike but by the window-chrome
work, which reached the same fork first. A sibling session
(diarizer/earwitness) spiked the macOS full-size-content-view chrome —
findings in `diarizer/explorations/macos-fullsize-content-window.md` — and
Phase H schedules that chrome behind a nested `mvu/desktop` module: cgo
Objective-C behind `//go:build darwin`, stubs elsewhere, tier 0 kept
cgo-free. File drops are the second tenant of the same module; §5 D1's
recommendation (b) stands, decided rather than deferred.

**Open question 1 is answered: check-layers skips nested modules.**
`scripts/check-layers.sh:196-200` classifies any `*/*` module that is not a
workbench app or a named demo as `kind=adapter` and skips judgment, so
`mvu/desktop` needs no gate change. The constraint that matters is line 293:
a parent importing its own nested module is a hard violation, so the
dependency runs `mvu/desktop → mvu`, never the reverse — which D3's "the loop
needs no changes" observation already wanted.

**Borrowable from the chrome spike** (all empirical, gioui.org v0.10.1,
macOS 25.5.0): `dispatch_sync` onto the main queue from a non-main goroutine
is safe while `app.Main` holds the main thread; `[NSApp windows]` iteration
finds the window under `Decorated(false)`; and any later `w.Option(...)` call
re-runs Gio's Configure, silently undoing external window mutations — the
finding that forced mvu to own its Option boundary (H1.1), which is the same
notification a re-registering drop target would want after §4.4.
