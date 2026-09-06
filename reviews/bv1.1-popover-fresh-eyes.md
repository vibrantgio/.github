---
date: 2026-09-06
task: BV1.1
phase: BV
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BV1.1 fresh-eyes review — the Share popover over the detail column

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about? It was briefed on the two recorded misreads — dark
grey on a dark ground reading as washed out in a 1x capture, and a
static render holding nothing that only appears on hover, scroll, focus
or drag — and told it could measure pixels rather than judge by eye.

## How the captures were taken

**No window was opened.** The screen is locked on this machine. The four
frames were rendered through the same path feeds' window goldens use:
`buildLayers` composed over a frozen theme by `windowFrame` in
`workbench/feeds/window_render_test.go`, drawn headlessly by
`components/golden.Capture` at one pixel per dp, `DeterministicShaper`,
`tokens.Comfortable`, at the 1200×800 window `main.go` opens. Two frames
were drawn and the second kept, so the pointer and click tags the layout
tree needs are registered before anything reports state.

The state was set on the model rather than faked in the view:
`shareOpen` true over `initialModel()` (no article chosen, the detail
column showing "Select an article") and over `settledModel()` (the first
row open in the reading pane), each in `tokens.DefaultLight` and
`tokens.DefaultDark`.

- `/tmp/bv11/after/feeds-share-empty-light.png`
- `/tmp/bv11/after/feeds-share-article-light.png`
- `/tmp/bv11/after/feeds-share-empty-dark.png`
- `/tmp/bv11/after/feeds-share-article-dark.png`

The same four frames rendered against the pre-fix `patterns/popover`
(`/tmp/bv11/before/`) differ from all four: before the deferral the
Share surface was covered by the detail column, leaving only the tail
and eleven rows of the surface's top edge visible under the navigation
bar: down the surface's midline at x=1100 the fill runs white from y=41
to y=51 and the detail column's own 241 takes over at y=52. In the
fixed frame the same column is the surface's fill from y=41 down to
y=150, broken only by the "Email" label's glyph rows. A hundred rows of
the surface were being painted over. That is the defect Rene reported,
and it is what these frames were taken to check is gone.

## The reviewer's reply, verbatim

I measured all four PNGs with PIL rather than eyeballing. Findings, worst first.

**1. The Share menu casts no shadow, and it decapitates the headline.** In `feeds-share-article-light.png` the menu's left border lands at x=1030, and the final "s" of "Go 1.26 Release Notes" is sliced vertically down its middle — ink continues right up to x=1029 and stops dead. I cropped and upscaled it to confirm: it is a half-letter, not a rendered ellipsis. Normally that would be forgivable, because a macOS menu announces itself as an overlay with a large soft shadow. This one has none. I scanned outward from every edge: at y=100 the pixels go `...241, 241, 193, 203, 255...` on the left and `255, 203, 193, 241, 241...` on the right; below the menu, `255, 203, 193, 241, 241` at y=150–153. Immediately outside a hard 2px stroke is the flat page background, zero falloff. The menu fill is 255 on a 241 pane — 1.13:1 — so in light mode the popup's *only* separation from the window is a 1.59:1 hairline. The result is that the chopped "s" reads as a text-rendering bug rather than as something covering it. Dark mode fares better (menu 71 on 24 = 1.91:1) but still has no shadow.

**2. It is a centered callout with a beak, and the beak is malformed.** The menu spans x=1030–1175, centered on 1102.5, which is exactly the center of the "Share" label (1085–1120). macOS pull-down menus are edge-aligned to their button and never have a pointer — a centered popover with a tail is the iOS/web idiom, and it is what forces the menu inboard over the headline in the first place. Worse, the beak is drawn badly. At its junction (y=43) the row reads `184, 184, ..., 171, 131, 242, 255...` — the beak's leg strokes are value 131 while the menu's own top border is 184–203. The legs are ~50 levels darker than the border they join, leaving two dark pips at x=1097 and x=1108. And the apex at y=37 is a flat 4px cap, not a point. At 1x it looks like the popup has two specks of dirt and a chipped tip. Separately, the "Share" button shows no open state: I sampled behind it and it is plain 227 (light) / 21 (dark), pixel-identical treatment to the idle "Add feed". A menu is up; its trigger should be drawn active. That is an open state, not a hover state.

**3. The sidebar tree is outdented and its separators are on the wrong side.** Group header "Tech" starts at x=32; its children "Go Blog", "Hacker News", "Lobste.rs" start at x=24–25. The children sit 7–8px *left* of their parent. Then the rules: hairlines at y=99, y=243, y=291, all full-bleed x=0–191. y=99 falls between the "Tech" label (y 69–80) and its own first item (y 109–120) — it cuts the group header off from the feeds it owns. The boundary that actually needs a rule, Lobste.rs (ends y=174) → News (starts y=214), has none. And y=291 is a dangling rule under "Personal" with ~500px of empty sidebar below it. The type hierarchy is inverted too: group labels are 12px cap-height at ink 19, the clickable feeds are 10px at ink ~75 — the non-interactive labels are the loudest thing in the pane. The disclosure markers are 10×10 solid black triangles, the heaviest marks in the sidebar; macOS uses small grey chevrons.

