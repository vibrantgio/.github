---
date: 2026-08-30
task: BI2.1
phase: BI
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BI2.1 — fresh-eyes review of mindchat after the picker adoption

2026-08-30. Four captures (header menu open, settings modal open, both
schemes) from TestWholeWindowPickerRender; reviewer briefed on five
recorded misreads, measured every claim, and checked two against the
stored macOS reference. The worker re-measured every load-bearing
claim independently. The full verbatim reply and per-finding triage
are preserved in the BI2.1 task report; the pooled outcomes are
open-rulings items 150-159. Highlights of the triage:

- Finding 1 (the settings menu has no border/shadow/radius — reads as
  corrupted text, 1.03:1 plane seam) is a SHIPPED REGRESSION of this
  task: the retired popover drew the outline the inline field menu
  now lacks. Tasked as BI2.2 with the rest of the menu manners the
  assembly used to provide (height cap + scroll, hover, dismissal,
  empty-state label).
- Finding 8 (hand-painted traffic lights with CSS-demo colours) is
  the render harness's stand-ins — recorded as the sixth fresh-eyes
  misread, not a defect.
- Finding 4 (two pickers share nothing) is largely the two-register
  design; its real half is finding 1.
- Findings 2/3 are the patterns/popover viewport-clip and the
  Pin-reported-box tail seam — pre-existing, pooled.
- Control heights were checked against the reference and CLEARED:
  the 36 px picker button matches macOS Notes' toolbar field exactly.
