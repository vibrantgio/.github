---
date: 2026-09-17
task: CG4.10
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG4.10 — the gallery's controls read cold beside the platform's own

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: do these controls read as macOS controls at the
platform's sizes, and what is wrong with them? It was handed the gallery's
controls section — button, the three emphases, the pinned pair, chip, text
field, search field, checkbox and radio, and the picker — rendered offscreen
at 1 px per point in both appearances, beside the stored captures
`control-hover-{light,dark}.png` and `control-pressed-{light,dark}.png`, and
told only the recorded misreads: that a dark label reads grey at 1x; that the
light sidebar material is the content's white told apart by a seam; that a
still shows no fade and no cursor; that alpha composites in sRGB; that the
window controls in these renders are harness stand-ins; and that a pointer
target is invisible in a still.

CG4.10's result is the pointer target and nothing drawn: `MinHitTarget`
deleted, every control's target the box it draws. Nothing below was acted on
inside the task; each is filed.

## The reply, verbatim

> Yes, at a glance they read as macOS controls, and the metrics back that up:
> the filled button is 24px tall with roughly a 5px corner radius, which is
> exactly what the Save button measures in the Script Editor sheet (y 501–524,
> 3px of corner inset); the resting fill is 0,122,255, the system accent; the
> picker's grey is 236,236,236, byte-for-byte the fill of the File Format
> pop-up in the same reference; the checkbox is 16x16, matching the platform's;
> the text field is 28px against the platform's 27, and its border is
> 243,243,243, the same near-invisible hairline macOS uses on the Tags field.
> Nobody sized these by eye off a Material spec. The problems are all in the
> indicators and the states.
>
> The worst of them is the picker. Its menu indicator is a solid filled
> downward triangle. That glyph does not exist on macOS. The Finder toolbar
> capture has both of the shapes the platform actually uses, side by side: the
> list-view control carries the stacked chevron pair for a pop-up, the
> grid-view control a single thin chevron for a pull-down, both hairline
> strokes in label grey. A filled triangle is a web select or a Windows combo
> box. The gallery's own toolbar picker gets this right with a single chevron,
> which makes the triangle on the main picker look like two different
> components rather than one.
>
> The open menu under that picker is wrong in almost every respect. It is a
> square-cornered rectangle — I checked the corner at x=376, y=1124 and the
> border column runs straight into the border row with no rounding — held off
> the page by a single 1px hairline (230,230,230 light, 52,52,52 dark) and
> nothing else. There is no shadow: the pixel immediately outside the border is
> the page background, 255,255,255 in light and 30,30,30 in dark, and the
> menu's own interior is that same 255 and that same 30. So the menu is the
> page colour on the page colour, separated by one hairline. macOS floats a
> pop-up menu on a translucent material that sits distinctly lighter than the
> window behind it, with rounded corners and a real drop shadow, so it reads as
> being above the window. The highlight on Banana is also a full-bleed square
> bar running edge to edge; macOS insets the selection bar from the menu edges
> and rounds it. And there is no checkmark beside the current item, nor is the
> menu positioned so that item lands over the button — macOS pop-ups open over
> the control with the selection aligned to it, they do not drop below like a
> web select.
>
> The picker field itself is 28px tall while the filled button beside it is 24
> and the platform's pop-up is 24. The gallery's own toolbar picker is 24. So
> the standard picker is the one control that is 4px over, and it is out of
> line with its own siblings as well as with the platform.
>
> Hover does not exist. The "Hover" filled button is pixel-identical to "Rest"
> — I diffed the left rounded cap of each and the maximum channel difference is
> zero, in both light and dark; both are flat 0,122,255. The same holds for the
> chips: unselected Rest and Hover are both 236,236,236, selected Rest and
> Hover both 0,100,225. Only press moves (0,110,230 in light, 25,135,255 in
> dark, which is the right direction in each theme). A dialog push button
> genuinely has no hover on macOS, so the button alone would be defensible, but
> the chips are toolbar-grade controls and the Finder capture shows exactly
> what the platform does there: the list-view and grid-view controls carry a
> grey and a white bezel that appears under the pointer. Three controls
> labelled with a hover column and rendering nothing is either an unimplemented
> state or a mislabelled gallery.
>
> Focus is indicated three different ways, and the button's way is invisible.
> On the filled button, focus is a one-pixel slightly-darker-blue outline drawn
> inside the accent fill — blue on blue, unreadable at 1x; at 6x you can just
> make it out. macOS draws focus as a light-blue halo outside the control while
> the control keeps its own edge, which is what the Save As field in the
> reference shows: the field keeps its border, there is a one-pixel white gap,
> then the ring. On the checkbox and radio, focus instead replaces the control
> with a larger one. The resting box is 16x16; the focused box measures 24x24,
> and inside that 3px pale-blue ring the 16px box has been reduced to a
> barely-there grey ghost with no crisp edge. So the control changes size when
> focused and loses its own outline, where macOS keeps the 16px box intact and
> adds the halo around it.
>
> Disabled is label-only. The disabled button's fill is 236,236,236 —
> byte-identical to the enabled Tonal button's fill in the row below. The
> disabled picker's fill is byte-identical to the enabled picker's. The
> disabled text field's border is 243,243,243, identical to the resting
> field's. Only the text greys. That means a disabled push button and an
> enabled Tonal button are the same object, and a disabled picker cannot be
> told from a live one without reading the label colour. macOS fades the whole
> control: in the reference sheet the disabled checkbox bezel sits at 242
> against a 255 background while its label sits at 204 — bezel and text fade
> together.
>
> Two smaller things. The Tonal button measures 26px tall (159–184) where the
> Filled button in the same row measures 24 (160–183), so the two do not share
> top and bottom edges; on macOS, Cancel and Save both run 501 to 524 exactly.
> And the search field's clear mark is a bare thin ✕ glyph; macOS uses the
> filled grey circle with a white ✕ cut out of it, which also gives the control
> a proper round hit target instead of a stroke.

## What was done with it

The verdict is the task's own answer: every size the reviewer measured came
back as the platform's, control by control, and it read the scale as measured
rather than borrowed. That is what CG4.10 leaves behind — the target is now
that measured box, in the live path as in the pure one.

Nothing the reviewer found is a pointer target, and nothing was fixed inside
this task:

- **The filled triangle** on the form trigger is a glyph, not a metric. Filed
  as 502.
- **The open menu** — the page's own fill on the page, a full-bleed square
  highlight, no checkmark, dropping below instead of opening over the control.
  Its square corner and its missing shadow already stand as 170, 329 and 416;
  the fill, the highlight bar, the checkmark and the placement are new. Filed
  as 503.
- **The form trigger's 28 dp** against the platform's 24 pop-up is a drawn
  height. It is the strongest of the findings against the platform ruling and
  is nothing this task touched. Filed as 504.
- **Hover rendering nothing** on button and chip. Filed as 505.
- **Focus drawn three ways**, blue inside blue on a filled button. Filed as
  506. The checkbox half is a painted extent and not a target: the footprint
  the glyph is centred in is the control height in both states, which a still
  cannot show — the brief said so.
- **Disabled as the label alone.** Filed as 507.
- **The Tonal button's 26 px** against the Filled button's 24 is the 1 dp edge
  straddling the control's own boundary, which is also why one golden moved in
  this task. Filed as 498.
- **The clear mark's bare ✕** already stands as 408, from CE2.4b's review, and
  was not filed again.
