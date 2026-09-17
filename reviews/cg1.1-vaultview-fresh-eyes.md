---
date: 2026-09-17
task: CG1.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG1.1 — the vault window read cold beside a Mac window

One reviewer, having seen neither the plan nor the packet, was given the
whole vault window in both appearances at 1x — the task's own
`window-light.png` and `window-dark.png` goldens, 1100×800, the size the
window opens at — beside `chatgpt-window-light.png`, `finder-window-light.png`
and `finder-window-untinted-dark.png`, and one question: does this window read
as one macOS window, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam and shows
what is behind the window; still captures show no fade or cursor; alpha
composites in sRGB; the window controls are harness stand-ins.

The renders it read carry the rail's find field inset 8 from the rail's edges
where the shipped ones carry 10, and the rail's foot rule running the rail's
full width where the shipped one stands on the rail's lane. Both moved after
the reply came back and neither is anything the reply turns on.

## The reviewer's reply, verbatim

> I read all four images and sampled pixels from ours against the two Finder captures and the ChatGPT capture.
>
> **Short answer: not quite. The base materials are right, but one pane is built differently from the rest, and the window reads as two designs stitched together rather than one.**
>
> What is right is worth saying first, because it narrows where the fault is. The sidebar fill is #F7F7F7 against #FFFFFF content in light and #1C1C1C against #1E1E1E in dark; Finder's own values in those same captures are #FAFAFA/#FFFFFF and #1C1C1D/#1E1E1E. That is a match. The seam between the sidebar and the content is #919191 in light — pixel-identical to the seam in the ChatGPT window — and #3D3D3D in dark against Finder's #434343. Body text, the heading scale, the link colour and the Properties table all sit comfortably. Nothing in the middle column made me doubt it.
>
> **The grey slab around the sidebar.** This is the fault that breaks the window. The sidebar is not a pane; it is a rounded card floating in an 8px-wide well of flat grey — #A1A1A1 in light, #282828 in dark — that wraps it on the left, the top and the bottom. The card has a ~6px corner radius on all four corners, so at the top-right (around x=243, y=8) and bottom-right (x=243, y=791) the white content bleeds into the notch and the sidebar/content seam stops being a straight full-height line. In light the step from #F7F7F7 card to #A1A1A1 well is enormous — it is by far the darkest area in the window, a picture-frame matte around the file tree. In dark it inverts: the well at #282828 is *lighter* than both the sidebar and the content, so it reads as a light rim instead. I checked whether this could be the desktop showing behind the window: it cannot. At y=0 and y=799 the content runs pure #FFFFFF to the pixel edge and the right panel runs #F7F7F7 to x=1099 with no surround at all. The grey exists only around the left pane, which means it is inside the window. Neither Finder nor ChatGPT has anything like it; in both, the sidebar material runs straight into the window's own edge.
>
> **The right panel is built to different rules than the left.** The Outline/Backlinks panel is flush to the window edge with square corners and no inset, while the sidebar is inset and rounded — same window, two constructions. Its seam is also far too faint: #E6E6E6 in light where the left seam is #919191, and #343434 in dark where the left is #3D3D3D. In the light render that right-hand seam almost disappears and the panel stops reading as a separate pane. And the panel's content column is lopsided: rows begin 9px from its left edge but stop 32px short of its right. Both the "Reading list" selection pill and the hairline above "Backlinks" end at x=1067 in a panel that runs to x=1099, so there is a visible dead margin down the right that nothing explains.
>
> **Two focused selections at once.** The sidebar's "Reading list" row and the Outline's "Reading list" row are both painted #178BFB — I sampled them and they are the same value to the digit. A macOS window gives full accent fill to the focused list only; the other shows an unfocused grey selection. As drawn, two lists claim focus simultaneously. Separately, that blue is #178BFB in *both* appearances — macOS moves from #007AFF in light to #0A84FF in dark, and ours does neither.
>
> **Secondary text is one step too faint, in both appearances.** "Outline", "Backlinks" and "No notes link here" are #B7B7B7 on #F7F7F7 in light and #545454 on #1C1C1C in dark. Finder's equivalent section headers in these same captures are #7B7B7A on #FAFAFA and #989898 on #1B1B1B. Ours are roughly half the contrast in both directions — the light ones hover at the edge of legibility and the dark ones are dimmer still. The Outline's unselected rows have the same problem in dark at #999999 where Finder's sidebar rows sit at #F4F4F4.
>
> **Dark mode picks up a colour cast the light mode does not.** Both code fills in dark are #1E1E2E — blue-violet, with the blue channel 16 above red and green — in a window where every other dark surface is strictly neutral. The two push buttons in the sidebar footer are #333A3F, a blue-slate, against a neutral #1C1C1C sidebar; Finder's dark toolbar buttons are a neutral #3D3D3D. In light both of these are neutral, so the cast is dark-only and looks like a syntax theme and a control style imported from somewhere else.
>
> **Scrollbars are too heavy.** The vertical knob is an opaque #6D6D6D on white and #9F9F9F on #1E1E1E — solid slabs, not the translucent overlay the platform draws. The code block's horizontal scrollbar is the worse of the two: it is parked flush on the block's bottom inner edge, running nearly its full width, so it eats the block's bottom padding, cuts across the bottom rounded corners, and reads as a progress bar sitting under "func main() {}" rather than as a scrollbar.
>
> **The sidebar-toggle icon.** It is pure #000000 with square corners and three little tick marks inside the left pane that turn to mush at 1x. The same symbol in the ChatGPT window is a #777777 rounded rect with a single clean divider. Ours is the darkest mark in the whole sidebar — darker than the sidebar's own labels — so the eye goes to the toggle before it goes to the selected note.
>
> One thing I will flag but not press: all four outer corners of the render are square, where both reference windows are rounded. Given that the traffic lights are harness stand-ins, the frame may simply not be yours to draw, so I mention it only as something I can see.

