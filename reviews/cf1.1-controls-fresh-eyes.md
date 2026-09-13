---
date: 2026-09-13
task: CF1.1
phase: CF
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CF1.1 — the controls, read cold

## The reply, verbatim

I read all 28 renders and all 11 reference captures, and sampled pixels with PIL. Here is what I found.

---

## Where the set duplicates itself, or duplicates the platform

**The search field is the text field with a magnifier glyph.** Render text field at rest: 28px tall (y72–99), white fill, 1px `#F3F3F3` hairline, small radius. Render search field at rest: 28px tall (y72–99), white fill, 1px `#F3F3F3` hairline, same radius. Byte-for-byte the same chrome. On the real system they are different-looking controls: the System Settings sidebar search is a **filled capsule**, `#E8E8E8`, 28px tall (y61–88), no stroke, ends fully rounded; the Finder toolbar search is the same filled capsule on `#F7F7F7`. Meanwhile the macOS *text* field (save dialog "Tags:") is 27px, white, 1px `#F3F3F3` — which the render's text field matches exactly. So the render got the text field right and then drew the search field as a copy of it.

**The chip and the tonal button are one appearance at two heights.** Chip unselected fill `#ECECEC`, pressed `#D5D5D5`. Tonal button fill `#ECECEC`, and the button sheet's press state is `#D5D5D5` too. The only difference is 20px vs 24px tall and the radius. Two components, one look.

**Four components share two indistinguishable blues.** Filled button `#007AFF`; pagination current page `#007AFF`; selected chip `#0064E1`; open-menu highlight `#0064E1`. Nothing in the set tells a reader which blue means "this is the action" and which means "this is selected" — and neither value is what macOS paints (below).

**Scrollbar, List, and Scroll area are three sheets showing one 6px thumb.** The List sheet's only pixels beyond text are the same thumb the Scrollbar sheet shows (both `#6D6D6D`, 6px wide, 22px tall). More to the point, the platform already gives this: across all five reference windows — two Finder windows, a save dialog, two System Settings panes, every one of them scrolled — **there is not a single visible scrollbar pixel**. macOS overlay scrollbars are absent at rest. A bar that is always painted is chrome the Mac deliberately doesn't show.

**Pagination duplicates scrolling.** Nothing in any reference capture paginates; Finder shows 40+ rows in one scroll view. And its current-page marker is the filled button again (`#007AFF`, same rounded rect).

**Breadcrumb overlaps Finder's path bar** — same job, "trail back to the root" — but drawn as web links (see below).

**Paragraph is a text view, not a control.** Bold/italic/mono/coloured/resized runs with links is what a Mac app gets from the system text stack; it doesn't belong in a control inventory beside checkbox and picker.

---

## What's missing for an ordinary Mac application

Counting only things I can point at in the reference captures:

- **Switch.** System Settings "Tint window background with wallpaper colour": 37×26px, fill `#1576F2`, knob white. There is no toggle anywhere in the render set — only checkbox and radio. Settings-shaped Mac UI is built out of switches.
- **Segmented control.** Finder's view switcher: a capsule track with a rounded-rect selected segment, four icon segments plus a divider. Absent.
- **Sidebar / source list.** Both Finder and System Settings have one: section headers ("Favourites", "Locations", "Tags"), 16px icons, and a selected row that is a rounded rect **inset** from the sidebar edges — measured in System Settings at 32px tall (y439–470), starting x=18, fill `#1068DE`, radius ~7px. The render set has no sidebar and no list-row selection of any kind.
- **Table with column headers, sort, stripes, and selection.** Finder's file list: 20px row pitch, alternating `#FFFFFF` / `#F4F5F5`, a "Name / Kind / Date Last Opened" header row with a hairline under it and a sort chevron. The render's List has 36px rows (text bands at y64, 100, 136, 172, 208 — a 36px pitch), a uniform `#FFFFFF` background with no stripes (column x=480 is 255,255,255 for all 210 rows sampled), no header, no icons, no selection.
- **Grouped settings box / form row.** System Settings' rounded container with label-left, control-right rows and hairline separators. No container component exists in the set.
- **Toolbar and toolbar buttons.** Finder's share / tag / more-… row, with a real hover state I measured below. The window chrome in the renders is a harness stand-in, so the set genuinely has no toolbar.
- **Sheet / dialog.** The save dialog is a whole pattern — rounded sheet over dimmed content, label-aligned form, Cancel + default-button row. Nothing like it in the set.
- **Badge.** System Settings "Software Update Available ①", `#F22C2F`. No badge render, though the set's own status vocabulary calls for one.
- **Disclosure / outline row**, **progress indicator**, **slider**, **stepper**, **tooltip** — none present. The first two show up in ordinary Mac windows constantly.

