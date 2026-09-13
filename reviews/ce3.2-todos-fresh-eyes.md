---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — Todos, read cold

Three whole-window renders — the list in both appearances and the light window
with its add dialog standing, drawn offscreen at 650×600, the size the window
opens at — handed with three macOS captures (`reminders-window.png`,
`mail-window-light.png`, `finder-window-untinted-light.png`) to an agent that
had seen neither the packet nor the plan, with no checklist and one question:
put beside these macOS windows, what would a developer who uses macOS every
day say this app gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured; the light chrome is very nearly the content's
white by measurement, told apart by a seam; alpha names composite in encoded
sRGB; every value was measured off a macOS capture; the typeface is
deliberately not the system's and the accent does not change between
appearances.

## The reviewer's reply, verbatim

> Read all six. Here is what a daily-Mac developer would say, worst first.
>
> ## 1. The floating blue "+" circle, bottom-right corner
> A 40×40 flat #007aff disc hovering over empty content at (594–633, 544–583). No macOS application has ever had one. On this platform "new item" lives in the **window toolbar** — Reminders puts `+` top-right beside the search field, Mail puts the compose button in its toolbar cluster — and a to-do list additionally offers an **inline new row**: click the empty space under the last item (or ⌘N) and a fresh editable row appears in place. The FAB is the single loudest "this was designed for Android" signal in the frame, and it isn't even a convincing FAB: it has no shadow at all, white runs right up against the circle edge at y=543.
>
> ## 2. The add sheet dims the window and floats a card
> Measured: the whole window is covered with 20% black (white 255 → 204), and a card sits at x=12–637, y=200–399 with a ~5px corner radius. Three things macOS does differently:
> - **A sheet never dims the window behind it.** The content stays at full brightness; only the window's controls go inert.
> - **A sheet is attached to the top edge**, sliding out from under the title bar, with its *top corners square and flush* and only the bottom corners rounded (~10–12px, not 5).
> - **A sheet is narrower than its window.** This card is 626px of a 650px window — 96% — leaving a 12px sliver of scrim down each side that reads as a layout bug rather than a design.
>
> The FAB, incidentally, stays visible under the scrim at 80% (measured #0062cc), so the modal is presented over an affordance that shouldn't exist.
>
> ## 3. Unchecked checkboxes are invisible
> Rows 2–4, x=28–43. The border is 2px of **#f3f3f3 on #ffffff — 1.13:1 contrast**. Dark is no better: **#2c3338 on #1e1e1e, 1.28:1**. At 1x, three of the four rows look like they simply have no control. A macOS checkbox in its off state is a white rounded rect with a ~1px border near #b8b8b8 (≈2.5:1) plus a faint inner shadow, and in dark mode it's a *filled* control at about #48484a — visible either way. This is not the "dark text reads grey at 1x" trap; these are measured numbers on both appearances.
>
> ## 4. The checkbox is a hard square
> The blue checked box spans exactly x=28–43 on every row from y=68 to y=83 — zero corner rounding, 16×16, 2px stroke. The macOS checkbox is ~14×14 with a ~3.5px corner radius and a 1px stroke. A sharp square is instantly foreign; it reads like an HTML `input[type=checkbox]` with a custom border.
>
> ## 5. A permanent blue ✕ on every row
> Trailing edge, x=594–617, 24×24, #007aff on all four rows. Two separate errors:
> - **macOS does not park a destructive control on every row.** Deletion is the Delete key on the selection, a right-click → Delete, or a control revealed on hover. A visible delete button on each of four rows makes the list look like four close boxes.
> - **If it existed, it would not be accent blue.** Accent blue means "default, safe, the thing you probably want." Destructive is systemRed. A blue ✕ is a category error.
>
> And it's 24×24 against the 16×16 checkbox — the destructive secondary action is drawn *larger and with more colour* than the row's primary control. The emphasis is exactly inverted.
>
> ## 6. No row structure whatsoever
> I scanned every scanline: between rows there is not one non-white pixel across the full width. For comparison, in the references Mail draws a 1px **#e6e6e6** separator between messages, and Finder alternates **#ffffff / #f4f5f5** bands every 20px. With neither, the list is four sentences floating in a white field, and there's no surface for a selected-row fill to land on — which is why the window has no visible notion of a current item at all.
>
> ## 7. Rows are nearly twice macOS density
> 64px pitch for a single line of ~15px text. Finder's list rows are 20px; a one-line Reminders row is around 38–40px. The whole list ends at y=280 in a 600px window, so half the frame is void. A Mac user's instinct is that a window this size should be showing three times this much.
>
> ## 8. No toolbar, no title, no sidebar
> The top 55px is undifferentiated white containing nothing. Every reference window has a toolbar band with identity and controls in it: Mail shows "All Sent / 1.918 messages" plus its button clusters, Finder shows "Recents" plus view switcher and search, Reminders shows its list name plus `+` and search. There is no title, no item count, no search field, and no toolbar separator — so there is also nowhere for the `+` to go, which is how the FAB happened. All three references are also **split windows with a source list**; a to-do app with more than one list needs that sidebar, and the seam (#f7f7f7 against #ffffff) is what gives a Mac window its depth.
>
> ## 9. The focused text field has no focus ring
> In the add sheet nothing but that field can take the keyboard, so it is focused — yet there is no ring. macOS draws a 3px accent-tinted ring around the focused field, and it's the main reason Mac sheets are usable without the mouse. The field is also 44px tall and full-bleed across the sheet (touch sizing); the regular-size macOS text field is ~22px with a 1px #c6c6c6 border. This one's border is the same invisible **#f3f3f3** as the checkboxes.
>
> ## 10. Sheet buttons are the wrong material and the wrong size
> Cancel is a flat **#ececec** fill with no border. A macOS bordered button is *white* with a hairline border and a faint shadow — grey flat fill is the iOS/web convention. Both buttons are a fixed 100×26; macOS push buttons hug their label (Cancel ≈ 68px) at ~22px tall.
>
> ## 11. Placeholder text too faint
> "What needs to be done?" measures **#cacaca on white, ~1.6:1**. macOS placeholder text lands around #9a9a9a (~2.8:1). At this value it reads as a disabled field, not an invitation.
>
> ## 12. Dark mode has no layering
> #1e1e1e edge to edge, every pixel. The value itself is right — that's macOS's dark text-background. But with no toolbar material, no sidebar, and no separators, there is nothing above or below it. Compare the dark Reminders reference, where sidebar and content sit at visibly different values; that separation is what makes macOS dark mode readable rather than a flat void.
>
> ---
>
> ## What it gets right
>
> - **The palette is genuinely measured, not guessed.** Primary label is **#272727** light and **#dddddd** dark — those are almost exactly macOS labelColor (#000000d9 on white, #ffffffd9 on #1e1e1e). Secondary/completed text is #808080 / #9a9a9a, both within a hair of secondaryLabelColor, and both comfortably legible (3.9:1 light).
> - **Accent #007aff is exact and used consistently** across the checked box, the default button, and the FAB.
> - **Light and dark are a proper pair, not an inversion.** Each appearance's values were chosen for its own background; the contrast ratios come out symmetric.
> - **The sheet's button order is macOS-correct**: Cancel on the left, the default action rightmost and accent-filled. That's the detail cross-platform apps get backwards most often.
> - **Alignment is clean.** Checkbox at x=28 and text at x=61 on every row, baselines on an exact 64px grid with zero drift.
> - **It doesn't fake window chrome.** No hand-drawn title bar, no invented traffic lights in the app's own layers — it leaves window furniture to the platform, which is the right instinct and makes everything above fixable without unpicking a custom frame.

## Disposition

**Fixed here.** Nothing. Every finding is shape, geometry or a control the
window does not have.

**Already pooled.**

- 3 and 9, the field and checkbox edge measuring 1.13:1 at rest: item 404 —
  and the same review's note that a disabled field reads stronger than an
  enabled one.
- 9's missing focus ring: item 405.

**New for pooling.**

- 1, the floating round add control: "No macOS application has ever had one",
  and on this platform "new item" lives in the toolbar or as an inline new
  row.
- 2, the add dialog: it dims the window, it is 96% of the window's width, and
  its corners are rounded on all four sides. "A sheet never dims the window
  behind it … A sheet is attached to the top edge."
- 4, the checkbox drawn as a hard 16 px square: "The macOS checkbox is ~14×14
  with a ~3.5px corner radius and a 1px stroke."
- 5, a permanent delete mark on every row, in the accent: "macOS does not park
  a destructive control on every row … If it existed, it would not be accent
  blue." And it is drawn larger than the row's own checkbox — "The emphasis is
  exactly inverted."
- 6, no row structure at all: no seam, no alternating fill, and so no surface
  for a selected row to land on.
- 7, a 64 px pitch for one line of text where Finder's list row is 20 and a
  one-line Reminders row is about 40.
- 8, no toolbar, no title, no item count, no search, no rail: "there is also
  nowhere for the `+` to go, which is how the FAB happened."
- 10, the dialog's buttons at a fixed 100×26 where the platform's hug their
  label.

**Recorded misreads.**

- 11, the placeholder at "#cacaca on white, ~1.6:1", is an antialiased pixel.
  Measured across the field, the placeholder's stems are `#808080` — the
  platform's `placeholderTextColor`, black at 127/255, flattened over the
  field's white in encoded sRGB, to the byte. This is the recorded misread the
  packet warns about, in its exact form.
- 12, "dark mode has no layering", is the window being one region: a to-do
  list with no rail and no toolbar has nothing to layer. The value `#1e1e1e`
  the reviewer confirms is right; the finding belongs with 8.
