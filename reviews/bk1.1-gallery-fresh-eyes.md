---
date: 2026-08-31
task: BK1.1
phase: BK
reviewer-model: opus-5
reviewer-effort: unrecorded
---

# BK1.1 fresh-eyes review — the tooltip and popover specimens become controls

The gallery's Patterns page, rendered headless at the real page width of 900
px in both schemes, cropped to the run that holds the Modal, Popover, Tooltip
and Hero cells, plus nearest-neighbour zooms of the popover anchor and beak at
6× and the tooltip at 5×. The reviewer was a fresh agent that had not seen the
task packet. It was briefed on the recorded non-issues and on the pooled set
(167–174, 177/178, 183–187, 188–194), told that both cells had just had their
anchor and trigger swapped from a grey pill wearing the role's own name to a
Ghost icon-only button carrying the platform's show-the-sidebar mark, and
asked one question: what would a developer on this platform complain about. It
was additionally required to answer the prior review's acceptance — whether the
popover's beak apex now seats on the control — in pixels. It had Bash and
sampled pixels throughout.

Verbatim reply, then triage.

## Verbatim reply

> ## The beak question, first
>
> **Yes — it seats, cleanly and exactly.** Light and dark are pixel-identical in geometry.
>
> The anchor is a 36 × 36 rounded square at **x 166–201, y 2936–2971** (centre 183.5, 2953.5). The beak's apex row is **y 2972**, its two darkest pixels at **x 183–184** — dead on the button's horizontal centre, and one row below the button's last row. It actually overlaps: at y 2971 the button's fill is 232 everywhere except x 183–184, which read 215 (light) / 81 (dark), i.e. the tip bleeds into the anchor's bottom edge. From there it widens to a 14 px base at y 2979, where the panel's top border (197 light / 114 dark) breaks correctly around it. Zero gap, zero horizontal drift, no daylight. The old complaint — apex y 552 against a text baseline at 547 — is fully answered: the apex now lands on a control rect, not on lettering. Nothing about the join itself is worth reopening.
>
> What follows is everything else.
>
> ## The two cells are the emptiest things on the page, and they don't line up with it
>
> I measured content bounding boxes for all 16 cells on the Patterns page. Fourteen of them pad top and bottom symmetrically (20/20, or 47/47 and 44/47 for the Hero-class cells) and start their content at **x 18–48**, flush with the section-header text at x 24. The Popover and Tooltip cells are the only two that break both rules:
>
> - Popover: content at **x 101–267, padT 97, padB 26**
> - Tooltip: content at **x 134–234, padT 22, padB 50**
>
> So the Popover specimen is indented **77 px** past the page's left rule and the Tooltip **110 px** — and, because their floating surfaces are different widths, they don't even align with *each other*: their visible left edges rag by 33 px in two stacked cells. The one thing that does align is the two anchors (both centred on x 183.5/184), and that alignment is invisible because both anchors are the faintest object in their cell. A developer scrolling this page sees a clean left rule running the whole way down, then two cells where the content drifts right by different amounts.
>
> The vertical numbers come from the same cause: both cells centre the **anchor** in the cell (popover button centre 2953.5 = cell centre 2953.5 exactly; tooltip button centre 3168.5 = cell centre 3168.5 exactly) and let the floating layer hang off one side. That leaves **97 px of dead air above the popover anchor** — 4.9× the page's 20 px standard — while the panel crowds to within 26 px of the "Tooltip" band below it. The Tooltip cell does the mirror image: 22 above, 50 below. Net ink: the Popover cell is 900 × 230 = 207,000 px² carrying a 167 × 107 specimen (**8.6 %**); the Tooltip cell is 5.3 %. The Modal cell directly above uses x 24–875, the full band. Three consecutive cells about floating layers, and two of them are 91–95 % blank in a lopsided way.
>
> ## The beak seats on a control that is optically not there
>
> Geometrically fine, but the hovered Ghost ground is **232 on 246** (light) and **34 on 24** (dark) — **1.13 : 1** and **1.12 : 1**. That is under the 3 : 1 non-text minimum by a factor of three, so the 36 × 36 rect the beak now sits on is a luminance step of 14/255. Worse in light: the anchor is **darker than the page** (−14) while the popover panel is **lighter** (+9), so the thing you clicked reads as a recess and the thing it spawned reads as a lift, by comparable magnitudes and in opposite directions. In dark both go up but at 10 vs 47, so the panel dominates and the anchor nearly disappears. The beak is now aimed at a *control-shaped* nothing rather than a *word-shaped* nothing — real progress, but a developer will still ask why the anchor is invisible.
>
> ## The mark itself doesn't survive 1x
>
> The sidebar glyph is **16 × 14 px inside a 36 × 36 button** (44 % coverage; perfectly centred, no complaint there). At that size its strokes fall apart unevenly: the horizontal frame rules land on the pixel grid and render at **19** (near black), while the vertical rules straddle a boundary and split across two columns at **171 / 125**. Against the 232 ground that is a delta of 213 horizontally versus 61 vertically — the same 1 px stroke reading **3.5× heavier top-and-bottom than left-and-right**. You can see it in the 6× crop: the mark looks like a box with black rules above and below and grey wire down the sides.
>
> The interior is worse. The three rail ticks occupy x 179–181 and render as values 197/155/177, 212/185/200, 224/210/219, 182/113/152 — a grey smear, not three lines, and the light/dark scans don't even smear the same way (dark gives four filled rows, a gap, two rows, a gap). At 1x the mark is an unreadable little box. If this is the platform's "show the sidebar" control, it needs to be recognisable in the gallery at the size the gallery actually renders it.
>
> ## The copy fights the picture
>
> The popover body says "A popover holds content **beside** what opened it." It is drawn **below** what opened it — beak pointing straight up, panel hanging under the anchor. The Tooltip caption ("shown above its trigger") matches its render exactly; the Popover's does not. Fix one or the other.
>
> Second copy problem, sharper now that both cells share a control: the Tooltip cell is coherent — a sidebar button, and a tooltip that says what it does. The Popover cell is not — the same sidebar button opens a panel of meta-prose about what popovers are. A developer reading the two cells side by side sees one specimen that behaves like the product and one that behaves like documentation.
>
> And the tooltip label is `Show the sidebar`. The platform's own string for this control is "Show Sidebar" — title case, no article. Sentence-cased prose in a tooltip is a house style choice, but it isn't the platform's, and this is the one cell that quotes a platform control verbatim.
>
> ## State: both cells draw the identical hover
>
> I diffed the two 36 × 36 anchor rects: **2 differing pixels in light, 3 in dark** — and those are the beak tip bleeding into the bottom row. They are the same state. That's correct for the Tooltip (tooltips appear on hover) and wrong for the Popover: a popover opens on press, and an anchor with its popover *open* is normally in an active/selected state, not hover. As drawn, the Popover cell shows an open panel above a merely-hovered trigger, which tells a developer nothing about which token to use for "anchor while open" — and quietly implies popovers open on hover.
>
> ## Smaller things, measured
>
> - **Three radii in two adjacent cells.** Tooltip corner ≈ **2 px** (at y 3123 the corner goes 207 → 80 → 19 in two columns; effectively a hard rectangle), the icon button ≈ **5–6 px**, the popover panel ≈ **7–8 px**. Stacked 5 px apart vertically, the boxy tooltip and the rounded button read as parts from different kits.
> - **The beak is drawn heavier than the panel it belongs to.** Panel border is a flat 197; the beak's diagonals run 133–168 and its tip 121. Diagonal antialiasing explains it, but the visible result is a tail that looks thicker-stroked than its own panel.
> - **No shadow on anything.** Scanning outward from the panel (y 3043+ and x &lt; 101) gives pure 246/24 — a 1 px hairline is the only elevation cue, and in light the fill lift is +9. The beak is therefore carrying essentially 100 % of the "this floats" signal, on 84 px² of ink.
> - **Inconsistent staging versus the Modal cell above.** That cell paints its own desktop ground (180 light / 14 dark) so its dialog has something to float over. Popover and Tooltip float on the bare gallery ground, so there's no way to judge whether a +9 lift survives over real app content.
> - **Possible elevation inversion in dark.** Dialog surface 46 on its 14 ground (+32); popover surface **71** on its 24 ground (+47). The popover lifts further and sits lighter than the modal directly above it — visible in the dark crop as the popover body being the brighter slab of the two.
> - **Different anchor offsets.** Tooltip sits 4 px above its trigger; the popover panel sits 8 px below (0 counting the beak tip). Two floating layers, two spacings.

