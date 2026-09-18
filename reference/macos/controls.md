# macOS control metrics

The numbers the density scale is built from, each with its provenance:
MEASURED (a stored capture, the method named), PUBLISHED (Apple's Human
Interface Guidelines, not read off this machine) or DERIVED (arithmetic on
the two, shown). Indexed by ADR-019, "The platform's control metrics".

Added 2026-09-11 by CE1.2; the dialog measurements and the ruling that the
measured numbers supersede the published ones are CE1.5 and CE1.6; the text
field's leading inset is CG4.19, its origin, its trailing end and the
pop-up's own label and mark are CG4.21, the pop-up's height, its
label's origin and its mark's whole geometry are CG5.1, the
switched-off controls and the states are CG5.2, the toolbar
control's own fill, edge, corner and mark are CG5.2b, and its height read
capture by capture is CG5.3b.

## What the stored captures measure

Every capture here is window-bounded (`screencapture -o -l <windowID>`) on a
2560×1440 display at ~109 ppi, where one pixel is one point — so the pixel
values below are point values, and the coordinates are window coordinates
with (0,0) at the window's top-left outer corner (ADR-019, "How the numbers
were taken").

| what | value | capture | method |
| --- | --- | --- | --- |
| toolbar control height — search field, capsule button, segmented control, pop-up button alike | 36 px, y 8–43 | `finder-window.png`, `mail-window.png`, `reminders-window.png`, `voicememos-window.png`, `notes-window.png` | luminance run down a column through each control; every bordered control in all five windows starts at y=8 and ends at y=43. Re-read capture by capture under "The toolbar control's height, capture by capture" below, where the one exception is recorded: Mail's folder pull-down stands lower in its band and measures 29 |
| that control's placement in the band | centred: 8 px above, 8 px below in a 52 px unified toolbar | same five | the band heights are ADR-019's "Title bar and toolbar bands" |
| text field outside a toolbar — Finder's info pane, "Add Tags…" | 33 px tall (y 263–295), 220 px wide (x 770–989) | `finder-window.png` | the field's fill (35,42,46) against the pane's (27,32,35), first and last row and column that leave the pane |
| a search field's leading inset: the field's inner edge to the first pixel of the magnifier glyph | 10 px | `mail-window.png` | horizontal luminance run at y=26 — the field's stroke at x=867, its fill from x=868, the glyph from x=878 |
| the same, on a more rounded capsule | 13 px | `voicememos-window.png` | same method — stroke x=643, fill from 644, glyph from 657 |
| that search field's gap: the glyph's last pixel to the prompt's first | 8 px | `mail-window.png` | the glyph spans x 878–890 and the prompt x 899–941, so eight clear columns stand between them. Read as a 2 px deviation from the field's own fill (36,45,50) over y 14–37, which is the run the leading inset above was read from. The sidebar field's gap is five, read the same way |
| that search field's prompt against the field's centre row | the prompt's cap band centred on it, the rounding falling half a pixel low | `mail-window.png` | "Search" occupies y 21–31 in a field of y 8–43: the band's centre is 26.5 against the field's 26.0. The sidebar field agrees — y 70–80 in a field of y 61–88, 75.5 against 75.0 |

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
| that text field's leading inset: the field's inner edge to the text's first pixel | 7 px | same | read off the focused "Save As:" field, the only one in the sheet holding a value. Its box runs x 264–495, the same columns the "Tags:" field below it runs, so its fill begins at x=265; the first pixel column of "Untitled" is x=272. The focus ring is drawn two columns outside the box, over x 262–266, which is why the box is read off the pair rather than off the ring. Both appearances give 272; dark carries one faint antialiased column at x=271, three of 255 above the selection's fill, which light does not, and a fringe is not the glyph's first column |
| that text field's text origin: the field's inner edge to the column the text is laid from | 6 px | same | the "Save As:" value is selected in the capture, and the selection fills from the run's origin: `#b4d8fd` light and `#406489` dark from x=271 against the fill beginning at x=265. The first covered pixel of "Untitled" is one column further in, at x=272, so the U carries 1 px of left side bearing in the face the platform sets the field in, and the 7 above is that origin plus that bearing |
| that text field's trailing end | no reading | same | nothing in either capture reaches it. The selection behind "Untitled" ends at x=318 and the value's last covered pixel at x=317, against an inner trailing edge at x=494; the "Tags:" field below holds no value at all. The trailing inset is the leading one mirrored until a capture holds a value that reaches a field's trailing edge, which is on the capture list |
| pop-up button's leading inset: the control's inner edge to the first pixel of its label | 12 px | same | the "File Format:" pop-up's fill runs x 264–451 with no edge column — a run down x=350 gives `#ececec` light and `#333a3f` dark from the first row of the control to the last, so its outer edge and its inner edge are one — and the first covered column of its label, "Script", is x=276 in both appearances. Five columns further in than the text field's 7 above: the platform sets a pop-up's label deeper than the field's text beside it. CG5.1 read the origin behind it the way CG4.19 read the field's: what a control spends is the origin and the face adds its first glyph's bearing, so the origin is 11. The bearing cannot be read off the S — that glyph's leading column carries only a fringe, 32 of the label's 200 levels light and 48 of its 173 dark, because an S opens on a curve and not on the U's stem — so it is the one column the "Untitled" of the field above exposes, where the selection gives the origin at x=271 against a first covered column at x=272 that is 90% covered |
| that pop-up's mark: its last pixel to the control's inner trailing edge | 9 px | same | the chevron pair spans x 435–442 against a fill ending at x=451. The same nine stands between a Mail toolbar pull-down's chevron and its own trailing edge: `mail-window.png`, the folder control, its chevron ending at x=748 against the capsule's trailing rim at x=757, in a control 29 px tall. The room is fixed and not a ratio of the control's height |
| that pop-up's mark: its extent | 8 px wide, 11 px tall — x 435–442, y 343–353 | same | CG5.1. Two chevrons point to point: the upper covers y 343–347 and points up, the lower y 349–353 and points down, five rows each, with y 348 left at the fill's own value across the whole eight columns |
| that mark's gap | 1 px | same | y 348, the one clear row between the two chevrons |
| that mark's stroke | ≈1.5 px perpendicular | same | an arm crossing a row covers about 2.1 columns — light row y=346 reads 108, 37 and 156 against a 236 fill and a 36 foreground, which is 0.64 + 0.99 + 0.40 — and the arm runs at 45°, so 2.1 × sin 45° ≈ 1.5. The same weight the pull-down's chevron is drawn at |
| that mark's vertical position | centred, the rounding falling half a pixel low | same | the pair covers y 343–353 in a control of y 336–359: seven rows above it and six below, where an exact centring of eleven rows in twenty-four is 6.5. The same rounding the Mail search field's prompt takes above |
| that mark's colour | `labelColor` | same | the pair's fully covered pixels read 36 light and (224,225,226) dark against fills of `#ececec` and `#333a3f`, which is `labelColor`'s 216 of 255 flattened onto each to the byte on every channel. `secondaryLabelColor`'s coverage would land at 118 and 163 — the mark is not drawn in it. The library spends `controlText`, which carries the same 216 in both appearances and is the name for a control's own marks |
| the Finder toolbar's pop-up draws the same glyph | 8 px wide, 11 px tall, upper y 21–25, lower y 27–31, x 726–733 | `finder-window-light.png` | the view pop-up in the toolbar band, in a control 36 px tall — identical in size to the dialog's, so the platform sizes this mark by its point size and not by the control it stands in |
| the Finder toolbar's pull-down draws ONE chevron | 8 px wide, 5 px tall — x 792–799, y 24–28 | same | the group control beside it: the pair's lower half alone, apex down, the same eight columns and the same five rows. Mail's folder pull-down reads 9 × 5 (`mail-window.png`, x 740–748, y 23–28) in a control 29 px tall; this one reads 8 × 5 in a control 36 px tall. The mark does not scale with the control it stands in, which is what `components/internal/toolbarface` models it as |
| checkbox — "Options:" | 16 px square, y 372–387, x 264–279 | same | runs across and down the box; switched off here, which moves its fill and not its extent |
| the second checkbox of the same pair | 16 px square, y 394–409, the same columns | same | the sheet carries two switched-off checkboxes, "Show startup screen" and "Stay open after run handler", and they agree to the pixel |
| the checkbox's row | 22 px | same | the pitch between the two squares: the first runs y 372–387 and the second y 394–409, so 394 − 372 = 22, with six clear rows between them. Both appearances agree to the pixel. The row is the pitch and nothing else — the sheet draws no row fill, seam or highlight behind a checkbox to read an extent off. It is neither the 24 px control height nor the 20 px list row, which is why `density.go` carries it as a number of its own |
| the checkbox's label against its square | the label's cap band centred on the square, the rounding falling half a pixel low | same | "Show startup screen" caps run y 375–385 against a square of y 372–387: a band centre of 380.0 against the square's 379.5. "Stay open after run handler" agrees — y 397–407 against y 394–409, 402.0 against 401.5. The same rounding the pop-up's mark and the Mail search field's prompt take. Read on the S of each label, the only cap either carries, so the band includes that letterform's overshoot |
| the checkbox's label, its leading gap | 6 px clear | same | the square's last column is x=279 and the label's first covered column x=286, in both appearances and both rows |
| radio button — "Automatically based on mouse or trackpad" | 16 px circle, y 696–711, x 253–268 | `system-settings-grouped-box-{light,dark}.png` | the selected radio's accent disc, read as the run of accent-blue pixels across and down; both appearances agree to the pixel. The same 16 the checkbox measures, which is what `components/input` draws the radio's circle at. It is the only radio or checkbox in that capture — the grouped boxes above it carry switches, not checkboxes — and it stands alone in its group with the capture's lower edge below it, so it gives the glyph's size and no row pitch |
| a switched-off control's fill | `#f2f2f2` light, `#2e3439` dark | same | flat-region samples of both checkboxes, x 264–279. The box draws no edge of its own: its rim is a one-pixel antialiased ramp from the fill to the sheet (`#f3f3f3` through `#fbfbfb` light), the way the pop-up above it meets the sheet with no edge column |
| the enabled fill it is read against | `#ececec` light, `#333a3f` dark | same | the "File Format:" pop-up's own fill, its last rows at y 355–359, seventeen rows above the first checkbox on the same sheet — the push button's measured fill |
| a switched-off control's coverage | 170 of 255 | same | the fraction of its own paint a switched-off control keeps over the surface it stands on. The enabled fill over the sheet at that coverage lands on the switched-off reading: light `#ececec` over `#ffffff` gives 242.33 → `#f2f2f2`, exact; dark `#333a3f` over `#232a2f` gives (45.67, 52.67, 57.67) → (46, 53, 58) against the measured (46, 52, 57), exact on red and one 255th over on green and blue — the tolerance the hover overlay's dark reading carries. No single coverage lands all four channels exactly, so the reading is recorded with its miss |
| a switched-off control's wording | `#bdbdbd` light, `#595f62` dark | same | the plateau of both checkbox labels on the sheet's own fill. Dark is `disabledControlTextColor`'s white at 63/255 to the byte on every channel. Light is three 255ths past `disabledControlTextColor`'s `#c0c0c0` — it is `tertiaryLabelColor`'s black at 66/255 exactly, and `#c0c0c0` pixels stand in the same labels — so the two names are one 255th-and-a-half apart in the light appearance and identical in the dark, where both report 63/255. A consumer spends `disabledControlTextColor`, the platform's name for a control's own switched-off text |
| push button width | 74 px, both buttons | same | x 359–432 and x 441–514 |
| the label's cap band | 10 px, y 508–517 | same | the bounding box of the label's marks inside the fill, each cap read on its own |
| the label's horizontal inset | "Cancel" 16 px leading, 17 trailing; "Save" 23 and 23 | same | the fill's edge to the first pixel of the label's marks |

