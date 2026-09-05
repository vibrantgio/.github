---
date: 2026-09-05
task: BR1.3
phase: BR
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BR1.3 fresh-eyes review — vaultview's window on the visible backdrop

Two images, both offscreen renders at 1 px per dp, no application
launched: vaultview's whole window in each scheme, 1100x800, which is the
size the window opens at. They are the stored window goldens as BR1.3
left them — the backdrop layer under the frame, the note's paper filling
the content area alone, and the backdrop showing in the gap around the
rail pane.

One reviewer, shown both images and nothing else. It had not seen the
packet or the plan; no model override was passed, so it inherited the
dispatching session's model. It was given no checklist and one question:
what would a developer on this platform complain about? It was told to
sample pixels rather than judge fills by eye, and handed the three
recorded misreads — dark ink reads grey at 1x, the chrome-over-backdrop
step is a designed whisper (7.1 L* light, 1.7 L* dark), and chrome
regions sharing one fill are doing so by design.

## What came back, verbatim

I opened both images, then measured everything I report below. All coordinates are (x, y) with the origin at top-left; all values are 8-bit sRGB from the PNGs.

### The window's structure, as measured

Three vertical regions, verified identical on row 0 and row 799:

- x 0–247: light `(212,212,212)` / dark `(17,17,17)` — the gutter behind the left rail
- x 248–779: light `(246,246,246)` / dark `(24,24,24)` — content pane
- x 780: light `(212,212,212)` / dark `(46,46,46)` — 1px divider
- x 781–1099: light `(232,232,232)` / dark `(21,21,21)` — right rail

The left rail is a rounded card: at y=400 the row reads `212` to x=7, border `(190,190,190)` at x=8, fill `(232,232,232)` x 9–246, border at x=247, content at x=248. Corner radius ≈10px (border reaches full strength at x=8/y=17 and x=17/y=8).

I checked the gutter/rail step you flagged: light 212→232 is ΔL\* 7.1, dark 17→21 is ΔL\* 1.7. That is the designed whisper. Not reporting it.

---

### 1. The UI font is Roboto, not San Francisco

This is the loudest thing in the window and the first thing a Mac developer will say.

I measured the outline's "Reading list" at 72px wide with a cap height of 11 rows (R spans y 84–94 at x 805–817). SF Pro at 14px gives "Reading list" = 72px, cap 10. Roboto-Regular at 14px gives 75px, cap 11. The widths are close enough that metrics alone don't settle it — so I rendered both at 14px and compared glyph shapes against a 12× crop of the screenshot. The `R` leg, the `g` descender hook, and the `t` top match Roboto and not SF Pro.

Corroborated on disk: `design/fonts/roboto-regular.ttf`, `roboto-medium.ttf`, `robotomono-regular.ttf`. The app ships Android's system font and uses it for every string in the window, and Roboto Mono for the code blocks.

Nothing else on this list matters as much. A macOS developer identifies Roboto instantly — it is the single strongest "this is a ported web/Android app" signal available, and it is present in every pixel of text.

### 2. Selection is two different designs in the two modes, and it is drawn twice at once

Selected-row fill, sampled at (900, 90) and (100, 261) — identical in both rails:

- light: `(216,206,255)`, L\* 85.0, saturation 0.19, contrast against the rail `(232,232,232)` = **1.21:1**. Row text stays at primary ink `(19,19,19)`.
- dark: `(63,0,133)`, L\* 19.0, saturation **1.00**, contrast against the rail `(21,21,21)` = 1.35:1. Row text flips to `(238,238,238)`.

So light mode is a pale 19%-saturation tint with unchanged text; dark mode is a 100%-saturation accent fill with inverted text. Those are two different selection models, not one design in two appearances. On macOS `selectedContentBackgroundColor` is a strong accent with white label in *both* appearances; the light rendering here reads as the *unfocused/hover* state, so a light-mode user sees a selection that looks disabled while the dark-mode user sees one that shouts.

Separately: the left rail's "Reading list" (y 246–277) and the right rail's "Reading list" (y 74–105) are both drawn at full selection strength simultaneously. macOS shows the accent fill only in the pane that has focus and greys the other. Two live-looking selections in one window is wrong regardless of which fill you pick.

