---
date: 2026-09-17
task: CG3.3
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG3.3 — the sk150's readout panel read beside the meter

One reviewer, having seen neither the plan nor the packet, was given three
images: the owner's photograph of the meter's own lit display
(`reference/sk150-display.png`), and the sk150 window at 1x — 720×760, the
size the window opens at — in both appearances, on the Monitor tab with the
output on at 21 V and 7 A. One question: do these readouts read as the meter's
own display in the photograph, and what is wrong with them?

The recorded-misreads brief it was given: a dark label reads grey at 1x; still
captures show no fade or cursor; alpha composites in sRGB; the window controls
are harness stand-ins; the photograph is a camera capture of a lit segment
display, its colours saturated by the exposure.

The renders it read are the stored goldens this task added,
`workbench/sk150/testdata/golden/window-light.png` and `window-dark.png`,
taken after the readouts took the device's colours and before anything below
was acted on.

## The reply, verbatim

> I read all three at 1x and then magnified the display regions and measured glyph boxes and colours.
>
> **Short answer: the colour and the black slab read right; the typography and the number format do not. It reads as a terminal printing numbers on a black rectangle, not as the meter's segment display.**
>
> What is faithful
>
> - The emissive colours are an essentially exact match to the photograph: green digits sample to (43,244,47) against the photo's (43,247,47), yellow (254,251,67) vs (255,253,70), magenta (249,40,250) vs (250,40,251). Row order V/A/W, the per-row coloured unit letter, and the green CV badge with dark text above the V are all correct.
> - The display does not follow the scheme: panel #090905 and all three digit colours are pixel-identical in `window-light.png` and `window-dark.png`. That is the right call — a device face is a device face in both schemes.
> - The unit letters are consistently set: V, A and W all sit on the digit baseline (V bottom y=225 against a baseline of 225/226; A 302 vs 303; W 379 vs 380) with the same 13px gap from the last digit (digits end x=461, units begin x=474). No misalignment there.
> - Digits are genuinely monospaced on a 33.5px cell, so a changing value will not shift the row.
>
> What is wrong
>
> 1. **The power row breaks the device's format.** The meter shows a fixed four-digit field with a floating point: `21.00`, `7.000`, `147.0`. The app shows `147.000` — six digits, a resolution the instrument does not have, and it is exactly 21.00 × 7.000, so it is arithmetic rather than a read register. The cost is visible: the magenta row's leading `1` starts at x=234 while the two rows above start at x=298/299, so the power row juts 64px further left than everything else and the three rows no longer sit on one field. On the device all three rows occupy the same four cells and align on both edges.
>
> 2. **It is not a seven-segment face.** At 4x the digits are a rounded monospace text font: the zeros carry a diagonal slash through them, the `1` has an angled flag at top-left, terminals are round, and the decimal point is a round dot. The photograph is true seven-segment — mitred angular strokes with visible segment gaps, an open unslashed `0`, a `1` that is a bare right-hand vertical bar, and a square decimal point. This is the single largest reason the panel does not read as the meter.
>
> 3. **The rows are leaded like body text.** App digit height 42px on a 77px row pitch — a 35px gap, 83% of the digit height. On the device the digit height is ~95px on a ~104px pitch, a gap of roughly 10%: the three rows nearly touch and form one dense block. Related, the digits are about half the relative size they should be: ~29% of the panel height on the device, ~17% in the app. And the decimal point is given a whole 33.5px monospace cell for an 11px dot, so `21.00` reads as `21 . 00`; on the device the point is tucked into a narrow inter-digit gap.
>
> 4. **The left gutter is empty and the block floats.** The device puts indicators down the left — the buzzer icon and the yellow `ON` badge on the current row — and pins the numbers hard to the right against the unit column. The app drops both (output state now lives only in the window header, so the display itself gives no sign the output is live) and leaves a 111px right margin, so the readout ends up adrift in the middle of the slab instead of being a right-pinned field with an indicator column beside it.
>
> 5. **Dark scheme loses the screen's edge.** The panel is #090905 on a #1E1E1E window with no bezel or rim — a 21-step luminance step and rounded corners. On white it reads as a convincing black glass slab; on dark it is a faint rectangle. The device's display sits in a visible grey bezel with square corners.
>
> Minor: the colours match the photograph so exactly that they have inherited the camera's blown highlights — those are exposure-saturated values, not the display's true emission, so at these sizes on a white page the green and magenta read as neon.

## What was done with it

The reply confirms every part of this task's result and finds no fault in it.
It measured the three lit colours and the panel's black against the photograph
and found them an essentially exact match, read the row order, the per-row
unit letter and the CV badge with its black label as correct, and read the
panel's being pixel-identical in both appearances as the right call for a
device face. So nothing was changed in answer to it.

Everything it finds wrong is outside the result: a number format, a typeface,
a type scale, a composition, and the photograph the owner measured from. Each
is pooled.

- The power row prints `147.000` where the device shows `147.0`, so the three
  rows share no field and the magenta line juts 64 px left of the two above
  it. Pooled, 468. The format predates this task; the black panel is what made
  it visible.
- The digits are a rounded monospace text face where the device's are
  seven-segment — read as "the single largest reason the panel does not read
  as the meter". Pooled, 469. Typography is out of this task's result by
  ruling.
- The rows are leaded like body text, the digits are half the device's
  relative size, and the decimal point takes a whole monospace cell. Pooled,
  470 — all of it is the Code role blown up to 56 sp.
- The panel's left gutter is empty, the numbers float in the middle of it, and
  the output state lives only in the window header, so the display gives no
  sign the output is live. Pooled, 471. This task put the ON badge in the
  device's yellow where the badge already stood; moving it onto the panel is a
  composition ruling for the window.
- In the dark scheme the panel's black stands 21 levels off the window's plane
  with no bezel, so it reads as a faint rectangle where on the light window it
  reads as black glass. Pooled, 472 — it stands off the dark plane further
  than the chart panels beside it do, so the question is the window's dark
  plane as much as the panel's.
- The four values carry the camera's blown highlights and read as neon.
  Pooled, 473. The owner named these values from this photograph, so they
  stand until he measures otherwise.
