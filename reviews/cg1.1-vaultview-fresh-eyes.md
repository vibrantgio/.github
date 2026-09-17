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

# CG1.1, second pass — the rail leaves the plane it was set into

The first pass kept the rail in `patterns/pane`: a rounded column set one
margin inside the window's leading, top and bottom edges with a hairline
round it, on the window's own plane. That was wrong, and the worker's
ruling defending it was wrong with it.

`finder-window-untinted-light.png` settles it. At row 500 the sidebar's
`#f7f7f7` runs to x=351 and the content's `#ffffff` begins at x=352, with no
hairline between them in 112 of 114 sampled rows; at x=200 the fill runs to
the window's own top and bottom opaque bounds. The dark capture agrees on
three sides and draws one pixel of `#434343` on the fourth. The eight-pixel
band that shows left of the light sidebar is the rim macOS 26 draws inside
the window frame, which is the platform's and not the application's to
paint — and the dark capture does not carry it at all. The `#a1a1a1` and
`#919191` read off `chatgpt-window-light.png` in the first pass are that
window's own shadow and rim, not a plane with a panel inset on it.

So `patterns/pane` became the flush chrome column — the run to the window's
leading, top and bottom edges and one seam to what stands beside it — and
every rail that passes it through moved with it: vaultview's, mindchat's and
the gallery's own specimen. The inspector was re-measured the same way and
was already right.

The renders below are the task's own `window-light.png` and
`window-dark.png` goldens at 1x, 1100×800, beside `chatgpt-window-light.png`
and the two untinted Finder captures. The brief carried the first pass's
misreads forward and added the operating system's rim, the square outer
corners, the two measured pill values, and the four findings already filed.

## The reviewer's reply, verbatim

> Yes — at a glance it reads as a macOS window, and the bones are right. The pane tones are exactly the platform's: sidebar #F7F7F7 against #FFFFFF content in light and #1C1C1C against #1E1E1E in dark, which is pixel-for-pixel what the untinted Finder captures show, and the right-hand panel correctly takes the sidebar's tone rather than inventing a third. The sidebar row pitch is 32px, the same as Finder's. The selection pill, the breadcrumb, the disclosure chevrons and the outline indent-by-heading-level all behave. Both appearances hold together as the same window. The faults are these.
>
> **The search field has no field.** In light, the "Find a note…" box is filled #F7F7F7 — bit-identical to the sidebar behind it — and outlined with #F3F3F3, four levels off the surface. There is nothing there to see; at 1x it is a magnifier and some placeholder text with a ghost of a rectangle. Finder's search field is #F7F7F7 sitting on the #FFFFFF toolbar, an eight-level recess carried by fill and no stroke at all. Ours has the stroke and not the recess, and the stroke is below the threshold of visibility. In dark the same box is filled #1C1C1C, again identical to the sidebar, but its border is #2C3338, which is strong enough to see — so the control is plainly visible in dark and effectively absent in light. Finder's dark search field is #262626 on a #1E1E1E backdrop, again an eight-level fill step.
>
> **The dark window's control chrome is tinted blue.** Every grey in the dark render is neutral — #1C1C1C sidebar, #1E1E1E content, #323232 and #343434 seams, #DDDDDD and #999999 text — except the controls. The "Rescan" and "Switch Vault" fill is #333A3F, the buttons' border is #3E4449, and the search field's border is #2C3338. All three carry 4–6 levels more blue than red. At 1x the two footer buttons read as faintly blue slabs in the bottom-left corner against an otherwise dead-neutral window. The same buttons in light are #ECECEC, perfectly neutral, so the pair does not match across appearances.
>
> **The note text is pure black and pure white; nothing else in the window is.** The document title "Second Brain", the H1 "Reading list", both H2s, the paragraphs and the bullet items all have glyph cores at #000000 in light and #FFFFFF in dark. Every other label in our own window uses the platform value — the sidebar items are #262626/#DCDCDC, the breadcrumb's current page is #272727/#DDDDDD — and that is also what Finder's filenames and ChatGPT's body copy measure at (#272727 light, #DDDDDD dark). So the breadcrumb "Reading list" at y=55 and the heading "Reading list" 160 pixels below it are painted two different blacks, and in dark the whole note body is glaring white where the chrome around it is correctly held back.
>
> **The right-hand panel's contents are shoved against its left edge.** The panel occupies x=781–1099. The selected "Reading list" pill and the hairline above "Backlinks" both run x=790–1067: nine pixels of inset on the left, thirty-two on the right. The blue selection bar visibly stops well short of the window's right edge while hugging the divider side, and the Backlinks rule does the same. The sidebar's own pill is inset 10 left and 9 right, so the two list panels are built to different rules.
>
> **The three panes start and stop at three different heights.** At the top, the sidebar's toggle icon occupies y=18–33 and the title "Second Brain" y=19–30, but the right panel's first element, the "Outline" heading, does not begin until y=47 — a 28-pixel hole in the top-right corner with no header in it. At the bottom it is worse: the sidebar has a footer with an inset hairline at y=759 and buttons at y=770–789; the content pane's "29 lines" floats at y=783–792 on bare white with no footer rule, band, or separation from the document above it, seven pixels from the window edge; and the right panel simply runs out of text at y=758 with forty pixels of empty grey below. Nothing along the bottom edge relates to anything else.
>
> **The note's vertical scrollbar is full length on a document that fits.** The thumb runs x=766–771, y=198–744 — 547 pixels, essentially the whole track — beside a note whose last element, the code fence, ends at y=740 with all three of its outline entries visible on screen. A thumb that spans its own track is a scrollbar indicating nothing; macOS would not draw one. I am reporting its length and presence, not its weight or colour.
>
> Two smaller ones. The two pane seams are drawn at different strengths — the sidebar/content divider is #DFDFDF and the content/panel divider is #E6E6E6 in light (#323232 and #343434 in dark) — so the left seam is measurably harder than the right. And the light-mode "29 lines" is #969696, while the sidebar's own secondary text ("Find a note…", the outline items) is #7C7C7C, which is the platform's secondary label; in dark both are #9A9A9A and correct, so only the light status line drifts pale.
>
> Geometry of the footer buttons, for the record: 20 pixels tall with 8 pixels of padding beside "Rescan" — short and tight for a macOS push button, and painted a fill darker than the surface they stand on with a border only eleven levels off their own fill, so they read as flat recessed patches rather than raised controls.

