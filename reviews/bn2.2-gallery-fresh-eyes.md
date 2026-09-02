---
date: 2026-09-02
task: BN2.2
phase: BN
reviewer-model: opus-5
reviewer-effort: unrecorded
---

# BN2.2 fresh-eyes review — the chip section redrawn around the four purposes

Two headless captures: the gallery's Everything column at 1000×760, scrolled so
the redrawn chip section sits mid-frame with the button rows above it and the
badge rows below, in light and in dark. Both were produced from the inventory
itself through the gallery's own offscreen capture route; no application window
was launched.

The reviewer was a fresh agent that had not seen the task packet, given the two
images, told which section was under review and that the rows around it were
context, given Bash and told to sample pixels before making any colour, size or
spacing claim, and asked one question with no checklist: what would a developer
on this platform complain about. The only briefing beyond that was the one
recorded misread — dark ink can read as grey at 1x in these captures when it is
in fact the full-strength text colour.

Verbatim reply, then triage.

## Verbatim reply

> ## Chip — review
>
> Both captures: `review-chip-light.png` and `review-chip-dark.png`. All values below are sampled from those files; contrast is WCAG 2.x on the sampled RGB.
>
> First, the thing that is right, because it makes the rest of the complaint precise: the geometry is clean. Every chip is exactly 32px tall with a 4px radius, 16px leading and trailing insets, 12px gaps, a 1px border, and every leading glyph is centred on the same 275.5 scanline. Nothing below is a sloppiness complaint. The complaints are all about colour tokens and about what selection does to layout.
>
> ---
>
> ### 1. In dark mode, the elevation ramp and the interaction ramp are the same ramp
>
> This is the one a developer would open a bug for.
>
> | dark token | value |
> |---|---|
> | surface: on the paper | `#181818` |
> | surface: on a card | `#222222` |
> | surface: in a dialog | `#2E2E2E` |
> | chip fill: rest | `#181818` (transparent) |
> | chip fill: hover | `#222222` |
> | chip fill: press | `#2E2E2E` |
>
> Same three values, in the same order. The consequence is not subtle — it is byte-exact:
>
> | this chip | fill | border | label | is pixel-identical to |
> |---|---|---|---|---|
> | at rest, on a card | `#222222` | `#6D6D6D` | `#9B9B9B` | **hovered, on the paper** |
> | at rest, in a dialog | `#2E2E2E` | `#9B9B9B` | `#9B9B9B` | **pressed, on the paper** |
>
> Not "similar". Identical in all three tokens, at the same size and radius. And it runs in the other direction too: a chip *hovered* on a card lands on `#222222` over a `#222222` card — a 1.00:1 fill, so hover feedback disappears entirely on a card; a chip *pressed* in a dialog lands on `#2E2E2E` over `#2E2E2E` and press feedback disappears there. The selected variant has the same fault one step over: selected-at-rest on a card is `#494263`, selected-hovered on the paper is `#4A4263` — one unit apart in one channel.
>
> I could only prove the collision from token equality, because the inventory never draws a hovered or pressed chip anywhere except on the paper. That is exactly why it survived: the section shows purposes × surfaces, and states × paper, and never crosses the two. The cross is where it breaks.
>
> Root cause is visible in the light capture: there, elevation goes *up* (`#F6F6F6` → `#F8F8F8` → `#FBFBFB`) while interaction goes *down* (`#F6F6F6` → `#E8E8E8` → `#D4D4D4`), so the two ramps can never meet. In dark, both were derived as "lighten the surface" and nobody re-shaped one of them. States need to be a composite over the actual surface the chip is sitting on, not an absolute value picked off the base surface.
>
> ### 2. Light mode has the opposite problem: there is no elevation
>
> | light | contrast against the paper |
> |---|---|
> | card `#F8F8F8` | 1.02:1 |
> | dialog `#FBFBFB` | 1.04:1 |
> | dark card `#222222` | 1.12:1 |
> | dark dialog `#2E2E2E` | 1.31:1 |
>
> The light surfaces are a 2- and 5-unit step; the dark ones are 10 and 22. Look at the light capture — the "On a card" and "In a dialog" bands are essentially not there. So the two schemes disagree about how much a level is worth by roughly 6×, which is the same tuned-independently failure as (1) seen from the other side.
>
> ### 3. Selecting a chip makes it 26px wider and reflows the row
>
> Measured on the four identically-labelled pairs in the state rows:
>
> | label | unselected | selected | delta |
> |---|---|---|---|
> | Rest | 61px | 87px | +26 |
> | Hover | 70px | 96px | +26 |
> | Press | 68px | 94px | +26 |
> | Focus | 70px | 96px | +26 |
>
> The leading checkmark (18px glyph + 8px gap) is added on selection rather than reserved. In a filter bar every click shoves every chip to its right by 26px, and in a wrapping row it can rewrap the line under the pointer.
>
> The obvious fix — reserve the space, or drop the check and let the fill carry selection — is blocked by the second half of this finding: **the fill is not carrying selection.** The selected tonal fill against the surface it sits on measures 1.37:1 (light), 1.30:1 (dark, paper), 1.70:1 (dark, card), 1.45:1 (dark, dialog). Below the 3:1 you would want for a state boundary. Which means selection is being communicated almost entirely by a checkmark drawn as a **1.5px hairline** — the thinnest stroke in the section, thinner than the label's own 2px stems. Selection is load-bearing on the faintest mark on screen, and that is also why it can't be removed.
>
> ### 4. The focus ring is not a macOS focus ring
>
> | | light | dark |
> |---|---|---|
> | ring | `#8C59F4`, 2px | `#A787FF`, 2px |
> | drawn | inset, replacing the 1px border | same |
> | against paper | 4.01:1 | 6.39:1 |
> | against the selected fill (inner edge) | 2.92:1 | 4.90:1 |
>
> Four things a Mac developer will say about this. It is a hard-coded brand purple, so it ignores the accent the user chose in System Settings — set the machine to Graphite and every other control's ring turns grey while the chips stay purple. It is drawn *inside* the control bounds instead of as a halo outside them, which is the web convention, not AppKit's. It *replaces* the resting border rather than adding to it, so a focused outlined chip stops looking like an outlined chip. And on the selected chip the inner edge is 2.92:1, so the ring is only clearly readable on its outer side.
>
> Incidentally it is a third purple: neither the filled button's `#723AD4` (light) / `#D0C4FF` (dark) nor the selected chip's tonal. And its relationship to the primary inverts between schemes — lighter than primary in light, darker in dark — which reads as hand-picked per scheme rather than derived.
>
> ### 5. One chip label is full strength; the other three are not
>
> | label, light | colour | contrast |
> |---|---|---|
> | Set reminder (assist) | `#131313` | **17.19:1** |
> | Unread, Olivia Barnes, What's due today?, and every chip in the state rows | `#5C5C5C` | **6.19:1** |
>
> Same in dark: `#EEEEEE` at 15.30:1 for the assist chip, `#9B9B9B` at 6.39:1 for everything else. (I checked the pixel cores rather than trusting the 1x render — these are solid glyph interiors, not antialiasing.)
>
> Both pass AA, so this is not a contrast bug. It's that in a single row of five same-sized chips, one label is nearly three times the contrast of its neighbours, which reads as "the other four are disabled". The whole chip family except the assist variant renders its label at secondary strength, including the resting filter chips. A team shipping a filter bar will file "our filters look greyed out."
>
> It also leaves nowhere to go. There is no disabled state in this inventory, and the resting label has already spent the quiet step: below `#5C5C5C` on `#F6F6F6` you drop under 4.5:1.
>
> ### 6. The selected chip's label is weakest at rest and strengthens when you touch it
>
> Light mode, selected variant:
>
> | state | label | fill | contrast |
> |---|---|---|---|
> | rest | `#605583` | `#D7CFF7` | **4.53:1** |
> | hover | `#463B67` | `#B9B1D8` | 4.97:1 |
> | press | `#180B32` | `#9B93B9` | 6.42:1 |
>
> The state overlay is being applied to the label as well as to the fill, so the resting selected chip — the state a user spends all their time looking at — carries the weakest text in the whole section at 4.53:1, and it only becomes properly legible while the mouse is down on it. That is backwards.
>
> Related: the overlay strength is not proportioned between variants. Unselected hover is a ~6% darkening and unselected press ~14%; selected hover is ~14% and selected press ~28%. So hovering a selected chip is as loud as pressing an unselected one, and pressing a selected chip is twice as loud as pressing an unselected one. In dark the mismatch is worse — 9.5% for unselected press against ~30% for selected press.
>
> ### 7. The glyphs are not one symbol family
>
> Measured inside a single row:
>
> | glyph | box | stroke | vertical span |
> |---|---|---|---|
> | plus (assist) | 14 × 14 | 2px, square caps | 269–282 |
> | checkmark (selected) | 18 × 18 | ~1.5px hairline | 267–284 |
> | close ✕ (input) | 18 × 18 | **3px** | 267–284 |
> | avatar | 24 × 24 | filled | 264–287 |
> | label | cap height 10px | 2px stems | 270–279 |
>
> Three optical sizes and three stroke weights in one row, none of them tracking the label's weight. The check and the ✕ both overshoot the label's cap height by 7px and hang 5px below its baseline. The ✕ at 3px is the heaviest mark on the entire chip — heavier than the label it sits next to — so on an input chip your eye lands on "delete" before it lands on the name, and it's drawn in the same `#5C5C5C` as the label, so a destructive affordance is styled as text but louder. This is what "these aren't SF Symbols" means concretely: one family, one optical size, one weight tracking the label.
>
> ### 8. Smaller, but they'd get mentioned
>
> **The avatar swims.** The input chip keeps the text chip's 16px leading inset in front of a 24px avatar that has only 4px of clearance top and bottom — a 4:1 imbalance, and a visible hole at the chip's leading edge (`crop-input-L.png` shows it plainly). A leading avatar normally insets to about 4px so it hugs the rounded end. Fixing it also takes 12px off a chip that is currently 173px wide for two words.
>
> **The close mark has no target.** It is an 18×18 hairline glyph with no background, 16px in from the chip edge and 9px from the label. I can't measure the hit region from a capture, but if it matches the ink it is under the 28pt pointer target, and the 16px of chip on its right is live surface — a near miss activates the chip instead of removing it.
>
> **"Tonal" means two different things.** In dark, the tonal button one row above is `#2F0066` — fully saturated violet. The selected chip's tonal fill is `#312948` — 43% saturated, near-grey. In light they swap which is louder. Put a tonal button next to a selected filter chip in a toolbar and it will look like a mistake.
>
> **Text sits 1px above the icons.** Labels are optically centred on 274.5, every glyph on 275.5. Below the threshold of anyone caring, listed only so it isn't rediscovered later as a finding.
>
> ### What the inventory should add
>
> The section covers purposes × surfaces and states × paper, and never the intersection. Add hover, press and focus **on a card and in a dialog** — that single row would have caught finding (1) before it shipped. Then add a disabled state (there is currently no token headroom for one), and the close mark's own hover and press, since it is an independent control living inside another control and is presently undocumented.

