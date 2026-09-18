---
date: 2026-09-18
task: CG5.10
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.10 — one measured band and one measured round allowance, read cold

One reviewer, having seen neither the plan nor the packet nor any source, was
given the gallery's whole icon row in both schemes at 1x — every mark at 16,
20 and 24 dp, one device pixel per dp (`icons-{light,dark}.png`) — beside two
crops of the platform at 1x: Finder's own light toolbar band
(`finder-window-light.png`, x 300–1000 of the band, which carries the history
chevrons, the list pop-up, the grid pull-down, the share glyph, the tag, the
ellipsis and the magnifier) and Voice Memos' window with its sidebar toggle
(`voicememos-window.png`, x 0–320). It was told it could write a program to
read the pixels, and that measuring beats eyeballing.

It was given the recorded misreads — a dark label reads grey at 1x; a still
shows no fade and no cursor; alpha composites in sRGB in the platform's
captures and in linear light in this library's renders, so a stored byte is
not the share of a pixel a band covered; a mark's band is replicated as the
capture shows it, split across two pixels, by ruling; and `refresh` and
`check` have no stored capture at all, so nothing settles their proportions
yet. It was asked one question, with no checklist: "Do these marks read as the
platform's symbols at the same size, and what is wrong with them?"

## The reply, verbatim

