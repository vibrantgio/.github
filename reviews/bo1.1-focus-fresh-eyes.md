---
date: 2026-08-31
task: BO1.1
phase: BO
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BO1.1 fresh-eyes review — one focus-ring colour per scheme

The new focused-specimens golden, `components/gallery/testdata/golden/focus-{light,dark}.png`,
760 × 204 px at 1 px per dp: button, text field, checkbox, chip and dropdown
trigger, all focused, standing side by side on the paper, on a card and in a
dialog, one image per scheme. The reviewer was a fresh agent that had not seen
the task packet, the plan or any source. It was given the four files (each
scheme at 1× and at a nearest-neighbour 2× for small features, told the 2×
carries no extra information), told what the widgets and rows are, briefed on
the recorded non-issues and the pooled set (167–174, 177/178, 183–187,
190–200), told that the dark ring's small margin over the 3:1 floor was raised
before and rebutted by the owner, and asked one question: what would a
developer on this platform complain about. It was additionally required to
verify in pixels whether there is exactly one ring colour per scheme across all
specimens and all three rows. It had Bash and PIL and measured throughout.

Verbatim reply, then triage.

## Verbatim reply

> I read all four images and then measured them pixel-by-pixel. Findings below, worst first.
>
> ---
>
> ## 1. The focus ring is built three different ways across five widgets — and there are two ring colours per scheme, not one
>
> **Answer to the verification question: no, there is not exactly one ring colour per scheme. There are two.**
>
> Enumerating every chromatic pixel (max−min channel > 30) in each image, and slicing by widget column-cluster × row-band, the ring pixels resolve cleanly:
>
> | scheme | field / checkbox / chip / dropdown | button |
> |---|---|---|
> | light | `#8c59f4` — 4746 px | `#bdaaff` — 1482 px (= 494 × 3 rows) |
> | dark | `#a787ff` — 5244 px | `#804be5` — 1389 px (= 463 × 3 rows) |
>
> Twelve of the fifteen specimens share one ring colour; the three button specimens use a second. Each colour is bit-identical across all three storeys — paper, card and dialog do not perturb it at all. There is no third ring colour anywhere; every other chromatic mass is a fill (`#723ad4` / `#d0c4ff`) or the dark button's label ink (`#22004e`).
>
> The two rings are far apart: **2.14:1 contrast in light, 1.86:1 in dark** (hues 259.7° vs 253.4°, and 256.0° vs 260.6° — same family, different lightness, inverted direction: the button's ring is *lighter* than the standard ring in light mode and *darker* in dark mode).
>
> **Is the second colour defensible? The colour, yes. The geometry, no.** If the standard ring were painted on the button's accent fill it would land at **1.48:1 (light) / 1.72:1 (dark)** — invisible. So a second tint is forced. But the real problem is that the button also moves the ring:
>
> Horizontal scanlines at y=33 (x-offsets are absolute):
>
> - **field / dropdown** (`x 244–393`, `533–682`): outer 2 px = ring, then straight into the fill. The ring *is* the control's border, recoloured. No neutral border visible underneath.
> - **chip** (`x 458–518`): same — the pill rim itself is the ring.
> - **checkbox** (`x 412–439`): 2 px ring, **2 px transparent gap showing the panel colour through**, then a 2 px *neutral* border (`#797979` light / `#6d6d6d` dark), then the box fill. A genuine offset ring around an unchanged control.
> - **button** (`x 122–229`): outer 2 px = **fill**, then 2 px ring, then fill again. The ring is drawn **inside** the button, 2 px in from the edge, on both axes (top at y 18–19 inside an edge at y 16; bottom at 48–49 inside 51).
>
> So tabbing across one row, the focus cue jumps from *outside* the control (checkbox) to *on* the control's silhouette (field, chip, dropdown) to *inside* it (button). The button's outer silhouette does not change at all when focused — the only cue is a 2 px interior hairline at **3.17:1 (light) / 3.21:1 (dark)** against the fill it sits on, with the *same* colour on both sides of it, which reads as a bevel or a gloss highlight, not as focus. Meanwhile that same standard ring, drawn *outside* the button against the panel, would have scored **4.01:1 on light paper and 6.39:1 on dark paper**. The inset construction throws away contrast it did not have to throw away, and it is the reason a second token exists at all.
>
> Secondary consequence: the checkbox is the only control whose focus indicator lives outside its own bounds — 20 px box, 28 px focused footprint, a 40% growth. It's the only one that can be clipped by a parent or overlap a neighbour. Here it happens to have 18 px of clearance on each side (ring-to-ring gaps across the row are 14, 18, 18, 14 px), but in a dense checkbox list that ring is the first thing to get cut.
>
> A macOS developer's version of this complaint: the platform ring is a single consistent thing drawn *outside* every control. Here it is three constructions and two colours, and the one control that most needs an unambiguous ring — the default push button — gets the weakest and most easily misread of the three.
>
> ## 2. In light mode the focus ring carries zero luminance signal
>
> Ring `#8c59f4` has relative luminance **0.1925**. The neutral resting border on the checkbox, `#797979`, has relative luminance **0.1912**. That is a contrast ratio of **1.01:1** — grey equivalents 121 vs 120. Same width too: both are 2 px.
>
> So in the light scheme, a focused accent border and an unfocused neutral border are **the same tone at the same weight**. Focus is encoded 100% in hue. I converted the light image to true relative-luminance greyscale and looked at it: the checkbox's focus ring and its own inner neutral border are indistinguishable, and the focused chip just looks like a chip with an ordinary grey outline. Under macOS's *Differentiate Without Color*, on a greyscale display, or for a monochromat, light-mode focus disappears entirely.
>
> The dark scheme does not have this problem — ring `#a787ff` (grey 154) vs neutral border `#6d6d6d` (grey 109) is 1.86:1, and the same greyscale test shows the ring clearly brighter than the border. This is a light-scheme-specific defect, which is the worse half to lose, Light Appearance being the macOS default.
>
> ## 3. The light scheme's elevation ramp is invisible; the dark one isn't
>
> The three row bands are flat, edge-to-edge, 68 px each, no dividers. Sampled at x=5:
>
> - light: `#f6f6f6` (246) / `#f8f8f8` (248) / `#fbfbfb` (251); field fills on those rows: 248 / 251 / 255
> - dark: `#181818` (24) / `#222222` (34) / `#2e2e2e` (46); field fills: 34 / 46 / 71
>
> Both schemes use the identical structural trick — each storey's panel reuses the previous storey's *control* tone (light card panel `#f8f8f8` is exactly the paper row's field fill; dark card panel `#222222` is exactly the paper row's field fill). But the step sizes are not comparable:
>
> | | paper→card | card→dialog | panel→field within a row | whole stack |
> |---|---|---|---|---|
> | light | 1.018:1 | 1.026:1 | 1.02–1.03:1 | **1.081:1** |
> | dark | 1.116:1 | 1.172:1 | 1.31–1.46:1 | **1.911:1** |
>
> Light spends **2, 3 and 4 code values** per storey — inside banding and dither noise, and below what survives auto-brightness, True Tone, or a mediocre panel. A developer will say: my card, my dialog and my page are the same colour, and my text field is the same colour as the surface it sits on — the only thing separating a control from its background in light mode is a border. Dark mode's identical structure reads clearly (a text field is a full 10–25 code values off its panel). The same design intent renders as depth in one scheme and as nothing in the other.
>
> ## 4. Two type sizes and two baselines in a single row of controls
>
> Same letter, same image, light-paper row: the **`p` in "Chip" is 7 × 11 px**; the **`p` in "Apple" is 8 × 12 px**. Alpha-weighted cap measurements agree: `B` in Button 10.0 px, `C` in Chip 10.3, `A` in Apple 11.2, `F` in Field 11.7. Baselines land at **y=38 for button and chip, y=39 for field and dropdown** — consistent in both schemes and all three rows, so it isn't AA noise.
>
> Widget heights compound it: field and dropdown are 40 px tall, button and chip 36 px, checkbox 20 px (28 with ring). All five are centred on y=33.5, so nothing lines up top or bottom, and the labels sit on two different baselines 1 px apart. On macOS these would all be one control size with one system control font. Corner radii are otherwise consistent (~4 px on button/field/checkbox/dropdown; the chip is a deliberate pill).
>
> ## 5. The focused text field shows no insertion point
>
> I scanned the interior of all six field specimens for any column with ≥14 rows of ink — a caret would be roughly 16 px tall here. Zero hits in either scheme, any row. A field advertised as focused, showing placeholder text and no caret, gives the user nothing to distinguish "this is where my keystrokes go" from "this control merely has a coloured border." Caveat: this could be a blink-off frame or a deliberate omission from static specimens rather than a real gap — but if the specimen sheet is the contract, the contract is missing the caret.
>
> ## Noted in passing, not filed
>
> - I did see the dark ring's tight margin: `#a787ff` on the dialog-row field fill `#474747` measures **3.34:1**, the smallest number in the sheet. Recorded as already raised and rebutted; not a new finding. Every other ring-to-neighbour pair is comfortable (light 4.01–4.33:1, dark 4.68–6.39:1).
> - The checkbox's painted box is 20 × 20 px at 1x, under the 24 × 24 minimum, though the hit area isn't knowable from pixels.
> - The dropdown's disclosure mark is a solid filled down-triangle rather than a macOS chevron — but that is almost certainly the Material icon-font stand-in, so I'm treating it as covered by the font-substitution ruling.
>
> ---
>
> Model: Opus 5 (`claude-opus-5[1m]`). Reasoning effort: not exposed to me in this session, so I can't state it.

## Triage

**Item 1 — the ring's colour half is CONFIRMED; its geometry half is a new
finding.** The reviewer independently reproduced the whole derivation: twelve
of fifteen specimens draw one bit-identical colour, unmoved by the storey, in
both schemes — which is the ruling — and it reproduced from pixels the exact
arithmetic that forces the thirteenth: the scheme's ring painted on a solid
primary fill measures 1.48:1 light and 1.72:1 dark. It calls the second colour
defensible and the *placement* the defect. That is a real question this task
did not open and cannot close cheaply: moving the button's band from inside its
fill to outside the control changes the button's focused footprint, which moves
every stored image containing a focused button in every repo that has one.
Nothing was changed for it. **For pooling.**

The checkbox's ring living outside its bounds (40% footprint growth, first
thing to clip in a dense list) is a distinct observation in the same item.
**For pooling.**

