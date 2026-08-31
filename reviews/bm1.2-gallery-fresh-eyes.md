---
date: 2026-08-31
task: BM1.2
phase: BM
reviewer-model: opus-5
reviewer-effort: unrecorded
---

# BM1.2 fresh-eyes review — the converted surfaces

Eight headless captures: the gallery strip's hero/pricing band and its
popover/tooltip band at 900×800, both schemes; the sitedocs window's
patterns tab at 1180×760, both schemes; and mindchat's settings modal at
1024×768 with a passing key check in light and a failing one in dark. The
reviewer was a fresh agent that had not seen the task packet, briefed on
the recorded non-issues and on the pooled set (167–173 plus the badge's own
176–180), told to judge the CONVERTED surfaces rather than the badge's
anatomy, and asked one question: what would a developer on this platform
complain about. Verbatim reply, then triage.

## Verbatim reply

> I read all eight renders at 1:1 and measured the pixels behind every claim below.
>
> **The badge has no identity in light mode.** Every converted surface renders its text at exactly `#5C5C5C` in light and `#9E9E9E` in dark — the eyebrow, "Popular", "Anchor", "Trigger", "Footer", all identical. That's fine for contrast (6.30:1 on the card in light, 5.94:1 in dark — matched, AA-clean). The problem is what sits next to it. In light mode the hero subtitle, "per month", "forever", and the feature-grid body text all measure `#5C5C5C` too — byte-identical to the badge. In dark mode the same secondary text measures `#CCCCCC` (9.91:1 on card) against the badge's `#9E9E9E` (5.94:1). So in dark the badge is a deliberate step quieter than the prose around it, and in light it is indistinguishable from any caption on the page. A developer who writes a badge and looks at it in light mode has written a `<span>`. The component's visual contract changes depending on the colour scheme, which is the one thing a theming system is supposed to prevent.
>
> **"Popular" is where that costs real money.** It's the only badge in these renders carrying product meaning, and it now reads as the weakest text on the card — the same grey as "per month" directly below it, sitting quietly in the corner. The middle tier's "highlighted" status rests entirely on a 2px border (`#723AD4` light, `#D0C4FF` dark). It's also 3px off: "Popular"'s baseline lands at y≈607 against "Studio" at y≈610. When it was a pill, centring the box on the title row was correct; as bare text on the same line, centring instead of baseline-aligning just looks like a layout bug, and at this size it's visible.
>
> **"Anchor" and "Trigger" stopped being widgets and became captions.** In the popover demo the beak's apex is at y=552 and the label's baseline at y=547 — four pixels of air, and the beak now points at a grey word with no edges, so it terminates in whitespace. The word reads as a title over the panel rather than the thing the panel hangs off. "Trigger" is worse: a bare grey word centred under a black tooltip is a figure caption, and the section header says "shown above its trigger", so the demo now contradicts its own label. These gallery scaffolding labels were doing real explanatory work as chips — they looked like stand-in controls. They don't any more.
>
> **The API-key status is the part I'd actually file a bug on.** Three separate things. First, the failing field in image 08 is untouched: border `#9E9E9E`, fill `#474747` — byte-identical to the healthy provider-name field above it. Nothing about the input that is wrong looks wrong. Second, the only readable explanation, "401 invalid_api_key", sits 61px below the field's bottom edge with an unrelated "Web search tool" checkbox wedged between them, occupying the slot that otherwise holds "2 chat models listed". The error doesn't point at the thing that failed. Third, the glyph itself: success in light is a hairline green check (`#006B24`, 6.49:1) with no text at all, while failure in dark is a 10×10 pastel `#FFBBB4` X at 8.42:1 — the softest colour in the dialog. Pale pink on charcoal reads "disabled" before it reads "failed", and the success state is two full contrast points weaker than the failure state in the same role.
>
> **And it looks like a button that doesn't work.** The status glyph (12×10) sits 14px from the refresh control (12×12), same baseline, same bare-glyph-on-surface treatment, no frame or hover affordance on either. It reads as a two-icon toolbar where the first icon is inert. Parking both outside the field also left the form column ragged: the name field, URL field, model popup, and Save button all end at x=771, but the API-key field stops at x=721 — 50px short, for a reason invisible to the user.
>
> One evidence gap: the "v1" nav badge isn't in the render. Images 05/06 are crops of the docs content pane only — they begin at the "Alert" section band with no nav bar and no sidebar in frame — so that conversion is unreviewed here.

## Triage

