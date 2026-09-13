---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — VaultView, read cold

Two whole-window renders — the vault reader in both appearances, drawn
offscreen at 1100×800, the size its window opens at, with a note open, its
properties table, its outline and its backlinks — handed with three macOS
captures (`finder-window-untinted-{light,dark}.png`, `notes-window.png`) to an
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

> I read all five images and measured pixels throughout rather than trusting impressions (which caught me twice — see the "gets right" list).
>
> ## Worst first
>
> **1. The sidebar is a floating, outlined, rounded card. The other two panes bleed off the window.**
> The sidebar occupies x8–247, y8–791 with a 1px stroke all the way around (#919191 light, #3d3d3d dark) and ~10px corner rounding, leaving 8px of window backdrop showing on its left, top and bottom. The content pane and the Outline panel meanwhile run x250–1099, y0–799 — no inset, no stroke, no rounding. (That asymmetry is what proves it's the app and not a harness frame.) macOS split-view panes are flush, full-height, and share the window's own bounds; only the window is rounded. Finder light has *no line at all* between sidebar and list — #f7f7f7 simply meets #ffffff at x=351/352. Finder dark uses one 1px #434343 hairline; Notes uses #3a4549. A grey box drawn around the sidebar with a gutter behind it is the single thing that reads "not a Mac app" from across the room.
>
> **2. Two full-accent selections at once, and accent is the wrong fill for both.**
> The sidebar "Reading list" (x17–238, y218–246) and the Outline "Reading list" (x796–1077, y72–96) are *both* filled #178bfb with white labels. macOS never does either half of that. Finder's selected sidebar row is a #f2f2f2 capsule on the #f7f7f7 sidebar (#2a2a2a on #1b1b1b in dark) with the label in ordinary text colour — only the *icon* takes the accent tint (#76b3f5). Notes' selected note row is #464646 on a #232a2d list. And only the pane holding keyboard focus draws an emphasized selection; the other drops to unemphasized grey. Painting both panes' selections at full saturation tells the user two things have focus.
>
> **3. There is no toolbar.**
> "Second Brain" is plain text at (272,16) sitting directly on white content, and the back/forward chevrons are pushed *below* it to y=61, inside the document body. No toolbar fill, no controls, and — measured — no hairline anywhere in x=400, y12–57. Finder draws a separator across the full width under its toolbar at y=105 (#e6e6e6) light / y=117 (#373737) dark; Notes' toolbar band is #232323 against #1e1e1e content with hairlines above and below. Back/forward on macOS is also a segmented control with a pill housing and a divider, not two bare strokes, and the disabled forward arrow is a dimmed glyph *inside* that housing.
>
> **4. Scrollbars are always visible and opaque.**
> A 6px #6d6d6d (light) / #9f9f9f (dark) knob sits at x766–771 spanning y198–744, plus a second at y731–736 glued inside the code block's border. Both Finder references show lists whose content clearly continues past the frame and show **zero** scrollbar pixels at the right edge in either appearance — overlay scrollers are gone when idle. The code block's horizontal scroller is worse: it's laid out inside the block, permanently consuming a line of height, instead of floating over the content.
>
> **5. Dark-mode section headers and empty states are too dim.**
> "Outline" (800,48), "Backlinks", and "No notes link here" measure #545454 on #1c1c1c — about 2.2:1. Finder's dark "Favourites" header is #989898 on the same ground, about 5.5:1. Light mode is *correct* (the app's #b7b7b7 is Finder's #b7b7b7 exactly), so this looks like the light tertiary value got naively inverted (255−183=72≈#48) rather than taking the platform's dark tertiary. The properties column and "29 lines" got it right at #9a9a9a, matching Finder's dark #9a9a9a — so it's only the header/empty-state token.
>
> **6. The Outline label shifts 8px left when selected.**
> "Open questions" starts at x=813 and "A sample" at x=812, but the selected "Reading list" glyphs start at x=805. The capsule should be painted behind a fixed label. The left sidebar gets this right (selected and unselected labels both start at x=61), so the bug is isolated to the Outline list.
>
> **7. The Backlinks section is bottom-anchored, leaving ~550px of dead panel.**
> Outline items end at y=133; nothing until a divider at y=695, then "Backlinks" and its empty state. macOS inspectors stack sections top-down and let the slack fall at the bottom. Related inconsistency: that divider is inset (x796–1077) while the sidebar's footer divider at y=743 is full-bleed (x9–246) — two separator conventions in one window.
>
> **8. No icons in the sidebar.** Folders ("Design", "guide") and notes ("Principles", "Reading list", "Sources") differ only by a disclosure chevron, so a leaf note and a collapsed folder at the same depth look identical. Every macOS source list pairs a symbol with each label — and in Finder the icon is precisely what carries the accent tint on selection.
>
> **9. "Rescan" / "Switch Vault" are bare text.** At y≈762 they're #262626 — the same colour and weight as the sidebar's own item labels — with no button housing, so they read as two more rows of the tree. macOS bottom bars use small icon buttons or a gear pop-up.
>
> **10. The search field's value is inverted.** It's #ffffff on the #f7f7f7 sidebar, the brightest surface in the pane, with no border (pure white meeting #f7f7f7 with only antialiasing). Finder's light search field is #f7f7f7 *recessed into* a #ffffff toolbar. macOS search fields are darker than their ground, never lighter.
>
> **11. The status line is clipped by the window edge.** "29 lines" runs down to y=791 — the same row as the sidebar card's bottom border — with no bar behind it and no hairline above. Meanwhile the content pane continues to y=799 while the sidebar stops at 791, so the two panes don't even end at the same place.
>
> **12. Minor:** the dark code-block fill is #1e1e2e, a blue-violet against the #1e1e1e window — a syntax theme's own background rather than a window-relative surface. The light one (#eff1f5) passes.
>
> ## What it gets right
>
> The colour work is genuinely measured, not guessed, and twice it beat my own eye: light tertiary #b7b7b7 is Finder's #b7b7b7 to the digit, dark secondary #9a9a9a is Finder's #9a9a9a, and the dark chrome/content pair #1c1c1c/#1e1e1e matches Finder dark exactly — including the counter-intuitive detail that the dark sidebar is *darker* than the content, which I was about to file as a defect until I sampled a clean region. The dark divider #3d3d3d lands between Notes' #3a4549 and Finder's #434343. The sidebar toggle at (225,26) is exactly where Notes puts its own (205,26). Sidebar row pitch is 32px, matching Finder. Scrollbar knobs are proper capsules with 3px round caps and correctly flip polarity between appearances. Tree indentation is consistent and labels align across depth. And the document column keeps a real reading measure (~477px) with restrained hairline rows in the properties table.

## Disposition

**Fixed here.** Nothing. Every finding is geometry, a control the window does
not have, or a question the Language has to answer first; none is a platform
name this task can swap.

**Already pooled.**

- 4, the always-visible scroller and the code block's horizontal bar: item
  342, and the same complaint in mindchat's 368.
- 2's second half — no pane knows whether its window is frontmost, so the
  unemphasized selection is never asked for — is items 411 and 412.
- 11, the status line reading as the note's last line rather than as chrome:
  item 347.
- The rail's disagreeing left edges, behind findings 6 and 7: item 348.

**New for pooling.**

- 1, the rail as an outlined floating pane while the other two columns bleed
  off the window: "A grey box drawn around the sidebar with a gutter behind it
  is the single thing that reads 'not a Mac app' from across the room." The
  hairline is `patterns/pane`'s deliberate one, and the Language's Seam entry
  says an inset object needs no seam — the two disagree and one must give.
- 2's first half, two panes at full-accent selection at once: "Painting both
  panes' selections at full saturation tells the user two things have focus",
  and Finder's own selected rail row is `#f2f2f2` with an ordinary label, the
  accent reaching only the icon.
- 3, no toolbar: the title sits on the content, the chevrons are pushed into
  the document, and there is no hairline anywhere above the body.
- 5, the dark rail's section headings and empty states at `#545454` on
  `#1c1c1c`, ≈2.2:1, where Finder's dark "Favourites" is `#989898`. The light
  value is the platform's tertiary label and matches Finder to the digit, so
  the two cannot both be tertiary; which name a rail's section heading takes
  is the question.
- 6, the Outline's selected label shifting 8 px left of its unselected
  neighbours.
- 7, the Backlinks section bottom-anchored with ~550 px of empty panel above
  it, and two separator conventions — one inset, one full-bleed — in one
  window.
- 8, no icons in the rail: "a leaf note and a collapsed folder at the same
  depth look identical."
- 9, "Rescan" / "Switch Vault" as bare text at the rail's own label strength.
- 10, the find field brighter than the rail it sits in: "macOS search fields
  are darker than their ground, never lighter." Needs a measurement — no
  stored capture holds a field inside a sidebar.

**Recorded misreads.**

- 12, the dark code block at `#1e1e2e`: that is the syntax base's own
  background, which `markdown/highlight` reports and does not move. Already on
  record from CC1.2.
- The document's prose reading pure black and pure white is the platform's
  `textColor`, which is `#000000` / `#ffffff` in the catalogue — a document is
  not a label. (That mindchat's transcript takes `labelColor` instead is a
  real inconsistency, and is pooled from that app's review.)