## Disposition

**Fixed here.** Nothing from this reply. The window it read is the window
this pass built; every fault it names is either already filed or a question
the reference answers three different ways, and none is the plane the pass
was reopened to remove.

**What the reply confirms.** The pane tones, the 32 px row pitch and the
inspector taking the sidebar's own fill rather than a third one are what the
untinted Finder captures measure, and the reviewer sampled them
independently. The plane is gone and nothing replaced it.

**Recorded misread.**

- **The note's scroll indicator is not on a note that fits.** The golden
  note is taller than its viewport — `TestNoteScrollbarOnlyWhenTheNoteOverflows`
  is the assertion that an indicator appears only when it is — and the thumb
  runs y 198–744 in a track of very nearly that length because the note
  overflows by a few rows. The reviewer's reading of the pixels is right and
  the conclusion is not. What is left of the finding is real and is filed
  below: an indicator that spans its own track tells the reader nothing.

**Already pooled.**

- The dark controls' blue cast — `PushButtonFill` `#333a3f` and `FieldEdge`
  `#2c3338` — is item 425: both dark values were measured over the tinted
  `#232a2e` plane and carry the reference desktop's cast against the
  untinted `#1e1e1e` window. The reviewer found it a third time,
  independently, and adds the button's border `#3e4449` to the list.
- The note's prose at pure black and pure white where every label around it
  takes the platform's is item 427, `textColor` against `labelColor`.
- The inspector's rows inset 9 leading and 32 trailing is item 435, filed in
  the first pass with the same measurement.
- The two seams at `#dfdfdf` and `#e6e6e6` is item 436, which this pass
  brought from `#919191`/`#e6e6e6` to those two.

**New for pooling.** Items 439 to 443.

- The search field, which is the reply's first finding and its strongest.
  The task named the save dialog's field and `FieldEdge`, and that is what
  this window draws; the reference does not agree with itself about what a
  SEARCH field on a chrome rail is, and the answer the task named is
  invisible in light. Measured for the item rather than painted.
- The three columns' tops and feet not relating to one another.
- The scroll indicator spanning its whole track.
- The light status line one tier pale.
- The foot's push buttons reading as recessed patches on a surface lighter
  than their own fill.