## What the toolbar control measures

Added 2026-09-18 by CG5.2b, from `finder-window-untinted-{light,dark}.png`,
`finder-window-light.png` and `finder-window.png`. A control standing in a
toolbar band is a different control from the dialog's pop-up above — 36 px
against 24, a capsule against a rounded rectangle — and these are its own
numbers.

**Which capture is which window.** Read off the traffic lights: a saturated
hue means the window is frontmost and its controls are drawn active.
`finder-window-untinted-dark.png` is FRONTMOST (its yellow button reads
`#f8bb00`). `finder-window-untinted-light.png` is NOT (no pixel in its title
bar carries a hue over 127 of saturation) — it is an inactive window, and its
toolbar controls are the platform's faded drawing rather than a control's own.
`finder-window-light.png` and `finder-window.png` are both frontmost and both
were taken with wallpaper tinting ON.

| what | measured | where | method |
| --- | --- | --- | --- |
| a toolbar control's fill, frontmost, untinted, dark | `#262626` on a `#1e1e1e` band | `finder-window-untinted-dark.png` | flat-region samples of the search field's interior (x 1162-1372, y 47-80): `#262626` over 1731 of 1783 pixels, against a band flat at `#1e1e1e` over 6650 sampled pixels. Eight levels lighter than what it stands on. The band is the fill of whatever region lies under it, continued upward — `#1c1c1c` over the sidebar, `#1e1e1e` over the content — so a toolbar band carries no fill of its own |
| the same, frontmost, tinted, dark | `#242d32` on a `#232a2e` band | `finder-window.png` | the view pop-up at x 692-742, y 8-43, against the band at x 457-685. Lighter on every channel, which is the direction the untinted pair gives |
| the same, frontmost, light | `#ffffff` | `finder-window-light.png` | the view pop-up's interior, flat `#ffffff`. The band beneath it there is the content's own `#ffffff`, so this capture fixes the fill's VALUE and not its step: the control is told from its band by its drop shadow alone. On the chrome material this library paints, `#ffffff` stands eight levels lighter, which is the dark appearance's step to the level. Recorded in `nscolors.tsv` as the measured material `toolbarControlFill` |
| an INACTIVE window's toolbar control | `#f7f7f7` on a `#ffffff` band, its glyphs at `tertiaryLabelColor` | `finder-window-untinted-light.png` | the same flat-region method; the glyphs peak at 183 on the 247 fill, which is black at 66/255 over it to the byte. Recorded so a later reading does not take this capture for an active control: it is the platform's inactive drawing, and it runs the other way — the control is DARKER than its band |
| that control's height | 36 px | `finder-window-untinted-{light,dark}.png` | a run down x=1200 light gives `#f7f7f7` over y 34-69 and one down x=1250 dark gives `#262626` over y 47-80 with its rim rows at 46 and 81. The same 36 the toolbar-control row at the head of this reference records |
| that control's edge, dark | 1 px, `#404040` | `finder-window-untinted-dark.png` | the rows immediately above and below the fill read 64 at every column of the flat middle, and the columns at either end read 61-62 through the corner's antialiasing. `separatorColor` over the fill gives `#3b3b3b` and over the band `#323232`, so neither name lands it and the rim is recorded as the pixel. Voice Memos' dark toolbar field agrees in kind — a `#4d4d4d` rim over a `#363636` fill, already recorded in the sidebar search field's section |
| that control's edge, light | NONE | `finder-window-{light,untinted-light}.png` | the untinted capture steps from the band to the fill in one row with no stroke row. The frontmost capture has no darker row on any side either: a run down x=715 reads 251, 251, 251, 250, 250 and then the control's 255 from y=8, and a run across y=15 reads 252 down to 249 over x 686-696 and then 255 from x=697. What falls outside the control there is its drop shadow, which darkens AWAY from the control and never sits against it. So the platform's toolbar control wears a rim in the dark appearance only, and there it is a HIGHLIGHT — lighter than both its fill and its band |
| that control's corner | fully rounded — half its height | `finder-window-untinted-light.png`, `finder-window.png` | sub-pixel left-edge fits on the group pull-down (x 938.1 at its extreme, over rows 50-53, its own middle): circular fits row by row run 17.4, 18.1, 19.1 and 23.7 about the half-height's 18, the spread the platform's continuous corner puts on a circular fit everywhere else in this reference. The dark tinted view pop-up agrees: 36 px tall, its first row 12 columns in from its extreme against a capsule's 13.8 |
| that control's mark | the stacked chevron pair, 8 by 11 | `finder-window-light.png` | x 726-733, upper y 21-25, lower y 27-31, in a control 36 px tall — the same eight by eleven the 24 px dialog pop-up draws. The mark is sized by its point size, not by the control |
| that mark's colour | `controlText` | same | its darkest pixel reads 77 on the `#ffffff` fill, which is `controlText`'s 216/255 at 82% coverage — the coverage a 1.4 px diagonal reaches at this raster phase. `secondaryLabelColor`'s 127/255 would need 140% of a pixel to reach 77, so the toolbar's mark is NOT the secondary label; it is the same name the dialog's pair reads exactly. The icon beside it in the same control peaks at the same 77 |
| that mark's trailing clearance | 9 px | same | the pair ends at x=733 against a fill ending at x=742. The same nine the dialog's pop-up leaves in a control 24 px tall, so the clearance is fixed and not a ratio of the control's height |
| the pull-down beside it | ONE chevron, 8 by 5 | same | x 792-799, y 24-28, pixel for pixel the lower half of the pair: the group control is a menu of ACTIONS and not a choice. A picker is single-choice by contract, so nothing in this library draws it |

