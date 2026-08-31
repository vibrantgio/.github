---
date: 2026-08-28
task: AY2.1
phase: AY
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# AY2.1 fresh-eyes review — the vaultview window, both schemes

Headless whole-window renders at 1100×800, both appearances, taken from
the composition the goldens store:
`workbench/vaultview/testdata/golden/window-light.png` and
`window-dark.png`.

**The live route was unavailable.** The machine's screen was locked for
the whole of this task (`CGSSessionScreenIsLocked` true). Under the
display shield a window-bounded `screencapture -l` fails, a whole-screen
capture returns black, and the toolkit panics inside window
initialisation. So this review is of a headless frame, which cannot show:
the platform's own window control buttons, the OS's rounding of the
window glass, vibrancy or any translucent material, a focus ring, the
inactive-window state, or anything that moves. Those absences are known
artifacts and are not defects.

Handed to a fresh subagent that had not seen the packet, with no
checklist and one question: *what would a developer on this platform
complain about?*

## The reply, verbatim

I read both images, measured them, and then checked every suspicion against the source and the stored macOS reference before believing it. Here is what I actually see.

## The thing that is wrong: the search field is the only square box in a rounded window

"Find a note…" occupies x 16–239, y 52–91 in both images, and its 1 px border (`#797979` light / lighter grey dark) turns 90 degrees at all four corners with **zero anti-aliasing** — I sampled the corner neighbourhoods and the ink goes from border to fill in one pixel, no ramp.

Nothing else in the window does that. Every other box carries a visible AA arc:

| element | radius | source |
|---|---|---|
| sidebar pane | 10 dp | `frame.go:163` `railRadiusDp` |
| tree selection pill | 8 dp | `tree.go:71` `treePillRadiusDp` |
| outline pill | 8 dp | `aside.go:105` `asidePillRadiusDp` |
| properties box, code input, fence | 4 dp | `note.go:865` `tokens.Radius.Base` |
| both scrollbar thumb caps | 3 px | `scrollbar.FromTokens` |

So the square field sits about six pixels inside the rail's own rounded corner — the mismatch is literally side by side. On macOS 26, where a sidebar search field is the most rounded control on screen, that is the first thing a developer's eye lands on, and they would file it as a design bug.

**It is not a design bug. It is a harness artifact, and it is the second time.** `/Users/rene/code/w/vibrantgio/workbench/vaultview/golden_test.go:59` defines `sharpRadius = tokens.RadiusScale{}` and passes it to `renderWindow` at lines 332, 387, 428, 514, 674, justified by:

> Sharp corners keep the goldens deterministic: anti-aliased rounded corners vary slightly between GPU contexts, breaking pixel-exact diffs.

That justification does not survive the image. `renderWindow` threads `rad` to exactly **one** descendant — `renderTree` → `input.Render` → `textfield.go:314`'s `tok.radius.Md` (6 dp). Every other rounded thing reads a module-local constant or the `tokens.Radius` package global and never consults the parameter. The pin therefore flattens the one control that needed no protection and leaves every genuinely AA'd corner in the frame untouched. The goldens are not deterministic in the way the comment claims, and the pin buys nothing.

Worse, `tree.go:621` states the opposite contract in writing:

> The find field is drawn through the component's own static path, so the golden carries the same field the live rail wears.

It doesn't. Live, the field is built from the reactive theme (`tree.go:276` `input.TextField`) at `Radius.Md` = 6 dp and is rounded. In the golden it is square. The stored image is not a picture of the shipping window, and it diverges precisely at the control users look at first.

And this exact failure was diagnosed and fixed **yesterday** in a sibling app. `PLAN.md:3988–3995` records it: review frames "rendered with the theme's radius scale pinned sharp, the way the stored goldens upstream pin it, so every rounded corner in them was square and the reviewer reported square corners in a rounded-corner OS." That was AK6.5; `todos/window_render_test.go` now renders at the real scale. `vaultview` still pins. In todos the pin flattened *everything*, so it was self-evidently an artifact; here it flattens exactly one widget, which is far more convincing as a real defect — the trap AK6.5 was written to close, reopened in a sharper form.

## What I deliberately am not complaining about

A reviewer's instinct fires on all of these. Each one has a documented, measured answer, and I checked every one before discarding it:

