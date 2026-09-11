---
date: 2026-09-11
task: CE2.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE2.2 fresh-eyes review — the converted controls and signals

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about, looking at these as macOS controls?

**It was briefed on the recorded misreads** — dark foreground reading
grey at 1x, chrome regions sharing one fill by design, and a still
capture being unable to show a fade, a hover or a cursor. It took the
briefing seriously enough to sample the pixels itself and to drop two
findings its eye had produced but the data contradicted, which it says
in its first line.

## How the captures were taken

**No window was opened.** Both images were rendered headlessly at one
device pixel per point by a throwaway harness inside `components`,
composing this task's own specimens in both recorded appearances at
640×560: a row of four buttons (filled, tonal, ghost, disabled tonal),
a row of badges (the five statuses worded, a count, a bare glyph and a
disc), a text field, a checkbox and a radio, three alerts and two
toasts. The harness was deleted after the run; it is not in the commit.

**It is not the gallery.** The task asked for the gallery's own
sections, and `components/gallery` cannot be built in this task: its
inventory imports sixteen `patterns` packages and `markdown`, and its
main imports `effects/springbutton`, so the module does not compile
until CE2.3 and CE2.4 have landed. The composition above is this
module's own specimens standing in for it. The gallery's own review is
owed when the gallery is converted.

## What this task changed in them

The signals converted to the platform's colour set — the badge to the
system colours under white, the alert to a box on the content's fill
inside a separator hairline with the status on its glyph, the toast to
the window's own plane with the status on its leading edge, the tooltip
to the same plane inside a hairline — and the push button's measured
fill replaced `controlColor` on the tonal button, the disabled button,
the chip at rest and the picker's trigger. No geometry, no spacing, no
type.

## The reviewer's reply, verbatim

