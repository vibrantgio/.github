---
date: 2026-09-03
task: BR1.1
phase: BR
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BR1.1 fresh-eyes review — the three-column frame with chrome and content parted

Two images, both offscreen renders at 1 px per dp, no application launched:
the regenerated patterns tiles
`components/gallery/testdata/golden/patterns-{light,dark}-1.png`, whose
lower half is the "Shell — the three-column frame: sidebar, content, aside"
specimen. This is the one composition BR1.1 moved pixels in: chrome now
stands at its own level and `patterns/shell`'s three-column frame fills its
content region at level 0 and its footer strip at the chrome level, where
before the whole frame was one flat fill.

The reviewer saw neither the packet nor the plan, was given no checklist,
and was asked one question: what would a developer who builds native
desktop applications on macOS complain about?

## What came back, verbatim

**1. In dark mode the window and its three columns are invisible.** Shell
fill is `#151515` sitting on a page of `#181818` — the "window" is *darker*
than what surrounds it, with no border and no shadow, so its edge is a
1.02:1 step. Inside, the sidebar (`#151515`), content pane (`#181818`) and
aside (`#151515`) differ by 3/255. There is no separator anywhere. The only
vertical line in the entire layout is the scrollbar at x=558. A native
window in dark mode gives the sidebar a distinct material (visibly lighter
than the `#1E1E1E`-class content area), draws a 1px split divider, and
separates the window from the desktop with a border and shadow. Light mode
is barely better: `#E8E8E8` sidebar vs `#F6F6F6` content is 1.14:1, under
the 3:1 non-text floor.

**2. A permanent, full-height scrollbar with nothing to scroll.** The bar at
x=558–563, y=517–716 spans 100% of the pane height — the thumb equals the
track, meaning the content fits. macOS overlay scrollers are not drawn at
all when content fits, appear only during scroll or on hover, are rounded at
both ends, and are inset from the edge. This one is 6px wide, square-ended,
flush against the pane, and always on. Worse, it is doing the split
divider's job: when a real macOS overlay scroller fades out, this layout
loses its only structural line.

**3. The content pane is a floating rectangle that doesn't reach the
window's edges.** It runs x 216–557, y 517–716 inside a shell that ends at
y=764 and x=743. That leaves a 48px band of sidebar-coloured dead space
under it, with the footer label stranded in the middle of it, and it stops
186px short of the trailing edge. A native split view fills to the bottom
and trailing edges of the window; the dividers run floor to ceiling. This
reads as a card dropped on a page, not as a window's content view.

**4. The sidebar selection is a full-bleed square band.** y 553–588 (36px
tall), running x=24 to x=215 — hard into the window's left edge, zero corner
radius. macOS sidebar selection is a rounded rect (~6pt) inset from both
edges of the sidebar, roughly 24–28pt tall. Dark mode compounds it: the fill
is `#5C15B7`, a saturated purple that is not the user's system accent and
does not desaturate for the non-key window state.

**5. The toolbar is a web navbar.** Brand text left, three centred labels
with a 2px underline under "Gallery" (x 287–354, y 509–510), a grey "v1"
pill right. macOS puts view switchers in an `NSSegmentedControl` in the
toolbar; the underline-tab indicator is a browser idiom. There is also no
toolbar bottom edge: at y=512 the row is uniform fill across the whole
width, so the "toolbar" only appears bounded across the middle third where
the content pane happens to start. Native toolbars gain a full-width
hairline the moment content sits under them.

**6. The tab group is off-centre by 18px.** It spans x 299–504, centre
401.5; the window centre is 383.5. It has been centred in the leftover space
between the brand (ends x=103) and the badge (starts x=699), which is what a
flexbox row does, not what a toolbar does. macOS centres centred toolbar
items on the window and lets the side items collide/truncate.

**7. Square window corners.** I probed rows 465–468 and 760–764 at x=23–28
and 741–744: the fill goes edge to edge with no antialiasing at any corner.
Radius is exactly 0. macOS windows have ~10pt rounded corners; a specimen
claiming to "frame a window" with 90° corners reads as a `<div>`.

**8. The sidebar toggle icon floats, centred, above the list.** 16×14px at
x 112–127, dead-centred in the 24–215 sidebar column, unlabelled, with
nothing else on its row. macOS puts the sidebar toggle in the toolbar at the
leading edge, left of the title. Centred over the list it looks like a stray
glyph.

