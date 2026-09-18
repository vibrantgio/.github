---
date: 2026-09-18
task: CG5.5
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.5 — the focused controls read cold beside the platform's focused field

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: the gallery's focus sheet in both schemes, as this
task regenerated it
(`components/gallery/testdata/golden/focus-{light,dark}.png` — five focused
controls on each of three surfaces), and the Save dialog's focused "Save As:"
field in both appearances, cropped from `save-dialog-{light,dark}.png`. It was
told which two are the platform's, and it was given the recorded misreads — a
dark label reads grey at 1x; a still shows no fade and no cursor; a coverage
composites in encoded sRGB; window controls in a harness rendering are
stand-ins; a pointer target is invisible in a still; an open menu belongs to
another task. It was asked one question, with no checklist: "Do these focused
controls read as the platform's keyboard focus, and what is wrong with them?"

## The reply, verbatim

> I read all four images and measured them with PIL. Short answer: the ring
> itself is convincingly platform-like — it is the wrong parts underneath it
> that break the illusion, and the button breaks the ring too.
>
> The colour law is right, and that is the part worth defending. The toolkit's
> ring is the accent composited at 50% over whatever it stands on, and it
> tracks the background exactly: light row 1 on white gives (128,179,250), row
> 2 on the (247,247,247) card gives (124,175,246) — half the 8-point
> background delta, as it should be; dark row 1 on (30,30,30) gives
> (28,99,142), row 2 on (42,48,52) gives (34,108,153), again exactly half.
> Back-solving the accent out of those gives (1,103,245) light and
> (26,168,254) dark. The real Save dialog back-solves to (19,109,241) and
> (41,172,253). That is a close enough match that nobody will catch it by eye,
> and the width matches too: the platform band is 4px at 1x (x=82–85 either
> side of the field), and so is the toolkit's on the field, checkbox, chip and
> pop-up.
>
> Now the problems.
>
> The band is built the wrong way round. On the platform the four pixels are
> not flat — light reads (140,184,248), (137,182,248), (131,176,242),
> (137,182,248), and dark reads (38,105,147), (38,107,150), (42,112,154),
> (38,107,150). The third pixel is the strongest in both, because macOS draws
> the control's own edge stroke in accent and haloes it on both sides; the most
> saturated pixel in the ring sits exactly on the control's boundary and points
> at it. The toolkit inverts that. Its outer 2px are the clean 50%-over-background
> blue and its inner 2px are the same stroke composited over the control's own
> fill — on the pop-up and the chip the inner band measures (118,170,240) and
> (115,167,237), which is precisely 50% accent over their (236,236,236) body.
> So the stroke is centred on the control edge, 2px out and 2px in, and the
> effect is that the ring's strongest pixel is the one furthest from the
> control while the boundary itself is where the ring goes muddy. At 1x the
> chip in particular reads as a pill with a bevelled blue edge rather than a
> pill with a ring around it.
>
> The button is the real failure. Its ring is 2px, half of every other control
> on the sheet: at x=175 the light band is y=14–15 on top and y=40–41 on the
> bottom, then (0,113,250) for two more rows — and (0,113,250) is 50% of the
> ring accent over the button's own (0,122,255) fill, to the unit. In other
> words the inner half of the ring landed on accent and dissolved, so the one
> control whose fill is already the accent colour ends up with the weakest
> focus indicator on the sheet. In dark it is worse: a 2px (28,99,142) rim
> around a (0,122,255) fill reads as a shadow or an antialiasing artefact, not
> as focus. macOS does not have this problem because the ring is drawn outside
> the button's frame, so a focused default button keeps the full-width band;
> here the geometry eats it.
>
> The checkbox has no bezel. It is a 12px white square with a 4px ring and
> nothing else — pixel-for-pixel the same construction as the text field, just
> smaller. Put the two side by side in the light sheet and the focused checkbox
> is indistinguishable from a miniature focused text field, because the focus
> ring is doing the job the checkbox's own border should be doing. The platform
> keeps the checkbox's bezel under the ring, so a focused checkbox shows two
> concentric edges and still reads as a checkbox.
>
> The text field has no fill of its own. On the card and chrome rows its
> interior measures (247,247,247) — identical to the row background. It is a
> hole with a blue outline. The checkbox eight pixels to its right paints
> (255,255,255) on that same card, which proves the toolkit has a field-surface
> value and simply does not apply it to the field. The macOS Save-As field is a
> white well whatever the sheet behind it is doing. The dark sheet shows the
> same incoherence from the other side: the field interior is the background,
> the checkbox interior is a neutral (30,30,31), and the chip and pop-up are a
> blue-tinted (51,58,63) — three different surface treatments across four
> controls that should share one.
>
> The pop-up button is not a macOS pop-up button. It is a flat (236,236,236)
> slab with no border, no shadow, and its indicator is a 4×8 dark-grey diamond
> at (55,55,55) sitting on that same grey; at 1x the two chevrons merge into a
> blob with a hole in it. The platform puts two separated chevrons in white on
> an accent-blue rounded badge at the trailing edge, which means a focused
> pop-up on macOS carries blue in two places and reads as live. Here the ring
> is the only blue on the control and the grey body underneath reads disabled —
> a focus ring around something that looks switched off.
>
> One thing about the sheet itself, since it is the instrument: in light mode
> "On a card" and "In the chrome" are both (247,247,247), byte-identical. Two
> of the three rows are the same test, so the light sheet only ever proves the
> ring on two backgrounds, not three. In dark they do differ, (42,48,52)
> against (28,28,28).
>
> Minor, for completeness: the toolkit's focused field box is 32px tall outside
> the ring against the platform's 30, and its outer ring corner radius is about
> 6px against the platform's 7–8, so the toolkit's field is a touch taller and
> a touch boxier than the thing it is imitating.

