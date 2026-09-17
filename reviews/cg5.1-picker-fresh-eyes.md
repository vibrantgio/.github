---
date: 2026-09-18
task: CG5.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.1 — the picker's trigger read cold beside the platform's pop-up button

One reviewer, having seen neither the plan nor the packet nor any source, was
given the gallery's picker row at 1x in both appearances — the five specimens
Closed, Focused, Open under its menu, Disabled and Toolbar — beside the Save
dialog's own pop-up buttons in `save-dialog-{light,dark}.png` and the Finder
toolbar's pop-up and pull-down in `finder-window-light.png`, with the hover
capture of the same toolbar. One question: does this control read as the
platform's pop-up button in its states, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; a
still shows no fade and no cursor and a pointer target is invisible in one;
alpha composites in encoded sRGB; the window controls and surrounding chrome
are harness stand-ins; the open menu's own drawing is somebody else's and not
under review.

The renders it read were taken after this task's change landed: the trigger
drawn at the pop-up's measured 24 px with no edge column of any kind, its
label spending the pop-up's own origin, and the platform's stacked chevron
pair in place of the solid triangle.

## The reply, verbatim

> # Review — picker trigger against the macOS 26 pop-up button
>
> **Answer: no.** The bezel is right — the label, the focus ring and the toolbar variant are not. Three of the five specimens are wrong in ways that are measurable, and the toolbar specimen is a different control altogether.
>
> Everything below is measured at 1x with PIL against the supplied captures.
>
> ## What is right, briefly
>
> - **Height: 24 px exactly**, in all five specimens, matching the "File Format" pop-up (y 136–159).
> - **Corner radius**: identical edge-inset profile to the reference (2 px at the first row, 1 px at the second, 0 from the third) — r ≈ 5. Exact.
> - **Light fill #ECECEC** (236,236,236) — byte-identical to the reference pop-up.
> - **Label and chevron ink**: #242424 light, (224,225,226) dark — byte-identical to the platform in both appearances.
> - **Chevron metrics**: 8 px wide, 11 px tall, split 5 / 1 gap / 5, vertically centred; trailing inset 8 px against the platform's 9. Leading text inset 11 px against the platform's 12. All within a pixel.
>
> Someone clearly measured the bezel off the platform. Nobody measured the type.
>
> ## 1. The label is ~20% too large — the loudest error on the row
>
> | | cap height | x-height | "Apple"/"Script" |
> |---|---|---|---|
> | Platform ("Script", "Script Editor", "Where:") | **10 px** (rows 143–152; confirmed again on 'S', 'E' and the 'd' ascender of "Script Editor", rows 88–97) | 7 px | — |
> | Specimen, Closed/Focused/Open/Disabled | **12 px** (rows 45–56) | 9 px | 40 px wide |
> | Specimen, Toolbar | **11 px** (rows 45–55) | — | 35 px wide |
>
> The platform puts a 10 px cap inside a 24 px bezel (ratio 0.42). The specimen puts a 12 px cap inside the same 24 px bezel (ratio 0.50). That is why the control reads as a web `<select>` rather than a macOS pop-up: the text is crowding a bezel sized for smaller text. The bezel is correct and the type inside it is not, which is the worst of both — it looks like a macOS control with the wrong contents.
>
> Secondary: **the row is not internally consistent.** The Toolbar specimen's label is a whole size smaller than the other four (cap 11 vs 12, word width 35 vs 40 px). Two sizes of the same label across five specimens of one control is a defect regardless of which one is correct.
>
> The specimen is also vertically 1 px high: cap band 45–56 centres on 50.5 against a box centre of 51.5. The platform's centres exactly (cap band 143–152, centre 147.5; box 136–159, centre 147.5).
>
> ## 2. The focus ring is inset and half-thickness — the control shrinks when focused
>
> | | thickness | placement | colour |
> |---|---|---|---|
> | Platform (Save As field) | **4 px** (rows 5–8 above, 31–34 below; 4 px at the left, x 62–65) | **outside** the control bezel; the field keeps its full height | (137,182,248) light / (38,107,150) dark |
> | Specimen | **2 px** (rows 40–41, 62–63) | **inside** the 24 px box — the fill runs only 42–61 | (118,170,240) light / (39,113,159) dark |
>
> The focused specimen's outer bounds are x 200–359, y 40–63 — identical to the Closed specimen's 160 × 24. The ring is painted over the control's own top and bottom two rows, so a focused picker has **20 px of fill where an unfocused one has 24**. On the platform the control never changes size; the ring grows outward into the margin. As drawn, focusing the control makes it visibly shrink and turns the bezel into a blue-outlined box.
>
> The dark ring colour is close (39,113,159 vs 38,107,150). The light ring is noticeably more saturated than the platform's: (118,170,240) vs (137,182,248), ~19 darker in R. Minor next to the geometry, but wrong.
>
> ## 3. The Toolbar specimen is the wrong control
>
> | | Finder's view pop-up | Specimen |
> |---|---|---|
> | Treatment | **filled capsule**, lighter than its toolbar: pure white (255) on a 250–252 toolbar, with a soft drop shadow, **no stroke** | **no fill at all** — interior is exactly the page ground (255 light, 30,30,30 dark) with a 1 px stroke (#DFDFDF light, #323232 dark) |
> | Size | 49 × 24, corner clearly rounder than the form pop-up's (measured 7–9 through the shadowed edge) | 67 × 24, r ≈ 5, same as the form pop-up |
>
> The figure/ground relationship is inverted. The platform lifts the toolbar control off the toolbar with a lighter fill and a shadow; the specimen draws a hollow outlined rectangle that sits flat on the ground. In dark mode it is nearly invisible — a (50,50,50) hairline on (30,30,30).
>
> ## 4. The Toolbar specimen carries the wrong indicator
>
> Finder's toolbar shows both glyphs side by side, and they mean different things:
>
> - **view pop-up** (a picker, x 106–112): the **stacked chevron pair**, up at rows 21–25, down at 28–31.
> - **group pull-down** (an action menu, x ~173–180): **one down chevron**, rows 24–28.
>
> The specimen's Toolbar picker draws **one down chevron** (x 779–787, rows 49–54). On the platform that says "this is a menu of actions", not "this shows the current choice". A pick-one control wearing a pull-down's glyph is a semantic error, not a styling nit — and it is inconsistent with the specimen's own other four variants, which correctly use the pair.
>
> It is also drawn far too weakly: the specimen's toolbar chevron peaks at grey **124** while its own label peaks at **38**. Finder's toolbar chevron peaks at **77**, level with the icon ink beside it (77–84). The indicator recedes when the platform keeps it at label weight — the other four specimens get this right (chevron 36, label 36, matching the reference's 36/36).
>
> ## 5. The dark fill carries a blue cast that is not the platform's
>
> The platform's dark control fill sits a **uniform +16 / +16 / +16** above its window ground: ground (35,42,47) → fill (51,58,63). That is a neutral white overlay at ~7.5% over a ground that happens to be tinted by the sheet's vibrancy.
>
> The specimen reproduces the **absolute value (51,58,63)** on a neutral (30,30,30) ground — a delta of **+21 / +28 / +33**. Composited correctly, a neutral 7.5% white over (30,30,30) lands at ≈(47,47,47). The picker is measurably bluer than its surroundings where the platform's is neutral.
>
> The same signature appears on the dark disabled label, (101,107,110) — consistent with 0.29 alpha over the already-tinted fill, so it inherits the cast. The dark palette looks like absolute RGB sampled out of one vibrancy-tinted screenshot rather than a translucent overlay. Light mode is unaffected because the reference ground there was plain white.
>
> *(Disabled text alpha itself is correct: 0.29 in the specimen against the platform's 0.29 light / 0.29 dark. Not a finding.)*
>
> ## 6. Disabled fades the contents but not the bezel
>
> The Disabled specimen's fill is **byte-identical to the enabled one** — (236,236,236) light, (51,58,63) dark. Only the label and chevron fade (36 → 178 light). AppKit draws a disabled control's entire bezel at reduced opacity, so the bezel lightens toward the window background too. There is no disabled pop-up in the supplied references to measure against, so I state the specimen's measurement rather than a platform number — but an unfaded bezel under faded text is not what AppKit produces.
>
> ## 7. Open does nothing to the trigger
>
> Diffing the Closed trigger against the Open trigger over the full 160 × 24 box: **410 differing pixels, all of them in the label text zone** ("Apple" vs "Banana"). The bezel and chevron zones differ by **0 pixels**. There is no pressed, active or highlighted treatment on a trigger whose menu is standing open.
>
> Compounding it: the menu is placed *beneath* the trigger (menu y 60–147, trigger ends at 63 — a 1 px gap), left edges aligned at x 376/535. The platform pops the menu *over* the button with the selected row registered on the button. I am not judging the menu's own drawing, but the trigger is left fully exposed in a state it has no rendering for, which the platform never has to solve because the button is covered.
>
> ## 8. The chevron shape is blunter than the platform's
>
> Correct size, wrong profile. The platform's up chevron widens linearly across all five rows from a 2 px apex:
>
> ```
> 143      +.
> 144     +##.
> 145    +#+##.
> 146   +#+ .##.
> 147   ++   .+.
> ```
>
> The specimen's reaches full 8 px width by its third row and is solid across the apex for three rows before opening:
>
> ```
> 47    .++.
> 48   .+##+.
> 49  .+####+.
> 50  +#+..+#+
> 51  ++.  .++
> ```
>
> At 1x the specimen's reads as a filled wedge with rounded shoulders rather than two thin strokes meeting at a point. Smallest item on the list, but it is the difference between a chevron and a blob.
>
> ## 9. Gap in coverage
>
> The row has no hover and no pressed specimen. The platform has both (the two Finder captures differ precisely in the hover treatment of the view pop-up), and pressed is the state a pop-up button spends its whole interaction in. Five specimens and neither one is shown.

## What was done with it

Nothing in the reply is CG5.1's to fix. The task's result is the trigger's
height, its two insets, its absent edge column and its mark, and the reply
confirms every one of them off the pixels independently — 24 px exactly, the
fill byte-identical, the mark 8 × 11 split 5 / 1 / 5 and centred, and the
mark's colour byte-identical to the platform in both appearances, which is
the reading that sent this task to `ControlText` rather than to the secondary
label its own text named. Everything else it found is another control's, or
typography's, or already filed.

Two of its numbers were re-measured here and are not defects:

- **the trailing inset "8 px against the platform's 9"** — measured off the
  gallery golden, the mark covers x 167–174 in a trigger ending at x=183:
  nine clear columns, the platform's number exactly. The reply counted the
  clear columns one short.
- **the leading inset "11 px against the platform's 12"** — the trigger
  spends an origin of 11 and the face adds its first glyph's bearing, which
  is the rule `control.PopupLeadDp` is written by. The platform's own capture
  says "Script", whose S carries a column; the gallery's specimen says
  "Apple", whose A carries none. Two words, one origin. `picker_test.go`
  pins the rule on a word that does carry one and reads 12.

Two more are already in the pool and are confirmed rather than refiled:

- **2**, the focus ring inside the control at half the platform's width, is
  pool 405, now with the platform's 4 px and its two colours measured.
- **5**, the dark fill's blue cast against a neutral window, is pool 425 —
  `PushButtonFill` dark read off a tinted capture. A fourth independent
  finding of it.

The rest is filed under section CF: **1** (the label's size and the row's two
sizes, and its one-pixel centring), **3** and **4** (the chrome variant's
fill, its mark's shape and its mark's colour), **6** (the disabled bezel),
**7** and **9** (the trigger has no hover and no pressed state at all, and
the gallery therefore shows neither), and **8** (the stroke's profile against
the platform's tapered glyph).
