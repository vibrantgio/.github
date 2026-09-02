---
date: 2026-09-02
task: BN3.2
phase: BN
reviewer-model: unrecorded
reviewer-effort: unrecorded
---

# BN3.2 fresh-eyes review — the chip's marks resized to the label's cap band

Two headless captures: the gallery's Components group at 900 px wide, cropped to
the 760 px window that puts the chip section mid-frame with the button rows
above it and the badge rows below, in light and in dark. Both were cut from the
gallery's own stored group images, which are produced through its offscreen
render route; no application window was launched.

The reviewer was a fresh agent that had not seen the task packet, given the two
images, told which section was under review and that the rows around it were
context, given Bash and told to sample pixels before making any colour, size,
spacing or alignment claim, and asked one question with no checklist: what would
a developer on this platform complain about. The only briefing beyond that was
the one recorded misread — dark ink can read as grey at 1x in these captures
when it is in fact the full-strength text colour.

The finding this task's own change produced is number 7, and it was fixed in
the task. Everything else is colour, composition or coverage.

Verbatim reply, then triage.

## Verbatim reply

> I sampled every claim below with PIL. All coordinates are image pixels at 1 px/dp.
>
> ---
>
> # Chip section review
>
> ## 1. In light mode the "three levels" row is a demonstration of nothing
>
> The three level surfaces sampled at x=30:
>
> | level | light fill | dark fill |
> |---|---|---|
> | On the paper | `246,246,246` | `24,24,24` |
> | On a card | `248,248,248` | `34,34,34` |
> | In a dialog | `251,251,251` | `46,46,46` |
>
> Light contrast paper→card is **1.018:1**, paper→dialog **1.044:1**. Dark is **1.116:1** and **1.308:1**. The surfaces are square-cornered (corner profile at (24,342) is a hard step, first differing pixel at x=24 on every row), have no border (`y=345` runs straight from `(0–23, 246)` to `(24–813, 248)`), and cast no shadow (`x=400`, y 392–420: `248` → `246` → `251`, no gradient). So in light mode a developer is shown three identical rows and told they are three levels. Nothing in the render supports the claim.
>
> Worse, the chips themselves don't respond either. Sampling the chip border and fill at each level:
>
> - **Light**: outline border is `121,121,121` on all three levels; unselected fill tracks the surface exactly (246/248/251); selected fill is `215,207,247` on all three levels. Zero level response, anywhere, in any part.
>
> ## 2. Dark mode does respond, but the two parts step on different levels
>
> - Selected chip fill: paper `49,41,72` → card `73,66,99` → dialog `73,66,99`. Steps once, between level 1 and 2, then stops.
> - Outline border: paper `109,109,109` → card `109,109,109` → dialog `155,155,155`. Steps once, between level 2 and 3, having done nothing before.
>
> One component, two sub-parts, two different level ramps that don't step on the same boundaries. And the border ramp looks like a spot fix rather than a system: `109` on the card is **3.07:1**, i.e. sitting on the 3:1 non-text floor to two decimal places; had `109` also been used on the dialog it would have been **2.35:1** and failed, so `155` was substituted at that one level only. Meanwhile the light theme never adjusts the border at all.
>
> The consequence for the selected chip is that its label contrast *degrades* as it goes up: `208,197,250` on `49,41,72` = **8.47:1** on the paper, but the label does not move when the fill lifts, so on a card and in a dialog it is **5.82:1**.
>
> ## 3. Dark state colours are the level colours, so hover and level are the same pixel
>
> - Unselected chip hover fill (dark) = `34,34,34`. The card surface = `34,34,34`. Identical.
> - Unselected chip press fill (dark) = `46,46,46`. The dialog surface = `46,46,46`. Identical.
> - Selected chip hover fill (dark) = `74,66,99`. Selected chip *at rest on a card* = `73,66,99`. One unit apart in red; **1.00:1**.
>
> A resting chip on a card is the same colour as a hovered chip on the paper. Since the state and level ramps are the same ramp with the same step, a hovered chip on a card must land on the press value, and a pressed chip in a dialog runs off the end. The state row is rendered on the paper only, so the gallery cannot show whether hover survives at level 2 or 3 — which is exactly the case a developer needs answered before shipping a chip inside a dialog.
>
> The light theme does not have this collision, but only because its levels do nothing (§1). Light states move the opposite direction from dark and by their own amounts: rest `246` → hover `232` → press `212`.
>
> ## 4. Selecting a chip changes its width by 18px
>
> The state rows use the same four labels twice, so this is directly measurable:
>
> | label | unselected width | selected width |
> |---|---|---|
> | Rest | 61 | 79 |
> | Hover | 70 | 88 |
> | Press | 68 | 86 |
> | Focus | 70 | 88 |
>
> **+18px, every time.** Breaking down the "Rest" chip: unselected is border at x=148, label 165–191, right edge 208. Selected is border at 148, check glyph 163–174, 8px gap, label 183–209, right edge 226. The check (12px) plus its gap (8px) minus the tightened leading pad (17→15) = 18.
>
> Chip gap is a uniform 12px (278→291, 367→380, 475→488, 640→653). So on a desktop filter row, clicking any chip shoves every chip to its right by 18px — under the pointer that just clicked. Nothing in this render reserves the check slot or animates the growth.
>
> ## 5. Three separate contrast values are sitting exactly on the 4.5:1 floor
>
> | case | label | fill | ratio |
> |---|---|---|---|
> | light, **selected, at rest** | `96,85,131` | `215,207,247` | **4.53** |
> | light, unselected, press | `92,92,92` | `212,212,212` | **4.51** |
> | dark, selected, press | `239,236,255` | `111,103,139` | **4.54** |
>
> These are not near the floor, they are on it, with 0.01–0.04 of headroom. The worst one is the resting appearance of a selected chip in light mode — the single most common state a filter chip is in. Note the direction is inconsistent between themes: selecting a chip in light drops label contrast from **6.19:1** (unselected rest, `92` on `246`) to **4.53:1**, while in dark it *raises* it from **6.39:1** to **8.47:1**. Same interaction, opposite effect on legibility depending on theme.
>
> ## 6. The focus ring fails 3:1 on its inner edge, in light, on a selected chip
>
> The ring is a 2px inset border replacing the 1px outline — measured at the unselected Focus chip, x 383–384 purple then background, and vertically at x=417, y 486–487 purple. The chip's outer bounds are unchanged (y0=486, y1=517, identical to the Rest chip), so there is no layout shift. Good.
>
> But there is no offset. On the selected Focus chip in light, x 437–438 is `140,89,244` and x=439 onward is the chip fill `215,207,247`:
>
> - ring vs the paper outside it: **4.01:1** — passes
> - ring vs the chip fill it sits directly on: **2.92:1** — **fails the 3:1 requirement for a focus indicator against adjacent colours**
>
> Dark is fine (`167,135,255` vs `49,41,72` = **4.90:1**). This is a light-mode-only defect and it is on the selected chip, i.e. the chip a keyboard user is most likely to be tabbing across in a filter row.
>
> ## 7. Three icons in one row, three different weights
>
> Measured stroke geometry in the "On the paper" row:
>
> - Assist **+**: bar is 2px thick (x=165, y 296–297 solid `19,19,19`), stem 2px (y=293, x 168–169). 36 of its 44 non-background pixels (82%) are at full strength.
> - Filter **✓**: 1px core. At y=294 the run reads `155,147,186` / `96,85,131` / `178,170,208` — a single full-strength pixel between two antialiased ones. 16 of 55 pixels (29%) at full strength.
> - Input **✕**: 1px core. At y=300: `244` / `161` / `92` / `161` / `244`. 20 of 96 pixels (21%) at full strength.
>
> All three occupy a 12×12 box, but the plus is a heavy near-black 2px mark and the other two are thin, muted 1px marks. At 1x this reads as three unrelated icon sets. Separately: a 12dp icon inside a 32dp chip next to an 11px cap-height label is small — the check has to carry the entire "this chip is selected" signal (see §9) and it is one pixel wide.
>
> ## 8. One row, two text tiers, for no visible reason
>
> In the same row, at the same size:
>
> - "Set reminder" (assist): `19,19,19` → **17.19:1**
> - "Unread" (filter), "Olivia Barnes" (input), "What's due today?" (suggestion): `92,92,92` → **6.19:1**
>
> Dark is the same split: `238,238,238` (**15.30:1**) vs `155,155,155` (**6.39:1**). The assist chip is near-black and its three neighbours are grey. Whatever the token rationale, on screen it reads as one enabled chip beside three disabled ones — and since the section shows no actual disabled state, there is nothing to correct that reading.
>
> ## 9. Three of the four purposes are pixel-identical at rest
>
> Sampled border, fill, label, height, corner profile:
>
> - Filter (unselected) and Suggestion: border `121,121,121`, fill = surface, label `92,92,92`, height 32, corner profile `[4,2,1,1,0]`. **Identical in every sampled property.**
> - Input adds only an avatar and a close mark; its border, fill, label colour and geometry are the same again.
>
> So the four purposes are distinguished by their affixes alone. Whether that's intended, the header promises "the four purposes" and the render delivers one appearance with three attachments.
>
> ## 10. The selected chip has no edge
>
> Selected chips have no border at all — at x=380, y=297 the pixel is `215,207,247`, the fill itself. The only thing separating a selected chip from the surface is the fill step:
>
> - light, on the paper: **1.37:1**; in a dialog: **1.43:1**
> - dark, on the paper: **1.30:1**; in a dialog: **1.45:1**
>
> So the *unselected* chip has a well-defined 4.03:1 edge and the *selected* one has a 1.37:1 edge. Selecting a chip makes its boundary harder to see.
>
> ## 11. The selected chip's label colour changes with state; the unselected one's doesn't
>
> - Unselected label is `92,92,92` in all four states (rest/hover/press/focus) — consistent.
> - Selected label in light: rest `96,85,131`, hover `70,59,103`, press `24,11,50`, focus `96,85,131`. Three different colours.
> - Selected label in dark: rest and hover both `208,197,250`, press `239,236,255`. Two.
>
> So light re-tints the label on hover and dark doesn't. And the light press value `24,11,50` is dark enough that the antialiasing thickens — in the 3x crop the selected "Press" chip visibly reads as a **bold** label next to its siblings, though the glyph run is the same width (86 = 68 + the same 18). A colour change that reads as a weight change on press is a rendering artifact, not an intent.
>
> ## 12. The level surfaces shrink-wrap, so the page has a ragged right edge
>
> - Chip section, "On a card": x 24–813 (790 wide).
> - Badge section, "On a card": x 24–503 (480 wide).
>
> Same level, same page, two widths, because each surface is sized to its longest row of content. The section header bands are full-bleed (0–899). So the page shows full-width grey header bars with content-width surfaces of arbitrary length hanging beneath them. The chip surface stops at 813 in a 900px window purely because the last chip ends at 797 plus 16px of padding.
>
> ## 13. Smaller things worth a line each
>
> - **Caption tier collapses in dark.** The row captions ("On the paper", etc.) reach `155,155,155` at their darkest — exactly the chip label colour. In light they never get darker than `121,121,121` while chip labels are a solid `92,92,92`. The caption is one tier below the content in light and the same tier in dark; only the size difference (8px cap vs 10–11px cap) separates them.
> - **Chip radius doesn't match button radius.** Chip corner profile `[4,2,1,1,0]` (r≈6); button `[2,1,0,0,0]` (r≈4). The shorter component is rounder than the taller one.
> - **The close mark gets no states.** Every state specimen in this section is a filter chip. The trailing ✕ is a separate hit target inside the chip — a 12×12 glyph with 8px to the label and 14px to the chip edge — and the gallery shows no hover, press or focus for it, no separate outline or backing, and nothing that would tell a developer what its hit rectangle is. Assist, input and suggestion chips get no state specimens at all.
> - **No disabled state**, and no focus-combined-with-anything (hover+focus, press+focus). The header scopes states to "rest, hover, press and focus", so this is a coverage note rather than a defect, but a chip API needs disabled tokens and there are none to read off this render.
>
> ## What is actually right
>
> For the record, since I measured it: every chip is exactly 32px tall on every row and in both themes; chip widths are byte-identical between light and dark (131/77/96/153/145), so no font-metric drift; gaps are a uniform 12px; all five labels share a baseline at y=301; padding is coherent (16px inside the border to text, 14px to an icon, 4px to an avatar, 14px from a trailing icon to the edge); and the focus ring, being inset, causes no layout shift.

