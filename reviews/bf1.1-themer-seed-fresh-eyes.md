---
date: 2026-08-30
task: BF1.1
phase: BF
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BF1.1 — fresh-eyes review of the Theme tab with the Palette Seed row

2026-08-30. The reviewer was handed the themer's Theme tab at the
app's real 1040×820 in both schemes (TestWindowDump captures), briefed
on five recorded misreads, and asked what a developer on this platform
would complain about. It probed every claim with PIL/numpy — L* per
ramp step, WCAG ratios, box geometry. The worker relayed the reply
verbatim; finding 5 was fixed in the task, the rest triaged below.

## Verbatim reply

> I probed both PNGs (1040×820, 1x) with PIL/numpy — sampled every ramp step, computed CIE L*, WCAG contrast ratios, and measured box geometry. Findings, worst first.
>
> ## 1. The dark ramp has a 35 L* canyon between 400 and 500 (product-breaking)
>
> Sampled L* per step, identical across all six roles (so this is a fixed tone table, not noise):
>
> - light: 97.0 92.0 85.1 74.1 63.1 51.1 39.2 27.8 5.9 → gaps 5, 7, 11, 11, 12, 12, 11, 22
> - dark: 8.0 13.0 19.1 29.9 **64.9** 74.1 82.0 87.9 94.0 → gaps 5, 6, 11, **35**, 9, 8, 6, 6
>
> Contrast of each step against its own page:
>
> - light vs #F6F6F6: 1.00 1.13 1.36 1.88 2.65 3.99 6.16 9.35 17.19
> - dark vs #181818: 1.00 1.11 1.32 1.89 **6.57** 8.76 11.06 13.00 15.27
>
> The dark ramp has no step anywhere between 1.9:1 and 6.6:1. You cannot pick a 3:1 tone (WCAG non-text minimum) or a 4.5:1 tone out of the dark ramp at all — it jumps straight over both thresholds. The light ramp lands on 2.65 / 3.99 / 6.16 and covers the same territory smoothly. The dark curve isn't the light curve reflected (mirrored light would be 6, 28, 39, 51, 63, 74, 85, 92, 97); the dark-end shape was reused unreflected and then spliced onto a light-end shape, and the seam is the 400→500 cliff.
>
> ## 2. Four of nine dark steps are the same colour
>
> Adjacent-step contrast in dark Primary: 1.12, 1.18, 1.44 for 100→200→300→400 (#0F1B00, #172600, #213400, #344E00). Steps 100 and 200 sit at 1.00 and 1.11 against the page and 1.12 / 1.00 against the section panel #222222 — 200 is literally the same luminance as the panel it's drawn on. In the screenshot those four cells read as one black bar. Light has the same crowding at 100–300 (1.14, 1.20, 1.38) but recovers by 400.
>
> ## 3. Accent lightness is scheme-dependent, so light-scheme contrast is a lottery
>
> Converted each seed and its "Aa" chip to LCh:
>
> | seed | seed L* | light chip | dark chip |
> |---|---|---|---|
> | #6C9BCE | 63 | #2F9AFF L*62 | #A5D0FF L*82 |
> | #829F5E | 62 | #72A500 L*62 | #9CE000 L*82 |
> | #E8112D | 49 | #E8112D L*49 | #FFBBB6 L*82 |
> | #88B2C1 | 70 | #00BAE5 L*70 | #69DAFF L*82 |
> | #827D5E | 52 | #8D7D00 L*52 | #E6CD00 L*82 |
>
> Dark pins every accent to L*82 and lands on exactly 11.07–11.11:1 for all five. Light lets the accent inherit the seed's own lightness, so label contrast ranges 4.62:1 (#E8112D) to 9.15:1 (#00BAE5) — and the label colour flips polarity: white on card 3, black on the other four. That mixed-polarity row is visible in the screenshot. Everything passes AA, but the red card is at 4.62 with no headroom while the dark scheme has a guaranteed floor. Same five seeds, predictable dark theme, unpredictable light one.
>
> ## 4. The panel is clipped mid-corner, with 20 px of window wasted below it
>
> The panel border runs y 358–791 on both sides, then the bottom corner arc starts sweeping inward (x=20 at y791, 21 at 792, 23 at 796, 28 at 799) and just stops. Rows y=800–819 are a single flat page colour across all 1040 px in both schemes — no border, no content. So the frame is sliced through its own radius, has no bottom edge, and 20 points of window sit empty under it.
>
> The Warning ramp row is cut at y=799, 10 px of a 21 px row, its label clipped through the glyph middles. Scrollbar thumb is 192 px in a ~395 px track, so the Theme tab is ~2.06× its viewport — half the tab is below the fold. Meanwhile the non-scrolling chrome above the panel (header, seed cards, tabs) takes y 20–390, 47% of window height, at the app's real size.
>
> ## 5. Dark-mode copy regression
>
> Light reads "Lifted seed" / "the colour this palette grew from and pins as its Primary base". Dark reads "**Lifted seed the light scheme pins**" / "the colour this palette grew from before this scheme re-toned it". The label slot has swallowed a clause and reads as a run-on with no punctuation.
>
> ## 6. Hint text uses two different inks for the same role
>
> Section-header hints ("the smaller swatch is the colour picked · …", "a dot marks where each pick lives · …") are drawn at #131313 / #EEEEEE — the same ink as the bold section heading beside them. Every other hint in the app ("drop another image to replace it", "vivid first, not largest…", "rendered from…", the hex captions) is muted #5C5C5C / #CCCCCC. So a 70-character helper line is at full heading strength, competing with the heading it sits next to.
>
> ## 7. Red loses its identity in dark; five Error steps are gamut-clipped
>
> The red seed's chroma collapses C87 → C27 at the pinned L*82 (fire-engine red becomes blush pink), while the green seed goes C74 → C93 and the khaki C58 → C83 at the same lightness. Dark Error 500–900 are #FF725A #FF9C88 #FFBCAE #FFD3CA #FFE9E5 — five consecutive steps with R clipped at 255, varying only in G/B, so hue and chroma both drift as the ramp climbs. Light Error clips R on four steps, Warning on three. Chroma boost itself is documented by the app's own caption ("the palette's own dial sets its chroma"), so I'm flagging the clipping and the red-specific collapse, not the boost.
>
> ## What's fine
>
> - No washed-out text anywhere. Muted body ink measures 6.19:1 light / 11.06:1 dark; primary ink 17.19 / 15.30; tab and section headings 17.50 / 13.71; column headers 10.85 / 14.76. All comfortably AA, most AAA.
> - All five "Aa" chips pass AA in both schemes (4.62–9.15 light, 11.07–11.11 dark).
> - Ramp grid alignment is essentially exact: every column header centre is within 0.5 px of its column centre ("base" within 1.0 px).
> - Selecting a card causes no layout shift — the selected card uses a 2 px border vs 1 px, but swatch content starts at y=181 in every card.
> - Seed candidate swatches are correctly scheme-independent (#E8112D identical in both), and the two Palette Seed swatches honour their own caption: the picked colour is 38×20, the lifted one 46×28, both centred on the same axis.
> - Toggle knob and glyph states are correct per scheme, and the elevation ladder (page #F6F6F6/#181818, section band #F8F8F8/#222222) is consistent in both directions.

## Triage (the worker's)

- Finding 5 fixed in the task: the dark cell renamed "Lifted seed
  pinned in the light scheme" — one noun phrase, no seam.
- Finding 4's second half confirms the two-swatch size channel reads
  at 1x untold; its first half is the window's own 20-point margin and
  a scrolling column being a scrolling column — misread, not acted on.
- Finding 6 declined with a recorded reason: the caption is the grid
  dot's only legend and muted ink goes faint in one scheme; if the
  hint-ink ladder changes it changes for all three bands. Pooled.
- Findings 1, 2, 3, 7 are tokens.FromSeed derivation facts, not
  workbench code; pooled for theme (144–147), 1 and 2 sharpening the
  earlier dark-ramp finding by exact measurement.
