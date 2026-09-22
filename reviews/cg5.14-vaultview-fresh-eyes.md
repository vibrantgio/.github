---
date: 2026-09-22
task: CG5.14
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.14 — vaultview's vault-switch dialog read cold beside the platform's Save panel

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x and told which two are the platform: the vault-switch
dialog open over vaultview's whole window in both appearances as this task
left it (`window-switch-{light,dark}.png`, 1100×800 each, rendered through the
app's own layers), and `save-dialog-{light,dark}.png`. It was given the
recorded misreads — a dark label reads grey at 1x; still captures show no fade
and no cursor; alpha composites in sRGB; our window's round buttons are
harness stand-ins; a pointer target is invisible in a still; the platform's
own open panel replaces this dialog on macOS in the next task, so this is the
library's modal for platforms that offer none — and it was asked one question,
with no checklist: "Does this dialog read as a macOS sheet for choosing a
folder, and what is wrong with it?"

## The reply, verbatim

> Read all four at 1x, and measured the pixels where my eye wasn't sure.
>
> **Short answer: no. It reads as a generic centred web/Material modal that happens to list folder names. Almost nothing in it says macOS, and almost nothing in it says file browser.**
>
> The strongest tell is that there is no list. In the platform panel the file area is a real object — a bordered scroll view with its own ground, hairline-separated from the naming section above (y=324) and from the button bar below (y=479). Our panel is one flat slab of #FFFFFF / #1E1E1E from corner to corner with no rule anywhere in it, so "Archive / Design / Inbox …" is just seven lines of text sitting on the dialog's own background. Nothing frames it, nothing scrolls, nothing says whether there are more than seven. And there are no folder icons. A macOS open panel puts a 16px folder icon on every row without exception; strip those and you have a menu, not a directory. Combined with `..` as the first row — a POSIX convention no Mac user has ever seen in a chooser — and a breadcrumb whose root segment is a literal blue `/`, this is a terminal's mental model wearing a dialog's clothes.
>
> The second tell is the column. Names begin at x=298; the right-hand values are right-aligned at x=800. For "Archive → 142 notes" that is 397 px of blank white between the two halves of one row, with no leader, no rule and no zebra, so at 1x you cannot reliably carry your eye from a name to its count. The column is also not one column: it holds "142 notes", "18 notes", "3 notes", "1 note", "27 notes", then ".obsidian vault" on Scratch — a count and a kind in the same slot — and Projects has nothing at all, which reads as missing data rather than zero. Because the whole string is right-aligned, the numerals land ragged (142 at x=749, 18 at 756, 3 at 762, 1 at 769); no numeric alignment. And this column is the reason the panel is 560×340 — a landscape letterbox, where the platform's is 370×356 portrait. The wide shape exists only to hold that gulf.
>
> The button row has one correct button and one missing one. Open is 74×24 px at a 20 px right inset, which is exactly the platform's Save (74×24, same inset) — dimensionally right. Cancel next to it is bare text: I sampled the pixels around the label and they are panel fill, #FFFFFF in light and #1E1E1E in dark. The reference Cancel is a real push button, 74 px wide, filled #ECECEC / #333A3F with a hairline. A borderless text Cancel beside a filled default button is the web convention; on macOS the pair is two equal push buttons 8 px apart. Ours also sits 19 px apart, and with no footer hairline the pair floats in the same field as the list.
>
> Chrome details miss too. Our corner radius is 6 px; the platform sheet's is about 17. That alone changes the read from "sheet" to "card". The panel carries a 24 px diffuse halo with no vertical offset — equal darkening above (204→189), below (189→204), left (198→188) and right (184→198) — a CSS box-shadow with y=0, not a cast shadow; the platform sheet in these captures has no shadow at all and relies on its hairlines. And the panel sits at dead window centre, 230–570 in an 800-tall window, centred on the whole window including the sidebar; a sheet descends from the title bar and sits high, as the reference does.
>
> Dark mode is where it comes apart worst. The panel is #1E1E1E on a #161616 window — eight levels of separation, no border, and the shadow ring darkens the surround to #141414, two levels below the background, which is invisible at 1x. So in dark there is effectively nothing drawing the edge of this dialog; it is a slightly-less-black rectangle. The platform sheet gets #232A2F on #191A1B and still backs it with internal hairlines and a filled Cancel button to make the object legible.
>
> Three blues, none of them the platform's. The Open button is #007AFF. The sidebar and outline selections behind it are #126FC9 in light and #126EBB in dark. The platform's default button here is #157EFB. So the accent is not read off the platform, the button blue is frozen across both schemes while the selection blue shifts between them, and the two in-app blues don't agree with each other. All of that is visible at once, because the parent window is undimmed and fully vivid under the modal — two saturated blue selection bars and a blue breadcrumb link compete with the dialog's own default button for the eye. In the reference, the parent's toolbar controls are visibly greyed while the sheet is up.
>
> Finally the header. "Open Vault" is 15 px semibold, left-aligned, and in exactly the same ink as every list row (#272727 in light, #DDDDDD in dark), so only weight separates the title from the content — there's no rule under it and no distinct band. The platform open panel has no title at all; it labels its fields instead. And the internal margins don't agree: title and breadcrumb sit at a 20 px left inset, the Open button at a 20 px right inset, but the list names are at 28 and the counts at 29 — an 8 px indent with no container to justify it, so it reads as misalignment rather than nesting.
>
> What is actually right, so it doesn't get lost: the default button's metrics, the 24 px row pitch, the 20 px outer insets on the header and footer, and the body text tones (#272727 / #DDDDDD) are all close to platform values. The skeleton is sound; the object-ness is missing.

## What was done with it

**Fixed in this task.** The last finding: the rows stood 8 px in from the
columns the header, the breadcrumb and the Open button lead and end on. The
row's leading and trailing air is now the browser's parameter — a screen that
lays the browser out itself gives its rows their own, and the dialog gives
none, the surface having already inset the body by 20. The goldens above were
re-recorded after it; every measurement in the reply was taken before.

**Measurement artifacts, recorded so they are not re-read as defects.** The
reviewer read the footer's two buttons as 19 px apart; that is the Cancel
LABEL's last pixel to the Open button's fill. A Ghost button draws no fill, so
its box is invisible in a still: Cancel's box runs x 654–727 and Open's x
736–809, the measured 8 px of the save dialog's own footer. The same
invisibility is what the reply's second footer finding is about, so the two
travel together. The reviewer also wrote that the parent window is undimmed,
having already measured the selections behind the scrim at `#126FC9` against
their own `#157EFB` — the window IS dimmed, and that reading is the dim.

**Pooled.** Everything else, as CQ in `explorations/open-rulings.md`: the
rows' missing folder symbol and the `..` row, the breadcrumb's literal root
segment, the annotation column, the dialog's landscape shape, Cancel's
emphasis against the platform's filled push button, the modal's corner and
shadow, where a dialog stands in its window, the dark dialog's eight levels of
separation, and the accent the button takes against the one the selection
takes. None of them is this task's — they are the browser's rows, the modal
pattern's own chrome, and a colour token — and several are one ruling for
every dialog in the organization rather than for this one.
