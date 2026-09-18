---
date: 2026-09-18
task: CG5.3l
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3l — vaultview's whole window read cold beside the Finder and Mail bands

One reviewer, having seen neither the plan nor the packet nor any source, was
given six images at 1x: vaultview's whole window in the light and the dark
scheme with the find shut and the same pair with a find open
(`workbench/vaultview/testdata/golden/window-{light,dark}.png` and
`window-find-{light,dark}.png`, the goldens this task regenerated), and two
frontmost macOS windows — `finder-window-light.png` and `mail-window.png`,
the two captures whose bands this task's composition was measured from. It was
told which two images are the platform's, given the recorded misreads — a dark
label reads grey at 1x; the light sidebar material is the content's white told
apart by a seam; a still shows no fade and no cursor; a coverage composites in
encoded sRGB; the window controls are harness stand-ins; a pointer target is
invisible in a still; an open menu is CG5.4's and focus CG5.5's; the paint of
the boundary below the band is pool 437's; the toolbar title's weight is
typography and stays by ruling — and asked one question:

> Does this window read as a macOS window with its toolbar, and what is wrong
> with it?

## The reply, verbatim

I've read all six at 1x and measured against the two real captures. Here is my answer.

---

**Short answer: the bones are right and the surface is wrong. The toolbar is the correct size and its items are the correct size and are correctly placed, but it has no material of its own, and the things sitting in it are painted as floating buttons rather than toolbar items. In light it does not read as a macOS toolbar; in dark it very nearly does, for a reason that turns out to be an accident.**

**The metrics that are right, so they can be left alone.** The band is 52pt: the pane dividers at x=240 and x=780 begin at exactly y=52, and Mail's toolbar hairline sits at y=51, so the height matches. Every item in the band — all three circular buttons, the sidebar toggle, and the find field — occupies y=8..43, a 36pt item with 8pt of clearance above and below. Finder's capsules occupy y=8..43 to the pixel, and Mail's five toolbar items do too. The trailing inset is 8pt (last item's right edge at x=1091, window edge at 1099); Mail's is also 8pt (1191 against 1199). The find field is 220×36, the same shape family as Mail's 325×36 search field. The title's cap height is 10pt spanning y=20..29; Finder's "Applications" spans y=19..29 to the baseline. None of that needs touching.

**The central defect: the toolbar band has no material. It is three tiles wearing the fills of the panes underneath it.** Scan y=5 across our light window and you get 247 from x=0 to 239, a hard step to 255 from x=240 to 779, and a hard step back to 247 from x=780 to 1099. Two vertical steps, no divider, no transition, no blend — the fills of the sidebar, the note and the outline panel simply run up through the toolbar to the top edge of the window. Both real captures do the opposite. Finder's toolbar at y=3 reads 250 over the sidebar, climbs smoothly to 255 across the middle, and falls to 251 near the trailing edge — that's the wallpaper coming through one continuous vibrant sheet, and critically there is *no step at all* where the sidebar boundary at x=320 passes underneath it. Mail is even blunter: at y=5 the band reads (35,42,46) at x=100, at x=390, at x=395, at x=600, at x=900 and at x=1100 — one flat value across the entire 1200pt width, sitting over a sidebar on the left and over a content pane that is pure white below y=160. Mail's sidebar/content divider is jet black (0,0,0) and it does not start until y=55. In macOS the toolbar is a sheet laid *over* the window's split. In ours the split is drawn *through* the toolbar. That single inversion is most of why the window doesn't read right.

This is also why the dark render nearly passes: the same three tiles are there in dark (28, 30, 28), but the step is two levels instead of eight, so it's invisible. The toolbar isn't more correct in dark; it's the same defect hidden by a smaller pane-fill delta.

**The x=780 step is not theoretical — a button straddles it.** In the find state the folder button's centre lands at x=790.5, so 8.5pt of a 37pt disc sits on the white content fill and 28.5pt sits on the grey panel fill. Its left half is a 255 disc on a 255 backdrop with no edge contrast whatsoever, and its right half has an 8-level edge. At 1x you can see the seam entering the button at the top and leaving at the bottom. It reads as a rendering fault.

**The buttons carry drop shadows, and macOS toolbar buttons do not.** Each 37pt disc sits in a soft shadow with roughly 14pt of lateral blur and about 8pt of downward offset, dipping the backdrop from 247 to 238 — an alpha near 0.035. Under the refresh button the backdrop does not recover to 247 until y=75, which is 32pt below the button and 23pt below the toolbar band itself. Under the sidebar toggle the shadow lands on the Search field and darkens its top edge to 227–231 against the field's own 232, so a toolbar button is tinting a control in the pane below it. Finder proves the platform does none of this: the eight rows beneath a toolbar capsule (x=712, y=44..51: 244,244,245,245,245,246,246,247) are byte-identical to the eight rows in the empty gap beside it at x=860. Mail's items are a 1px stroke with an almost-transparent fill — its compose button's interior is (36,45,50) against a (35,42,46) band, a three-level lift — and no shadow at all. Ours are lit like floating action buttons. That, more than the icon shapes, is what makes the band read as "a white strip with three pills hovering over it" rather than as a toolbar.

