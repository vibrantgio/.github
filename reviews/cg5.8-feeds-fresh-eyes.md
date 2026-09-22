---
date: 2026-09-22
task: CG5.8
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.8 — feeds' rail read cold beside the platform's own sidebars

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x and told which two are the platform: feeds' whole
window in both appearances as this task left it (1200×800 each, rendered
through the app's own layers), `voicememos-multi-folder-2026-09-18.png` and
`finder-window-untinted-dark.png`. It was given the recorded misreads — a dark
label reads grey at 1x; a still shows no fade, no cursor and no hover; a
coverage composites in encoded sRGB; our window's three round buttons are
harness stand-ins; a pointer target is invisible in a still; the band along
the window's top and the window's trailing column are other rounds' — and it
was told it could read the pixels any way it liked. It was asked one question,
with no checklist: "Does this sidebar read as the sidebar in the reference
window, and what is wrong with it?"

## The reply, verbatim

> I read the pixels with PIL — column/row transition scans, glyph coverage profiles, and peak-colour sampling. Here is what I found.
>
> ## The short answer
>
> The **row** reads as the reference almost exactly. The **sidebar** does not, because everything between the rows is wrong: the group headers are outline rows rather than section labels, there are hairline rules that no macOS sidebar has, and in light appearance the column is the same white as the content pane.
>
> ## What is already right (so nobody re-litigates it)
>
> | | ours (light) | Voice Memos | Finder (dark) |
> |---|---|---|---|
> | selection pill | x 10–181 in a 0–190 sidebar → inset 10/9 | x 74–273 in 64–283 → inset 10/9 | x 74–363 in 65–372 → inset 9/9 |
> | pill height / radius | y 76–107 = 32, r≈6 | y 363–394 = 32, r≈6 | y 90–121 = 32, r≈6 |
> | pill fill | #178BFB | #178BFB | — |
> | row pitch | 32 | 32 | 32 |
> | icon box leading | pill + 9 | pill + 9 | pill + 9 |
> | label leading | pill + 39 | pill + 38 | pill + 37 |
> | item label | 13pt, #262626 | 13pt, #262626 | 13pt |
> | trailing count | #6D6D6D, right edge 16pt from sidebar edge | #6D6D6D, 17pt | — |
> | selected row contents | label/icon/count all #FFFFFF | same | — |
>
> That is a genuinely faithful row. The fill is bit-identical to Voice Memos' and so is the inset/height/radius triple.
>
> Also **not** a finding: our dark label is #DCDCDC, Finder's plateaus at #F4F4F4 (520 pixels at exactly 244 — a real plateau, not antialiasing). But #DCDCDC is white-at-85% composited over #1E1E1E, which is macOS `labelColor` dark; Finder's 244 is the platform's text-smoothing overshoot. Different rasteriser, same token.
>
> ## 1. The group headers are outline rows, not sidebar section headers
>
> This is the whole reason it doesn't read as the reference, and it is three things at once.
>
> **Size and colour.** Glyph profiles: our "Tech" has a 'T' cap from y=46 to y=55 — 10px, regular weight, darkest pixel **#262626**. Voice Memos' "My Folders" has an 'M' cap from y=183 to y=190 — **8px, semibold**, darkest pixel **#7D7D7D**. Finder's "Favourites" is identical: cap y=174–181, 8px semibold, peak **#989898** on a #1C1C1C ground. So ours is ~14pt at full label darkness; the platform's is 11pt semibold at secondary grey.
>
> The consequence is visible in the capture: our item label "Hacker News" is #262626 at 13pt and the header above it is #262626 at 14pt. The header is the *loudest* text in the column. In both references the section label is the *quietest* text on screen — it is the only text in either sidebar that is not primary-label colour. Our "News" and "Personal" rows currently out-shout the three feeds they organise.
>
> **The disclosure triangle.** We draw a filled 10×10 triangle at x=11–20 on every group row, #ACACAC light / #9A9A9A dark, always present. Across Voice Memos' one section header and Finder's three, there are **zero** triangles at rest. (I am not counting hover — the platform's hover affordance on a section header is a "Show/Hide" text button, not a triangle, so this is not the still hiding something.)
>
> **Row height.** Our header occupies a 48pt row of its own (y 28–75, 172–219, 220–267) with the label vertically centred in it. The platform header is not a row: Voice Memos puts 42pt of space between the last item row (ends y=160) and the first folder row (starts y=203) and floats the 11pt label low in that gap at y=182–192. Finder uses 31pt the same way. A 48pt row with a centred label and a bottom border is a table header; a small grey caption sitting low in a gap is a sidebar section.
>
> ## 2. Full-bleed hairline rules inside the sidebar
>
> Three 1px rules at **y=75, y=219, y=267**, spanning **x=0 through x=190** — the entire sidebar width, edge to edge. #E6E6E6 light, #343434 dark.
>
> Neither reference has a single horizontal rule anywhere in its sidebar: 0 across Voice Memos' 8 rows + 1 header, 0 across Finder's 17 rows + 3 headers. This alone turns the column into a table.
>
> Two of the three placements are also wrong on their own terms:
>
> - **y=75 sits between "Tech" and its own three children.** The header row is 28–75 and the Go Blog pill starts at 76. So the rule cuts the label off from the list it labels, and visually attaches it upward to the toolbar instead.
> - **y=267 dangles.** It closes "Personal" and then there are 533 rows of empty sidebar below it (y 268–800 is uniformly #FFFFFF — I checked every column 0–190 at y=500 and the set of distinct colours is `{(255,255,255)}`). A terminal rule with half a window of nothing under it reads as an unfinished table body.
>
> ## 3. Light appearance: the sidebar is the same white as the content
>
> Scanning y=400/600/700 across our light window: x 0–190 is **#FFFFFF**, x=191 is a 1px **#DFDFDF** line, x=192 onward is **#FFFFFF**. The sidebar and the article list are the same sheet of paper with a pencil line between them.
>
> Voice Memos, over a black desktop (which is the *worst* case for the sidebar material — vibrancy pulls it toward the desktop, so a bright wallpaper would separate less, not more):
>
> - sidebar interior x 66–281: **#F9F9F9**
> - x 282–283: **#FDFDFD**, **#FFFFFF**
> - x 284–318: a shadow ramping **#F4F4F4 → #FFFFFF** over 35px (measured profile: 244,244,245,245,246,246,247,…,254,255)
> - content: **#FFFFFF**
>
> So the platform separates with a tone step *plus* a soft shadow cast onto the content, and uses **no hairline at all**. We use a hairline and nothing else. Six levels of tone sounds like nothing written down, but combined with the 35px shadow it is what makes the platform sidebar read as a recessed plane behind the content rather than a margin of it.
>
> Dark is fine and I want to be explicit about that: ours is a flat #1E1E1E against a #1E1E1E content pane with a #323232 divider; Finder's sidebar is a #1B1B1B→#212121 vibrancy gradient against a #1E1E1E content pane with a #424242 divider at x=373. Effectively the same. The defect is light-only.
>
> ## 4. The header label aligns to nothing, and the triangle promises an indent that isn't there
>
> Our columns: triangle 11–20, header text starts **x=32**, item icon glyph starts **x=22**, item label starts **x=49**. The header text lands 10px right of the icon column and 17px left of the label column.
>
> Both references put the section label's leading edge on the icon column: Voice Memos header 'M' at x=81 with the folder icon at x=83; Finder header 'F' at x=81 with the icons at x=83–85. One column, not a third one.
>
> Worse, the item icons at x=22 start *left* of their parent header's text at x=32. We draw a disclosure triangle — the universal sign of an outline — and then outdent the children relative to the parent label. It is neither a sidebar section nor a working tree.
>
> ## 5. Minor
>
> - **Width 191pt.** Voice Memos runs 219 (x 64–283), Finder 307 (x 65–372). Ours is narrower than both, which is part of why the 14pt headers feel cramped.
> - **Icon column.** Our document glyph is 14 wide × **20 tall** (x 22–35, y 114–133) in a 32pt row. The platform symbols measure 16–20 wide × 16–19 tall (Finder: Desktop 20×16, Applications 16×17, Documents 14×19; Voice Memos folder 20×16). Ours is at the top of the height range and the bottom of the width range — a portrait glyph in a column of square ones.
> - **All three feeds carry the identical generic page glyph.** Every row in both references has a distinct symbol. The sidebar currently has no per-row identity above the text.
>
> ## Ranking
>
> 1. Section headers styled as 14pt full-darkness outline rows with permanent triangles (§1) — fix this and most of the "not a macOS sidebar" impression goes away.
> 2. The three full-bleed hairline rules (§2), especially the one severing "Tech" from its own children.
> 3. Light-mode white-on-white with no material step and no shadow (§3).
> 4. Header text on a phantom fourth column plus non-indented children (§4).
> 5. Width and icon-column details (§5).

## What was done with it

**Confirmed, and nothing was changed for it.** The whole of "what is already
right" is this task's own result, read back independently: the pill's fill,
inset, height and corner; the 32 pitch; the symbol's column, the label's
column and the count's column; the count's colour; and every part of the
selected row wearing the pill's white. The reviewer's "right edge 16pt from
sidebar edge" against the platform's 17 is the count landing correctly and
being measured against the wrong edge: feeds' rail is still flush chrome and
draws a 1 px seam down its own trailing edge, and the reviewer excluded that
column. Measured from the rail's last column — the analogue of the panel's
rim, which is where the platform's 17 is measured from — ours is 17 too. In
`patterns/sidebar`, which now draws no seam, the count's last covered column
is 17 in from the rail's trailing edge exactly, and a test pins it.

The dark-label reading was correctly set aside by the reviewer itself.

**Filed, not fixed.** Findings 1, 2, 3 and 4 are all one thing this task does
not touch: feeds groups its feeds with `patterns/accordion`, whose header is a
48 dp row with a permanent disclosure mark, a full-width hairline under it and
a body painted in the content's own fill. The platform's sidebar heads a run
with a small secondary label floating in air and draws no line and no
triangle at all. Replacing the accordion with the sidebar's own sections
removes a control the window has — the groups collapse — so it is a
composition decision and not a defect this task may settle. Pool 690, 691 and
692.

Finding 5's width is the same boundary: this task moved `patterns/sidebar` to
the measured 220 and left feeds' own rail at its 192 flush column, because
feeds has not been made a pane. Pool 689.

Finding 5's icon column is the icon set's, not the rail's: the document mark's
figure is 14 by 20 where the platform's row symbols measure 16–20 by 16–19.
Pool 693. The identical glyph on all three feeds is what this task chose and
stated — the set carries no mark that says a feed — and whether a rail's rows
should carry per-row identity at all is pool 694.
