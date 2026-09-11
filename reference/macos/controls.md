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

**The reference holds no push button, checkbox, pop-up button or text field
at regular size in a dialog or a sheet.** Everything above is a toolbar
control or a pane field, and macOS 26 sizes its toolbar controls well over
the size a push button is published at — 36 px against 22 pt. The two are
different controls in different places, so neither reading corrects the
other; both are recorded, and the gap below says what would settle it.

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

## The gap, and how it closes

One capture would turn every PUBLISHED row above into a MEASURED one: a
**System Settings dialog** (or any standard sheet) showing, at regular size,
a push button, a text field, a pop-up button and a checkbox — in both the
light and the dark appearance, window-bounded so the image is exactly the
window's outer bounds. From it: each control's height, the horizontal inset
between a push button's edge and the first pixel of its label, and that
label's line box.

The owner supplies it. Nothing is launched from a task to close this gap —
PLAN.md's "Measure from the stored reference" — and when it lands, store it
here under a name that says which OS it is, read the numbers off the pixels,
replace the published rows with measured ones, and leave this section
standing with the date it closed.
