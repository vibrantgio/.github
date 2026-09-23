---
date: 2026-09-23
task: CG7.2
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG7.2 — mindchat's settings dialog read cold beside the platform's own sheet

One reviewer, having seen neither the plan nor the packet nor any source and
told not to go looking for one, was given four images at 1x and told which two
are the platform: mindchat's whole window with the settings dialog standing
open, in both appearances as this task left it (1024×768 each, rendered
through the app's own layers, the selected provider's key already answered
for), and `save-dialog-light.png` and `save-dialog-dark.png`. It was given the
recorded misreads — a dark label reads grey at 1x; a still shows no fade, no
cursor and no pointer feedback; alpha composites in sRGB; our window's three
round buttons are harness stand-ins; a pointer target is invisible in a still;
the stored captures were taken with the window shadow excluded, so the
platform's own sheet shadow is not in them; the dialog's position and shape —
centred, landscape — are the owner's and stay; the footer is measured and
stays — and it was told it could read the pixels any way it liked, with Bash
and PIL to hand. It was asked one question, with no checklist: "Does this
dialog read as a macOS sheet, and what is wrong with it?"

The two application images it was handed were rendered with the default-model
row at 40 dp and its status caption in `labelColor`. Both moved after the
review and nothing else in either image did; the reviewer's own findings 3 and
8 are what moved them, and the readings are recorded below as it made them.

## The reply, verbatim

