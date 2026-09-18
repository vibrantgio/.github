---
date: 2026-09-18
task: CG5.3p
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.3p — vaultview's sidebar list read cold beside Voice Memos' and Finder's

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x: vaultview's sidebar rail in both schemes, cropped
from the window goldens this task regenerated
(`workbench/vaultview/testdata/golden/window-{light,dark}.png`), and two
macOS 26 captures — `voicememos-multi-folder-2026-09-18.png` and
`finder-window-untinted-dark.png`. It was told which two are the platform's,
given the recorded misreads — a dark label reads grey at 1x; a still shows no
fade and no cursor; a coverage composites in encoded sRGB; the window control
buttons are harness stand-ins; a pointer target is invisible in a still; the
inset panel itself is CG5.3n's and accepted by the owner; the toolbar band is
CG5.3o's; the inspector column is out of scope — and asked one question:

> Does this sidebar's list read as the sidebar list in the reference window,
> and what is wrong with it?

## The reply, verbatim

## Verdict

Yes — in rhythm and in selection it reads as the reference's sidebar list. The row pitch is 32 px in ours and in both references (Design 149 → notes 181 → Principles 213 → guide 245 → Reading list 277; VoiceMemos TriNova 219 → iXora 251 → DTA 283). The selection pill is 32 px tall with a 9 px inset on both sides in both (ours x 18–237 inside a panel whose inner edge is x 9–246; VoiceMemos x 74–273 inside 65–282), the corner ramp is pixel-for-pixel the same, and the accent fill is literally identical, rgb(23,139,251) in both. Section headers match too: grey 124 on 247 vs 125 on 250 in light, 153 on 28 vs Finder's 152 on 29 in dark, with the same 42 px gap above a header and 32 px below it. Label typography is right — x-height 7 px in both, letter advances the same, ink 38 in light in both.

What gives it away is the row content.

**1. The icons are about 60% the size they should be, and hairline.** Our folder glyph inks 12 × 10 px with a hard 1.0 px stroke (row y=150 reads 247, 38, then twelve px of paper, 38 — no antialiasing on the sides at all). The macOS folder is 20 × 16 with a ~1.5 px stroke (VoiceMemos x 83–102, y 211–226, side stroke reading 0 then 125; Finder dark x 83–102, y 226–241). Our document glyph is 8 × 12 against the same 20 px cell. The cell *centre* is exactly right — ours sits at panel-inner + 27.5 px, VoiceMemos at sidebar-inner + 27.5 px, identical — so this is purely the glyph drawn too small and too thin inside a correct slot. Two knock-on effects: the gap from icon to label is 14 px in ours against 9 px in VoiceMemos and 10 px in Finder (all three put the label at inner + 45–48), so the icon floats away from its text instead of pairing with it; and the icon's optical weight no longer balances the label, so each row reads as a line of text with a small mark beside it rather than macOS's icon-and-label pair.

**2. The disclosure chevrons hang outside the selection pill.** A top-level chevron occupies x 11–20 while the pill spans x 18–237 and the panel's inner edge is x 9 — so seven of the chevron's ten pixels lie outside the highlight, and it sits just 2 px off the panel edge. Select "Design" or "guide" and its chevron will be half in the blue and half on the panel. It is also 14 px left of the "Folders"/"Notes" header text at x 25–26; in both references the header text (inner + 16) and the row icon column (inner + 17–18) sit within a pixel of each other, and nothing at all sits left of the highlight's edge. The chevron gutter has been added outside the row's content inset instead of carved out of it.

**3. Dark mode runs dim.** Our labels and icons peak at 220 on a 28 backdrop, every row; Finder's sidebar labels and icons peak at 244 on the same 28. Light mode matches exactly (38 on 247 vs 38 on 250), so this is a dark-only foreground deficit and it makes the whole list sit back from the surface at 1x.

One thing that looks wrong and is not: "Reading list" appears bolder than its neighbours, but its stems measure 1.55 px effective width against VoiceMemos' selected "Cura Informalis" at 1.58 — the selected row is correct, and the apparent jump is the unselected rows' lighter dark-on-light antialiasing, which is the recorded rendering artifact.

## What was done with each

**1, the icons drawn too small — fixed.** The rail drew its mark at the size a
mark beside a line of text takes, 16 dp, inside the 24 dp square the row keeps
for a symbol, so the set's axis-aligned keyline came out 12 across on a 1 dp
band. The mark now fills the square: 18 across on a 1.5 band, against the
folder symbol's measured 20.00 by 14.39 and its 1.37-to-1.50 band in
`voicememos-multi-folder-2026-09-18.png`. The gap from the symbol to the name
closes to the measured 10 with it. mindchat's rail carried the same mistake and
takes the same fix.

**2, the chevron outside the pill — fixed.** The disclosure had been given the
room before the rail's own first column, which is the pill's own inset and
therefore outside it. A tree row carries a part the platform's plain sidebar
row does not, so the disclosure now takes the row's FIRST column — the rail's
own 17, where the section headings begin, which is the relation both references
hold within a pixel — and the symbol and the name stand one column further in.
The whole tree is indented by that one column; the step per depth is unchanged
and `TestTreeIndentIsOnePerDepth` pins it.

**3, dark runs dim — half answered, half filed.** The LABEL is measured and
correct: `voicememos-sidebar-dark.png` draws its row labels at `#dcdcdc`, which
is `labelColor`'s white at 216/255 over the panel's `#1c1c1c` to within one of
255, and that is what the rail draws. `finder-window-untinted-dark.png` reads
244 for the same thing, which is 0.952 coverage and no alpha the platform
names — that capture's text is carrying font smoothing the Voice Memos captures
do not, which is also why its light sidebar could not be read for this round.
The SYMBOL half is a real and open reading: Voice Memos draws its sidebar marks
at a plateau of `#000000` light and `#ffffff` dark, 38 and 35 of 255 past the
label beside them, and no platform name answers for either. The library draws a
mark in the foreground of what it sits in, which is the label's colour; the gap
is filed as open ruling 637 for the owner rather than turned into a third
measured value of the rail inside this task.

The reviewer's own recorded non-defect — the selected row reading bolder — is
the antialiasing misread the brief names, and it was checked: the stems measure
1.55 against the reference's 1.58.
