---
date: 2026-09-03
task: BR1.2
phase: BR
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BR1.2 fresh-eyes review — the card's two looks, outlined and filled

Two images, both offscreen renders at 1 px per dp, no application launched:
the gallery's "Card — outlined and filled, header, body and footer"
specimen, captured from `components/gallery`'s own inventory in each
scheme at the page width the stored tiles use (900 dp), each 900x222.
This is the composition BR1.2 moved: the second look, until now a level-2
fill, is the filled look at level 1, the same fill the outlined look
already had, so the two differ only by the outline.

One reviewer per scheme, each shown one image and nothing else. Neither
saw the packet, the plan or the other's reply; no model override was
passed, so both inherited the dispatching session's model. They were
given no checklist and one question: what would a developer on this
platform complain about? Both were told to sample pixels rather than
judge fills by eye, and were handed the three recorded misreads — dark
text reads grey at 1x, a light-scheme step under about 1 L* reads as no
step at 1x, and adjacent regions sharing one fill often do so by design.

## What came back, verbatim — light

I sampled the pixels rather than trusting my eyes. Here is what a
Gio-on-macOS developer would file.

**The outline is painted outside the box it was given, and it is two
pixels wide.** The page's spacing arithmetic is unambiguous: the left
margin is 24 (the section label's glyphs start at x=24), the gutter is 20,
the gap under the header rule is 20. The filled card lands exactly on that
grid — its fill occupies x 304–563, y 52–201, a clean 260×150 rect (304 =
24 + 260 + 20). The outlined card gets the same 260×150 rect at x 24–283,
but its stroke paints x 23–284 and y 51–202: one pixel outside the rect on
every side, one pixel inside. Consequences the developer actually feels:
the two cards in the row do not share a top edge (51 vs 52) or a bottom
edge (202 vs 201); the outlined card hangs a pixel into the left margin so
it no longer aligns with the section label above it; and its usable
interior is 258px against the filled card's 260, so the same string can
wrap at a different word depending on which variant you chose. Put an
outlined card in a clipping parent, or flush against the window edge, and
the left of the line gets shaved. The fix is the boring one — inset the
stroke by half its width, or stroke the inner edge — but as shipped,
`Outlined` is not the same size as `Filled`.

And the stroke itself is heavy. Both border columns read essentially full
strength (197 and 198 on the left, 199 and 197 on the right, same top and
bottom), not the ~221/~221 pair you would get from a 1px line straddling a
boundary. That is roughly two device pixels of ink at 1x, where macOS
hairline rules are one. It is a genuinely thicker line than a native
separator, and whatever produces 2 here presumably produces 4 on a Retina
backing store.

**There is a latent corner seam.** At each corner, one pixel of pure page
background (246) sits *between* the stroke and the fill — e.g. (25,57)
top-left, (278,53) top-right, (25,196) bottom-left. The outline's rounded
corner and the fill's rounded corner are not the same curve. Right now
nobody sees it, because the fill is 248 and the page is 246. Give the card
an actual fill colour and you get a background-coloured notch at all four
corners.

**"Filled" doesn't fill.** I checked this specifically before saying it:
the outlined card's interior and the filled card's interior are both
exactly RGB(248,248,248), pixel for pixel, and the page behind them is 246
— about 0.7 L\* apart, which I understand is a deliberate, below-threshold
step. That policy is fine for a surface that has some other boundary. It
is fatal for a variant whose *only* feature is the fill. The filled card
has no border, no shadow (I sampled the ring around it — 246 flat on all
four sides, no gradient at all), and a fill that is by design
imperceptible, so nothing marks its top, bottom, left or right. On screen
it is not a card, it's a paragraph with a chip under it. A developer
choosing `Filled` from an API that offers exactly two variants will
reasonably ask what the second one is for, since the two are
pixel-identical apart from the very hairline that `Filled` omits.

**Two smaller ones.** The footer chip's label is a mid-grey — it bottoms
out at 92 with a solid plateau of pixels at that value, so that's the
token, not antialiasing — on a 212 chip fill: 4.51:1, sitting on the 4.5
AA floor for small text, while every other label on the strip is
near-black (19). One recolour of the chip fill and it's a failure. And the
gallery caption promises "header, body and footer", but the three slots
produce no visible structure — no divider, no differential padding, the
footer chip is simply the last thing in the column at the same 16px inset.
It isn't clear what `Header`/`Footer` buy over stacking widgets yourself.

## What came back, verbatim — dark

I sampled the pixels rather than trusting my eye. Here is what a developer
working on this platform would complain about, in the order they would
raise it.

**The two variants have exactly the same fill.** Both card interiors are
byte-identical `(34,34,34)`; I confirmed it by run-length scanning row 120
across both cards and by a full-image colour histogram, which contains a
single 34-cluster of 69,417 pixels. So "Outlined" is not a card with the
backdrop showing through and an outline around it — it is the *same*
filled card with a hairline added. The filled card is separated from the
backdrop `(24,24,24)` only by that fill: ΔL\* ≈ 5.0, a contrast ratio of
1.12:1. That step is real and I am not claiming it is invisible, but it is
the *only* thing defining the filled card's boundary, and it means the
developer choosing between two variants is choosing between "card" and
"card, plus a border." They will ask what they actually bought.

**The outline renders below its own specification.** Every straight run of
the border is two columns, values 80 and 82, with no fully-covered pixel
anywhere along an edge (756 pixels of each, exactly). The corner arcs peak
at 105, and 104–105 is a plateau, so the nominal outline colour is
~`(105,105,105)`. Nominal against the backdrop that would be 3.23:1 — just
clearing the 3:1 non-text minimum. As rendered at 80/82 it is 2.27:1, and
2.04:1 against the card fill. The border is specified right on the
accessibility line and the sub-pixel smear pushes it under. Nothing here
is snapped to the pixel grid: the stroke straddles the boundary as a soft
two-pixel band. The developer will note that the divider under the section
title *is* snapped — a single crisp row at y=31, value 46 — so the
rasterisation discipline is inconsistent within one screen.

**The corners are visibly heavier than the sides.** At the 45° point of
the top-left arc the row reads 78, 104, 73 — summed ink above background ≈
183, where a constant-width band crossed diagonally predicts 104 × √2 ≈
147. That is ~25% overdraw, and the peak pixel is 105 against 82 on the
straight edges. Either the stroke is translucent and double-composited at
the joins, or the arc coverage is computed differently from the
axis-aligned segments. Either way the outline reads as four darker dots at
the corners of a lighter frame.

**The stroke is not inside the layout box.** The outlined card's footprint
is 262×152 at (23,51); the filled card's is 260×150 at (304,52). Same
nominal 260×150 slot, but the outlined variant bleeds one pixel on all
four sides: the two cards' top edges are off by one, their bottoms are off
by one, and the gap between them is 19px where the geometry implies 21.
Content insets differ too — 17px from the outer edge on the outlined card,
16px on the filled. Text baselines happen to align perfectly (70–82,
101–113, 122–134, 143–153, 169–184 in both), so the misalignment is purely
in the boxes. A developer will complain that `Dims` doesn't account for
the stroke: outlined cards in a row won't line up with anything else, and
one placed flush against a clip will get its border shaved.

**The advertised structure isn't expressed.** The heading promises
"header, body and footer," and presumably the API demands three slots, but
the render gives back one flat `(34,34,34)` region with no divider, no
footer fill, no elevation change. The spacing doesn't signal it either:
17px above the title, 28px from title baseline to first body baseline
against a 21px line pitch, 16px from the last body baseline to the chip,
16px to the bottom. The footer is *closer* to the body than the header is.
It reads as a paragraph with a grey pill after it.

**The footer chip reads as disabled.** Its fill is `(71,71,71)` — 1.71:1
against the card — and its label peaks at 204, the only text on the strip
that isn't the 238 used for the section heading, both card titles and all
body copy (13.7:1 and 15.7:1, both excellent). 204-on-71 is 5.79:1, which
passes AA, but on a card where everything else is at 13.7:1 the
muted-fill-plus-muted-label combination is exactly the dark-mode disabled
idiom. If it is interactive, it is also a 51×16px target at 1x, far below
any desktop pointer-target guidance.

**The gallery demonstrates nothing about behaviour.** The body copy is
hard-wrapped: line two ends at x=459 with 104px of clear interior to its
right, and the next word would have fit comfortably. So the strip never
shows how the card reflows, which is the first thing anyone integrating it
needs to know. Both cards are fixed at 260px inside a 900px strip,
left-packed, 336px of empty backdrop to the right — intrinsic-versus-fill
behaviour is untested too.

Two smaller notes. The section-title strip is `(21,21,21)`, *darker* than
the content backdrop at 24 (ΔL\* 1.5, 1.03:1); the entire separation is
carried by that one 46-valued divider row at 1.31:1, which inverts the
usual ordering where chrome sits at or above the backdrop. And
forensically: the outlined card contains four one-pixel-wide,
near-full-height columns at x=26, 29, 277 and 282 sitting one LSB above
the fill (35 versus 34), absent from the filled card. Invisible to anyone,
but it confirms the outlined variant is composited as extra paths over the
same filled card rather than being its own shape — which is the same root
cause as the fill collision and the overflowing stroke.

## What was done about it

Nothing was changed on the strength of the review: no item is both cheap
and inside BR1.2, whose subject is the second look's fill and name.

**Confirmed, and the finding both reviewers reached independently.** Two
reviewers who could not see each other's image or reply arrived at the
same complaint from opposite schemes: the two looks are one fill plus an
optional hairline, so the filled look has nothing of its own — in light it
is a 0.7 L\* step with no edge at all, in dark a 5.0 L\* step that carries
the whole boundary alone. This is exactly the shape BR1.2 was given, so it
is not a defect against the task; it is a question the task's shape
raises, and it needs a ruling rather than a worker's fix. The Language's
own card entry describes a different arrangement — outlined as a hairline
on the content's own fill, filled as one step lighter with no hairline —
under which the two looks differ in both fill and edge instead of only the
edge, and both reviewers' central complaint disappears. Deciding between
the two is the owner's; changing it reaches `card-border` (derived against
level 1 today), the published sheet, the mirror fixtures and every
outlined golden, so it is a task of its own, not an amendment to this one.