Also worth noting: `(63,0,133)` is a fully saturated web purple at 52% value. No macOS accent produces it; systemPurple in dark is `#BF5AF2`.

### 3. Scrollbars: always visible, too heavy, and the two instances don't match each other

Both thumbs are 6px and neither has a track.

- Vertical, content pane: x 766–771, y 198–744. Light `(142,142,142)` = 3.03:1 on the page; dark `(135,135,135)` = 4.94:1.
- Horizontal, inside the code block: x 286–706 at y 731–736. Light `(92,92,92)` = **5.91:1** on the code fill; dark `(204,204,204)` = **10.21:1**.

Three problems, all measured:

- **The horizontal thumb is more prominent than the code it belongs to.** In light, the thumb is 5.91:1 while the comment text on the same fill is 2.30:1 — the scrollbar has 2.6× the contrast of the text. In dark it's 10.21:1 vs 3.36:1, a 3× gap. In the 3× crop the bar is the heaviest object in the block.
- **The two scrollbars use different tints, and the polarity flips between modes.** Light: horizontal (92) is *darker* than vertical (142). Dark: horizontal (204) is *brighter* than vertical (135). Same control, four different values.
- **They never hide.** The vertical thumb spans y 198–744 of a track that starts at 198 (3px under the Properties box, which ends at y=195) — the thumb covers roughly 95% of its track, i.e. about 26px of actual overflow. macOS overlay scrollbars would show nothing at rest for that, and would fade in only while scrolling. Here a permanent grey bar is parked in the margin for 26px of scroll.

The horizontal thumb also has 1px of clearance from its frame: at x=500 the thumb runs y 731–736, one row of fill at 737, block border at 738. It visually touches the box.

### 4. The left rail card has a gutter on three sides and none on the fourth

Measured insets for the card: left 8px (backdrop x 0–7), top 8px (backdrop y 0–7 at x=100), bottom 8px (border at y=791, backdrop y 792–799), **right 0px** — the border sits at x=247 and the content pane begins at x=248.

The consequence is visible at the corners. At y=8–16, x 243–247 is filled with the *gutter* colour `(212,212,212)` — the wedge outside the card's rounded top-right corner, jammed against the content pane with nothing between them. Same at the bottom right (y 786–791). At 1x that reads as a small dark nick where the rail meets the document. Either give the card a right gutter or square off its right corners.

### 5. The right rail is drawn with a different idiom from the left rail

Left rail: inset rounded card, 1px border `(190,190,190)` light / `(54,54,54)` dark, radius 10.
Right rail: full-bleed to all four window edges, no border, no radius, separated only by the 1px divider at x=780.

Two panels doing the same job (window furniture flanking a document) built out of two different components. In light the edge weights are also mismatched — the card border is L\* 77.0 while the right divider is L\* 84.9 — so the left rail is fenced noticeably harder than the right one. In dark they nearly converge (54 vs 46), so the mismatch itself changes between appearances.

### 6. Nothing in the window is, or looks like, a native control

- **No toolbar.** The top 45px is bare. A three-pane document app on macOS has a unified toolbar; here "Second Brain" is a plain label at (272, 19–30).
- **Back/forward are bare 8×14 chevrons** at x 276–283 and x 300–307, y 55–68. No button chrome, no segmented control, no hit-area affordance. macOS gives these a 32×24pt segmented control in the toolbar.
- **Disabled forward is invisible.** `(212,212,212)` on `(246,246,246)` = **1.37:1** in light; `(46,46,46)` on `(24,24,24)` = 1.31:1 in dark. Below any perceptibility threshold — it reads as an empty gap, not a disabled control.
- **The search field has no magnifier and no clear button.** Just a 40px-tall rounded box, x 16–239, y 52–91, with a `(121,121,121)` stroke = 3.55:1 against the rail. macOS search fields carry a magnifier glyph, are 22–28pt tall, and use a far lighter stroke.
- **"Rescan" and "Switch Vault"** (x 25–69 and 91–168, y 761–772) have no fill and no border — I scanned the whole band and found only glyph ink. They are indistinguishable from labels.
- **Control tinting is inconsistent.** The sidebar-toggle icon at x 219–236, y 18–33 is drawn at `(19,19,19)` — the same ink as body text, making it the darkest object in the rail — while the back chevron in the same window is `(122,122,122)`. Two navigation controls, two ink levels.