## Disposition

**Fixed here.**

- The sidebar-toggle mark. It was drawn in `PlatformColors.Text` — pure
  black — which made it the darkest thing in the rail. It is now the
  platform's secondary label flattened onto the fill it stands on, which is
  the name `patterns/sidebar` already draws its own collapse mark in. It
  reads `#7c7c7c` on the rail against the `#777777` the ChatGPT window draws.

**Recorded misreads.** Each was checked against the stored captures with PIL
before being set aside; the first two are new and belong in the next brief.

- **The grey well around the sidebar is what macOS 26 draws.** The reply's
  headline finding rests on "neither Finder nor ChatGPT has anything like it;
  in both, the sidebar material runs straight into the window's own edge."
  `chatgpt-window-light.png` says otherwise, and to the byte: at y=400 the
  window's own opaque bounds begin at x=56, then `#a1a1a1` for seven columns,
  then one column of `#919191`, then the sidebar's `#f7f7f7` from x=65 — the
  same eight-pixel well and the same hairline our render draws. It runs down
  the sidebar's left, its top and its bottom only: at column 600 the content
  runs `#ffffff` from y=38, at row 400 it runs `#ffffff` to x=1186, and the
  sidebar's own hairline at column 303 has rounded caps at y≈52 and y≈883.
  `voicememos-sidebar-light.png` shows the same floating sidebar. The
  platform's sidebar is an inset rounded panel on the window's plane; ours
  reproduces it, and the well is the under-page grey the plane is painted in.
  The reviewer's own sentence — the seam is "pixel-identical to the seam in
  the ChatGPT window" — is that measurement read the other way round.
- **The dark pill is not the light one.** The dark render's pill measures
  `#1994fc` and the light one `#178bfb`, which are the two values
  `voicememos-sidebar-{light,dark}.png` were read for. `controlAccentColor`
  is `#007aff` in both appearances on this machine (`nscolors.tsv`), so
  "macOS moves from #007AFF to #0A84FF" is not what this platform reports.
- **Finder's `#FAFAFA` is the tinted reading.** `finder-window-light.png` was
  taken with window-background wallpaper tinting on. The untinted pair
  measures `#f7f7f7` light and `#1c1c1c` dark, which is what the reference
  records and what we paint; the reviewer read the tinted capture and still
  called it a match.
- **The square outer corners** are the golden's, not the window's: the stored
  image is the window's plane alone and the platform rounds the frame. The
  reviewer flagged this as a maybe and was right to.

**Already pooled.**

- Two lists at the emphasized selection at once: items 411 and 412, the
  key-window state, and the same complaint in CE3.2's finding 2.
- The section headings' and empty lines' faintness in both appearances:
  CE3.2's finding 5, held by item 428.
- The dark code fill `#1e1e2e`: CE3.2's finding 12, held by item 428.
- The push buttons' `#333a3f`: item 425, `PushButtonFill` dark measured over
  the tinted plane.
- The scrollbars' weight and the code block's horizontal bar: item 342.

**New for pooling.** Items 435 and 436 below the section this review opened.

- The inspector's trailing lane: its rows begin one lane (10) inside the
  column and stop one lane plus the scrollbar's reserved gutter (31) short of
  it, so the pill is not inset alike on both sides the way the rail's is. The
  gutter is real — the note column reserves the same one — and closing it
  means the inspector's bar floats over its rows where the note's does not,
  which is a second scrollbar convention in one window. It is pooled rather
  than painted.
- The two boundaries' unequal strength: the sidebar's edge reads `#919191`
  because the separator lies on the window's plane, the inspector's `#e6e6e6`
  because it lies on the content. Both are the Language's seam rule applied
  correctly, and they do not look like one window.
