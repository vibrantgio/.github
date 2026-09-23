---
date: 2026-09-23
task: CG7.5
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG7.5 — mindchat's settings dialog read cold beside the platform's own sheet

One reviewer, having seen neither the plan nor the packet nor any source and
told not to go looking for one, was given four images at 1x and told which two
are the platform: mindchat's whole window with the settings dialog standing
open, in both appearances as this task left it (1024×768 each, rendered through
the app's own layers, the selected provider's key already answered for), and
`save-dialog-light.png` and `save-dialog-dark.png`. It was given the recorded
misreads — a dark label reads grey at 1x; a still shows no fade, no cursor and
no pointer feedback; alpha composites in sRGB; our window's three round buttons
are harness stand-ins; a pointer target is invisible in a still; the stored
captures were taken with the window shadow excluded, so the platform's own
sheet shadow is not in them; the dialog's position and shape and its leading
title are the owner's ruling and stay; the footer is measured and stays; the
dark sheet's fill and the toolbar greys were read on tinted captures and a
re-measurement is already scheduled — and it was told it could read the pixels
any way it liked, with Bash and PIL to hand. It was asked one question, with no
checklist: "Does this dialog read as a macOS sheet, and what is wrong with it?"

The two application images it was handed were rendered with the `+`/`−` pair
carrying the bordered control's drop shadow. That shadow is gone after the
review and nothing else in either image moved; the reviewer's own finding 3 is
what moved it, and the readings are recorded below as it made them.

## The reply, verbatim

