---
date: 2026-09-06
task: BT2.2
phase: BT
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BT2.2 fresh-eyes review — the note column at its measure

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about? It was briefed on the two recorded misreads — dark
grey on a dark ground reading as washed out in a 1x capture, and static
renders holding nothing that only appears while scrolling or hovering —
and told it could measure pixels rather than judge by eye. It measured
almost everything it reported.

## How the captures were taken

**No window was opened.** The screen is locked on this machine —
`CGSessionCopyCurrentDictionary` answers `CGSSessionScreenIsLocked = 1`
and `CGGetActiveDisplayList` counts zero active displays — so a live
window cannot be shown, let alone captured. The six images were rendered
through the same path the goldens use: `renderWindow` from `frame.go`
composed with `windowScene`, drawn headlessly by
`components/golden.Capture` at one pixel per dp, `DeterministicShaper`,
`tokens.Comfortable`, `goldenLeading` for the window-button metric.

| capture | window | scheme | model |
| --- | --- | --- | --- |
| wide-light / wide-dark | 1600×900 | both | `goldenModel()` |
| narrow-light / narrow-dark | 1163×900 | both | `goldenModel()` |
| wide-code-light / wide-code-dark | 1600×900 | both | the same note with a fenced block wider than the measure |

1163 dp is the narrowest window at which the measure still fits: with the
rail standing the note column is `W − 248 − 6 − 320`, its viewport is
that less the page's 24 dp leading inset and the 10 dp the scrollbar
occupies, and 540 dp stops fitting below 1163. A dp narrower and every
block takes what there is instead. The captures are not goldens and were
not committed; the recipe above reproduces them.

## The reviewer's reply, verbatim

I read all six frames and measured the pixels. Findings below; coordinates are in the images' own 1x pixel space.

---

## What a Mac developer would complain about

**1. In the wide window the note is 226px out of line with everything above it.**
In `wide-light.png` / `wide-dark.png`, "Second Brain", the back/forward chevrons, the breadcrumb, the Properties disclosure and the Properties card all start at **x=272**, and the card stretches to **x=1249**. The note itself — H1, both paragraphs, both H2s, both code blocks — sits at **x=498–1037**. Two competing grids in one pane, stacked directly on top of each other with only 22px between the card's bottom edge (y=195) and the H1's cap (y=217). The `narrow-*.png` shots hide this by accident: the content pane there is only 595px wide (248–842), so the fixed 540px reading column lands at x=273 and happens to agree with the chrome. Drag the window wider and the whole document slides right while its own header stays put.

**2. The Properties card is a 978×84 outlined box that is 86% empty.**
Its fill is *exactly* the page fill — (241,241,241) light, (24,24,24) dark, measured at the card centre — so it has no surface of its own, only a 1px border ((182,182,182) light / (71,71,71) dark). No row rules, no key/value column rule (I scanned every column between x=273 and x=1249 for a vertical line; there is none). The content ends at x≈410. So it's a giant hollow rectangle with three short lines huddled in the top-left corner. It reads as an empty text field, not a metadata table.

**3. The code block is clipped mid-glyph while 242px of the pane sit empty next to it.**
`wide-code-light.png` / `wide-code-dark.png`: the block ends at x=1037, the pane runs to x=1279. The line is hard-cut at x≈1024 — through the middle of the `i` in `(string` and the `a` in `ta` — with no ellipsis and no fade. The scrollbar thumb runs x=513–902 inside an inner width of ~512px, so roughly 160px of the line (≈24%) is hidden. There are **242 unused px immediately to its right**, and a 320px panel beyond that. The 540px column never grows, so the app makes you scroll a ~670px line inside a 1600px window. This is the single thing I'd expect a developer to react to first.

