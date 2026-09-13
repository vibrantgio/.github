---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — the icon browser, read cold

Three whole-window renders — the icon grid in both appearances and the light
one with a query applied, drawn offscreen at 1000×700, the size the window
opens at — handed with three macOS captures
(`finder-window-untinted-{light,dark}.png`, `mail-window-light.png`) to an
agent that had seen neither the packet nor the plan, with no checklist and one
question: put beside these macOS windows, what would a developer who uses
macOS every day say this app gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured; the light chrome is very nearly the content's
white by measurement, told apart by a seam; alpha names composite in encoded
sRGB; every value was measured off a macOS capture; the typeface is
deliberately not the system's and the accent does not change between
appearances.

## The reviewer's reply, verbatim

> I read all six images and measured pixel values rather than trusting impressions.
>
> ## What a macOS developer would call wrong — worst first
>
> **1. The search field shows its placeholder while the results are filtered.** `iconbrowser-light-filtered.png` is filtered to "history" (2 icons, and the marks row reduced to history-back/history-forward), yet the field still reads "Search icons…" in placeholder grey. I diffed the two light frames: the field region (rows 40–76) is **pixel-identical** — `ImageChops` bbox `None`. Nothing was typed into it as far as the render is concerned. On macOS the query appears in the field in the primary label colour the instant you type, and a trailing ⊗ clear button appears. Here you cannot tell what is being searched or how to get back to the full list. (If the harness filtered programmatically without typing, this is instrumentation — but as presented it is the first thing a Mac user would report.)
>
> **2. There is no toolbar.** The top 44 rows contain **zero non-background pixels** in both appearances — I checked all 44,000. Then a search row floats at y 44–71 with nothing under it: no hairline, no material change. Finder puts title, back/forward, view switcher, share, tags and search into one 52px toolbar band with a separator, and content scrolls under it. This app reserves a 44px dead band for a title bar it never draws, then spends a *second* band on search, and the grid scrolls up to it with no boundary at all.
>
> **3. The search field is not drawn as a control.** Fill `#ffffff`, sitting on a `#ffffff` page, demarcated only by a 1px `#f3f3f3` border — **1.11:1**, below even macOS's own `separatorColor` (1.24:1) and far below Finder's affordance. Finder's field is a 210×36 well *filled* `#f7f7f7` with no border at all: the fill is the control. And there's no leading magnifier and no clear button — in an app that renders its own `search` mark at three sizes, one row above, and doesn't use it in its own search field.
>
> **4. It's a full-bleed search bar.** x 12→988, 976px wide. macOS has no such thing: Finder's field is a fixed ~200pt control pinned to the toolbar's trailing edge, Mail's is a magnifier button that expands. A window-width search bar is an iOS/Android/web pattern and is the single loudest non-native signal in the frame.
>
> **5. All 961 icons are painted the accent colour** (`#007AFF`, measured). macOS renders content glyphs in `labelColor` — black in light, white in dark — and reserves the accent for selection, focus and active controls. The accent is also a System Settings preference the user owns; flooding a content grid with it means the window repaints wholesale when someone picks Graphite. Font Book and SF Symbols both render their grids monochrome and use the accent only on the selected cell.
>
> **6. No sidebar, no grouping affordance.** Both reference windows have a source list. 961 items scroll flat under two headings, with names that are obviously categorised (`Action*`, …) and no way to jump to a category.
>
> **7. The grid doesn't align with its own chrome and is enormously sparse.** Cells measure 160×84 for a 24px glyph — 85% empty. The first glyph starts at x=72 while its own section heading starts at x=12. Right margin is 29px against a 12px left margin, so the grid's right edge misses the heading's and the search field's shared 985–988 edge by ~17px. macOS holds one content inset across chrome and content.
>
> **8. Labels aren't truncated.** Widest observed, `ActionAccountBalanceWallet`, runs 153px inside a 160px cell; the tightest neighbour gap in the frame is **18px** (row 5: AssignmentReturn / Returned / TurnedIn). Longer names in the set will collide. Finder truncates in the middle with an ellipsis and wraps to two lines.
>
> **9. Developer prose in the chrome — and in the wrong units.** "one mark at 16, 20, 24 dp; disclosure also turned, for an open row" is right-aligned inside the section header. `dp` is an Android unit; macOS is points. That one word is the tell. macOS puts this kind of note in a tooltip or an inspector, never as a sentence trailing a heading.
>
> **10. Type is a size too large.** Search placeholder cap height 11px (≈16px font) against Finder's 9px (13pt system). Section headings cap 10px in near-black, against Finder's group headers ("Favourites") at 8px in secondary grey. The headings read as web `<h3>`s, not macOS group labels.
>
> **11. The dark field stroke is blue-tinted.** `#2C3338` (B−R = 12) where every other neutral in the app is exactly neutral. macOS's dark separator is `#ffffff` at ~10% — neutral grey. The light counterpart (`#f3f3f3`) *is* neutral, so the pair is inconsistent with itself.
>
> **12. No rule between the two sections.** macOS separates grouped scroll content with a hairline or a distinct grouped background.
>
> ## What it gets right
>
> The colour work is genuinely accurate — these aren't approximations, they land on the macOS values to the unit. Light primary `#272727` is black@85% over white; secondary `#808080` is black@50%. Dark primary `#DDDDDD` is white@85% over `#1E1E1E`; secondary `#9A9A9A` is white@55% — both exact. The dark background `#1E1E1E` matches Finder's dark window chrome exactly (measured 30,30,30 in both). Accent is the real `#007AFF`. The placeholder is correctly secondary, not primary. Chrome alignment is disciplined: search field and both headings share a 12px left inset and a 985–988 right edge, and the trailing counts right-align to it. Grid pitch is dead consistent (160 × 84, ±2px), glyph rendering is clean at 24dp with no stray colour anywhere in either appearance, and the light/dark pair is a true pair — same geometry, same layout, only the palette swaps.