## Triage

Nothing was fixed in-task. Every finding lands either in `components/chip`'s
colour model, in the theme's ramps, or on a number that needs an owner ruling —
and the packet fences this task to drawing specimens with the existing API. The
one gallery-side suggestion (the missing states × levels cross) changes the
section's composition and roughly doubles its height, so it is pooled with the
bug it would have caught rather than taken unilaterally mid-task; the task that
fixes finding 1 will want that specimen and should carry it.

Pooled as open rulings 207–215 (§AC).

| finding | disposition |
|---|---|
| 1. dark walk and elevation ladder are the same three values | pooled, 207 **[bug]** |
| 2. light elevation is 1.02:1 / 1.04:1 where dark is 1.12:1 / 1.31:1 | pooled, 208 |
| 3. selection widens the chip 26 px; the container carries 1.30–1.70:1 | pooled, 209 |
| 4. the focus ring ignores the platform accent, sits inside, is a third purple | pooled, 210; neighbours 201, 202 |
| 5. one full-strength label beside four muted ones | pooled, 211 |
| 6. selected label weakest at rest; overlay not proportioned between rests | pooled, 211 |
| 7. the marks are not one family; ✕ is the heaviest ink on the chip | pooled, 213 |
| 8. the avatar swims in the text chip's leading inset | pooled, 213 |
| 8. "Tonal" means two different things | pooled, 214; neighbours 206 |
| 8. label baseline 1 px above the glyph centres | pooled, 215, as the minor it is |
| no disabled state to show | pooled, 212 **[feature]** |
| the states × levels cross is missing from the section | pooled, 215 |
| 8. the close mark has no target | **rebutted from the contract** |

### Rebutted

The close mark's pointer target. The reviewer said outright that it could not be
measured from a capture, and the package does register one: a target of
`DismissHitDp` — 24 dp on each axis, WCAG 2.5.8 AA — centred on the mark and
registered after the body's, so it takes the pointer where the two overlap. The
"near miss activates the chip" reading is what the capture allows, not what the
code does. Worth briefing into the next chip review as a recorded non-issue: a
hit region is invisible in a still.

### Recorded non-issues confirmed

The dark-ink-reads-grey misread was briefed and the reviewer sampled pixel cores
rather than trusting the 1x render, and said so. The geometry acceptance passed
with pixel evidence: 32 px height, 4 px radius, 16 px end insets, 12 px gaps,
1 px edge, every leading glyph on one scanline.
