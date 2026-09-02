---
date: 2026-09-02
task: BQ1.4
phase: BQ
reviewer-model: unrecorded
reviewer-effort: unrecorded
---

# BQ1.4 fresh-eyes review — the four status washes side by side

## What the reviewer was given

Four PNGs and nothing about the task, all rendered offscreen from the
repositories' own goldens — no window was opened on the owner's screen:

- `alerts-dark.png` and `alerts-light.png`: the four alert specimens
  (`patterns/alert`) stacked error, warning, success, info, 960x1152 each.
- `badges-dark.png` and `badges-light.png`: the badge row
  (`components/badge`, level 0) — Neutral, Success, Warning, Error, Info —
  1260x132 each.

All four are nearest-neighbour 3x enlargements of the rendered pixels, so
every sampled value is exact.

It was told the stacking order, that it must sample pixel values before
making any colour claim, and one recorded misread — dark ink and dark fills
read as flat grey when looked at rather than sampled, and reviewers have
wrongly reported "these are all the same near-black". It was given two
questions and no checklist: do the four statuses read as four distinct hues,
and does each fill still read as a wash rather than a filled control. It was
told to say plainly if either read fine.

## Verbatim reply

> I sampled every colour before looking at any image. All four captures are 3x nearest-neighbour, so the values below are exact rendered pixels.
>
> ---
>
> ## Review: status washes, alerts and badges, both themes
>
> ### What I sampled and where
>
> **Alert fills** — `alerts-dark.png` / `alerts-light.png`, sampled at `(20, y0+10)` for each of the four 288px-tall specimens (y0 = 0, 288, 576, 864):
>
> | | dark fill | L\* | C\* | hue° | light fill | L\* | C\* | hue° |
> |---|---|---|---|---|---|---|---|---|
> | error | `#482421` | 19.0 | 19.2 | 30 | `#f9c9c4` | 84.9 | 18.5 | 29 |
> | warning | `#3c2c08` | 19.1 | 24.4 | 83 | `#e7d2ac` | 85.0 | 21.6 | 86 |
> | success | `#18341c` | 18.9 | 20.8 | 145 | `#bbddbe` | 85.0 | 20.6 | 146 |
> | info | `#183049` | 19.2 | 18.3 | 269 | `#bad8f8` | 85.2 | 19.2 | 261 |
>
> **Badge fills** (`badges-dark.png` / `badges-light.png`, y=66, spans located by run-length scan) are the *identical* tokens, plus neutral `#2e2e2e` / `#d4d4d4` at the same L\* 18.9 / 84.9 with C\* = 0.0. Page backdrop: `#181818` (L\* 8.2) dark, `#f6f6f6` (L\* 96.9) light.
>
> ---
>
> ### 1. Four distinct hues?
>
> **Yes, in both themes, and dark is not the weaker of the two.** The recorded "it's all near-black" misread does not survive sampling: the four dark fills are 19.0/19.1/18.9/19.2 L\* — deliberately isoluminant — with hue angles 30 / 83 / 145 / 269 and chroma 18–24. They are four hues at the same lightness, not four near-blacks.
>
> Pairwise CIEDE2000 between fills:
>
> | pair | dark | light |
> |---|---|---|
> | error vs warning | **18.1** | **18.8** |
> | warning vs success | 20.0 | **18.6** |
> | error vs info | 25.9 | 28.4 |
> | success vs info | 26.5 | 25.7 |
> | warning vs info | 29.4 | 30.6 |
> | error vs success | 35.7 | 35.7 |
>
> Dark and light are within ~1 dE00 of each other on every pair. **The two themes are separated equally well — the dark set is not the compromised one.** The construction is disciplined: same hue angles, same chroma band, same L\*, in both directions.
>
> The one genuine weak spot, in both themes, is **error vs warning at dE00 ≈ 18**, well below the 25–36 of every other pair. In dark that is `#482421` against `#3c2c08` — a red-brown against an olive-brown, and in the alerts capture they sit edge to edge with no gap or divider (y=287 is `#482421`, y=288 is `#3c2c08`, no seam). And the icons do not rescue it: the icon colours are `#fd6d65` vs `#f07b1e` dark (dE00 19.8) and `#b12226` vs `#944600` light (dE00 17.8) — the *same* weakest pair, in the same place. Error and warning are the one distinction this system makes twice as weakly as all the others, in both themes, in both fill and icon.
>
> ---
>
> ### 2. Does each fill still read as a wash?
>
> **Yes — unambiguously, and this is the strongest thing about the specimens.**
>
> Fill against the page backdrop (measurable only in the badge captures, where the backdrop is visible):
>
> | | dark CR vs `#181818` | dE00 | light CR vs `#f6f6f6` | dE00 |
> |---|---|---|---|---|
> | error | 1.310 | 18.0 | 1.370 | 17.9 |
> | warning | 1.316 | 17.3 | 1.367 | 16.3 |
> | success | 1.308 | 18.5 | 1.369 | 18.6 |
> | info | 1.317 | 14.8 | 1.362 | 15.4 |
> | neutral | 1.308 | 6.9 | 1.372 | 7.4 |
>
> 1.31:1 and 1.37:1. That is a tint, not a control. A filled control would clear 3:1 against the backdrop and would flip its foreground; instead the content on top carries the contrast — alert titles are `#eeeeee` on the dark fills (CR 11.6) and `#131313` on the light fills (CR 12.6), and the fill just tints the ground underneath. Every fill also lands at the same L\* as the achromatic neutral wash, which is exactly what a wash system should do: hue varies, weight does not. Nothing in these four captures reads as a solid coloured block or a button.
>
> If anything the dark wash is slightly *under*-weighted at the faint end: info at dE00 14.8 from the backdrop is the quietest of the five, and on a large surface it will be close to invisible.
>
> ---
>
> ### What a developer would actually complain about
>
> **1. Badge label contrast is 8.4:1 in dark and 4.5:1 in light. That asymmetry will get filed.** Sampled peak label pixel inside each badge span:
>
> - dark: Error `#ffbbb4` 8.40, Warning `#ffc242` 8.39, Success `#77e387` 8.48, Info `#a6d0ff` 8.40
> - light: Error `#b12226` 4.54, Warning `#944600` 4.53, Success `#006b24` 4.54, Info `#005da8` 4.56
>
> Light sits on the 4.5 AA line with roughly a hundredth of headroom, at badge type size. Any rounding, any future fill nudge, and it fails. Dark has nearly double the margin for the same component. The same asymmetry, smaller, is in the alert icons: 4.84–4.90 dark, 4.53–4.56 light. The two themes were tuned to different targets and it shows in the numbers, not in the render.
>
> **2. The Neutral badge in dark is the odd one out.** Its label peaks at `#9b9b9b` for CR 4.89 while every status badge in the same row is 8.40. In the rendered row the word "Neutral" is visibly dimmer than "Success", "Warning", "Error", "Info" beside it — and it is the one badge with no hue to carry meaning if the text is hard to read. Light theme does not have this problem (neutral 4.51, statuses 4.53–4.56). This looks like a dark-theme neutral-foreground token that missed the pass the status foregrounds got.
>
> **3. All four alerts use the same icon glyph.** It is one right-pointing triangle in error, warning, success and info alike. Hue is carrying 100% of the status signal, with zero redundant encoding — no shape, no border, no status word in the alert text ("Could not save", "Unsaved changes"). Combined with error-vs-warning at dE00 18 in *both* the fill and the icon, a red-green colour-blind user has essentially nothing to separate an error alert from a warning alert. (If this triangle is a specimen placeholder and the shipping component ships distinct glyphs, disregard; if it is the shipping glyph, it is the most serious defect in these four images.)
>
> **4. Cross-platform: a background-only signal is the first thing forced-colors mode destroys.** The alerts have no border, no outline, and no rounded corners in these captures — the fill runs full-bleed to every edge and the four specimens abut with no divider. That is fine as a wash, but it means the alert's bounds and its status are both encoded solely in a 1.31:1 background tint. Under Windows high-contrast / forced-colors, macOS Increase Contrast, and the Linux high-contrast themes, background colours are the thing that gets overridden — and this design has nothing left underneath. The badges survive it (the label literally reads "Error", "Warning"); the alerts do not. A 1px border in the status hue would cost nothing and would keep the alert legible when the wash is stripped.
>
> **5. Minor: warning is the most chromatic wash and info the least** (C\* 24.4 vs 18.3 dark, 21.6 vs 19.2 light). Warning reads slightly more present than its siblings in the badge row. Small, but it is the one place the otherwise-strict isoluminant construction is not matched by an iso-chroma one.
>
> **Not a defect:** the `#c8c8c8` 768×96 rectangle in each alert is a body-copy placeholder — pixel-identical in both themes, four instances, perfectly uniform. It is the harness, not the design. I mention it only so nobody reports a giant light-grey block as a dark-theme bug.
>
> **Bottom line:** the wash question is settled — these are washes, correctly and consistently built, at 1.31:1 / 1.37:1 with the contrast carried by the content on top. The hue question is a qualified yes: four separated hues in both themes with dark no worse than light, but error-vs-warning is half as separated as every other pair, that weakness is duplicated rather than compensated in the icon colours, and the identical icon glyph leaves hue with no backup.