> I sampled the actual pixels rather than trusting my eye at 1x — several things I *thought* I saw (capsule buttons, non-adapting palette) the pixel data contradicted, so those are dropped. Here is what a macOS developer would actually complain about.
>
> ## Badges — the text fails contrast, all of it
>
> White ~10px text on saturated fills:
>
> | Badge | Fill | White-on-fill |
> |---|---|---|
> | Success | `#34C759` | **2.22:1** |
> | Warning | `#FF8D28` | **2.31:1** |
> | Neutral | `#8E8E93` | **3.26:1** |
> | Error | `#FF383C` | **3.57:1** |
> | "9" | `#0088FF` | **3.9:1** |
>
> Every one is under 4.5:1 at a size well below the large-text exemption. Success and Warning at 2.2:1 are the worst thing in either screenshot. Apple uses systemGreen/systemOrange as *glyph* colours or as fills behind dark text — never as a bed for 10px white. Nobody shipping this would get it past a11y review.
>
> ## Light appearance was never actually designed
>
> - **Message-box borders are `#F9F9F9` on a `#FFFFFF` window — 1.04:1.** The three cards have no fill of their own (interior samples `#FFFFFF`, identical to the window) and a border you cannot perceive. In light mode those boxes do not visually exist; you see a triangle and a line of text floating on white. Dark mode gets `#474747` on `#1E1E1E` (~3.3:1) and the cards read fine. The light theme is the dark theme with the values left un-derived.
> - **The text field is worse: `#F3F3F3` border on white, 1.03:1, 1px.** An invisible input. No well, no fill, no bezel. On macOS a bezeled field is the one thing guaranteed to look recessed; here it's nothing but grey placeholder text hanging in space.
> - **Placeholder is `#BEBEBE` on white — 1.86:1.** Dark mode's placeholder is `#C2C2C2` on `#1E1E1E`, 9.36:1. A 5× swing in legibility between appearances for the same string.
> - **Body text is `#6C6C6C` in light (5.25:1) vs `#EEEEEE` in dark (14.4:1).** This is not the dark-reads-grey misread — it's the inverse, and it's measured. Light mode's *primary* text sits at what AppKit calls secondaryLabelColor.
> - Related: **`#6C6C6C` is the only text colour in the light window** — body text, "Learn more", near enough the Cancel label (`#636363`). There is no labelColor/secondaryLabelColor hierarchy at all; everything is one mid grey.
> - The one place `#ECECEC` appears is as a *button fill*. That is AppKit's windowBackgroundColor. They put the window colour on the buttons and pure white on the window — exactly inverted.
>
> ## Buttons
>
> - **Cancel and Disabled are the same fill, byte for byte** — `#ECECEC` light, `#333A3F` dark. The only thing separating an enabled secondary button from a dead one is the label.
> - **And in light mode that label is unreadable:** disabled text `#D0D0D0` on `#ECECEC` = **1.31:1**. In dark it's 3.65:1 and perfectly legible. So the light-mode Cancel and Disabled buttons are two near-identical grey rectangles, one of which appears blank. macOS dims a disabled title to ~25% opacity, which still lands near 3:1 — readable, just obviously off.
> - **"Learn more" is `#6C6C6C`/`#EEEEEE` — plain label colour, not accent.** It reads as static text, not a button. A borderless AppKit button used as a link is tinted.
> - **Optical spacing in the row goes 12px, 32px, 32px.** Save→Cancel is 12; Cancel→"Learn more"→Disabled are 32 each, because the borderless button carries invisible padding its neighbours don't. The row looks broken into two clumps.
> - Read as a dialog row, **Save sits left of Cancel** — the confirm button belongs on the right on macOS.
>
> ## Two different blues, one of which doesn't adapt
>
> Every semantic colour correctly ships its Apple light/dark pair: green `#34C759`→`#30D158`, orange `#FF8D28`→`#FF9230`, red `#FF383C`→`#FF4245`, grey `#8E8E93`→`#98989D`. Blue does not:
>
> - **Save button, checkbox and radio are `#007AFF` in *both* appearances.** systemBlue's dark variant is `#0A84FF`. The accent is the single colour in the window that failed to get its dark value.
> - **The message-box triangles are a *different* blue: `#0088FF` light / `#0091FF` dark** — neither of Apple's values, and it *does* adapt. So the window contains two blues, they disagree, and only the non-accent one shifts.
>
> ## Message boxes — severity is carried by hue alone
>
> All three icons are the **same solid right-pointing triangle**, differing only in colour. On macOS that shape is a *disclosure triangle* — "Autosave is on" with a blue right-triangle reads as a collapsed section, not an info message. Info/warning/error should be three distinct SF Symbols (`info.circle`, `exclamationmark.triangle.fill`, `xmark.octagon.fill`); identical geometry in three hues means the severity vanishes for anyone colour-blind, and vanishes in a greyscale screenshot.
>
> The same failure repeats in the notifications: green bar vs red bar, otherwise identical.
>
> Also, each card is **58px tall for one line of text** — roughly 21px padding above and below. They read as list rows, not banners.
>
> ## Notifications aren't controls
>
> Each is an **8px coloured bar and a text run — no container, no fill, no border, no icon, no title.** That's a CSS blockquote rule, not a macOS notification (rounded rect, heavy radius, app icon, title + body, material background). And the 8px rule is a heavy stroke for a hairline accent.
>
> ## Checkbox and radio
>
> - **Neither has a label.** An unlabelled checkbox is not a control — there's nothing to click but a 16px box, when the label is normally part of the hit target.
> - **A single radio button.** Radios only exist in groups; one alone is meaningless.
> - **The row is inset 4px from everything else** — checkbox left edge at x=24, while buttons, badges, field, cards and notification bars all start at x=20.
>
> ## Layout
>
> - **Four different trailing edges: buttons end at 449, cards at 440, field at 279, notification text near 133** — in a 640px window. Nothing shares a right edge, and there's a ~190px dead column down the right side.
> - **The text field (27px) is taller than the buttons above it (24px).** In AppKit a regular-size text field and push button are the same height; that 3px is the kind of thing that reads as "not native" before you can say why.
> - **Stroke weights disagree:** card borders are 2px, the field border 1px. macOS control borders are hairlines.
> - **Border hues disagree in dark:** cards `#474747` (neutral), field `#2C3338` (blue-tinted).
> - The search field **has no magnifying glass and no label**, despite the placeholder saying "Search notes."
> - The badge row ends with **a bare checkmark and a filled circle-check, side by side, unlabelled** — two indicators doing the same job with no stated difference.
>
> The single most damaging item is the badge contrast; the most revealing is that light mode's borders sit at 1.03–1.04:1 while dark mode's are at 3.3:1 — the light palette was filled in by hand without ever being checked against the background it lands on.

## What was fixed here

**The alert's and the tooltip's hairline was drawn twice as wide and
half as strong as it should be.** The reviewer read it as "card borders
are 2px, the field border 1px" and as `#F9F9F9` on white. Both were
true and both were one defect: the hairline was a `clip.Stroke` centred
on the box's own edge, so half its coverage fell outside the box and
what landed was two pixel rows at half strength instead of one row at
full. It is now drawn the way `components/input` draws a field's edge —
the box filled in the separator, the inset box filled on top — and
lands on one row. Measured before and after, on a white page: two rows
of `#f9f9f9`, now one row of `#f3f3f3`. Both alerts' and the tooltip's
goldens regenerated for it.

