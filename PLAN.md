# Vibrant Gio — Phase BT, planned apart

This file holds one phase, authored in the `bt-vaultview` worktrees at
`/Users/rene/code/w/vibrantgio-bt` so it can be appended to the main
PLAN.md later. The main PLAN.md's standing rules (its lines 1–105) bind
every task here unchanged, with two additions: all work happens in the
`bt-vaultview` worktrees and is committed and pushed on that branch,
never on a default branch; and `.github/scripts/check-retired-words.sh
check <module>` (from the main checkout) runs clean on every touched
module before commit.

## Phase BT: Vaultview reads and remembers

Executes three asks of Rene's (2026-09-06) against the Language:
vaultview's window remembers its size, position and rail width across
launches; its note column reads at a measure and centres within its
region; and the seams the user can drag are splitters — one splitter
for the org, hoisted from the shell's split pane and vaultview's aside.
Language entries Splitter and Measure are already in DOMAIN.md. G-BT3
waits for the main plan's BR4.3 (Divider becomes seam and splitter) to
land and is built on top of it; G-BT1 and G-BT2 overlap nothing in
flight. No tags.

### G-BT1: The window remembers itself

#### BT1.1: mvu remembers a window's size and position

- [x] An opt-in in `mvu` — one call at window construction, given the
  application's name — that records the window's size and position in
  device-independent units on every configure event, debounced so a
  drag does not write on every frame, to a small JSON file in the
  OS-appropriate config directory under the application's name, the
  same directory `theme/preferences` resolves. Nothing is written until
  the first change after start.
- [x] On the next start the remembered size and position are applied
  before the first frame; when there is no file, the file is unreadable,
  or the remembered frame no longer fits any screen, the application's
  defaults apply and the file is replaced on the next change. Position
  uses Gio's public API where it exists and the `mvu/desktop` AppKit
  hook where it does not; if position cannot be read or set on a
  platform, size alone is remembered there and the package doc says so.
- [x] Tests pin: round trip through a temporary directory; a missing or
  corrupt file yields defaults; a frame outside every screen yields
  defaults; the debounce writes once for a burst.
- [x] Exit: green in `mvu`; commit and push on `bt-vaultview`.

#### BT1.2: Vaultview remembers its window and its rail

- [x] Vaultview adopts BT1.1 at its window construction; its default
  size is what it is today. The rail pane's width and the aside's width
  join the same file as application state, restored before the first
  frame — the rail's width becomes meaningful when BT3.2 makes the rail
  draggable, and until then it is written as the fixed width.
- [ ] Exit: green in vaultview's module; a manual check that a moved
  and resized window comes back where it was; commit and push on
  `bt-vaultview`.

### G-BT2: The note column reads at a measure

#### BT2.1: The markdown style gains a measure

- [x] `markdown.Style` gains a measure — the width a block may reach,
  zero meaning the full width as today. When the viewport is wider,
  every top-level block lays out at the measure and is centred in the
  viewport; the gutter is still reserved for the scrollbar at the
  viewport's edge, not the measure's. A scroll area for wide content —
  a code block, a table — is no wider than the measure and scrolls
  inside it.
- [x] Goldens follow: one wide-viewport capture per scheme shows a
  centred column with a code block that scrolls inside the measure.
- [x] Exit: green in `markdown`; commit and push on `bt-vaultview`.

#### BT2.2: Vaultview reads at the measured measure

- [x] Vaultview sets the note column's measure from the stored reading
  reference (`.github/reference` and the typeset measurements the
  document heading scale was derived from) — a number with provenance,
  not a guess — and the column centres between the rail pane and the
  aside at any window width.
- [x] Fresh-eyes review at a wide window and at the narrowest window
  where the measure still fits, both schemes, per the standing
  protocol; findings pooled.
- [x] Exit: green in vaultview's module; commit and push on
  `bt-vaultview`.

### G-BT3: One splitter

Waits for the main plan's BR4.3 to land; rebase `bt-vaultview` onto it
first.

#### BT3.1: The splitter pattern

