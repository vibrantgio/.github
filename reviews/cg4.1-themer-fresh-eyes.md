---
date: 2026-09-17
task: CG4.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG4.1 — the themer read cold beside System Settings' Appearance pane

One reviewer, having seen neither the plan nor the packet nor any source, was
given the whole themer window in both appearances at 1x — 1200×900, the size
the window opens at — beside `system-settings-grouped-box-light.png` and
`system-settings-grouped-box-dark.png`, which are the whole System Settings
window on the Appearance pane and so the platform's own choices window. One
question: does this window read as a macOS choices window whose preview shows
the theme being chosen, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam; still
captures show no fade or cursor; alpha composites in sRGB; the window controls
of the reviewed window are harness stand-ins and are absent from these renders.

The renders it read were taken before the reply came back and before anything
below was acted on. They are the stored goldens as they then stood: the
appearance switch in the title row, the style list beside the preview, and the
sample window with its push buttons at the foot of its content pane.

## The reply, verbatim

> I read all four images, and zoomed into several regions of the first two to
> confirm details before claiming them.
>
> **Verdict: it reads as macOS-adjacent, but not yet as a macOS window, and the
> preview reads as a second window rather than as a preview.**
>
> What is right first, because it narrows the fault. The grouped-box family is
> genuinely the platform's: the box fill is #F7F7F7 on a white pane in light
> and (42,48,52) in dark, which is pixel-identical to the fills in the System
> Settings captures. Section titles sit above their boxes at the same left
> inset as the box; "Theme colour → Colour → #6C9BCE" mirrors the reference's
> "Theme → Colour" label/value row exactly. The two appearances are a coherent
> pair — nothing flips the wrong way, the code block carries catppuccin-latte
> and catppuccin-mocha correctly, and the style list swaps its contents while
> keeping the three "either" entries. The dark pane is (30,30,30) against the
> reference's (35,42,46), but the reference has "Tint window background with
> wallpaper colour" switched on, so its blue cast is wallpaper-derived and the
> neutral pane is defensible.
>
> Now what is wrong.
>
> **There is no window.** Sampling a column at x=600 from y=0, the background
> is uniform to the first box at y=104: no titlebar, no toolbar band, no
> separator, no sidebar, no bottom bar. "Themer" is content-weight text painted
> at (20,35) with the appearance toggle floating on its baseline at the far
> right. The platform window opposite it has traffic lights, back/forward
> chevrons and the pane title in a toolbar, and a sidebar carrying the
> navigation. So this reads as a settings *page* in a frame — the shape of a
> web preferences screen, not of an app window.
>
> **The preview competes with the window instead of illustrating it.** The mock
> Notes window is 810px wide inside a 1200px window, with full-size traffic
> lights, a real titlebar, and its own Search field, Cancel and Done. The
> reference does the same job with small thumbnails — unmistakably pictures,
> with a ring and a caption under them. Here the only traffic lights on screen
> belong to the fake window, so it out-signals its host. Worse, the preview's
> Done at x1070–1148 is filled #6C9BCE and the live "Keep this theme" at
> x1030–1180 is filled #007AFF, 56px apart vertically, same capsule, same size
> class. Two default buttons in one column, and the only Cancel anywhere is the
> inert one. Nothing tells you which of the three is clickable.
>
> **A drawing bug in the selected pills, in both appearances.** The selected
> "Roboto Mono" capsule and the selected style row ("catppuccin-latte",
> "catppuccin-mocha") each have a flat white square notch stuck to their left
> cap, breaking the rounded end. It is white in dark mode too, where it is
> glaring against the dark row. Same defect in both widgets, both themes — it
> is the pill's leading cap being painted with the wrong colour, not an
> antialiasing misread.
>
> **The Theme colour swatch is not right-aligned.** Its right edge lands at
> x=1023; the Picture box's swatch strip ends at x=1160 and the "Keep this
> theme" button at x=1180, all against a box edge at 1180. So that pill floats
> 157px shy of the inset every other trailing element respects, leaving a
> conspicuous empty band. Every trailing control in the reference ("Automatic
> ⌄", "Medium ⌄", the toggle) sits on one right inset.
>
> **Four selection dialects.** A blue ring for the picture swatch, a filled
> pill for the code face, a full-width filled row for the style list, a blue
> capsule-in-capsule for appearance. The reference uses one idiom — ring plus
> emboldened caption — for Auto/Light/Dark, Clear/Tinted and the four icon
> styles alike, and reserves radios and popups for value rows. The themer also
> never emboldens the selected caption, so "#6C9BCE · 38%" carries no weight
> cue.
>
> **Smaller, all in the Picture row.** The first cell is a bordered white photo
> card with an empty caption slot while every sibling has one, so the caption
> baseline has a hole. The captions mix units: "#007AFF · macOS" is a
> provenance, "38%" a share, in the same slot. The shares read 38, 31, 2, 19,
> 11 — out of order, and the header's long grey sentence exists mainly to
> explain that away. Generally the captions are doing explanatory work ("The
> platform's colours with the theme colour where the accent goes") that a
> preview should be showing.
>
> **Two structural notes.** No box contains a divider, and three of them hold
> exactly one row, so the box is acting as a background band rather than
> grouping anything — the reference's boxes always group two or more rows with
> hairlines. And the Theme colour box is the only one you cannot operate; it is
> a readout mirroring the Picture selection, styled identically to the boxes you
> can.

## What was done with it

**The notch on a chosen row — fixed.** It was the leading marker bar
`ChoiceRow` drew inside the row's own rounded fill, in the colour the platform
reads on its selection: a 6-point white rectangle inside a corner of radius 8,
which is a bite out of that corner rather than a mark. The bar is gone. A
chosen row now wears the platform's selection under the label the platform
pairs with it and nothing else, which is how the platform's own lists say it.
The two tests that read the bar read the row's fill instead.

**Two default buttons in one column — fixed.** The sample window's push
buttons stood at the foot of its content pane, directly above the page's own
default button. They now stand at the trailing end of the sample's toolbar,
where this platform puts a window's own actions; the find field moved to the
head of the content pane, where the platform opens one. "Keep this theme" is
the only filled button in the bottom half of the page again.

**The Theme colour row's trailing gap — a misread, and the brief's fault.**
The colour field at the trailing end of that row is a published component the
render harness draws as an empty box, so in these renders the row stops at the
chip and the field's own 132 points are blank. The live window fills the run to
the same inset as every other trailing control. The recorded-misreads brief
carried this line for the CG2.1 review and did not carry it here.

**"There is no window" — half a misread, half pooled.** The window controls
are the platform's own and are absent from a harness render, which the brief
said; what remains — that this window has no toolbar, no sidebar and no bottom
bar where System Settings has all three — is a question about the whole
window's shape rather than about this round, and is pooled.

**Four selection dialects, the Picture row's captions, the boxes holding one
row each, the preview's caption doing the preview's work** — all pooled. None
is the list, the preview's contents or the word "base", and each is a ruling
about a part of the window this round did not open.
