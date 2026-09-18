---
date: 2026-09-18
task: CG5.7
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.7 — the icon set's marks read cold beside the platform's own symbols

One reviewer, having seen neither the plan nor the packet nor any source, was
given the whole set at 24 px on the chrome fill in both schemes, as this task
redrew it, beside three crops of the platform at 1x: Finder's own light
toolbar band (`finder-window-light.png`, x 318–1000 of the band), Voice Memos'
dark one (`voicememos-window.png`, x 0–320) and Voice Memos' sidebar
(`voicememos-multi-folder-2026-09-18.png`). It was told which strips are the
platform's and in what order our fourteen marks stand. It was given the
recorded misreads — a dark label reads grey at 1x; a still shows no fade and
no cursor; a coverage composites in encoded sRGB; a mark's band is replicated
as the capture shows it, split across two pixels, by ruling. It was asked one
question, with no checklist: "Do these marks read as the platform's symbols at
the same size, and what is wrong with them?"

## The reply, verbatim

> I have everything I need from the pixels. Here is the review.
>
> ---
>
> **No — about half of the set reads as the platform's symbols and half does
> not, and the failures are systematic rather than one-off. Ink colour and
> layout are exact; geometry and stroke weight are not.**
>
> I measured every mark in `iconrow-light.png` (identical geometry in the dark
> strip) against the Finder and Voice Memos bands in `review-sheet.png` and the
> Voice Memos sidebar crop. Stroke widths below are alpha-integrated coverage
> across a cut perpendicular to the stroke, so 1.35 px means one full-ink pixel
> plus a 35% neighbour.
>
> **1. The three large chevrons are the loudest mismatch — disclosure,
> history-back, history-forward.** Ours measure 12 × 20 px. Finder's own
> back/forward chevrons, sitting in the strip directly below, measure **7 × 14
> px**. That is 71% wider and 43% taller. The aspect is wrong too: Finder's arm
> runs 3.5 across for 7 down (a 53° included angle); ours runs 6 across for 10
> down (62°), so ours is about 9° blunter as well as bigger. Side by side at
> 10× the difference is not subtle — ours looks like a chevron from a list row
> blown up into a toolbar, Finder's is a narrow tick. Our stroke there is 2.13
> px perpendicular, the heaviest in the whole set.
>
> **2. `folder` and `open-folder` are the same mark.** I diffed them pixel by
> pixel. Frame, tab, width, height, halo values are *identical*; the only
> difference in the entire glyph is that the second full-width interior rule
> sits at y=23 in `folder` and y=24 in `open-folder` — a one-pixel vertical
> shift. At 24 px nobody can tell them apart, and I couldn't either until I
> diffed the arrays. Two affordances that must be distinguishable collapse into
> one symbol. Voice Memos solves this the obvious way: its sidebar folder has a
> real stepped tab and a distinct silhouette.
>
> **3. Stroke weight varies by 85% inside our own set, where the platform holds
> one weight.** Measured perpendicular widths:
>
> - small chevron, chevron-pair — **1.15 px**
> - document, folder, open-folder, plus — **1.35 px**
> - sidebar — **1.44 px**
> - clear (X) — **1.77 px**
> - check — ~**1.9 px**
> - search ring, refresh ring — **1.99 px**
> - disclosure, history-back, history-forward — **2.13 px**
>
> Finder's comparable strokes, drawn in the same active ink on white, cluster
> tightly: magnifier ring 1.51, grid-icon cell edge 1.34, grid top rule 1.30,
> pop-up chevron 1.44. So the platform lives in a 1.3–1.5 band and we straddle
> it in both directions. The visible consequence in the light strip: the X, the
> check, the magnifier, the refresh and the three big chevrons read black,
> while the document, folder, open-folder, plus and sidebar read grey — in the
> same row, at the same size, in the same colour. That is a weight defect, not
> the 1× grey-label misread; I verified it by integrating alpha, not by eye.
>
> **4. The folder's construction is wrong, independent of the duplicate
> problem.** Ours is a closed 20 × 14 rectangle whose top edge runs straight
> across at y=20, with a 7 px-wide tab parked on top occupying y=18–19 — and
> because that top edge passes *underneath* the tab, the tab rises exactly **1
> px** proud of the body, with its own top row at only 35% ink. At 1× it reads
> as a grey smudge, not a tab. Then the body carries **two** full-width rules
> (y=20 and y=23) with a 35% grey row at y=21 and 16% rows at y=22 and y=24
> between and below them, so the top third of the folder is a grey band
> spanning edge to edge. The result reads as a drawer front or a card with a
> header bar. Voice Memos' folder (sidebar crop, the TriNova row) instead has:
> a tab integrated into the outline that rises **2 px** and steps down into the
> top edge, rounded corners, and a **single inset** lid rule running x=11..27
> inside a frame at x=8..29 — inset roughly 3 px each side, never flush. Ours
> is flush to both frame edges, which is what kills the folder reading.
>
> **5. Everything is drawn to a 20 px envelope where the platform's toolbar
> symbols sit in 16–18 px.** Finder's measured glyphs: magnifier 16 × 17, share
> 14 × 18, tag 17 × 17, grid 18 × 17, list 15 × 12, nav chevron 7 × 14. Ours:
> clear 20 × 20, plus 20 × 20, search 20 × 20, refresh 18 × 20, document 14 ×
> 18 core, folder 20 × 16, sidebar 20 × 16. So we are roughly 15–25% over
> across the board. The magnifier is the cleanest single comparison because
> both are active dark ink: our ring is **16 px across with a 1.99 px stroke
> and a 6 px tail** (20 × 20 overall); Finder's is **14 px across, 1.51 px
> stroke, 5 px tail** (16 × 17 overall). Ours carries about 50% more ink on the
> ring — roughly 100 px² against 66 px². That is why it reads as a chunky
> circle rather than a lens.
>
> **6. The refresh arrowhead has only one barb.** The head is not a triangle.
> It is the arc's own end thickened across x=5..13 for two rows, with a 2 px
> nub sticking up at x=9..10 and nothing at all on the underside — the lower
> edge just merges into the ring. At 1× it reads as a lump on top of a circle
> rather than an arrow. The head also only extends about 2 px beyond the ring's
> stroke, so there is no silhouette change to carry the "clockwise" meaning.
>
> **7. The magnifier's handle tapers and its join blobs.** Ours starts 2 px
> wide where it leaves the ring and ends 1 px at the tip, and the first handle
> pixels overlap the ring's bottom-right arc so the join thickens into a corner
> blob (row 16 of the mark: `.########++#+`). Finder's handle is uniform for
> its full 5 px and meets the circle cleanly — its rows 89–92 show a clean
> two-pixel diagonal with no thickening at the junction.
>
> **8. Minor, and I flag it as a question rather than a defect because there is
> no platform document symbol in these captures to check against.** Our
> `document` draws the folded corner with the flap's right angle *inside* the
> page at bottom-left — a vertical stroke at x=244–245 running y=18..23 (45%
> across the page body) plus a horizontal at y=23–24, with the crease as the
> hypotenuse. Geometrically that is a correct folded-back flap, but the fold is
> **7 px wide on a 14 px page** — half the page width — and the tall internal
> vertical stroke is the most prominent thing in the glyph after the outline.
> Worth checking against `doc` at the same size before shipping; I can't settle
> it from these pixels.
>
> **9. Trivial.** The check is 18 × 13, the shortest mark in the set —
> everything else is 16–20 tall — so it sits noticeably smaller than its
> neighbour the X (20 × 20) despite sharing a centre line. And our light chrome
> fill is 247 against the Finder band's 255, though that Finder window's band
> looks untinted, so I would not read anything into 8 levels.
>
> **What is right, and worth saying so:**
>
> - **Ink values match the platform exactly.** Light: ours 77 on 247; Finder's
>   active glyphs 77. Dark: ours peaks at 233 on a 28 ground; Voice Memos'
>   sidebar glyph peaks at **233 on a 30 ground**. Identical.
> - **The small chevron and the chevron-pair are very close.** Ours 8 × 5 and 8
>   × 11; Finder's pop-up chevron is 7 × 4 and its sort chevron pair is 7 × 11
>   (5 up, 1 gap, 5 down — the same construction as ours). Only the stroke is
>   light, at 1.15 px against Finder's 1.44.
> - **The sidebar mark is the best mark in the set.** Ours 20 × 16 against
>   Voice Memos' 18 × 16; divider at 29% of the width against their 27%; three
>   ticks at 21% / 36% / 54% of the interior height against their 21% / 40% /
>   57%. The uneven tick brightness in ours (peaks 0.81, 0.69, 0.46 alpha)
>   looks wrong at first but the platform glyph shows the same pattern (0.64,
>   0.44, 0.69) from fractional positioning — I nearly filed it and it is not a
>   defect.
> - **Layout is clean.** Pitch is exactly 44 px across all fourteen marks, and
>   every vertical centre lands at 25.0–25.5 in a 52 px strip. Nothing is
>   misaligned.
>
> **If I had to fix three things in order:** shrink the three large chevrons to
> roughly 7 × 14 and narrow the angle; give `open-folder` a genuinely different
> silhouette from `folder` and rebuild both around a 2 px stepped tab with a
> single inset rule; then pull the whole set onto one stroke weight near 1.4 px
> and one 16–18 px envelope.

