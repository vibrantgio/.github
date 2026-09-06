---
date: 2026-09-06
task: BT2.1
phase: BT
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BT2.1 fresh-eyes review — a document read at a measure

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer on this platform
complain about? It was handed the two new wide-viewport goldens —
`markdown/testdata/golden/measure-wide-light.png` and
`measure-wide-dark.png`, a 900x380 viewport holding a 360 dp column.

No application look changed in this task: the measure defaults to zero
and every stored golden in `markdown` is byte-identical to before. The
review was run on the new captures anyway, because they are the first
composition the measure produces.

## What the review confirms

The centring is exact and scheme-symmetric. The column spans x=270..629
in both images, leaving 270 px either side, identical to the pixel; every
line band, the fence rect and the bar rect are pixel-identical between
the two schemes. Body baselines land on a 24 px pitch and code baselines
on a 19 px pitch with no accumulated error. That is the contract this
task was written to meet.

## In scope, and ruled rather than fixed

The reviewer asked why a fence holding a 55-character comment scrolls at
all when 540 px of page sit empty either side of it. That is the measure
as the Language defines it: wide content that keeps its own size sits in
a scroll area no wider than the measure, because a fence allowed to run
out to the window would put the reading column and the code on two
different measures on the same page. Filed here rather than fixed.

## Out of scope — carried, not discarded

Everything else the reviewer found is present in the code-overflow
goldens recorded before this task and is untouched by the measure. Each
is recorded here so the next round that opens the fence has them:

- Dark-scheme prose carries visibly more ink than light for the same
  glyphs — antialiased coverage measured 0.1 -> 0.41, 0.5 -> 0.87, and
  66% more total ink over the paragraph. The two schemes do not read as
  the same weight.
- The fence's bottom padding is not its top padding: 16 px of clear fill
  above the first line against 4 px below the last descender, with the
  bar 1 px off the border.
- The bar reads as a rule rather than as a scrollbar: 6 px tall, always
  drawn, no track, inset 13 px from the fence's inner edge so it starts
  under the code rather than at the block's edge.
- The bar's colour is not mirrored: light `#5C5C5C` against `#424242`
  code, dark `#CCCCCC` against `#CCCCCC` code — the same value as the
  text it sits under, and the brightest mass in the dark image.
- The cut edge slices a glyph in half and leaves the fence's horizontal
  padding clear beside it; the dissolve is drawn but is invisible at 1x
  against a near-white or near-black fill.
- The fence's fill is 1.13:1 against the light page and 1.16:1 against
  the dark one, so only the rim says where the block is — and a white
  fill in a light scheme is a ceiling nothing can be raised above later.
- Code text is both fainter than prose (9.9:1 against its fill, against
  prose's 16.4:1) and physically smaller (10 px ascender against 13).
- The fence's radius is nearly square while the bar's is a full pill.

Two further remarks are outside the library rather than defects in it:
the goldens carry no syntax palette, the highlighter being opt-in; and
the capture's small top inset is the test harness's own inset with
`StartSpace` at zero, not a document margin.