- [ ] `patterns/splitter`: the Splitter entry made code — the seam
  between two regions made operable, drawn at the seam's width in the
  seam's colour, thicker and firmer while a hand is on it, a hit area
  wider than the line, the resize pointer over it, dragging clamped to
  the bounds each region allows. Hoisted from the shell's split-pane
  drag and vaultview's aside splitter, which are the same thing twice;
  the shell adopts it in this task.
- [ ] Exit: green in `patterns` and every consumer of the shell's split
  pane; commit and push on `bt-vaultview`.

#### BT3.2: Vaultview's two splitters

- [ ] A splitter between the rail pane and the note column, clamped to
  a minimum rail width and a minimum note measure; the aside's seam
  becomes the same splitter. Both widths are remembered through BT1.2's
  file.
- [ ] Fresh-eyes review of both seams at rest and under a hand, both
  schemes; findings pooled.
- [ ] Exit: green in vaultview's module; commit and push on
  `bt-vaultview`.

## Pool

Findings this phase's reviews turned up and did not fix. They append as
the phase runs; nothing here is planned work until it is cut into a task.

### From BT2.2's fresh-eyes review (2026-09-06)

Full record in `reviews/bt2.2-measure-fresh-eyes.md`; the numbers below
are the reviewer's, measured off 1600×900 renders at one pixel per dp.

- **The note page's own rows do not know the measure — caused by BT2.2.**
  At a wide window the breadcrumb row, the Properties disclosure and the
  Properties card run the whole column, x 272–1249, while the document
  reads at x 498–1037: two grids stacked on each other with 22 px
  between the card's foot and the title's cap. The reference reading
  surface splits them the other way — its head row stands at the
  window's top-left, outside the column, and its properties table sits
  inside the column with the prose. Deciding which rows are the
  document's and which are the window's, and giving the document's rows
  the same lead, is a task. It also wants the arithmetic in `markdown`
  rather than copied into an application.
- **A scroll area cuts its content mid-glyph with nothing marking the
  cut.** A code block wider than the measure is hard-cut at the scroll
  area's trailing edge — through the middle of a letter — with no fade
  and no other sign that the line continues. The scrolling is ruled and
  right; the edge treatment is `markdown`'s and is not.
- **The fenced block still wears the highlighter's own palette, and the
  light appearance is the worse one.** Confirms S7 on the current build.
  Code comments measure 2.30:1 in light and 3.36:1 in dark, both under
  the 4.5:1 body floor; the light fill `#EFF1F5` stands at 1.005:1
  against the page, so the block is defined by its border alone and
  reads as a text field. Its border is also the darkest in the window at
  `#797979`, against `#B6B6B6` for the properties card.
- **The properties card is a 978×84 outlined box that is 86 % empty**,
  filled with exactly the page fill, carrying no row rule and no column
  rule, its content ending at x≈410.
- **The pane's 8 px margin of backdrop stops halfway across the window.**
  It runs the pane's leading edge full height and its top and bottom
  edges to x=247, where the content area begins with no gap at all, and
  the pane's rounded corners bite a wedge of content-area fill out of
  themselves at each end of the top and bottom strips.
- **A link's underline is drawn through its descenders**, 2 px below the
  baseline, with no descender skip.
- **The document's level 1 and level 2 headings are 2 px apart** — 19 px
  and 17 px cap heights against a 12 px body — so a note's title reads
  as a third peer heading rather than as the title.
- **The trailing column never gives width back.** 320 dp at every window
  width, 615 px of it empty between the outline's last entry and the
  backlinks rule; at 1163 dp that is 27 % of the window.
- **Nothing in the window reads as Cocoa**: a grotesque that is not the
  system face; a selection fill that is pale lavender in one appearance
  and saturated violet in the other and follows no system accent; a
  scrollbar heavier and tighter to the edge than the platform's; a code
  palette imported whole from elsewhere.
- **The rail's rows carry no marks**, so a folder and a note at the same
  depth read as the same kind of thing, and the rail's footer controls
  are bare text at the same weight and colour as those rows.
- **The rail and the outline set the same string at different sizes** —
  a 10 px cap against an 8 px cap — in pills of the same height on rows
  of the same pitch.
- **One note's name is on screen four times at once**: the rail's
  selected row, the breadcrumb's tail, the title, and the outline's
  first entry.
