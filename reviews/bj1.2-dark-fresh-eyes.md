---
date: 2026-08-31
task: BJ1.2
phase: BJ
reviewer-model: opus-5
reviewer-effort: unrecorded
---

# BJ1.2 fresh-eyes review — the re-derived dark tone curve

Eleven stored images, six of them before/after pairs cut from committed
goldens: the component gallery in a 1180×760 app window, a note-taking app
window at 1100×800, the full 900×2575 component page, a 2× zoom of the chip
and badge rows, and a 6× zoom of the badge close-mark row — each at the tone
scale as it stood before the curve was re-derived and as it stands now. The
light scheme of the gallery window rode along as an unchanged reference so
the reviewer could judge whether dark had become symmetric with it, with
instructions not to review light for its own sake.

The reviewer was a fresh agent that had not seen the task packet. It was
briefed on the recorded non-issues (headless renders, substituted fonts, the
dark-ink-reads-grey misread, furniture deliberately darker than content) and
on the pooled set (167–174, 177/178, 182–187), told to sample pixels before
making any colour claim, and asked one question: what would a developer on
this platform complain about, and does the new dark read better than the old.
Two specific asks rode with it — the chip under the pointer on a raised
ground, and a re-measurement of the close mark's dark press ramp, which an
earlier reviewer had recorded as compressed and which was explicitly deferred
until this curve landed.

Its numbers were spot-checked before relaying. The focus ring at 3.07:1 on
the card ground, the ring's light counterpart at 4.01:1, the two distinct
ring colours in one page (`#804BE5` at 3234 px, `#A787FF` at 704 px), and the
old level-3 pressed chip's `#A1A1A1` fill carrying `#2E2E2E` ink with no rim
separable from the fill all reproduce exactly. Nothing in the reply was
found overstated.

Verbatim reply, then triage.

## Verbatim reply