## Disposition

**Fixed here.** Nothing. Every finding is shape, placement or copy.

**Already pooled.**

- 3, the field demarcated by an edge that measures 1.11:1: item 404.
- 3's and 4's search field without a magnifier or a clear mark, and its shape:
  item 408.

**New for pooling.**

- 2, the window reserving a 44 px band for a title bar it never draws, then
  spending a second band on search, with no hairline or material between
  either and the grid.
- 4, the search bar running the window's whole width: "A window-width search
  bar is an iOS/Android/web pattern and is the single loudest non-native
  signal in the frame."
- 5, all 961 icons painted the accent: "macOS renders content glyphs in
  `labelColor` … and reserves the accent for selection, focus and active
  controls", and the accent is a setting the user owns.
- 6, no sidebar and no way to jump to a category in 961 flat items.
- 7, cells 85% empty, and the grid's insets disagreeing with the chrome's:
  "macOS holds one content inset across chrome and content."
- 8, labels not truncated, with an 18 px gap between the tightest pair.
- 9, developer prose in the section heading, and `dp` in shipped text: "`dp`
  is an Android unit; macOS is points. That one word is the tell."
- 10, the type a size larger than the platform's throughout.
- 12, no rule between the two sections.

**Recorded misreads.**

- 1 is the instrument. The filtered frame is rendered from a model whose query
  is set directly; nothing was typed, so the field draws its placeholder. The
  reviewer named this possibility themselves. Worth carrying into the next
  packet: a window rendered from a model, not driven, shows no typed text and
  no caret.
- 11, the dark field edge being blue-tinted, is the measured `fieldEdge`:
  `#2c3338`, read off the save dialog's unfocused field, where the platform's
  separator over that sheet does not reproduce the pixel. It is recorded as
  the pixel for exactly that reason. The cast does trace back to a capture
  taken with wallpaper tinting on — see the cross-app item in this round's
  themer and marketing reviews.
