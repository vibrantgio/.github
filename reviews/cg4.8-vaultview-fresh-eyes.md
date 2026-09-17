---
date: 2026-09-17
task: CG4.8
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG4.8 — vaultview's rail search field read cold beside System Settings' sidebar

One reviewer, having seen neither the plan nor the packet nor any source, was
given vaultview's rail at 1x in both appearances — the leading 240 px of the
stored window golden, its full height down to 420 px — beside the sidebar of
`system-settings-grouped-box-light.png` and
`system-settings-grouped-box-dark.png`, cropped from the window's rim to the
seam. One question: does this rail's search field read as the platform's
sidebar search field, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam; still
captures show no fade or cursor; alpha composites in sRGB; the window controls
of the reviewed rail are harness stand-ins.

The renders it read were taken after the chrome variant landed and before
anything below was acted on: the field drawn as the measured recess —
`#e8e8e8` light and `#2f3234` dark, 28 px tall, no edge, ends fully rounded,
inset 10 px from each of the rail's edges.

## The reply, verbatim

> I measured both images pixel-by-pixel rather than eyeballing. Geometry is
> identical between our light and dark shots, so the findings below hold for
> both appearances unless marked.
>
> ## Verdict
>
> Yes — at a glance it reads as the platform's sidebar search field. The
> capsule outline, the height and the fill are right. What's wrong is
> entirely *inside* the capsule: the magnifier and the placeholder are drawn
> at a larger size and heavier weight than the platform's, and they sit too
> far in from the left end with too much air between them.
>
> ## What matches (measured, don't touch these)
>
> - **Height**: ours 28 px (y 62–89), platform 28 px (y 53–80). Exact.
> - **Corner**: not a pill — both reach full width at the 10th row and hold
>   it for 10 rows. The per-row inset falloff is 18, 14, 10, 8, 6, 4, 4, 2,
>   2, 0 px on both. Corner radius matches within a pixel.
> - **Fill**: light 232,232,232 vs the platform's 232,232,231; dark 47,50,52
>   vs 47,50,52 — exact. Flat on both, no gradient, no inner shadow.
> - **Stroke**: neither field has a border. Ours goes rail→fill in one step,
>   same as the platform.
> - **Placeholder colour**: peak ink 116,116,116 in light on both; in dark
>   ours 161,163,163 vs the platform's ~152–158. Within a couple of levels —
>   the colour is right.
> - **Alignment with the rows below**: our field spans x 10–229, and the
>   selected-row pill ("Reading list") spans x 10–229. They line up exactly.
>   The field's inset from the rail edge is 10 px left / 9 px right against
>   the platform's 8 px — a pixel or two, not a defect.
>
> ## What's wrong
>
> **1. The magnifier is too big and far too heavy.** Ours occupies 16×16 px
> (circle 12 px across, y 68–83); the platform's occupies 14×13 px (circle 11
> px, y 61–73). Worse than the size is the stroke: ours is a solid 2 px ring
> — in the pixel dump the circle's sides read as two fully-dark columns —
> where the platform's is ~1 px with one antialiased neighbour. Ours is
> roughly double the stroke weight. The handle compounds it: ours runs 5 px
> at 2 px thick, the platform's ~3 px at ~1.5 px. Net effect: our glyph reads
> as a bold icon, the platform's as a hairline. This is the single most
> visible difference, and it is the one thing that gives our field away in
> both appearances.
>
> **2. The magnifier sits too far from the left end.** Glyph left edge is 14
> px in from the field's left edge; the platform's is 9 px. Five pixels too
> deep.
>
> **3. Too much air between the glyph and the placeholder.** Clear space is
> 11 px in ours, 6 px on the platform.
>
> Items 2 and 3 plus the oversized glyph stack up: our placeholder text
> starts **41 px** into the field where the platform's starts **29 px**. The
> whole leading cluster is 12 px wider than it should be, which is what makes
> our field look emptier and less compact than the platform's.
>
> **4. The placeholder type is ~20% too large.** Cap height 12 px (the 'F'
> spans y 69–80) against the platform's 10 px (the 'S' spans y 62–71);
> x-height 9 px against 7 px. The weight is comparable — it is purely a size
> difference. Our placeholder looks like roughly 15–16 pt where the platform
> is at ~13 pt.
>
> **5. The magnifier's circle is 2 px above the optical centre.** Ours:
> circle y 68–79, centre 73.5, against a field centre of 75.5. The platform
> centres the *circle* (y 61–71, centre 66.0, field centre 66.5) and lets the
> handle hang below the centreline. We appear to be centring the glyph's full
> bounding box instead, which lifts the circle. Minor, but it is why our
> glyph sits slightly high.
>
> Placeholder text vertical position is fine — ours is 1 px high of centre,
> the platform's is dead centre.
>
> **6. Dark only — the fill's tint has no source in our rail.** The field
> fill 47,50,52 is blue-tinted (b−r = +5). On the platform that tint belongs:
> its sidebar is 28,33,36 (b−r = +8), so field and rail share a hue. Our rail
> is 28,28,28, dead neutral. So we have taken the platform's tinted fill and
> dropped it on an untinted rail, and the field reads faintly cool against
> it. Either the rail should carry the tint or the fill should be neutralised
> to match the rail.
>
> ## Two things I saw but am not calling defects
>
> - **Wording**: ours says "Find a note…", the platform says "Search". The
>   ellipsis is not a macOS placeholder convention for a search field, but
>   the wording looks like a product choice rather than a fidelity slip —
>   flagging it only so it is a deliberate decision.
> - **Vertical offset in the rail**: our field top is 62 px from the
>   capture's top edge, the platform's 53 px. But the gap from the toolbar
>   control's bottom to the field top is 29 px in *both* — our whole toolbar
>   band sits ~8 px lower, and since our window controls are harness
>   stand-ins, that offset is probably the harness, not the field.
>
> I could not check the gap between the field's bottom and the first row
> against the platform: the platform crop has the "Software Update Available"
> banner in that position, not a normal row, so there is nothing comparable
> to measure against.

## What was done with it

The verdict and the five "what matches" rows are the task's result confirmed
from outside: the height, the corner, both fills, the absence of a stroke and
the placeholder's colour are each what the measurement asked for, read back
off the drawn pixels by someone who did not know what they were meant to be.
The dark placeholder's 161,163,163 against the capture's 152–158 is the
vibrancy shortfall the reference records under "What the sidebar search field
measures": the untinted Voice Memos capture reads the platform's own coverage
to the byte and ours reproduces it.

Nothing below was fixed inside this task, and each is filed:

- **1, 5** — the glyph's weight, its size and where its circle sits are the
  icon set's asset and the density's icon size, neither of which is a fill or
  a metric this task measured, and both reach every mark in the library.
  Filed as one item.
- **2, 3** — the leading cluster. The stored captures give three different
  leading insets for three search fields — 9 px in this sidebar, 10 px in
  Mail's toolbar, 13 px in Voice Memos' capsule — and the library draws one
  horizontal padding for every field in it. Moving that token on one capture
  is over-fitting; filed with all three readings.
- **4** — the placeholder's size is BodyLarge's, and typography is not this
  phase's to move; the same finding stands in `controls.md` against the
  label's cap band. Filed.
- **6** — the dark recess is a tinted reading over a tinted sidebar, as
  `CardFill`'s dark value is, and our chrome is the untinted material. It is
  recorded in `controls.md` as what one capture would close, and filed as the
  ruling between neutralising the fill and capturing an untinted one.

The wording and the toolbar band's 8 px are not defects of this field and
were not filed.
