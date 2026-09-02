---
date: 2026-09-02
task: BQ1.2
phase: BQ
reviewer-model: Opus 5
reviewer-effort: unrecorded
---

# BQ1.2 fresh-eyes review — the reserved highlighter on the palette board

## What the reviewer was given

Two images and nothing about the task: the themer's palette section rendered
offscreen at 1400x1120, light and dark, each carrying both halves of the page
(the ramps grid above, the picks board below). The images came from
`TestPaletteSectionDump`, so no window was opened on the owner's screen.

It was told what the two sections are, that PIL was available for sampling,
and one recorded misread — dark ink can read as grey at 1x in these captures.
It was given one question, no checklist: what would a developer on this
platform complain about.

## Verbatim reply

> Read both images, then sampled with PIL. All colours below are dominant-fill samples (mode over a 40x20 window inside each cell/chip), contrasts are WCAG ratios, ΔE is CIE76 in Lab.
>
> ## Findings, most serious first
>
> **1. In the dark scheme, Primary and Secondary are the same colour.**
> Dark Primary chip (24–68, 787–819) = `b0cdff`; Secondary chip (24–68, 849–881) = `b2cdfd`. ΔE 1.17 — below the just-noticeable difference for flat areas. In the ramp, dark Primary 800 and Secondary 800 (x 1060–1180, y=81 vs y=105) are **byte-identical** `c2d8ff`, and 900 (x 1194–1234) are byte-identical `e5eeff`. A primary button and a secondary button in dark mode render as the same pixel. The two chips sit 60 px apart in the Accents list and you cannot tell them apart.
>
> **2. In the light scheme, Primary 100/200/300 are byte-identical to Secondary 100/200/300.**
> `f2f7ff`, `dce9ff`, `bdd6ff` at y=81 and y=105, x-centres 179 / 313 / 447. Three of nine steps in both ramps are the same colour. Info 100/200 (`f0f7ff`, `d8eaff`, y=225) is within ΔE 0.70 / 1.76 of both. So the whole pale end of the light palette is one blue with three names.
>
> **3. The two schemes are built to different contrast budgets.**
> Light accent/status chips: white ink on the 700 fill — Primary 6.87, Secondary 6.44, Tertiary 6.46, Error 6.72, Success 6.71, Warning 6.75, Info 6.71. Dark: the role's own 100 on the 700 fill — 11.02 to 11.14 across all seven. Same components, ~1.65x more contrast in dark. Also, in light every On-colour is literally `ffffff` — OnPrimary, OnSecondary, OnTertiary, OnError, OnSuccess, OnWarning and OnInfo are one colour with seven names, which the "Ink ends" entry confirms ("White … an ink here").
>
> **4. "a dot marks where each pick lives" is false for the container picks, and inconsistently so.**
> Light SuccessContainer chip (482–526, 564–596) = `bbddbe`, but the dot sits on Success 300 (447,177) = `7feb8f` — ΔE **40.6**, a muted sage vs a vivid mint. WarningContainer `e4d3ac` vs Warning 300 `ffce4b` — ΔE **47.3**. Yet ErrorContainer is ΔE 3.3 and InfoContainer ΔE 3.9 — visually exact. Dark: Error 28.8, Success 13.3, Info 12.4, Warning 8.8. So the "held at the container chroma" clamp bites hard on two families and not at all on two others, and the ramp diagram points at a swatch that in two rows is plainly not the colour shown in the chip.
>
> **5. Highlight misses the floor it prints.**
> Text says "floored at 1.25 over the surface". Light Highlight `e6cbee` (24–68, 690–722) against the theme's Surface `e8e8e8` = **1.212**. Dark `3b2641` against Surface `222222` = **1.166**. Both below 1.25. Against Background (`f6f6f6`/`181818`) it is 1.374 / 1.302, which passes — so either the floor is broken or "the surface" is ambiguous between Background and Surface, and since the page never prints the measured number you cannot tell which.
>
> **6. Nine steps, but two of them are duplicates in dark and the ladder is not mirrored.**
> L\* per step, light: 97.0, 92.0, 85.0, 74.0, 63.0, 51.0, 39.0, 28.0, 6.0 — first gap 5, last gap 22. Dark: 8.2, 13.1, 18.9, 30.0, 46.0, 64.0, 82.0, 86.0, 94.0 — the 700→800 gap is 4. Dark Neutral 700/800 = `cccccc`/`d7d7d7`, ΔE **3.9**; dark Success 700/800 ΔE 3.9; Primary 7.4, Secondary 6.4, Info 7.1. Two of the nine dark steps carry almost no information. And the dark set is not the reverse of the light set, so "Primary 300" is a different lightness depending on scheme.
>
> **7. Chroma is not matched across roles at the same step.**
> At step 200 in light: Error C\*=10.9 (reads white), Success C\*=59.5 (vivid mint), Warning C\*=32.4, Secondary C\*=12.1. At step 400: Warning C\*=81.8, Secondary C\*=26.5. Secondary and Tertiary are flat-chroma across the whole ramp (26 and 41) while Primary/Error/Success/Warning/Info have a pronounced arc. Look at the light grid at y=177 x=313 (`96ffa4`) next to y=105 x=313 (`dce9ff`) — same step number, wildly different intensity. The step number tells you lightness and nothing else.
>
> **8. The "base" column is a copy of step 700, and its label is wrong.**
> Dark: base equals step 700 at ΔE **0.00** for all seven roles. Light: ΔE 0.00 for the four statuses, 1.1–1.4 for the three accents — invisible. The legend calls it "its role's pinned base", implying the seed, but light Primary base is `0050d0` and dark Primary base is `b0cdff`. The seed colour does not appear at any step of the dark ramp (it would fall between dark steps 400 `003ea6` and 500 `1463ed`). A tenth swatch per row that carries no information and misnames what it shows.
>
> **9. The section header bar is invisible in light and visible in dark.**
> The bar behind "Palette Ramps"/"Palette Picks" spans y 0–31 and y 282–312. Light: `f8f8f8` on a `f6f6f6` page — **1.016:1**, and it is *lighter* than the page while the theme's own Surface (`e8e8e8`, documented three rows below it) is darker. Dark: `222222` = Surface on `181818`, 1.09:1, and you can see it in the screenshot. Same element, present in one scheme and absent in the other, and in light it is not any named palette colour.
>
> **10. In dark, the entire right third of the page documents two colours the theme does not use.**
> Both "Ink ends" entries read "no ink here" (verified at 3x, crop x 930–1390, y 360–450). In dark the on-colours come from each role's 100, so White and Black are unused — yet they get a full column, and that column's content ends at y=443 while the left column runs to y=950.
>
> **11. The ramp grid is ruled in near-ink while the rest of the page uses Divider.**
> Grid rules at x=245–246, y=71–260 are `222222` in light (14.7:1 against the page) and `e8e8e8` in dark. The Palette Picks section underlines at y=354 are `d4d4d4` / `2e2e2e` — the Divider colour, 1.37:1. In the light grid the 2px near-black lines visually outweigh the `f2f7ff`/`dce9ff` swatches they enclose. Vertical rules are 2px, horizontal rules are 1px doubled with a 2px gap (y=92 and y=95), and the outer frame is 1px — three weights in one grid.
>
> **12. The same fact is worded two different ways depending on scheme.**
> Light: "the seed, lifted, just off Primary 700 / white, measured over Primary". Dark: "Primary 700 / Primary 100, measured over the base". Identical relationship, two vocabularies — "over Primary" vs "over the base". A diff of the two schemes' output is unreadable.
>
> **13. No measured numbers anywhere.**
> Every pick says "measured over X" and none prints the ratio. On a page whose stated job is showing where each colour came from, the one thing a developer needs to sign off — the contrast it achieved — is the one thing withheld. (Finding 5 exists only because I had to measure it myself.)
>
> **14. Layout wastes about a third of the page.**
> Content bottoms: left column y=950, middle y=850, right y=443; page content ends at y=950 leaving 169 px of blank full-width tail below it, plus roughly 470x670 px empty under the right column. Three columns are used because three families exist, not because the content balances.

