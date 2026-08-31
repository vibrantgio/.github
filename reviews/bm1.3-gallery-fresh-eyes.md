---
date: 2026-08-31
task: BM1.3
phase: BM
reviewer-model: opus-5
reviewer-effort: unrecorded
---

# BM1.3 fresh-eyes review — the badge's tinted container

Two headless captures: the gallery's Everything column at 1000×760, scrolled
so the badge section sits mid-frame, in light and in dark. The reviewer was a
fresh agent that had not seen the task packet, briefed on the recorded
non-issues and on the pooled set (167–174, 177/178/179, 182), told to look
hardest at the new container anatomy — seams, padding, radius, identity
against the chip and against prose, and the close mark's three states — and
asked one question: what would a developer on this platform complain about.
It was given Bash and told to sample pixels before making any colour claim,
which it did throughout.

Verbatim reply, then triage.

## Verbatim reply

> ## What a developer on this platform would complain about
>
> ### 1. The container is tuned against exactly one background, and collapses on the other two storeys (dark)
>
> This is the big one. The Chip section directly above the Badge section is explicitly captioned "rest, hover, press and focus, **on three storeys**" and demos paper / card / dialog. Badge is only ever shown on the paper. Sampled surfaces and fills:
>
> | dark surface | RGB |
> |---|---|
> | paper | (24,24,24) |
> | card | (34,34,34) |
> | dialog | (46,46,46) |
>
> | dark badge fill | RGB | vs paper | vs card | vs dialog |
> |---|---|---|---|---|
> | Neutral | (46,46,46) | 1.31 | 1.17 | **1.00** |
> | Success | (24,52,28) | 1.31 | 1.17 | **1.00** |
> | Warning | (69,39,19) | 1.31 | 1.18 | **1.00** |
> | Error | (72,36,33) | 1.31 | 1.17 | **1.00** |
> | Info | (24,48,73) | 1.32 | 1.18 | **1.01** |
>
> Every dark fill sits at the same luminance as the dialog surface, so all five roles lose *all* luminance separation there, and Neutral is byte-identical to it — (46,46,46) on (46,46,46). Put a Neutral badge in a dialog in dark and the container the task just added is literally not drawn. The four coloured roles survive on hue alone, which is what a deuteranope or a bad panel loses first. The fills read as a fixed offset from the paper token rather than being composed against the local surface; the dialog storey happens to land on that offset.
>
> Light does not have this problem — light fills are darker than every storey, so separation goes 1.37 → 1.39 → 1.43 as you go up. (Distinct from the pooled "dark Neutral has less separation than light", which is a within-paper comparison.)
>
> ### 2. The close-mark surface is the badge's trailing padding, not a button
>
> Measured in light, dismissible row y418–433:
>
> - Badge fill (186,216,248); hover slab (157,186,217) at x315–332; press slab (128,156,186) at x394–411. Both slabs are **18w × 16h**, full badge height, flush to the badge's right edge, square left seam, rounded right corners inherited from the badge. Corner handling is clean — no bleed, symmetric AA.
> - The ✕ glyph is **8×8** at x317–324 (hover) and x396–403 (press). So inside the 18px slab there is **2px to the left of the glyph and 8px to the right** — the mark sits 3px left of the slab's centre.
>
> The glyph itself does not move between states (rest ✕ at x237–244, 8px from the badge edge; hover ✕ 8px from the badge edge), so there's no jump — good. But because the slab was sized to reach the badge's trailing edge rather than to be a target centred on the glyph, it renders as "the right third of the badge went darker" rather than "the close button lit up". The 9x crop makes this unmistakable.
>
> Two follow-ons a developer would raise immediately:
> - The visible target is 18×16px, under the WCAG 2.2 2.5.8 minimum of 24×24, for a *destructive* action. Nothing in the capture suggests a larger invisible hit area.
> - At rest there is no slab at all, so the dismiss affordance has zero boundary — "Filtered by owner ✕" reads as label plus decorative glyph until you hover it.
>
> ### 3. No focus state, no disabled state, for the only new interactive control
>
> Chip demos Rest/Hover/Press/**Focus**. Text field demos Rest/**Focused**/**Disabled**. Checkbox and radio demo **Focused** and **Disabled**. The dismissible badge's close mark demos Rest/Hover/Press and stops. It is the only interactive control on this page with neither a focus nor a disabled state — a keyboard user has no way to see where they are. (This is the *absence* of the state, not the pooled focus-ring geometry note.)
>
> ### 4. The close-mark ramp is a raw sRGB nudge, and it doesn't match the chip's ramp
>
> Light: rest (186,216,248) → hover (157,186,217) → press (128,156,186). The deltas are exactly −29,−30,−31 then −58,−60,−62 — a per-channel subtraction applied twice, not a token lookup. Dark goes the other way at +26,+27,+28.
>
> Compared against the chip on the same page (sampled at y=93/95, clear of the label):
>
> | | hover Δ | press Δ |
> |---|---|---|
> | Chip, light | 1.15 | 1.40 |
> | Chip, dark | 1.14 | 1.40 |
> | Badge close mark, light | **1.36** | **1.93** |
> | Badge close mark, dark | **1.50** | **5.05** |
>
> The chip's ramp is scheme-symmetric to two decimals. The badge's is neither symmetric nor the same magnitude. A developer wiring up a third component has no way to tell which of these is "the" hover token. (The dark press leg specifically is pooled; the mismatch against the chip's ramp, and the light leg, are not.)
>
> A raw per-channel subtraction also won't survive contact with the roles the gallery doesn't exercise — the dismissible only ever appears in Info. Subtracting 58/60/62 from the Warning fill (231,210,172) lands on (173,150,110), a far larger perceptual step than the same subtraction on Info.
>
> ### 5. Smaller things
>
> - **The glyph-only utterance has no container.** The check at x268–281, y391–400 sits on bare page (246,246,246 / 24,24,24) with ink (0,107,36) / (119,227,135). Word and count get the Success container; the glyph gets nothing. If `Badge` with an icon payload silently drops the container, a glyph-only Error badge loses its role tint entirely — the exact failure the container was added to prevent.
> - **Light ink is pinned at the AA floor with zero headroom.** Every light role's text-on-fill lands at 4.51–4.56:1 (Neutral 4.51, Success 4.54, Warning 4.53, Error 4.54, Info 4.56) — visibly generated to hit 4.5. Dark sits at 8.40–8.48. Any future darkening of a light fill, or a user contrast preference, drops light below AA on the first move.
>
> ### What's fine
>
> Don't touch these: geometry is byte-identical between the two schemes (every badge x-extent matches). All nine badges are 16px tall on a 30px row pitch with exactly 20px gaps. The corner radius is ~3px, symmetric top-to-bottom, with clean 3px AA and no artifacts. Badge ink baselines align with the row-label baselines (369, 399, 429). And a badge is in no danger of being confused with a chip — 16px vs ~34px tall, 3px radius vs pill, tinted fill vs bordered surface with a chevron.

## Triage

### 1 — the dark container collapsing on card and dialog: REBUTTED, but the gap it found was real and is FIXED

The defect does not exist. The reviewer measured the fills the gallery
happened to draw — all of them at the paper storey, because that was the only
storey the section showed — and then compared those same fills against the
card and dialog surfaces on the assumption that the fill is fixed. It is not:
the fill is derived against the storey the badge is placed on, which is the
whole reason the ground-aware member of the container family was added rather
than the fixed-depth one. Measured, dark scheme, Neutral:

    ground              fill        seam
    level-0  #181818    #2e2e2e     1.308:1
    level-1  #222222    #474747     1.712:1
    level-2  #2e2e2e    #474747     1.462:1

The reviewer's 1.00:1 is exactly the collision the walk exists to step over —
it is the number the FIXED container would have landed on, quoted in the
derivation's own doc comment as its reason for existing. The gate over the
seed sweep (ten seeds, both derivations, both schemes, five roles, five
storeys) measures worst 1.299:1 and loudest 1.718:1; nothing in the population
lands under the floor.

But the reviewer could not have known that from the page, and that is a real
finding. The chip section shows three storeys because its colour model is
relative; the badge's now is too, and the section was still showing one
ground. FIXED in this task: the badge section's vocabulary row became three
storey panels — paper, card, dialog — exactly as the chip's does, so the fill
lifting with the ground is visible rather than asserted. The anatomy rows
(utterances, dismissible) stay on the page, because what they ask a reader to
judge is the same question on every ground.

### 2 — the close slab is a trailing cap, not a centred button

Two claims, one rebutted and one recorded.

REBUTTED: "the visible target is 18×16, under WCAG 2.5.8's 24×24, and nothing
suggests a larger invisible hit area." The registered pointer target is 24 dp
square, centred on the mark and free to overhang the badge on every side — a
capture cannot show it, and the live tests assert a click 12 dp outside the
drawn mark dismisses. 2.5.8 governs the target, not the mark drawn in it.

RECORDED, pool it: the slab's asymmetry is real and measured correctly — 2 px
of fill left of the glyph and 8 px right, because the cap runs from the middle
of the gap that separates the mark from the label out to the badge's own edge
and corner. It cannot be centred on the mark without the geometry it has: the
right gap is the S2 side padding, so a centred cap would start 8 px left of
the mark and slide under the label's last glyph. The choice is between an
off-centre cap and a cap that overlaps the word, and the current answer was
the deliberate one — but "the right third went darker" rather than "the button
lit up" is a fair reading of it and deserves a ruling. Not forced here.

RECORDED, pool it: "at rest the dismiss affordance has zero boundary." True
and by construction — the close mark is ruled an affordance on a piece of text
rather than a control, so at rest it is the ✕ and nothing else. Whether that
survives contact with a destructive action is a ruling, not a fix.

### 3 — no focus and no disabled state on the close mark

RECORDED, pool it. Correct observation, and it is a standing decision rather
than an omission: the package doc rules that a badge has no keyboard path and
no focus ring, because a badge that took focus would be one more stop between
the reader and the controls that do something. The reviewer's consequence is
the sharp end of that ruling — a keyboard user cannot dismiss a badge at all
— and it is worth re-opening as a question rather than leaving it as a
comment. Out of scope for this task.

### 4 — the state ramp

PARTLY REBUTTED. It is not a raw per-channel subtraction; it is the pinned
state walk, which ladders the fill on the neutral ramp at the fill's own hue
and chroma. Even per-channel deltas are what a walk on an evenly-spaced
neutral ramp looks like, which is why it reads as arithmetic. The reviewer's
worry that it "won't survive contact with the roles the gallery doesn't
exercise" is answered by the seed sweep: the mark re-derives against the
walked fill, and the worst pairing over all five roles, five storeys, both
schemes, both derivations and ten seeds measures 4.20:1 against a 3.0 floor.

RECORDED, pool it: the magnitude mismatch against the chip is real and is new.
Chip hover 1.15 / press 1.40, scheme-symmetric to two decimals; the badge's
cap 1.36 / 1.93 light and 1.50 / 5.05 dark. The dark press leg is the pooled
dark-ramp item. The light leg and the asymmetry against the chip are not, and
"which of these is the hover token" is a fair question about the system rather
than about this component.

### 5a — the glyph badge has no container

REBUTTED as a defect: it is the owner's ruling — the invariant is that hue is
never the badge's only channel, not that every badge wears a container, and a glyph
carries its meaning in its shape.

But the reviewer's sub-point is the sharpest thing in the review and it was
NOT covered: the package cannot enforce that. Props.Glyph is a painter this
code cannot inspect, so two glyph badges drawn with ONE sign in two variants
are two hues and nothing else — the exact collapse the fill exists to prevent,
reintroduced above the component. FIXED in this task, as far as it can be:
the obligation is now stated in the package doc and on the derivation — a set
of glyph badges owes distinct shapes, and a set that cannot have them owes
words instead.

### 5b — the light foreground pinned at the AA floor, dark at 8.4

RECORDED, pool it. The numbers are right and match the package's own gate:
worst foreground on the fill over the whole seed sweep is 4.50:1 against a 4.5
floor.
It is the derivation working as specified — the nearest rung to the ramp's
mid-value that clears the floor, which in light is the rung that just clears
it — but a light scheme sitting on the floor while dark sits at 8.4 is a real
asymmetry with no headroom for a contrast preference. Same family as the
pooled scheme-inversion item; worth its own entry.

## Pooled items this round resolves

- **176, hue-only channel.** Resolved. Every worded and counted badge now
  draws a second channel: a container fill separated from its storey by at
  least
  1.25:1 (measured worst over the sweep 1.299:1, loudest 1.718:1).
- **180, invisible close region.** Resolved for the region; the cap's
  asymmetry and the rest state's absence of a boundary are recorded above as
  new entries.
- **181, light Neutral identical to prose.** Resolved by the fill rather than
  by the foreground. The light Neutral foreground is still #5c5c5c, the same
  rung a caption
  reads in — that is the derivation's correct answer for that ground — but it
  is now set on a #d4d4d4 field at 1.372:1 against the level-0 page, so the
  badge is a badge and not a run of prose.
- **179, dark close ramp.** Untouched, stays with the dark-ramp phase; the
  reviewer's 5.05 dark press leg is the same measurement.

## New entries for the pool

1. The close cap is off-centre on its mark by 3 px and cannot be centred
   without overlapping the label; ruling wanted on cap versus centred target.
2. At rest a dismissible badge has no boundary around its close mark.
3. The close mark has no focus and no disabled state, so a keyboard user
   cannot dismiss a badge; the no-focus ruling deserves re-opening.
4. The badge's state walk is a different magnitude from the chip's and is not
   scheme-symmetric where the chip's is (light 1.36/1.93 vs 1.15/1.40).
5. The light foreground on the fill sits on the 4.5:1 AA floor (4.50–4.56)
   while dark
   sits at 8.40–8.48: no headroom in light for a contrast preference.