> ## Answer
>
> **In light, yes — nearly.** The shell is measurably the platform's: fill `#FFFFFF` exactly, corner radius ~13px on a near-identical continuous curve (inset profile 20/17/15/13/12/10/9/8/7/6/5 vs the platform's 21/17/15/13/11/10/9/8/7/6/5), a 20% black scrim over the parent window that matches the platform's to the level (255→204 in both), text fields 28px tall with border `#F3F3F3` and fill = sheet fill (platform: 27px, `#F3F3F3`, fill = sheet fill), Cancel `#ECECEC`, Save `#157BFB`, buttons 72–74×24 at 20px margins, label ink `#808080` — the platform's own value, so the "faded label" misread does not apply here. systemGreen is `#34C759`/`#30D158`, exact.
>
> **In dark, no.** And in both appearances two components break the illusion.
>
> ---
>
> ### 1. The dark sheet ground is wrong, and it corrupts every control standing on it
>
> Sheet fill measured at (400,380) and across the whole plate: ours `#1E1E1E` (30,30,30), perfectly neutral. Platform: `#232A2F` (35,42,47), distinctly blue-grey. Ours is five levels darker and has no hue.
>
> Consequences, all measured:
>
> | | platform | ours |
> |---|---|---|
> | sheet vs window behind it (ΔY) | 0.0119 | **0.0050** |
> | field border vs sheet (ΔY) | 0.0097 | **0.0189** |
> | Cancel button vs sheet (Y ratio) | 1.84 : 1 | **3.15 : 1** |
> | providers panel vs sheet (Y ratio) | — | 2.20 : 1 (light: 1.08 : 1) |
>
> The chrome values themselves are the platform's, copied verbatim — field border `#2C3338`, Cancel `#333A3F`, panel `#2A3034` are all exact platform greys. They were taken off a `#232A2F` sheet and dropped onto a `#1E1E1E` one. So the sheet sinks toward the window behind it (less than half the platform's separation) while everything on it pops off it at roughly twice the platform's strength. That is backwards: on the platform the sheet lifts and its controls sit quietly.
>
> This is one root cause with five symptoms. Fix the sheet fill and four of the rows above correct themselves.
>
> ### 2. The segmented control is a different design in light than in dark
>
> Bounds x 414–771, y 234–269 in both.
>
> - **Light**: no track fill at all (bare sheet white, 255), no border, dividers `#F2F2F2` (Lc 4.8 — invisible at 1x), selected pill `#E5E5E5` **darker** than the track, plus a ~2% soft shadow halo reaching ~12px outside the control.
> - **Dark**: track `#262626`, hard 1px border `#404040`, dividers `#3A3A3A`, selected pill `#494949` **lighter** than the track, no shadow.
>
> So the selected segment reads recessed in light and raised in dark. macOS is neither: a recessed grey track with a raised white pill, in both appearances. Ours also drops a shadow on one appearance only, and a segmented control never carries a shadow on the platform.
>
> It is also drawn from a separate palette. Its four greys (38 / 58 / 64 / 73) are strictly neutral while every other control in the same sheet carries the platform's blue tint, and its labels are `#4D4D4D` light / `#E9E9E9` dark where all other primary text in the sheet is `#242424` / `#E0E1E2`.
>
> ### 3. "Default model:" sits 6–7px low
>
> Label ink occupies rows 507–517 (baseline 517); the popup box is y 494–517, centre 505.5. The label's baseline lands exactly on the popup's bottom edge. Every other row in the sheet is centred to within 1px — Name 293 vs 293.5, Base URL 331 vs 331.5 — and the platform's "File Format:" is 348 vs 347.5. It is the one broken row and it is visible.
>
> ### 4. The source list is not a macOS source list
>
> - Selection is a hard, square-cornered bar: x 258–395, y 262–289, corner radius 0–2px. macOS 26 uses a rounded rect (r≈5–6). It reads as a web/Windows listbox.
> - The panel is a flat slab: r≈4, no border, no divider under the "PROVIDERS" header, and the +/− are bare 11px glyphs at (261–272, 289–300) × y 519 with no button chrome and no bottom bar.
> - In light the slab is nearly invisible (`#F7F7F7` on white, 1.08:1); in dark it is a strong plate (2.20:1) — the same light/dark asymmetry as finding 1.
>
> ### 5. Field content text is harder than everything else in the sheet
>
> "OpenAI" in the Name field peaks at `(0,0,0)` in light and `(255,255,255)` in dark. The popup value 200px below it, the Cancel label, the checkbox label and the list rows all peak at `(36,36,36)` / `(224,225,226)` — which are the platform's exact values. So one string per field is pure black / pure white where its neighbours are label colour. Most visible in dark, where the field text glares next to the caption under it.
>
> ### 6. The shadow has no vertical offset
>
> Measured at x=300: above, 204→189 over 23px; below, 189→204 over 23px. Left (over the sidebar) 198→184, right 189→204, both ~22px. Identical multiply on all four sides, ~7.4% peak darkening. It is a symmetric halo, not a drop shadow — macOS window shadows are offset downward and far larger. (The reference captures exclude the platform shadow, so this is read off ours alone.)
>
> ### 7. The two columns don't finish together, and the footer is crowded on one side
>
> The right column's last control ends at y=517; the providers panel ends at y=533. The panel comes within 13px of the buttons (top 546) while the right column leaves 29px. The platform's footer band is 65px: 22px above the buttons, 20px below. There is also a 68px void between the checkbox (bottom ~426) and the Default model row (top 494), with that row bottom-pinned. Separately, the platform splits its sheet with hairlines (`#E6E6E6` / `#393F43`, at y=324 and y=479, the lower one 22px above the buttons); ours has none.
>
> ### 8. Minor
>
> - "2 chat models listed" is a secondary status caption drawn in full primary ink (`#242424` / `#E0E1E2`) at a smaller size (cap height 9 vs the labels' 10). The platform's grey for that role is the `#808080` / `#9C9FA1` our own labels already use.
> - The left-aligned title "Settings" (cap top y=203, cap height 12 → ≈17px semibold, 20px from the sheet's left edge) has no platform equivalent — macOS sheets carry no title, and alerts centre their message. Judgement, not measurement.
>
> ---
>
> **Order to fix**: the dark sheet fill (1) first, because it alone accounts for the panel, field-border and Cancel-button over-separation; then the segmented control (2), which is the single most un-macOS object in the frame; then the Default model row (3) and the list selection (4), both cheap; then 5–8.

## What was done with it

**The reviewer read the task's own result back as the platform's.** It measured
the label column — "label ink `#808080` — the platform's own value" — and found
every row but one centred on its control to within a pixel, which is the pair
this task laid out and the pair `controls.md` now records off the sheet. It
found the fields' 28 px against the platform's 27, and nothing to say about the
labels' column or the fields' column.

**Finding 3 is fixed.** The default-model row stated 40 dp where the closed
trigger draws 24, so the label centred on sixteen pixels of slack under the
control. `SelectRowHeight` is now the pop-up's own measured 24 —
`save-dialog-{light,dark}.png` reads both pop-up boxes at 24 px, y 281–304 and
y 336–359 — and the label's cap band and the trigger's box now share a centre
to the pixel, as every other row does. That also closes the first half of
finding 7: the form's last control and the providers well now finish on the
same row, y=533.

**Finding 8's first bullet is fixed.** The status caption is a caption and now
takes `secondaryLabelColor` over the floating fill, the same name the row
labels beside it take, which is the reading the reviewer names. The failed
check keeps the system red.

**Finding 2 is a reading against the stored reference, and the drawing
stands.** The chosen segment's patch is DARKER than the control's fill in the
light appearance on the platform too: `controls.md`'s chosen-segment section
reads `#dedede` on `#f7f7f7` off `finder-window-untinted-light.png` and
`#494949` on `#262626` off the dark capture, and records the coverage rather
than the pixel precisely because the light window is not frontmost — over a
frontmost light control's `#ffffff` the same coverage lands `#e5e5e5`, which is
what the reviewer measured. The light appearance also draws no rim at all,
which is `toolbarface.Capsule`'s measured answer, and the shadow it carries in
light and not in dark is the platform's own toolbar-control shadow, measured
per appearance. What the reviewer is describing — a recessed track with a
raised pill in both appearances — is not in any stored capture. The genuine
question it exposes is the one pooled below: this is the toolbar's segmented
control standing in a sheet's body, because the toolbar's is the only
segmented control the reference measures.

**Everything else is outside the task and pooled.** Finding 1 (the dark sheet
neutral under controls measured on a tinted one) as 768, finding 2's palette
half and its host as 769 and 770, finding 4 as 771 and 772, finding 5 as 773,
finding 6 as 774, finding 7's void and hairlines as 775, and finding 8's title
as 776.
