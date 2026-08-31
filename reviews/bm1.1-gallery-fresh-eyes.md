---
date: 2026-08-31
task: BM1.1
phase: BM
reviewer-model: opus-5
reviewer-effort: high
---

# BM1.1 fresh-eyes review — the gallery window with the new badge section

Whole gallery window at 1280×860, both schemes, headless capture with
the new badge section mid-window; reviewer was a fresh agent briefed
on the recorded non-issues and the pooled items 167–174, asked what a
developer on this platform would complain about. Verbatim reply, then
triage.

## Verbatim reply

> I read both renders, cropped the badge band at 3x, and measured pixels. Here is what a developer would file.
>
> ## The headline: badge variants are encoded in hue and nothing else
>
> I scanned the entire badge content rect, (170,195)–(760,305), in both schemes. It contains exactly two things: the background colour and glyph antialiasing. Not one container pixel — no fill, no border, no radius, no padding, in either scheme. Every other component on screen renders real chrome (button pills, text-field boxes, checkbox squares, the picker field), so the badge is the only component here that is pure text.
>
> That alone might be a deliberate "typographic badge" decision — I can't tell a missing background from an intended one at the pixel level. But look at what it costs, combined with the palette. In the light scheme the five variants measure:
>
> | | ink | CR | L* | C* | h |
> |---|---|---|---|---|---|
> | Neutral | (92,92,92) | 6.19 | 39.1 | 0.0 | — |
> | Success | (0,107,36) | 6.21 | 39.0 | 53.1 | 143.5 |
> | Warning | (148,70,0) | 6.20 | 39.0 | 57.3 | 59.1 |
> | Error | (177,34,38) | 6.22 | 39.0 | 65.9 | 32.2 |
> | Info | (0,93,168) | 6.21 | 39.0 | 47.1 | 277.9 |
>
> Five colours pinned to L* 39.0 within a tenth. Somebody contrast-matched this palette carefully, and the side effect is that luminance carries *zero* variant information by construction. With no fill, no border, and no per-variant icon, hue is the only channel left.
>
> The gallery hides this because the word inside each badge happens to be the variant's own name. In production the word is arbitrary content — the row below proves it, with "Popular" and "128". So a Warning badge and an Error badge reading "Popular" differ only by hue.
>
> I ran Machado severity-1.0 simulations (sanity-checked: grey 128 maps to grey 128 in all three). Light scheme, deuteranopia: Success becomes (98,89,42), Warning (112,99,0), Error (115,103,32) — three khaki browns. Warning↔Error is ΔE\*ab **8.9**; Success↔Error **13.1**. Protanopia collapses Success↔Warning to **7.3**. In dark, tritanopia collapses Warning↔Error to **7.3**, and protanopia washes Error to (201,196,179), ΔE **16.8** from the Neutral badge — the error badge becomes the neutral badge. On 10px-tall text those are not distinguishable. That is WCAG 1.4.1 (Use of Color, Level A), and it is the one finding here that would block adoption.
>
> ## The close mark is an 8×8 pixel target with nothing around it
>
> The × ink box measures exactly 8×8 px in all three dismissible specimens, carrying 21.5 px² of coverage — about the ink mass of a single capital letter (the "P" of "Press" measures 22.9). It sits 5–6 px from its own label, 21 px from the next badge, and because there is no container there is no visible hit rectangle at all. Against the ~28pt macOS minimum, Material's 48dp, or even a ~24px pointer floor, that is roughly a tenth of the area a developer would expect to be handed.
>
> The state feedback is ink-only. Across rest/hover/press the label text is byte-identical — (92,92,92) light, (158,158,158) dark — and there is no background tint anywhere. Hovering a dismissible badge changes 64 pixels.
>
> And the two schemes don't ramp the same. Light runs L\* 39.1 → 28.0 → 7.1 (steps of 11 and 21, CR 6.19 → 9.30 → 17.19); dark runs 65.1 → 74.2 → 82.2 (steps of 9 and 8, CR 6.63 → 8.76 → 11.06). Light's press is an emphatic slam; dark's press is barely separable from hover, on an 8px glyph. Same interaction, half the confirmation.
>
> ## The set's internal ranking flips between schemes
>
> Light holds all five variants at 6.19–6.22:1 — Neutral is a co-equal member. Dark puts Success/Warning/Error/Info at 11.01–11.10:1 but leaves Neutral at **6.63:1**, a 40% contrast deficit that makes it read as the disabled member of its own set. Same tokens, different hierarchy depending on scheme.
>
> Chroma inverts the semantics on top of that. Error is the highest-chroma variant in light (C\* 65.9) and the *lowest* of the four colours in dark (C\* 27.0, a pale pink (255,187,180)), while Warning climbs from 57.3 to 69.8 and turns vivid amber. So the loudest badge on the row is Error in light and Warning in dark. Warning also swings hue family across schemes — h 59.1° (orange-brown) to 81.6° (yellow-amber), a 22.5° shift, easily the largest in the set. A developer will ask why one semantic token is two different hues.
>
> Relatedly, light's Warning at (148,70,0) is a brown. Forcing amber to L\* 39 to hit 6.2:1 makes amber unreachable; what lands is mud, at identical lightness and only 27° of hue from Error — the two variants whose confusion matters most are the two closest together.
>
> ## The gallery isn't a controlled comparison
>
> The entire utterances row renders in (0,93,168) light / (166,208,255) dark — byte-identical to the Info variant — while the dismissible row renders in Neutral grey. The variant changes with the row, so nothing here tells you whether variant and utterance are independent axes or whether the utterance forms are Info-only. For a gallery whose job is teaching the API, that's the wrong specimen matrix.
>
> Two smaller things in the same vein. The heading promises "the three utterances" and the row shows four specimens — Popular, 128, ✓, and ✓ Verified — with no marking of which one isn't an utterance. And icon sizing is inconsistent inside one component family: the leading check is 14×12 px / 45.3 px² of ink, the trailing close mark 8×8 / 21.5 px² — one icon half the optical weight of the other.
>
> ## One caveat, offered rather than filed
>
> In dark, the row labels measure 8.28–8.66:1 while the Neutral badge specimens they point at measure 6.63:1, so the label outranks the thing it labels; in light the order is correct (labels dimmer than specimens). I checked and this pattern holds for captions elsewhere in the gallery too, so it is probably systemic and may already sit inside the pooled caption finding — I'm not re-reporting the light-scheme caption number. It bites hardest here only because the badges have no container to hold their own visual weight.

## Triage

Fixed in scope by the worker: the specimen matrix (rows now vary one
axis each — hue, utterance, close-mark states) and the
three-utterances-four-specimens mismatch; goldens regenerated in
gallery and sitedocs. Partial false positive recorded: the close mark
DOES carry a 24 dp hit target, invisible by ruling — WCAG 2.5.8 AA
governs a text-sized inline element, not the 44 dp of a standalone
control; a still frame cannot show it, and the reviewer's deeper
point (nothing shows where you may click) is what the ruling
accepted. Everything else pooled as items 176–181.