## Triage

One finding was fixed in the task, because this task made it: §7's first half.
The rest is the chip's colour model, the theme's ramps, or the section's
composition — the same ground BN2.2's review already covered, re-measured
independently and in several places sharpened.

**The ruled change itself is confirmed by the review's own measurements.** The
reviewer read the mark box at 12 px against an 11 px cap height — 1.09, inside
the 1.11–1.21 band measured off the platform — and read the avatar's padding at
"4px to an avatar" among the things it listed as coherent, which is the leading
inset this task replaced. Neither the size relation nor the inset drew a
complaint, and the mark being *too big* was the defect the task was cut for.

### Fixed in task

**§7, three marks at three weights.** Real, and introduced by this task's own
change. All three marks now take the same number — the label's stem — but the
gallery's plus rounded that number to a whole pixel before stroking with it
while the chip's own check and cross did not. An axis-aligned arm at a rounded
2 px lands on the pixel grid at full strength; the diagonals spread the same
weight over three columns. Measured after the fix, the plus falls from 36 of 44
ink pixels at full strength to 4 of 44, which is the same character as the
diagonals beside it. The mark painters in the chip's own tests take the number
unrounded for the same reason, and both sites say why.

**§7, second half — the marks read lighter than the label.** Not fixed and not
the chip's alone. The geometric band IS the label's stem, which is the measured
relation; what the reviewer is seeing is that a diagonal composited in linear
light shows less ink than the same coverage composited in encoded sRGB, which
the measured macOS reference already records as a platform-wide difference of
about 30 points at hairline scale. Every derived diagonal in this library is
affected, not the chip's two, so it wants its own ruling. Pooled as 224.