- **No titlebar, no traffic lights, square opaque window corners.** These are headless CPU renders at `PxPerDp: 1` of the app's own surface (`golden_test.go` `drawOnce`), not `screencapture` of a decorated window. The empty run across the top-left of the rail is the deliberate button reservation (`goldenLeading = 79`, a frozen real macOS measurement).
- **Both scrollbars fully opaque with no scrolling happening.** They are fading overlay bars; `scrollbar.fade` documents that frame one counts as activity "so a single-frame capture (a golden) never catches it mid-fade."
- **The code fence's horizontal bar is far heavier than the page's vertical bar, and the relationship inverts between themes** (I measured 5.91:1 vs 3.03:1 light, 10.21:1 vs 4.94:1 dark). Fully deliberate — `markdown/style.go:633–667` argues it at length and predicts 6.30:1 and 9.91:1, which my numbers corroborate.
- **Dark mode's surface separation collapses to 1.03:1** (sidebar `#151515` vs content `#181818`, ΔY 0.0016, against 1.13:1 / ΔY 0.115 in light). I measured the stored reference: macOS Notes in dark runs sidebar `#1c2123` vs content `#1e1e1e` — also **1.03:1**. The platform does the same thing.
- **The rail floats as an outlined inset card while the right aside is flush to three window edges.** This is current Tahoe idiom (the machine is on 26.5.2) and `frame.go:485–500` cites the platform worked example: a floating panel outlined internally at 1.51:1 beside a flush side carrying no outline.
- **Thin, greyish-looking text.** 1x render artifact.

## One secondary note

`markdown/style.go`'s `codeScrollbar` rationale asserts the fence fill "is the raised storey, which is lighter than both in either scheme." In dark that holds (`#1e1e2e` over `#181818` paper and `#151515` floor). In light it does not: the fence is `#eff1f5` and the paper is `#f6f6f6` — lighter than the floor, but darker than the page. The conclusion still stands (a bar clearing 3:1 on both extremes over-clears on anything between them), so this is a wrong premise under a right answer, not a rendering fault. Worth correcting in the comment since the whole override is argued from it.

## Bottom line

The window is in better shape than a first glance suggests — nearly everything that looks off has a measurement and a citation behind it. The one real complaint is the square search field, and the fix is in `/Users/rene/code/w/vibrantgio/workbench/vaultview/golden_test.go`: drop `sharpRadius` and render at `tokens.Radius`, the same change AK6.5 already made to `todos`. Regenerating the goldens will change only that one control's corners, which is itself the proof that the pin was never doing what its comment claims.

## Triage (added by the task, after the reply)

The images above are the goldens as they stood when the reviewer was
handed them. The one complaint was acted on in the same task, so the
stored files now differ from what was reviewed at exactly the place the
reviewer named — the find field's four corners.

- **The square search field: FIXED.** Every claim was verified before
  acting. `renderWindow`'s `rad` parameter reaches exactly one
  descendant, `renderTree` → `input.Render`, and nothing else; the live
  field builds from the reactive theme at `Radius.Md`; `renderTree`'s
  own comment promised the golden carried the field the live rail wears
  and it did not; AK6.5 closed the same trap in `todos`. The
  determinism argument the pin rested on is void on its face — the pane
  (10 dp), both pills (8 dp), the properties box and the fence
  (`Radius.Base`) and the scrollbar caps all draw antialiased arcs into
  these same goldens and have always diffed exactly. `sharpRadius` is
  now `goldenRadius = tokens.Radius` and the goldens were regenerated;
  the only pixels that moved were the field's corners, which is the
  proof the pin was never buying what it claimed.
- **The linchpin's dark magnitude, corroborated rather than
  challenged.** Three reviewers in a row contested the direction of the
  floor (S28's entry, and the two before it). This one measured the
  window at 1.03:1 between furniture and content in dark, went to the
  stored macOS reference to check, found the platform doing the same
  thing, and filed it under "not complaining". ADR-019's own numbers
  agree: Notes' pane samples at luminance 31.2 against a content ground
  of 30.0, +1.2 — the same 1.03:1. First independent confirmation of
  the magnitude the previous three called wrong.
- **`markdown/style.go`'s `codeScrollbar` rationale rests on a false
  premise in its light half:** it asserts the fence fill is the raised
  storey and "lighter than both in either scheme", where in light the
  fence `#EFF1F5` is lighter than the floor and DARKER than the
  `#F6F6F6` page. The conclusion survives — a bar clearing 3:1 at both
  extremes over-clears between them — so this is a comment to correct,
  not a rendering fault. Different repo, recorded not fixed.
- **Nothing was said against this task's own subject.** The reviewer
  read the rail's outlined inset pane beside the flush, unoutlined
  aside and filed it as current platform idiom, naming the 1.51:1
  outline. No complaint about the retired shadow, the aside's hairline,
  or either seam's weight.
- **Known false positives the reviewer filtered for itself,** without
  being briefed: the absent titlebar and traffic lights, the square
  window corners, the scrollbars drawn at rest, the fence bar's weight
  against the page bar's, and thin-looking ink at 1x. All are in the
  ledger already; none is re-recorded.
