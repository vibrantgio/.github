---
date: 2026-09-18
task: CG5.4
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.4 — the picker's open menu read cold beside the platform's pop-up button

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: the gallery's open picker in both schemes, cropped
from the goldens this task regenerated
(`components/gallery/testdata/golden/components-{light,dark}.png`), and the
save dialog's closed "File Format" pop-up in both appearances, cropped from
`save-dialog-{light,dark}.png`. It was told which two are the platform's, that
no stored capture anywhere holds an OPEN macOS menu so there is no picture of
one to compare against, and it was given the recorded misreads — a dark label
reads grey at 1x; a still shows no fade, no animation and no cursor; a
coverage composites in encoded sRGB; window controls in a harness rendering
are stand-ins; a pointer target is invisible in a still; keyboard focus is
another task's and is not drawn here. It was asked one question, with no
checklist: "Does this open menu read as the platform's pop-up menu, and what is
wrong with it?"

## The reply, verbatim

> ## Does it read as the platform's pop-up menu?
>
> No. It reads as a Material / iOS-Settings picker that has been painted blue.
> Everything about the panel is plausible in isolation, but the two things a
> Mac user identifies a pop-up menu by — the shape of the highlight and the
> fact that the panel is a *material floating over* the window — are both
> wrong, and they're wrong in a way that names a different platform.
>
> Ordered by how much it matters:
>
> **1. The highlight is a capsule, and that is the loudest wrong note.**
> Measured in the light capture: the highlight runs x 34–173, y 56–83 — 140 ×
> 28 px, and the corner inset at the top row (starts at x 41 on the first row,
> x 34 by row 7) gives a radius of ~14 px, exactly half the height. That's a
> full stadium/pill. macOS draws the menu highlight as a rounded *rectangle*
> with roughly a 4–5 pt radius, inset about 5 pt from each side, and slightly
> shorter than the row pitch. A full-height capsule is the Android/iOS
> selected-row shape. On its own this one detail is enough to make the menu
> read as not-Mac.
>
> **2. The panel has no value separation from the surface it stands on.**
> Light: panel fill is `#FFFFFF` and the gallery background behind it is also
> `#FFFFFF`. Dark: panel fill is `#1E1E1E` and the background is also
> `#1E1E1E`. In both appearances the panel is *the same colour as its
> backdrop*. In dark this is severe — the only evidence a panel exists is a 1
> px `#343434` border, so it reads as a hole cut into the window rather than
> something lying on top of it. A macOS menu panel is a distinct material: in
> dark it is clearly lighter than the window it covers, and in light it is a
> near-white translucent panel with the backdrop showing through.
>
> **3. Light and dark disagree about how the panel edge is drawn.**
> Dark has a 1 px `#343434` hairline and essentially no shadow — the surround
> only falls from `#1E1E1E` to `#1B1B1B`, three levels, invisible at 1x. Light
> has *no* border at all and a large soft shadow. Two different constructions
> for the same component. macOS has both a hairline and a real shadow in both
> appearances.
>
> **4. The shadow is an elevation glow, not a menu shadow.**
> At x=100 the light shadow ramps over ~24 px above the panel top and ~24 px
> below the bottom — perfectly symmetric, no downward offset — and it never
> gets darker than `#E6E6E6`. That's a Material elevation blur. A macOS menu
> shadow is tighter, offset downward, and appreciably darker immediately at
> the panel edge, which is what makes the rounded corners read crisply instead
> of dissolving.
>
> **5. Rows are too tall, and the panel has no internal padding.**
> Row pitch is 28 px. The real pop-up button in your reference crop is 24 px
> tall *in total* (fill spans y 11–34) — so one menu row is taller than the
> entire control that opens it. macOS pop-up-menu rows are around 19–20 px at
> 1x. Worse, the three rows exactly fill the panel: panel y 29–110, rows at
> 29–56 / 56–84 / 84–111. There is zero padding above the first row and below
> the last, so "Apple" and "Cherry" are jammed into the rounded corners. macOS
> leaves ~4–5 px of panel above and below the item stack — that margin is
> precisely what lets the first and last highlight sit *inside* the corner
> radius instead of fighting it.
>
> **6. The checked row is painted with a permanent accent fill.**
> On macOS the checkmark alone states the current value; the accent fill
> belongs to the *pointer* and moves as you track down the menu. Here Banana
> carries both at rest, with nothing under the pointer. That "selected item =
> filled blue row" reading is Material's, not the platform's. (A real pop-up
> opens positioned so the checked item lands under the pointer, so the two
> coincide at the instant it appears — but the fill must be owned by the
> pointer, not by the selection.)
>
> **7. The menu is far wider than its content.**
> Panel is x 25–182 = 158 px. The longest label, "Cherry", ends at x 101 —
> leaving 81 px of empty space on the right, more than half the panel width.
> macOS sizes a pop-up menu to the widest label plus the checkmark gutter plus
> a small trailing margin, or widens it to match the button. This matches
> neither; it is just slack.
>
> **8. The gutter is oversized, though the alignment is correct.**
> Labels all start at x 57 — 32 px in from the panel edge — with the checkmark
> occupying roughly x 36–50. The alignment itself is right: checked and
> unchecked labels share one left edge, which is what macOS does. But 32 px
> against macOS's ~21 px is another symptom of the same systematic inflation
> as the 28 px rows.
>
> **9. The accent blue is off, and it is the same blue in both appearances.**
> Light highlight is `#178BFB`, dark is `#1994FC`. macOS system blue is
> `#007AFF` light / `#0A84FF` dark. Ours is lighter and cyan-shifted in both,
> and the light→dark lift is 2 levels where the platform's is a real, visible
> step. Minor next to the above, but it is a value read off a palette rather
> than off the platform.
>
> **What lands:** the panel corner radius measures ~6–7 px, which is in the
> right neighbourhood for a macOS menu. The white-on-accent checkmark and
> label in the highlighted row are correct. The label left-alignment across
> checked and unchecked rows is correct.
>
> **One note outside the question, since you supplied the reference:** the
> closed trigger visible at the right of the gallery (the "Toolbar / Apple"
> control) is a pure `#FFFFFF` full capsule about 35 px tall. The reference
> pop-up button is `#ECECEC` on white, 24 px tall, with a ~5 px radius. So the
> trigger is wrong in the same three ways as the menu — fill too light, too
> tall, capsule instead of a small radius. The 28 px menu rows are consistent
> with that inflated trigger, which suggests this is one scale-and-radius
> error applied across the component, not two separate ones.