## What was done with it

Its three ranked findings were the three acted on, and two more with them.

**1, the three large chevrons — FIXED.** The packet listed `disclosure`,
`history-back` and `history-forward` among the marks no capture holds. One
does: `finder-window-light.png`'s back/forward pair. Measured at 1x, the back
chevron covers x 340–347 and the forward one x 376–383, both y 19–32 — **8 px
across by 14 down** in a control 36 px tall, with a band of **1.53 px**
perpendicular (row y=30 covers 0.60 + 1.00 + 0.71 = 2.33 columns against a 254
fill and a 191 foreground, and 2.33 × sin 41.2° = 1.53). Both are drawn in
`disabledControlText`, Finder standing at the top of its history, which fixes
the geometry and not the colour. All three marks were redrawn to that 8 by 14:
one centre line from 9,6 to 15,12 to 9,18 and its mirror, two arms at 45
degrees with every corner on the 1.5 sub-grid, round caps of one unit carrying
the figure to the capture's extent. The set now draws ONE chevron pointed three
ways. The reviewer's angle reading is a misread of the arm — an 8-wide,
14-tall chevron pointing sideways puts each arm across the whole width and half
the height, and taking the band off the extent gives a centre line of 6.47 by
12.47, which is 43.9 degrees and not 53.

**2 and 4, the two folders — FIXED in the part the captures settle.** The
folder mark's own capture insets its lid rule about 1.2 px at each end of a 20
px body, and CG5.7's first draft dropped that as "a rounded cap the set does
not draw at this weight". It is not a cap, it is the inset, and it is the one
thing that tells this mark from the open-folder one: `folder`'s rule now runs
5.25 to 18.75 inside an inner pane of 4 to 20, where `open-folder`'s runs the
full inner width its own capture reads it at. What is NOT fixed is the larger
half of the finding, and it is pooled: both stored captures hold a CLOSED
folder — Voice Memos' sidebar row and Mail's folder pull-down — so no capture
in the reference says what an OPEN folder looks like, and the name is already
on the ruling sheet.