**And the shadow is clipped inconsistently, which gives the band away.** Over the content column the shadow stops dead: at x=737 in the find render it reads 246 all the way down to y=51 and then snaps to 255 at y=52. Over the sidebar and the outline panel the same shadow from the same button run continues past y=52 to y≈75. One shadow, two z-orders, decided by which pane happens to be underneath. That is the same root cause as the tri-tone: the toolbar isn't a layer, it's three pane-tops.

**Toolbar icon ink is about twice as dark as the platform's in light.** Every icon in Finder's light toolbar bottoms out at exactly 77 (#4D4D4D) — the list-view glyph, the share/tag/more group, the magnifier, all 77. All four of ours bottom out at 39 (#272727), which is the note-body ink. The result is that the toolbar shouts louder than the document it frames. Dark is fine and should be left alone: ours peaks at 222 against Mail's 234.

**Nothing is grouped.** macOS runs related toolbar items into one shared capsule with hairline dividers: Mail's reply / reply-all / forward is a single 110pt capsule, archive / delete / junk is another 111pt capsule, folder+chevron is 52pt, flag+chevron is 73pt, and Finder's share / tag / more is one capsule. The spacing carries meaning — 7pt between clustered capsules, 27pt to set the compose button apart. Ours is three isolated 37pt discs at 15pt and 16pt gaps: neither the 7pt of a cluster nor the 27pt of a separation, and with no capsule and no dividers, so nothing says that refresh and reveal-in-Finder are a pair while search is not. The word for the shape we have is "three buttons"; the word macOS uses is "two groups".

**The toolbar carries the wrong things.** Finder puts back/forward in the toolbar as one segmented capsule with a hairline between the chevrons, immediately to the left of the window title. Our back/forward are bare 11pt chevrons at (272,85) and (296,85) — below the band, inside the content pane, with no capsule, no divider and no visible hit target — sitting in a breadcrumb row whose parent crumb is painted link-blue, a web idiom where Finder's path crumbs are plain label colour. Meanwhile the toolbar title says "Second Brain", which is the vault, not the document; the note actually open is "Reading list", named only by that unbacked breadcrumb. So the window's primary navigation and its document identity have both been evicted from the toolbar, and what remains in it are three peripheral actions. A macOS document window's toolbar is where you learn what you're looking at and how to go back; ours tells you neither.

**Opening find re-flows the band.** Refresh moves from centre x=965 to x=736.5 and folder from x=1017.5 to x=790.5 — two unrelated buttons jumping 228pt to the left because the trailing cluster is a right-aligned flow rather than anchored items. macOS search fields expand and collapse in place and the neighbours hold still. This is also what walks the folder button onto the x=780 seam. Related: the match count "2 of 3" sits outside the field as loose toolbar text at x≈826..861 while the clear (×) sits inside the field at its trailing edge — macOS keeps the count with the field, not stranded in the band beside it.

**One leading-edge measurement, flagged because of the stand-in caveat.** Our first control's left edge is at x=80. In the Finder capture the traffic lights occupy x=19..32, 42..55 and 65..78 at the same y=26. So a real light cluster would clear the sidebar toggle by 2pt. The toggle is also aligned to nothing else: its centre is x=98, while the sidebar's content column runs x=10..229 with a centre of 119.5 — it is neither flush with the sidebar's content edge nor centred in the sidebar.

**Below the band, three things are of a piece with the same "no layer" problem, and I'll note them briefly because they undercut the toolbar's reading.** The breadcrumb row at y=85 is fixed but has no bar behind it — in the find render the scrolled body text passes 2pt beneath it with no hairline, no inset and no backdrop of its own, so a pinned row and live scrolling content are simply touching. The outline list is likewise sliced: the clip line falls at y=96, fifteen points below the "Outline" baseline at y=81, leaving five rows of glyph bottoms of "Section 6" floating under the header on identical grey. And the status line is not a status bar: "29 lines" is bare text at x=265, y=783..791, on the content's own white, 43pt below the last content row, with no band, no material and no separator — at a glance it reads as a stray line of body copy rather than window furniture.

**Finally, the scrollbar, which is the loudest wrong note after the toolbar.** The thumb is 6pt wide (x=766..771, 8pt clear of the divider — the geometry is fine) but it is opaque 109 in light, where a macOS overlay thumb composited over white lands nearer 166, and opaque 159 in dark, where the platform lands nearer 100. It is over-inked in both directions, and in the light note view it is the second most prominent thing on screen. Worse, in the find state the find-match markers are painted *on top of* the thumb: three 3pt bands at y=274–276, 296–298 and 319–321 inside a thumb that spans y=254..374, and the values are (252,244,209)/(253,249,229) in light and (62,62,49)/(86,86,63) in dark — the same highlight fill as the text highlights, which measure (252,247,222) and (70,70,54). The thumb is chopped into four disconnected pieces and reads as broken; in dark the markers are darker than the thumb, so they read as holes punched through it. Match markers belong in the track, behind or beside the thumb, never over it.

**Two searches look identical.** The sidebar has a magnifier and the word "Search" in a field; the toolbar has a magnifier button that opens find-in-note. Nothing distinguishes vault search from find-in-document.

**If I had to rank the fixes by how much each buys back the macOS reading:** give the toolbar one continuous material of its own drawn above the pane split (kills the tri-tone, the straddling button and the asymmetric shadow clipping at a stroke); drop the button shadows and let the items be flat capsules; lift the light-mode icon ink from 39 to the platform's 77; group the three buttons into capsules with real 7pt/27pt spacing; and move back/forward up into the band with the document's own name as the title. The horizontal boundary under the band I've deliberately left out, and I've also set aside the focus treatment, the title's weight, and the sidebar-versus-content fill relationship.

## What was done with it

**The task's own result is read back cold and confirmed.** The reviewer,
measuring the images rather than being told anything, returned the band at 52
with every item 36 tall at y 8-43 and 8 px of clearance above and below; the
last control 8 px clear of the window's trailing edge; the recess 220 by 36;
and the order running the document actions and then the search. Those are the
four numbers this task set, each measured off a different stored window, and
they are the four it read back.

**Two findings are measured misreads against the reference and were not acted
on.**

*The band having no material of its own.* The reviewer read our band's two
fill steps — 247 over the rail, 255 over the note, 247 over the inspector — as
the defect, and asked for one continuous sheet drawn over the window's split.
`controls.md` records the opposite, measured by CG5.3g off
`finder-window-untinted-dark.png`: "The band is the fill of whatever region
lies under it, continued upward — `#1c1c1c` over the sidebar, `#1e1e1e` over
the content — so a toolbar band carries no fill of its own", and "inside it
the fill change alone says where a column's edge is." Re-read for this review:
in that capture the band's own row at y=3 runs flat at 29 from x=280 and steps
to 30 at x=323, which is the sidebar's column edge, with no line anywhere in
the band — the platform's band steps exactly as ours does. The reviewer's
counter-evidence was Mail, whose band reads one flat `(35,42,46)` across all
1200 px "over a content pane that is pure white below y=160". Re-measured: at
x=600 and x=900 the fill under Mail's band is `(35,42,46)` from y=52 down to
y≈159, and the white does not begin until y=160. Mail's band is flat because
the region under it is flat for a hundred rows; it is not a sheet over a white
column. Both captures therefore say the same thing, and the step in our band
is the platform's rule and not a defect. What the reviewer's reading does open
— whether the two halves of a window may differ ENOUGH under one band for the
step to read as a fault — is filed as 609 through its consequence.

*Toolbar controls casting no shadow.* The reviewer offered a direct
measurement: Finder's eight rows under a toolbar capsule at x=712 are
byte-identical to "the empty gap beside it at x=860". x=860 is not an empty
gap — it is inside the share/tag/more capsule, which runs x 827-936 in that
capture, so both samples were taken under a control. Read against the real
empty band at x=600 and x=630, which is a flat 255 for every row from 44 to
55, the rows under the capsule read 244 and recover to 248; the true gaps
between controls at x=750, x=818 and x=945 read 250-252, the two neighbouring
shadows overlapping. `controls.md`'s whole section "What the toolbar control's
drop shadow measures" is fitted to 77 such samples across three captures, and
it stands. Nothing moved.

**One finding is already planned and was not filed.** The light-appearance
mark reading 39 against the platform's 77 is the set's band being a sixth
heavier than the platform's: `controls.md` records the platform's axis-aligned
band at 1.12 to 1.39 px against this set's 1.5 at 24 dp, so the platform's
mark never fully covers a pixel and this one does. CG5.7 is the task that
gives the set the platform's measured keyline and a second measured weight.

**Eleven findings are outside this task and were filed** as pool 607 through
617: the two icon names a worker coined for the set, the bordered control's
dark rim five levels short of the measured pixel, the band re-flowing when the
find opens and walking a control onto a column edge, the band's shadow being
covered over one column and not the other, nothing in the band being grouped
into a capsule the way the platform groups related items, the window's
navigation and the document's own name standing outside the band, the find's
count beside the field rather than in it, the find's match marks painted over
the scrollbar's thumb, the thumb over-inked in both schemes, the vault's
search and the note's find drawn identically, and a pinned row with live
content scrolling under it.

**One note on the images.** The four renders the reviewer read are the goldens
this task regenerated. After the review the `open-folder` mark's flap line
moved 1.5 units, to land a whole device pixel at 20 dp; it answers no finding
here and the goldens were regenerated again for it.