> # Review — settings sheet against the macOS Save sheet
>
> ## Verdict
>
> The frame reads as macOS; the contents do not. Measured against the platform captures, the sheet's shell and its *standard* controls are close to exact — the corner profile matches the platform squircle to within 1–2px on every row of the arc, the push buttons are 74×24 in both with Cancel at `(236,236,236)` light and `(51,58,63)` dark (identical to the platform), the popup button is 24pt tall with the platform's `(236,236,236)`/`(51,58,63)` fill, the text field is 28pt against the platform's 27 with the platform's own `(243,243,243)`/`(44,51,56)` hairline, the label column is right-aligned to a single x (503) with a 10px gutter against the platform's 9, the row pitch is 38px against the platform's 38, and the label grey is `(128,128,128)` light / `(154,154,154)` dark — the Save panel's own secondary label colour, to the digit. The selection blue `(0,100,225)`/`(0,89,209)` and the green disc `(52,199,89)`/`(48,209,88)` are the platform's. The parent window is not dimmed, which is correct.
>
> What breaks it is that two of the controls come from a different design system entirely, and the type scale is not the platform's. At a glance this reads as a carefully built cross-platform dialog wearing a macOS frame.
>
> The strongest evidence needs no external reference: within this sheet's own control family — field 28, popup 24, buttons 24, list row 28 — the segmented control is 35 and the +/− control is 36. Those two are the outliers against the app's own measurements.
>
> ---
>
> ## 1. The segmented control is a different control in each appearance, and in light it is inverted
>
> Measured at x=600 and y=288:
>
> | | light | dark |
> |---|---|---|
> | track fill | `(255,255,255)` — identical to the sheet | `(38,38,38)` on a 30 sheet |
> | track border | none | `(64,64,64)`, 1px |
> | selected segment | `(229,229,229)` — **darker** than the track | `(73,73,73)` — **lighter** than the track |
> | shadow | sheet darkened 255→246, 31px below the control, ~14px above and left | 30→29, i.e. none |
> | height | 35 (y 270–304) | 35 |
> | selected pill | 82×24, radius ~10 (capsule) | same |
>
> Three separate problems stack here.
>
> **The light-mode polarity is backwards.** On macOS the segmented track is a light grey plate and the selected segment is the white, raised one. Here the track is invisible (pure white on a pure white sheet) and the selected segment is the only grey thing in the control — so the chosen tab reads as pressed or disabled rather than chosen. The APCA numbers confirm what the eye does: the tab labels are `(77,77,77)`, giving Lc 89 for the three unselected labels on white and **Lc 74 for the selected label on its 229 pill**. The selected tab is the lowest-contrast text in the sheet.
>
> **The two appearances are not the same design.** Light gets a shadow and no border; dark gets a border and no shadow. Dark is the better of the two and is roughly macOS-plausible; light is not. A control should not change its construction between appearances, only its values.
>
> **The geometry is 50% oversized.** 35pt tall with a full-capsule track and a capsule selection pill. The macOS regular segmented control is 22–24pt with roughly a 6pt radius, matching the popup button beside it. The app's own popup button, 24pt, sits directly below it and makes the mismatch obvious.
>
> ## 2. The +/− control is a floating capsule with a drop shadow
>
> Measured: 77×36, radius 18 (full capsule), fill `(255,255,255)` light / `(38,38,38)` with a `(64,64,64)` border dark, positioned **inside** the list panel at x 258–334, y 456–491, with the panel's 247 fill darkened to 238 beneath it and 242–246 above — a cast shadow.
>
> The macOS equivalent is a two-segment bordered control roughly 46×22, sitting *below* the table flush with its left edge, hairline-bordered, flat, with SF Symbol glyphs at ~11px. What is drawn here is a shadowed pill the size of a touch target, overlapping the list's own content area. Beyond the appearance, it is a functional defect: the panel is 228px tall and holds 28px rows, so with eight or more providers the capsule will sit on top of live rows.
>
> The glyphs are oversized to match — the plus is an ~18px 2px-stroke cross, against macOS's ~11px thin symbol.
>
> ## 3. Controls inside the sheet cast shadows
>
> The segmented control and the +/− capsule both cast soft drop shadows (measurements above). No control inside a macOS window casts a shadow — the window or sheet is the only thing in the compositing stack that does. This is the single clearest "not macOS" signal in the image, because it is the one that survives squinting.
>
> Worth saying that this is not a global effect the harness is applying: I probed directly under the Default-model popup at x=650 and the pixel at y=498 is `(255,255,255)` — a hard edge, no shadow. So the popup button is correct and the shadow is a per-control decision on the other two. That should make it cheap to remove.
>
> ## 4. The type scale is not the platform's
>
> Cap-height measured as ink rows for an unambiguous capital (O, N, S, F), so the numbers include one row of antialiasing:
>
> | | rows | ≈ size |
> |---|---|---|
> | platform — every label and every value | 10 | 13pt |
> | app — tab labels | 8 | ~11pt |
> | app — form labels, checkbox label, caption | 9 | ~12pt |
> | app — button labels | 10 | 13pt ✓ |
> | app — field values | 11 | ~14pt |
> | app — "Settings" title (2px stems) | 12 | ~15–16pt semibold |
>
> The platform sheet uses one size for labels, values, popup contents and buttons alike. This sheet carries four, and the damaging one is inside a single row: **"Name:" is two steps smaller than "OpenAI", the value it labels.** macOS never does this, and it is why the form reads big and loose next to the platform's tight, even rows. It also throws the baselines out — the platform baseline-aligns label and value exactly (both at y=224 on the Save As row); here "Name:" sits on 333 and "OpenAI" on 335, because the two are being centred in the row rather than baseline-aligned.
>
> Fixing this to a single 13pt for labels and values, with 11pt for the "2 chat models listed" caption, would do more for the macOS read than anything else on this list except items 1–3.
>
> ## 5. The list selection has square corners
>
> Measured: the blue rectangle is 138×28 at x 258–395 inside a 150px panel — a correct 6px inset on both sides — but the corner grid is solid at every one of the first eight rows. **Radius 0.** The macOS source-list selection is a rounded rect of about 5–6. The inset is right and the colour is exactly right; only the corner is missing.
>
> ## 6. The checkbox is a Material checkbox
>
> | | app | platform |
> |---|---|---|
> | box | 14×14 | 16×16 |
> | corner radius | ~1 (single softened pixel) | ~4 (three-pixel inset on the first row) |
> | construction | 2px hard outline, `(172,172,172)` light / `(136,136,136)` dark | filled rounded square, no hard outline |
>
> A 2px square stroke is the giveaway. macOS wants a 16pt rounded square with a hairline border and a faint inner shadow.
>
> ## 7. No section separators, and the footer is crowded
>
> The platform sheet carries two full-width 1px hairlines — `(230,230,230)` light / `(57,63,67)` dark at y=324 and y=479 — dividing it into fields, options and footer, and gives the button row a 65px band with 22px above the buttons.
>
> I scanned every row from y=498 to y=553 across the app sheet: no hairline anywhere. The bottom margin is right (20px below the buttons, against the platform's 20), but the gap *above* them is 13px — the popup button's bottom edge is at 497 and Cancel's top at 510. The buttons are pressed against the last form row with nothing separating them, so the footer does not read as a footer.
>
> ## 8. The sheet's own shadow has no vertical offset
>
> Measured on the app capture against a uniform `(204,204,204)` window background: above the sheet the peak is 189 at y=213 recovering to 204 by y=189 (24px); below, the peak is 189 at y=554 recovering to 204 by y=578 (24px). Identical peak, identical reach, top and bottom. Sides darken by 16–20.
>
> That is a uniform glow, not a cast shadow. No macOS window or sheet shadow is vertically symmetric — they are offset downward and are far heavier below than above, and considerably larger in radius than 24px at 1x. Stated with the caveat that the platform captures have their shadow excluded, so this one is measured from the app image alone.
>
> ## 9. Dark mode's greys are half-tinted
>
> Sheet `(30,30,30)` and field fill `(30,30,30)` are neutral, while field border `(44,51,56)`, popup and Cancel fill `(51,58,63)` and list panel `(42,48,52)` all carry a blue cast of 10–12 units between the red and blue channels. On the platform every one of those is tinted together — sheet `(35,42,47)`, border `(44,51,56)`, popup `(51,58,63)` — so they harmonise.
>
> This overlaps the known wallpaper-tint item, but the separable part is that the *borrowed* values were taken tinted and the *generated* ones were not, so the popup button currently reads as a faintly blue chip on a neutral sheet. Whatever the re-measurement lands on for the sheet fill, the family has to move together or this stays visible.
>
> ## 10. Nothing in the sheet has key focus
>
> I searched every pixel of the sheet for saturated blue: the only two regions are the list selection (x 258–395, y 298–325) and the Save button (x 698–771, y 510–533). There is no focus ring on any field. The platform sheet in the same still shows the Save As field focused, ringed, and its text selected — a macOS sheet always has a key view when it opens. Flagged with the caveat that a still could have caught the sheet before focus landed, but if there genuinely is no initial first responder, that is a defect the still is telling the truth about.
>
> ## 11. Smaller things
>
> - **Base URL's value is drawn at secondary grey** — `(128,128,128)` light, `(154,154,154)` dark, the same grey as the labels. If that is placeholder text it is too strong (macOS placeholder is tertiary, distinctly lighter); if it is a real value it is too weak. As it stands you cannot tell whether the field is filled, and it is the one field where that matters.
> - **The segmented control's left edge is at x=414 while the field column starts at x=514.** The two align only by accident with the longest label ("Default model:" starts at 415); against "Name:" at 465 the tab bar overhangs the label column by 51px. The form reads as two unrelated grids stacked.
> - **Button corner radius is 5 against the platform's 4** (measured from the flat-top run: the platform's blue starts 3 in on its first row and is solid by row 3; the app's starts 4 in and is solid by row 4). One pixel, mentioned only for completeness.
> - **The "Providers" list and the tab bar are two selectors on the same axis**, with different contents (2 items vs 4) and nothing labelling the difference. If the tabs are "available providers" and the list is "configured providers", that is legible logic but nothing in the sheet says so.
>
> ---
>
> ## What I measured and how
>
> PIL, direct pixel reads at 1x on all four files, no resampling except NEAREST for visual crops.
>
> Geometry by transition scanning — walking a row or column and printing every position where a channel changes by more than 2–3 units — which gives exact edges for the sheet (app x 232–791, y 214–553; platform x 165–534, y 188–544), every field, button, popup, panel and the selection. Corner radii by printing a thresholded ASCII grid of the corner and reading the first solid pixel per row. Text sizes by ink-row extents over a single isolated capital, printed as a glyph bitmap so I could confirm which rows were cap top and baseline rather than trusting a bounding box. Fills by `Counter` over a button or track interior so antialiased text pixels could not skew the modal colour — this is what corrected an early misread of the dark Cancel button as `(120,122,124)` when it is in fact `(51,58,63)`, matching the platform exactly. Shadows by sampling the background at increasing distance from each edge and comparing against the window background sampled far away (uniform 204 light), confirmed across four rows. Focus by scanning all 190,400 sheet pixels for `b - r > 50`. APCA computed from the standard formula on the measured sRGB greys.

## What was done with it

**The reviewer read this task's own result back as the platform's.** It measured
the label column right-aligned to one x with the gap to the field column beside
it, the row pitch, and the row label's grey as "the Save panel's own secondary
label colour, to the digit" — which is the pair CG7.2 laid out and `controls.md`
records off the sheet. It read the two hairlines and the footer band at exactly
the values this task recorded from the same captures.

**Finding 3's second half is fixed.** The `+`/`−` pair carried the bordered
control's drop shadow, and that shadow reached past the well's own foot onto the
sheet beneath it: a run down x=300 in the light render read the sheet at 246 at
y=498 recovering to 255 only by y=523, twenty-five rows of smudge between the
well and the footer. The shadow a bordered control casts is measured on a
TOOLBAR BAND, and the reason the templates' control above spends it is that its
fill is the light appearance's `#ffffff` standing on the sheet's own `#ffffff`.
The pair stands on the well's panel, a fill of its own, so it spends none. The
dark appearance never drew one.

**Finding 2's "with eight or more providers the capsule will sit on top of live
rows" is a misread.** The pair is a Rigid row under the list's Flexed one, so
the list is laid out in the height the pair leaves and the two cannot overlap;
a ninth provider scrolls inside the list, which carries the platform's overlay
scrollbar. Recorded for the next brief.

**Finding 10 is a misread of the harness.** The golden is a static frame
rendered outside a running window, so no view in it holds the keyboard and no
focus ring can be drawn. The dialog names its three fields as
`DynamicFocusTags` and opens with the keyboard on the first of them, which is
what the Modal entry asks; the still cannot show it. Recorded for the next
brief.

**Finding 1 is a reading against the stored reference, and the drawing stands.**
It repeats CG7.2's own reviewer to the pixel, and `controls.md`'s chosen-segment
section answers it the same way: the chosen segment's patch is DARKER than the
control's fill in the light appearance on the platform too, and the light
appearance draws no rim at all, which is `toolbarface.Capsule`'s measured
answer. The heights it reads — 35 and 36 against the sheet's own 24 — are the
genuine question, and it is the one pooled as 788.

**Findings 5 and 8 are settled and were not re-filed.** The owner ruled
2026-09-23 that a content list's selection is square on the platform (771 needs
no task), and a floating surface's own shadow is already on 425's capture list
(774).

**Finding 9 is the known tinted-plane reading**, 768 and 769 on 425's capture
list.

**Everything else is outside the task and pooled**: finding 7 as 787, findings 1
and 2's geometry as 788, finding 3's general half as 791, finding 4 as 792,
finding 6 as 793, and finding 11's four bullets as 794, 795, 797 and 798.
