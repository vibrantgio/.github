---
date: 2026-09-06
task: BR4.2
phase: BR
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BR4.2 fresh-eyes review — the search field and its matches in vaultview

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer on this platform
complain about? It was handed two images and nothing else — the whole
vaultview window at 1100x800 in each scheme, offscreen renders at 1 px
per dp, on the frame where a query has been typed into the rail's search
field and the rail is showing its matches. The dispatch passed an opus
model override; no effort setting was recorded. It was told to sample
pixels before making any claim about a colour, a size or an alignment,
and briefed on five recorded misreads — dark foreground reading grey at
1x, a whisper step reading as none, chrome regions sharing one fill by
design, a light card being white on off-white by ruling, and the rail's
hairline being deliberate. It reported none of the five.

The task's own subject is finding 3, and finding 1 of the "what's fine"
list. Everything else is the window around the search, which the
reviewer was free to look at and did.

## The reply, verbatim

Both images read, all values below sampled with PIL from the PNGs.

## What a developer would complain about

**1. Code-comment text in the light theme is 2.30:1.** The two comment lines in the fenced block at y≈672–710 are `(156,160,176)` on `(239,241,245)` — 2.30:1, well under AA for ~13px monospace. Those lines carry the note's actual explanation ("A wikilink inside code is a code sample, not navigable"), so the sentence that matters most is the least readable thing in the window. Dark is `(108,112,134)` on `(30,30,46)` = 3.36:1, also under 4.5:1.

**2. The selected-row indicator has almost no luminance separation in either theme.** Sidebar row "Reading list" and outline row "Reading list" both fill with `(216,206,255)` on panel `(227,227,227)` = **1.15:1** (light) and `(63,0,133)` on `(21,21,21)` = **1.35:1** (dark). This is the app's primary state signal and it is carried by hue alone; desaturate either screenshot and the selection disappears. The text on the fill is fine (12.6:1 / 11.7:1) — it's the block itself that doesn't separate.

**3. The dark search-match highlight is the light one multiplied by 0.392.** Light `(199,185,0)`, dark `(78,72,0)` — 199×0.392=78.0, 185×0.392=72.5. It isn't a designed dark counterpart, it's the same swatch dimmed. Result: 1.96:1 against the rail panel, and **1.45:1** against the selected row's purple, so the match inside "Read**in**g list" is a muddy olive smudge rather than a highlight. Light gets a bright patch; dark gets a hole.

**4. Nothing in the window shows keyboard focus.** The reader has just typed "in", yet columns x=68–110 inside the field (y 58–86) contain zero non-background pixels — no caret — and there is not one chromatic pixel anywhere in the field's interior in either theme. The field's border is `(121,121,121)`/`(109,109,109)`, identical to the inert code block's border below it.

