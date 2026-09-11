# macOS control metrics

The numbers the density scale is built from, each with its provenance:
MEASURED (a stored capture, the method named), PUBLISHED (Apple's Human
Interface Guidelines, not read off this machine) or DERIVED (arithmetic on
the two, shown). Indexed by ADR-019, "The platform's control metrics".

Added 2026-09-11 by CE1.2. Nothing was launched to produce it.

## What the stored captures measure

Every capture here is window-bounded (`screencapture -o -l <windowID>`) on a
2560×1440 display at ~109 ppi, where one pixel is one point — so the pixel
values below are point values, and the coordinates are window coordinates
with (0,0) at the window's top-left outer corner (ADR-019, "How the numbers
were taken").

| what | value | capture | method |
| --- | --- | --- | --- |
| toolbar control height — search field, capsule button, segmented control, pop-up button alike | 36 px, y 8–43 | `finder-window.png`, `mail-window.png`, `reminders-window.png`, `voicememos-window.png`, `notes-window.png` | luminance run down a column through each control; every bordered control in all five windows starts at y=8 and ends at y=43 |
| that control's placement in the band | centred: 8 px above, 8 px below in a 52 px unified toolbar | same five | the band heights are ADR-019's "Title bar and toolbar bands" |
| text field outside a toolbar — Finder's info pane, "Add Tags…" | 33 px tall (y 263–295), 220 px wide (x 770–989) | `finder-window.png` | the field's fill (35,42,46) against the pane's (27,32,35), first and last row and column that leave the pane |
| a search field's leading inset: the field's inner edge to the first pixel of the magnifier glyph | 10 px | `mail-window.png` | horizontal luminance run at y=26 — the field's stroke at x=867, its fill from x=868, the glyph from x=878 |
| the same, on a more rounded capsule | 13 px | `voicememos-window.png` | same method — stroke x=643, fill from 644, glyph from 657 |

Everything above is a toolbar control or a pane field, and macOS 26 sizes
its toolbar controls well over the size a push button is published at — 36
px against 22 pt. The two are different controls in different places, so
neither reading corrects the other; both are recorded. The section below
measures the dialog controls themselves.

## What the dialog captures measure

Added 2026-09-11 by CE1.5, from `save-dialog-light.png` and
`save-dialog-dark.png` — a Save panel carrying a text field, a pop-up
button, a checkbox and two push buttons at regular size, window-bounded,
one capture per appearance at 1x. Both appearances agree to the pixel on
every row below, which is why one column carries them. Each height is the
first row the control leaves its sheet's fill to the last, the way this
reference reads a control's extent everywhere else; the sheet's own fill is
`#ffffff` light and `#232a2f` dark.

| control | measured | where | method |
| --- | --- | --- | --- |
| push button — "Cancel", "Save" | 24 px, y 501–524 | `save-dialog-{light,dark}.png` | luminance run down x=365, clear of the label: the fill `#ececec` light and `#333a3f` dark against the sheet |
| pop-up button — "Where:", "File Format:" | 24 px, y 281–304 and y 336–359 | same | the same run at x=440 and x=430 |
| text field — "Tags:", unfocused | 27 px, y 243–269 | same | the field's fill is the sheet's, so the run reads its border rows, `#f3f3f3` light and `#2c3338` dark |
| checkbox — "Options:" | 16 px square, y 372–387, x 264–279 | same | runs across and down the box; disabled here, which moves its fill and not its extent |
| push button width | 74 px, both buttons | same | x 359–432 and x 441–514 |
| the label's cap band | 10 px, y 508–517 | same | the bounding box of the label's marks inside the fill, each cap read on its own |
| the label's horizontal inset | "Cancel" 16 px leading, 17 trailing; "Save" 23 and 23 | same | the fill's edge to the first pixel of the label's marks |

**The inset is not a padding here.** Both buttons measure 74 px wide while
their labels measure 41 px and 28 px, so both are sitting at the platform's
minimum push-button width with the label centred in it; the 16 px and 23 px
above are what centring leaves, not what the platform insets by. A capture
of a push button whose label is long enough to drive its width would settle
the padding, and this pair does not.

