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

- [ ] An opt-in in `mvu` — one call at window construction, given the
  application's name — that records the window's size and position in
  device-independent units on every configure event, debounced so a
  drag does not write on every frame, to a small JSON file in the
  OS-appropriate config directory under the application's name, the
  same directory `theme/preferences` resolves. Nothing is written until
  the first change after start.
- [ ] On the next start the remembered size and position are applied
  before the first frame; when there is no file, the file is unreadable,
  or the remembered frame no longer fits any screen, the application's
  defaults apply and the file is replaced on the next change. Position
  uses Gio's public API where it exists and the `mvu/desktop` AppKit
  hook where it does not; if position cannot be read or set on a
  platform, size alone is remembered there and the package doc says so.
- [ ] Tests pin: round trip through a temporary directory; a missing or
  corrupt file yields defaults; a frame outside every screen yields
  defaults; the debounce writes once for a burst.
- [ ] Exit: green in `mvu`; commit and push on `bt-vaultview`.

#### BT1.2: Vaultview remembers its window and its rail

- [ ] Vaultview adopts BT1.1 at its window construction; its default
  size is what it is today. The rail pane's width and the aside's width
  join the same file as application state, restored before the first
  frame — the rail's width becomes meaningful when BT3.2 makes the rail
  draggable, and until then it is written as the fixed width.
- [ ] Exit: green in vaultview's module; a manual check that a moved
  and resized window comes back where it was; commit and push on
  `bt-vaultview`.

### G-BT2: The note column reads at a measure

#### BT2.1: The markdown style gains a measure

- [ ] `markdown.Style` gains a measure — the width a block may reach,
  zero meaning the full width as today. When the viewport is wider,
  every top-level block lays out at the measure and is centred in the
  viewport; the gutter is still reserved for the scrollbar at the
  viewport's edge, not the measure's. A scroll area for wide content —
  a code block, a table — is no wider than the measure and scrolls
  inside it.
- [ ] Goldens follow: one wide-viewport capture per scheme shows a
  centred column with a code block that scrolls inside the measure.
- [ ] Exit: green in `markdown`; commit and push on `bt-vaultview`.

#### BT2.2: Vaultview reads at the measured measure

- [ ] Vaultview sets the note column's measure from the stored reading
  reference (`.github/reference` and the typeset measurements the
  document heading scale was derived from) — a number with provenance,
  not a guess — and the column centres between the rail pane and the
  aside at any window width.
- [ ] Fresh-eyes review at a wide window and at the narrowest window
  where the measure still fits, both schemes, per the standing
  protocol; findings pooled.
- [ ] Exit: green in vaultview's module; commit and push on
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