**Real and outside BR1.2 — the stroke's geometry.** Four separate items
share one root cause, which the dark reviewer named correctly at the end:
the outline is a centred stroke over the fill's rounded rectangle rather
than a shape of its own. From that follow the outlined card's 262x152
footprint against the filled card's 260x150 and the one-pixel edge
mismatch between them; the two partly covered columns per edge that read
as a two-device-pixel line at 1x where a hairline is one; the ~25% corner
overdraw; and the latent one-pixel seam of the surface behind showing
between arc and fill at each corner, harmless only while the two fills are
0.7 L\* apart. The rasterised 2.27:1 the dark reviewer measured against a
nominal 3.23:1 is the same effect: the derivation clears the graphic floor
for a line that is never fully painted. `explorations/open-rulings.md`
already carries the one-pixel offset as item 68; the smear, the corner
overdraw, the corner seam and the rasterised contrast are new, and the
whole set wants one task that insets the stroke and gives the outline its
own path.

**Real and outside BR1.2 — the specimen.** The footer badge is at 4.51:1
in light (92 on 212, right on the AA floor for small text) and reads as
the dark-mode disabled idiom in dark (204 on 71, against 238 everywhere
else on the strip). The specimen's prose is hard-wrapped, so the strip
shows nothing about reflow, and both cards are pinned at 260 dp inside a
900 dp row, so it shows nothing about intrinsic-versus-fill either. The
hard wrap is deliberate — the gallery's goldens must be byte-stable
without a system shaper — but the badge contrast is a live question for
`components/badge` and the gallery's neutral badge together.

**Real and outside BR1.2 — the gallery's own section band.** In dark the
section-title strip is (21,21,21) under a content backdrop of (24,24,24),
so the band is darker than what it labels and only its divider row
separates them. BR1.1 has just settled that chrome stands a tint lighter
than the backdrop; this band is the gallery's own furniture and was not in
that pass.

**Not a defect.** "The advertised structure isn't expressed" reads the
three slots as a promise of visible parts. The card draws no text and no
divider of its own by construction — the slots are caller-supplied
widgets, and what they buy is the stack, the S4 inset and the S3 gaps that
fall only between the slots that survive, which is why a header-only card
is not padded for the two that are absent. The reviewer is right that the
specimen does not show this; the specimen, not the pattern, is what would
have to change.
