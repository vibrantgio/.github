# Off-the-shelf shells from the apps Rene prefers — exploration

Drafted 2026-09-06 on Rene's ruling: a layout nobody uses leaves the
library, and mindchat and vaultview become the shells an application
starts from, the best-practice starting point rather than a specimen.
Takes `standard-shell-plan.md` (the earwitness draft) as input; where
the two overlap this document names which task absorbs which. Pool
material until Rene shapes it; nothing here is dispatched.

## What exists, and who uses it

| In the library | Consumers | Verdict proposed |
|---|---|---|
| shell, sidebar-header-main layout | feeds | migrates to a shipped shell, then leaves |
| shell, split-pane layout | feeds, nested in the above | its drag is the splitter now; the layout leaves with the shell |
| shell, three-column layout | none | leaves the library |
| pane | mindchat, vaultview | stays: it is the shells' leading part |
| sidebar, navbar | gallery specimens only | navbar stays for the marketing shell; sidebar's fate is the source list's ruling |

Three applications each drew their own window: vaultview (pane, note
column, aside, one chrome row, a status bar), mindchat (pane, content
column with a chrome row, transcript and input bar), feeds (the shell's
sidebar-header-main with a split pane inside). Vaultview's and
mindchat's frames share their vocabulary already: the pane as an inset
object with the backdrop showing around it, the recall convention (a
control that travels with the pane cannot be the one that recalls it),
the window buttons measured from the glass, the chrome row as a title
row. That shared frame is the shell to ship.

## The shells

Two arrangements, one pattern, variants named by the Language's Shell
entry ("the arrangements its variants name"):

1. **Pane and column.** Mindchat's window: the pane down the leading
   edge, a content column beside it with one chrome row across its
   top. Vaultview with its aside away is the same window.
2. **Pane, column and aside.** Vaultview's window: the same, plus a
   trailing aside on a splitter, and a status bar under the column.

Both carry: the pane on a splitter (BT3.2), widths and the window frame
remembered (BT1.x), the recall toggle in both halves, Tab order in
reading order, the chrome row holding the recall control, a title and
the trailing actions. The aside and the status bar are slots that may
be empty; an empty aside takes no width.

