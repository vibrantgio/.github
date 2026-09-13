---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — SK150 Control, read cold

Two whole-window renders — the bench supply's control panel in both
appearances, drawn offscreen at 720×760, the size its window opens at, against
the simulated device with a live readout, a minute of history in both charts
and the presets and device tabs populated — handed with three macOS captures
(`system-settings-grouped-box-{light,dark}.png`, `save-dialog-light.png`) to
an agent that had seen neither the packet nor the plan, with no checklist and
one question: put beside these macOS windows, what would a developer who uses
macOS every day say this app gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured; alpha names composite in encoded sRGB; every value
was measured off a macOS capture; the typeface is deliberately not the
system's and the accent does not change between appearances.

## The reviewer's reply, verbatim

> Read all five images and measured the frames pixel by pixel. Here's the verdict.
>
> ## What a daily macOS user would call wrong — worst first
>
> **1. The tab strip is Material Design, not macOS.** Frame y=72–95: a flat #F7F7F7 band, square corners, inset 16px from each edge (x=16→703), holding three left-aligned labels with a 2px underline under "Monitor" and a 1px #DFDFDF rule beneath. macOS has no such control. A three-way view switch is a centred `NSSegmentedControl` — a rounded pill, the selected segment raised on a white/elevated capsule with a shadow, sitting in the toolbar or centred under it — or a sidebar, as in the System Settings reference. An accent underline as the selection indicator exists nowhere in AppKit. Compounding it: the underline is `#0064E1`, while the app's own accent everywhere else (ON pill, M0 chip, the 12.48 readout, the power glyph) is `#007AFF`. Two different blues in one 720px window. And the selected label is `#262626`, identical to the unselected ones, so the 2px rule is the *only* selection cue — macOS also weights the selected segment.
>
> **2. The output switch, top right, is not a switch.** At x=596–694, y=17–55 there's a lightning bolt glyph, a blue "ON" pill, the word "OFF" stacked *underneath* it in grey, and a separate circular power glyph to the right. macOS has exactly one widget for this: `NSSwitch` — a ~38×22 capsule with a white knob, filled accent when on, empty grey when off, with its label to the *left*, as the "Tint window background with wallpaper colour" row in the System Settings reference shows. Worse, the inactive half is painted `#C0C0C0` on white — **1.82:1**, and `#565656` on `#1E1E1E` in dark — **2.27:1**. That reads as *disabled*, not as *the other state*. On a bench supply, the control that energises the terminals is the one you must never have to squint at. Two controls (segmented ON/OFF plus a power button) for one binary state is a third problem.
>
> **3. Chart axis labels are drawn inside the plot, and the data line runs through them.** In the current chart, "1.980 A" (x=35–80, y≈709–725) and "-59s" (x=252–277) both have the cyan trace crossing the glyph strokes. Swift Charts / any native chart reserves gutters: y labels in a left margin outside the plot rect, x labels below the frame, and insets the plot so nothing can collide. Related: "-59s" sits 36% across a plot that spans x=20–699 — its data point is at the far left. It looks like the min-value label and the x-axis start label are laid out in the same row and shoved each other rightward, so the time axis is mislabelling where the data is.
>
> **4. Cyan `#00C3D0` on white is unreadable, and neither cyan nor magenta is a macOS colour.** The "2.140 A" readout measures **2.16:1** against white — under even the 3:1 large-text floor. (It's fine in dark: `#00D2E0` on `#1E1E1E` is 8.97:1, so the light ramp is the broken one.) `#00C3D0` is neither `systemTeal` (48,176,199) nor `systemCyan` (50,173,230); `#CB30E0` is neither `systemPurple` (175,82,222) nor `systemPink`. The blue is `systemBlue` exactly — so the app clearly knows where the system palette lives and then invented two colours beside it.
>
> **5. Nothing is on one grid.** Three left margins in one window: the title and tab band at x=16, the chart cards at x=20, and the "M0 … Set" row floating between x=144 and x=574 — the Set button's right edge stops **125px short** of the chart card's right edge directly below it. The metrics strip (IN 19.20 V … 00:42:17) is centred at x=149–573. In the System Settings reference every group box *and* every section header shares a single left edge (x=243) and right edge (x=702), with no exceptions. That single shared column is most of what makes a macOS window read as macOS.
>
> **6. Section headers aren't headers.** "Output voltage (V)" and "Output current (A)" are regular-weight body text at the same size as everything else. Compare "Theme" and "Windows" in System Settings: bold, visibly a header. As drawn, the chart titles read as captions that happen to sit above a grey box.
>
> **7. Icons are wrong symbols, and the values have no labels.** In the metrics strip: a flame for 34.0 °C (SF Symbols has `thermometer.medium`), a brightness sunburst for 17.8 Wh, a battery for 1.42 Ah. Four of the five values are decodable only by guessing the pictogram. The System Settings reference labels every row in words and reserves the graphic for the value.
>
> **8. The "CV" badge collides with the "V" unit.** The pill occupies y=174–193, the V glyph y=196–213 — a **2px** gap between a 20px badge and an 18px letter, in the same x column. It reads as one smudged stack rather than two things.
>
> **9. Dark mode mixes two grey families.** Window `#1E1E1E` and gridlines `#1A1A1A` are hue-neutral; the chart cards `#2A3034` and the Set button `#333A3F` are blue-tinted. Side by side the cards look faintly teal against a strictly neutral window. macOS keeps one family throughout — and light mode here *is* consistently neutral (white / `#F7F7F7` / `#ECECEC` / `#E6E6E6`), so the two appearances don't agree with each other.
>
> **10. Minor:** card corner radius is ~6px where the macOS grouped box measures ~10px; the Set button carries a 1px `#E1E1E1` stroke that the macOS push button doesn't have; the tab band's inset-but-square-cornered shape is neither edge-to-edge chrome nor a floating control.
>
> ## What it gets right
>
> - **The Set button is very nearly pixel-correct.** `#ECECEC` fill, ~6px radius, 72×26 — against the save dialog's Cancel at `#ECECEC`, ~5px radius, 86×24.
> - **Surface values are measured, not guessed.** Light window white with `#F7F7F7` boxes, dark boxes `#2A3034` — all lifted straight off the System Settings reference, and the box-lighter-than-pane relationship in dark is correct.
> - **`systemBlue` is exact** (0,122,255) and the readout colours do adapt between appearances (cyan 195→210, magenta 203,48,224→219,52,242), so the dynamic-colour machinery works — it's the chosen values that are off.
> - **The numeric readouts are properly tabular.** All three right-align on a fixed digit grid with the unit column pinned at x=457, so the display won't jitter as values change. That's the correct instrument behaviour and it's easy to get wrong.
> - **Secondary text matches macOS.** `#808080` on white is 3.95:1, which is `secondaryLabelColor` (0.5 alpha black) to the byte.
> - **Symmetric 20px margins** on the chart cards, top and bottom, left and right.

## Disposition

**Fixed here.** Nothing. Every finding is shape, placement or a colour choice
the plan has already pooled.

**Already pooled.**

- 4, the cyan and magenta readouts: item 414 — three readouts on hand-picked
  system colours with no rationale for a one-accent platform. The reviewer
  adds the number that item lacked: `#00c3d0` on white measures 2.16:1, "under
  even the 3:1 large-text floor", and the dark half of the pair is fine, so it
  is the light ramp that fails.

**New for pooling.**

- 1, the tab strip: "An accent underline as the selection indicator exists
  nowhere in AppKit", and the selected label is the same colour as the
  unselected ones, so the rule is the only cue. Its colour is
  `selectedContentBackground` beside an accent used everywhere else — the same
  reading came back independently from sitedocs and feeds.
- 2, the output control: two controls for one binary state, the inactive half
  at 1.82:1 light and 2.27:1 dark — "On a bench supply, the control that
  energises the terminals is the one you must never have to squint at."
- 3, chart axis labels drawn inside the plot with the trace crossing their
  strokes, and the time label landing where its data does not.
- 5, three left margins in one 720 px window, and the set row stopping 125 px
  short of the card below it: "That single shared column is most of what makes
  a macOS window read as macOS."
- 6, chart titles set at body weight where the platform's group headers are
  bold.
- 7, wrong symbols in the metrics strip and no words beside the values.
- 8, the constant-voltage badge two pixels above the unit glyph under it.
- 10, the card radius against the platform's grouped box, and the set button
  carrying a hairline the platform's push button does not.

**Recorded misreads.**

- 9, "dark mode mixes two grey families", has a real cause and the wrong
  suspect: the cards are `CardFill` and the button `PushButtonFill`, both
  measured — but both off captures taken with wallpaper tinting on, so they
  carry a blue cast the untinted window background does not. Recorded as a
  cross-app item and reported to the owner; themer, marketing and iconbrowser
  read the same thing.
