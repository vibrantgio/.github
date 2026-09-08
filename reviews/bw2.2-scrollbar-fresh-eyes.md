---
date: 2026-09-08
task: BW2.2
phase: BW
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BW2.2 fresh-eyes review — the scrollbar while a search is on

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about? It was briefed on two recorded misreads — a dark
foreground reading as grey at 1x, and a light card standing on an
off-white background by design — and told nothing else.

## How the captures were taken

**No window was opened.** Two frames were rendered headlessly through
the components gallery's own capture path, each 900×520 at one device
pixel per point: the inventory's existing scrollbar section and the new
one beneath it, heading and body, in the light scheme and in the dark.
The new section shows a bar beside forty rows with five matches at
0.04, 0.23, 0.50, 0.71 and 0.96 of the content, the third of them the
current one, and the thumb parked at the start.

## The reviewer's reply, verbatim

> Read both. Here's what a Mac-native developer would file.
>
> **The scroller isn't attached to anything.** It sits at roughly x=537 in a 900px-wide panel — about 200px to the right of where the text ends, and with some 360px of empty background to its right. On macOS a scroller is always flush against the trailing edge of the view it scrolls, inside the clip view's bounds. Floating mid-canvas, it reads as decoration rather than a control: you can't tell from looking at it which region it governs, and the caption's promise "beside its content" isn't what the eye sees — it's beside nothing, in the middle of a field of empty grey. This is the first thing anyone would say about both sections.
>
> **It's a permanent thumb with no track, which is neither macOS style.** Overlay scrollers fade out when idle and, on hover, fatten and grow a visible track; legacy scrollers are always on *and* always have a track. This is a thumb that never goes away and never has a groove. The problem gets concrete in the search section: the yellow marks are strewn down a column at y≈345, 393, 430 and 474 with nothing drawn behind them, so they look like loose specks floating on the panel rather than ticks on a scroller. The marks imply a track the widget refuses to draw.
>
> **The thumb isn't at the top when the content is at the top.** Both sections say "Line 1 of 40", so scroll offset is zero, yet the thumb starts about 20px below the top of its content area in each (y≈55 where the section body starts at ~32; y≈305 where the body starts at ~288). At the extremes a Mac scroller sits flush against the end — that's how you read "I'm at the top" without looking at the content. This one hovers, so at a glance it looks like you're already scrolled slightly.
>
> **The grab target is too thin.** The thumb measures about 5–6 device pixels wide at 1x, noticeably thinner than a macOS scroller thumb, and — this is the tell — *thinner than the match ticks beside it*, which run about 9px. A tick wider than the thumb it belongs to looks backwards, and a 6px-wide target with no expanded hover state is something you'd miss with the mouse.
>
> **The current match is hidden underneath the thumb.** The one mark that's supposed to be strongest, at the top of section two, is drawn under (or inside) the thumb, so all you see is a yellow slice cutting through the grey capsule around y≈318. It reads as a rendering fault — as if the thumb broke in half — not as "you are here". In Xcode and every editor a Mac dev uses, the thumb is translucent or the marks are drawn over it, so the current match survives being scrolled past.
>
> **The marks aren't pixel-snapped, and it shows badly at 1x.** In the light shot the same colour renders at visibly different weights down the column: the tick at y≈430 is a clean bright yellow, the one at y≈393 is a muddy olive-grey, and the one at y≈474 is somewhere between. That's a 2px-tall mark landing on fractional device-pixel positions and getting smeared across two rows at half intensity each. Mac controls snap indicator geometry to device pixels precisely so this doesn't happen; here it looks like some matches are dimmer than others, which reads as meaning when it's only rounding.
>
> **Yellow is the wrong hue for both schemes, and the dark scheme is the weaker of the two.** On the light off-white panel, yellow is about the lowest-contrast marker colour available — a 2px yellow dash on #f2f2f2 is nearly gone. In dark mode the yellow has been darkened to olive against a near-black panel, so the marks are *less* present in dark than in light, which is backwards: on a dark background an indicator should gain punch, not lose it. A yellow that has to be muted to survive light mode and darkened again for dark mode is doing no work in either.
>
> **Minor, but noticeable:** each section shows five lines and then roughly a full line's worth of empty space before the divider, while the thumb claims you're seeing about an eighth of the content. There's visibly room for another line that isn't being drawn, so the viewport and the scroller disagree about where the content box ends.

