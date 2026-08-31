---
date: 2026-08-30
task: BD1.1
phase: BD
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BD1.1 — fresh-eyes review of the gallery window

2026-08-30. The reviewer was handed four 1280×800 gallery-window
captures — the two new sections (floating pane, button emphasis row) in
both schemes — briefed only on the recorded 1x dark-ink-reads-grey
misread, and asked what a developer on this platform would complain
about. Captures at `/tmp/bc11/window-*.png` (session-local); the
verbatim reply follows.

## Verbatim reply

> I read all four. Here is what a macOS developer looking at these
> would file.
>
> **The emphasis registers invert between themes, and they don't invert
> together.** In light, `Filled` is solid saturated purple with white
> text and `Tonal` is a pale lavender wash — an obvious high-to-low
> ladder. In dark, those two have swapped their appearance: `Filled` is
> now the pale lavender chip and `Tonal` is the deep saturated purple.
> Whatever the token math is doing, the result is that the same two
> lines of calling code produce opposite visual hierarchies depending
> on the user's system appearance. Worse, the icon-only button on the
> end of that same row keeps its saturated purple fill in *both*
> themes, so in dark it out-shouts the `Filled` face sitting beside it
> — three siblings in one row that no longer sort. The same defect
> reappears where it actually matters, in the modal footer: light gives
> `Cancel` the pale treatment and `Discard` the solid purple, so the
> destructive primary is unmistakable; dark hands `Cancel` the deep
> purple and `Discard` the pale one. A destructive action changing
> places with its escape hatch when the user flips to dark mode is a
> bug report, not a taste note.
>
> **Dark mode collapses the surface elevation the specimens are
> explicitly advertising.** The floating-pane row's own caption
> promises "ground showing all the way round it" and "its storey is the
> floor, a step darker than the paper." In dark, the page ground, the
> card, and the inset navigator are all effectively the same
> near-black; only a hairline stroke separates them. The specimen fails
> to demonstrate the thing it is captioned to demonstrate, which means
> a developer reaching for this pattern in a dark-first app gets
> nothing from the elevation system and has to draw borders by hand.
> The modal scrim has the mirror-image problem in each theme: in dark
> it barely darkens the page behind it, and in light it is a flat
> opaque grey slab that hides its backdrop entirely rather than dimming
> it — that isn't a scrim, and it will look wrong the moment there's
> real content underneath.
>
> **Focus is rendered inconsistently across control families, and in
> one case it destroys state.** Chips draw a purple outline outside the
> resting shape; the text field recolours its own border; the checkbox
> and radio replace their fill. The consequence is visible in the row
> itself: the "Focused" checkbox renders as an *unchecked* box with a
> ring, and the "Focused" radio as an empty ring with no dot, so focus
> and selected-state are competing for the same pixels — you cannot
> show a focused-and-checked control. On a platform where keyboard
> focus is an accessibility requirement, that's the finding I'd expect
> to be escalated first. Relatedly, the disabled text field's
> placeholder in dark is grey-on-grey to the point of illegibility, and
> the pressed chip in dark carries near-white text on a mid-grey fill
> that reads far weaker than its light counterpart.
>
> **Smaller, but they'd get mentioned.** The sidebar background doesn't
> fill the full window height in the light components view — it stops
> just below the last nav item and leaves a lighter block beneath,
> which does not happen in the patterns view, so the chrome's extent
> depends on what's scrolled into the content area. The `Pinned` red is
> identical in both themes; the caption says it's deliberately pinned
> from outside the palette, which is fair, but its dark rendering sits
> at noticeably weaker contrast against the black ground than against
> the light one, so "pinned" is quietly delivering two different
> legibility outcomes.

## Triage

- The icon-button claim ("keeps its saturated purple fill in both
  themes") was **disproved by pixel probe**: light filled and icon both
  {114 58 212 255}, dark filled and icon both {208 196 255 255}.
  `drawIconButton` and `drawButton` share `buttonColors`, so the faces
  cannot diverge by construction. Recorded as a misread: at 1x a small
  glyph square beside a wide button reads as more saturated than it is.
- Everything else was verified as real, none introduced by BD1.1, and
  pooled in `explorations/open-rulings.md` §N (items 124–129).