> I have the measurements. Here is the review.
>
> ---
>
> ## Do they read as the platform's symbols at the same size?
>
> **At 24 dp, yes — to within a few percent, mark for mark.** Below 24 dp they
> stop being the platform's symbols, and the reason is one decision applied
> globally.
>
> Method note: I linearised the two library sheets before reading coverage (ink
> 39 on 255 light, 221 on 30 dark) and read the two macOS captures as sRGB-byte
> alpha (ink 77 on 255 in Finder, 233 on 39 in the Voice Memos button), per the
> recorded rule.
>
> ### What is right
>
> **Light and dark are the same drawing.** Integrated ink per mark per size
> agrees between the two sheets to better than 0.1% on all 42 cells (e.g.
> `folder` 24 dp: 112.15 light vs 112.04 dark). No appearance-dependent
> geometry drift.
>
> **Every mark scales exactly.** Threshold-free ink-weighted σx/σy ratios across
> 16→20→24 dp are 1.25 / 1.20 / 1.50 for all 14 marks, max deviation 3% (only
> `chevron`'s σy wobbles, 1.34 then 1.13, but lands at 1.51). Bounding-box
> centres coincide within 0.5 px; all three columns centre on x = 163.5 / 219.5
> / 275.5.
>
> **The 24 dp column really is the platform's toolbar size and shape.** Three
> independent like-for-like comparisons:
>
> - `sidebar` 24 dp vs the Voice Memos toggle: box 17.7 × 13.7 px centreline vs
>   **17.4 × 13.6**; stroke 1.40 vs **1.39** (I cut all four walls of the
>   platform box — 1.392, 1.391, 1.392, 1.402); divider at 35.1% of the width
>   vs **33.6%**; and the faint list lines inside the pane are drawn at a
>   lighter secondary weight in both — 0.89 px in the library, **0.93 px** on
>   the platform. That last detail is not an accident.
> - `search` 24 dp vs Finder's magnifier: ring centreline diameter 11.49 vs
>   **11.44**, handle tip 13.3 px from the ring centre vs **13.33**.
> - `history-back` / `history-forward` / `disclosure` 24 dp vs Finder's
>   back/forward chevron: arm slope 1.048 dx/dy vs **1.035**, depth 6.28 vs
>   **5.98**, half-height 6.0 vs **5.75** (library 4% larger).
>
> **The set correctly carries two different chevrons.** `disclosure`/`history-*`
> have depth/half-width 1.05 — a ~92° chevron, matching Finder's back/forward.
> `chevron`/`chevron-pair` have 0.77 — a squat one, matching Finder's
> pop-up/pull-down indicator, which I measured at **0.69** (8 × 5 px footprint
> at x492–499 and x426–433). `chevron` looking dramatically smaller than
> `disclosure` in the sheet is therefore correct, not a bug.
>
> ### Defects, ranked
>
> **1. Stroke weight is tied to the mark's dp; on the platform it is not.** The
> library's stroke is exactly dp/17.07 — I measured 0.937 / 1.173 / 1.404 px off
> `plus`'s bars and confirmed the same numbers on `sidebar`'s walls. macOS holds
> its stroke nearly flat across a 4× range of glyph footprint: Finder's
> list-popup bars **1.354** (13 × 12 glyph), the Voice Memos box **1.391**
> (19 × 16), the magnifier ring at its equator **1.475** (17 × 17), and the
> pop-up chevron **1.54** slope-corrected (an 8 × 5 glyph — smaller than any
> library mark at 16 dp, yet the heaviest stroke in the capture). Four platform
> glyphs, footprints 5 px to 19 px, stroke spread 14%.
>
> So 24 dp lands dead centre of that band, but 16 dp lays down **34% less ink
> per unit of stroke length than anything macOS draws at 1x**. This is an
> integrated-coverage claim, not a pixel-alignment one — it survives wherever
> the stroke happens to land. The visible consequence at 16 dp: the
> diagonal-built marks never reach their own ink colour anywhere. `check`
> bottoms out at sRGB **132** on white (peak α 0.79), `chevron` at 114,
> `chevron-pair` at 106, `disclosure`/`history-*` at 101, while `plus`,
> `folder`, `open-folder` and `refresh` in the same column all reach 39. That is
> a 3.4× spread in darkest pixel inside one row of icons, and the platform does
> not have it — its 8 × 5 pop-up chevron reaches full ink (77) at three separate
> pixels.
>
> **2. `chevron-pair` closes into a diamond at 16 and 20 dp.** Per-row ink
> through the waist where the two chevrons' tips meet: 16 dp **0.79**, 20 dp
> **0.47**, 24 dp **0.00**, against arm rows of 2.38 / 2.99 / 3.58. Finder's own
> up/down pair (x426–433, y21–31, also an 11-row glyph) has an exact **0.00**
> row at y26. The library reproduces that separation only at 24 dp; at 16 dp the
> outer edge is continuously inked (0.1 / 0.2 / 0.3 down columns 0) and the mark
> reads as ◇, not as up-and-down.
>
> **3. `folder`'s flap line never separates from its top edge, at any size.**
> Column profile through the body: 24 dp **1.00 / 0.39 / 0.40 / 1.00**, 20 dp
> 1.00 / 0.16 / 0.84 / 0.33, 16 dp 0.92 / 0.28 / 0.66 — the gap row is never
> empty, so it renders as one 3–4 row fuzzy band rather than two lines. Its
> sibling `open-folder` uses twice the gap and holds a true zero at all three
> sizes (24 dp 1.00 / 0.39 / **0.00** / 0.40 / 1.00; 16 dp 0.92 / **0.00** /
> 0.61 / 0.33). The two marks are therefore drawn to different internal specs,
> and the closed/open pair converges as it shrinks: at 16 dp they differ by only
> **14.7%** of the folder's ink, versus 27.8% at 24 dp. At 16 dp I cannot
> reliably tell them apart.
>
> **4. `clear` and `plus` are given an identical box, so the X out-weighs the
> +.** Both measure 13.06 / 14.83 / 18.60 px centreline at 16 / 20 / 24 dp — the
> same square. Because the X runs its arms down the diagonal, it carries **34%
> more ink** than the plus at every size (68.9 vs 51.4 at 24 dp; 30.7 vs 22.9 at
> 16 dp). This is an optical-sizing judgement, not a measurement against the
> platform — Finder's band has neither an X nor a plus — so treat it as lower
> confidence than 1–3.
>
> **5. `refresh` (low, and not a platform judgement).** It has no stored
> capture, so I make no claim about its proportions. But it is the only mark in
> the set whose aspect changes with size: bounding box 10 × 10 / 12 × 12 /
> **14 × 16**, because the arrowhead spur only clears the ring at 24 dp. At
> 16 dp the head is a 6 × 2 smear and the mark reads as a broken ring with a
> smudge rather than as an arrow.
>
> `check` is excluded from proportion judgements for the same reason; it appears
> above only as the extreme case of defect 1, which is a weight measurement.
>
> ### Bottom line
>
> The vector work is faithful — at 24 dp these are the macOS symbols, including
> details as fine as the sidebar pane's secondary stroke weight and the fact
> that the pop-up chevron is a different chevron from the back chevron. What is
> wrong is that the stroke was made a function of the mark's size. Hold it near
> 1.4 px instead of dp/17, and defects 1 and 2 go with it; defect 3 needs
> `folder`'s flap gap widened to `open-folder`'s.

## What was done with each finding

**The three confirmations are this task's own result read back off the
images, by a reviewer that was given neither number.** The band: the reviewer
measured the platform at 1.354, 1.391, 1.475 and 1.54 across four glyphs and
put this set's 24 dp "dead centre of that band" — which is the reading 1.4 was
chosen from, arrived at independently. The round and curved allowance: the
magnifier's ring centreline diameter reads 11.49 against the platform's 11.44
and the handle's tip 13.3 against 13.33, which is the 13-unit allowance to a
twentieth of a pixel. And the second band reads 0.89 against the platform's
0.93.

**1, stroke weight tied to dp — POOLED (677), not fixed here.** The task rules
one measured band stated in units at 24 dp, and that is what is drawn; holding
1.4 PX at every size is a different rule and a new ruling. The reviewer's
numbers are the strongest evidence yet for it and they are recorded: 16 dp
lays 34 per cent less ink per unit of stroke length than anything the platform
draws at 1x, and the darkest pixel inside one row spans 3.4×. `components/icons`
already records what each mark reaches at each size, and the icons test pins
those readings mark by mark, so nothing here is quiet.

**2, the chevron pair closing into a diamond at 16 and 20 dp — NOT a defect in
what the library draws; the sheet question is POOLED (678).** The chevron pair
and the single chevron are control's marks and the library spends them at 24 dp
and nowhere else: `components/internal/control`'s `DrawMark` draws into a 24 dp
box and is the only caller. Their files say so and the icons test reads them at
that size alone. The gallery's sheet shows every mark at all three sizes
because it is one sheet, which is what put the pair at 16 dp in front of the
reviewer. Whether the sheet should show a control's mark at the one size it is
drawn at is the pooled question.

**3, the folder's flap gap — POOLED (679), not fixed here.** The gap is
measured, not chosen: `voicememos-multi-folder-2026-09-18.png` holds the flap
1.24 px clear of the body's inner top face over a mean band of 1.42, which is
0.87 of a band and 1.22 units against the set's 1.4 — under two device pixels
at 24 dp, so no row can be clear. `open-folder`'s 2.09 units is its own
capture's relation (`mail-window.png`: a 1.34 px edge, 2.00 px of air), and the
two marks read two different folders because the platform draws two different
folders. Widening the closed folder's gap to the open one's would replace a
measurement with a copy; what the reviewer found is the same root cause as 1,
and 679 records it with both readings.

**4, the X out-weighing the plus — POOLED (680).** The reviewer flags it as
lower confidence itself, and it is the unmeasured diagonal allowance: `clear`
takes 20 units where `plus` takes the measured 19-unit keyline, so the X's arms
are longer and carry more ink for the same band. The capture that would settle
the diagonal allowance is what 680 asks for.

**5, the refresh mark's head — POOLED (681).** No capture settles this mark and
425 already carries the request for one (Safari's reload symbol); 681 adds what
the reviewer measured, so the capture round knows what to look for: the
arrowhead clears the ring only at 24 dp and the figure's own aspect moves with
the size.