> ## VERDICT — what would a developer complain about, and does the new dark read better?
>
> **Yes, the new dark reads better, and the improvement is not cosmetic — it fixes a state that was structurally broken.** But the fix has left three new seams, and one of them is a focus ring sitting 2.4% above the 3:1 floor.
>
> The complaint a developer would have brought against the OLD dark is precise: *the chip's press state stopped obeying the scheme once you raised the ground.* On the paper storey the pressed fill is `#353535` (L\* 22.2) with `#EEEEEE` ink; on a card it climbs to `#5C5C5C` (L\* 39.1); in a dialog it lands on `#A1A1A1` (L\* 66.2) and the label **flips to dark ink `#2E2E2E`** — which is bit-for-bit the dialog's own surface colour. The chip's press state in a dialog is the only cell in a 12-cell matrix rendered dark-on-light. Worse, its rim is also `#A1A1A1` — *identical to its fill*, contrast 1.00:1. The chip has no boundary at all. Every other chip in the matrix is bounded. That is the bug, and a developer building a popover full of filter chips would hit it on their first click.
>
> The new dark fixes both halves: pressed-in-dialog is now `#6D6D6D` fill with `#CCCCCC` rim (3.26:1 rim-to-fill, 8.46:1 rim-to-ground) and `#EEEEEE` ink. It is bounded and it is light-on-dark like its eleven siblings.
>
> Second complaint, also fixed: **the disabled controls were the loudest boxes on the page.** Disabled text field / picker fill went `#555555` → `#3C3C3C` (2.38:1 → 1.61:1 against the page, where the *enabled* field is 1.12:1), and the disabled placeholder went from 2.40:1 to 3.24:1 against its own fill. The disabled box no longer out-shouts its enabled neighbours, and its own text got *more* legible while doing so. Third: the picker's selected row went 4.58:1 → **5.76:1**, off the 4.5 floor it was sitting exactly on. Fourth: dark's secondary/caption ink dropped `#B6B6B6` → `#9B9B9B`, 8.76:1 → 6.39:1, moving toward light's 3.97:1 instead of being 2.2× louder than it.
>
> What a developer would complain about in the NEW dark: **the focus ring got quiet.** `#A98BFF` → `#804BE5` takes ring-vs-ground from 6.62:1 to 3.43:1 on paper and **3.07:1 on a card** — a 2.4% margin over WCAG's 3:1 focus floor, while light's equivalent ring measures 4.01–4.26:1 on every storey. That is the opposite of symmetric, and it is the one number in this change I would not ship without a decision. (Credit where due: OLD dark's *button* focus ring was `#5C15B7` at 1.90:1 against the page — one-sided, strong inside the button and nearly gone outside it. NEW is 3.21 inside / 3.43 outside. Better shape, thinner margin.)
>
> ---
>
> ## (A) CHIP UNDER THE POINTER
>
> All values sampled from `chips-and-badges-2x-*.png`; strokes are hard 2px at 2× with no antialiasing, so these are exact token values, cross-checked against a vertical scan through the top rim and against the 1× window render.
>
> ### Level-2 PRESSED ("On a card" / Press), ground `#222222`
>
> | | fill | fill:gnd | rim | rim:gnd | rim:fill | label | label:fill |
> |---|---|---|---|---|---|---|---|
> | BEFORE | `#5C5C5C` L\*39.1 | 2.38 | `#B6B6B6` | 7.85 | 3.30 | `#EEEEEE` | **5.76** |
> | AFTER | `#505050` L\*34.0 | 1.97 | `#CCCCCC` | 9.91 | 5.02 | `#EEEEEE` | **6.95** |
>
> Neighbours for context (AFTER): L2 rest `#252525`/rim `#9B9B9B`, label 13.21:1; L2 hover `#343434`/rim `#9B9B9B`, label 10.73:1.
>
> **Legible and bounded in both, better in AFTER.** The label gained 1.2 of contrast and the rim gained 1.7 against its own fill. This cell was never broken.
>
> ### Level-3 HOVERED ("In a dialog" / Hover), ground `#2E2E2E`
>
> | | fill | fill:gnd | rim | rim:gnd | rim:fill | label:fill |
> |---|---|---|---|---|---|---|
> | BEFORE | `#515151` L\*34.5 | 1.71 | `#B6B6B6` | 6.70 | 3.91 | 6.84 |
> | AFTER | `#4C4C4C` L\*32.3 | 1.58 | `#9B9B9B` | 4.89 | 3.09 | 7.40 |
>
> **Legible and bounded in both.** AFTER trades rim contrast (3.91 → 3.09 against the fill) for label contrast (6.84 → 7.40) and, more importantly, for *consistency*: OLD gave the hovered dialog chip a brighter rim (`#B6B6B6`) than its resting neighbour (`#9E9E9E`), NEW makes rest and hover share `#9B9B9B` on this storey. 3.09:1 rim-to-fill still clears the 3:1 non-text floor, but only just.
>
> ### The cell that was actually broken — Level-3 PRESSED
>
> | | fill | rim | rim:fill | label | label:fill |
> |---|---|---|---|---|---|
> | BEFORE | `#A1A1A1` L\*66.2 | `#A1A1A1` | **1.00 — no boundary** | `#2E2E2E` (= the dialog ground) | 5.26 |
> | AFTER | `#6D6D6D` L\*45.7 | `#CCCCCC` | 3.26 | `#EEEEEE` | **4.51** |
>
> Note the trade honestly: label contrast went **down**, 5.26 → 4.51. What was bought is a rim that exists, and an ink that matches the other eleven cells. That is the right trade. But 4.51:1 on a ~13px semibold label is a 0.2% pass, and it is the least legible label in the matrix by a factor of 3.3 (best cell is 14.85:1). Light's worst chip label is **12.53:1**. See finding 4.
>
> ### Does the state ramp stay separable per storey, same magnitude on all three?
>
> ΔL\* of the chip fill, rest → hover → press:
>
> | storey | LIGHT | DARK BEFORE | DARK AFTER |
> |---|---|---|---|
> | L1 paper | +5.58 / −7.08 | +5.39 / +7.00 | +5.39 / +7.00 |
> | L2 card | +6.28 / −7.08 | +7.02 / +17.37 | +7.02 / +12.32 |
> | L3 dialog | +7.31 / −7.08 | +14.13 / +31.79 | +11.99 / +13.71 |
>
> **Separable on every storey in both, yes.** **Same magnitude across storeys — no, and this is the residual defect.** Light's press step is *constant* at 7.08 L\* on all three storeys (its hover/press fills are absolute values `#E8E8E8`/`#D4D4D4`, identical regardless of ground). Dark's fills are ground-relative, so the walk stretches with the storey: AFTER varies 5.39→11.99 on hover (2.22×) and 7.00→13.71 on press (1.96×). BEFORE varied 2.62× and 4.54×. So AFTER roughly halves the divergence — real progress — but dark's paper storey (5.39/7.00, essentially identical to light's 5.58/7.08) and dark's dialog storey (11.99/13.71) are still two different components as far as the user's eye is concerned.
>
> ---
>
> ## (B) THE CLOSE-MARK RAMP
>
> **The earlier reviewer's "9 then 8" does not reproduce against these files.** I measured the plate at three points, then histogrammed the whole cap region; both agree.
>
> Close-mark plate, L\* (rest has no plate — the × sits on the badge fill `#183049`):
>
> | | rest | hover | press | step 1 | step 2 |
> |---|---|---|---|---|---|
> | **BEFORE** | 19.18 (`#183049`) | 31.00 (`#324B65`) | 65.25 (`#86A1C0`) | **+11.82** | **+34.25** |
> | **AFTER** | 19.18 (`#183049`) | 30.57 (`#314A64`) | 46.30 (`#56708D`) | **+11.39** | **+15.73** |
>
> So the old dark ramp was **11.8 then 34.3**, not 9 then 8. Press was not "barely separable from hover" — it was *screaming*: the pressed plate hit 5.05:1 against the badge fill and 6.66:1 against the page, making the 8px close cap the brightest object in the badge row, brighter than the badge itself.
>
> And it inverted. The BEFORE glyph L\* runs 57.18 → 59.45 → **53.93**: the × got *darker* at press while its plate leapt 34 points, leaving **glyph-on-plate at 1.46:1**. The close mark effectively vanished into its own cap at the moment of the click. Same failure mode as the L3 pressed chip, same file, same state.
>
> AFTER: glyph L\* 57.18 → 59.45 → **71.22**, monotone, glyph-on-plate **2.32:1**.
>
> **Verdict: better, substantially.** Press step cut 34.25 → 15.73; hover:press step ratio 1:2.90 → 1:1.38 (light's stated 11/21 is 1:1.91, so dark now brackets it rather than being 50% over); the plate stops out-shouting the badge (5.05:1 → 2.63:1 against the badge fill, 6.66:1 → 3.47:1 against the page); and the glyph inversion is gone. The hover step is unchanged at ~11.4, matching light's 11 — that half was already right.
>
> The remaining problem is finding 5 below: the × glyph still fails 3:1 against its own plate in two of three states.
>
> ---
>
> ## NEW FINDINGS
>
> **1. The focus ring lost half its contrast and now has no headroom over the 3:1 floor.** `#A98BFF` → `#804BE5`. Measured against every ground it actually touches in `gallery-page-dark-AFTER.png` (neighbour census over all ring pixels): 3.43:1 on `#181818` (paper, 3495 px), **3.07:1 on `#222222`** (card, 1616 px), 3.21:1 against the button fill `#D0C4FF` (792 px). Light's ring `#8C59F4` measures 4.01 / 4.08 / 4.15 / 4.18 / 4.26 against its grounds. Dark is now ~25% below light and 2.4% above the WCAG 2.4.11/1.4.11 floor at its worst. One tone step of drift and it fails.
>
> **2. The focus ring is two different colours depending on which storey the control sits on.** Pixel census of the AFTER page: `#804BE5` occurs in 3234 px across six y-bands (button row, chip-on-*paper* focus, text field, picker, link); `#A787FF` occurs in exactly 704 px in two bands — y508–543 and y584–619, which are the chip focus cells on the *card* and *dialog* storeys. Same component, same state, two ring tokens, differing by 19 L\*. Contrast consequence: chip focus reads 5.72:1 (card) and 4.88:1 (dialog) while every other focused control on the page reads 3.07–3.43:1. Light uses one ring value everywhere. This looks like a tone-scale lookup resolving one step differently for the paper storey.
>
> **3. The chip's rest rim is storey-dependent, so the hover affordance changes shape per storey.** AFTER rest rims: `#6D6D6D` on paper, `#9B9B9B` on card, `#9B9B9B` on dialog (3.43 / 5.72 / 4.89 against ground). Hover rims: `#9B9B9B` on all three. Press rims: `#9B9B9B` on paper, `#CCCCCC` on card and dialog. Read that as ramps:
>
> - paper: 109 → 155 → 155 — rim steps at **hover**, then stops
> - card/dialog: 155 → 155 → 204 — rim doesn't move on hover, steps at **press**
> - light, all storeys: 121 → 121 → 92 — rim never moves on hover, steps at press
>
> So on the paper storey the pointer brightens the outline by 86% in contrast terms; two storeys up it does nothing. BEFORE had a mirror-image version of this defect (rest/hover both `#9E9E9E` everywhere, but dialog-hover jumped to `#B6B6B6`), so this is a *moved* inconsistency, not a new one — but it is still there and light doesn't have it.
>
> **4. Dark's chip label contrast collapses across storeys where light's is flat, and a fourth storey would fail.** AFTER label:fill by cell — paper 14.85 / 13.04 / 10.57, card 13.21 / 10.73 / 6.95, dialog 11.21 / 7.40 / **4.51**. Light: 17.50 / 15.16 / 12.53 down to 18.27 / 15.16 / 12.53 — a 12.5–18.3 band, never below 12.5. Dark spans 4.51–14.85, a 3.3× spread, and the pressed-in-dialog cell is 0.2% over the text floor. Mechanism: light keeps the pressed fill at an absolute `#D4D4D4` and the ink at `#131313`; dark drives the pressed fill off the ground (`#353535`/`#505050`/`#6D6D6D`) while holding ink at `#EEEEEE`, so each storey eats ~11 L\* of the ink's headroom. Any surface above the dialog — a nested popover, a menu over a dialog — puts this label under 4.5:1.
>
> **5. The badge close-mark glyph fails 3:1 against its own plate in hover and press.** AFTER: rest 3.86:1, hover **2.83:1**, press **2.32:1**. BEFORE was worse (3.86 / 2.79 / **1.46**), so this improved, but the glyph is a meaningful non-text graphic under 1.4.11 and two of its three states are below the floor. The glyph colour is pinned at `#7292B6` for both rest and hover while the plate rises 11 L\* underneath it — that's why hover is the weakest non-press state. Distinct from the pooled "no boundary at rest" and "state-walk magnitude" items: this is the mark itself, not its cap.
>
> **6. The disabled checkbox's outline is now nearly gone.** Its rim went `#676767` → `#474747`: 3.14:1 → **1.91:1** against the page, and 1.83:1 → **1.40:1** against its own fill. Its fill went `#404040` → `#313131`, 1.71:1 → 1.37:1 against the page. The disabled-should-be-quiet direction is right and WCAG exempts disabled controls, but 1.40:1 between a 1px rim and the thing it encloses is the point where "quiet" becomes "not a control". This is the one place the darkening pass overshot; the disabled *field* (finding: 1.61:1 fill, 3.24:1 placeholder) landed correctly by comparison.
>
> **7. The solid button's state walk in dark is 39% of light's, and this change reshaped it without enlarging it.** Fill L\*: light 40.2 → 29.2 → 8.5 (ΔL\* −11.0 then −20.7, rest:press 2.755:1). Dark AFTER 81.9 → 86.2 → 94.1 (ΔL\* +4.29 then +7.93, rest:press **1.391:1**). AFTER changed hover only (`#DFD8FF` → `#DBD2FF`), leaving press and rest untouched, so the *total* walk is byte-identical to BEFORE at 1.3909:1 — the change redistributed the two steps from 1:1.75 to **1:1.85**, which now matches light's 1:1.89 almost exactly. Shape symmetric, magnitude not: a click on a dark primary button moves 12.2 L\* where the same click in light moves 31.7. Structural cause is that dark's primary is a light fill with only ~18 L\* of headroom above it; the fix isn't in the tone scale.
>
> ### Pooled items this change moved (noted, not re-filed)
>
> - Dark secondary/caption ink `#B6B6B6` → `#9B9B9B`, **8.76:1 → 6.39:1**. The light-vs-dark caption asymmetry narrows from 3.97 vs 8.76 to 3.97 vs 6.39. Dark still clears 4.5 comfortably.
> - Picker selected row: fill `#BDAAFF` → `#D0C4FF`, ink `#474747` unchanged, **4.58:1 → 5.76:1**. It is no longer the row sitting on the floor; unselected rows are 8.01:1 (unchanged), so the gap closed from 3.4 to 2.25.
> - Disabled controls out-shouting enabled: disabled field/picker fill `#555555` → `#3C3C3C`, **2.38:1 → 1.61:1** against the page (enabled field is 1.12:1); disabled placeholder `#929292` → `#8B8B8B` reads **2.40:1 → 3.24:1** against its now-darker fill. Materially addressed.
> - Container/field/checkbox rest rims `#9E9E9E` → `#6D6D6D` everywhere (2580 px in the notes app alone): 6.63:1 → 3.43:1 against the page. Light's equivalent is 4.03:1, so this moved dark toward light and slightly past it. Still clearly visible; not invisible. Dividers, scrollbar and the sidebar rule are untouched (`#363636`, `#878787`, `#2E2E2E`).
>
> ---
>
> ## PREDICTION CONFIRMATIONS
>
> **Prediction 1 — solid-fill button hover ≈ 1.118:1 from rest. CONFIRMED in substance, off by 0.009 in the number.** Measured `#DBD2FF` (hover) against `#D0C4FF` (rest) = **1.1269:1**, ΔL\* +4.29. Both values are the dominant modal fills (4056 px and 77691 px in the AFTER page), sampled clear of edges and glyphs. It is indeed deliberately tiny, and it is *smaller* than before (BEFORE was 1.1829:1, ΔL\* +6.08). The 0.009 gap suggests 1.118 was computed from unrounded tokens before 8-bit quantisation. Note the consequence: at 1.13:1 the hover fill alone is not a perceivable affordance — on the paper storey the button relies entirely on the pointer being there. Light's hover is 1.499:1.
>
> **Prediction 2 — focus ring ≈ 2.92:1 against a mid-tone ground, symmetric with light's 2.93:1. REFUTED as stated; I cannot reproduce either number as a real adjacency.** I enumerated every colour bordering every focus-ring pixel in the AFTER page, and every colour above 80 occurrences in both AFTER and the light reference. The ring never meets anything at 2.92 or 2.93. Actual ring-to-ground:
>
> - dark AFTER `#804BE5`: **3.43** (paper), **3.07** (card), 3.33 (`#1B1B1B`), 3.21 (button fill)
> - dark AFTER `#A787FF`: 5.72 / 5.51 / 4.88 / 4.68 (chip focus, card + dialog)
> - light `#8C59F4`: **4.01 / 4.08 / 4.15 / 4.18 / 4.26**
>
> The nearest 2.92-ish values exist but are not the same relationship in the two schemes: dark's ring vs the *hover chip fill on paper* `#262626` = 2.9227, light's ring vs the *pressed chip fill* `#D4D4D4` = 2.9209 (and vs the Warning badge fill = 2.9301). Those are coincidences of different pairs, not a symmetry. On the measurable version of the claim — ring against the ground it sits on — dark is 3.07–3.43 and light is 4.01–4.26: **not symmetric, dark is the weaker of the two by about 25%.**

## Triage

**The verdict answers the phase's question.** The curve was re-derived to put
rungs in a hole that spanned 1.9:1 to 6.6:1 against the dark page, and the
reviewer — who was not told that was the goal — found the hole's consequences
on its own and named them as the thing a developer would have complained
about: a pressed chip on a dialog that inverted to dark ink on a fill
indistinguishable from its own rim, and a close mark whose glyph went darker
while its plate leapt 34 L\*. Both were the old curve reaching across the gap
for a rung that cleared its floor and landing on a pale one. Both are gone.

**Nothing here is a stop-and-report for this task.** No light tile moved; the
reviewer's own light measurements are the unchanged reference and it did not
report light drift. The findings are all forward work on the new curve.

**Item 179 retires re-measured, and its premise was wrong.** It recorded the
dark press ramp as L\* steps 9 and 8 with press "barely separable from hover",
and deferred action until this phase landed. Re-measured against the same
stored images, the old ramp was 11.8 then 34.3 — the opposite defect, a press
plate that out-shouted the badge it sat in at 6.66:1 against the page, with
the glyph inverting to 1.46:1 against its own plate at the moment of the
click. The new ramp is 11.4 then 15.7, the glyph is monotone, and the plate
no longer out-shouts the badge. The compression the item describes does not
exist and never did; the inversion it missed is fixed. What survives is the
glyph-against-plate floor, filed fresh as item 192.

**Two findings are the same shape and probably one cause.** Items 189 (two
ring colours in one page, differing by 19 L\*) and 190 (rest rim steps at
hover on the paper storey, at press on the other two) both read as a rung
lookup resolving differently for the paper storey than for raised ones. Worth
looking at together before either is touched.

**Item 188 is the one to rule on first.** A focus ring at 3.07:1 has a 2.4%
margin over the floor it must clear, where light's has 34%. It is the only
finding the reviewer said it would not ship without a decision, and the ring
is a token, not a walk — a cheap fix if the ruling goes that way.

Pooled as items 188–194 in `explorations/open-rulings.md` §Z.