---

## What looks wrong for the platform

**1. Hover does nothing.** This is the biggest one and it's exact. Render filled button: rest fill `(0,122,255)`, hover fill `(0,122,255)` — identical, in both light and dark. Render chip: rest `#ECECEC`, hover `#ECECEC` light; rest `#333A3F`, hover `#333A3F` dark. Identical again. Compare `control-hover-light.png` against `finder-window-light.png`: they differ in exactly one region, x695–742 / y9–42, the toolbar search button, where the background goes `#FFFFFF` → `#F2F2F2`. In dark it becomes `#384146`. So macOS hover is a real, visible fill appearing, and the render's labelled "Hover" column is just its rest state repainted.

The press state, by contrast, is *exactly* right. `control-pressed-light.png` differs from `save-dialog-light.png` only at x359–432 / y501–524 — the Cancel button — going `#ECECEC` → `#D5D5D5`; in dark `#333A3F` → `#474D52`. The render's pressed chip is `#D5D5D5` light and `#474D52` dark. Those match byte for byte. The press token was derived from the real system; the hover token was not applied.

**2. The picker's chevron is a solid triangle.** Render: a filled grey down-triangle, `#767676`, ~8px wide at x160–167. macOS pop-up button ("File Format: Script"): a **stroked up-and-down chevron pair**, near-black, ~9px tall. I magnified both 10x to be sure. The filled triangle is the web/Windows `<select>` mark. The render's picker is also 28px tall (y72–99) where macOS's is 24px (y336–359), and it adds a 1px `#D5D5D5` stroke that macOS's pop-up does not have (macOS goes straight from `#FFFFFF` at y335 to `#ECECEC` at y336). The dark fill is right — render `#333A3F`, macOS `#333A3F` — it's the stroke and the mark that are wrong. The pagination arrows and the breadcrumb separator use the same filled-triangle language.

**3. The open menu is square-cornered with a full-bleed highlight.** Render menu panel: square corners, flat 1px `#E6E6E6` border, no shadow. Highlighted row: `#0064E1` running x377–534, edge-to-edge between the borders at 376 and 535, 28px tall (y128–155), corners hard. Every selection in the captures is the opposite: the System Settings sidebar selection is inset 18px and radius ~7px; the Finder sidebar selection likewise. And every surface in the captures — window, sheet, grouped box, search field, toolbar button — is rounded. A square-cornered, shadowless, edge-to-edge-highlight menu is the one thing in the set that doesn't look like it came from this operating system.

**4. The focus ring is half thickness and drawn inside.** Render focused text field: 2px `#80B3FA`, and the field stays 28px tall (y72–99), same as at rest — the ring replaces the border in place. macOS focused "Save As" field: 4px of `#89B6F8` (y205–208 and y231–234), and the field grows from 27px at rest to 30px focused — the ring is a halo *outside* the control.

**5. The accent blue is the nominal value, not the painted one.** Render uses `#007AFF` for the button, checkbox, radio and pagination. Measured off the captures: Save button `#157EFB` (21,126,251); System Settings radio `#157BF5`; the switch `#1576F2`; the sidebar selection `#1068DE`. Consistently ~21 red where the render has 0. Small, but it's on every primary control in the set and it's measurable.

