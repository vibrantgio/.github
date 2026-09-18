---
date: 2026-09-18
task: CG5.3n
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3n — vaultview's sidebar read cold beside Voice Memos and Finder

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: vaultview's whole window in the light and the dark
scheme (`workbench/vaultview/testdata/golden/window-{light,dark}.png`, the
goldens this task regenerated) and two macOS 26 windows — the owner's own
`voicememos-multi-folder-2026-09-18.png`, light over a black desktop, and
`finder-window-untinted-dark.png`. It was told which two are the platform's,
given the recorded misreads — a dark label reads grey at 1x; a still shows no
fade and no cursor; a coverage composites in encoded sRGB; the window controls
are harness stand-ins and the light render draws none; a pointer target is
invisible in a still; the earlier CG1.1 review called this panel "a grey slab
neither Finder nor ChatGPT has" and THAT was the misread, the panel being the
platform's own sidebar; the column on the right is out of scope by the owner's
word; an open menu is CG5.4's and focus CG5.5's — and asked one question:

> Does this window's sidebar read as the sidebar in the reference window, and
> what is wrong with it?

## The reply, verbatim

I read all four images at 1x and measured the pixels rather than trusting my eye.

**The answer is yes — it reads as the platform's sidebar, and most of it is right to the pixel. What is wrong is that it does not sit on top of the content: it casts almost no shadow, and in the light appearance its right edge disappears entirely.**

**What is right.** The panel is inset 8 px from the window's left, top and bottom edges: the rim lands at x=8, y=8 and y=791 in an 800-tall window. Voice Memos is inset by exactly the same 8 px (window edge x=56, rim x=64; window top y=38, rim y=46; rim y=786, window bottom y=794), and so is Finder in dark. The outer corner radius measures about 14–15 px against the reference's 14. The panel is bounded by a 1 px light rim, 255 in light and 58 in dark, where Voice Memos uses 255 followed by a 253 second pixel and Finder dark uses 58. The light fill is a flat 247 against the reference's 249–250; the dark fill is 28 against Finder's 27–33, with the window background at 29 and the content pane at 30 — Finder's dark sidebar is just as close to its surroundings, so the near-invisibility in dark is correct, not a defect. The rows are on a 32 px pitch, same as both references. The label ink measures (38,38,38) in light — identical to Voice Memos to the value — and (220,220,220) in dark, which is the 85 % white the platform uses; Finder happens to run brighter at 244, but ours follows the standard. The selected row is the strongest part: the pill is (23,139,251), which is Voice Memos' selection colour exactly, 32 px tall, inset 10 px from the panel's left and 9 px from its right against the reference's 10 and 10, with a corner radius of 6–7 px against the reference's 6–7. The search field's fill is (232,232,232), which is again Voice Memos' field fill exactly, and it lines up with the row pills at x=18..237. The sidebar's own toggle button sits 18 px below the panel top; Voice Memos' two buttons sit 18 px below theirs.

**What is wrong.** The panel casts no shadow onto the content pane. In Voice Memos, the pixel immediately right of the sidebar's rim is 244 and ramps back to 254 over roughly 30 px — that gradient is the whole reason the panel reads as floating over the document. In our light window the content is 255 at x=248 and 255 at every pixel after it. The joint is flat and butted, so the sidebar reads as a region the window was divided into rather than a panel laid on top of one.

Made worse by the rim: we paint the right rim pure 255, and the content pane is also 255, so in light the panel's right boundary is carried by nothing but the 247-to-255 fill step. The reference's 255 rim reads as a bright edge precisely because it stands against 244 of shadowed content. Fix the shadow and this fixes itself.

The bottom shadow is a flat band, not a shadow. Below the panel, rows y=792 to 799 read a constant 242 across x≈15 to 242 and stop dead at the sidebar's own width. Voice Memos runs 227, 228, 229, 229, 230, 231, 232, 234 over the same 8 px — darker at the panel and lightening away from it. Ours is about 15 levels too light at the edge and has no falloff at all, so at 1x it reads as a grey strip ruled under the panel. The left and top shadows, by contrast, are correct: left goes 246, 246, 245, 245, 244, 244, 243, 243 against the reference's 245 to 239, and the top runs 251 down to 247 against the reference's identical 251 down to 247.

The rows carry no icons. Every row in both references has a glyph in a fixed 20 px column — waveform, trash, folder, clock, app icon, tag dot — with the label starting 48 px in from the panel's left rim. Our rows are text only, and the disclosure chevron sits in the place the icon would occupy, so the list reads as a plain outline rather than a platform sidebar list. There is also no alignment column: a depth-1 label starts at x=48, a depth-2 label at x=61, so the left ink edge shifts row to row.

