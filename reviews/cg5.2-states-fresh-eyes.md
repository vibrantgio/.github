---
date: 2026-09-18
task: CG5.2
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.2 — the controls' hover and switched-off states read cold beside the platform's

One reviewer, having seen neither the plan nor the packet nor any source, was
given the gallery's button, chip, picker and text-field specimens at 1x in both
appearances and `components/picker`'s eight field-state images — rest, under the
pointer, held and switched off in each appearance — beside three platform
captures: the Finder toolbar control under the pointer in
`control-hover-{light,dark}.png`, the held Cancel push button in
`control-pressed-{light,dark}.png`, and the Save dialog's two switched-off
checkboxes beside its enabled pop-up in `save-dialog-{light,dark}.png`. One
question: do these controls' hover and disabled states read as the platform's,
and what is wrong with them?

The recorded-misreads brief it was given: a dark label reads grey rather than
black at 1x; a still capture shows no fade and no cursor, and a pointer target
is invisible in one; alpha composites in encoded sRGB and not in linear light;
window controls in a rendered image are harness stand-ins; the focus ring and
the open menu are other tasks' work and not this one's.

## The reply, verbatim

I read all 22 images and sampled them with PIL. Here is what they say.

## The short answer

Disabled reads as the platform's, essentially everywhere. Hover reads as the platform's in light appearance and is broken in dark appearance — in dark, hover is painted at the pressed fill, so hover and press are the same colour on every control family shown.

## Ranked findings

**1. In dark appearance, hover and pressed are the same pixel value. (Worst by a wide margin.)**

`field-dark-hovered.png` fill is (70,77,81); `field-dark-pressed.png` fill is (71,77,82). A whole-image difference of the two files gives a maximum of 2 in one channel across 4,700 changed pixels — invisible. The same collapse appears in every family:

- `gallery-buttons-dark.png`, the accent button: Hover (24,135,255), Press (25,135,255).
- `gallery-chips-dark.png`, unselected row: Hover (70,77,81), Press (71,77,82).
- `gallery-chips-dark.png`, selected row: Hover (24,105,213), Press (25,105,214).

Two consequences, both bad. Pressing a control in dark gives no feedback at all — the fill does not move. And merely putting the pointer over a control in dark shouts as loudly as holding it down, so a dark window under a moving pointer looks like something is being clicked.

The diagnosis is visible in the numbers. Light places hover 52% of the way from rest to press: 236 → 224 → 213, i.e. 12 of 23. Dark places it at 95%: (51,58,63) → (70,77,81) → (71,77,82), i.e. 19 of 20. The accent button is the same story, 13/25 in light versus 24/25 in dark. The dark hover step is not a random wrong number — it is close to the platform's own hover step (`macos-hover-dark.png`: toolbar (36,45,50) → hovered fill (56,65,70), +20). But on the platform that step is applied to a *toolbar* control whose rest state has no fill at all. Applied instead to a pop-up that already carries a rest fill of (51,58,63), the same +19 lands squarely on the pressed value. The step was lifted from the wrong starting surface.

**2. The disabled text field has no body in light appearance.**

`gallery-textfields-light.png`, rightmost field: the interior is 255 — identical to the page — and the only thing drawn is a 247 hairline, 8 levels off white. The platform's disabled control keeps a visible body: in `macos-disabled-light.png` the two switched-off checkboxes are a solid 242 fill on 255, 13 levels, with no separate stroke. So where macOS dims a control, this makes it disappear. It is also barely distinguishable from its own rest state — the rest field's border is 243 and the disabled one's is 247, a 4-level difference; the only real signal that it is off is the placeholder going 128 → 192. The picker and the button do this correctly (see below); the text field does not.

**3. Two small inconsistencies in the dark disabled treatment.**

`field-dark-disabled.png` fill is (44,49,52) against the platform's (46,52,57) in `macos-disabled-dark.png` — slightly darker and noticeably flatter, having lost most of the cool tint. Part of that is downstream: the gallery's dark ground is a neutral (30,30,30) where the macOS dialog is (35,42,47), and the disabled fill is a blend toward that ground, so a neutral ground bleeds the tint out. Separately, the disabled text colour is not consistent between controls: the pop-up's disabled label and chevron are (96,100,102), cool, a good match for the platform's (89,95,98); but the disabled placeholder in `gallery-textfields-dark.png` is a flat neutral (86,86,86). Two different disabled-text colours in one toolkit.

**4. Hover is unevidenced for two controls.**