**Verified before triaging.** The first finding's measurement was
independently reproduced against the token set rather than the pixels:
`MarkOn(RoleNeutral, Level0, TextFloor)` returns `#5c5c5c` in the light
scheme and `Ramps.Neutral.Step(700)` — the ink the hero subtitle and the
pricing body already wear — returns `#5c5c5c` too. In the dark scheme the
same pair is `#9e9e9e` against `#cccccc`. The claim is exact, and it is
about the badge's own derivation rather than about any call site: the
neutral ramp has no pinned base, so Neutral takes the walk, and in the
light scheme the walk lands on the rung secondary prose already occupies.

**Nothing fixed in this task.** Every finding either belongs to the badge's
ruled anatomy, is already scheduled work, or predates the conversion. The
one call-site defect that is genuinely new — the "Popular" baseline —
cannot be fixed at the call site, for the reason given below.

1. **Light-scheme Neutral collides with secondary prose** — POOL, new. Not
   the same as the pooled dark-Neutral deficit: this is the light scheme,
   and the complaint is not contrast but indistinguishability. A Neutral
   badge and a caption are one ink in light and two inks in dark, so the
   component reads as a component in one scheme and as a span in the other.
   Fixing it means giving Neutral something the other four have — a pinned
   base, a weight, or a floor of its own — which is a ruling on the badge's
   anatomy and not a call-site edit.

2. **"Popular" baseline is 3px off** — POOL, new, with a known fix. Real
   and caused by this conversion: the badge's 16 dp line box is centred
   against TitleLarge's, and centring two line boxes of different heights
   does not align their baselines. The pill hid it because a pill is a box.
   It cannot be fixed in `patterns/pricing`, because `badge.draw` returns
   `layout.Dimensions{Size: size}` and discards the baseline `typeset` hands
   it, so `layout.Baseline` alignment has nothing to align on. The fix is
   about five lines — carry `labelDims.Baseline` out of `draw`, then switch
   `nameRowWidget`'s Flex from `Middle` to `Baseline` — and it belongs with
   whoever owns the badge's anatomy, plus one golden round.

3. **"Popular" is now the weakest text on the card** — POOL, and a
   consequence of item 1 rather than an independent finding. Worth carrying
   because it names the cost in the one place a badge carries product
   meaning rather than scaffolding.

4. **"Anchor" and "Trigger" read as captions; the tooltip demo contradicts
   its own section header** — ALREADY SCHEDULED, not pooled. These two cells
   were converted deliberately minimally so the package deletion compiles;
   Phase BK replaces both specimens with icon buttons. The reviewer
   independently arrived at the reason BK exists. The beak-points-at-nothing
   measurement (4 px of air, apex at y=552 against a baseline at y=547) is
   worth carrying INTO BK as the acceptance test for the replacement.

5. **The failing API-key field is not marked** — POOL, pre-existing. The
   field's border and fill were never driven by `KeyStatus`; the conversion
   changed the verdict beside the field and nothing about the field.

6. **The error text is 61 px away with an unrelated checkbox between it and
   the field** — POOL, pre-existing. `settingsBody`'s row order, untouched
   here.

7. **Success reads weaker than failure; pale pink reads "disabled"** —
   POOL, and adjacent to the pooled scheme-chroma-inversion item without
   being the same claim. Note the comparison is across schemes (light
   success against dark failure), so the two-contrast-point gap is partly an
   artifact of which capture carried which verdict; the within-scheme
   version of the question is still worth asking of the badge's four hued
   inks.

8. **The verdict glyph reads as an inert button beside the refresh
   control** — POOL, new, and the sharpest cost of the hoist. Before, the
   verdict was a filled Material circle-check and the refresh an outline
   glyph, so the two did not rhyme; both are now bare strokes on the same
   surface at the same size, and a bare stroke beside a bare stroke reads as
   a toolbar. The badge is right and the row is now wrong — which is a
   settings-row layout question, not a badge one.

9. **The API-key field ends 50 px short of the form column** — POOL,
   pre-existing. The verdict and the refresh control always sat outside the
   field; the conversion narrowed the verdict slot from 18 dp to the badge's
   16 dp line box, so the field is 2 px wider than it was, not narrower.

10. **The "v1" navbar badge was not in frame** — accepted evidence gap. The
    sitedocs captures are the patterns tab's content pane, which begins at
    the Alert band; the navbar specimen is further down the same strip. The
    conversion is a one-line call-site change on the floor storey and is
    covered by the gallery goldens, but it did not get eyes here.
