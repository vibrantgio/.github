---
date: 2026-09-13
task: CF1.1
phase: CF
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CF1.1 — the signals, read cold

## The reply, verbatim

I read all ten renders and all five reference captures, and sampled pixels with Pillow. Everything below is measured off those files; where the reference set contains no equivalent, I say so instead of guessing.

---

## Redundant

**The four one-line alert rows and the four one-line toast rows are the same control twice.** Both are a rounded box holding a single sentence, keyed by the same four statuses in the same four hues. The alert card measures 520 × 56 px with a coloured triangle on the left; the toast measures 240 × 35 px with an 8 px-wide coloured bar on the left (x36–43). The text ink is identical in both (#272727 light, #DDDDDD dark). Nothing distinguishes them on screen except width and which shape carries the hue. The reference set shows the platform's answer for a message the user must deal with — the Save sheet, which comes with Cancel and Save push buttons — and neither of these two has any button at all, so as drawn they are two spellings of one passive notice.

**Three separate encodings of the same five statuses inside the badge sheet.** Row 1 is five filled pills; row 3 is five 16 × 16 discs with a check; row 4 is the same five discs with a cross. The disc rows carry no information the pill row does not, and the check disc and cross disc differ only by the glyph inside a fill of the identical colour (grey #8E8E93, green #34C759, orange #FF8D28, red #FF383C, blue #0088FF in light). That is fifteen objects for five meanings. "Popular", "128" and the bare check on the Utterances row are the same green pill again at three widths.

**The tooltip duplicates something AppKit hands you for free.** Every NSView has a `toolTip` string and the system draws the help tag itself — delay, placement, shadow and all. What is drawn here is a 101 × 24 px box whose fill is byte-identical to the page behind it (255,255,255 in light; 30,30,30 in dark), separated only by a 1 px #E6E6E6 / #343434 hairline. The reference set has no captured help tag to measure against, so I will not claim a specific fill is correct — but I can say that the one floating layer I *can* measure, the Save sheet, separates from what it floats on by a fill change (#FFFFFF on #CCCCCC, contrast 1.61) rather than by a hairline over an identical fill. A hand-rolled tag with no elevation cue is strictly worse than the one you get by setting a string.

**The back and forward chevrons in the icon sheet.** Finder's toolbar in both `finder-window-light.png` and the untinted captures already shows this exact pair, and on the Mac it is a standard segmented toolbar item, not a glyph you place yourself.

---

## Missing for an ordinary Mac application

Measured against the two reference windows, the whole operable half of the toolkit is absent. None of the ten renders contains:

- **A push button.** The Save dialog has two — Save, filled #157EFB and 24 px tall (y501–524), and Cancel, face #ECECEC. This is the single most-used control on the platform and there is nothing in the set that is pressable except a badge's close mark.
- **A text field.** The Save As field is 22 px tall inside a 3 px blue focus ring (#89B6F8 at the ring, y205–208 and y231–234); the Tags field below it is white-on-white with a #F3F3F3 border.
- **A pop-up button.** Two in the Save dialog (Where, File Format), fill #ECECEC on the light sheet, #333A3F on the dark one, with the up/down chevron stepper at the right edge.
- **Checkboxes** — the two Options rows.
- **A sidebar / source list with a selected row.** Finder's, selection #F2F2F2 on a #F7F7F7 sidebar in light, #2A2A2A on #1C1C1C in dark; the tinted capture shows the accent-filled variant.
- **A table with column headers and alternating rows** — Finder's list, rows alternating #FFFFFF / #F4F5F5 in light and #1E1E1E / #292929 in dark, with a sortable Date Last Opened header.
- **A toolbar, a search field, scroll bars, window chrome, a progress indicator, menus.**

Also missing *within* the components that are present: the toast has no close control and no action, and the alert has neither a title line nor a dismiss — yet the badge, the least consequential of the three, is the only one that got a close mark.

---

## Wrong for the platform

**The badge palette is not the Mac's blue.** The Info badge and the dismissible badge are filled #0088FF in light and #0091FF in dark. The platform's control blue, measured on the Save button, is #157EFB — and it is *the same* #157EFB in both light and dark captures. A pill in a blue the system never paints, sitting beside a real Save button, reads as a foreign chip.

**White text on the Success and Warning badges is roughly half the contrast the platform itself will accept.** White on #34C759 is 2.22:1 (2.02:1 on the dark #30D158); white on #FF8D28 is 2.31:1 (2.23:1 dark); white on the neutral #8E8E93 is 3.26:1 (2.87:1 dark). The worst white-on-colour anywhere in the references is the Save button at 3.88:1. The green and orange badges are below that by a factor of about 1.7.

**Dark-mode elevation runs the wrong way on the toast.** The toast body is #1E1E1E (relative luminance 0.0130) floating on a #2A3034 surface (0.0285) — the floating thing is *darker* than what it floats on, at 0.45× the luminance. In the dark Save dialog the sheet #232A2F (0.0222) sits on the window #191A1B (0.0102) — 2.17× *lighter*. The magnitude of separation is comparable (1.25 vs 1.20 contrast); the direction is inverted.

**The alert's status mark is a play triangle.** It is a solid right-pointing triangle, 10 px wide × 20 px tall, in the status hue. Nothing in either reference window uses a solid triangle as a status mark; a solid right-pointing triangle is a play or disclosure affordance, and four stacked rows each led by one read as a list of things to run.

**The platform control marks are drawn at body-text weight.** The disclosure, back and forward chevrons and the sidebar glyph in the icon sheet all bottom out at #272727–#292929 on white — contrast 14.9:1, and exactly the ink Finder uses for a filename (#272727). In the *active* Finder window the heaviest toolbar glyph of any kind measures #4D4D4D (8.45:1) and the back/forward chevrons measure #BFBFBF (1.84:1). Dark is the same story: the render's forward chevron peaks at #DDDDDD on #1E1E1E (12.3:1) where Finder's peaks at #676767 on #262626 (2.68:1). They are also oversized — 10 × 18 px against Finder's 8 × 14 px, about 1.28×. These marks are secondary furniture on the Mac and here they are the loudest ink on the sheet.

**The info mark is inverted and outsized.** It is a 34 × 34 px filled disc with a knocked-out "i" — fill #272727 in light, and in dark it inverts to a near-white #DDDDDD disc, making it the single brightest object in the dark render. The Mac's own info button, bottom-left of the Save dialog window, is a 13 × 13 px outline glyph. That is 2.6× the size, filled where the platform is outlined.

**Hover and press on the dismissible badge are effectively invisible, and in dark they are indistinguishable from each other.** Light: base #0088FF, hover #0081F2, press #007BE6 — hover against base is 1.10 contrast, press against base 1.20. Dark: base #0091FF, hover #189BFF, press #199CFF — press against hover is 1.0097, a difference of one code value per channel. A still capture cannot show a transition, but it can show the end states, and in dark the pressed state and the hovered state are the same colour to within rounding.

---

## Two things I checked and found *not* wrong

I want to flag these because they look like defects and are not.

**The hairline-bordered alert card is legitimate Mac practice.** I was ready to call the alert wrong for having a fill identical to the page with only a 1 px #E6E6E6 border. But the Tags field in the Save dialog is #FFFFFF on a #FFFFFF sheet with a #F3F3F3 border — contrast 1.11, *fainter* than the render's 1.25. The render's hairline is stronger than the platform's. (In dark, macOS does give that field a lighter fill, #2C3338 on #232A2F, where the render's alert gets none — so dark is the weaker half, but it is a small point, not a defect.)

**The body and secondary text colours are right on the money.** Primary text in the alerts, toasts and tooltip is #272727 light / #DDDDDD dark — byte-identical to Finder's filename ink in both appearances. The row labels and icon captions are #828282 light / #999999 dark against Finder's Kind column at #808080 / #9A9A9A. A dark label reading grey at 1× is antialiasing, not a colour error.

## How it was asked

Ten offscreen renders at 1 px per point, one per gallery section in each
appearance: `components-badge`, `components-alert`, `components-toast`,
`components-tooltip` and `components-icon`, light and dark, each drawn with
its own heading above it on the appearance's window plane.

Beside them, five stored captures of this machine's own system:
`save-dialog-light.png`, `save-dialog-dark.png`,
`finder-window-untinted-light.png`, `finder-window-untinted-dark.png` and
`finder-window-light.png`.

The reviewer had seen neither the plan nor the packet, was given no
checklist, was told to compare against the captures and never against macOS
from memory, was handed the recorded misreads verbatim, and was asked the one
question of this task.
