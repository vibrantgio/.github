---
date: 2026-09-05
task: BR1.6
phase: BR
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BR1.6 fresh-eyes review — the card and the field, both schemes

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer on this platform
complain about? The model was passed as `opus`, so the reviewer ran on
the dispatching session's own model; its effort setting is not
observable from here and is recorded as unrecorded.

What it was handed: one specimen sheet per scheme, 760×520, rendered
offscreen through the headless GPU — the window's content plane
carrying a filled card and an outlined card side by side, each holding
a text field, and beneath them a dialog surface with a card on it and a
field in that card. It was told to sample pixels before making any
claim about a colour, and briefed on the three recorded misreads (dark
foreground reading grey at 1x, a small tonal step reading as none, and
chrome regions sharing one fill by design). It checked all three and
reported that none applied.

The sheet the reviewer saw was drawn by a throwaway harness rather than
by an application, and one thing in it was the harness's fault rather
than the system's: it filled the dialog surface without the outline
`patterns/modal` actually strokes around it, so the reviewer's first
finding reads the light dialog as having no edge at all. The finding is
answered under the triage below rather than corrected in the record.

## The reply, verbatim

I looked at both sheets at native size and sampled every surface. Here is the full tone map (all values are 8-bit grey; both images are perfectly neutral, R=G=B everywhere):

| level | light | dark |
|---|---|---|
| window backdrop | 241 | 24 |
| card A (left, no outline) | **255** | 34 |
| input in card A | **255** | 44 |
| card B (right, outlined) | **255** (outline 193/203) | 34 (outline 80/82) |
| dialog surface | **255** | 46 |
| card C (on dialog) | **255** (outline 234) | 57 (no outline) |
| input in card C | **255** | 71 |

## 1. The light scheme has no elevation ramp at all — five nested levels are all exactly #FFFFFF

This is what a developer would open their mouth about first. In dark there is a real, monotonic ramp: 24 → 34 → 44 on the content plane, and 46 → 57 → 71 on the dialog. In light, card, input, dialog, card-on-dialog and its input are all **exactly 255** — not a small step, zero step. Verified by sampling whole interior boxes, each of which returned `n_uniq=1, value=255`.

Concrete consequences:
- Dialog vs. the plain card beside it: dark `46 vs 34` = 1.172:1; light `255 vs 255` = **1.000:1**. In light a modal dialog surface is pixel-identical to an ordinary card, so it has no elevation identity.
- Card C vs. the dialog under it: dark separates by fill (46→57, 1.176:1); light has to fall back to a 234 hairline (1.203:1) because there is no fill left to spend.
- Input vs. its card: dark 34→44 and 57→71; light 255→255, so the field exists only as its 1px outline.

The headroom is the root cause: light gets 241→255, **14 levels** total above the backdrop; dark has spent 47 levels (24→71) and still has 184 left. The light scheme runs out of ramp after one step, and there are **no shadows anywhere in either sheet** to compensate — every boundary is a hard one-pixel transition (e.g. light column x=200: `…255 | 220-259:241`, no penumbra), and every flat region is single-valued. So once the fill saturates there is no second cue.

## 2. The same card measures a different size in light than in dark

Card C's outer bounds: **light x63..364, y283..456 = 302×174. Dark x64..363, y284..455 = 300×172.** Same widget, same content, 2px difference in both dimensions, purely from the colour scheme.

The mechanism is visible in the pixels: card C gets a 2px outline (234) in light and no outline at all in dark — presumably an automatic fallback for "I can't step my fill above my parent, so draw an edge instead" — and that outline is added *outside* the box rather than inset. Measured from the card's own outer edge, its inner padding is **17px in light and 16px in dark** (input C's left edge is at x=80 in both).

This is the finding that would cost someone a day: layout geometry is theme-dependent, so golden-image tests diverge, sibling alignment shifts, and toggling appearance nudges everything by a pixel.

## 3. Outlined and filled cards in the same row don't share bounds

