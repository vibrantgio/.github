---
date: 2026-09-18
task: CG5.3b
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3b — a workbench toolbar read cold beside the Finder toolbar

One reviewer, having seen neither the plan nor the packet nor any source, was
given two images at 1x: in each, a strip of mindchat's window across its
toolbar row above a crop of a real Finder window's toolbar taken on the same
display. The light pair was the light appearance against
`finder-window-light.png`, frontmost; the dark pair the dark appearance
against `finder-window-untinted-dark.png`, frontmost. One question: does this
toolbar read as a macOS toolbar with its controls, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam; still
captures show no fade and no cursor; alpha composites in sRGB; the window
controls are harness stand-ins; a pointer target is invisible in a still; the
open menu is CG5.4's and focus CG5.5's, neither under review.

The renders it read were taken after this task's change landed: the picker's
chrome trigger drawing the density's toolbar control height, which measures
36 dp in mindchat's 52 dp chrome row with 8 above it and 8 below — the
platform's own placement, row for row.

## The reply, verbatim

> It reads as a macOS window, but the toolbar does not yet read as a macOS *toolbar with controls* — it reads as a title bar with some loose glyphs on it. The band height, the vertical centring, and the alignment of the title with the window-control row are all right; what is missing is the control chrome.
>
> **Most serious: the toolbar controls have no button containers.** In the light strip, the sidebar-toggle and the `+` at x≈185 and x≈218 are bare outline glyphs sitting directly on the toolbar fill, and the model popup at the far right ("OpenAI · gpt-5.5" plus its chevron pair) is likewise bare text on white. Compare the Finder strip directly below: every single control is inside a rounded capsule — the back/forward pair share one pill, the list-view popup and the arrange popup each have their own, the share/tag/more trio share one, and the search button is a filled circle. Nothing in Finder's toolbar is a naked glyph. The consequence in the app strip is that the right-hand end reads as a piece of status text rather than as something you can press, and the two left-hand glyphs read as decoration.
>
> **The same control is drawn differently in the two appearances.** In the dark strip the model popup at the right *does* have a container — a distinctly lighter rounded rect with a visible edge around "OpenAI · gpt-5.5". In the light strip that container is absent (or so close to the toolbar fill that it does not exist at 1x). Whatever produces the capsule in dark is not producing it in light, and that is a straightforward inconsistency, not a judgement call. Note also that the dark capsule is *too* light relative to its neighbours: Finder's dark capsules (the segmented view picker, the share/tag/more group) are only a step above the toolbar, whereas the app's popup fill jumps much further, so the one control shouts.
>
> **The title is the wrong weight.** "Reactive layouts" in both strips is regular weight; "Applications" and "Recents" in the Finder strips are clearly semibold. At this size the weight difference is the single most recognisable typographic tell of a macOS toolbar title, and the app misses it in both appearances.
>
> **The sidebar/content seam is drawn as a hard line through the full toolbar height.** In both app strips there is a crisp vertical rule at x≈240 running from the very top edge down. Finder's equivalent seam does not read as a drawn line across the toolbar at all — in the light strip the sidebar region simply ends and the content begins, and in the dark strip the boundary is a value change, not a stroke. The app's rule is too dark and too continuous; it cuts the toolbar into two panels instead of leaving one unified band.
>
> **The glyph metrics are light.** The sidebar-toggle and `+` are thinner-stroked and smaller than the SF Symbols in the Finder strip at the same scale — Finder's list, grid, share, tag and ellipsis symbols all carry visibly more weight and optical size. The `+` in particular is a hairline cross. The chevron pair on the model popup in the light strip is small enough to nearly disappear.
>
> Minor and possibly the harness rather than the library: the app window's top-left corner is square where Finder's is a large radius.

## What was done with it

The reply confirms this task's whole result from the other side: "the band
height, the vertical centring, and the alignment of the title with the
window-control row are all right", read cold against the platform's own band.
CG5.2b's reviewer had filed the opposite finding against the same control —
"the toolbar trigger is a third too short … 24 px where every toolbar control
in all three Finder captures is 36" — and that finding is what this task
closed. No reviewer now reads the control as the wrong size.

**Nothing was fixed here.** Every finding is either outside this task or
already answered by a measurement, and each is accounted for below.

**Filed, 560 — the light control has no separation from its band.** The
reviewer reads the light trigger as "bare text on white" and the dark one as
having a container, and calls the pair an inconsistency. The polarity is the
platform's own and is measured: `finder-window-untinted-dark.png` gives a
`#404040` rim over the fill, and `finder-window-{light,untinted-light}.png`
give no stroke row on any side at all, which CG5.2b read and this library
draws. What the platform has there and this library does not is the control's
DROP SHADOW — the reference already records that in the light appearance the
control "is told from its band by its drop shadow alone", the 250 above the
fill and the 244 below in that capture. So the reviewer is reading a real
absence with the wrong cause named, and the item filed is the shadow.

**Not a defect — the dark fill's step.** "The app's popup fill jumps much
further" than Finder's does not hold against the pixels: the trigger draws
`#262626` on a `#1e1e1e` band, which is the platform's own eight levels,
measured off the capture in the same image. Both are in that image and both
measure the same step. The trigger's rim is the one place it misses, and it
misses LOW — `#3b3b3b` against the platform's `#404040`, five of 255 short,
recorded in `toolbarface.Rim`.

**Filed, 561 — the chrome controls are bare glyphs.** The pane toggle and the
new-chat mark stand on the band with no control around them, where the
platform draws every toolbar control inside one. This library has exactly one
bordered chrome control, the picker's trigger; nothing else can give a mark a
container, which is why the finding is a library item and not an application
one.

**Filed, 562 — the toolbar title's weight.** mindchat sets it in TitleSmall
regular where the platform sets its toolbar title semibold.

**Filed, 563 — the seam across the band.** `patterns/pane` draws its seam the
full height of the window, the toolbar row included, where the platform leaves
the band unified and lets the fill change carry the boundary.

**Filed, 564 — the chrome marks' weight and size** against the platform's
symbols at the same scale.

**Not a defect — the square top-left corner.** The reviewer flagged it as
possibly the harness, and it is: these are headless renders of the window's
own content, which carry no window rounding.
