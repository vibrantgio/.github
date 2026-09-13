---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — the launcher, read cold

Two whole-window renders — the launcher in both appearances, drawn offscreen
at 1340×966, the size its window opens at, carrying the animated triangle
field the running window draws — handed with three macOS captures
(`finder-window-untinted-{light,dark}.png`,
`system-settings-grouped-box-light.png`) to an agent that had seen neither the
packet nor the plan, with no checklist and one question: put beside these
macOS windows, what would a developer who uses macOS every day say this app
gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; the
triangle field is deliberate and not an artefact; a still shows no hover, fade
or cursor; dark foreground reads grey at 1x and contrast is to be measured;
alpha names composite in encoded sRGB; every value was measured off a macOS
capture; the typeface is deliberately not the system's and the accent does not
change between appearances.

## The reviewer's reply, verbatim

> I read all five images and measured pixels rather than trusting impression. Here is what a daily macOS developer would say, worst first.
>
> ## 1. The cards have no surface at all — the wallpaper passes straight through them
>
> This is the defect everything else hangs off. I scanned row y=440 across the whole frame. Inside the Todos card and immediately outside it, the pixels are *identical*: (220,255,245) at x=30 (outside), (220,255,245) at x=47 (inside). Same in dark: (57,112,114) outside, (57,118,114) inside. At 3x you can see the background's triangle wireframe running uninterrupted through the card interior. The only thing that says "card" is a 1px stroke.
>
> macOS does the opposite. In the System Settings reference I measured the pane background at #FFFFFF and the grouped box fill at #F7F7F7 — an **opaque** fill, corner radius ~10px, and I scanned its edge: **no border stroke at all**. The box is defined entirely by fill, never by outline. The app has inverted this: outline only, no fill.
>
> ## 2. Text contrast fails, and fails by a different amount depending on where the card sits
>
> A direct consequence of #1 — the labels float on a gradient, so their contrast is a function of grid position.
>
> Dark mode, secondary body text #9A9A9A:
> - on the teal region (Todos, Site Docs): **1.82:1**
> - on the purple region (Feeds, Marketing): **3.62:1**
>
> 1.82:1 is not marginal, it is unreadable. The card *titles* in dark (#DDDDDD) measure only **3.77:1** — the brightest text in the dark frame misses 4.5:1.
>
> Light mode, #808080 secondary: **3.70:1** on the mint side, **2.84:1** on the lilac side.
>
> macOS never lets a label's contrast vary with position, because a label always sits on an opaque control background, never on the desktop tint. Finder's list rows measure a flat #FFFFFF (light) / #1E1E1E (dark) under every single row.
>
> ## 3. The window background is a saturated animated gradient; macOS windows are neutral
>
> Finder light: content #FFFFFF, sidebar #F7F7F7, toolbar #FFFFFF. Finder dark: #1E1E1E / #1C1C1C. Zero chroma anywhere. This app's background runs (229,232,247) top-left → (220,248,245) bottom-left → (220,212,245) top-right, with a visible triangular lattice under the content.
>
> I know the field is deliberate. The macOS objection is not that it exists but that it is *under the content*. macOS 26 does have "Tint window background with wallpaper colour" (it is right there in the Settings reference, toggled on), but that is a low-chroma wash behind sidebars and toolbars, and the content surfaces on top stay opaque. Here the tint is the reading surface.
>
> ## 4. Nine filled accent-blue default buttons
>
> Every card carries an identical #007AFF filled "Launch" button. Between the two reference windows — a full Finder window and a full System Settings pane — there are **zero** filled accent push buttons. macOS grants the filled accent style to exactly one control per window or sheet: the default action that Return triggers. Nine of them means none of them is the default, and the eye has nowhere to land. AppKit's answer for a repeated per-row action is the plain bordered push button (grey capsule), or no button at all.
>
> ## 5. The button label is bold
>
> "Launch" is set bold/semibold on the blue fill. macOS push-button labels are 13pt system **regular**, in every style including the default button. Bold button text is an Android/web tell.
>
> ## 6. The header is a web landing-page hero, not a macOS window header
>
> Top-left of the frame: an all-caps letterspaced "VIBRANTGIO" eyebrow, then "Workbench" with a 27px cap height (≈37pt), then a 15px subtitle.
>
> For comparison, I measured the largest text in each reference: System Settings' "Appearance" pane header is a 14px ink band, ~10px cap height (≈15pt). Finder's window title is a 13pt semibold toolbar string. A macOS window does not restate its own name at 37pt inside its content area — the title bar does that, and the content starts with the content.
>
> The eyebrow is worse: all-caps tracked-out kickers are a marketing-page device with no AppKit equivalent.
>
> ## 7. The card is not the click target
>
> Nine tiles, each with a small button in its lower-left. In every macOS launcher — Launchpad, Finder icon view, the Applications folder — the **tile itself** is the target, and it opens on double-click with the whole cell showing a selection fill on the way. A 110×24px sub-target inside a 300×189px cell means 96% of each tile is dead.
>
> ## 8. A launcher that shows no app icons
>
> Nine applications, and each is represented by a flat monochrome #007AFF Material glyph (the Todos clipboard, the Feeds list, the Marketing blocks — the latter two read as solid blue rectangles at 1x). macOS shows an application as its actual icon: a rounded-square, 3D-shaded, 64–128px artwork. Failing that, an SF Symbol — thinner stroke, optically sized, in the label colour, not the accent. Measured in dark, the accent glyph sits at **1.82:1** against the teal backdrop, so several of these icons are barely visible.
>
> ## 9. Every card has 66px of dead space at the bottom
>
> Card 1 spans y=284→473 (189px tall). Its content ends at y=407 (button bottom). All nine cards are fixed at 189px and all nine descriptions are two lines, so the bottom third of every card is empty by construction — not because one card is taller. macOS grouped boxes hug their content; the box in the Settings reference is exactly as tall as its rows.
>
> ## 10. The hairline reverses polarity between modes
>
> The card border is a hard-coded neutral that ignores the tint: **#E6E6E6 in light, #343434 in dark**.
> - Light: #E6E6E6 against the card interior measures **1.17:1** — effectively invisible, which is why the light frame reads as text floating on wallpaper.
> - Dark: #343434 is *darker* than everything around it (**2.43:1**), so the cards read as black wireframe cut-outs.
>
> macOS separators are a semi-transparent hairline that sits *within* the surface in both appearances and never swings from invisible to dominant.
>
> ## 11. Label colours are opaque, not alpha
>
> Light secondary text measures exactly (128,128,128). If this were macOS `secondaryLabelColor` (black at 50%) composited over the (220,250,245) backdrop it would land near (110,125,122). It doesn't — it's a flat grey painted over the tint, so it reads slightly dead and warm against the mint. Same in dark: exactly (154,154,154) everywhere. On macOS the label hierarchy is alpha over the surface, precisely so it inherits the surface's tone.
>
> ## 12. Smaller things
>
> - **Ragged left edge inside the card.** Icon left edge x=66, body text x=63, button x=62. Three different left margins in one 300px column.
> - **Corner radii.** Cards are radius ~7px against the macOS grouped box's ~10–11px (measured). The button is radius ~5px on a 24px height, where macOS 26 draws push buttons at that size as capsules.
> - **Jargon in shipped copy.** "Complete example apps built on mvu, components, theme, patterns and seen" — "and seen" reads as a typo to anyone outside the project, and internal package names have no business in the window subtitle. Likewise "961 bundled Material icons" advertises, in the UI, that this app is not using SF Symbols.
>
> ---
>
> ## What it gets right
>
> The accent is the genuine article: #007AFF measured exactly, unmodified, in both appearances. Geometry is disciplined — 46px left margin and 46px right margin, 17px gutters horizontally and vertically, three rows at identical 189px pitch, hairlines that are a true 1px at 1x with no half-pixel smear. The card icon is optically centred on its title (icon centre y=312, title cap centre y=312.5). Light-mode primary text is #272727 at **13.99:1**, a properly confident macOS label. The light/dark pair is structurally identical — nothing shifts, reflows or disappears between them, which is more than many real apps manage. The button at 24px tall is within a pixel or two of AppKit's 22pt regular push button. And the reading order inside each cell — icon and title, description, action — is the right order, left-aligned, no centring.
>
> The bones are sound. What is missing is the single most macOS thing there is: content sits on an opaque surface, and the surface is what you see.

## Disposition

**Fixed here.** Nothing. The window's fills are already the platform's names —
the whole-window test pins each cell to the window's own plane and its edge to
the separator flattened onto it — and every finding below is composition,
geometry or copy.

**Already pooled.** Nothing in this window has a standing item; the launcher's
composition, the dead space under each cell and the nine buttons were reported
at CC1.2 and dispositioned there as belonging to no phase.

**New for pooling.**

- 1 and 11 together, and they are the sharpest thing in the ten reviews: the
  cells are groups, so their inside is the window's own plane, and the
  animated field is painted *between* that plane and the page. So every
  foreground and every hairline in this window is flattened over a surface
  that is not the one it lands on. The reviewer measured the consequence:
  "Inside the Todos card and immediately outside it, the pixels are
  *identical*", and label contrast "is a function of grid position" — 1.82:1
  on the teal side of the dark frame against 3.62:1 on the purple.
- 2, the contrast that follows from it, stated as numbers: dark titles at
  3.77:1, dark secondary body at 1.82:1 on one side of the window.
- 3, the field as the reading surface: "macOS 26 does have 'Tint window
  background with wallpaper colour' … but that is a low-chroma wash behind
  sidebars and toolbars, and the content surfaces on top stay opaque. Here the
  tint is the reading surface."
- 4, nine accent-filled buttons: "macOS grants the filled accent style to
  exactly one control per window or sheet."
- 5, and again in marketing: every button label is bold where the platform's
  are regular.
- 6, the page opening with a marketing hero — an all-caps tracked eyebrow and
  a 37 pt restatement of the window's own name.
- 7, the cell not being the click target: "96% of each tile is dead."
- 8, applications shown as monochrome accent glyphs rather than icons.
- 9, 66 px of empty cell under every roster entry by construction.
- 10, the hairline reading 1.17:1 in light and 2.43:1 in dark against what
  actually surrounds it — the same cause as 1.
- 12, three left margins inside one cell, and the cell radius against the
  platform's grouped box.
- 12's last bullet, the window subtitle naming internal packages: "internal
  package names have no business in the window subtitle."

**Recorded misreads.**

- "The card border is a hard-coded neutral that ignores the tint" is not
  hard-coded: it is the platform's separator flattened over the window's own
  plane. The reviewer's complaint is right and its cause is finding 1 — the
  field sits between the plane and the hairline.
- The cells are groups, not cards. A group divides the page and takes the fill
  of the surface it is in, by the Language; the reviewer's "outline only, no
  fill" is an accurate description of a group and a fair question about
  whether a roster wants one.