**The toolbar control's height, capture by capture.** Read by CG5.3b as a
luminance run down a column through each control's own middle. Every bordered
control in every Finder toolbar capture measures 36 px, and two windows from
other applications agree:

| capture | what was read | reading |
| --- | --- | --- |
| `finder-window-untinted-dark.png` | all five bordered controls in the band, whose flat rim runs are x 404-432, 818-921, 980-989, 1050-1115 and 1178-1356 at y=46 and again at y=81 | rim row y=46, `#262626` fill over y 47-80, rim row y=81 — **36 px** outer, the same at x=418, 870, 984, 1082 and 1250 |
| `finder-window-untinted-light.png` | the same band in the light appearance, controls at x 377-414, 895-909, 1032-1052, 1071-1089 and 1209-1355 | `#f7f7f7` fill over y 34-69 with no rim row on either side — **36 px**, read at x=405, 902, 1042, 1080 and 1280. This window is NOT frontmost, so its FILL is the platform's inactive drawing; its extent is not |
| `finder-window-light.png` | the view pop-up, frontmost | `#ffffff` over y 8-43 at x=715 — **36 px** — with the drop shadow's 250 above it and 244 below, which is all that tells it from the band there |
| `finder-window.png` | the same pop-up, dark, frontmost | rim rows at y=8 and y=43 with the `#242d32` fill between them at x=717 — **36 px** |
| `mail-window.png` | the toolbar search field | the `#242d32` fill over y 8-43 at x=900 — **36 px** |
| `notes-toolbar.png` | the whole band of a Notes toolbar | rim rows at y=8 and y=43 running 350 columns wide, `#232323` fill between — **36 px** |

