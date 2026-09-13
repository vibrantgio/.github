---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — Site Docs, read cold

Two whole-window renders — the documentation browser in both appearances,
drawn offscreen at 1200×800, the size its window opens at, on the Docs tab
with the guide open, its outline beside it and a fenced block and a quote in
the page — handed with three macOS captures
(`finder-window-untinted-{light,dark}.png`, `notes-window.png`) to an agent
that had seen neither the packet nor the plan, with no checklist and one
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

> I read all five images and measured pixels off each. Here is what a Mac developer would flag, worst first.
>
> ## 1. The window has the wrong bones: a full-width tab strip where the title bar belongs
>
> The tab row (`Docs Theme Components Patterns Markdown`) spans the entire window width, y=0–54, and the sidebar starts *below* it at y=55, boxed in by a full-width hairline. Both Finder references and Notes do the opposite: the sidebar runs floor-to-ceiling against the window's left edge, and the toolbar is split over it — sidebar material behind the traffic lights, content material to the right of the seam. There is no horizontal rule crossing the sidebar anywhere in macOS.
>
> Worse, this strip is unusable in a real window. In the Finder reference the window's left edge is at x=38 and the traffic lights sit at x=60/83/106 — a cluster occupying roughly 14–74px in from the edge. In this app the word "Docs" begins at x=13 and "Theme" runs 68–110. The close, minimise and zoom buttons would land directly on the first two tabs.
>
> The selected-tab underline is worse still: it runs **x=0 to x=55**, starting at the literal window edge, where the rounded corner is, and overshooting the 13–42px label on both sides. Nothing in macOS paints to x=0 at the top of a window.
>
> ## 2. No toolbar, and in particular no search field
>
> There is no window title, no back/forward, no sidebar toggle, no search. Finder carries all four; Notes carries a sidebar toggle at top-left and a search field at top-right. A documentation browser is the one app category where macOS always leads with search — Dictionary, Xcode's documentation window, Help Viewer all do. Here there is no way to find anything except by scrolling an outline.
>
> ## 3. The underlined tab strip is a web idiom
>
> macOS switches top-level views with a segmented control in the toolbar (Finder's view-mode segment is visible in the reference), or with sidebar sections. It does not use a 2px underline beneath a text label. Compounding it: the selected tab's label is `#262626`, *identical* to the four unselected labels — only the underline distinguishes it. A macOS segmented control changes the selected segment's fill.
>
> ## 4. Two different accent blues, and neither is the system blue
>
> - Sidebar selection pill: `#178BFB` light, `#1994FC` dark
> - Tab underline: `#0064E1` light, `#0059D1` dark
>
> macOS systemBlue is `#007AFF`. So the window carries two accents, both wrong, and — against the stated platform behaviour that the accent does not change between appearances — **both shift between light and dark**. The pill blue is also lighter than systemBlue, which costs contrast: white on `#178BFB` measures **3.43:1** (white on `#007AFF` is ~4.0:1).
>
> ## 5. The sidebar is denser than any macOS sidebar, and the chevron collides with the pill
>
> | | this app | Finder (measured) |
> |---|---|---|
> | row pitch | 28px | 32px |
> | selection height | 28px | 30px |
> | selection side inset | 10px | 18px |
>
> A 28px pill in a 28px row means **zero vertical gap** — two adjacent selected rows would touch, which never happens in macOS. And on the selected row the disclosure chevron sits at x=12–15 inside a pill that starts at x=10, so it is jammed 2px from the capsule's rounded corner; the enlarged crop shows it visibly crowded by the curve. macOS keeps the disclosure control clear of the selection shape.
>
> ## 6. Child rows use a smaller type size — backwards from macOS
>
> "First child" / "Second child" have a cap height of 8px against 10px for the top-level rows (same colour, `#262626`, in both). In a macOS source list every row is one size and depth is expressed by indent alone; smaller type is what macOS reserves for *group headers* ("Favourites", "Locations", "Tags" in the Finder reference). So the hierarchy reads inverted — the children look like section labels. The indent step is also only 14px, against roughly a full disclosure column in Finder.
>
> ## 7. Body and heading text are pure black / pure white
>
> Content text measures `#000000` in light and `#FFFFFF` in dark. macOS labelColor is never either: Finder's filenames measure `#272727` light and `#DDDDDD` dark, Notes' body `#DCDCDC`. The app's *own sidebar* gets this right (`#262626` / `#DCDCDC`) — so the content column is inconsistent with the sidebar next to it as well as with the platform. Pure white on `#1E1E1E` is the one that will look harsh in use.
>
> ## 8. The reading column is glued to the left
>
> Text wraps at x=1034 and the code panel ends at x=1043, in a 1200px window. That is a 25px gutter on the left of the column and **156px on the right**. Notes keeps near-equal margins in its content pane. A max reading measure is fine; anchoring it left and leaving a sixth of the window blank on one side is not what macOS does.
>
> ## 9. The code block wears GitHub's web theme
>
> Keywords `#CF222E` light / `#FF7B72` dark, identifiers `#6639BA` / `#D2A8FF` — those are GitHub's light and dark syntax palettes verbatim. A Mac developer reads them as a web page embedded in a window; Xcode's default theme is magenta keywords and teal types. The panel itself is fine; the colours inside it are from another platform.
>
> ## 10. Smaller things
>
> - **Blockquote text in light** is `#808080` on white = **3.95:1**, under the 4.5 threshold. The dark equivalent (`#9A9A9A` on `#1E1E1E`, 5.92:1) is fine — the light one is the weak half.
> - **The heading ramp is compressed**: cap heights 17 (H1) / 15 (H2) / 13 (H4) / 11 (body). "Too deep for the tree" is a level-four heading and is only 2px of cap smaller than a level two. The body is also larger than macOS's 13pt.
> - **No icons in the sidebar.** Both Finder and Notes pair every row with an SF Symbol. Defensible for a document outline, but it is a visible difference.
>
> ---
>
> ## What it gets right
>
> The materials are essentially exact. Light: sidebar `#F7F7F7`, content `#FFFFFF`, 1px `#DFDFDF` seam. Dark: sidebar `#1C1C1C`, content `#1E1E1E`, `#323232` seam. Finder measures `#F7F7F7` sidebar in light and `#1D1D1D` / `#1E1E1E` in dark — the app is within a unit of the platform in both appearances, including the correct near-invisible light contrast that relies on the seam to read.
>
> The code panel's elevation is symmetric and well judged: `#F4F5F5` on white and `#292929` on `#1E1E1E` are both exactly +11 off their background, each with a 1px border (`#DCDDDD` / `#3E3E3E`) and a ~6px radius. Getting the same perceived lift in both appearances is the part people usually botch, and it is right here.
>
> Sidebar label colour (`#262626` / `#DCDCDC`) is macOS labelColor. The selection pill's ~6px corner radius and 280px width are correct proportions. Dark secondary text at `#9A9A9A` is well set. Overlay scrollbars are correctly absent at rest. The two appearances are structurally identical — nothing moves or reflows between them.

## Disposition

**Fixed here.** The row pitch in finding 5. The docs outline is a tree in a
chrome rail, and the platform's sidebar and tree row is 32 dp, measured off
Finder and Voice Memos and recorded in ADR-019; the outline carried a local
28. It now reads `patterns/sidebar`'s `RowHeight`, the same constant
vaultview's tree and feeds' rail already take. The `docs-tab-{light,dark}`
goldens move for that and nothing else.

The selection inset in the same table is not a defect: the stored measurement
is 10 px from each edge of the rail, in Finder and in Voice Memos alike, and
that is what the pattern draws.

**Already pooled.**

- 4's second half — the rail pill's value not being the accent — is item 411.
- 9, the fenced block wearing a style author's colours, is `markdown/highlight`
  reporting what a base measures, on record from CC1.2.

**New for pooling.**

- 1, the tab strip crossing the whole window above the rail: "There is no
  horizontal rule crossing the sidebar anywhere in macOS", and, worse, "The
  close, minimise and zoom buttons would land directly on the first two tabs."
- 1's underline running to x=0, "where the rounded corner is".
- 2, no toolbar and no search: "A documentation browser is the one app
  category where macOS always leads with search."
- 3, the underlined tab strip as an idiom, and the selected tab's label being
  the same colour as the four unselected ones.
- 4's first half: the tab underline is `selectedContentBackground` while the
  rail's pill is the measured sidebar selection, so one window shows two
  selection colours for two different kinds of selection. The same complaint
  came back independently from sk150 and feeds.
- 5's remainder: a 32 dp pill in a 32 dp row leaves no gap between two
  adjacent selected rows, and the disclosure mark sits inside the pill's
  corner curve.
- 6, child rows set smaller than their parents: "the hierarchy reads inverted
  — the children look like section labels."
- 8, the reading column glued to the left: 25 px of gutter on one side and 156
  on the other.
- 10, the light blockquote at `#808080` on white, and the compressed heading
  ramp.

**Recorded misreads.**

- 4 reads the two selection colours as two accents that "both shift between
  light and dark". Neither is the accent: `#0064e1`/`#0059d1` is
  `selectedContentBackgroundColor` and `#178bfb`/`#1994fc` the sidebar
  selection, both measured per scheme, and the accent itself is `#007aff` in
  both appearances as briefed.
- 7, the body set in pure black and pure white, is the platform's `textColor`,
  which the catalogue records as `#000000` / `#ffffff`. A document is not a
  label. That this disagrees with mindchat's transcript is real and is pooled
  from that review.