**9. The aside is 4px out of alignment with the content, and its gutter is
wrong.** "Aside" cap-band is y 532–542; "The main column." is y 536–546.
Same offset repeats in the body (574 vs 578). The two columns' first lines
should share a baseline. Its text also starts at x=576, only 6px from the
aside's leading edge (12px from the scrollbar), against the content pane's
16px inset — three columns, three different gutters.

**10. The footer is not a status bar.** "Footer — status and counts" is
`#808080` text at x=41, y 727–735, on the same fill as everything else, with
no top separator, no distinct material, and not vertically centred in its
strip (11px above, 29px below). macOS status bars are full-width, have a
hairline top separator and a distinct background, and their content is
centred in the bar.

**11. Sidebar rows are Slack/Notion, not macOS.** 36px row pitch with 16px
solid colour circles at x 40–55. macOS sidebar rows are shorter and use
monochrome template SF Symbols tinted by state, not saturated filled dots as
the primary item glyph.

**12. The item colours change identity between appearances, and two of them
collide in dark.** Light: `#723AD4`, `#625886`, `#914567`, `#006B24`. Dark:
`#D0C4FF`, `#D0C5FA`, `#FFB8D4`, `#77E387`. The first two dots are
distinguishable in light (violet vs muted slate) and effectively identical
in dark — 1 and 5 units apart in G and B. `#914567` maroon becomes `#FFB8D4`
pink; `#006B24` bottle green becomes `#77E387` mint. System colours shift
subtly between appearances and never converge to the point where two
adjacent list items stop being tellable apart.

**13. The body text is hard-wrapped and doesn't use its column.** The
paragraph's longest line ends at x=442 inside a pane whose text area runs to
x≈541 — 100px of unused measure, with breaks at fixed points rather than
flowing to the column width. Resize the window and this will not reflow the
way any native text view does.

**14. Nothing indicates the panes are resizable.** No divider hit-target, no
drag affordance between sidebar/content or content/aside. A macOS
three-column window is an `NSSplitViewController` where every divider is
draggable and the sidebar collapses.

## What was done about it

Nothing was cheap and in scope for this task, so nothing was changed on the
strength of the review. What each item is:

**Misreads, recorded so the next reviewer's version of them is recognised.**

- **1's "no separator anywhere" and 2's "scrollbar" are the same object.**
  The vertical line at x=558 is the three-column frame's own divider,
  `drawThreeColumn`'s `dividerColor` fill between the content and the aside,
  drawn full height between the navbar's foot and the footer. It is one
  device-pixel of `Divider`, not an overlay scroller, and it does not fade.
  The reviewer's complaint that "when a real overlay scroller fades out this
  layout loses its only structural line" therefore does not apply to it.
- **3's "48px band of sidebar-coloured dead space under it" is the footer
  strip**, and "stops 186px short of the trailing edge" is the aside. Both
  are chrome, and chrome is one fill, so a reader who has not been told the
  aside is an inspector reads the whole trailing region as unfilled. That
  the aside and the footer and the sidebar are the same colour is the model
  working, not a defect — but it is also why this composition needs its
  divider work (below) to be legible.
- **1's dark-scheme reading is the measured platform whisper**, not a
  regression. 1.48 L\* between the chrome level and the content is what
  three dark macOS references measure, and the system's answer to it is the
  derived hairline, which this specimen has only between content and aside.
  The recorded false positive stands: a whisper step read off a 1x capture
  looks like no step at all.

**Genuine, out of scope here, and worth a plan item.**

- **No divider between the sidebar and the content** (1, 14). The
  three-column frame draws one only on the aside side. A leading divider,
  and drag affordances on both, are `patterns/shell` work.
- **The permanent, square-ended, flush scrollbar** (2). `components/
  scrollbar` behaviour, not elevation.
- **The footer is not a status bar** (10): no hairline over it, its label
  not centred in the strip. BR1.1 gave the strip its own chrome fill; the
  separator and the centring are the next step on the same region.
- **No toolbar hairline under the navbar** (5). Now that the content region
  below it is a different fill, the navbar's foot is a colour step across
  the middle third and nothing at all across the sidebar and aside.
- **Square window corners** (7) and the sidebar's full-bleed square
  selection (4).

**Specimen-level, not system-level** (6, 8, 9, 11, 12, 13): the gallery's
own navbar props, its sidebar item dots, its hard-wrapped prose and its
aside insets. Item 12 — two of the four dots converging in the dark scheme —
is the one of these worth carrying forward as a real question about the
specimen's chosen swatches.