### 7. Code-comment contrast is genuinely too low in light mode

Comment ink `(156,160,176)` on the code fill `(239,241,245)` = **2.30:1**. That fails even the 3:1 non-text floor, let alone 4.5:1. The dark equivalent is `(108,112,134)` on `(30,30,46)` = 3.36:1 — still under 4.5 but far better. This is the one place where "washed out" is real rather than an antialiasing artifact; I sampled the darkest pixel across the whole comment run and 156 is the floor.

For reference the other ink in that block is fine: inline code `(76,79,105)` = 7.06:1 light, `(205,214,244)` = 11.34:1 dark.

### 8. Three panes, three padding schemes; three footers at three heights

Content insets, measured from each pane's own edges:

- left rail: content x 16–239 inside fill x 9–246 → 7 / 7
- content pane: body x 272–749 inside pane x 248–779 → 24 / 30
- right rail: content x 796–1077 inside x 781–1099 → 15 / 22

The 6–7px extra on the right of the last two is consistent with a reserved 6px scrollbar gutter, which explains it — but the right rail's outline never scrolls, so its content just sits 7px off-centre, and the content pane's actual scrollbar (x 766–771) is not in the gutter it reserved anyway.

The footers are worse:

- left rail: separator at y=743, text y 761–772, card bottom 791 → 18px below the text
- right rail: separator at y=683, "Backlinks" 699–710, "No notes link here." 735–746, window bottom 799 → **53px** below the text
- content pane: **no separator at all**, "29 lines" at y 783–792 → **7px** below the text

I scanned x 248–765 for every row and found nothing between the code block (ends y=738) and "29 lines" (starts y=783) — no rule, no fill change. So the content pane's status line is the only footer without a divider, it is the only one crammed against the window edge (7px vs 18px vs 53px), and because it shares the page fill exactly, scrolling content will run into it with no boundary.

### 9. The secondary-text token collapses in light and splits in dark

Sampled darkest/brightest ink per run:

| | light | dark |
|---|---|---|
| "Properties", breadcrumb "guide", "Find a note…", "29 lines" | `92` | `204` |
| "Outline", "Backlinks", "No notes link here." | `92` | `155` |

In light both groups are byte-identical at `(92,92,92)`. In dark they diverge by 49 levels (11.06:1 vs 6.57:1 against their backgrounds). So the right rail's section headers look exactly as strong as the content pane's in light and visibly dimmer in dark. Either two tokens have been accidentally given the same light value, or one token is being applied where two are meant — but the modes disagree about it either way.

The same inconsistency shows up in box borders:

| | light | dark |
|---|---|---|
| Properties box border | `(182)` = 1.88:1 | `(71)` = 1.91:1 |
| code block / inline code border | `(121)` = **4.03:1** | `(109)` = 3.43:1 |

Two bordered boxes stacked in the same 478px column with a 2× difference in edge weight. The light/dark pairs also don't track each other (4.03 vs 3.43).

### 10. Everything is sized for a browser, not for macOS

- Sidebar and outline rows are on a **36px pitch** (tree item centres at 117.5, 153.5, 189.5, 225.5, 261.5, 297.5; outline at 89.5, 125.5, 161.5). Selection pills are 32px tall inside that. macOS source lists are 24pt small / 28pt medium / 32pt large — 36 is off the end of the scale.
- The search field is **40px tall** (y 52–91). macOS: 22–28pt.
- Body text measures ~15px (cap height 11 rows: "T" of "The" spans y 266–277). The system size for this kind of UI is 13pt.

Together with Roboto, this is what makes the window read as Electron.

### 11. The outline's indent step is 7px

Right-rail text starts: section labels at x=796, H1 item "Reading list" at x=805, H2 items "Open questions" and "A sample" at x=812. So the heading-level indent is **7px** — barely a glyph's width, and the hierarchy it encodes is almost unreadable. The section label at 796 also hangs 9px left of every item, aligning with the selection pill's *outer* edge rather than with the item text, which is backwards from the macOS sidebar convention.