### Pooled

| finding | disposition |
|---|---|
| 1. light levels do nothing; the chip does not respond to level in light | confirms 208, sharpened with the chip's own parts |
| 2. in dark the fill and the outline step on different levels | pooled, 219 |
| 3. dark state ramp and level ramp are the same pixels | confirms 207 **[bug]**, independently re-measured |
| 4. selection widens the chip 18 px under the pointer | confirms 209; the number moves from 26 to 18 with the smaller mark |
| 5. three cases sitting on the 4.5:1 floor with 0.01–0.04 of headroom | pooled, 220 |
| 6. light focus ring is 2.92:1 against the selected chip's own fill | pooled, 221; neighbours 210 |
| 7. three marks, three weights | **fixed in task** |
| 7. the marks read lighter than the label they match geometrically | pooled, 224 |
| 8. one full-strength label beside three muted ones | confirms 211 |
| 9. three purposes pixel-identical at rest | pooled, 222 |
| 10. the selected chip has no edge; 1.30–1.45:1 boundary | pooled, 223 |
| 11. light re-tints the selected label on hover, dark does not | confirms 211, second half |
| 12. level surfaces shrink-wrap under full-bleed headers | pooled, 225 |
| 13. caption tier collapses onto the label tier in dark | pooled, 226 |
| 13. chip radius rounder than the taller button's | pooled, 227 |
| 13. the close mark gets no state specimens; only filters get states | confirms 215 |
| 13. no disabled state to read off the render | confirms 212 **[feature]** |

### Recorded non-issue, resurfaced

The dismiss mark's pointer target. The reviewer wrote that nothing in the render
"would tell a developer what its hit rectangle is" — which is true of a still
image and was BN2.2's recorded non-issue in the same words. The package
registers 24 dp on each axis, centred on the mark, after the body's area so it
takes the pointer where the two overlap; this task did not move it, on purpose,
and a mark now small enough to read as type is precisely the case that separate
target exists for. Brief it into the next chip review again: a hit region is
invisible in a still.

### Recorded misread, not repeated

The reviewer was briefed that dark ink can read as grey at 1x and sampled every
colour claim, so the misread did not recur. Worth adding to the next brief: the
reviewer twice reported an "11px cap height" where the face's own metric is
9.95 px — a threshold-and-antialiasing reading of a band that is 10 px of ink.
Close enough to be harmless here, but a review that reasons from a cap height
should take it from the face rather than from the pixels.