The band those controls stand in is 52 px, so the platform leaves 8 px above
and 8 below (the row at the head of this reference). `tokens.Density` carries
the 36 as `ToolbarControlHeight` from CG5.3b, which is what settles the open
question the paragraph below recorded.

Mail's folder PULL-DOWN is the one control in these windows that does not read
36: at x=700 its fill runs y 20-47, one level off the band it stands on, which
is the 29 px the dialog-control table above already records it at. It stands
lower in the band than the search field beside it, so what it measures is a
second row and not the same row drawn shorter. Nothing in this library draws a
pull-down, so the reading is recorded and spent nowhere.

**The pop-up mark's stroke, re-read.** CG5.1 recorded ≈1.5 px perpendicular
from "an arm crossing a row covers about 2.1 columns … the arm runs at 45°".
The arm does not run at 45°: an eight-by-five chevron's centreline runs at
atan(2·5/8) = 51.3° off the horizontal. Re-read off
`save-dialog-light.png`, the upper chevron's left arm crosses row y=345 over
0.02 + 0.65 + 0.99 = 1.66 columns and row y=346 over 0.64 + 0.99 + 0.40 = 2.03,
a mean of 1.85, which perpendicular is 1.85 × sin 51.3° = 1.44 px. The whole
upper chevron covers 12.73 px² of that capture, which over a centreline of
2 × 4.7 px is 1.36 px of width. So the stroke measures 1.36 to 1.44 and the
recorded 1.5 stands as the nearest weight this system draws, with its miss
stated here.

**The mark's profile.** The platform draws two thin strokes meeting at a
point, not a wedge. Its upper chevron's coverage, row by row off
`save-dialog-light.png` (x 435-442, y 343-347), totals 0.38, 2.55, 4.09, 4.06,
1.65 of a pixel — a third of a pixel of paint in the apex row. A stroked polyline drawn
with this rasterizer is capped and joined ROUND, which puts 1.49 in that row
and reaches full width three rows down: that is the blob CG5.1's fresh eyes
read as "a filled wedge with rounded shoulders". The mark is therefore drawn
as a filled outline with a mitered apex and cut ends, which puts 0.46 in the
apex row against the platform's 0.38 and 11.3 px² of coverage against its
12.73. The remaining excess is at the arms' far ends, where the platform
tapers and a straight cut does not.

**The stroke is spent in pixels.** `gtx.Dp` rounds to a whole pixel, so a
1.5 dp stroke asked for through it is TWO pixels at one pixel per dp — a third
heavier than the measurement. The mark multiplies by the metric instead and
draws 1.5 px.

**The rim is drawn where it lifts.** The library's chrome trigger draws the
platform's seam over its own fill and draws it only where that lands LIGHTER
than the fill — the dark appearance, where the seam is white at 25/255 and
gives `#3b3b3b` over the `#262626` fill against the measured `#404040`, five of
255 short. In the light appearance the seam is black, it would darken the fill,
and the platform draws no edge there at all, so none is drawn. The rule is the
platform's behaviour stated once rather than an appearance the code tests for.

**What the library draws against these numbers.** The chrome trigger takes the
fill, the absence of a light edge, the capsule corner, the mark at its measured
size and clearance, and — since CG5.3b — the 36 itself, through
`tokens.Density.ToolbarControlHeight`. The two triggers are one component drawn
in two places and the place settles the height: the form trigger draws the
dialog pop-up's 24 and the chrome trigger the toolbar control's 36. The
corner follows, being half the height either way. What CG5.1 landed and CG5.3b
did not disturb is that the two variants spend one pair of insets and one
mark.

**What is open here.** No stored capture holds a toolbar control in the LIGHT
appearance, frontmost, standing on a band that is not the same white it is —
the one capture that would separate this control's fill from its band in that
appearance. One capture closes it: a **frontmost light window whose toolbar
band carries the sidebar material under a bordered control**, window-bounded
at 1x with wallpaper tinting off.