**5. The code surfaces are a foreign palette bolted onto a strictly neutral theme.** Every other surface is pure grey (`241/227/207`, `24/21/17`); the code fills are `(239,241,245)` and `(30,30,46)` — Catppuccin Latte and Mocha base, exactly, confirmed by `func` = `(210,16,57)` (#d20f39) light and `(243,139,168)` (#f38ba8) dark. Consequences: in light the code fill is **1.001:1** against the page, so the block reads as a bare outline with no fill at all; in dark it's 1.08:1 with a +16 blue cast that visibly clashes against the neutral chrome. The two themes' code blocks don't look like the same component.

**6. Two scrollbars, two unrelated styles, inverting in opposite directions.** Main vertical thumb: `(137,137,137)` light / `(135,135,135)` dark — a delta of 2 while the surface under it goes 241→24, so it's effectively theme-invariant (3.10:1 light, 4.94:1 dark). Code-block horizontal thumb: `(92,92,92)` light / `(204,204,204)` dark — 5.91:1 and **10.21:1**, making it the brightest object in the dark code block, louder than the code. Same widget, 6px in both cases, four unrelated greys.

**7. The main vertical scrollbar is drawn permanently and at full length with nothing to scroll.** Thumb spans y=198–744 at x=766–771; the content visibly ends at the code block's bottom border at y=739, and the status bar says "29 lines" with all three outline headings on screen. No track is painted — it's a bare floating capsule occupying a column for no information. macOS overlay scrollbars would not be sitting there.

**8. The dark theme's text hierarchy collapses, and the muted token isn't the same in both panes.** Primary/secondary separation is 2.78:1 in light (19 vs 92) but **1.38:1** in dark (238 vs 204) — "Properties", the breadcrumb ancestor, the property keys and the status bar barely read as de-emphasised. Worse, light collapses every muted role onto one grey `(92,92,92)`, while dark splits the same roles into two: `(204,204,204)` in the content pane and `(155,155,155)` in the right panel. "Properties" and "Outline" are the same role and get the same grey in light and different greys in dark.

**9. The nav arrows.** Disabled forward chevron is `(212,212,212)` on `(241,241,241)` = 1.31:1 light, `(46,46,46)` on `(24,24,24)` = 1.31:1 dark — you cannot tell there is a forward button. And the *enabled* Back arrow (`(122,122,122)`, 3.80:1 light) is dimmer than the purely decorative breadcrumb separator `▸` beside it (`(92,92,92)`, 5.92:1): the clickable thing is quieter than the punctuation.

**10. The 8px window-backdrop gutter wraps only the left rail.** Backdrop `(207,207,207)`/`(17,17,17)` occupies x=0–7 full height, and y=0–7 and y=792–799 for x=0–247 only. The content pane (x=248–779) and right panel (x=781–1099) are flush to the window edges. So the window has an inset card on one side and full-bleed panels on the other two. Separately, that gutter is clearly visible in light (1.21:1 against the rail) and invisible in dark (1.03:1) — the deliberate frame simply doesn't exist in the dark appearance. (I'm not flagging the rail's hairline itself.)

**11. Border weight doesn't track interactivity.** Three border tokens on one screen: `121`/`109` on the search field, the inline-code box and the code block; `182`/`71` on the properties card; `186`/`54` on the rail card. The 121 hairline is 3.35:1 against its own fill, roughly twice the properties card's 1.56:1 — so the inert code block is the most strongly outlined element in the window, and a text field you can type into wears exactly the same outline as a block you can't.

**12. The code block's padding is lopsided and the horizontal scrollbar is laid inside it.** Block 2: text starts x=285 (13px left inset), clips at x=725 with 23px to the border at 748, top inset 17px, and the h-scrollbar occupies y=731–736 — 5px below the last glyph and only **2px** off the bottom border. Block 1 directly above ("code") has 16/17px top and bottom insets. Two adjacent code blocks with visibly unequal internal padding because the scrollbar was reserved inside rather than overlaid.

**13. Two divider conventions and asymmetric panel insets.** The rail footer divider runs full-bleed x=9–246; the Backlinks divider is inset, x=796–1077, inside a panel spanning x=781–1099 — 16px of inset on the left, 22px on the right. The content pane repeats the imbalance: content x=272–749 in a pane x=248–779, so 24px left, 30px right.

## What's fine

- **Search-match highlight alignment is correct**, despite looking off at 1x. In "Principles" the ink for "in" is x=58–67 and the highlight box is x=58–68; in "Reading" the ink is x=76–85 and the box is x=76–86. One pixel of bleed, no offset.
- **The "guide" tag on the selected row is not too faint** — it looks it at 1x, but it measures `(97,96,100)` on `(216,206,255)` = 4.22:1 light and `(202,202,203)` on `(63,0,133)` = 8.27:1 dark.
- **Body, heading and link contrast are strong throughout** — body 16.45:1 / 15.30:1, links `(114,58,212)` 5.68:1 and `(208,196,255)` 11.01:1, both properly underlined.
- **Geometry is pixel-identical between the two appearances** — every boundary I scanned (rail 8/247, divider 780, selected row 16–239 × 138–169, code block 272–749 × 658–738) lands on the same coordinate in both. No layout shift across themes.
- Row insets inside the rail card are symmetric (7px each side), and the elevation order is consistent in both themes (backdrop < rail/panel < content).

## Triage

**Fixed in this task: nothing.** Nothing the reviewer found is both in
BR4.2's scope and wrong.

**Finding 3 — measured right, judged against a floor the highlighter
does not answer to.** The arithmetic is correct: the dark fill is the
light fill at the yellow ramp's deeper step, which is what a ramp is.
What it is held to is `tokens.ContainerFloor`, 1.2 — the highlighter has
to be *visibly a different surface* from the one it marks, not a
graphic answering 3:1, because it lies under body text that must go on
clearing `TextFloor` over it. Measured here:

| scheme | marked surface | highlight | ratio | body text over it |
|---|---|---|---|---|
| light | rail, chrome level | `#c7b900` | 1.58 | — |
| light | selected row, Primary 300 | `#c7b900` | 1.37 | 9.17 |
| dark | rail, chrome level | `#4e4800` | 1.96 | — |
| dark | selected row, Primary 300 | `#4e4800` | 1.45 | 8.04 |

Every case clears the floor, and the dark rail case (1.96) separates
*more* than the light one (1.58) — the opposite of "light gets a bright
patch, dark gets a hole". The reviewer read saturation as separation.
Changing the number is a ruling on `HighlightOn` in `theme`, out of this
task and not a defect at the ruled floor.

**Finding 4 is an artefact of the capture, not the window.** The images
are static renders of the whole window; the static path draws no editor
and therefore no caret, and no focus ring, because nothing in an
offscreen render holds focus. The live field's focus ring and caret are
the text field's own, unchanged by this task and covered by
`searchfield-*-focused` in `components/input/testdata/golden`.

**Pooled, not fixed.** Findings 1, 2, 5, 6, 7, 8, 9, 10, 11, 12 and 13
are all pre-existing and outside a task about a search field: the
markdown code block's third-party palette and its padding (1, 5, 12),
the selection pill's luminance (2), the scrollbars (6, 7), the dark
scheme's muted-text collapse (8), the navigation chevrons (9), the
window's backdrop gutter (10), the border tokens (11) and the divider
conventions (13). Findings 2, 8 and 9 are the ones with an
accessibility number behind them and are worth a pool item each.

One seed the review's own subject suggests: the highlighter's floor
over a *filled* row. It clears the floor it is held to, but at 1.37–1.45
on a Primary-300 pill a reader scanning matches down a filtered list
loses the mark on exactly the row they are standing on. Whether the
highlighter should answer to more than "visibly another surface" when
what it marks is itself a fill is a question for `theme`.