**6. The pinned red is Material's, not the Mac's.** `#B3261E` (179,38,30). Reds measured in the captures: close button `#FC5E63`, the update badge `#F22C2F`, the settings red swatch `#DE3A43`. None is anywhere near that dark or that brown. (The sheet is captioned "pinned from outside the set", so this may be deliberately off-theme — but as a red in a Mac window it reads as foreign, and worth saying so.) Interestingly the paragraph's "coloured" run is `#FF383C`, which *is* a credible system red — so the set contains both.

**7. The scroll area fades its edge; macOS clips.** Render: a 14px alpha ramp, x24 (`#FBFCFF`) through x37 (`#6EA3FF`) before the content reaches full `#0088FF`. Finder's file list is cut dead at y=1020, mid-glyph, with one antialiasing row and then the window edge. No fade anywhere in any capture.

**8. The scrollbar floats in open space.** The thumb sits at x536–541 of a 900px panel — roughly 360px from the right edge — not against the content it measures. Combined with (1), it's a bar that's always there and never at the edge.

**9. The search tick marks are invisible.** Light: ticks are `(253,249,229)` on `#FFFFFF` — a maximum channel delta of 26, and only in blue. The "current match, stronger" tick is `(252,244,209)`, delta 46. Dark: `(62,62,49)` on `(30,30,30)`. At 1x these do not read as marks; I had to scan the column to confirm they exist.

**10. The light card is on the wrong side of the content.** Render chip surfaces, light: content `#FFFFFF`, card `#F7F7F7`, chrome `#F7F7F7` — the card is *darker* than the content. System Settings light does the reverse: the page is `#F7F7F7` and the grouped box on it is `#FFFFFF` (measured at x=600: y230–280 white box, y281–293 the `#F7F7F7` gap). In dark the render is right — its card `#2A3034` is exactly System Settings' dark grouped box `#2A3034`. So the dark ladder matches macOS and the light one is inverted.

**11. Breadcrumb and paragraph use web links.** `#0068DA`, underlined, with a filled triangle separator. There is no coloured underlined text anywhere in the five reference windows; Finder's path bar uses folder icons, grey chevrons and black labels.

**12. The ghost button has no bounds at all.** Row 55 across x315–384 is `(255,255,255)` for all 70 pixels — the control is literally nothing but its label at rest. On macOS the equivalent is the bounds-free toolbar button, and that's only workable *because* hover paints `#F2F2F2` under it. With hover a no-op (finding 1), a ghost button on this system can never be found by pointing at it.

---

**The short version:** the flat colour tokens are mostly measured from the real system and land well (`#ECECEC`, `#D5D5D5`, `#333A3F`, `#474D52`, `#F3F3F3`, the dark card, both text-field treatments). What's off is behaviour and shape language — hover isn't applied anywhere, the menu and its highlight don't look like macOS, the pop-up mark and the arrows are solid triangles, and the focus ring is the wrong thickness and on the wrong side of the border. What's missing is the structural half of a Mac window: switch, segmented control, sidebar, table with headers and stripes, grouped box, toolbar, sheet. And four of the set's components — search field, chip, pagination, standalone scrollbar — are either a re-skin of a sibling or something the platform deliberately does differently.

## How it was asked

Thirty offscreen renders at 1 px per point, one per gallery section in each
appearance: `components-button`, `components-button-emphasis`,
`components-button-pinned`, `components-chip`, `components-textfield`,
`components-searchfield`, `components-checkbox`, `components-picker`,
`components-list`, `components-scrollbar`, `components-scrollbar-search`,
`components-scrollarea`, `components-pagination`, `components-breadcrumb` and
`components-paragraph`, light and dark, each drawn with its own heading above
it on the appearance's window plane.

Beside them, eleven stored captures of this machine's own system:
`save-dialog-{light,dark}.png`, `finder-window-untinted-{light,dark}.png`,
`finder-window-light.png`, `control-hover-{light,dark}.png`,
`control-pressed-{light,dark}.png` and
`system-settings-grouped-box-{light,dark}.png`.

The reviewer had seen neither the plan nor the packet, was given no
checklist, was told to compare against the captures and never against macOS
from memory, was handed the recorded misreads verbatim, and was asked the one
question of this task.