## Triage

**The acceptance is met.** The beak apex is at y 2972 on a control rect of
y 2936–2971, x 166–201, centred at x 183–184 against the button's centre of
183.5 — one row below the button's last row, with the tip bleeding into that
last row. Zero gap, zero drift, both schemes identical in geometry. The prior
review's apex-552-against-baseline-547 complaint is answered: the beak lands
on a control, not on lettering.

**Fixed here.** The copy contradiction. The popover body read "beside what
opened it" while the specimen is drawn below its anchor; it now reads "below
what opened it", and the cell says what it shows. Goldens regenerated.

**Considered and kept.** The tooltip's sentence case. "Show the sidebar" is
the house voice every other string in the gallery is written in — the hero's
"Try a seed", the modal's "Discard this theme?" — and the reviewer grants it
is a style choice. A specimen that switches register to quote one platform's
capitalisation would be the odd string on the page, not the correct one.

**Pooled — not this task.**

1. *The two cells are the emptiest on the page, and their content rags left.*
   The dead air and the indent are the placement contract's, not the
   specimen's: the pattern centres the anchor across the canvas it is handed
   and hangs the surface off one side, and the canvas is capped at 320 px
   inside a 900 px band. The ratio is unchanged from the pill the cells used
   to hold — 74 px of air above the old anchor in a 170 px slot, 77 px above
   the new one in a 190 px slot. Making the run flush with the page's left
   rule means either an alignment other than centre, or a canvas the width of
   the band, in both cells. A composition decision.