**4. There is an 8px dark moat around three sides of the sidebar, and it stops halfway across the window.**
x=0–7 for the full height, plus y=0–7 and y=892–899 across x=0–247, are filled with **(207,207,207)** in light and **(17,17,17)** in dark. That is darker than the sidebar (227/21), the content pane (241/24) and the right panel (227/21) — it is the darkest surface in the window, and it exists only on the sidebar's left, top and bottom. On the right the sidebar's 1px border sits at x=247 with the content pane starting at x=248: **zero gap**. Because the card is a rounded rect, its top-right and bottom-right corners bite a wedge of content-pane grey out of the sidebar (visible at y=8–15 and y=885–891). The top strip just terminates at x=248 mid-window. It reads as an unpainted window edge rather than a design.

**5. Code comments genuinely fail contrast — and light mode is the worse one.**
I checked this against your recorded misread, and it goes the other way. The comment colour is a flat modal fill, not antialiasing (146 identical pixels light, 176 dark):

| | ink | ground | ratio |
|---|---|---|---|
| light | (156,160,176) | (239,241,245) | **2.30:1** |
| dark | (108,112,134) | (30,30,46) | **3.36:1** |

Both are below AA 4.5:1, and the light-mode comments in `wide-light.png` / `narrow-light.png` (y=672–706) are the least readable thing in the window.

For the record, everything else I sampled is fine and I am *not* reporting it: dark-mode "Outline"/"Backlinks"/"No notes link here" measure 6.57:1, "29 lines" 11.06:1, property keys 10.17:1, body text 15.30:1. Nothing in dark mode is washed out. Syntax colours are 4.34–4.80:1 in light and 7.08–11.34:1 in dark.

**6. The link underline is drawn through the descenders.**
`wide-light.png`, "the principles": baseline ≈ y=277, underline at **y=279**, and the `p` descender continues to y=281. The rule cuts straight through it — no descender skip, and only ~2px below baseline. Same in all six frames.

**7. The note title and the section headings are 2px apart.**
Measured on flat-topped caps: `R` of the H1 "Reading list" = **19px** cap (y=218–236); `A` of the H2 "A sample" = **17px** cap (y=548–564). Same weight, same colour. Body cap is 12px. So title→heading is a 12% step while heading→body is 42%. In `wide-light.png` the H1 does not read as the document's title; it reads as a third peer heading.

**8. The right panel is 320px of mostly nothing, and it never gives width back.**
The Outline's last entry ends at y=168; the Backlinks rule is at y=783 — **615px of empty panel** between them, with Backlinks holding a single line. The panel is 319px wide in both the 1600px and the 1163px window. At 1163 that is 27% of the width, which squeezes the content pane to 595px while the reading column stays 540 — so in `narrow-light.png` the text sits 25px from one pane edge and 30px from the other while the panel beside it holds four lines of text.

**9. Nothing about it reads as Cocoa.**
- **Typeface**: the letterforms in "Second Brain", "guide", "Reading list" are a Roboto/Go-style grotesque, not San Francisco. On a Mac the whole window reads as a web or Android app.
- **Selection**: light mode is a pale lavender fill `#D8CEFF` with near-black text; dark mode is a saturated `#3F0085` with white text. Two different idioms for the same state, and neither follows the System Settings accent colour. It's also the only saturated colour in an otherwise strictly neutral UI.
- **Code palette**: fill `#EFF1F5` light / `#1E1E2E` dark with Catppuccin-style syntax colours — a blue-violet panel imported into a neutral grey app. In dark, the `#1E1E2E` patch visibly reads purple against the `#181818` page.
- **Scrollbar**: capsule ends (good), but 6px, fully opaque (92,92,92) light / (204,204,204) dark, sitting 1px above the block's border with no inset — heavier and tighter to the edge than the macOS overlay thumb, which is translucent and inset.
- **No title bar or traffic lights** appear in any of the six frames.