**What the state captures hold for a pop-up.** `control-hover-{light,dark}.png`
is the Finder window with the toolbar's VIEW POP-UP under the pointer — the
control drawing the stacked pair — and its fill reads `#f2f2f2` light and
`#384146` dark against `#ffffff` and `#242d32` at rest, which is exactly the
`hoverOverlay` already recorded in `nscolors.tsv` from that capture. So a
pop-up under the pointer takes the same overlay every other control takes and
no separate reading is owed. `control-pressed-{light,dark}.png` holds no
pressed pop-up at all: differenced against `save-dialog-{light,dark}.png` it
changes only x 359–432, y 501–524, which is the "Cancel" PUSH BUTTON. A
pressed pop-up is on the capture list.

**What the state captures hold for a push button.** `control-hover-{light,
dark}.png` holds no push button under the pointer — its pointer is on the
Finder toolbar's view pop-up, and that window carries no push button at all —
so nothing here measures a push button as exempt from the hover overlay, and
such a capture is on the capture list. What `control-pressed-{light,dark}.png`
does settle is that the two pointer states do not stack: the held "Cancel"
reads `#d5d5d5` light and `#474d52` dark, which is `pressOverlay` straight
over `pushButtonFill` on every channel, with no hover composited under it.
Differenced against the resting sheet the capture changes those 74 × 24 pixels
and nothing else, the "Save" button beside it holding its `#157efb`.

**The two pointer overlays disagree between the appearances.** Read off the two
state captures together: light, `hoverOverlay` is black at 0.051 and
`pressOverlay` black at 0.098, a ratio of 1.9 — a hovered control moves 13
levels off white and a held one 23 levels off `#ececec`. Dark, they are white at
0.094 and white at 0.098, a ratio of 1.04 — both move about 20 levels. So a dark
control drawn with its resting fill under the pointer and then held moves by one
255th between the two states, where the same pair in light moves by eleven. The
two coverages were read off different controls: hover off a Finder toolbar
control that carries NO fill at rest, press off a Save dialog push button over
the push button's own fill. Nothing in the reference says whether the platform
draws a weaker hover on a control that already carries a bezel than on the
fill-less toolbar control the dark reading came from. One control captured under
the pointer and then held, in the dark appearance, is what would settle it, and
it is on the capture list.

**What the sheet's switched-off controls are.** Read off
`save-dialog-{light,dark}.png`: the two "Options:" checkboxes are the only
switched-off controls in it. The "Save As:" and "Tags:" fields, the "Where:"
and "File Format:" pop-ups and both push buttons are enabled — their labels
read `labelColor`'s `#272727` light and `#dddfdf` dark where the checkbox
labels read `#bdbdbd` and `#595f62`. The "Save As:", "Tags:" and "Where:" row
labels read `#808080` light and `#9c9fa1` dark, which is `secondaryLabelColor`
over the sheet; that is the system panel setting its own row labels weaker
than the accessory view below it sets "File Format:" and "Options:", and it is
not a switched-off reading. So the sheet holds no switched-off push button and
no switched-off control that draws an edge, and the coverage above — read off
the checkbox's fill, which is all a checkbox draws — is what carries both the
fill and the edge until either capture is taken.

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

## What the list captures measure

Added 2026-09-11 by CE2.3, which needed the platform's row height for the
list and the table. Both readings are 1x window captures, so the pixels are
points.

| what | measured | where | method |
| --- | --- | --- | --- |
| a list row in the content — Finder's list view | 20 px pitch, no seam between rows | `finder-window-light.png` | luminance run down x=965, clear of every column's text: the stripes alternate `#ffffff` and `#f4f5f5` on an exact 20 px pitch from y=105 to y=284, and no row draws a hairline |
| the alternate row's fill | `#f4f5f5` | same | the flat fill of every second stripe. It is the second entry of AppKit's `alternatingContentBackgroundColors`, which answers `#f4f5f5` light and white at 0.05 dark — the light value to the byte. Recorded in `nscolors.tsv` as the measured material `alternatingContentBackground` |
| the column header's foot | 1 px, `#e5e5e5` | same | the row at y=79, under the "Name / Date Modified / Size / Kind" band. `separatorColor` over the content's white is `#e6e6e6`, so the header's seam is that name within one 255th |
| a sidebar row — Finder's | 32 px | same | the selected "Applications" row's fill, `#efefef`, runs y 148–179 at x=250. A sidebar row is not a content list row: it is 12 px taller |
| a message-list row — Mail's | 80 px dark, 92 px light | `mail-window.png`, `mail-window-light.png` | luminance run down x=380: dark rows are 79 px of `#232a2e` parted by one row of `#393f42` at y=145, 225, 305 …; light rows are 91 px of `#ffffff` parted by one row of `#e6e6e6` at y=249, 341, 433 …. Both hairlines are `separatorColor` over the fill beside them, to the byte. These are multi-line message rows and not the platform's single-line row height, so the density scale does not take them |
| the dim a sheet lays over the window it interrupts | black at 0.20 light, black at 0.26 dark | `save-dialog-light.png`, `save-dialog-dark.png` | the window standing behind the sheet. Light: its toolbar band and its document body both read `#cccccc` against the `#ffffff` the sheet itself carries, which is black at 0.20 exactly. Dark: its toolbar band reads `#1a1f22` against the measured `#232a2e` chrome material, which black at 0.26 reproduces on every channel (0.255 through 0.275 do; 0.25 does not). Recorded in `nscolors.tsv` as the measured material `scrim` |