2. *The hovered Ghost ground is 1.13 : 1.* This is the button register's own
   hover treatment, drawn from the state overlay, and it is what every ghost
   affordance in the system wears — modal's close mark included. Raising it is
   a token change with reach far past two gallery cells. Adjacent to the
   pooled state-walk-magnitude item but distinct: that one is about the walk,
   this is about the ghost register's floor.

3. *The sidebar mark does not survive 1x.* Stroke weights split unevenly
   across the pixel grid and the three rail ticks smear. This is the mark's
   own drawing at 20 px, reachable from any icon button at Comfortable
   density; it is not a property of these two cells.

4. *The popover anchor is drawn hovered rather than active.* Correct
   observation, and there is no state to draw instead: the render state
   carries rest, hover, focus, press and disabled, and nothing for "the
   surface I opened is still up". Press would depict the instant of the click
   rather than the standing condition, and would also break the phase's own
   requirement that both cells show the same control. Wanting an
   anchor-while-open treatment is a request for a new state, and a ruling.

5. *Three radii within two stacked cells* (tooltip ≈2, button ≈5–6, panel
   ≈7–8). Token-scale question across three packages.

6. *The beak reads heavier than the panel border* (diagonals 133–168, tip 121,
   border a flat 197). Diagonal antialiasing against an axis-aligned hairline;
   a fix belongs in the pattern's tail geometry.

7. *Both cells float over the bare gallery ground* while the modal above them
   paints its own desktop ground, so a +9 lift cannot be judged against real
   content. A staging change in two cells, worth doing with the modal's own
   staging in view rather than piecemeal.

8. *Two different anchor gaps* — 4 px above the tooltip's trigger, 8 px below
   the popover's anchor. Both are spacing-scale steps chosen inside their own
   package; reconciling them is a cross-pattern call.

**Rebutted.**

- *No shadow on the popover.* Deliberate and documented: the popover is an
  unscrimmed, shadowless transient overlay whose fill plus its 1 dp stroke are
  its only separation cues. The beak carrying the float signal is the design,
  not a gap in it.

- *Dark elevation inversion — the popover lighter than the modal.* Also
  deliberate. The popover takes the deepest rung of the ladder precisely
  because it has neither a scrim nor a shadow to separate it; the dialog, which
  has a scrim, sits one rung shallower. Measuring the popover as the brighter
  slab in dark is measuring the ladder working.

- *The popover cell shows meta-prose while the tooltip shows product copy.*
  The gallery is the system's own textbook; a popover in it holds a sentence
  about popovers for the same reason the alert cell holds a sentence about
  alerts. The tooltip differs because a tooltip's whole content is the name of
  the control under it, which here is the control's real name.
