---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — Themer, read cold

Two whole-window renders — the theme picker in both appearances, drawn
offscreen at 1040×960, the size its window opens at, with a colour judged, the
syntax bases and code faces on offer and the preview panel open — handed with
three macOS captures (`system-settings-grouped-box-{light,dark}.png`,
`save-dialog-light.png`) to an agent that had seen neither the packet nor the
plan, with no checklist and one question: put beside these macOS windows, what
would a developer who uses macOS every day say this app gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured; the light chrome is very nearly the content's
white by measurement, told apart by a seam; alpha names composite in encoded
sRGB; every value was measured off a macOS capture; the typeface is
deliberately not the system's and the accent does not change between
appearances.

## The reviewer's reply, verbatim

> I read all five images and measured pixel values rather than trusting impressions. Worst first.
>
> ## What a daily macOS user would flag
>
> **1. The big sections are drawn as outlines on white; macOS fills them instead.**
> The "Code" box (x 223–1020, y 317–617) and the "Preview" box (x 20–1020, y 655–940) have an interior of `#ffffff` — identical to the window — and are defined only by a 2px stroke of `#f3f3f3`. In dark: interior `#1e1e1e` = window, stroke `#2b2b2b`. macOS grouped boxes carry no stroke at all: in the System Settings reference the column goes straight from window `#ffffff` to box fill `#f7f7f7` (dark: `#232a2e` → `#2a3034`). So the themer's two largest containers are invisible at a glance and the light frame reads as one flat web page. Worse, the app *already has the right recipe*: the "Code face" and "Syntax base" panels are `#f7f7f7` fills. One window, two contradictory box treatments.
>
> **2. Every unselected item in the two lists is painted grey, so enabled options look disabled.**
> "borland", "bw", "colorful", "emacs", "friendly" (x 40–200, y 460–610) bottom out at `#7c7c7c`–`#84...` on `#f7f7f7` — about 3.9:1. Regular-weight primary text elsewhere in the same frame (the "#007AFF" label at y 91) reaches `#494949`, and macOS `labelColor` on that panel is 14.5:1. Same in the mock window: "Library"/"Shared", "Another row"/"One more". In the System Settings sidebar, "Wi‑Fi", "Bluetooth", "Network" are full-strength black — only *disabled* rows go grey. A Mac user reads this list as "one item available, the rest greyed out."
>
> **3. The appearance control's selected segment is filled accent blue.**
> Top right, x 932–1005. Track `#ececec`, selected half `#0064e1` with a white sun glyph; dark mirrors it with `#0059d1`. No AppKit segmented control fills the selection with accent. macOS raises the selected segment as a white capsule (light) / lighter grey (dark) with the glyph in label colour — see the Auto/Light/Dark and Clear/Tinted segments in the reference, where selection is a bordered raised tile, not a colour fill. As drawn it reads as a two-position switch, not a picker.
>
> **4. The theme colour is a 192×106 blue card with white text inside it.**
> x 19–211, y 177–283: an outer `#0064e1` slab, an inset white-stroked rect of `#007aff`, and "#007AFF · macOS" set in white *inside* the swatch. macOS shows accent colour as a row of ~22px circular wells (System Settings → Appearance → Colour) or an `NSColorWell` bezel, and never puts a caption inside the colour. And the entire band to its right — x 210 to 1020, 105px tall — is empty white. macOS group rows span the full content width with the control trailing-aligned.
>
> **5. Text truncates while large areas sit empty.**
> In the preview table, "UnemphasizedSelectedContent…" and "UnemphasizedSelectedTextBac…" ellipsize at x≈690, while the table has roughly 175px of dead space from x 825 to 1000 with nothing in it. `NSTableView` columns divide the available width; truncating with a third of the table blank is the first thing a Mac user spots. Same fault at "Where the platform uses its accent, the t…" (x 152–380, y 737), truncated on one line with the whole box below it free — macOS wraps help text, it doesn't clip it.
>
> **6. The primary action sits top-right and is set bold.**
> "Keep this theme" (x 864–1020, y 90–113) is bold white on `#007aff`. The macOS reference default button "Save" is **regular** weight, and it lives bottom-right of the panel with Cancel to its left. The themer's own mock reproduces the correct footer placement — then sets "Done" bold too. Relatedly, the drop well and the "#007AFF" readout sit *above* the "Theme colour" heading that names them, so the top band is an orphan row; macOS puts the heading above its group.
>
> **7. Scrollbars are permanently visible, mis-toned, and one runs over a pinned header.**
> Syntax-list thumb at x 193–199, `#6a6a6a` on `#f7f7f7` — macOS's overlay scroller composites to roughly `#a8a8a8`–`#c0c0c0` there, so this is about twice as dark; it also floats ~10px in from the panel's right edge (x 209) instead of hugging it. The preview thumb (x 1000–1005, y 666–718) is `#9c9c9c` in dark, where macOS's light-on-dark thumb lands near `#6d6d6d` — far too bright — and it starts at y 666, overlapping the "The colour set previewed" banner that spans y≈655–705. macOS scrollers sit inside the scrolled area, below a pinned header.
>
> **8. The selected list row carries a white bar on its left edge, and the window uses two selection shapes.**
> The blue pill behind "catppuccin-latte" / "catppuccin-mocha" and "Roboto Mono" has a white vertical marker notched into its leading edge — a VS Code / Material idiom with no AppKit equivalent; macOS selection is a plain fill. The pill is also a full capsule, where the System Settings sidebar selection ("Appearance") is a ~8px rounded rect. Meanwhile "The selected row" in the mock (x 152–380, y 793–813) is a square-cornered full-bleed bar. Three lists, three shapes.
>
> **9. Capitalisation and voice are not the platform's.**
> "the macOS accent colour, and it follows it", "the colour the platform is set to. Drop a picture for more.", "every name the platform answers for · in the order the set carries them", "36 light bases", "Click one to apply." Lowercase sentence fragments, a mid-string `·`, and an instruction ("Click one to apply") macOS would never print. Apple uses title-style capitalisation for headings and buttons and sentence-style — starting with a capital — for help text. Also, right-aligning an explanatory sentence opposite a section heading ("Theme colour" at x 20 vs the caption ending at x 1019) is a web pattern; macOS puts help text under the group, left-aligned.
>
> **10. The drop target reads as a disabled button.**
> x 19–131, y 72–132: a flat `#f7f7f7` rounded rect, no bezel, no dashed edge, no icon, with 11px grey "Drop an image" centred. It is the same fill as the list panels next to it. macOS drop destinations are either a bezeled image well or a dashed rounded outline that appears on drag, with a symbol.
>
> **11. The search field has no magnifier.**
> x 149–381, y 753–785. The focus halo is actually well matched (peak `#80b3fa` against the reference field's `#83b0f2`, both ~4px), but it's a 6px-radius rectangle with a bare "Search" placeholder. Every macOS search field — including the one in the reference sidebar — is a capsule with a leading magnifying-glass glyph.
>
> **12. Dark mode mixes neutral and blue-tinted greys.**
> Window `#1e1e1e`, code-box stroke `#2b2b2b`, mock sidebar `#1c1c1c` are neutral; but the list panels, the drop well and the Cancel button are `#2a3034` and `#333a3f` — about 19% saturation at hue 204°. Those are exactly the values in the dark System Settings reference, which was captured with "Tint window background with wallpaper colour" switched **on** (visible in that same screenshot). Untinted macOS dark greys are neutral (`#1e1e1e` / `#2c2c2e` / `#3a3a3c`). The light palette is perfectly neutral, so light and dark disagree about whether grey is grey.
>
> **13. The table header isn't a header.**
> "Platform name | Value" (y 726) is grey text over the plain content fill with a hairline that stops dead at x 824, mid-window. `NSTableView` headers are a full-width band with a bottom hairline running edge to edge and dividers between columns.
>
> **14. The mock window's title band cuts across the top of its sidebar.**
> The "Sample" band spans x 33–392 full width at y 663–692, with the "Library/Recents/Shared" sidebar starting beneath it. macOS full-height sidebars run to the top of the window, with the toolbar sitting transparently over them.
>
> ## What it gets right
>
> The measured chrome is genuinely accurate where it's used: panels `#f7f7f7` on `#ffffff` content, sidebar `#f7f7f7` light and `#1c1c1c` darker-than-content in dark — both match the platform's direction. The Cancel button is `#ececec`, pixel-identical to the reference push button, at a correct ~25px height, and the Cancel-then-default order and bottom-right footer placement in the mock are right. Selection blue is the real `selectedContentBackgroundColor` `#0064e1`, the accent `#007aff` is correct and correctly held constant across appearances. The focus ring is close to exact. Grouped-box corner radius (~11px) matches macOS's ~12px. Dark secondary text sits at 5.1:1, comfortably legible. The problems above are almost all in shape, weight, and where things are put — the colour work underneath is sound.

## Disposition

**Fixed here.** Nothing. Every finding is shape, placement, copy or a
measurement the reference does not hold; none is a platform name this task can
swap.

**Already pooled.**

- 7, the permanently visible scrollers and the thumb's value: items 342 and
  368.
- 11, the search field without a magnifier: item 408.

**New for pooling.**

- 1, one window with two box treatments: the Code and Preview boxes are groups
  — a hairline and no fill of their own — while the Code face and Syntax base
  panels are cards. Both are what the Language says each is, and the reviewer
  still read the window as "one flat web page". Whether a section that large
  should be a group at all is the question.
- 2, unselected rows in the two lists at the platform's secondary label, which
  the reviewer read as "one item available, the rest greyed out."
- 3, the appearance control's selected segment filled with the selection
  colour: "No AppKit segmented control fills the selection with accent."
- 4, the theme colour drawn as a 192×106 card with its caption inside the
  swatch, and 810 px of empty row beside it.
- 5, names ellipsizing in the preview table while a third of the table is
  empty, and a help line clipped on one line.
- 6, the keep action top-trailing and set bold: "macOS control labels are the
  regular system weight."
- 8, the selected row's white leading marker, and three list selections in one
  window drawn three ways.
- 9, the window's copy: lowercase fragments, a mid-string `·`, an instruction
  the platform would not print, and help text right-aligned opposite its
  heading.
- 10, the drop target reading as a disabled button.
- 13, the preview table's header not being a header: grey text with a hairline
  that stops mid-window.
- 14, the mock window's title band cutting across the top of its own rail.

**Recorded misreads.**

- 12, "dark mode mixes neutral and blue-tinted greys", is the real finding
  under a wrong cause: the reviewer blames the reference capture's wallpaper
  tinting, but the tint is in *our* token. `CardFill` and `PushButtonFill`
  were measured off System Settings and the save dialog, both captured with
  wallpaper tinting on, so they carry a blue cast the untinted window
  background (`#1e1e1e`) does not. Recorded here as a cross-app item and
  reported to the owner; the same reading came back from marketing, sk150 and
  iconbrowser.
- 3's and 8's "accent" is `selectedContentBackgroundColor`, not
  `controlAccentColor`; the shape complaint stands, the colour naming does
  not.
