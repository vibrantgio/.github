---
date: 2026-09-17
task: CG2.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG2.1 — the themer read cold beside System Settings' Appearance pane

One reviewer, having seen neither the plan nor the packet, was given the whole
themer window in both appearances at 1x — 1200×900, the size the window opens
at — beside `system-settings-grouped-box-light.png` and
`system-settings-grouped-box-dark.png`, which are the whole System Settings
window on the Appearance pane and so the platform's own choices window. One
question: does this window read as a macOS choices window, and what is wrong
with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam and shows
what is behind the window; still captures show no fade or cursor; alpha
composites in sRGB; the window controls are harness stand-ins and are absent
from these renders; the colour field at the trailing end of the Theme colour
row is a published component the render harness draws as an empty box.

The renders it read were taken before the reply came back and before anything
below was acted on. They differ from the stored goldens in one way that is not
the reply's: their syntax base column lists the whole registry, where the
goldens list a fixed eight names so a stored image cannot depend on which
tests ran before it.

## The reviewer's reply, verbatim

> No. It reads as a web settings page that has been handed the macOS palette. The colour values are right and almost nothing else about the structure is.
>
> What is right, in one sentence: the box fill (#F7F7F7 light, #2A3034 dark), the 20px window margins, the 1160px box width, the ~6px radii, the 24–26px control heights, and the text colours (#262626/#7C7C7C light, #DDDDDD/#9FA2A3 dark) are pixel-identical to the reference captures.
>
> The worst thing in the window is that every unselected choice is painted in secondary grey. "JetBrains Mono" in the Code face box is #9B9B9B with no container at all, sitting beside a filled accent pill — it reads as disabled, not as the other option. Every unselected row in the Syntax base list — borland, bw, colorful, emacs — is #7C7C7C, the same grey as the caption text, so a 36-item list of available choices reads as one live row and four dead ones. In dark it is the same story at #9FA2A3. This is a choices window whose choices look unavailable, which is the one failure that costs the window its job. macOS lists carry primary label colour on every row and mark the selected one by inverting it.
>
> Second: the sectioning is fragmented and the type has no hierarchy. Five one-row boxes each get their own heading, where the platform groups related rows into one box under one heading — the reference puts "Colour" and "Text highlight colour" in a single box under "Theme". Worse, the headings are not headings. "Picture" measures 3.44 ink pixels per column, which is the reference's *row label* weight (3.37), not its group-heading weight (4.36); it is regular where the platform is semibold. And the grey caption is 13px of ink, the same as the heading, where the platform's caption is 11px. Heading and caption differ only in colour, so there is one tier where macOS has three.
>
> Third: the caption strip. Every section pushes a grey sentence fragment out to x≈1178, hard against the window's trailing margin, 1100px away from the heading it belongs to. macOS never does this — secondary text goes inside the box, under the row label, left-aligned ("Choose your preferred look for Liquid Glass."). The eye is forced into a zigzag on every section: heading far left, caption far right, value back at far left inside the box, control at far right again. The copy in that strip is also wrong in register: lowercase fragments with no terminal punctuation, and metaphor where the platform uses plain statements. "the face a fence is set in" is unreadable unless you already know that "fence" means a fenced code block. "Fenced code wears the syntax base; Greet is a word of it quoted into a line" is a riddle for "inline code". "vivid first, not largest" is a note to the implementer, not to a user.
>
> Fourth: in light appearance the light preview window has no edges. Its sidebar paints #F7F7F7 and the Preview box it sits in is also #F7F7F7, with no border and no shadow, so the left 108px of that sample simply is not there — "Library / Recents / Shared" floats in the box. In dark the same sample is a clean white card, and the dark sample is the one that nearly vanishes. Neither sample is labelled Light or Dark; the reference labels every thumbnail (Auto, Light, Dark). A window preview has to read as a window in both appearances, which means a hairline in both.
>
> Fifth: selecting a picture swatch moves everything in the tile. Unselected, the swatch is x467–623 by y119–155 with its hex caption below it in grey. Selected, the swatch is x290–443 by y121–153 — three pixels narrower and four shorter — and the caption has jumped from below the tile to inside it, white on the accent. The ring is 5px thick and butts directly onto the swatch with no gap; the reference draws a 3px ring with a 1–2px gutter of box colour between ring and thumbnail, and the thumbnail itself never changes size. Selecting a colour here makes the row twitch.
>
> Sixth: three blues, none of them the platform's and none of them the theme colour. The "Keep this theme" button and the "#007AFF · macOS" tile are #007AFF. The picture-tile ring, the Roboto Mono pill, the syntax list selection and the light/dark segmented control are all #0064E1 — the pressed shade of system blue, used at rest. The chosen theme colour is #6C9BCE. For reference, this machine actually renders its accent at #157EFB with sidebar selection at #1068DE, so #007AFF and #0064E1 are both stale constants rather than values read off the platform. And the window whose entire purpose is choosing an accent applies system blue to all of its own chrome; only the Preview box honours #6C9BCE, which contradicts the caption sitting directly above the Theme colour row.
>
> Seventh: the dark window background is #1E1E1E — neutral, and 5–8 units darker than the platform's #232A2E — while the box fill #2A3034 matches the platform exactly. One surface was read off the capture and the other was not, so the boxes stand off the background by 12/18/22 where the platform's stand off by 7/6/6, and a blue-grey box sits on a neutral window. In dark the boxes look pasted on.
>
> Eighth: the Theme colour box has no row label. The leading position, where macOS puts the label, holds the value "#6C9BCE", followed by "from scene.png", with the control at the trailing end. The row reads value → provenance → control, which is the platform's order with the label deleted.
>
> Ninth: there is no title. "Themer" sits at x=20, y=29, 12px of ink at #272727 — the same size, weight and colour as the group heading "Picture" eight rows below it. The platform sets its pane title in a 52px toolbar that is visually separate from the content.
>
> Tenth, the Syntax base split view: the list column runs flush to the box edge with zero inset while the panel beside it is inset 10px on three sides, and the two surfaces (#F7F7F7 and #FFFFFF) meet at x=234 with no hairline between them. The scrollbar thumb floats at x≈213, 21px inside the column's own right edge, with no track. And the five visible rows are vertically centred with about 20px of empty box above and below, so a scrolling window into 36 items looks like a complete list of five that happens to have a scrollbar next to it.
>
> Lesser, but still wrong. The prose line in the preview panel is pure #000000, darker than any heading in the window — explanatory sample copy is the most prominent text on screen. In dark, the code block is #1E1E2E on a #1E1E1E panel, a 16-unit difference in one channel, so the syntax base colour that the preview exists to demonstrate is carried entirely by a 1px #343442 border. The panel itself is a white surface nested inside a grey grouped box with a third bezelled surface inside that — three stacked surfaces where macOS uses one. And the Picture row mixes a 62px bordered thumbnail with six 36px pills, the first of which is the system accent presented in exactly the same shape as five colours sampled from the image, distinguished only by the word "macOS" in its caption.

## What was done about each

**Fixed in this task.**

- *Every unselected choice painted in the muted step.* `ChoiceRow` now sets an
  unchosen row's words in the platform's label colour, which is the colour the
  platform's own lists carry on every row. Both choosers take it, so the code
  faces and the syntax bases read as available.
- *The headings are not headings, and there is one tier where the platform has
  three.* The window's name is `TitleLarge`, a group's title `TitleMedium`, a
  row's words `BodyMedium` and a caption `BodySmall`: four tiers that differ in
  size as well as weight. That also answers the ninth point — the window's name
  is no longer the group heading's twin.
- *The caption strip at the trailing margin, and the zigzag it forces.* Every
  hint now stands beside the title it belongs to.
- *The copy's register.* Each hint is a sentence with a capital and a stop, and
  the metaphor is gone: "the face a fence is set in" is now "The typeface a
  code block is set in", and the sample's own prose line reads "A code block
  wears the syntax base, and `Greet` is inline code in a line of prose."
  "vivid first, not largest" became "Vivid colours first, not the largest
  areas; the percentage is each colour's share of the picture."
- *The light preview window has no edges, and neither sample is labelled.* Each
  sample carries its own edge — `Separator` over the chrome material — and its
  title band names the appearance it is drawn in.
- *Selecting a swatch moves everything in the tile.* The chosen colour is now
  marked by a ring round its swatch and by nothing else: 3 points of the
  platform's accent with 1 point of the box's fill between the ring and the
  swatch, which is what the Appearance pane's own selected thumbnail measures
  (`system-settings-grouped-box-light.png`, the ring at x 455–457 and y 62–64
  with the box's fill at x 458). The swatch keeps its size and its place and
  the caption keeps its colour and its place; a test pins the swatch's own
  pixel across the choice.
- *The Theme colour box has no row label.* The row now leads with "Colour",
  then the value, then where it came from, with the controls at the trailing
  end.
- *Two surfaces meeting with no hairline in the syntax base box.* The sample's
  plate carries a line of its own.

**Pooled, with the reason.**

- *Five one-row boxes where the platform groups related rows under one heading.*
  The four groups and their order are the task's own text; merging them is a
  change to what the window is, not to how it is drawn. Pooled as item 449.
- *Three blues, and two of them stale constants.* `ControlAccent` #007AFF and
  `SelectedContentBackground` #0064E1 are token values that serve every
  application in the checkout, and the reviewer's own measurement of this
  machine — accent #157EFB, sidebar selection #1068DE — is corroborated by the
  Appearance pane's selected-thumbnail ring at #157EFB. Pooled as item 450.
  That the window's own chrome follows the desktop rather than the chosen
  colour is the standing ruling, not a defect.
- *The dark window background is neutral where the platform's is blue-grey.*
  Another token value, and the same class of finding. Pooled as item 451.
- *The scrollbar thumb floats with no track.* The scrollbar component's, not
  this window's. Pooled as item 452.
- *The preview's prose line is pure black, darker than any heading.* That is
  `markdown.FromTokens` taking the platform's text colour for body copy, which
  every reader of a markdown document gets. Pooled as item 453.
- *In dark the code block's own fill all but coincides with the plate under it.*
  A base's background against the page the plate paints. Pooled as item 454.
- *The platform's accent cell has the same shape as five colours out of a
  picture.* Moving it into the theme colour group is the structural answer and
  wants the room a group has. Pooled as item 455.
- *A scrolling window into 36 names that looks like a list of five.* Already
  pooled as item 446 before the reply came back, with the component that would
  replace it named.
