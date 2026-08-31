---
date: 2026-08-31
task: BL1.1
phase: BL
reviewer-model: opus-5
reviewer-effort: high
retrofitted: true
---

# BL1.1 fresh-eyes review — the gallery window after the chip cut

2026-08-31. Whole gallery window at 1400×900, both schemes, headless
capture scrolled to the chip section; reviewer was a fresh agent
briefed only on the recorded non-issues, asked what a developer on
this platform would complain about. Verbatim reply, then triage.

## Verbatim reply

> Both files read and pixel-probed. Findings, worst first.
>
> **1. Dark: the pressed chip on the "In a dialog" storey inverts and reads as disabled.**
> The press overlay compounds with elevation in dark but not in light. Dark chip "Press" fill by storey: paper `#353535` → card `#5c5c5c` → dialog `#a1a1a1`. Light is flat: `#d4d4d4` on all three. So in the dark capture the dialog-storey Press chip is a pale grey slab (5.26:1 against its own `#2e2e2e` storey) and its label flips to dark ink `#2e2e2e` — 5.26:1, against 10.6–14.9:1 for every one of its siblings. Next to "Rest"/"Hover"/"Focus" in white it reads as the greyed-out one, i.e. the pressed state looks disabled. A developer will file this as "press state blows out on elevated surfaces in dark mode."
>
> **2. Light: secondary/caption text fails AA; dark's equivalent is twice the ratio.**
> Every field label in the light capture — "On the paper", "Rest", "Closed", "Focused", "Unchecked", "Disabled" — peaks at `#7a7a7a`–`#7f7f7f` on `#f6f6f6`, i.e. **at best 3.97:1**, under the 4.5:1 floor for normal text. The identical labels in the dark capture measure `#b5b5b5` on `#181818` = **8.66:1**. These aren't decoration; they're the only thing telling you which control is which. The light secondary-text token is roughly one step too pale, or the dark one is one step too generous — either way they aren't the same design.
>
> **3. Light mode has no elevation at all.**
> Surface ladder measured against the page: light `#f6f6f6` → card `#f8f8f8` (**1.02:1**) → dialog `#fbfbfb` (**1.04:1**) → picker menu `#ffffff` (**1.08:1**). Dark: `#181818` → `#252525` (1.16) → `#313131` (1.36) → menu `#474747` (1.91). There is no border and no shadow on the card or dialog surfaces, so in the light capture the "three storeys" row — the section whose entire purpose is showing elevation — shows three identical white bands. I misread these as visible grey boxes at first glance and had to zoom in to confirm they aren't there. The same goes for the open picker menu: in light it's white-on-white held together only by its 1px `#797979` outline.
>
> **4. Both: the selected row is the least legible row in the open picker menu.**
> Dark: "Banana" is `#474747` ink on `#bdaaff` = **4.58:1**, while the unselected "Apple"/"Cherry" rows are `#eeeeee` on `#474747` = **8.01:1**. Light: the selected row is **4.53:1** on `#6f36d1` against **18.58:1** for its neighbours. In the dark crop the highlighted item visibly recedes behind the two plain rows above and below it — backwards for the current selection.
>
> **5. Both: disabled controls out-shout the enabled ones, and their text is unreadable in light.**
> Light text field row: the enabled fields are `#f8f8f8` (1.02:1 vs page) defined by a 1px `#797979` border; the disabled one is a borderless `#e1e1e1` slab at 1.21:1 — the loudest box in the row — with placeholder text at **1.44:1** (disabled picker value: **1.55:1**). Dark is the same shape of error less severely: disabled fill `#555555` at 2.38:1 vs the enabled field's 1.16:1, text at 2.40:1 / 3.06:1. Disabled text is contrast-exempt, but 1.44:1 is not "de-emphasised", it's gone, and macOS keeps disabled controls readable. The disabled variant also drops the border its siblings have, so it doesn't read as the same component.
>
> **6. Both: the picker menu is a square-cornered, shadowless rectangle.**
> Probed the bottom-left corner at y=770–775: the border pixel runs to the last row with no radius and no antialiasing, and there's no shadow ring anywhere around it — while the picker field it drops from is rounded (~6px). A flat square panel butted against a rounded field is the first thing a macOS developer will point at; native menus are rounded and shadowed, and they overlay rather than reserving layout space below the field.
>
> **7. Both: focus is drawn two different ways.**
> Chips, text fields and pickers keep their exact footprint and swap the 1px grey border for a 2px purple one (light `#8c59f4`, dark `#a98bff`; measured 4.01:1 and 6.62:1 against the page, so the indicator contrast itself is fine). Checkbox and radio instead grow from **20×20 to 28×28** with the ring drawn outside the control. Same gallery, same focus concept, two different geometries.
>
> **8. Both: the sidebar's right edge vanishes wherever a section band lines up with it.**
> The bands are exactly the sidebar colour — `#e8e8e8` in light, `#151515` in dark, identical values on both sides of x=150 — so the sidebar boundary is present between sections and gone across them, giving a notched, intermittent edge down the whole window. The band's 1px bottom rule (`#d4d4d4` / `#2e2e2e`) also stops dead at x=150 instead of tying into anything.
>
> **9. Both: the sidebar title is truncated to "Components Galle…" in a 1400px window.** Only a handful of pixels short. Truncating your own app title at this width looks like a broken measurement, not a design decision.
>
> **10. Nits, both captures.** The "Anchor" picker is 36px tall on a row where its four siblings are 40px, top-aligned so its label sits 2px high — and it uses a thin chevron where the other four use a filled triangle, two disclosure glyphs for one control family in one row. The virtual list's 6px scrollbar sits at x=686–691 with no visible container edge anywhere near it (rows end at x=460, the section runs to x=1400), so it floats unanchored mid-window; the caption says the gutter is deliberate, but nothing on screen draws the gutter.
>
> **What's fine.** The accent inverts correctly and without hue drift (`#723ad4` light / `#d0c4ff` dark) — I checked the checkbox fill, radio fill and sidebar selection separately and they're the same token, no small-glyph saturation illusion. Sidebar selection contrast is 6.42:1 light / 11.32:1 dark. Primary text is 15.16–18.58:1 light and 13.71–15.74:1 dark. Rest borders are 4.03:1 / 6.63:1 and the scrollbar 3.03:1 / 4.94:1 — all clear of the 3:1 non-text floor. Control pitch and alignment are clean everywhere except the Anchor picker.

## Triage

Nothing was caused by BL1.1 — the chip section the task recomposed
drew no finding, and the "what's fine" paragraph covers the chip's
own borders and inks. Findings 1 and 3 are the dark ramp's missing
middle and the light ramp's compressed headroom — the strongest
independent confirmation yet of open-rulings 144/145 (Phase BJ's
premise); attached there rather than pooled anew. Finding 10's anchor
geometry is by design (the picker's two-register split: chrome
register at ControlHeight with the chevron, form register at the
BodyLarge line box with the triangle) and is rebutted, though its
presentation point is pooled. Everything else is pooled as items
167–174.
