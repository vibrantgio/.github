# macOS control metrics

The numbers the density scale is built from, each with its provenance:
MEASURED (a stored capture, the method named), PUBLISHED (Apple's Human
Interface Guidelines, not read off this machine) or DERIVED (arithmetic on
the two, shown). Indexed by ADR-019, "The platform's control metrics".

Added 2026-09-11 by CE1.2; the dialog measurements and the ruling that the
measured numbers supersede the published ones are CE1.5 and CE1.6.

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
its toolbar controls well over the size a push button is drawn at in a
dialog — 36 px against the 24 px measured below. The two are different
controls in different places, so neither reading corrects the other; both are
recorded. The section below measures the dialog controls themselves.

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

**The push button's fill is a colour, not only a height.** The `#ececec`
light and `#333a3f` dark this row reads off "Cancel" are recorded in
`nscolors.tsv` as the measured material `pushButtonFill`, because
`controlColor` is not that value in either appearance: it reports `#ffffff`
light and white at a quarter dark, which is the bezel's backing rather than
the fill the platform draws. The "Save" button beside it is the default
action and reads `#157efb`, the accent under the bezel's own gradient;
that gradient is not recorded, so a consumer paints `controlAccentColor`
flat.

**The inset is not a padding here.** Both buttons measure 74 px wide while
their labels measure 41 px and 28 px, so both are sitting at the platform's
minimum push-button width with the label centred in it; the 16 px and 23 px
above are what centring leaves, not what the platform insets by. A capture
of a push button whose label is long enough to drive its width would settle
the padding, and this pair does not.

**The cap band is the platform's standard label.** 10 px is what
`mail-window.png`'s search-field label reads in ADR-019's cap-band section,
so a dialog's push button is set in the same type as a toolbar's field.

## Where the measured heights supersede the published ones

MEASURED, from the captures above, against the PUBLISHED rows below. Where
the two disagree the measured number is the platform's answer and the
published one is superseded (owner ruling, 2026-09-11): the application is
judged against the platform, and the guidelines are a document about it.

| control | published | measured | difference | what ships |
| --- | --- | --- | --- | --- |
| push button, regular | 22 pt | 24 px, `save-dialog-{light,dark}.png` | +2 | 24, MEASURED |
| pop-up button | 22 pt | 24 px, same pair | +2 | 24, MEASURED — the same number as the push button |
| text field | 22 pt | 27 px, same pair | +5 | 27, MEASURED, as its own number: the platform does not draw a field at a button's height |
| checkbox | not published here | 16 px square, same pair | — | 16, MEASURED — recorded here and in `density.go`'s provenance table; not a density token, since the checkbox carries its own side length in `components/input` |
| label text size | 13 pt | a 10 px cap band, which is the platform's 14 pt label | +1 | neither — typography is not the density scale's to move, and no task in this phase touches it |
| push button, small | 19 pt | uncaptured | — | 19, PUBLISHED — the one number here still waiting on a capture |
| horizontal inset beside a push button's label | about 8 pt | unreadable off this pair | — | 8, PUBLISHED — see "The inset is not a padding here" above |

The 24 px push button is the number the 2026-08-05 `fittingSize` sweep
recorded for the regular push bezel, which the section below keeps. Two
instruments that disagree with the Human Interface Guidelines and agree with
each other got the ruling: `density.go` ships the measured heights as of
CE1.6.

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
itself. Its regular push bezel of 24 pt nonetheless lands on the 24 px the
Save panel draws, which is why the two instruments are read as agreeing. The
older reading is kept here so a later task does not rediscover it as a
contradiction; the published-over-measured ruling of 2026-09-10 was reversed
on 2026-09-11, and the density scale now takes the measured height.

## What the density scale takes

`theme/tokens/density.go`, from CE1.6:

| token | value | provenance |
| --- | --- | --- |
| `ComfortableControlHeight` | 24 dp | MEASURED: the regular push button and pop-up button in `save-dialog-{light,dark}.png`, both appearances agreeing to the pixel. Supersedes the published 22 pt |
| `CompactControlHeight` | 19 dp | PUBLISHED: the small push button — no capture holds a small control |
| `ComfortableFieldHeight` | 27 dp | MEASURED: the text field in the same pair. Supersedes the published 22 pt, and is a second number because the platform draws a field taller than a button |
| `CompactFieldHeight` | 21 dp | DERIVED: 27 × 19/24 = 21.4, rounded — the measured field-to-control ratio applied to the small control, until a small field is captured |
| `Comfortable.PaddingX` | 8 dp | PUBLISHED: the inset beside a regular push button's label. The capture cannot correct it — both buttons sit at the platform's 74 px minimum width with their labels centred |
| `Compact.PaddingX` | 7 dp | DERIVED: 8 × 19/22 = 6.9, rounded — the published small-to-regular ratio, both operands published, since neither the inset nor the small control is captured |
| `Comfortable.PaddingY` | 2 dp | DERIVED: (24 − 20) / 2, where 20 dp is the LabelLarge line box a button is set in; a Comfortable button lands exactly on 24 |
| `Compact.PaddingY` | 0 dp | DERIVED: 20 > 19, so there is no room to pad with; a Compact button draws 20 dp against a 19 dp floor, 1 dp over |

The checkbox's measured 16 px is in `density.go`'s provenance table as a
line, not as a token: the checkbox's side length lives in
`components/input`, which is where a consumer takes this number.

Two overshoots are recorded rather than hidden, and both close only by moving
a typography role, which is not the density scale's to move: a Compact button
draws 20 dp against its 19 dp floor, and a Comfortable text field draws 28 dp
against the platform's measured 27, BodyLarge's 24 dp line box plus the
control's own 2 dp padding.

## The gap, and what is left of it

One capture closed the regular-size gap: a **dialog or standard sheet**
showing, at regular size, a push button, a text field, a pop-up button and a
checkbox, in both appearances, window-bounded so the image is exactly the
window's outer bounds.

It landed 2026-09-11 as `save-dialog-light.png` and `save-dialog-dark.png`,
taken in the one batched session PLAN.md's "Measure from the stored
reference" allows, on macOS 26.5.2 (build 25F84), on the 2560×1440 display
at 1x where one pixel is one point. Every number is in "What the dialog
captures measure" above, and CE1.6 shipped them over the published ones.

**What is still open.** No capture holds a control at the platform's *small*
size, so `CompactControlHeight` is still the published 19 pt and
`CompactFieldHeight` is derived from the regular pair's ratio. One capture
closes it: a **window or sheet showing a small push button and a small text
field**, in both appearances, window-bounded, at 1x — a control-size
inspector pane or any application that draws its controls small. Until it
exists, Compact is the one setting in the scale whose height is not read off
this platform.

**Also open, smaller.** The horizontal inset beside a push button's label
cannot be read off the stored pair: both buttons sit at the platform's
minimum width with their labels centred. A capture of a push button whose
label is long enough to drive its width would settle it; `Comfortable.PaddingX`
stays the published 8 pt until one exists.

**Also open: the tooltip.** No stored capture holds a help tag, so the fill,
the edge and the text of `components/tooltip` are the Language's mapping of
what a floating annotation is on this platform — the window background
inside a separator hairline, the label colour on it — rather than three
numbers read off a capture. One capture closes it: a **help tag standing
beside its control**, in both appearances, window-bounded, at 1x.