**10. In light mode the code block has no fill at all.**
`#EFF1F5` against the page's `#F1F1F1` is **1.005:1**. The block is defined purely by its 1px `#797979` border — which is darker than every other border in the app (Properties card `#B6B6B6`, panel dividers `#D4D4D4`). The consequence in `wide-light.png`: the first block, y=587–629, containing only the word `code`, is indistinguishable from a text input. I initially read it as one.

---

## Smaller things

- **Sidebar tree has no icons.** Folders and notes differ only by the presence of a chevron. Measured label positions: `Design` 45, `notes` 59, `Principles` 59, `guide` 44, `Reading list` 59, `Sources` 44 — the indentation is internally consistent (Finder-like), but with no folder/document icons and no indent guides, "Sources" at depth 1 and "guide" at depth 1 are visually the same kind of thing.
- **The two side panels use different type sizes for the same kind of list.** The identical string "Reading list" is 70px wide with a 10px cap in the sidebar and **62px wide with an 8px cap** in the outline — yet both sit in a 32px pill on a 36px row pitch.
- **Footer buttons are bare text.** "Rescan" (x=25–69) and "Switch Vault" (x=91–168) render at the same weight and colour as the tree items — (19,19,19) on (227,227,227) — below a 1px rule at y=843. Nothing says they are pressable.
- **Everything is 6px left of optical centre.** Content pane padding is 24px left (248→272) and 30px right (1249→1279); the outline pill is inset 15px from the divider and 22px from the window edge. Presumably a reserved scrollbar gutter, but the effect is that no full-width element is actually centred.
- **"29 lines"** sits 7px from the window bottom (ink y=883–892, window ends at 899), with no separator, spanning the content pane only.
- **"Reading list" is on screen four times at once** — sidebar selection, breadcrumb tail, H1, outline first entry. Combined with the Properties card, the note's first word in `wide-light.png` starts at y=217: 24% of the window height is chrome before any content.

## What was done with it

**Nothing was fixed in this task.** Finding 1 is the only one this task
caused, and it is a design question rather than a slip: which rows of the
note page belong to the document and which to the window. The reference
reading surface answers it one way — its head row stands at the window's
top-left, outside the column, while its properties table sits inside the
column with the prose — and adopting that answer means the page's own
rows learn the measure, which is a task's worth of work and duplicates
arithmetic that belongs in `markdown` rather than in an application.
Pooled, flagged as caused here.

Finding 3 is ruled behaviour and is not a defect: wide content that keeps
its own size sits in a scroll area no wider than the measure, and a code
block therefore scrolls inside the measure however wide the window is.
The reviewer had not been told this, which is the point of a fresh pair
of eyes, and its reaction is worth keeping as evidence of how the ruling
reads to somebody meeting it cold. The sub-observation inside it is not
covered by the ruling and is pooled: the line is cut mid-glyph with
nothing marking the cut.

Findings 5 and 10 confirm S7's carried finding — the fenced block wears
the highlighter's own palette rather than this system's — with fresh
numbers on the current build, and the light appearance is the worse of
the two. Findings 2, 4, 6, 7, 8, 9 and the smaller things are
pre-existing and untouched by this task. All of it is pooled.

## What the review confirms about the measure itself

Read off `wide-dark.png` at 1600×900, one pixel per dp:

| measure | value |
| --- | --- |
| every top-level block's width | 540 dp, x 498–1037 |
| the region between the rail pane and the trailing column | 1032 dp, x 248–1279 |
| the column's leading margin | 250 dp |
| the column's trailing margin | 242 dp |
| the column's centre against the region's | 4 dp toward the trailing edge |

The 8 dp between the two margins is a constant at every width where the
measure applies, and it is arithmetic rather than accident:
`noteInsetDp − scrollbarWidth − frameSplitterDp` = 24 − 10 − 6. The
scrollbar occupies its own width out of the viewport's trailing edge
before the document is handed what is left, so the run of blocks centres
in a span already short at one end. The reviewer found the same
asymmetry independently and from the other side, measuring the page's own
rows at 24 dp leading and 30 dp trailing.