**What the density scale took.** `Density.RowHeight` is 20 dp Comfortable,
MEASURED off Finder's list view above, and it replaces the control height as
the pin for every stacked row — list rows, table rows, header cells, sidebar
items. Compact carries the platform's small control height, 19 dp, because no
stored capture holds a list drawn dense; that gap is below.

**What is open here.** No capture holds a list at the platform's small row
size, so `CompactRowHeight` is the small control's published 19 pt rather
than a reading. One capture closes it: a **list or table drawn at the
platform's small row size**, window-bounded, at 1x. A second gap: no stored
capture holds a dark-appearance list view, so the alternate row's dark value
is AppKit's array answer alone rather than a pixel.

**What the sidebar row is not.** Finder's sidebar row measures 32 px against
its list row's 20, so the two are different rows and neither corrects the
other. The section below reads the sidebar's own row, and `patterns/sidebar`
takes it as of CE2.5: the 32 px row is that package's constant rather than a
second density token, because it is one region's geometry and not a scale a
consumer chooses.

## What the sidebar captures measure

Added 2026-09-11 by CE2.5, from the three captures the owner took the same
day with "Tint window background with wallpaper colour" switched OFF —
`finder-window-untinted-light.png` (1399×1063), `finder-window-untinted-dark.png`
(1443×1107) and `voicememos-sidebar-light.png` (1088×869). All three are 1x
captures on the 2560×1440 display where one pixel is one point; unlike the
rest of this reference they carry the window's drop shadow, so the window's
own opaque bounds start where the alpha ramp ends. macOS 26 draws an 8 px
light rim inside those bounds, and the sidebar's fill begins inside the rim.

| what | measured | where | method |
| --- | --- | --- | --- |
| the sidebar's fill, untinted | `#f7f7f7` light, `#1c1c1c` dark | `finder-window-untinted-{light,dark}.png` | flat-region samples of the rail: the light one is `#f7f7f7` over 188981 of the sampled pixels, the dark one is shaded `#1b1b1b`–`#1e1e1e` across the rail with `#1c1c1c` the mode. The content beside it reads `#ffffff` light and `#1e1e1e` dark, striped with `#f4f5f5` and `#292929` — the alternate row to the byte in both. So untinted, the chrome is a shade DARKER than the content in both schemes, where the tinted readings had it equal in light |
| a sidebar row | 32 px | all three | the selected row's pill spans y 78–109 light and y 90–121 dark in the Finder pair, and y 363–394 in the Voice Memos capture — 32 rows in each |
| the selected row's pill, frontmost | `#178bfb` under a white label | `voicememos-sidebar-light.png` | the pill is flat `#178bfb` over 5461 pixels, x 74–273, y 363–394. `mail-window-light.png` carries the same value. It is not `selectedContentBackgroundColor` (`#0064e1`) and not `controlAccentColor` (`#007aff`): it is the accent with the lift the platform's vibrancy adds over a sidebar material |
| the selected row's pill, not frontmost | `#f2f2f2` light, `#2a2a2a` dark | `finder-window-untinted-{light,dark}.png` | both captures were taken with the window behind the capturing session, so both show the unemphasized pill: light `#f2f2f2` over the `#f7f7f7` rail, dark `#2a2a2a` over the `#1c1c1c` rail. Neither is `unemphasizedSelectedContentBackgroundColor`, which reports `#dcdcdc` light and `#464646` dark, and no single coverage reproduces both — the light step is 0.185 of the way to that name and the dark one 0.333 |
| the pill's inset | 10 px from each edge of the rail | `finder-window-untinted-light.png` | the pill spans x 52–341 inside a rail whose fill spans x 42–351. The Voice Memos pill reads the same 10 against its own rail (x 74–273 in a rail spanning x 64–283) |
| the pill's corner | 8 px | both light captures | a circular fit to the sub-pixel coverage of the pill's top-left corner: 7.9 in the Finder capture (rms 0.05 px over seven rows) and 8.4 in the Voice Memos one (rms 0.21 px over eight). The platform's own corner is a continuous curve — a superellipse of exponent 4 fits it four times better than a circle — which is why the two circular fits differ; 8 is what a circular corner draws |

**What is open here.** No stored capture holds a DARK sidebar whose window is
frontmost, so the `#178bfb` pill has no dark partner and the light reading is
the only one. `patterns/sidebar` consequently paints the pill with
`controlAccentColor`, which is the name the platform's own answer is a lift
of, and follows the user's accent as the platform's does. One capture closes
it: **a sidebar in the dark appearance, its window frontmost, with a row
selected**, window-bounded at 1x with wallpaper tinting off so it pairs with
the light readings above. CE2.5 tried to take it and could not: the console
session was locked (`CGSSessionScreenIsLocked` 1) and `screencapture -o -l`
answers "could not create image from window" while it is. Rendering the row
offscreen through AppKit does not substitute — an `NSTableView` at
`style = .sourceList` drawn into a bitmap reproduces the dark unemphasized
pill as `#424242` where Finder draws `#2a2a2a`, because the platform's pill is
drawn with a vibrancy that has no backdrop offscreen.

## What the sidebar search field measures

Added 2026-09-17 by CG4.8, from `system-settings-grouped-box-light.png` and
`system-settings-grouped-box-dark.png` (723×720, the whole System Settings
window, one capture per appearance at 1x, wallpaper tinting ON — the pair
`cardFill` was read from) and from the toolbar search field in
`voicememos-sidebar-light.png` and `voicememos-window.png`. The System
Settings sidebar carries a search field at its top; that field is the recess
below. Coordinates are window coordinates, (0,0) at the window's top-left
outer corner.