**The cap band is the platform's standard label.** 10 px is what
`mail-window.png`'s search-field label reads in ADR-019's cap-band section,
so a dialog's push button is set in the same type as a toolbar's field.

## Where the measured heights disagree with the published ones

MEASURED, from the captures above, against the PUBLISHED rows below:

| control | published | measured | difference |
| --- | --- | --- | --- |
| push button, regular | 22 pt | 24 px | +2 |
| pop-up button | 22 pt | 24 px | +2 |
| text field | 22 pt | 27 px | +5 |
| label text size | 13 pt | a 10 px cap band, which is the platform's 14 pt label | +1 |
| checkbox | not published here | 16 px | — |

The 24 px push button is the number the 2026-08-05 `fittingSize` sweep
recorded for the regular push bezel, which the section below keeps and
which the density scale was ruled against. Two instruments that disagree
with the Human Interface Guidelines and agree with each other are worth the
ruling the guidelines got; CE1.5 changed no token, and `density.go` still
ships the published 22 and 19.

## What the platform publishes

PUBLISHED — Apple's Human Interface Guidelines for macOS, the button, text
field and pop-up button metrics. These are the drawn control's heights.

| control | regular | small | mini |
| --- | --- | --- | --- |
| push button | 22 pt | 19 pt | 16 pt |
| text field | 22 pt | — | — |
| pop-up button | 22 pt | — | — |
| label text size | 13 pt | 11 pt | — |
| horizontal inset beside a push button's label | about 8 pt | — | — |

## Where the readings disagree

An AppKit `fittingSize` sweep taken 2026-08-05, recorded in
`theme/tokens/density.go` until CE1.2 replaced it, read NSButton's push bezel
at mini 16 / small 20 / regular 24 / large 28 pt and NSTextField (rounded
bezel, regular) at 24 pt. `fittingSize` answers with the bezel's fitting box,
which is not the drawn control: it carries the margin the bezel keeps around
itself. Where the two disagree the density scale takes the published height
(owner ruling, 2026-09-10). The older reading is kept here so a later task
does not rediscover it as a contradiction.

## What the density scale takes

`theme/tokens/density.go`, from CE1.2:

| token | value | provenance |
| --- | --- | --- |
| `ComfortableControlHeight` | 22 dp | PUBLISHED: the regular push button, text field and pop-up button |
| `CompactControlHeight` | 19 dp | PUBLISHED: the small push button |
| `Comfortable.PaddingX` | 8 dp | PUBLISHED: the inset beside a regular push button's label |
| `Compact.PaddingX` | 7 dp | DERIVED: 8 × 19/22 = 6.9, rounded — no small-size inset is published |
| `Comfortable.PaddingY` | 1 dp | DERIVED: (22 − 20) / 2, where 20 dp is the LabelLarge line box a button is set in; a Comfortable button lands exactly on 22 |
| `Compact.PaddingY` | 0 dp | DERIVED: 20 > 19, so there is no room to pad with; a Compact button draws 20 dp against a 19 dp floor, 1 dp over |

The 1 dp overshoot at Compact closes only by moving a typography role, and
typography is not the density scale's to move.

## The gap, and how it closed

One capture would turn every PUBLISHED row above into a MEASURED one: a
**dialog or standard sheet** showing, at regular size, a push button, a text
field, a pop-up button and a checkbox — in both the light and the dark
appearance, window-bounded so the image is exactly the window's outer
bounds.

It landed 2026-09-11 as `save-dialog-light.png` and `save-dialog-dark.png`,
taken in the one batched session PLAN.md's "Measure from the stored
reference" allows, on macOS 26.5.2 (build 25F84), on the 2560×1440 display
at 1x where one pixel is one point. Every number is in "What the dialog
captures measure" above. The published rows are kept beside the measured
ones rather than replaced, because the density scale was ruled onto them
and only a ruling moves it.