There are no section labels at all. Voice Memos sets "My Folders" at (125,125,125) in a 10 px ink band with extra leading above the group; Finder does the same three times with (152,152,152). Our sidebar runs from the search field to the last row as one undifferentiated tree. The cost is visible: "Sources" sits at x=47, on the same indent column as "Design" and "guide", while "Reading list" directly above it sits at x=61 — so either "Sources" is a sibling that is under-indented by 14 px, or it is a root item that returns to the top level with no gap, no label and no cue of any kind. Either way the hierarchy is unreadable at that seam, and a section label is what the reference uses to solve it.

One small thing in dark: the search field fill is (47,50,52), a +19 step over the 28 panel and carrying a slight blue cast, where everything else in the panel — fill 28, rim 58, labels 220 — is strictly neutral. Finder's field is a neutral (38,38,38), +8 over its background. Ours is the loudest thing in the dark panel after the selection.

Two minor notes, well below the above: the reference's dark sidebar fill has a gentle left-to-right lift, 27 at the left rim to 33 at the right, which is what gives the material its depth; ours is a dead-flat 28. And Finder brightens the rim on the side facing the content, 67 there against 58 elsewhere; ours is 58 all the way round.

## What was done with it

**The task's own result is read back cold and confirmed.** The reviewer,
measuring the images rather than being told anything, returned the inset at 8
on three sides against the reference's 8 on all four captures; the 1 px rim at
255 light and 58 dark; the panel's corner at "about 14–15 px against the
reference's 14", which is the two agreeing with each other; the fill flat at
247 light and 28 dark; the row pitch at 32; the selection pill at (23,139,251),
32 tall, inset 10 and 9 against the reference's 10 and 10, cornered at 6–7; the
label at (38,38,38) "identical to Voice Memos to the value"; and the toggle 18
px below the panel's top, "Voice Memos' two buttons sit 18 px below theirs".
It also answered the CG1.1 misread on its own: the dark panel's near-invisibility
against its surroundings "is correct, not a defect", because Finder's is as
close.

**The first finding was a real defect and is fixed.** The panel cast no shadow
on the content at all — the reviewer measured 255 at every column right of the
rim where the reference ramps 244 back to white. The cause was op order: a
window's document column paints its own surface AFTER the pane has laid out,
because the pane comes first in the reading order, and that painting covered
the ramp the panel had cast. `patterns/pane` no longer paints the shadow inside
`Layout`; `PaintShadow` cuts the panel's own rounded box out of the drawing so
it lands the same image wherever it is called, and vaultview and mindchat call
it once their columns are down. The content beside the rim now reads 243 and
recovers over the reach in the light appearance, against the reference's 244.
The reviewer's second paragraph — the right rim carrying nothing because both
sides are 255 — is the same defect, and it closed with it, as the reviewer
said it would.

**The bottom band is the shadow model's recorded limit and is filed, not
fixed.** The reviewer read the 8 px below the panel as a flat 242 where the
reference runs 227 to 234. The library spreads a shadow as one linear ramp from
one peak at the edge of a rectangle sunk below the shape, and the sink is 9
against a margin of 8, so the whole margin lies inside the rectangle and draws
the peak flat. The reading that fixes it — a deeper, blurred, top-lit lobe
below — is not a shape the library draws, and the fit that lands the other
three sides at an rms of 1.19 of 255 is the one that is drawn. Filed as 622
with the numbers.

**Two findings are about the rail's CONTENT, which this task does not
touch.** The rows carrying no icon in a fixed column, and the tree having no
section labels, are `workbench/vaultview`'s folder tree and not the panel the
task is about — the reviewer was asked about the sidebar and read the whole
column, which is the right thing for fresh eyes to do. Both are filed, 627 and
628, with the indent seam the reviewer measured at "Sources".

**Three small findings are filed rather than acted on.** The dark search
field's +19 blue-cast step is `SidebarSearchFill`, measured by CG4.8 off System
Settings, and the reviewer's Finder reading disagrees with it: filed as 629.
The dark material's left-to-right lift the reviewer noticed is the same reading
this task's own measurement made and is filed as 623. The rim brightening on
the side facing the content is recorded in `controls.md` and in the token's own
comment — `#404040` through the band and `#434343` below it, against `#3a3a3a`
on the three sides over the plane — and one value is carried on purpose; the
reviewer's 67 against 58 is that same pixel.

**One reading is the reviewer's own arithmetic and stands unchanged.** The
pill's inset "10 px from the panel's left and 9 px from its right" is one pixel
of asymmetry in `patterns/sidebar`, which the reference does not have. Filed as
630.