## Triage

**Fixed in this task — finding 5.** The rule this task wrote said "floored at
1.25 over the surface", and "the surface" reads as the theme's own Surface
token, which the wash does not clear: 1.21:1 light and 1.17:1 dark, measured
here and confirmed independently. The cell shows the resolved field, which is
the wash against the Background pin, and there it clears the floor — 1.37:1
and 1.30:1. The rule now says "over the page", which is the colour the cell
actually shows and the word this board already uses for it. A wash standing on
any other surface is a walked colour this cell does not carry.

**Out of this task's scope — findings 1, 2, 3, 6, 7.** All five are properties
of the derivation, not of the listing: identical accent steps in both schemes,
the two contrast budgets, the unmirrored step ladder, and the unmatched chroma
arcs. They are worth a phase of their own; nothing in BQ1.2 could move them,
and the listing is reporting them accurately, which is what it is for.

**Recorded, not fixed — findings 4, 8, 9, 10, 11, 12, 13, 14.** Eight
observations about the palette section itself. The strongest are 4 (the grid
marks a step whose colour the container chip plainly is not — the rule says
"held at the container chroma" but a reader still reads the dot as "this
colour lives here"), 9 (the section heading band is 1.016:1 in light, and is
not any named palette colour), and 13 (a board about where colours came from
prints no measured contrast anywhere — the highlight cell, which prints its
measured hue separation, is the only cell that prints a number at all). 8, 10,
11, 12 and 14 are composition and vocabulary, all pre-existing.

## Recorded misread

None. The reviewer sampled every colour claim it made and reported the
coordinates, and the one dark-ink misread it was briefed on did not recur.
Worth carrying into the next brief: it read the ramp grid's rules as
"near-ink" (finding 11), which is what they measure, but this board draws them
in the inverse surface deliberately — a reviewer reasoning about a rule weight
should be told the frame colour is a chosen edge, not a divider.
