---
date: 2026-09-11
task: CE2.3
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE2.3 fresh-eyes review — the converted patterns

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who ships macOS
applications complain about? It was handed fourteen regenerated goldens —
the three-column and sidebar-header-main shells in both appearances, the
modal in both, the light table, the pricing row in both, the sidebar in
both, the light tab strip, the light toast column and the light accordion —
and told only that the garish solid blocks in some of them are test
fixtures standing in for caller content, and that a cropped component render
is not a window so a missing title bar is not a defect. It was also told
the one recorded misread this plan keeps repeating: dark text reads grey at
1x, so judge legibility generously on small captures.

Everything numeric below is the reviewer's own pixel sampling.

## What it found, verbatim

1. **`shell/light-three-column.png` and `shell/light-sidebar-header-main.png`
   — the sidebar doesn't exist visually.** The sidebar column is pure
   `#FFFFFF`, the content area is pure `#FFFFFF`, and there is no divider: I
   sampled the full boundary band (x=180–191, y=120) and every pixel is
   `(255,255,255)`. No sidebar material, no tint, no hairline. The dark
   captures show the split clearly (`#232A2E` vs. content), so light mode is
   the broken half. On a real Mac the sidebar is always distinguishable, and
   a three-column shell with no seams reads as one blank page with floating
   text.

2. **`sidebar/dark-expanded-active-second.png` — the selection is a
   full-bleed hard rectangle.** Solid `#0059D1` from x=0 to x=191 (the entire
   capture width), y=44–61, square corners, no inset. macOS sidebar selection
   is an inset rounded rect (~8px side margins, ~6px radius) in the accent
   colour. This reads as a web list or a Windows tree view. The row's leading
   icon also stays its normal blue inside the selection, so it nearly
   disappears against the fill.

3. **`sidebar/light-expanded.png` and both shell captures — the
   header/toggle icon is unplaced.** The sidebar-toggle glyph sits at x≈92
   while every row below starts at x≈16. It's neither left-aligned with the
   content nor at a plausible toolbar position — it looks like it landed
   wherever the layout dropped it.

4. **`pricing/*-three-tier-recommended.png` (both) — zero corner radius on
   cards and buttons.** I checked the card corner at (20,20): the border
   turns 90° with no antialiased arc. Same for the "Choose" buttons —
   `#007AFF` (correct accent blue) in a perfectly square rectangle, full card
   width. macOS pushbuttons are rounded ~6px and are not full-bleed slabs;
   cards are rounded ~10px.

5. **`pricing/*` — the "Popular" badge is close to illegible and looks
   inverted in dark.** Light: white text on `#8E8E93` ≈ 3.3:1. Dark: white
   text on `#98989D` ≈ 3.0:1, at roughly 9px. Both are below the 4.5:1 you'd
   want for text that small. In dark mode it's also a *light grey* chip on a
   dark card — brighter than everything around it, which reads as a disabled
   placeholder rather than a "recommended" accent.

6. **`modal/light-open.png` and `modal/dark-open.png` — the dialog has
   essentially no elevation.** Light: the scrim is `217,217,217` and only
   drops to `212` at the panel edge — a 2% darkening, which is not a shadow.
   Dark: no shadow at all (scrim `16,16,16`, edge `15,15,15`), no border, and
   the panel is `#1E1E1E` on a `#101010` scrim — 14 levels of separation for
   a modal. The corner radius is ~4px; macOS alerts and sheets are ~10–12px.
   A modal that doesn't visibly float is the first thing anyone will file.