(The left rail's tree, by contrast, is fine: depth-0 text at x=44–45 with chevrons at 25–38, depth-1 text at 58–59 with chevrons at 42–49 — a clean 14px step. "Sources" at x=44 is a root-level file, not a mis-indented child. I checked this before reporting it and it is correct.)

### 12. The right rail is wider than the left and 64% empty at the default size

Right rail 319px, left rail 248px, document 532px. At 1100pt the document gets under half the window while the widest panel is the outline. Between the last outline item (ends y=168) and the Backlinks separator (y=683) there are **515 rows of nothing**. A three-pane layout at this default window size gives the note less room than the two rails combined (567px).

---

### Things I looked at and am not filing

- The rail/gutter and rail/page fill steps — sampled, they are the designed whisper you described (ΔL\* 7.1 light, 1.7 dark).
- Ink weight. Every primary run bottoms out at `(19,19,19)` light / peaks at `(238,238,238)` dark, 17.19:1 and 15.30:1. Nothing is washed out; the greys are antialiasing.
- The vertical scrollbar's thumb starting at y=198 rather than at the top of the pane. It looked like an offset thumb on a scrolled-to-top document, but the Properties box is pinned and ends at y=195, so the track legitimately starts at 198. Not a bug.
- The clipped comment line ("…not navigat"). The clip is clean at a glyph boundary around x=736, consistent with symmetric 13px block padding (text starts at x=286, 13px in from the border at 273). The truncation is silent — no ellipsis, no fade — but geometrically it is correct.
- The code fill is blue-tinted (`(239,241,245)` light, `(30,30,46)` dark) while every other surface in the window is neutral. That's a syntax theme choice, and defensible, though it does make the code blocks look imported from another app.

### What I could not determine from the capture

Whether the window has a system title bar. All four corners are square (`(212,212,212)` at (0,0) and (0,799); `(232,232,232)` at (1099,0) and (1099,799)), which is expected for an offscreen content render — the OS would round them. But nothing in the top-left is reserved for traffic lights: the card fill starts at y=9 and the first content in that area is the toggle icon at (219–236, 18–33). If this window uses a hidden/unified title bar, the close/minimize/zoom buttons will land on the card's rounded top-left corner at roughly x 13–75, y 13–33. If it uses the standard title bar, this is fine and the capture simply excludes it. Worth confirming against a real on-screen window.

## Triage

**Fixed in this task.** Finding 4, the nick at the pane's trailing
corners, and only that half of it. The pane is set in from three of the
window's edges and stands flush against the document on the fourth, so
the backdrop belongs to those three sides — but until this fix the two
arcs the pane rounds away from its trailing edge showed the backdrop as
well, against the document, which is exactly the nick the reviewer
measured. It is a defect this task created: before it, those arcs showed
the paper the frame painted across the whole window, byte-identical to
the document beside them. `pane.FillTrailingCorners` now paints that
strip in the fill of the region flush against the edge, and both pane
callers use it; vaultview's window test pins the two corners. The other
half of the finding — whether a pane should be set in on its fourth side
too, or square its flush corners — is a change to the pattern's geometry
and is pooled.

**Answered, not a defect.** Finding 5. The two columns are two different
things by design: the rail is a pane, dismissible and therefore an
object with an inset and an outline, and the trailing column is flush
chrome, fixed, which wears a plain seam instead. The differing edge
weights are the two derivations they are drawn from. The reviewer's
"what I could not determine" is the full-size-content treatment: the
window's control buttons stand at the platform's own inset and the
pane's top strip is cut to hold them, which the goldens do not draw.

**Out of BR1.3's scope, for pooling.** Findings 1 (Roboto rather than
the platform's own face), 2 (the two schemes carry two different
selection models, and both columns show a selection at once), 3
(scrollbars always visible, heavier than the code they belong to, two
tints that flip polarity between schemes), 6 (no control in the window
reads as one — bare chevrons, a disabled control at 1.37:1, a search
field with no magnifier, two actions with no fill or border, two
navigation marks at two ink levels), 7 (code-comment ink at 2.30:1 in
light, under even the 3:1 non-text floor), 8 (three panes with three
padding schemes and three footer treatments, one of them with no
separator at all), 9 (the secondary-text ink is byte-identical for two
groups in light and 49 levels apart in dark; two bordered boxes in one
column at a 2× difference in edge weight), 10 (36 px row pitch and a 40
px search field, both off the top of the platform's scale), 11 (a 7 px
indent step in the outline), 12 (the document gets less width than the
two columns beside it at the default window size).