## What was done with it

**The colour and the width are confirmed, independently.** The reviewer
back-solved the indicator out of the rendered sheet and landed
`keyboardFocusIndicatorColor` at its own 127/255, and read the platform's band
at four px — the same two numbers this task read column by column off the
capture and recorded in `controls.md`. The confirmation is worth as much as the
complaints: two instruments, one answer.

**"The band is built the wrong way round" is half a misread and half a real
finding.** The platform's third pixel is not a stronger coverage: the shift
from its neighbours is −6 on every channel alike in light, and a coverage
change through `#0067f4` cannot move red by nothing, green by 152·Δ and blue
by 11·Δ in equal steps. A uniform shift on all three is a change of GROUND,
and the ground at x=264 is the field's own `#f3f3f3` edge column, which the
"Tags:" field below reads unfocused. So the platform's band is one coverage
throughout and the third pixel is that coverage over the control's own edge —
which is exactly what a band straddling the box does, and is why the library
draws it that way. The real half is the consequence the reviewer then names:
where a control's fill is NOT its surface, the two halves of the band land as
two values and the band reads two-tone. Pooled with the next item, which is
the same root.

**The button's dissolved half is real and is not settleable from the stored
reference.** `keyboardFocusIndicator` is the accent at 127/255, so over an
accent fill it composites to within nine of 255 of that fill and half the band
disappears — measured here, not argued. What the platform does instead cannot
be read: no stored capture holds a focused push button, and the two focused
controls the reference does hold disagree about placement (the dialog field
straddles its box; Voice Memos' toolbar search recess puts its whole band
outside its fill, read column by column in this task). Filed as 651 and 652,
and the capture that closes it is added to `controls.md`'s open list.

**The checkbox's vanished bezel is the same root.** The box's edge is one px
and the band's inner half is two, so the edge reads only as a six-of-255 shade
under the band. Filed with 652.

**The field's interior is a recorded answer, not a defect.** `control.FieldFill`
is measured: the Save dialog's unfocused "Tags:" field reads its sheet's own
fill in both appearances — `#ffffff` light and `#232a2f` dark — where the
platform's text background is `#1e1e1e` dark. The dark reading is what settles
it; a field filling itself with the text background could not land `#232a2f`.
The reviewer's "the macOS Save-As field is a white well whatever the sheet
behind it is doing" is true only of a white sheet. The three fills across four
controls are likewise three platform names — the field's surface, the
checkbox's text background, the chip's and pop-up's push-button fill — and not
one treatment applied three ways.

**The pop-up's mark is a real shortfall and is CG5.1's number.** The reference
reads the pair at 8 × 11 with a one-px gap and a ≈1.5 px stroke; the sheet
draws 8 × 9 with four-row chevrons and a thinner arm, which is what makes them
merge at 1x. Filed as 653. The accent badge the reviewer describes is a second
macOS pop-up drawing the reference does not hold — the Save dialog's File
Format pop-up carries grey chevrons on its own fill and no badge — filed as
654 rather than acted on.

**The field's height is already answered.** The reviewer reads 32 outside the
band against the platform's 30, which is the field drawn at 28 against the
Save dialog's measured 27. `theme/tokens/density.go` records that overshoot:
a height is `max(floor, lineBox + 2×PaddingY)`, BodyLarge's line box plus
Comfortable's padding is 28, and the scale does not move a typography role to
close one dp. Nothing filed. The corner is answered by construction: the band is stroked on
the control's own six-dp path, so its outer arc is eight and its inner four; a
circular fit at 1x to a four-px band reads between them.

**The sheet's light rows 2 and 3 really are one test.** `CardFill` and
`SidebarMaterial` are the same `#f7f7f7` in the light appearance, so the
platform gives the sheet two fills there and not three. Filed as 655 rather
than papered over by choosing a fill the platform does not name.
