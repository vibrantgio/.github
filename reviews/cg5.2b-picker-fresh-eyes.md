---
date: 2026-09-18
task: CG5.2b
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.2b — the picker's two triggers read cold beside the platform's pop-up and toolbar controls

One reviewer, having seen neither the plan nor the packet nor any source, was
given the gallery's picker row at 1x in both appearances — the form trigger at
rest, under the pointer, held, focused and switched off, then open under its
menu beside the chrome trigger at rest and under the pointer — with five
platform crops: the Finder toolbar's view pop-up and group pull-down in
`finder-window-{light,dark}.png`, a bordered toolbar control on its band in
`finder-window-untinted-dark.png`, and the Save dialog's "File Format:" pop-up
in `save-dialog-{light,dark}.png`. One question: do these two triggers read as
the platform's pop-up and toolbar controls, and what is wrong with them?

The recorded-misreads brief it was given: a dark label reads grey at 1x; a
still shows no fade, no animation and no cursor; alpha composites in encoded
sRGB; a pointer target is invisible in a still; window controls and
surrounding chrome are harness stand-ins; the open menu's own drawing is
CG5.4's and the focus ring CG5.5's, neither under review.

The renders it read were taken after this task's change landed and before its
one fix: the marks one colour in both variants, the chrome trigger carrying
the measured toolbar control fill in a capsule, the mark at its measured size
in both, and both triggers' line boxes capped to the control's height.

## The reply, verbatim

> # Picker triggers vs. the macOS pop-up and toolbar controls
>
> **Yes for the form trigger — it is the platform's pop-up button very nearly to the pixel. No for the toolbar trigger: it is the form trigger in a capsule, not a toolbar control.**
>
> ## What is right
>
> Measured against `save-popup-*.png`, the form trigger is a near-exact reproduction:
>
> - **Box**: 24 px tall in both; corner is a continuous (squircle) curve, not a circular arc — the inset from the straight edge runs 3.1 / 1.9 / 0.9 / 0.5 / 0.2 / 0.0 px down the arc on the specimen against 3.2 / 1.8 / 0.9 / 0.6 / 0.3 / 0.16 on the platform. No border, no shadow, in either appearance — same as the platform.
> - **Fills**: light `(236,236,236)` on both. Dark `(51,58,63)` on both.
> - **Label ink**: light darkest `(36,36,36)`, dark lightest `(224,225,226)` — identical values to the platform captures.
> - **Chevron**: the pick-one up/down pair, not the pull-down's single `v` — correct for this component, and it matches Finder's view pop-up too. 8×11 px against the platform's 8×11 (Save) / 9×11 (Finder), 9 px from the right edge in both, and sitting the same 0.5 px below the box's vertical centre. Label left inset 11 px against 12.
> - The toolbar variant is a **true capsule**, r = 12 on h = 24 (arc fits a 12 px circle within 0.5 px) — the right shape family for chrome. Its dark values are close to the untinted Finder reference: fill 38 on band 28 with a 59 rim, against the platform's 38 on 30 with a 64 rim.
> - Focus leaves the fill untouched, and hover/press/disabled move the same direction in both appearances.
>
> ## What is wrong
>
> **1. Dark has no press state.** Across the whole 164×28 trigger box, Hover `(70,77,81)` and Press `(71,77,82)` differ by at most 2 levels anywhere; 3802 of 4592 pixels differ by exactly 1. APCA Lc between them is 0.0. Light does it properly — 236 → 224 → 213, even −12 / −11 steps. The dark specimen shows four states where light shows five.
>
> **2. The toolbar trigger is a third too short.** Every toolbar control in all three Finder captures is **36 px** tall (fill spans y 6–41 untinted, y 8–43 tinted and light). The specimen's is **24 px** — the form trigger's height with the corner radius turned up. Toolbar metrics were not adopted, only the silhouette.
>
> **3. The light toolbar trigger has a border the platform does not draw.** Specimen: a 1 px ring at `(230,230,230)` all the way round, fill 255 on band 247 — 17 levels *darker* than the band. In Finder light, the white pill meets the band with no darker pixel anywhere (band 248–252 straight to fill 255, on both controls). macOS strokes this pill only in dark, and there the rim is *lighter* than the fill (untinted: rim 64, fill 38, band 30) — which the specimen's dark version gets right. So a dark-only rim was mirrored into light with its polarity inverted.
>
> **4. The dark form-trigger fills carry a wallpaper tint the page does not have.** The platform's dark pop-up fill is its window background plus a flat +16 on every channel: bg `(35,42,47)` → fill `(51,58,63)`. The tint belongs to the background, not the control. The specimen hard-copies `(51,58,63)` onto a neutral `(30,30,30)` page, so the control reads blue — B−R = 12 where the surface it stands on has B−R = 0. Same cast through hover `(70,77,81)`, press `(71,77,82)`, disabled `(44,49,52)`. The proof is internal: the same component's toolbar trigger is neutral in dark — `(38,38,38)`, `(58,58,58)`, rim `(59,59,59)`. One component, two disagreeing dark palettes. On this page the platform-consistent rest fill is `(46,46,46)`.
>
> **5. The label is about 15% too large.** Measured the same way on the same 236 fill: the platform's "Script" spans 13 rows cap-top to descender (y 13–25), the specimen's "Apple" spans 15 (y 75–89); subpixel, the `p` stem is 9.2 px on the platform and 11.4 px on the specimen. The chevron next to it is a pixel-for-pixel match, so the type is the only thing out of scale, and it crowds a box whose height is otherwise exactly right.
>
> ## Minor
>
> - **Open is drawn as Closed.** The open trigger is fill `(236,236,236)` / `(51,58,63)` with both corner pairs rounded — no active treatment at all. Press darkens by 23 levels; the persistent form of the same interaction darkens by 0. Nothing on the trigger says its menu is down.
> - **Dark disabled is far weaker than light disabled.** Both use the same two alphas (fill ≈0.67, label ≈0.33), but the results are not symmetric: the disabled label is APCA Lc 31.7 in light and Lc −16.7 in dark. Dark disabled `(96,100,102)` on `(44,49,52)` is a shape, not a word.

