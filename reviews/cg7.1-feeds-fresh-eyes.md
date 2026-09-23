---
date: 2026-09-23
task: CG7.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG7.1 — feeds' rail read cold beside the platform's own sidebars

One reviewer, having seen neither the plan nor the packet nor any source and
told not to go looking for one, was given four images at 1x and told which two
are the platform: feeds' whole window in both appearances as this task left it
(1200×800 each, rendered through the app's own layers, with the first group
open and the two below it collapsed), `voicememos-multi-folder-2026-09-18.png`
and `mail-window.png`. It was given the recorded misreads — a dark label reads
grey at 1x; a still shows no fade, no cursor and no hover; a still holds no
keyboard, so the open feed shows the grey pill rather than the blue one; a
coverage composites in encoded sRGB; our window's three round buttons are
harness stand-ins; a pointer target is invisible in a still; the articles table
and the band's controls are other rounds' — and it was told it could read the
pixels any way it liked. It was asked one question, with no checklist: "Does
this window's sidebar read as the sidebar in the reference windows, and what is
wrong with it?"

## The reply, verbatim

> I read only the four images. All measurements below are in pixels = points (verified: both platform captures show 14 px traffic lights, so both are 1x, same scale as ours).
>
> ---
>
> ## Answer
>
> **Yes — the skeleton reads as a macOS sidebar, and it does so to the pixel.** Nearly every dimension I can measure against VoiceMemos matches within 1 pt. What is wrong is not the geometry, it is the **ink**: everything drawn inside the pane is lighter, thinner and smaller than the platform's, and the selected row is coloured in a way the platform never uses.
>
> ### What already matches the reference (measured)
>
> | Property | Ours (feeds-light) | VoiceMemos |
> |---|---|---|
> | Sidebar width (window interior edge → seam) | 219 | 219 |
> | Sidebar fill | #F7F7F7 | #F9F9F9 |
> | Row pitch | 32 | 32 |
> | Selection pill size | 200 × 32 | 200 × 32 |
> | Pill side insets (leading / trailing) | 9 / 9 | 9 / 9 |
> | Icon optical centre from pane edge | 27.5 | 27.5 |
> | Label column from pane edge | 48 | 47 |
> | Count right-aligned, trailing inset | 16 | 15 |
> | Section-header text inset | 16 | 15 |
> | Header text centre → first row centre | 32 | — |
> | Last row centre → next header centre | 42.5 | 42 |
> | Label colour | #262626 | #262626 |
> | Count colour | #6D6D6D | #6D6D6D |
> | Header colour / cap height | #7C7C7C / 8 px | #7D7D7D / 8 px |
> | Row content vertical centring | exact | exact |
> | Pane runs full height, no divider crossing it at the toolbar line | yes | yes |
> | Seam: 1 px white line + soft shadow onto content | yes (23 px) | yes (33 px) |
>
> That is a remarkably close skeleton. Everything below is what sits on top of it.
>
> ---
>
> ## Findings, ranked
>
> ### 1. The selected row tints its content with the accent. The platform never does this. (worst)
>
> Measured on the "Go Blog" row:
>
> | | pill fill | label / icon / count |
> |---|---|---|
> | Ours, light | #ECECEC (neutral) | **#0072F7 (accent blue)** |
> | Ours, dark | #2A2A2A (neutral) | **#148FFF (accent blue)** |
> | VoiceMemos | #178BFB (accent blue) | #FFFFFF |
>
> The platform has exactly two selected-row appearances: accent pill + white content (focused), or neutral pill + **normal** content colours (unfocused). Ours is a third state that exists nowhere on the platform — a neutral pill with accent-tinted content — and it reads as a hyperlink, not as a selection.
>
> It also inverts the contrast hierarchy. APCA against each row's own backdrop:
>
> | row | light | dark |
> |---|---|---|
> | **selected** label | **Lc 58.5** | **Lc −38.4** |
> | unselected label | Lc 97.3 | Lc −83.8 |
> | count (unselected) | Lc 70.9 | Lc −43.6 |
> | header | Lc 64.0 | Lc −45.6 |
> | VoiceMemos selected (white on blue) | Lc −66.6 | — |
>
> The selected row is the **faintest text in the sidebar** — fainter than the section headers, fainter than the counts. It should be the most definite thing in the pane. Fix: on the neutral pill, paint label/icon/count at their normal colours (#262626 / #6D6D6D); reserve white content for the accent-filled pill.
>
> ### 2. The row icons are the wrong shape and far too light.
>
> | | ours (doc) | VoiceMemos (folder) | VoiceMemos (trash) |
> |---|---|---|---|
> | glyph box | 14 w × **20 h** | 20 w × **16 h** | 16 w × 16 h |
> | stroke ink (horizontal cut) | ≈0.9 px | ≈1.5 px | ≈1.5 px |
> | stroke core / halo value | #5A core, #B6 halo | **#00** core, #7D halo | #00 core, #7D halo |
> | total ink per icon | 64.1 | 113.1 (+76 %) | 107.4 |
> | clearance inside the 32 pill | 6 top / 6 bottom | 8 / 8 | 8 / 8 |
>
> Our icons are 25 % taller than the platform's 16 pt symbol box and carry 43 % less ink. The stroke never reaches black — its dominant value is #5A over a #B6 halo, so the icon reads mid-grey next to a #262626 label, where the platform's icon reads black next to the same label. The net effect is a column of tall, spindly wireframes where the reference has compact, solid symbols. This is the second thing the eye notices after the blue.
>
> ### 3. Row labels are a size small and render ~45 % lighter.
>
> | | cap height | x-height | ink / (advance × cap) |
> |---|---|---|---|
> | ours "Hacker News" | 9 | 7 | 0.177 |
> | ours "Lobste.rs" | 9 | 7 | 0.169 |
> | VM "TriNova" | **10** | 7 | **0.262** |
> | VM "Recently Deleted" | **10** | 7 | **0.252** |
>
> Colour is identical (both peak at #262626) and the x-height matches, so this is size plus rendered weight. Over the same 70 × 15 box our label lays down 10.6 ink per 100 px² against the platform's 14.2. Caveat: part of that gap is macOS's own stem darkening, which is not ours to reproduce — but the 1 px cap-height shortfall is, and the combined result is that the whole pane reads a shade paler than the reference.
>
> ### 4. Persistent disclosure chevrons on every section header.
>
> Neither reference window shows any disclosure affordance at rest — "My Folders" is text and nothing else. Ours shows a chevron on all three headers permanently: 12 × 8 down-chevron on Tech, 8 × 12 right-chevron on News and Personal, drawn as a hairline (dominant value #9A, lighter than the header text itself at #7C).
>
> Two problems beyond its existence: it is a 12 pt mark carrying almost no ink, so it reads as a large faint smudge rather than a control; and its trailing edge sits at inset 13 while the count column sits at inset 16, so the sidebar's right-hand column doesn't line up (the centres do align at x = 207.5, only the edges disagree).
>
> Header weight is also light: ink per advance px 1.32 against the platform's 1.61 (+22 %), at identical cap height and colour. "My Folders" reads as a small bold label; "Tech" reads as small regular text.
>
> ### 5. Dark appearance: the sidebar barely separates from the content, and the seam is the brightest thing in the pane.
>
> | | sidebar | content | ΔL\* |
> |---|---|---|---|
> | ours, light | #F7F7F7 (L\* 97.2) | #FFFFFF (L\* 100) | **2.77** |
> | VoiceMemos, light | #F9F9F9 (L\* 97.9) | #FFFFFF | 2.07 |
> | ours, **dark** | #1C1C1C (L\* 10.3) | #1E1E1E (L\* 11.3) | **1.00** |
>
> In dark our sidebar is a third as distinct from the content as it is in light. The pane边 boundary is carried almost entirely by the seam line, and that line is #3A3A3A — **ΔL\* +14 brighter than both panes it divides**, the brightest pixel in the whole left half of the window. In light, the same construction is a white line against a white content pane and is invisible, which is right. Mail's dark pane seam is #000000, darker than both panes, not lighter.
>
> Caveat worth stating: neither reference gives me a dark sidebar next to a dark content pane (Mail's left column is an 80 pt message list, and its right pane is white), so I can prove our dark seam is conspicuous but cannot show you the platform's answer for the same case.
>
> ### 6. The selection pill is twice as prominent in dark as in light.
>
> Pill against its own sidebar: light −3.8 ΔL\* (#ECECEC on #F7F7F7), dark +6.8 ΔL\* (#2A2A2A on #1C1C1C). The direction is right in both, but the dark pill is 1.8× the step of the light one. Pick one figure and hold it across appearances.
>
> ### 7. The pill's corner radius is tighter than the platform's.
>
> Same 32 pt height, same 200 pt width, different corner. Ours reaches full width 5 rows in from the pill edge (circular arc r ≈ 7.5); VoiceMemos reaches it 7 rows in (r ≈ 11, and it is a continuous corner, not a circular one). Side by side ours is a rounded rectangle where the reference is closer to a capsule. Smallest of the findings, but it is the one shape difference in an otherwise exact pill.
>
> ---
>
> ## Summary
>
> The sidebar's structure is right — widths, insets, the 32 pt rhythm, the 42 pt section gap, the label and count columns, the three text colours, the full-height pane with its white seam and shadow are all within a point of VoiceMemos. What is wrong is everything drawn on that structure: the selected row wears the accent as a text colour instead of as a fill and ends up the faintest row in the list; the icons are tall, thin, grey wireframes where the platform uses compact black symbols; the labels and headers are a touch small and noticeably lighter; the headers carry a permanent chevron the platform doesn't show; and in dark the pane and its neighbour differ by ΔL\* 1.0 while a bright hairline does all the separating.
>
> Fix 1 and 2 and it will read as the reference at a glance. 3–7 are what close the remaining gap.

## What was done with it

**"What already matches the reference" is this task's own result, read back
independently.** The panel's width, its fill, the 32 pitch, the pill's box and
its 10 insets, the symbol's centre, the label's column, the count's column, the
section's 42 block, the three measured colours and the panel running the
window's full height with no line crossing it are the readings CG7.1 spent, and
a reviewer who had never seen them measured them back within a point. The one
place its numbers sit a point under the recorded ones — counts and heading at
16 where the reference records 17 — is its own method reading the panel's
interior rather than its rim, and its Voice Memos column reads 15 against the
same recorded 17, so ours and the platform's land the same distance apart under
one ruler.

**Finding 1 is measured, and it is the platform's own answer.** CG5.23 read the
unfocused pill off `finder-sidebar-unfocused-{light,dark}.png`: "the row's name
plateaus at `#0072f7` over 47 pixels light and `#148fff` over 43 dark, and the
document mark beside it plateaus at the SAME value over 23 pixels in each",
recorded as `SidebarSelectionUnemphasized` and
`SidebarSelectionUnemphasizedLabel`. Ours reads `#0072F7` and `#148FFF` — the
platform's values to the byte. The reviewer's "the platform has exactly two
selected-row appearances" is a third one it had no capture of: neither image it
was given holds an unfocused rail, and the brief told it a still shows the grey
pill without saying what the platform paints on it. Recorded as a misread of
this round's making, and the misread brief grows the line for the next review.
Nothing changed. Its APCA reading stands and is the platform's own hierarchy,
not ours.

**Finding 4's first half is the question this task recorded rather than
answered.** That neither reference shows a disclosure at rest is exactly what
`controls.md`'s new section says: no stored capture holds one, the two Mail
windows are redacted down the sidebar, and the box, the inset and the line the
mark stands on are derived from readings the reference does hold. Pool 757 names
the capture that would close it. The reviewer reaching the same conclusion from
the pixels alone is the strongest thing it says.

Finding 4's second half — the mark's edge at 13 against the count's 16 — is the
turn's own geometry, stated where the constant is: the drawing is centred in its
box and measures 8 across closed and 11.7 turned, so one box cannot land both
states on one column. The reviewer confirms the centres align at x=207.5, which
is the invariant that was chosen. Its faintness is the set's one band at a 20 dp
box; pooled.

**Finding 5's second half is the panel's rim, not a seam.** `#3a3a3a` is
`PaneRim` dark, MEASURED off `finder-window-untinted-dark.png` — "the rim reads
`#3a3a3a` flat down x=64 and along y=46 and y=1024" — and the platform draws a
rim, not a line, around an inset panel. The reviewer says itself that neither
image gives it a dark pane beside a dark content column. Its first half, the
ΔL\* 1.0 between the two dark fills, is the platform's own pair: `#1c1c1c`
chrome against `#1e1e1e` content, the reading `controls.md` records under the
sidebar captures. Nothing changed.

**Finding 6 is CG5.23's own measurement.** The grey pill is a coverage — black
at 11/255 light, white at 16/255 dark — and that section records the resulting
steps as "ΔL\* 3.83" light and "6.79" dark on the same rails. The asymmetry is
what the platform draws; a single figure held across appearances is what the
platform does not do.

**Finding 7 is the continuous corner, already recorded.** `SelectionRadius` is 8
because a circular fit to the platform's own pill reads 7.9 in Finder and 8.4 in
Voice Memos, and `controls.md` states why the two differ: the platform's corner
is a continuous curve, so the arc leaves the straight edge further out than a
circle of the same radius would. The reviewer measured where the arc meets the
straight edge and read 11. Pooled as a reading.

**Filed, not fixed.** Finding 2 is pool 693, filed by CG5.8 — the document
mark's 14 by 20 figure in a column of square ones — which this review extends
from shape to weight; the new reading is pooled beside it. Finding 3 and finding
4's header weight are typography, which this task was told not to move; pooled.