## What the reviewer found that this task did not cause

**Alpha composites in linear light here and in sRGB on the platform,
and this is the largest finding in the review.** The reviewer's "body
text is `#6C6C6C` in light" is exact, and it is not the recorded
misread — it is its inverse, as the reviewer says. `labelColor` is
black at 0.85 coverage; Gio converts to premultiplied linear RGBA
before rasterising, so 0.85 black over white lands on `#6c6c6c`.
macOS does not do that. In `reference/macos/save-dialog-light.png` the
"Cancel" button's label over the measured `#ececec` fill reads
`#242424`, and `controlTextColor` blended in **sRGB** predicts
`#232323` while the linear blend predicts `#636363`. The dark capture
settles it on every channel: the same label over `#333a3f` reads
`#e0e1e2`, the sRGB blend predicts `#e0`, `#e1`, `#e2` exactly, and the
linear blend predicts `#eeeeee` — which is what this library paints.

So every alpha-carrying name in the platform set — `Label`,
`SecondaryLabel`, `ControlText`, `DisabledControlText`, `Separator`,
`PlaceholderText`, both overlays, the focus ring — lands lighter in the
light appearance and darker in the dark one than the platform draws it,
and the light appearance is where it is disfiguring: primary text at
`#6c6c6c` where macOS puts `#242424`. `theme/color.Over` models Gio's
linear blend correctly and the library's own gates therefore agree with
themselves; what they do not agree with is the platform. The reviewer's
"disabled text 1.31:1", "placeholder 1.86:1", "`#6C6C6C` is the only
text colour in the light window" and "no labelColor/secondaryLabelColor
hierarchy" are all the same finding seen from four sides. **This needs
an owner ruling** — pre-composite the platform's alpha colours in sRGB
before handing them to Gio, or accept Gio's blend — and it is a phase
decision, not a CE2.2 one.

**The badge's white on the system colours is the ruled mapping.** The
contrast table is correct arithmetic. It is also what the platform
draws its count badge as, and Phase CE's ruling is to conform to the
platform and supersede the published guidance where the two differ.
Recorded for the owner rather than changed.

**Two blues, and only one adapts — both are measured.**
`controlAccentColor` reported `#007aff` in both appearances when the
catalogue was read off AppKit on 2026-09-10; `systemBlue` reported
`#0088ff` and `#0091ff`. The reviewer's Apple values are the published
ones, and measured beats published here, but a set in which the accent
alone does not shift is worth a second reading of AppKit.

**Cancel and Disabled sharing a fill is CE2.1's ruled answer**: the
platform draws a disabled default action as an ordinary disabled
button, so a fill falls back and the foreground becomes
`disabledControlTextColor`. The light-appearance illegibility of that
title is the compositing finding again.

**The field being 3 px taller than the button is CE1.6's measured
ruling**, off the same capture: the platform's regular push button is
24 px and its text field 27. The reviewer's belief that AppKit makes
them equal is the published guidance. Brief the next reviewer on it.

**The ghost button reading as static text** is a real question about
CE2.1's mapping — a borderless AppKit button used as a link is tinted —
and is left for the owner.

**The alert's chevron** is a pre-existing shape, not a colour, and the
per-status glyph set has always been owed. The reviewer's point that
severity now rides on hue alone is sharper than it was, because the
tinted box is gone: the mark is the only coloured thing left.

**A toast has no boundary in the light appearance.** True, and
structural: `WindowBackground`, `ControlBackground` and
`SidebarMaterial` are all `#ffffff` on macOS 26, so the only thing that
separates a floating surface from the pane under it is its shadow — and
the shadow belongs to the placement, `patterns/notifications`. That
makes `FloatingShadow` load-bearing for CE2.3 and CE2.4 rather than
decorative.

## What the reviewer saw that the harness caused, not the components

The checkbox and radio carrying no label, the radio standing alone, the
field having no magnifying glass, Save sitting left of Cancel, the four
different trailing edges and the dead column, the 4 px inset on the
checkbox row, and the bare check standing beside the disc check: all of
these are the throwaway composition's doing. It set specimens down to
be looked at, not a dialog. They are not findings against the
components and are recorded here only so the next reader does not
re-file them.