| what | measured | where | method |
| --- | --- | --- | --- |
| the recess's fill | `#e8e8e8` light, `#2f3234` dark | `system-settings-grouped-box-{light,dark}.png` | flat-region samples inside the field, x 120–204, y 64–85: the dark one is `#2f3234` over all 1870 pixels; the light one is `#e8e8e7` over 1690 of them and `#e8e8e8` over the rest, the blue channel one 255th down with the whole rail's shading — the sidebar beside it reads `#fafaf9` over 34141 of 49400 sampled pixels against `#fafafa` over 4598. Voice Memos' toolbar field carries the light value flat: `#e8e8e8` over 4527 pixels |
| the recess's extent | 195 × **28 px**, x 18–212, y 61–88 | both | a luminance run down x=120, clear of the marks: the sidebar to the fill at y=61 and back at y=89, in both appearances to the row; a run across y=75 gives the two ends |
| the recess has no edge | none in either appearance | both | the runs above step from the sidebar to the fill in one row and one column — no stroke row, no rim row, and the only intermediate values are the corner's antialiasing |
| the recess's corner | fully rounded — 14 px, half its height | both light and dark | a circular fit to the sub-pixel coverage of the left end, its extreme pinned at x=18: r = 14.7, rms 0.38 px over 26 rows. The platform's corner is a continuous curve, which is what puts a circular fit above the half-height, exactly as the sidebar pill's 8 px corner fits at 7.9 and 8.4 above |
| the recess's insets from the sidebar's edges | 8 px leading, 8 px trailing | both | the sidebar's fill spans x 10–220 between a 2 px light rim at x 8–9 and the seam at x 221–222; the field spans x 18–212 inside it. The same 8 px on each side in both appearances |
| the recess's top | 53 px below the window's top outer edge | both | the window's top rim is at y=8 and the field's first row at y=61; the window buttons are centred at (25.5, 25.5), the red one spanning x 19–32, y 19–32 |
| the magnifier | 15 × 13 px, x 27–41, y 69–81 | both | the bounding box of the glyph's marks inside the fill. Its leading inset is 9 px — the recess's edge at x=18 to the glyph's first pixel at x=27 — and its centre row, y=75, is the recess's own (y 61–88) |
| the magnifier's lens | a ring, 11.68 px across and 9.73 down outside, its band 1.30 px across and 1.04 down, centred (32.86, 74.57) | both | sub-pixel edges from the coverage in each row and column, the extremes fitted by a parabola over three: left 27.00, right 38.68, top 69.69, bottom 79.41, and the band's thickness the coverage summed along a cut through each extreme. A radial profile about that centre, sampled every 5 degrees clear of the handle, runs 5.11 px along the row and 4.21 down the column — a period of 180 degrees, so it is an ellipse and not a mis-centred circle |
| the magnifier's handle | a band at 39.8 degrees below the row, its far end 11.08 px from the lens's centre | both | the principal axis of the coverage outside the lens's band in the lower trailing quadrant, and that axis's far extreme: the tip lands at (41.37, 81.66) against the lens's centre, 8.51 px along the row and 7.09 down |
| the same glyph in a toolbar | 13 × 13 px, a round lens 10.28 px across outside on a 1.32 px band, centred (883.17, 25.48); the handle at 43.7 degrees, its far end 10.15 px from that centre | `mail-window.png`, and `voicememos-window.png` agrees at 13 × 13 with a lens of 4.49 px centreline radius | a least-squares circle fitted to the coverage clear of the handle: rms 0.47 px about a radius of 4.51, which is the band's own thickness over √12 and so the fit of a circle, not of an ellipse. The same radial profile holds 4.39 to 4.56 px all the way round |
| the placeholder | an 11 px cap band, x 47–88, y 70–80, 5 px after the magnifier | both | the bounding box of "Search" inside the fill |
| the magnifier's and the placeholder's colour | `placeholderTextColor` over the recess — black at 127/255 light, white at 140/255 dark | both, and `voicememos-window.png` | light: the placeholder's darkest pixel is `#747474`, which is that coverage over `#e8e8e8` to the byte, and the magnifier's is `#787878`, four 255ths short because a thin ring never fully covers a pixel. Dark: the placeholder peaks `#979899` on the recess, white at 127/255 rather than the 140/255 AppKit answers with — Voice Memos' untinted dark toolbar field peaks `#a4a4a4` on its `#363636` fill, white at 140/255 to the byte, so the shortfall is this sidebar's vibrancy and not the platform's answer. `secondaryLabelColor` carries the same two coverages, so the mark and the prompt are one colour |

**The recess is a fill, not a step over what it stands on.** In the light
appearance the same `#e8e8e8` stands on two different chrome fills — System
Settings' `#fafaf9` sidebar and Voice Memos' `#ffffff` toolbar band — so it
cannot be a coverage over what it stands on. The direction does not
survive the scheme either: light, the recess is 18 levels darker than the
sidebar; dark, it is 19 levels lighter than it (`#2f3234` over `#1c2124`).
Recorded in `nscolors.tsv` as the measured material `sidebarSearchFill`,
which is the name the reading earns: one fill, read off a sidebar, carrying
neither a step nor the toolbar field's dark value.

**The toolbar field is a different control.** In the same two appearances
Voice Memos' toolbar search field measures 36 px tall (y 46–81 light, y 8–43
dark), against the sidebar recess's 28, and in the dark appearance it wears a
1 px `#4d4d4d` rim above and below its `#363636` fill where the sidebar
recess wears none. Its light fill is the recess's `#e8e8e8` and its dark fill
is not, so neither capture corrects the other and both are recorded.

**The sidebar's magnifier is the toolbar's glyph drawn wide.** The three
stored search fields carry one drawing at one size — 13 × 13 px across its
marks in Mail's toolbar and in Voice Memos' capsule, a round lens 10.28 px
across outside on a band of 1.3, its handle at 45 degrees reaching twice the
lens's outer radius from the lens's centre. System Settings' sidebar draws the
same glyph 15 px wide: the lens's centreline radius is 5.11 px along the row
against 4.21 down the column, an aspect of 1.21 where the toolbar's is 1.00,
and the handle sits at 39.8 degrees rather than 43.7 — which is what that same
aspect does to a 45 degree band, since atan(1/1.21) is 39.6. Against the
toolbar's reading the sidebar's glyph is 1.13 times the radius along the row
and 0.93 times it down the column; the handle's far end is 1.19 times as far
along the row and 0.98 as far down it.