**Item 2 — the light ring carries no luminance signal.** New, measured, and the
sharpest finding in the reply: the light ring `#8C59F4` and the neutral resting
border `#797979` differ by 1.01:1 in relative luminance at the same 2 px width,
so light-scheme focus is carried entirely by hue and vanishes under
Differentiate Without Color or on a greyscale display. Dark does not have the
problem (1.86:1). Changing it means moving the light ring off the rung nearest
the ramp's mid-value step, which is a contrast-rule decision and moves every
light focus image. **For pooling.**

**Item 3 — the light elevation ramp measures 2–4 code values per storey.** Not
new as a fact: it is the ladder's stated trade, written down in
`components/internal/control`'s `Fill` header ("in the light scheme the rungs
above the pin are whispers … what says where the control is, is the Border
hairline and the corner radius") and in the tokens package's elevation header.
The reviewer's contribution is the measurement of the whole stack — 1.081:1
light against 1.911:1 dark — and the observation that the same structure reads
as depth in one scheme and as nothing in the other. **For pooling as a
re-measurement of a known trade, not as a defect.**

**Item 4 — two type sizes and two baselines across one control row.** Real and
the library's own: a button and a chip take LabelLarge, a field and a trigger
take BodyLarge, and the four control heights are 36/40/20 px. Not a property of
this sheet's composition — the sheet uses each family's own role, as the
gallery does. **For pooling.**

**Item 5 — no caret in the focused field.** True of the static render, which
draws no insertion point in any state; the live field's caret belongs to the
interactive path. Worth deciding whether a focused specimen should show one.
**For pooling.**

**Passing notes.** The dark ring's 3.34:1 against the level-3 fill is the
already-rebutted margin and is not re-pooled; it is the same number this task's
own sweep gates at 3.17:1 worst over 1644 palettes. The 20 × 20 px checkbox box
and the Material disclosure triangle are covered by existing rulings.

**Nothing was fixed in this task from this review** — every finding is either
confirmation of what shipped or a change larger than BO1.1's scope.