**4. Unread state is a 3×4 pixel dot and nothing else.** The dots at rows 1, 2 and 4 measure x=697–699, y=171–174. I compared the "The Go Team" cell of an unread row against a read one: ink sum 35631 vs 35631, dark pixel count 160 vs 160 — pixel-identical. So the entire read/unread signal is a period-sized *neutral* mark (not the accent color), in a column 90px wide (690–780) whose header is a literal "•" bullet at x=697. A bullet as a column title is not a label, and at 1x I could not tell which rows were unread until I measured.

**5. Column widths are backwards.** Titles are clipped at ~x=380 — seven of ten rows end in "…" — while the Author column runs 396 to ~550 to hold the identical string "The Go Team" (81px used, ~80px wasted) ten times, and the unread column burns 90px on a 3px dot. Roughly 170px of the 572px table is spent on redundancy and air while the only column with unique content is the one being truncated.

**6. Bottom-of-list pagination in a desktop reader, built from two mismatched control idioms.** Numbered page chips "1 2" (36×36 rounded fills) flanked by bare 10×20 triangles with no button chrome at all. Ten articles per page with a page-2 button is a website pattern; a Mac reader scrolls. The triangles are also below any reasonable click target and give no affordance that they're pressable. The disabled treatment is inconsistent between schemes: the disabled prev arrow is 195 on 241 = **1.56:1** in light, but 156 on 24 = **6.47:1** in dark. Same control, nearly invisible in one scheme and nearly full-strength in the other.

**7. The detail pane has a ragged left edge.** Title starts at x=814, byline at x=813, tab strip and its divider at x=813 — but every line of body text starts at x=829. A 16px step that runs the full height of the pane, with no rule or rhythm to justify it.

**8. Underline tabs, and the active tab is only a 2px line.** Reader/Raw/Comments with a purple bar at y=162–163 spanning x=813–881 is Material; macOS uses a segmented control here. Worse, I sampled the labels: active "Reader" darkest pixel is `[19,19,19]`, inactive "Raw" darkest pixel is `[19,19,19]`. Identical. The selected state hangs entirely on a 2px underline.

**9. In dark mode, two of the three pane boundaries are effectively invisible.** Sidebar 21 vs content 24 = **1.028:1**; toolbar 21 vs content 24 = 1.028:1 — and neither gets a hairline (I scanned x=186–200 at y=400 and y=46–56 at five x positions; it's a bare fill step). Yet the list/detail split at x=796 *does* get a hairline (46 on 24). Same window, same kind of boundary, two different treatments. In light the same steps are 1.136:1, also weak but at least perceptible. This is a structural inconsistency, not the dark-ink misread — the fills are three levels apart.

**10. Toolbar spacing has no discipline.** "Add feed" occupies x=959–1014, "Share" x=1085–1120: a 71px gap between two adjacent toolbar buttons, and an 80px trailing margin to the window edge — against a 16px inset used everywhere else (table 208/780, detail pane 813/1183, sidebar pill 16/175). It looks like fixed equal-width cells with centered labels, and it reads as two unrelated links stranded in whitespace.

**11. The menu itself is oversized for macOS.** "Email" cap height measures 12px (≈16–17px type); a native menu is 13pt, ≈9.3px cap. Item pitch is 28px against macOS's 22. Padding above the first item is 18px and below the last is 20px, against ~5. Text inset is 11px from the interior edge, so there is no state column for checkmarks. No keyboard equivalents, no icons.

**Minor:** every table row gets a full-width 212-grey rule (macOS tables use alternating fills or nothing); the header band is *lighter* (255) than the rows it heads (241), which inverts the usual weighting; the filter field is 40px tall — taller than a table row — with a heavy 121-grey border, no magnifier glyph, and says "Filter articles" where a Mac says "Search"; and the accent is a hardcoded purple (114,58,212) rather than the user's system accent.

**What is right, and I checked specifically:** contrast is not a defect anywhere I measured, in either scheme — secondary text is 92 on 241 = 5.9:1 light and 204 on 24 = 11.0:1 dark, primary is 15.3:1 dark, and both page buttons clear AA at 4.51 and 4.54:1. The earlier "dark ink looks washed out" trap does not apply here; the dark scheme measures well. The empty state is genuinely centered (text center 997.5/425 against pane center 998.5/426). The sidebar selection pill is a 24px rounded rect in a 28px row inset 16px on both sides — that is exactly the macOS 11+ sidebar. The toolbar is 52px and shares the sidebar's fill, which is the correct unified look, and the first 192px of it is left empty, so there is room for the traffic lights. Surface elevation is directionally consistent across schemes (filter field and table header both lift above the pane: +14 light, +10 dark). And the grid alignment within each pane is clean — filter field, header, rows and rules all share the 208/780 column, and the tab strip, its divider and the byline all share 813/1183.

## What was done with it

Nothing was changed in this task. The reviewer's first finding is the
deferral working — the menu now covers the headline, which is what a
floating surface does — and its complaint is that the surface announces
that with nothing but a hairline. That is the popover's stated separation
contract (level 3, fill plus a 1 dp stroke, no shadow), so it is a
decision rather than a defect, and it is pooled rather than patched here.
The tail's own drawing faults (legs ~50 levels darker than the border
they join, a flat 4 px apex) are in `drawTail`, which BV1.1 was told to
leave alone; they are pooled with the rest. Findings 3 through 11 are
about the window this popover happens to open over and reach well past
the popover.

The four frames plus the pre-fix pair are under `/tmp/bv11/`; they are
not stored, since feeds' own goldens hold no popover-open frame.
