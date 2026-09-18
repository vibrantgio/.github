---
date: 2026-09-18
task: CG5.3o
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3o — vaultview's band read cold beside Finder's

One reviewer, having seen neither the plan nor the packet nor any source, was
given seven images at 1x: vaultview's whole window in both schemes with the
find shut and both again with it open
(`workbench/vaultview/testdata/golden/window-{light,dark}.png` and
`window-find-{light,dark}.png`, the goldens this task regenerated) and three
macOS 26 captures — `finder-window-light.png`,
`finder-window-untinted-dark.png` and `mail-find-light.png`. It was told which
three are the platform's, given the recorded misreads — a dark label reads
grey at 1x; a still shows no fade and no cursor; a coverage composites in
encoded sRGB; the window control buttons are harness stand-ins and the light
render draws none; a pointer target is invisible in a still; the sidebar panel
and its rows are other rounds' work; the trailing column is out of scope by
the owner's word; an open menu is CG5.4's and focus CG5.5's; the toolbar
title's weight is settled by a typography ruling — and asked one question:

> Does this window read as a macOS window with its toolbar, and what is wrong
> with it?

## The reply, verbatim

## Does it read as a macOS window with its toolbar?

Yes — at a glance, convincingly, and in dark mode almost exactly. The bones are right, and several of the numbers are right to the pixel. What goes wrong is that the toolbar isn't treated as one band: it is assembled out of the three columns underneath it, and that shows in the light render as a seam through a button, a button that vanishes into its own background, and a shadow that leaks out of the toolbar into the content.

### What is right (measured against the Finder captures)

**The toolbar's geometry is correct.** In `finder-window-light.png` the traffic lights occupy y 19–32, the chevrons y 19–32, the title "Applications" y 19–33 — every toolbar item centred on y ≈ 25.5–26, and the content (column-header row) begins at y ≈ 52. In `window-light.png` the title "Reading list" sits at y 19–32 (centre 25.5), the sidebar toggle glyph y 19–32, and the content/outline divider at x = 780 starts exactly at y = 52 (light 225 on 255/247; dark 52 on 30/28). Same 52 px band, same centreline.

**Button sizing matches.** Our icon buttons are 38 × 36 px (refresh fill x 764–801, magnifier x 1054–1091; all y 8–43). Finder's search button is 37 px wide at y = 26, and Finder dark's search field spans y 46–81, i.e. 36 px tall starting 8 px below the window top (window top y = 38). Trailing inset is 8 px in both (our magnifier ends at 1091, window edge 1099; Finder's search circle ends at 991, window edge 999). The find field is 220 × 36 (x 872–1091) against Finder dark's 222 × 36 — that is a very close copy.

**Dark mode's button material is essentially exact.** Our dark button fill is 38 on a 30 ground with a 63-level rim at y = 8 and y = 43. Finder dark's search field is fill 38 on a 30 ground with a 64 rim at y 46 and y 81. Identical numbers.

**The disabled forward chevron is right.** Ours reads 192 at its core; Finder's disabled back/forward chevrons read 190–191. That level of fidelity on a secondary state is worth saying out loud.

### What is wrong

**1. The toolbar ground is three colours, and one button straddles the seam.** The band has no material of its own — each column's fill runs up to y = 0. At y = 0 in the light render, x 776 = 255 and x 780 = 245→247; in dark, x 779 = 30 and x 780 = 28. So the toolbar steps from the document white to the outline grey at x = 780 with no line, no shadow and no corner, and the hairline that *does* mark that seam only starts at y = 52. The refresh button spans x 764–801 — 16 px of it sits on 255 and 22 px on 247. Its left half has no edge at all and its right half does. In Finder the equivalent seam (the inset sidebar's right edge at x ≈ 317) carries a real edge and shadow all the way up through the toolbar, and every toolbar item sits on one continuous ground.

**2. In light, two of the buttons are invisible except for their shadow.** Refresh and folder are filled `(255,255,255)` on a `(255,255,255)` ground — zero fill contrast. The magnifier, 250 px to their right, is the same 255 fill on 247 and reads as a proper capsule. Finder gives its capsules 255 against a toolbar ground of ~250 everywhere, so all of them read alike. Here the same control renders two different ways in one band.

**3. The light-mode elevation shadow is about twice macOS's and spills out of the toolbar.** Below the folder button at x = 836 ours reads 238 from y 44 through y 53 — a flat 9-level plateau — then ramps back to 247 only at y = 75. Finder below its share capsule at x = 880 reads 244 at y 44 and is back to 250 by y 59: 6 levels over 16 px, smoothly, from the first row. Ours also spreads *upward* (242 at y 6–7, still 245 at y = 0, where it is clipped by the window top), so it reads as a halo rather than a drop shadow. The practical consequence is visible in the crop: a grey smudge crosses the toolbar's own bottom edge at y = 52, runs past the point where the column divider begins, and reaches the "Outline" heading at y = 72. Meanwhile the dark render's shadow is 27 against a 28 ground — effectively nothing. The two themes disagree about whether these buttons are raised at all.

**4. Toolbar content is drawn at the extremes rather than at a platform label tone.** Finder light draws the title *and every enabled toolbar glyph* at exactly `(77,77,77)` — 132 pixels sit at 77 in "Applications", and the ellipsis, both view segments, the grid icon and the magnifier all bottom out at 77. Its list rows use 39 and its sidebar labels 25, so macOS deliberately puts toolbar content *below* body strength. Ours inverts that: the title core is `(0,0,0)` (45 pixels at 0) and the glyphs are `(39,39,39)`. APCA Lc 106 and 102 against the white ground, where macOS is Lc 89. Pure black isn't a macOS label colour at all — our own sidebar items use 38 (#262626, the 85 % black macOS actually uses), so the window contradicts itself. Dark has the same shape of error on the title: ours is `(255,255,255)` (Lc −106) where Finder dark's title and glyphs are 232/233 (Lc −91). The glyphs in dark, at 222, are fine. This is tone, not weight, so the typography ruling doesn't cover it.

