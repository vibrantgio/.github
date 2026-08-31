---
date: 2026-08-30
task: BD1.2
phase: BD
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BD1.2 — fresh-eyes review of the gallery window after the rail fix

2026-08-30. The reviewer was handed the gallery window at 1280×800 in
both schemes after BD1.2's fix (the rail's ground made continuous),
briefed on three recorded misreads (1x dark-ink grey, glyph-square
saturation, headless artifacts), and asked what a developer on this
platform would complain about. It was NOT briefed on the recorded
"dark furniture darker than content is ADR-022's linchpin, not a bug"
misread — read its finding 1 with that in mind. The worker verified
the reply against the reviewer's own transcript word for word. The
reviewer did not complain the rail stops short — the fix landed.

## Verbatim reply

> ## What a macOS developer would complain about
>
> All numbers are pixel probes of the two PNGs (both 1280×800, sRGB). I checked the three recorded misreads first: text ink is **not** washed out anywhere (probed below), the swatch fills are all genuine, and I've ignored the missing titlebar/scrollbars.
>
> ### 1. The dark theme paints ~23% of the window in a colour that isn't in its own palette
>
> The sidebar rail and every sub-section band ("Palette — the scheme's semantic roles", "Typography — …") render **#151515 (21,21,21)** in dark. The gallery's own published roles, read off its own swatches, are Background **#181818 (24,24,24)**, Surface **#222222 (34,34,34)**, Divider **#2E2E2E (46,46,46)**, and the Neutral ramp's nine steps are 24/34/46/71/158/182/204/221/238. **21 is none of them.** A colour histogram confirms (21,21,21) is the second most-used colour in the dark render (23,010 of ~114k sampled pixels).
>
> In light the identical surfaces render **#E8E8E8 (232,232,232)** — which *is* exactly the Surface swatch. So light is correct and dark is not, and dark's chrome is *darker* than Background: elevation is inverted. Sidebar-vs-content contrast collapses to **1.028:1** in dark (21 vs 24) with no divider line at all — I scanned x=144..155 at y=300 and the transition is a bare 21→24 step. Light manages 1.134:1. The navigation rail effectively has no edge in dark mode.
>
> ### 2. Light mode's muted text fails WCAG AA; dark mode over-delivers by 2×
>
> | element | light | dark |
> |---|---|---|
> | subtitle "Every published family…" | #797979 on #F6F6F6 = **4.03:1** | #B6B6B6 on #181818 = **8.76:1** |
> | type-spec labels "DisplayLarge · 57sp" | **3.97:1** | **8.76:1** |
> | inactive toggle glyph | #5C5C5C on #D4D4D4 = **4.51:1** | #CCCCCC on #2E2E2E = **8.46:1** |
> | "Aa" on every coloured swatch | 6.37–6.66:1 | 9.94–10.06:1 |
>
> The subtitle's cap height measures 10px (rows 56–65) and the spec labels 9px (653–661), i.e. ~12–14px text — nowhere near WCAG's large-text exemption. **4.03:1 and 3.97:1 fail the 4.5:1 AA floor.** And the pattern is systematic across four independent measurements: the light scheme runs at roughly half the dark scheme's contrast for the same semantic role. The two themes were plainly not calibrated against the same target, and the failing one is the default.
>
> ### 3. The dark ramps have a 41%-wide hole in the middle
>
> Dark Neutral: 24, 34, 46, 71, **158**, 182, 204, 221, 238. Step deltas are 10, 12, 25, **87**, 24, 22, 17, 17. Nine steps that claim to span the tonal range cover 24–71 and 158–238 with **nothing between 71 and 158** — 87 levels, 41% of the ramp's own range, unsampled. Every dark ramp does it: Primary jumps (92,21,183)→(169,139,255), Info (0,72,132)→(70,161,255), Success (0,83,26)→(68,179,90). The light Neutral ramp (246,232,212,182,152,121,92,66,19) has a worst gap of 47, and looks like a real ramp.
>
> Practical consequence: in dark there is no mid-tone step available for a disabled label, a hairline on a raised surface, or a secondary border. You either pick 71 (nearly invisible on 24) or 158 (nearly full-strength). This is the ramp that's actually shipped to consumers, and it's unusable in the middle.
>
> ### 4. Invisible swatches in both themes
>
> The Background swatch and the Neutral ramp's step 1 are painted *exactly* the page background — light 246 on 246, dark 24 on 24 — so a component whose entire job is showing you a colour shows you nothing. Their only cue is a 1px border: **1.91:1** for the ramp cell in dark (71 on 24), **1.88:1** in light (182 on 246), and **1.31:1** for the Background swatch outline in dark (46 on 24). At 1x, a 1.3:1 hairline is not a component boundary.
>
> ### 5. The swatch row isn't on a grid
>
> Swatch left edges: 174, 238, 302, 366, 430, 494, 558, 622, **689**, 753, 817. Pitch is 64px everywhere except 622→689, which is **67px** — the gutter after Background is 11px instead of 8px, identically in both themes, so it's layout not theme. Cause: the "Background" caption measures 622–679 = **58px**, two pixels wider than its 56px swatch, so that column is sized by its label and the row's rhythm breaks. Either the captions get a fixed column width or they get truncated/wrapped, but a palette table that visibly loses alignment at one specific cell is the first thing anyone screenshots as a bug.
>
> ### 6. Full-bleed right edge, dead space, and a fixed-width content column
>
> The section bands ("Foundations", "Palette — …") are inset 25px on the left (text at x=174, pane starts at 149) and **0px on the right** — the band colour is still there at x=1279. On macOS that reads as clipped content, not as a deliberate bleed. Meanwhile the content it frames doesn't use the width at all: the palette row ends at x=872 and the ramps at x=613, leaving **407px (32%) and 666px (52%) of the window blank** at 1280 wide. Full-bleed chrome wrapped around a narrow fixed column is the worst of both.
>
> ### 7. It's Material 3 in a macOS window, and it says so out loud
>
> The type scale is labelled **57sp / 45sp / 36sp / 32sp** — those are Material 3's Display Large/Medium/Small and Headline Large, to the digit. `sp` is Android's scale-independent pixel, tied to a user font-scale setting that does not exist on macOS; on this platform type is specified in points. Shipping Android's density unit in the visible UI of a Mac app tells every reviewer the design system was ported, not designed, and a developer reading "57sp" has to go find out what that means in points before they can use the token.
>
> Related: the theme control is a hard two-position sun/moon segmented switch (88×28px at x=1168–1255, y=31–58) with **no Auto/System position**. macOS apps are expected to follow System Settings → Appearance and to flip automatically at the user's scheduled switch. A Mac developer will file this before anything else on the list.
>
> ### Deliberately not complaining about
> Small ink is genuinely dark, not grey — sidebar labels measure #131313 on #E8E8E8 (15.16:1 light) and #EEEEEE on #151515 (15.74:1 dark); the "Aa" glyphs sit at 6.4:1+ light and 9.9:1+ dark on every coloured tile, and the small tiles' fills match their labels. Missing titlebar, missing scrollbars, and the clipped "HeadlineLarge · 32sp" at y=800 are capture artifacts.

## Triage

- Finding 1's headline — chrome darker than Background — is the
  recorded ADR-022 linchpin working as ruled (furniture is the
  window's floor in both schemes); the reviewer was not briefed on
  that misread. What survives triage is the measured residue: a
  1.028:1 seam with no divider hairline in dark, pooled under item
  130.
- Findings 2–7 verified against the probes and pooled as items
  131–136 in `explorations/open-rulings.md`.
- The reviewer's numbers also correct item 128's original diagnosis;
  the correction is recorded there and in BD1.2's commit messages.