## What was done with each

Nothing in the reply moved a value, because no finding in it names a value
this checkout can read. The reply converges on one thing, which is the thing
the task already said it would: there is no capture of an open menu, so every
number the menu draws is named rather than measured. That capture is on 425's
list and the reference states the gap under "Also open: the open menu". What
follows is the triage, finding by finding.

**1, the highlight's corner — one misread inside a real finding.** The
reviewer's own reading disproves its conclusion: a corner that starts at x 41
on the first row and reaches x 34 by row 7 is a radius of seven or eight, not
the fourteen the sentence after it claims, and fourteen on a row 28 tall is
what a stadium would be. The pill is drawn at 8, `patterns/sidebar`'s
measured corner. What is real underneath the misread is that 8 with an inset
of 10 is the SIDEBAR's pill and not a menu's, which is what the task said it
would draw absent a capture. Pooled as 645.

**2, the plane is the window background.** This is the task's own stated
fallback: no name in the recorded set is a menu background, so the plane takes
what the Language gives the floating level — the window background under the
platform's shadow — and the reviewer is right that the platform's menu
material is lighter than the window in dark. There is no value here to use
instead. Pooled as 644.

**3, the two appearances read as two constructions.** Both draw the same
hairline, `Separator` flattened over the plane: `#e6e6e6` light and `#343434`
dark. The reviewer saw none in light because the deepest pixel of the plane's
own shadow is also `#e6e6e6` there — the line and the shadow land on the same
value. Real, and unfixable without the capture that says what a menu's edge
is. Pooled as 648.

**4, the shadow is symmetric.** A recorded answer: the reference already
states that one rectangle with one peak cannot be both as deep below a
floating surface and as light beside it as the platform draws, and carries the
same limit for `PaneShadow` and `ToolbarControlShadow`. What is new is that it
is visible on a menu. Pooled as 649 so the limit is not filed twice as a
surprise.

**5, row height and the plane's padding.** The row height is the sizing rule
every stacked row in the library takes and is not this task's. The padding is
real — the first and last pills stand against the plane's own corner — and any
number for it would be invented, so it waits on the capture. Pooled as 647.

**6, the pill on the held row.** The task states the drawing: the pill on the
selection, the check beside the current item. The reviewer's own parenthesis
concedes the two coincide the instant a real pop-up opens, and a still shows
no pointer, which is a briefed misread. The drawing already gives the pointer
the pill wherever there is one and falls back to the held row only when there
is not, which is the behaviour the reply asks for. No change.

**7, the menu is wider than its content.** A recorded answer: the reply's own
sentence offers "or widens it to match the button", and the menu is exactly
the trigger's width. The slack is the gallery cell's, not the component's.

**8, the gutter.** Same class as 1 and 5: 10 + 16 + 6, every part named from
something the reference measures elsewhere, none of it read off a menu. Pooled
with 646.

**9, the blue.** A recorded answer with a real question inside it.
`SidebarSelection` is MEASURED off Voice Memos and the reference states
explicitly that it is neither `controlAccentColor` nor
`selectedContentBackground` — so the comparison against `#007aff` is answered.
What is open is whether a MENU takes the sidebar's pill colour at all or the
content list's `SelectedContentBackground`, which the same capture settles.
Pooled as 650.

**The note outside the question.** The chrome trigger's fill, height and
silhouette are CG5.1's and CG5.3b's, measured off a frontmost toolbar rather
than off a dialog; the reference states that a toolbar control and a dialog
control are different controls in different places and that neither reading
corrects the other. Recorded answer, no change.
