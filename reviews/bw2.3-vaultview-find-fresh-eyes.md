---
date: 2026-09-08
task: BW2.3
phase: BW
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BW2.3 fresh-eyes review — the vault window while the page is being searched

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, the frame's own seam not being a scrollbar, and a still capture
not being able to show a scrollbar's fade — and told nothing else.

## How the captures were taken

**No window was opened.** The two window goldens this task added were
rendered headlessly, each 1100×800 at one device pixel per point — the
size the application's window opens at — in the light scheme and in the
dark: `workbench/vaultview/testdata/golden/window-find-light.png` and
`window-find-dark.png`. Both show a thirty-section note seated so that
the three matches of the query `margin` are on the page, the find field
open over the note with the query in it, the reader on the second of the
three matches, and the places of all three on the note's scrollbar.

## The reviewer's reply, verbatim

> I read both PNGs and then cropped and pixel-sampled the suspicious regions. Here is what a Mac-native eye would file.
>
> **The scrollbar looks broken.** In the content pane the thumb runs x≈766–771, y≈275–390. The find-match ticks are painted *on top of it*, at full opacity, at exactly the thumb's width — three yellow bands (#E7D700) slicing through the grey. It doesn't read as "matches are here"; it reads as a thumb rendered in segments, or a repaint that lost three rows. Every Mac app puts those ticks in the track, inset or narrower than the thumb, never over it. Worse, the thumb is `rgb(137,137,137)` in light and `rgb(135,135,135)` in dark — the same grey on a `241` background and on a `24` background. It doesn't theme at all. And the outline pane's thumb is `129`, a third grey for the second scrollbar in the same window.
>
> **You can't tell which match is "2 of 3".** All three highlights look identical at a glance. They aren't: matches 1 and 3 are `#E7D700`, match 2 is `#C6B900` (dark: `#4E4800` vs `#746E30`). That's a ~14% luminance step on a saturated yellow — invisible at 1x. The counter promises a current match the eye cannot find. The highlight rect itself is a raw glyph-bounds box: square corners, zero horizontal padding (the `m` and the `n` touch the edges), and vertically off-centre — more box below the baseline than above the cap. In dark it's a flat olive that looks like the light swatch with the lights turned down, not a designed dark highlight.
>
> **The window is built from two different kinds of container.** The sidebar is a rounded card floating on an 8px gutter of `rgb(207,207,207)` (dark: `17`) — a colour that appears nowhere else in the window. The content pane and the outline pane run flush to x=0…1100 and y=0…800 with no gutter at all. So one third of the window floats and two thirds don't, and the floating third is framed in a shade the rest of the app never uses. On a real macOS window that card's rounded corner also nests 8px inside the window's own corner radius, which will read as concentric-radius mismatch at the top-left — exactly where the traffic lights land.
>
> **The find-in-page bar is not a find bar.** There's no next/previous, no Done. The `✕` is a hairline stroke glyph with a lot of dead space before it, not the filled grey ⓧ; `2 of 3` hangs outside the field in open space, attached to nothing. The field has no bar behind it and no separator, so it floats orphaned in the text column with the paragraph starting ~8px below it. Its corner radius also doesn't match the sidebar's "Find a note…" field — two search fields, two radii. And the focus ring is a hard 2px purple stroke rather than the system accent.
>
> **Focus is ambiguous, because two things are purple.** The find field has a purple ring and the outline row "Section 7" has a purple fill. In macOS the unfocused list would drop to grey. Worse, the two modes use different idioms for that row: a pale lavender tint with dark text in light, a fully saturated `#4B0F9E` slab with white text in dark. Dark mode shouts louder than light, which is backwards.
>
> **The disabled forward chevron is effectively invisible.** `rgb(212,212,212)` on `241` — about 1.2:1. In dark, `46` on `24`. It's a smudge, not a disabled control; you can't tell there's a forward button there at all. Meanwhile the back chevron at `122` is fine, so the disabled tier is the bug, not the enabled one.
>
> **"122 lines" reads as part of the note.** It sits at x=272, same left edge as the body text, ~14px below "it is read in." — a *smaller* gap than between paragraphs — in secondary grey, with no bar, no rule, and no bottom padding before the window edge at y=800. It looks like the document has a stray last line.
>
> **Nothing in the sidebar shares a left edge.** The search field starts at x=17, the footer actions at x=25, the tree labels at x=45. Three margins in a 240px column. "Rescan" and "Switch Vault" are set in the same weight and the same colour as "Sources" and "Principles" — they read as two more file names, not as buttons. The tree's indent step is only ~13px, so the disclosure chevron for "notes" sits directly under the "D" of "Design"; a child's chevron in the parent's text column makes the hierarchy hard to scan. And nothing in the tree is selected even though a note is open.
>
> **Two smaller platform tells.** The sidebar-toggle icon is parked at the sidebar's *right* edge (x≈228) — on macOS it is always at the toolbar's left, beside the traffic lights — and it has no hit-target chrome at ~20px. And the hairlines don't agree: in light the sidebar's border is `186` while the content/outline seam is `212`; in dark that ordering inverts (`54` vs `46`). Cross-pane content insets are 36 / 23 / 14 px, so the three columns don't breathe alike either.