**7, the magnifier's join — FIXED.** The handle's near corners stood 5.59 units
from the lens's centre against an inner radius of 6, so the band crossed into
the lens's own hole, which the non-zero winding rule fills solid. A corner of a
2-unit band whose centre line stands d out lies √(d²+1) from the centre, so
d = √35 = 5.916 puts both corners exactly on the inner edge. The taper the
reviewer read is the antialiasing of a uniform 2-unit band and not a taper: the
handle is a parallelogram of constant width.

**3 and 5, the weights and the envelope — POOLED, 662 and 663.** The spread is
the set's diagonal compensation working as designed — this backend composites
in linear light, where a 45-degree band at 1.5 units arrives at 67 per cent of
the colour, which is why the diagonal measure is 2 — and the 20-unit allowance
a round or curved form takes was not what the ruling moved. What is left on it
after the chevrons took their capture is `search`, `clear`, `check` and
`refresh`. Both readings are recorded with their misses in the files and in
`controls.md`.

**6, the refresh arrowhead — POOLED, 670.** `refresh` has no capture anywhere
in the reference and is drawn to the grid alone; there is nothing to correct
the head against, and the capture that would is on the reference's list.

**8, the document's fold — MEASURED, no change.** The fold is the capture's:
`finder-window-untinted-dark.png`'s Documents row cuts its corner six columns
against seven rows on a 13 px page, which is the 6 of 13 this mark draws. The
one thing that did move is the fold's upright, from the capture's 6 units in to
5: it is the only band in the figure that can land a whole device pixel at all
three sizes, and a figure whose every band misses reads grey at 16 dp.

**9, the check's size — POOLED, 671.** `check` is NOT MEASURED. No stored
capture holds a checkmark at all.

**The "20 px envelope" reading is half the keyline's own price and is recorded
as 665.** The measured keyline is 19 units centred in a 24-unit box, which puts
a square form at 2.5 and 21.5 — twenty device columns touched at 24 dp with the
outer two half lit, where the platform's 19 px tag covers nineteen columns
whole.

**The light chrome fill at 247 is not the band.** The strip was drawn on
`SidebarMaterial`, the sidebar's own fill, because the set's marks stand on
chrome generally; Finder's toolbar band in that window is the content's white.
Correctly not filed.