**5. The find field's elevation flips sign between themes.** Light: fill 232 inside a 247 ground — recessed 15 levels. Dark: fill 54 inside a 28 ground — raised 26 levels. Finder dark's search field is 38 on 30 — raised 8. So the light field goes the wrong way, and both are roughly three times macOS's step. Worse, within a single band the icon buttons and the field don't agree: dark is 38 vs 54, and light is 255 vs 232 — opposite sides of the same ground. (The blue ring at (124,175,246)/(27,98,141) I've left alone as focus work.)

**6. The sidebar toggle is the only toolbar control without a capsule.** Its glyph occupies x 219–236, y 19–32, flat on 247 (dark 28); sampling x = 227 from y 0 to 51 shows nothing but ground. The other five controls all carry the 38 × 36 capsule.

**7. The trailing items don't read as one group.** There are 199 px of empty toolbar between the folder button's right edge (855) and the magnifier's left edge (1054), because refresh and folder are anchored to the document column's trailing edge and search to the window's. Finder keeps its trailing cluster together: the share/tag/ellipsis capsule ends at 928 and the search circle starts at 955 — a 26 px gap. Ours reads as two unrelated clusters, which is the same root cause as defect 1.

**8. Square window corners.** Finder's opaque region starts at x = 27 on row 0 and reaches x = 3 by row 15 — a radius of roughly 24 px. Our render is a flat rectangle to all four corners (dark `(30,30,30)` at 0,0 and `(28,28,28)` at 1099,0). I flag this only lightly, since the window frame appears to be harness territory alongside the control buttons.

One thing I checked and won't call a defect: the back/forward capsule starts 25 px in from the content column's left edge (247 → 272) where Finder's starts 8 px in (318 → 326), but 272 is exactly the document's text margin — the breadcrumb and body paragraphs both start at x = 272 — so that looks deliberate and it reads well.

## What was done with it

**The task's own result is read back cold and confirmed.** The reviewer,
measuring the images rather than being told anything, returned the band at 52
with every item centred on 25.5; the bordered control at 38 × 36 standing
y 8–43; the last control 8 clear of the window's trailing edge; the find
recess at 220 × 36 "against Finder dark's 222 × 36 — that is a very close
copy"; the dark control's fill at 38 on a 30 band with a 63-level rim against
Finder's 38 on 30 with a 64 rim, "identical numbers"; and the switched-off
forward segment at 192 against Finder's disabled chevrons at 190–191. It also
answered the leading inset on its own: the pair standing 25 in from the
content column's edge where Finder's stands 8 "looks deliberate and it reads
well", because 272 is the column's own text margin and the trail below it
starts there too.

**Finding 2 is a measured misread and is answered.** The reviewer read
Finder's light band as "~250 everywhere" and ours as 255 under the note
column, and called our two action controls invisible. Read again by this task
at 1x, `finder-window-light.png` reads **255** at every one of y 2, 5, 12, 25,
40 and 50 at x 600, 620, 640 and 660 — columns clear of every control — and
its view pop-up's own fill at x 700–720, y=25 reads 255 as well. The 249–253
the reviewer sampled is the drop shadow those same capsules cast, not a
material. Finder's light toolbar control IS white on white, told from its band
by its shadow alone, which is the reading `controls.md` already carries and
the one `toolbarface` draws. Nothing was changed.

**Findings 5 and 6 are recorded answers.** The recess standing darker than its
band light and lighter dark is measured and recorded — `controls.md`, "the
direction does not survive the scheme, so the fill is a colour and not a
coverage over what it stands on" — and the two fills in one band come from two
applications measured side by side, neither correcting the other, which the
same section records. The control with no capsule is the sidebar panel's own
toggle standing in the panel's strip and not in the band at all; CG5.3n ruled
it bare, because the platform's own sidebar panel draws its marks bare. Both
were out of scope by the brief and neither was acted on.

**Finding 8 is the harness.** The window's corners belong to the window
server; a stored render draws the application's own plane, which is a
rectangle. The reviewer flagged it lightly for that reason and was right to.

**Findings 1 and 7 are one real consequence of this task and are filed, not
fixed.** Reserving the find's open width in the band — which is what makes the
recess grow from a fixed trailing end with no control walking — moved the two
vault actions 182 px leftward, off the trailing column and onto the boundary
between the note and the inspector. The reviewer measured both halves of it:
the refresh control at x 764–801 standing 16 columns on one fill and 22 on the
other, and 199 px of bare band between the vault switch and the magnifier. Two
rulings meet here — the band carries no fill of its own, and no control walks
when the find opens — and where the actions then stand is unmeasured in every
stored capture. Filed as 631 and 633.

**Findings 3 and 4 are outside this task and are filed.** The toolbar
control's shadow plateauing where the platform's ramps from its first row is
the shadow model's recorded shape limit, already filed at 622 for the sidebar
panel and now read on a toolbar control too: filed as 636 with the reviewer's
numbers. The toolbar's own label tone — Finder drawing its title AND its
glyphs at `#4d4d4d` where ours draw at black and 39 — is a colour the platform
set has no name for; filed as 632.

**Two findings of this task's own measurement are filed with them.** The light
segmented control's seam misses the name the library draws it with by twelve
of 255 (634), and no stored capture holds a search field reporting a count, so
where the count stands is composed from two measured insets rather than
measured itself (635).
