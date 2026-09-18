---
date: 2026-09-18
task: CG5.3d
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3d — a labelled checkbox row read cold beside the save dialog's Options rows

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: the component gallery's labelled checkbox and radio
row in the light and the dark appearance, and a crop of the stored
`save-dialog-{light,dark}.png` holding the two "Options:" checkboxes with
their labels, which is the capture every number in this task was measured
from. It was told what the specimens are, given the recorded misreads —
a dark label reads grey at 1x; a still shows no fade and no cursor; a
coverage composites in encoded sRGB; window controls are harness stand-ins;
a pointer target is invisible in a still; keyboard focus is a later task's —
and asked one question:

> Does this labelled checkbox row read as the platform's, and what is wrong
> with it?

## The reply, verbatim

I measured the pixels rather than trusting my eye. Short answer: no, it doesn't read as the platform's. The colour tokens are right and the vertical centring is right; the control geometry and the type are not, and the unchecked state is effectively not drawn at all.

**The enabled unchecked checkbox is fainter than the platform's disabled one.** In the gallery, "Show startup screen" is a 16×16 box drawn as a 2px outline at #F3F3F3 on #FFFFFF with a white interior — a 12-level step out of 255. In the reference crop, the *switched-off* checkbox next to "Show startup screen" is a solid #F2F2F2. So your live, clickable control is painted lighter than macOS paints a dead one. Dark is worse: the gallery's unchecked box is a 2px #2C2C2C outline on #1E1E1E — 14 levels — while its own "Switched off" box is a solid #2C3134. Same luminance, 44 vs 44. Put the first and third specimens side by side in that row and the only thing distinguishing an operable checkbox from a disabled one is the label colour. macOS draws the unchecked enabled box as a filled well with a visible border and a bottom edge; it is always legible as a target.

The reason the hierarchy inverts is that the two states use opposite drawing models: enabled is border-with-no-fill, disabled is fill-with-no-border. macOS draws the same control at reduced contrast. Your disabled fill (#F2F2F2 light) matches the reference exactly, which proves the palette is fine and the drawing is not.

**Every box in the row is a square, not a rounded square.** Corner radius measures ~1px — the corners soften by a single antialiased pixel (row 15 reads 251 at the corner, then 243 across). The reference, at the identical 16×16 footprint, has radius ~3.5px: its top row of fill starts 3px in, the next 2px, the next 1px. This is the single most recognisable thing about a macOS checkbox and it's absent from all five specimens, the radios included. The border is also 2px solid where macOS uses a 1px hairline, so the little edge that exists reads coarse.

**The labels are not the system font at the system size.** "Show startup screen" — the same string in both images — is 146px wide in the gallery (x38–183) and 124px in the reference (x96–219): 18% wider. Cap height 13px vs 11 ('S' spans y17–29 against y20–30); x-height 10px vs 7 ('o' spans y20–29 against y23–29). The heights grow 1.3–1.4× while the widths grow only 1.18×, so this is not SF at a larger point size — it's a different face with a taller x-height on tighter advances. Meanwhile the colours are dead on (#272727 enabled / #BDBDBD disabled in light, #DDDDDD / #565656 in dark, all matching the reference exactly), which only makes the size mismatch louder.

**The label crowds the box.** 5px from box edge to first label ink, against 6px in the reference — and with oversized type in that 5px it reads tighter still. The radio uses 6px while the three checkboxes use 5, so the row isn't even internally consistent.

**The accent is flat and doesn't move between appearances.** The checked checkbox and the chosen radio are #007AFF in light *and* dark, one flat value across the whole fill. macOS brightens the accent in dark appearance (#0A84FF) and, in light, fills the control with a slight vertical gradient plus a darker bottom edge. A single flat iOS-blue tile in both appearances is the giveaway.

**The checkmark is spindly and jammed against the walls.** Effective stroke ~1.5px — the upper arm is largely antialiasing (its pixels read 178,196,255 and 169,190,255, never solid white), with square-cut terminals. It spans x214–225 inside a box of x212–227, i.e. 2px of inset on each side. macOS's tick is heavier, has rounded caps, and sits with visibly more air inside the box.

**The row's spacing puts the break in the wrong place.** Label-end to next-box-start runs 29px, 66px, 28px, 29px. The 66px hole falls between two checkboxes ("Stay open after run" → "Switched off"), while the checkbox-to-radio transition — the one boundary that deserves a group break — gets 28px. It reads as a layout accident, and it groups the specimens by the wrong axis.

One coverage gap worth noting: the row shows a chosen radio and a switched-off radio, but never an enabled unselected one — which is exactly the state that would expose the same invisible-well problem on the radio side.

## What was done with each finding

**The label crowds the box — fixed, and it was this task's own defect.** The
gap had been spent as an origin one column short of the reading, by
`control.TextLeadDp`'s rule: what a control spends is the origin, and a face
adds its first glyph's bearing to it. That rule holds where the capture shows
the platform's origin — the field's selection fill stands behind its value and
the bearing can be told from it — and it does not hold here, where only the
covered columns are visible. The gap is now the measured six spent to the
first covered column, so the capture's own labels, which begin with an S the
body role's face bears no column on, are covered column for column. The
reviewer's second reading is the same point from the other side: the radio's
"Chosen" begins with a C that does bear a column, which is why it drew one
wider than the checkboxes beside it. That difference is the face's and
survives; what changed is which letter lands on the platform's column.

**The row's spacing and the missing unselected radio — fixed.** The break
between the two families is now wider than the break inside one, so the row
reads by family, and an enabled unselected radio stands in it. The 66 px hole
the reviewer measured is not in the image: the column runs are 28, 28, 27, 28
px from label end to next glyph start. The misread has a cause worth keeping —
the switched-off checkbox between them is so faint on white that its box can
be missed entirely, which is the reviewer's own first finding read back.

**The enabled unchecked box fainter than the switched-off one — pooled, 569.**
The drawing models are opposite by construction and no stored capture holds an
enabled checkbox, which `checkbox.go` says in place. Not this task's, which
moves no glyph.

**The corner radius and the 2 px edge — pooled, 570.**

**The type a sixth larger than the platform's — already filed as 494,**
confirmed here independently from a fifth capture and not refiled. Typography
did not move in this task and the label takes the body role the field's prompt
takes, whose declared cap band is 11.375 px against the capture's 11.

**The accent flat and unmoved between appearances — pooled, 571.**

**The check mark's weight, caps and inset — pooled, 572.**