Neither `gallery-pickers-*.png` nor `gallery-textfields-*.png` has a hover column — the columns are Closed / Focused / Open / Disabled / Toolbar and Rest / Focused / Disabled. Hover is only shown for the pop-up, in the separate `field-*-hovered.png` pair. That leaves the toolbar-variant picker (rightmost in `gallery-pickers-light.png`, the bordered "Apple ⌄" capsule) with no hover evidence at all — and that is precisely the case `macos-hover-light.png` documents, where the rest control carries no fill and hover makes a 242 fill appear from nothing. I cannot say whether that one is right or wrong from these images.

## What reads right

Quite a lot, and it is worth saying plainly: every state in this set that has a platform anchor matches to the pixel.

- **Light hover is correct.** `field-light-rest.png` 236 → `field-light-hovered.png` 224 is a −12 step; the platform's own hover in `macos-hover-light.png` is 255 → 242, −13. Same magnitude, same direction, and it leaves all three states cleanly separable.
- **Pressed is exact in both appearances.** `field-light-pressed.png` is 213,213,213 and `macos-pressed-light.png`'s held Cancel button is 213,213,213. `field-dark-pressed.png` is (71,77,82) and the held Cancel in `macos-pressed-dark.png` is (71,77,82). Identical.
- **Rest is exact in both.** 236 light and (51,58,63) dark are the enabled "Script" pop-up's fills in the two `macos-disabled-*.png` captures.
- **Light disabled fill is exact.** `field-light-disabled.png` at 242 is the macOS disabled checkbox fill, 242, on the same 255 ground. The disabled label at 182 against the platform's 189 is close enough to read the same.
- **Dark disabled text is right.** (96,100,102) against the platform's (89,95,98).
- **Enabled label colour and control geometry match.** Label 36,36,36 light and (224,225,226) dark are the platform's values exactly, and the pop-up is 24px tall at 1x in both — `macos-disabled-light.png`'s pop-up spans y11–34, `field-light-rest.png`'s spans y12–35.
- **Disabled changes only fill and text**, with no border or shadow appearing or vanishing, which is what the macOS captures show too. The pop-up is a flat fill with no stroke in both appearances, matching the platform's.

The fix implied by all this is narrow: the dark hover fill is the only value in the set that was not read off the platform correctly, and it needs to sit around halfway between the dark rest and dark pressed fills — near (61,68,72) for the pop-up and chip, and the corresponding midpoint for the accent button — the way light already does.

## What was done with each finding

**1, the dark hover and press collapsing onto one value.** Confirmed off the
same pixels before the review ran, and pooled rather than fixed. The reading it
rests on is the platform's own: `hoverOverlay` dark is white at 24 of 255 and
`pressOverlay` dark white at 25, each reproducing its own capture on every
channel, and the reviewer's own numbers show the two captures agree with the
component. The step the reviewer proposes — a dark hover near (61,68,72), the
midpoint — is not in any stored capture, and an unmeasured number is not one
this library may paint. What the reference cannot answer is whether the platform
draws a weaker hover on a control that already carries a bezel than on the
fill-less toolbar control the dark overlay was read from; one control captured
under the pointer and held would settle it, and that capture is now on the
list. Filed as a bug with both readings, and the disagreement between the two
appearances — the light pair standing at a ratio of 1.9 and the dark pair at
1.04 — is recorded in `controls.md` beside the numbers.

**2, the switched-off text field reading as an absence in light.** Pooled. The
field's interior is the surface it stands on and not a fill of its own, which is
itself a measurement off the same Save dialog, so there is no body to fade; what
this task faded is the hairline, from twelve levels off white to eight. The
reviewer is right that what is left saying the field is off is the prompt. No
stored capture holds a switched-off text field, so the rule cannot be corrected
from the reference as it stands.

**3, the dark switched-off fill's lost tint.** Confirmed and already filed: the
dark push button fill was measured over a wallpaper-tinted plane and carries that
cast against an untinted window, which is a standing pool item four reviewers
have now found independently. The second half — two different greys for switched-off
text — is the platform's own model rather than a defect: both controls spend
the platform's one name for switched-off text, and a coverage lands differently
on the trigger's cool fill than on the window's neutral plane. It is the same
tinted-capture item underneath, and nothing new was filed for it.

**4, no hover specimen for the picker or the field in the gallery.** Pooled. The
chrome-variant trigger does take the overlay and has carried hovered goldens of
its own since before this task, so the reviewer could not see a state that is
drawn; the gallery's picker row has no room for two more cells at the page's
width. A text field that tints under the pointer is unmeasured and was not
given one.

Nothing the review found was fixable inside this task's evidence, and nothing
in it contradicted a number the task set.