## What was measured against the reply

Four of the eight items were checked against the captured pixels rather
than judged by eye.

**The geometry is snapped, and the two weights are two fills.** Every
painted match in both captures is exactly three rows tall and six columns
wide (x 536–541), fully opaque, with no antialiased edge row: the light
scheme's plain matches are #E7D700 in all nine pixels and its current one
#C6B900, the dark scheme's #4E4800 and #746E30. So nothing is smeared
across fractional rows. What the reviewer read at y≈393 as "a muddy
olive-grey" *is* the current match's stronger fill, and the row it lies on
is the one the section places at 0.50 — the current match, not a rounding
artefact. The finding that survives the measurement is the sharper one:
in the light scheme the stronger fill reads as duller rather than
stronger at this size.

**The painted extent is the thumb's own width, not wider.** Six columns
against the thumb's six: a match is exactly as wide as the thumb it
crosses, so "ticks wider than the thumb" does not hold.

**The current match is not the one under the thumb.** The current match
is the third, mid-track; the mark the thumb sits on at the top is a plain
one. The observation underneath it stands on its own, though, and is the
most useful thing in the reply: a full-width mark drawn across the thumb
reads as the thumb broken in half rather than as a match the thumb is
passing.

**The thumb is at the start of its track.** The 20px the reviewer
measured is the inventory section's own padding, which every section
carries; the bar begins where its slot begins. The same padding accounts
for the closing item: five 36dp rows exactly fill the section's 180dp
body, and the space beneath is that padding rather than a sixth row the
viewport is hiding.

## What was changed

Nothing, from the review. Every remaining finding either asks for a
ruling on the fills or the bar's own geometry, or belongs to the
specimen's framing, which the section above it shares.

The review did earn its place before it was written, though: rendering
the specimen at all caught a defect no test had — the painted matches
were taking the *major* extent as their minor one and running some 175px
out into the content beside the bar. It was fixed, and the test grew the
assertion that would have caught it: nothing carries a match's fill
outside the track's own minor extent.

## What is left for the pool

1. **In the light scheme the current match reads duller than the rest.**
   The stronger fill is the highlight walked one hover step, which in a
   light scheme walks *deeper*; on a 3×6px mark against an off-white
   panel that reads as a dimmer mark rather than a more present one. It
   is the same derivation the document marks its matches with, so a
   change belongs to both surfaces at once, not to the bar alone. A
   difference in size as well as in fill would carry at this scale, but
   "stronger" has so far meant the fill and nothing else.
2. **The dark scheme's plain fill is very quiet.** #4E4800 on a #222222
   panel is a low-contrast mark, and the reviewer's point that an
   indicator should gain presence on a dark background rather than lose
   it is worth an answer. Adjacent to the already-pooled item on the
   current match's contrast.
3. **A full-width mark across the thumb reads as a broken thumb.** The
   ruling is that the thumb never hides a match; drawing the match over
   the whole of the thumb's width is what makes it read as a fault.
   Leaving a hairline of thumb either side of the mark would keep the
   capsule continuous, at the cost of a narrower mark everywhere.
4. **While a search is on, the bar draws no track for the matches to lie
   in.** The overlay bar's track is transparent by default, so the
   matches read as specks on the panel rather than as places in a track.
   Whether a search should bring the track out is a ruling.
5. **The inventory's scrollbar specimens sit mid-panel.** Both sections
   cap their content at 520dp inside a 900px slot, so the bar floats with
   empty ground to its right instead of standing at the trailing edge of
   what it scrolls. It is the specimen's framing, shared with the section
   above, and changing one without the other would stagger them.
6. **A still capture cannot show the fade.** The reviewer read a
   permanently visible thumb; the bar's first frame is opaque by design
   so that a single-frame capture is not caught mid-fade. Worth adding to
   the recorded misreads for any future review of this component.