The stretch is that application's rasterising and not the capture's. A window
button in the same picture has a coverage-weighted spread of 4.009 px on both
axes, a ratio of 1.000, so the pixels are square and every other reading off
this capture stands. What a library draws from this pair is the round glyph at
the sidebar's placement: two captures out of three read it round, and an
ellipse is one application's raster rather than a shape the platform owns.
Recorded 2026-09-17 by CG4.13.

**Where the drawn height already lands.** A Comfortable text field in this
library draws 28 dp — BodyLarge's 24 dp line box plus 2×2 dp of the density's
padding, over the 27 dp floor — which is the recess's measured 28 to the
pixel. The chrome variant therefore takes no height of its own; it takes the
corner, the fill and the absence of an edge.

**What is open here.** The dark reading was taken with wallpaper tinting on,
so `#2f3234` carries the desktop picture's cast the way `cardFill`'s
`#2a3034` does, and the sidebar it stands on reads `#1c2124` rather than the
untinted `#1c1c1c` recorded as `sidebarMaterial`. No stored capture holds a
sidebar search field in the dark appearance untinted. One capture closes it:
a **window with a search field at the top of its sidebar, in the dark
appearance, with "Tint window background with wallpaper colour" switched
off**, window-bounded at 1x.

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
| `ComfortableRowHeight` | 20 dp | MEASURED: Finder's list view in `finder-window-light.png`, a 20 px stripe pitch with no row seam. Added by CE2.3; it replaces the control height as the pin for every stacked row |
| `CompactRowHeight` | 19 dp | PUBLISHED: the small push button, carried until a capture holds a list drawn dense |
| `ComfortableCheckboxRowHeight` | 22 dp | MEASURED: the pitch between the two "Options:" checkboxes in `save-dialog-{light,dark}.png`, squares at y 372–387 and y 394–409. Added by CG5.3; it is the footprint the 16 px glyph is centred in, and the checkbox's and the radio's pointer target |
| `CompactCheckboxRowHeight` | 17 dp | DERIVED: 22 × 19/24 = 17.4, rounded — the same regular-to-small ratio `CompactFieldHeight` takes, until a capture holds a small checkbox |
| `ComfortableToolbarControlHeight` | 36 dp | MEASURED: every bordered control in the Finder toolbar captures, per capture in "The toolbar control's height, capture by capture" below. Added by CG5.3b; it is the height a bordered control standing in a chrome region draws, against the dialog control's 24 |
| `CompactToolbarControlHeight` | 36 dp | CARRIED: no capture holds a toolbar drawn at the platform's small size, and all five stored windows draw their toolbar controls at one height, so Compact carries the measured 36 until one does |
| `Comfortable.PaddingX` | 8 dp | PUBLISHED: the inset beside a regular push button's label. The capture cannot correct it — both buttons sit at the platform's 74 px minimum width with their labels centred |
| `Compact.PaddingX` | 7 dp | DERIVED: 8 × 19/22 = 6.9, rounded — the published small-to-regular ratio, both operands published, since neither the inset nor the small control is captured |
| `Comfortable.PaddingY` | 2 dp | DERIVED: (24 − 20) / 2, where 20 dp is the LabelLarge line box a button is set in; a Comfortable button lands exactly on 24 |
| `Compact.PaddingY` | 0 dp | DERIVED: 20 > 19, so there is no room to pad with; a Compact button draws 20 dp against a 19 dp floor, 1 dp over |

The checkbox's measured 16 px is in `density.go`'s provenance table as a
line, not as a token: the checkbox's side length lives in
`components/input`, which is where a consumer takes this number. Its ROW is a
token, added by CG5.3: the glyph does not move with density and the footprint
it is centred in does.

**Which stored captures hold a checkbox or a radio.** Only two.
`save-dialog-{light,dark}.png` holds the pair of switched-off "Options:"
checkboxes the rows above are read from, and it is the only capture holding
two of them stacked, so it is the only one that can give a row pitch.
`system-settings-grouped-box-{light,dark}.png` holds one selected radio, the
"Automatically based on mouse or trackpad" row of the "Show scroll bars"
group; everything else in that window's grouped boxes is a switch, a pop-up, a
colour swatch or a picture chooser, and the capture's lower edge falls below
that radio before a second one, so it gives the glyph and no pitch. No
stored capture holds a checkbox at the platform's small size.

Two overshoots are recorded rather than hidden, and both close only by moving
a typography role, which is not the density scale's to move: a Compact button
draws 20 dp against its 19 dp floor, and a Comfortable text field draws 28 dp
against the platform's measured 27, BodyLarge's 24 dp line box plus the
control's own 2 dp padding.

**What a Compact pop-up does with its label.** Read 2026-09-18 by CG5.2b
against the small control rows above: the platform's small control is the
published 19 pt, no stored capture holds one, and the capture that would close
it is on this reference's list. BodyLarge's line box is 24 dp at every
density, so a Compact pop-up draws a 19 dp control around a 24 dp line box.
What is cut is the leading that line box carries, not the type: the role's cap
band measures 12 px — CG5.1's fresh eyes read it on the gallery's own trigger —
and 12 stands inside 19 with three and a half rows either side. So both
triggers cap the line box to the control's height and clip what they draw to
their own shape, and the role's size does not move. Whether BodyLarge is the
right size for a control's label at all is typography's question and is pooled.

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
