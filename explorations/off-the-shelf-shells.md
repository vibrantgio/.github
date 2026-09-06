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
