---
date: 2026-09-02
task: BP2.1
phase: BP
reviewer-model: unrecorded
reviewer-effort: unrecorded
---

# BP2.1 fresh-eyes review — the followed-link arrival highlight

Two headless captures of vaultview's whole window at the size it opens,
1100x800, in light and in dark: the moment a link that named a block lands,
with the block it named carrying the highlight wash at full strength. Both
came out of the package's own window-render golden route; no application
window was launched.

The reviewer was a fresh agent that had not seen the task packet. It was told
only that a reader had clicked a link pointing at a paragraph inside the note,
that the app had just brought them there, that one paragraph carries a wash
saying "this is the thing you clicked through to", and that the wash fades by
itself. It was given Bash and told to sample pixels before making any claim
about colour, contrast or size, and briefed on the recorded false positive —
dark-scheme ink reads grey at 1x. It was told to review nothing else in the
window. Two questions, no checklist:

1. Does the washed paragraph read as "here is what you sought"?
2. Could the wash be mistaken for a status report?

## The reply, verbatim

> Both questions, with sampled values.
>
> **1. Yes.** The tint reads as "here is what you sought". It sits behind the
> sentence's text run only — a flat rectangle 305x24 px (x 272–576, y 388–411)
> inside a reading column roughly 478 px wide — with hard edges, no border, no
> left rail, no icon, no full-width band. The ink inside it is identical to the
> body ink elsewhere in the note (light #131313, dark #EEEEEE), at 12.5:1 on the
> wash versus 17.2:1 on the page in light, and 11.8:1 versus 15.3:1 in dark, so
> the paragraph still reads as ordinary prose that has been marked, not as a
> boxed-off notice. It also matches the rest of the window's pointing: the wash
> is violet (light #E6CBEE, HSV 286/15/93; dark #3B2641, HSV 287/42/25 —
> genuinely saturated purple, not grey, sampled to rule out the known dark-1x
> false positive), the same hue family as the selected sidebar row and the
> selected outline row, both of which say "Reading list". Three violet marks,
> one destination. The light-scheme wash is subtle against the page (1.37:1,
> dark 1.30:1), but the hue shift from a fully neutral #F6F6F6 page carries it.
>
> **2. No.** A histogram of every saturated pixel in each capture (S > 45%, V >
> 30%) finds only violet and blue hues — 270° and 255° and a little 210–225° —
> plus about a dozen red pixels that belong to a syntax keyword in the code
> block. There is no red, amber, or green anywhere in either window, so the wash
> has no status palette to be confused with, and it carries none of the
> furniture that would suggest one: no icon, no coloured left edge, no bounding
> stroke, no banner spanning the column. Its nearest neighbour in the app's own
> vocabulary is the selection colour, which is a "where you are" meaning, not a
> "something happened" one.

## What was done with it

No defect was named, and nothing was changed in response.

The measured seam — 1.37:1 light, 1.30:1 dark — is inside what the token's own
derivation pins for a wash against the surface it marks: at worst 1.302:1 over
the shared seed sweep, at loudest 1.713:1.

One observation was pooled rather than acted on: the wash and the app's own
selection fill are the same hue family, which the reviewer read as coherent —
three violet marks, one destination — and which the system has not ruled on.
The reservation the highlighter carries is measured against the four status
hues and against nothing else, so the accent's own distance from it is
unmeasured. Pooled as open-ruling 231.

## The captures

- `workbench/vaultview/testdata/golden/window-arrival-light.png`
- `workbench/vaultview/testdata/golden/window-arrival-dark.png`