## What was measured against the reply

**The two search fields wear the same corner.** Both fields are forty
points tall and both turn their top-left corner over exactly three rows:
the rail's leading edge stands at x 18, 17, 16 on rows 52, 53, 54, and
the page's at x 274, 273, 272 on rows 88, 89, 90 — the same curve, in
both schemes. What differs is the focus ring: the page's field is the
focused one, and a two-point stroke around a corner reads as a different
corner. "Two search fields, two radii" does not hold.

**The thumb's grey does not follow the scheme.** It does: the note's
thumb is `rgb(137,137,137)` on the light page and `rgb(135,135,135)` on
the dark one, and the outline pane's is `rgb(129,129,129)` light against
`rgb(135,135,135)` dark. Two of the three numbers the reviewer read are
exact and the reading stands — one grey for both schemes, and two greys
for two bars in one window.

**The fills on the bar are the two the query marks with.** The sampled
`#E7D700` and `#C6B900` in the light scheme, `#4E4800` and `#746E30` in
the dark, are exactly the document's plain and current match fills, three
rows tall and six columns wide. The reviewer's own numbers make the
point better than the eye did: the current match differs from the rest by
a step it cannot see.

**Nothing in the tree was selected.** True, and it was the picture's
fault rather than the window's: the note the goldens open was not in the
index the fixture built, so the rail could not show it.

## What was changed

Two things, both cheap and both inside the task:

1. **The note the goldens open is now in the vault's index**, so the rail
   shows it and marks it open. The window in the stored image is now a
   window somebody could be looking at.
2. **The count moved in against the field.** It stood a page gap (16dp)
   away, which is what made it read as "attached to nothing"; it now
   stands the rail's own field pad (8dp) from the control it belongs to.

Everything else the reply raises is either a ruling this task may not
make, a surface another task owns, or answered below.

## What is answered rather than changed

**"There's no next/previous, no Done."** The Language's Search field
entry says what this control is: a looking glass, the text, the clear
mark, and — finding within a page — how many matches there are, which is
current, and stepping with Enter and Shift+Enter. Buttons for the two
steps and a third for dismissal are three controls the entry does not
name, and the task's own instruction is to draw those parts and nothing
beyond them. Escape dismisses, and the clear mark empties.

**"The field floats with no bar behind it, and the paragraph starts
right under it."** The note page puts no gap above the document by
design: the viewport begins on the lower edge of whatever row stands over
it — the breadcrumb, the properties panel, and now the find field — so a
line scrolling out of the top is cut by that edge rather than by a strip
of bare page. The find field is that row while it is open, and it keeps
the rule the rows above it keep.

**"The sidebar floats and the other two panes do not."** The floating
pane is Phase BT's, ruled and measured against the platform's own
sidebars; it is not this task's to unpick.

## What is left for the pool

1. **A match painted across the thumb reads as a broken thumb.** Second
   reviewer, second reading, and this one arrived at it from a whole
   window rather than a specimen: "a thumb rendered in segments, or a
   repaint that lost three rows". Already pooled from BW2.2 (338); this
   is corroboration, and the strongest single complaint in the reply.
2. **The current match cannot be told from the others.** Third reading of
   the same thing — pooled from BW2.1 for the prose and BW2.2 (336) for
   the bar. What this review adds is that the counter makes it worse: a
   field saying "2 of 3" promises a match the eye then cannot find.
3. **The scrollbar's thumb wears one grey in both schemes, and two
   different greys in one window.** Measured above. Not pooled anywhere
   yet, and it belongs to `components/scrollbar` rather than to any app.
4. **The match's own box is the glyph run's box**: square corners, no
   horizontal padding, and taller below the baseline than above the cap.
   `markdown` paints the fill on the line box; whether a mark should be
   padded and rounded is a ruling for the highlight, and it would move
   every document's goldens.
5. **Two purples in one window.** The focused field's ring and the
   outline's selected row are the same accent, and the reviewer read the
   pair as ambiguous focus; the dark scheme's selected row is also the
   more pronounced of the two schemes.
6. **The disabled history control reads at about 1.2:1.** The step is
   deliberate and carries its own measured note in the code, but a
   control nobody can see is worth a second look.
7. **The status bar's line count reads as a last line of the note** — same
   left edge as the prose, a smaller gap than the paragraph rhythm, no
   rule and no bottom padding.
8. **The rail's three left edges** (field 17, footer 25, rows 45), its
   13px indent step, and its foot actions reading as two more file names.
9. **The window's hairlines disagree** between the pane's border and the
   content seam, and the three columns keep three different content
   insets.
