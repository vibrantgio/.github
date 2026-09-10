---
date: 2026-09-10
task: BY1.2
phase: BY
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BY1.2 fresh-eyes review — the vaultview window with a live query and three matches

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, the window frame's own seam not being a scrollbar, and a still
capture being unable to show a fade, an animation, a hover state or the
text cursor — and told nothing else.

## How the captures were taken

**No window was opened.** The whole vaultview window was rendered
headlessly at 1100×800, one device pixel per point — the size the
application's window opens at — by `TestVaultWindowFindGolden` in
`workbench/vaultview`, which is the harness the find goldens use: the
note seated one section above the three the query matches in, so all
three marks stand on the page with the one the reader is on in the
middle of it. The reviewer was given the dark capture and the light
one, in that order, and nothing else.

## The reviewer's reply, verbatim

> Here is what I found, in rough order of how loudly a Mac developer would complain.
>
> **There is no title bar and no traffic lights.** The window is 1100×800 and every pixel of row 0 is app content — the sidebar card's top border at y=8, "Second Brain" at y=19, "Outline" at y=47. Where the close/minimize/zoom buttons belong there is a rounded sidebar card containing a search field, with a sidebar-toggle icon tucked at its top-right (x≈228, y≈26). Nothing identifies a draggable region either. On a Mac this is the first thing you notice and the first thing that makes the window feel un-closable and un-movable.
>
> **In the dark image, the current search match is the least readable text in the window.** The three "margin" highlights sit at y≈274, 385 and 496 in the note body. The two non-current ones are white (#EEEEEE) on dark olive (#74620E → about 5:1, fine). The current one, in Section 9 at y≈385, is white on bright mustard #BA9907 — roughly **2.4:1**, below even the 3:1 large-text floor. The match you are actually looking at is the one you can't read. The light image does this correctly (near-black text on yellow), so it is a dark-palette-only failure.
>
> **The search-hit ticks are drawn inside the scrollbar thumb.** In the dark image the content scrollbar occupies x=766–771 with the thumb spanning y=278–388, and the three match markers land at y=298–300, 319–321 and 340–342 — inside that same 6px lane. The result is a thumb that looks chopped into four segments rather than a thumb with markers beside it. The markers are also invisible wherever they fall outside the thumb's current position, so the "where are my other hits" affordance only works by accident.
>
> **The find bar can't be operated with the mouse.** The field at y≈88–127 has a magnifier, the query, and a clear X, with "2 of 3" sitting *outside* the field to its right at x≈521. There are no previous/next chevrons, so the only way to reach match 3 is a keyboard shortcut. On macOS the counter also belongs inside the field's trailing edge, not floating beside it as loose grey text.
>
> **Nothing in the window follows the system accent colour.** The find field's focus ring, the selected tree row ("Reading room"), and the selected outline row ("Section 7") are all a fixed purple — #3F0085 in dark, #D8CEFF in light. A Mac user who has set their accent to blue, graphite, or anything else will see none of it here. The focus ring is also a hard 2px stroke rather than the soft system ring.
>
> **"122 lines" is an orphan.** It sits at the bottom-left of the content pane, baseline around y=791 — only 9px off the window's bottom edge, against the same background as the note body, with no divider or status bar behind it, and only about 10px below the last line of prose ("it is read in." at y≈766). It reads as if it were part of the note's text, and as the note scrolls the body text will run straight into it. The left rail's footer, by contrast, *does* get a proper divider at y=743 above "Rescan / Switch Vault" — so the two footers in the same window are built differently.
>
> **The file-tree indentation doesn't survive a glance.** Measuring label left edges in the light image: top-level labels ("Design", "guide", "Sources") start at x=45; nested labels ("notes", "Principles", "Reading list", "Reading room") start at x=59. That is a 14px indent per level — *narrower than the disclosure triangle itself*, which occupies 26→45. The consequence is visible on the `notes` row: its chevron starts at x=43, two pixels left of where its parent "Design" text starts, so a child's triangle sits underneath the parent's label. And "Sources" at x=45 is a root-level item but only 14px left of "Reading room" at x=59, so you genuinely cannot tell whether Sources belongs to `guide` or to the vault root. Finder and Xcode use 16pt per level with the triangle in its own gutter, and they draw indent guides; neither is happening here.
>
> **The top of the window is ragged across the three columns.** First ink per column: sidebar y=8 (card border), content y=19 ("Second Brain"), outline y=47 ("Outline"). Three columns, three different starting heights, no shared toolbar band to align them to. The right panel has 40-odd px of dead space above its header while the middle pane starts almost immediately.
>
> **The window inset is applied on three sides of one panel only.** At y=400 the scan reads: 8px of backdrop, sidebar card 9–246, content 248–779, outline 781–1099. So the sidebar floats as a rounded card with an 8px gutter on its left, top and bottom, but is flush against the content pane on its right, and the content and outline panes run hard to the top, right and bottom window edges. The floating-card treatment either applies to all the panels or to none.
>
> **Two smaller things.** "Rescan" and "Switch Vault" at the sidebar's bottom are bare text with no button shape, spacing, or separator between them — nothing says they're clickable rather than labels. And the note you are reading, "Reading room", appears only inside the breadcrumb at y=61; the window itself is titled nowhere, so there's no document name and no proxy icon to drag or ⌘-click for the path.

## What was fixed

Nothing. Every finding is either already ruled or outside what this task
changed, and the two that are about the yellow are both cases where the
right answer is a ruling and not a patch. This is recorded rather than
acted on so that the readings survive.

## The dark current match, measured

The reviewer's headline finding about this task's own work is exact and
independently arrived at: white text over the dark current match
measures about 2.4:1. BY1.1 measured the same seam at 2.367:1 on the
content plane and 2.012:1 on level 3, and recorded it deliberately:
the coverage is Obsidian's own 70%, not a number tuned to a text floor,
and the marked text is not repainted. So the reading is not news and it
is not a regression — it is the reference's behaviour, arrived at from
the other side by someone who did not know the reference existed.

What the reviewer adds is that a reader notices it, and notices it
precisely on the one match they are standing on. Two answers are open
and neither belongs to this task: lower the current match's coverage in
the dark scheme only, which breaks "one yellow, one dial, both schemes";
or repaint the marked text over the current match, which breaks "the
marked text keeps its colour". Both are owner rulings against the
Obsidian reference, so both go back to the owner.

The light scheme is clean, which the reviewer says plainly: near-black
text over the yellow, 13.470:1 measured.

## What is left, for pooling

- **The marks of the matches share the thumb's lane.** They are painted
  in the track after the thumb, so the thumb reads as segmented where a
  mark crosses it, and a mark under a moved thumb is not separable from
  it. The bar's own contract — the thumb passes under the marks rather
  than over them — is what puts them there. A gutter of their own beside
  the thumb, or marks wider than the thumb, would separate the two.
  Pixels: the lane is x=766–771, thumb y=278–388, marks at y=298–300,
  319–321 and 340–342.
- **No title bar, no traffic lights, no draggable region**, and the
  window carries no document title or proxy icon. Recurs across this
  plan's window reviews.
- **The find field has no previous/next controls**, so stepping matches
  is keyboard-only, and "2 of 3" stands outside the field rather than at
  its trailing edge.
- **Nothing follows the system accent colour**, and the focus ring is a
  hard 2 dp stroke rather than the system's soft ring.
- **"122 lines" stands orphaned** against the note's own surface with no
  seam above it, while the rail's footer in the same window has one.
- **The tree indents 14 px per level, narrower than the disclosure mark
  itself**, so a child's mark sits under its parent's label and a root
  row is not separable from a nested one.
- **The three columns start at three different heights** (y=8, 19, 47)
  with no shared band to align to.
- **The floating-card inset reaches one panel on three sides only**: the
  rail floats with an 8 px gutter left, top and bottom, and the content
  and outline panes run hard to the window's edges.
- **"Rescan" and "Switch Vault" are bare text**, with nothing saying they
  are operable.