Card A (filled): **300×180**, y40..219. Card B (outlined): **302×182**, y39..220. Same row, same content — the inputs inside them are at the identical absolute y56..95 — but the outlined variant's stroke is painted outside its layout box, so it overhangs its sibling by 1px on every side and its inner inset from the outer edge is 17px vs card A's 16px. That is why the row's top edges don't line up in the render. Same root cause as #2.

## 4. Trivial, sub-perceptual: Δ1 compositing seams

Full-height 1px columns one shade off their surroundings: light card B at x=382 (254 on 255); dark card B at x=382 **and** x=385 (both 35 on 34); dark input A at x=322 (45 on 44). That is 1.004:1 — genuinely invisible, and I would not file it except as a hint that the outlined card double-composites its inner edge in dark (two seams, not one).

## What is right, plainly

I checked the three recorded misreads and none of them apply here:

- **Dark foreground text is not grey.** Placeholder ink samples at **204** in every input. Contrast: 8.696:1 on input A (fill 44), 5.786:1 on input C (fill 71). Light ink is 92 → 6.687:1. All three comfortably pass AA; the dark text is genuinely lighter than it looks at 1x.
- **The small dark steps are real, not absent.** 24→34, 34→44, 46→57, 57→71 all measure. My "no step" finding is confined to light, where the values are bit-identical.
- **The uniform backdrop is deliberate.** 241/24 across the entire window with no seams — one fill for the whole plane, not a bug.

Also solid: the text fields are the most consistent thing on the sheet. All three are 40px tall, their outlines are one token per scheme (121 light / 155 dark) giving 4.353:1 and 3.343–5.724:1 against every fill they sit on — well past the 3:1 bar for non-text UI boundaries — and the two top cards' inputs sit at identical absolute coordinates. The dark ramp as a whole is well-formed and I would not change it.

## Triage

**1 — the light scheme runs out of fill above the first raise: ANSWERED, partly by
design and partly the harness's fault.** The reviewer measured the ruling: the
light content pin stands one band step under white so that the first raise off
the content is told by its fill (241 → 255, 1.129:1, the same order as the dark
scheme's 1.116:1), and everything above that first raise is told by a seam. The
reviewer's own numbers confirm the raise it says is missing is present where the
language promises it — its card-vs-backdrop figure is the one raise the light
scheme has, and its card-C-vs-dialog 1.203:1 hairline is the seam doing the job
the fill cannot.

Two parts of the finding are the harness's, not the system's. The dialog was
filled without the outline `patterns/modal` strokes around it, so "a modal
dialog surface is pixel-identical to an ordinary card" is true of the sheet and
not of the pattern: a real dialog carries a 3:1 neutral edge and its scrim. And
"no shadows anywhere" is the same omission — the dp shadow is `effects/depth`'s
and is drawn by the pattern, not by a bare `SurfaceAt` fill. The specimen was
re-rendered with the dialog's own outline and the sheet then reads as intended.

**2 — the card's painted footprint changed with the scheme: REAL, FIXED in this
task.** The seam was drawn as a `clip.Stroke` centred on the card's edge, so half
of it landed outside the card and the card's painted extent grew by a pixel on
every side in the scheme that owed a seam. It is now drawn as the card's own
rectangle in the seam colour with the raise laid back over it one pixel in, so
the hairline lands entirely inside the card's own bounds. Re-measured: card C is
300×172 in BOTH schemes.

**3 — the outlined card overhangs its filled sibling by a pixel: REAL, OUT OF
SCOPE, for BR1.7.** Same mechanism, but in the outlined branch, which this task
was told to leave alone and which BR1.7 removes outright — a card is raised, no
hairline of its own. Recorded here so the round that deletes that branch knows
the geometry moves when it does.

**4 — Δ1 compositing seams: NOT FIXED, pooled.** Sub-perceptual (1.004:1) and the
reviewer would not have filed it either. The useful half is the observation that
the outlined card composites its inner edge twice in the dark scheme; that is the
same outline branch as finding 3 and belongs with it.