## What was done with it

The reply confirms, off the pixels and independently, every number this task
set: the mark as the pop-up pair in BOTH variants at 8 × 11, nine clear
columns from the trailing edge and half a pixel low; one colour for the mark
and the label; the capsule at r = 12 on h = 24; and the dark toolbar fill of 38
on a 28 band against the platform's 38 on 30. It also read the form trigger's
corner back as the platform's continuous curve within 0.15 px down the arc,
which nothing had measured before.

**Fixed here — finding 3.** The light rim was this task's own result ("measure
the control's fill, edge if any, corner and height in that capture and draw
them") and it was drawn wrong. Re-read off `finder-window-light.png`: a run
down x=715 gives 251, 251, 251, 250, 250 and then the control's 255 from y=8,
and a run across y=15 gives 252 down to 249 over x 686-696 and then 255 from
x=697 — no darker row against the control on any side, the falling values
being its drop shadow, which darkens away from it. So the platform wears a rim
in the dark appearance only, and there it is a highlight. `toolbarface.Rim`
now answers the platform's seam over the control's own fill only where that
lands LIGHTER than the fill, and no colour at all where it would darken it;
the trigger draws no band when there is no colour. One rule, stated once,
rather than an appearance the code tests for. `controls.md` carries both runs
and the rule.

**Filed, not fixed.** Finding 2 — the toolbar control measures 36 px on the
platform and this trigger draws the density's 24 — is real and outside this
task: CG5.1 landed the two variants agreeing on the control height and
`density.go` ships it, so moving the chrome variant to the platform's toolbar
height is a ruling about what a chrome-region control is sized by. Pool 551.
The open trigger having no treatment of its own is pool 552; the switched-off
label's contrast running Lc 31.7 light against Lc −16.7 dark is pool 553; and
the consequence of the light rim going — a chrome trigger standing on the
content plane is now white on white, exactly as the platform's is, and the
platform's shadow is what tells it apart — is pool 554.

**Confirmed, already filed.** Finding 1, hover and press one 255th apart in
the dark appearance, is the reading `controls.md` records under "The two
pointer overlays disagree between the appearances" and the capture that
settles it is already on 425's list as 544. Finding 4, the dark fill's
wallpaper cast, is pool 425 — a fifth independent finding, and the first to
prove it from inside one component: this task's own toolbar fill is neutral in
dark where the form trigger's is not. Finding 5, the label a seventh to a
sixth larger than the platform's, is pool 494.
