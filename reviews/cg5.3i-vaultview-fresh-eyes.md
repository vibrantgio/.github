---
date: 2026-09-18
task: CG5.3i
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3i — vaultview's whole window read cold beside the Finder band

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: vaultview's whole window in the light and the dark
scheme (`workbench/vaultview/testdata/golden/window-{light,dark}.png`, the
goldens this task regenerated) and the frontmost Finder window from
`finder-window-light.png` and `finder-window-untinted-dark.png`, which is the
capture every number in this task was measured from. It was told which two
images are the platform's, given the recorded misreads — a dark label reads
grey at 1x; the light sidebar material is the content's white told apart by a
seam; a still shows no fade, no animation and no cursor; a coverage composites
in encoded sRGB; the window controls are harness stand-ins; a pointer target
is invisible in a still; the open menu is CG5.4's and focus CG5.5's; the paint
below the band at the window's boundary is pool 437's; the title's weight is
typography and stays by ruling — and asked one question:

> Does this window's toolbar read as a macOS toolbar with its controls, and
> what is wrong with it?

## The reply, verbatim

## Fresh-eyes review — vaultview toolbar vs. Finder

**Verdict: it reads as a macOS toolbar band, but not as a macOS toolbar *with its controls*.** The band itself is right; what should be standing in it is almost entirely missing, and the band is cut short before it reaches the window's right edge.

**What is right.** The band is 52px tall in both renders, the same height as the Finder toolbar in both captures. It is flush and untinted: over the content column it is the same white (255) / near-black (30) as the document below it, and over the sidebar the same 247 / 28 as the sidebar below — exactly the relationship Finder shows (content 255/30, sidebar 250/28), so there is no wrong-looking grey stripe pasted across the top. The pane divider hairlines start at y=52 and correctly do not run up through the band, in both schemes. The one control sits at the far left of the sidebar region, x 79–116, which is where a sidebar toggle belongs once the window controls have had their run.

**The toolbar has one control and 754 empty pixels.** Right of the title, the band is literally empty: I scanned every column from x=360 to x=1100 across y=0–51 in both renders and found not a single non-background pixel. The title "Second Brain" occupies x 264–346, and from there to the right edge of the window there is nothing at all. Put the Finder captures beside it and the contrast is the whole point of the comparison: Finder light carries a back/forward segmented pair, then the title, then a right-hand cluster of view-switcher, group-by, share, tag, more and search; Finder dark carries the same plus an expanded Search field. The vaultview window plainly *has* those actions — but they have been pushed out of the toolbar and scattered into the panes. Back and forward are bare chevron glyphs down in the content column at y≈85, beside the breadcrumb, with no button shape around them at all. Search is a field at the top of the sidebar, y≈76. Rescan and Switch Vault are two bordered push buttons parked at the bottom-left of the sidebar, y≈779. Those are toolbar items sitting everywhere except the toolbar, and the result is a toolbar whose right two-thirds is dead space in both schemes.

**The band stops at x=780 instead of at the window edge.** There is a hard vertical step in the toolbar at x=780 in the light render — 255 to the left, 247 to the right — running the full height of the band from y=0. That is the Outline/Backlinks column's fill rising into the toolbar, so the toolbar surface terminates 320px short of the right edge and a separate grey column runs to the top-right corner. In Finder the toolbar surface runs unbroken from the sidebar all the way out to the window's right edge, and that far right end is precisely where its controls live. Here the app has taken the one region a macOS toolbar most needs — its right end — and given it to a content pane. In the dark render the same step is 30 vs 28, a difference of 2/255, so it is effectively invisible: the toolbar looks continuous in dark and visibly chopped in light. Whatever the fix, the two schemes should not disagree about whether the toolbar reaches the right edge.

**The one control is the wrong shape.** The sidebar toggle is a circle: I measured its profile and it spans 38px at the vertical centre and tapers to 8px at both y=8 and y=43 — a 36–38px disc, not a rounded rectangle. In the light scheme it is a white disc on the 247 sidebar with a soft shadow falling about 10px below it (238 under the button, fading back to 247). Finder's toolbar items are rounded rectangles and capsules throughout — the segmented back/forward pair, the view-switcher, the share, tag and more buttons — never circles. A white disc with a halo on a light ground reads as a floating circular action button borrowed from another platform, not as a macOS toolbar item. The dark rendering has the tone right (38 fill on a 30 band, matching Finder dark's 38-on-30 buttons) and only the silhouette wrong, which suggests this is purely a corner-radius and shadow question, not a colour one.

**Summary of what to fix:** put the window's toolbar-class actions back in the toolbar and fill its right end (search, and the back/forward pair belongs beside the title, not in the document); let the toolbar surface run the full window width rather than surrendering the last 320px to the Outline column; and give the toggle a rounded-rect silhouette in place of the shadowed disc.

## What was done with it

**The band, the control's placement and the seams are confirmed.** Every
number the task set is read back: the band at 52 in both schemes, each
column's fill continuing up into it, the seams starting at y=52 and crossing
none of it, and the sidebar toggle standing at the leading end of the band
after the window controls' own run. That is the task's result read cold.

**One finding is a misread against the measurement and was not acted on: the
control's silhouette.** The reviewer read the 38 × 36 capsule as a disc and
asked for a rounded rectangle. The platform draws exactly this shape: a
toolbar control carrying one symbol and nothing else measures 38 px wide
against its 36 px height in `mail-window.png` (the compose control, x 404-441),
37 in `notes-toolbar.png` and 40 in `voicememos-window.png` (the sidebar
toggle, x 96-135), and every bordered control in a stored toolbar band is
cornered at half its height — `finder-window-untinted-light.png`'s group
pull-down fits r = 17.4 to 19.1 about the half-height's 18. A capsule 38 wide
and 36 tall IS very nearly a circle, and Voice Memos' own sidebar toggle reads
the same way in its capture. The shadow the reviewer read as a halo is the
platform's measured drop shadow (`controls.md`, "What the toolbar control's
drop shadow measures"), and its dark counterpart was re-measured by this task.
Measured beats read: nothing moved.

**Two findings are outside this task and were filed:** the window's
toolbar-class actions standing everywhere but in the band (pool 594), and the
inspector column owning the band's trailing end, where the platform keeps its
control cluster (pool 595). The second is the one place the reviewer's reading
and the reference disagree in kind: `controls.md` records that a toolbar band
carries no fill of its own and each column's fill continues upward into it, so
the step at x=780 is the platform's own rule and not a defect; what is open is
whether a content column may take the band's trailing end at all.