## What was done with it

Both questions came back yes, which is the task's own gate: the four dark
washes read as four hues, dark measures within about one ΔE00 of light on
every pair, and every wash still measures as a wash (1.31:1 dark, 1.37:1
light, under the 2.5:1 the gates call a fill).

Nothing was fixed in this task — every finding is a separate component or a
separate derivation question, and none of it is a defect in what BQ1.4
moved.

Pooled in `explorations/open-rulings.md`:

- **244** — error and warning are the palette's least separated pair, in
  both schemes and in both channels, with the marks repeating the weakness
  rather than covering it. Replaces item **45**, which asked whether to
  accept the dark pair at ΔE00 8.8 or make the exception; this task made the
  exception, the dark pair now measures 18.1 against light's 18.8, and 45's
  number is stale.
- **245** — an alert states its bounds and its status in the wash alone, so
  any environment that overrides background colours takes both. The
  reviewer's "no rounded corners" is a misread of the specimen and was not
  pooled: `drawAlert` fills a rounded rect at the Lg radius, and the capture
  simply carries no page around it. What the item pools is the verified half
  — the shape is filled and never stroked.
- **246** — one OKLCh chroma dial does not make four equally present washes:
  CIELAB C\* runs 18.3–24.4 in dark and 19.2–21.6 in light.

Already pooled, and independently reproduced by this reviewer, so no new
number was taken:

- the dark Neutral badge label at 4.89:1 beside status labels at 8.40:1 is
  item **241**, pooled by BQ1.3's reviewer with the same measurements;
- the light-versus-dark foreground asymmetry is item **1** (sharpened
  2026-09-02) under item **122**'s schemes-measure-differently finding;
- the identical alert glyph in all four statuses is item **67**, and it is
  the shipping glyph, not a specimen placeholder.
