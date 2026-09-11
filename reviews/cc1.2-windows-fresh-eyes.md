---
date: 2026-09-11
task: CC1.2
phase: CC
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CC1.2 fresh-eyes review — the launcher, a vaultview note and sitedocs' theme tab

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer on
macOS/Windows/Linux complain about in these windows?

**It was briefed on nothing.** The recorded misreads were not handed to
it — an omission, and it produced one of them almost immediately (see
the second finding below). Read its reply with that in mind, and brief
the next one.

## How the captures were taken

**No window was opened.** All four images are stored goldens,
regenerated in this task and rendered headlessly at one device pixel
per point by the golden harnesses in `workbench`,
`workbench/vaultview` and `workbench/sitedocs`: the launcher in both
schemes at 1340×966, a vaultview note on the light scheme, and
sitedocs' theme tab on the dark one. The reviewer was given the four
files and nothing else.

## What this task changed in them

CC1.2 converted the consumers from the WCAG 2 ratio to APCA. Every
pixel that moved is a foreground or a mark re-derived at the new
floors — no geometry, no spacing, no type, no layout. So the standing
question for each finding below is only whether the measure caused it.

## The reviewer's reply, verbatim

> I read all four images. Findings, worst first.
>
> **sitedocs/theme-tab-dark — the swatches that are the entire point of the page are invisible.** In the bottom-left "Page and surfaces" column, the chips for *Surface* (Neutral 200) and *Seam* (Neutral 300) render as empty rounded rectangles with a hairline border on a near-black page. You cannot see the colour. Same failure in the "Axis ends" column at the right: the *Black* chip is a black box on a dark background, a rectangle of nothing. A page whose job is "here is every colour the theme names, and where it came from" documents several of its colours by showing the reader an empty box. The *Background / Text* chip next to them shows "Aa", *ErrorContainer / ErrorMark* shows a small filled square, and Surface/Seam show nothing at all — three different chip treatments in one column with no legend explaining why.
>
> **sitedocs — the pick markers vanish on the light half of every ramp.** The white dot marking where a pick lives reads clearly in the 100–300 columns but is effectively invisible at Error 700, Success 700, Warning 700, Info 700 (white dot on pale pink/green/peach/blue) and worst of all Neutral 900, where a white dot sits on a near-white swatch. The one piece of information the ramp grid carries beyond "here are colours" is unreadable in roughly half the places it appears.
>
> **sitedocs — the frame is cut mid-content.** The bottom row slices "SuccessContainer / SuccessMark" in half at the window edge, and the "Inverse" heading in the left column has nothing at all beneath it — a section header with its content amputated. If this is the golden, the golden is capturing a broken viewport; if it's the app, the last section is unreachable without scrolling with no visual hint that there's more.
>
> **sitedocs — the explanatory text is exiled to the far right, tiny, and crammed.** Each band header pushes its explanation to the opposite end of a 1170px bar: "the smaller swatch is the colour picked · the seed sets the accent hue · the palette's own dial sets its chroma · it only tints the status hues" is four separate sentences chained with middle dots, ~11px grey on dark, ending flush against the right edge with no padding, hundreds of pixels away from the swatches it describes. Nobody will read it. Same for "a dot marks where each pick lives · nine steps a role · 100 nearest the page · each row ends with its role's pinned base, and Neutral pins none". And the Neutral row's base cell is an em dash "–", which reads as a missing/broken value rather than "pins none".
>
> **vaultview/note-light — content overflows its container and is chopped mid-word.** The bottom code block's first line reads "// A wikilink inside code is a code sample, not navigat1" — cut dead at the block's right edge, no ellipsis, no horizontal scrollbar, no wrap. The reader gets a truncated sentence with no indication anything was lost. The same block is also sliced by the bottom of the window with no padding.
>
> **vaultview — the inline code span is rendered as a full-width block.** The word "code" under "A sample" sits alone inside a bordered box spanning the entire content width (x≈24 to 510) and about 40px tall, with the word tucked in the top-left and a large empty area to its right. That is an inline `code` chip being laid out as a block-level pre. It reads as a rendering bug at a glance.
>
> **vaultview — the scrollbar is a black slab welded to the window edge.** A very dark, hard-edged vertical bar runs from y≈168 to the bottom at the extreme right, with no track, no rounding, no inset, and it starts partway down rather than at the top of the scroll region. On macOS this is nothing like the overlay scrollbar users expect; on any platform it reads as a stray filled rectangle. It also crowds the content — there's no gutter between the text column and the bar.
>
> **vaultview — low-contrast comment text in the code block.** `// A wikilink inside code…` and `// [[Design/Principles]]` are light grey italics on a pale lavender-grey block; at 1x they're close to illegible, while `func` and `main` right below them are saturated blue and red. The contrast ordering is backwards from the reading order.
>
> **launcher (both themes) — the grid is 40% empty and the last row is a lone orphan.** Nine cards in a four-column grid leaves "SK150 Control" alone with three empty columns beside it, then roughly 100px of dead background below that, plus a 128px empty band above "VIBRANTGIO" at the top. The window is 1340×966 and a large fraction of it is background. Meanwhile the gap between the subtitle and the first card row is only ~50px, so the page is simultaneously top-heavy in empty space and tight where it matters.
>
> **launcher — every card has ~50px of dead space under its Launch button.** In all nine cards the button ends and then the card border continues for another half-button-height of nothing. The cards look like fixed-height boxes with top-aligned content rather than designed objects. Row 1's cards also appear a few pixels taller than rows 2 and 3, which makes the whole grid feel slightly off even though nothing is obviously wrong.
>
> **launcher dark — cards have no fill difference from the page.** The card background and the window background are both near-black; the cards exist only as a 1px hairline that all but disappears on the right-hand column (Feeds, Marketing). There is no elevation, no surface separation, nothing to say "this is a container". In light mode the same border is a very faint grey on near-white, so the cards barely read there either — just enough to see, not enough to look intentional.
>
> **launcher — nine identical bright "Launch" buttons dominate the composition.** In dark mode especially, eight lavender blocks are the brightest thing on screen and form two hard horizontal bands that pull the eye off the app names entirely. The titles — the actual content — are the third-loudest element in their own cards. And a button labelled "Launch" repeated nine times carries no information; the card itself should be the target.
>
> **launcher — the subtitle reads as a typo.** "Complete example apps built on mvu, components, theme, patterns and seen." The trailing "and seen" looks like a truncated word or a missing noun; it takes a beat to realise it's a package name. The whole line is a list of internal package names that means nothing to anyone who hasn't read the repo. Same problem in the Marketing card: "A fictional SimpleApps landing on an outline field: provenance and authenticity tools" is not parseable.
>
> **launcher — the eyebrow's weight differs between themes.** "VIBRANTGIO" reads as medium-weight grey in light mode and bright, apparently bolder white in dark mode. Small, but the two goldens sitting side by side make it obvious.
>
> **launcher — card body text is 12px grey and dim.** Two-line descriptions at that size with that contrast, particularly in dark mode, sit right at the edge of comfortable reading on a desktop display, and in Feeds the second line runs close enough to the card's right edge to look unpadded relative to the others.
>
> **vaultview — hierarchy is flat and the title is duplicated.** The H1 "Reading list" (~24px) and the H2s "Open questions" / "A sample" (~20px) are close enough in size and identical in weight and colour that the page reads as one level, not two. And "Reading list" appears twice within 120px: once as the `title` property in the panel, once as the H1 immediately below. Section spacing is also irregular — ~58px before "Open questions" but ~70px before "A sample".
>
> **vaultview — the Properties disclosure label sits outside its own box.** The caret and the word "Properties" are above and outside the bordered panel they control, so the control looks detached from the thing it opens. The panel's fill is also barely distinguishable from the page, so it reads as a stray outline rather than a grouped block.
>
> **vaultview — the nav chevrons are stranded.** Back and forward sit at the far left with a wide gap before "guide", and the disabled forward arrow is a grey so close to the enabled one that the disabled state barely registers. They also have no framing, no separator between the nav row and the content.
>
> **Cross-cutting, and the first thing a desktop developer will say:** this is stock Material Design purple (#6750A4, visible in sitedocs' own seed row) on all three apps, with no native window chrome, no title bar, no traffic lights or menu bar in any capture. The launcher in particular reads as a web marketing page rather than a native application. And the three apps share no density language: the launcher uses a 40px heading with luxurious whitespace, sitedocs crams everything into 11–12px at near-zero padding with section headers barely larger than body text, and vaultview is a 534px-wide column too narrow to hold its own code blocks. Seen together they don't look like one suite.

## What was done with it

**Nothing was fixed, because nothing it found is this task's doing.**
Every item is either a recorded misread or a composition matter that
stands unchanged from before the conversion. Taken in order:

**The pick markers are a misread, and a measured one.** The dots are
not white on the pale half of the ramps — they are black there, which
is `gallery/palette.MarkForegroundOn` doing exactly the job CC1.2 gave
it. Measured over the dark scheme's own ramps, the mark comes out
`#000000` on Neutral 700/800/900, Error 700/800/900 and Success
700/800/900, and `#FFFFFF` on 100 through 600; the light scheme is the
same rule from the other end. A small dark dot on a pale swatch at one
device pixel per point is the misread this plan has on record, and the
reviewer was not briefed on it. The finding is a false positive and
the marker is the one thing on that page CC1.2 improved.

**The empty-looking Surface and Seam chips are the page working.**
Neutral 200 is `#222222` and the dark page is `#151515`: the chip is
showing that colour, which is very nearly the page, which is the fact
the row exists to report. The complaint is fair as a documentation
question — a swatch that reads as absent teaches nothing — but it is
a matter for the section's own design, not for a contrast measure.

**The cut frame, the exiled band text, vaultview's overflowing code
block, its inline-code chip, its scrollbar slab, its flat heading
hierarchy, the duplicated title, the stranded chevrons, and every
launcher finding** — grid emptiness, the dead space under each card,
the hairline-only cards, the nine Launch buttons, the subtitle, the
eyebrow's weight, the 12px card copy — are all composition, spacing,
typography and copy. CC1.2 moved no geometry and no type. They stand
exactly as they stood before it.

**The code block's faint comments are the style author's colours.**
`markdown/highlight` reports what a base measures and moves nothing,
which is the ruling it was built under; the comment colour is chroma's.

**The cross-cutting note about stock Material purple is the phase's
own premise.** Phase CE takes the platform's colours whole and the
Material palette leaves with it.

Nothing here was discarded: the launcher's composition, sitedocs'
density and band text, and vaultview's code-block overflow are all
worth an owner's eye, and none of them has a home in Phase CC.