Words for Rene to coin or approve before code: the two variants' names
(candidates: "pane and column", "pane, column and aside"; or the
platform's "two-column" / "three-column"); "chrome row" versus the
navbar (the row is a title row one control height tall; the navbar is
the marketing band); "source list" for the pane's sectioned list of
places (vaultview's tree, mindchat's conversations, feeds' feeds) or
a ruling that the list control with a row recipe already is one.

## What the apps keep and what they give up

- **Vaultview** gives up frame.go's geometry wholesale; keeps its
  columns' contents, its note measure, its splitters' clamps (which
  become the shell's, parameterised by the column's minimum).
- **Mindchat** gives up frame.go the same way; keeps the transcript,
  the input bar and its menus. Its chrome row's model picker is the
  trailing-actions slot.
- **Feeds** moves from the shell's old layouts onto the pane-column-
  aside variant (feeds list in the pane, articles in the column,
  the article in the aside, or the two-pane variant if the reader
  prefers); the old layouts are then unconsumed and leave.
- **Goldens** regenerate once per app with the cause named; the
  abrupt rule applies, no compatibility layouts kept.

## Sequencing, and the overlap with the earwitness draft

The earwitness draft's G-BU2 (headless window render as a library, an
mvu test driver) comes first here as well: this week's reviews were all
rendered without a screen through vaultview's local renderer, and every
adoption task below needs it. Its G-BU3 (three-column shell, splitter
and widths, recall and Tab order, source list) is this exploration;
BU3.1–BU3.3 collapse into "extract the shell from vaultview, mindchat
adopts, feeds adopts, the old layouts leave". BU3.4, the source list,
stays its own task after the shell. G-BU4 to G-BU6 are the recorder's
and are untouched by this.

Proposed goals, one task per run:

1. **Language.** Shell variants named; chrome row ruled against navbar;
   source list ruled; sidebar's fate ruled. One task.
2. **Seeing without a screen.** BU2.1 as drafted: the whole-window
   renderer in a library; vaultview, mindchat and the launcher adopt.
   One task. (BU2.2, the driver, can follow at any time.)
3. **The shell.** Extract from vaultview into the shell pattern as the
   pane-column-aside variant with the aside optional; vaultview adopts
   in the same task (it is the reference, so this is a move, not a
   copy). One task, possibly two if the recall and Tab wiring
   outgrows it.
4. **Mindchat adopts** the pane-and-column variant; its frame goes.
   One task, fresh eyes on the window.
5. **Feeds adopts**; the sidebar-header-main and split-pane layouts and
   the three-column layout leave the library; the gallery's shell
   specimens become the two variants. One task.
6. **The source list** (BU3.4) from vaultview's tree and mindchat's
   conversation list; both adopt. One task, after Language.

## Open questions for Rene

- Do the two variants stay one pattern with an optional aside, or two
  named shells? (Recommended: one pattern, two variants, since the
  aside toggles at runtime in vaultview.)
- Does the status bar belong to the shell or to the application? (It
  is a chrome region in the Language; recommended: a shell slot.)
- Is feeds' reading layout the three-column variant, or is feeds
  better served by two columns with the article in the column? The
  answer decides whether the old split pane is missed.
- The launcher's window: does it adopt a shell or stay bespoke?

## Input from the recorder application outside the org (2026-10-01)

Its owner ruled there the same day: the application changes its shell
first, then takes its slices one at a time, each by reading the
workbench exemplars, generalising the pattern into the library, and
adopting it afterwards. It bootstraps on the round of 2026-09-26 and
waits for the shell this exploration proposes rather than drawing its
own frame. Pool material until Rene shapes it; nothing here is a
dispatch.

What it needs from the shell beyond the two arrangements above:

1. **A third arrangement: pane, list and content.** The pane down the
   leading edge (220 dp, recall toggle in both halves), then a list
   column of absolute width on a splitter (default 300 dp, 220 to 480;
   it keeps its width when the window resizes), then the content
   column absorbing the rest. The platform's windows of this shape:
   Mail, Notes, and Voice Memos with its folder sidebar. One band
   across list and content, one share per column: the list's share
   shows a title (the folder's name) and, while the pane is away, the
   recall toggle and the pane's primary act as toolbar buttons; the
   content's share holds the trailing acts, a search field at the
   trailing end.
2. **A foot slot under each column**, optional, taking no height when
   empty. Its record row lives under the list column; it uses no
   status bar under the content. The draft's status bar generalises
   to a foot per column.
3. **The pane's own foot slot**: a hairline the pane's width and one
   row under it (mindchat's Settings row).
4. **The pane's width and shown state and the list's width remembered
   by the shell**, as drafted; the application persists nothing of
   the frame.
5. **The empty-content placeholder** ("No session selected") is the
   application's content, not the shell's.

Its answers to the open questions above:

- One pattern with variants, as recommended; its variant is pane, list
  and content, no aside.
- The status bar: a shell slot, per column (point 2).
- Feeds' arrangement and the launcher: no view from there.
- Names: its own language says the folder pane, the session list
  column and the detail column; the shell's names rule and it maps
  onto them.

What it waits on, in this exploration's sequence: the Language task
(names), the whole-window renderer as a library (its goldens need
it), the shell extraction with the third arrangement, and later the
source list (its folder pane is one). It pins per tagged round.

The held draft (`standard-shell-plan.md`, G-BU5 and G-BU6) stays the
queue for the controls. It will ask per slice, one at a time, in this
order: the session list and folders (source list, two-line row),
recording (the record row's level meter and pill), following live
(tail-follow, speaker turns with a chip), review (seek bar),
transcription (progress), assignment (dialog), then search,
microphones, setup, import, speakers, export.

## The recorder's first control request after the shell (2026-10-01)

The held draft's item for the application's life (G-BU4, the
terminate hook with a veto, the reopen hook, did-become-active) in
`mvu/desktop`, asked for ahead of the rest of that goal. The recorder's
menu bar landed on the desktop module's menu bar at v1.1.0, every item
a message through the loop; its quit path cannot, because the module
has no terminate or reopen hook, no workbench app has one, and Gio
exposes no delegate seam, so it is Objective-C on the application's
delegate, which belongs in the library before an application uses it.
Asked as drafted: applicationShouldTerminate as a hook the application
answers from its loop (a veto, so a running recording stops and
finalises first and the application then quits itself),
applicationShouldHandleReopen, and did-become-active, each delivered as
a message on the window's stream the way the bar's items are, callbacks
hopping off the main queue as the drop target's do. The About pane is
not needed yet. Timing is the owner's; it may share a round with the
shell or come earlier. Pool material; nothing here is a dispatch.

## The recorder's proposal: the pane frame gains a slide (2026-10-02)

Pool material beside the shell until the owner shapes it. Its owner
ruled there the same day that the recorder's shell is copied from
vaultview first (the pane frame, the pane strip with bare marks, the
sidebar helpers' rows and pill, the recall convention), and that what
the two windows then share is named so the library extracts one shell
pattern both derive from. The copy landed; the shared-parts list
follows once read off both frames.

What it found: `shell.PaneFrame` has two states for the pane, hidden
and not, and `pane.Bounds` answers an empty rectangle for the first,
so the pane arrives and leaves in one frame. Voice Memos, the window
the pane's measurements were taken off, slides its sidebar out and
back. No workbench app animates its pane, so the recorder carries one
app-local control of 180 lines that turns the one bool the frame takes
into the one width the frame takes: `effects/tween` between 0 and the
pane's width over `MotionScale.DurNormal` on `EaseStandard`, reversal
from the drawn width, a frame asked for only while moving, instant
under the reduced scale. Everything else follows from the width: the
content column reflows, the toolbar re-measures, the pane's corners
move, the shadow casts from the new bounds.

What it would take in the library, in three parts of increasing reach:

- **`tokens.Bezier` gains an evaluator** (`At(t)`), since the theme
  publishes the control points and nothing evaluates them; needed by
  every consumer of the easing family whether or not a pane slides.
- **`effects/tween` gains an eased constructor** over that evaluator,
  removing the closure idiom from every caller wanting the theme's
  curve; the package's own doc names the gap.
- **A slide ships beside the frame, not inside it**: a small exported
  type in `patterns/pane` the caller holds and spends into
  `PaneFrame.Width`, the frame learning nothing and `Hidden` staying
  the caller's `width <= 0`. The recorder recommends this over the
  frame holding the animation, because the frame is a value built
  fresh every frame with no lifetime, and the same slide would drive
  an aside without the frame knowing. One rule ships with it: the
  toolbar's leading inset while the pane is mid-sweep is the larger
  of the toolbar's own gutter and the inset past the window's control
  buttons, so it passes without a step.

When it lands the recorder deletes its control and calls the library.

Addendum measured the same day on Voice Memos (macOS 26) with real
pointer clicks and 100 ms captures: the pane translates as one object,
its column anchored to its trailing rim, entering from and leaving
past the window's leading edge with its own margin and rounded corners,
no row clipped in place and no title truncated; the content column's
leading edge is the pane's trailing rim throughout; the window's three
buttons stay on the glass while the pane passes under their line; the
new-folder and toggle marks snap to their resting positions from the
first frame (on the pane's corner line while it is still arriving,
bordered in the toolbar from the first frame of the departure); the
whole motion is about 300 ms (the rim moved 228, 163, 84 px across
100 ms captures). So the slide yields an offset as well as a width,
bounds from the margin plus the width minus the pane's full width to
the margin plus the width, clipped to the window, and the frame
accepts bounds whose leading edge lies off the window. The recorder's
own control narrowed in place, which is wrong against this, and is
being corrected to translate.