7. **`modal/*` — the close affordance is a bare glyph.** A thin stroked ✕ in
   the top-right with no button background, no hit area, no chrome. macOS
   dialogs dismiss via titled buttons (or a sheet's own controls); a naked
   web-style ✕ in the corner is the giveaway that this isn't a native dialog.

8. **Dark palette is two different grey families.** Chrome surfaces are
   teal-tinted — shell/sidebar `#232A2E`, recommended card `#2A3034`
   (blue-green cast) — while page and modal surfaces are neutral — pricing
   page `#1E1E1E`, modal `#1E1E1E`. Put a modal over the shell and the cast
   mismatch is visible. macOS dark greys are one consistent family.

9. **`table/light-comfortable.png` — the header isn't a header.** White fill,
   same text size/weight/colour as the body rows, no column divider lines,
   only a single hairline underneath (y=19). macOS table headers have a
   distinct fill, secondary-label header text, and vertical separators you
   can drag. The sort triangle also floats at x≈62 — far from its "ID" label
   (which ends at x≈23) and visually closer to "Name" at x≈93, so it reads as
   marking the wrong column. No row-selection state appears anywhere in the
   capture.

10. **`notifications/light-three-stacked.png` — the cards are invisible.**
    White cards on a white background with a shadow that is ~4–8 levels at
    its darkest (`#FBFBFB`→`#F7F7F7`), square corners, no border. The
    coloured left bar is the only thing defining the card. There's also no
    icon, no dismiss button, and no timestamp — a native
    notification/banner has at least a close affordance.

11. **`tabs/light-three-tabs-first-selected.png` — the selected underline
    floats.** There's an underline under "Preview" only, with no baseline
    rule running across the whole strip and no separator between the tab bar
    and the content below, so the marker has nothing to sit on. (Separately:
    underlined text tabs are a web/Material idiom; macOS would use a
    segmented control. Fine if deliberate, but it will get mentioned.)

12. **`accordion/light-three-sections-first-open.png` — old-style triangles,
    and the labels jitter.** Solid filled ▶/▼ triangles; macOS has used
    chevrons since Big Sur. Worse, the glyph widths differ between states:
    the open row's triangle spans x=13–18 with its label at x=33, the
    collapsed rows' triangles span x=11–16 with labels at x=36. So the header
    text shifts ~3px sideways every time you expand or collapse a section.

Things that are right, briefly: text is legible everywhere (I checked at
pixel level, not by eye), the accent blue is exactly `#007AFF`, the table's
zebra striping and the toolbar hairline in the shell captures are correct,
and dark-mode sidebar/content contrast is well judged.

## What was done about it

**Fixed in the task (1).** The reviewer's first finding is a Language
violation and not a taste: the Chrome entry says a light chrome region is
told from the content by a seam alone, and on macOS 26 the chrome material
is the content's white exactly, so a light shell without that seam is one
blank page. The navbar now draws the hairline along its own foot, the
sidebar down its own trailing edge — once, by the region above or leading,
as the Seam entry says — and `shell`'s three-column frame draws the status
strip's top, the content above it being the caller's. Verified in the
regenerated goldens: `#e5e5e5` at the boundary, which is `separatorColor`
over white within one 255th.

**False positives, recorded so they are not rediscovered.**

- **4, and the square corners in 10:** the goldens pass a deliberately sharp
  radius so a stored image is deterministic across GPUs. Corner radius is a
  test fixture in these captures, not the pattern's answer.
- **9, the sort triangle:** it is right-aligned inside its own column, which
  is where Finder puts it — in `finder-window-light.png` the "Name" header's
  chevron sits at x≈577 with the label at x≈368, the column running
  340–590. The reviewer read it against the neighbouring label rather than
  against the column.
- **9, the header text:** AppKit's `headerTextColor` is `#000000` at 0.85
  light and plain white dark — the same value `labelColor` reports. A
  secondary-strength header is not what this platform answers with, however
  familiar it looks.
- **11, the baseline rule:** the strip's foot seam is drawn; it reads
  `#e5e5e5` at y=23 across the full width. This is the recorded misread of
  the class the packet warns about — `separatorColor` over white is a very
  quiet line at 1x, which is the platform's own answer.
- **12, the label jitter:** the label's x offset is the chevron column's
  fixed width in every state. The three sections carry different titles, so
  the reviewer measured the first ink column of three different words.
- **8, the two grey families:** this is the platform's own answer as
  measured. The desktop the reference was captured on has "Tint window
  background with wallpaper colour" switched on, which is what carries the
  chrome material and the grouped box off neutral grey while
  `windowBackgroundColor` stays `#1e1e1e`. ADR-019 records the dependency.
  It is nonetheless worth the owner's attention: the recorded set bakes in
  one desktop's tint, and a machine with the setting off reads its chrome
  nearer neutral.

**Recorded, not fixed — out of a colour pass's scope.**

- **2, the sidebar selection's shape.** macOS insets and rounds it; ours is
  full-bleed and square. The colour is right and the geometry is not, and
  the inset and radius are not in the reference yet. `finder-window-light.png`
  holds a selected sidebar row to measure them from.
- **3, the collapse glyph's placement.** It is centred in the whole rail
  rather than aligned with the rows' icon column.
- **5, the Popular badge.** `badge.Neutral` is `systemGray` under white,
  which is CE2.2's ruled mapping; in the dark scheme it is lighter than
  everything around it. A question for the owner, not for this task.
- **6 and 10, the shadow.** This is the phase's known seam and the most
  consequential thing on the list. The shadow's COLOUR is the platform's
  measured black at 0.075, passed through `effects/depth` as the fraction of
  a Material key shadow that API still takes. Its REACH is still depth's
  6 dp for the floating level, where the reference measures the platform's
  at 24 px falling from 0.075 at the edge to nothing. A 6 dp spread of a
  7.5% black is what makes a white toast on a white page and a dark sheet on
  a dark scrim read flat. CE2.4 moves `effects` to the platform set and is
  where the ramp lands.
- **7, the modal's close ✕**, and **11's** "macOS would use a segmented
  control", and **12's** filled triangles: three structure questions the
  Language has already settled or has not yet taken up. None is a colour.
- **9, vertical column separators in the table.** `gridColor` exists for
  them and the table draws only horizontal lines. A small, real addition,
  and structure rather than colour.
