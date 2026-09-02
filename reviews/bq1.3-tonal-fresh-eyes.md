---
date: 2026-09-02
task: BQ1.3
phase: BQ
reviewer-model: unrecorded
reviewer-effort: unrecorded
---

# BQ1.3 fresh-eyes review — the Tonal button on the badge's tint

## What the reviewer was given

Two images and nothing about the task: the components gallery's own goldens
after the collapse, `components-light.png` and `components-dark.png`
(900x2659 each, rendered offscreen — no window was opened on the owner's
screen). Each carries the button row and the badge rows in one frame, which
is the pairing the ruling is about.

It was told which two rows to look at, that it could sample pixels if it
wanted to be sure, and one recorded misread — dark ink reads grey at 1x. It
was given two questions and no checklist: do the Tonal button and the badges
read as the same tint, and does the Tonal button still read as a button. It
was told to say plainly if either read fine and not to manufacture findings.

## Verbatim reply

> I read both PNGs and then verified the colours numerically (PIL is available in this environment, so nothing below is an unverified visual guess unless I say so).
>
> ## A. Tonal button vs badges — same tint?
>
> **Yes, in both schemes — the same recipe, to two decimal places.** This is not a "looks about right" judgement; the numbers line up exactly.
>
> Light scheme, sampled fills and label glyph cores:
>
> | specimen | fill | Oklch L / C | label | label-on-fill contrast | fill-vs-page contrast |
> |---|---|---|---|---|---|
> | Tonal button | `#D7CFF7` | 0.874 / 0.055 | `#6F36D1` | 4.53 | 1.37 |
> | Badge Neutral | `#D4D4D4` | 0.870 / 0.000 | `#5C5C5C` | 4.51 | 1.37 |
> | Badge Success | `#BBDDBE` | 0.864 / 0.056 | `#006B24` | 4.54 | 1.37 |
> | Badge Warning | `#E7D2AC` | 0.872 / 0.055 | `#944600` | 4.53 | 1.37 |
> | Badge Error | `#F9C9C4` | 0.876 / 0.055 | `#B12226` | 4.54 | 1.37 |
> | Badge Info | `#BAD8F8` | 0.871 / 0.055 | `#005DA8` | 4.56 | 1.36 |
>
> Dark scheme, same story one step down: fills all Oklch L 0.295–0.308 with C 0.054–0.055 (Tonal `#312A48` at L 0.307, C 0.054), every fill sitting at 1.31–1.32 against the `#181818` band, Tonal at 1.32. Labels all Oklch L 0.83–0.85.
>
> So the fill is a constant-lightness, constant-chroma tint rotated by hue, the label is the same hue pinned to a fixed contrast ratio against it, and the Tonal button is drawn from that identical generator with the primary hue plugged in. Neither one obeys a different rule. The only thing that varies between specimens is hue and the gamut ceiling that hue imposes on the label's chroma (purple can carry C=0.220 at L≈0.5, green only 0.136) — that is physics, not an inconsistency.
>
> **Calibration check, since you warned about it:** the Tonal label reads as a muted grey-violet at 1x, but `#6F36D1` is Oklch C=0.220 — the *most* saturated label anywhere in either row, and byte-for-byte the same colour as the Filled button's fill. I would have called it washed out from the visual read alone. It isn't.
>
> ## B. Does the Tonal still read as a button?
>
> **Yes, in both schemes — but it is geometry doing the work, not colour.**
>
> The plate's separation from the page is 1.37:1 (light) / 1.32:1 (dark), which is precisely a badge's separation. As a *field*, it carries no more visual weight than the word "Info". What makes it a button is that it is the same footprint as Filled — same height, same corner radius, same padding, shoulder to shoulder in the row — and its label is the primary hue rather than a neutral. In the light crop it is an unmistakable lavender slab; in the dark crop the plum plate is equally legible against `#181818`. I did not have to hunt for either edge. It reads as the middle rung of a three-step ladder, which is what it is.
>
> If the intent were for Tonal to survive on a busier surface, or at a smaller size, that 1.35:1 plate would be worth worrying about. Standing in this row at this size, it holds.
>
> ## Things that bother me anyway
>
> **1. The Ghost button's label is neutral grey, not the brand hue.** Light `#5C5C5C`, dark `#CCCCCC` — zero chroma. In light it is *byte-identical* to the Neutral badge's label colour. Filled and Tonal both carry the purple; Ghost drops it entirely, so next to them it reads as a caption sitting in the row rather than the third emphasis step of the same control. It looks less like a low-emphasis button than like the word "Ghost" labelling the empty slot where a third button would go. I can't tell from the image whether that's deliberate, but it is the one thing in that row I'd want a ruling on.
>
> **2. Dark scheme: the Neutral badge is the odd one out.** Its label sits at 4.89:1 against its fill while Success, Warning, Error and Info all sit at 8.40–8.48:1. In the light scheme all five agree at 4.51–4.56:1. So the asymmetry is dark-only, and it is visible: the word "Neutral" reads perceptibly dimmer than its four neighbours (Oklab L 0.689 vs 0.83–0.85 for the rest). Given how exactly everything else in these two rows agrees, this looks like an oversight rather than an intentional de-emphasis.
>
> **3. Not a defect — checked and cleared.** "Filled" looks noticeably bolder than "Tonal" and "Ghost" in the light scheme. It isn't: measured ink density is 0.419 / 0.406 / 0.392, and in dark 0.386 / 0.375 / 0.392, with identical glyph bounding-box heights. That is white-on-dark bloom at 1x, same class of artifact as the one in your calibration note.

## What was done with it

Both questions came back yes, and the reviewer's own sampling is the
strongest evidence the collapse landed: it measured six specimens off two
images and found one generator behind all of them, without being told there
was one to find.

Nothing was fixed in this task; the two complaints are both outside the
Tonal button.

- Finding 1 sharpens open ruling 236, which already has the Ghost variant
  reading as unstyled text. The new fact is that its label is byte-identical
  to the Neutral badge's in light, so the row's third step drops the brand
  hue its two neighbours carry. Recorded on 236 rather than pooled again.
- Finding 2 is new and pooled as 241: the dark Neutral badge's foreground
  sits at 4.89:1 where its four status siblings sit at 8.4:1, because the
  statuses answer with a pinned base that overshoots the floor and neutral
  answers with a walk that stops at it.

Finding 3 the reviewer cleared itself, and it is another instance of the 1x
ink-density misread — worth carrying into the next review packet.

Two findings of this task's own measurement were pooled beside them: 242,
the walked label (the pressed Tonal label falls to 4.26:1 with the default
seed, under the floor its resting state clears), and 243, the light focus
ring landing byte-identical to the Tonal label it circles. Open ruling 124's
recorded measurement was corrected in place — dark Tonal is a low-chroma
tint now, not a saturated container — without touching what it asks.
