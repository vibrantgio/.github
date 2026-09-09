---
date: 2026-09-09
task: BX1.2
phase: BX
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BX1.2 fresh-eyes review — the themer window offering the macOS accent colour

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, and a still capture being unable to show a fade, an animation, a
hover state or the pointer — and told nothing else.

## How the captures were taken

**No window was opened.** The whole themer window was rendered headlessly
at 1040×820, one device pixel per point — the size the application's
window opens at — by `TestFollowingDump` in `workbench/themer`, which
writes four PNGs under `-themer.dump=DIR`: the light scheme and the dark,
each with the last cell of the candidate row offered and then chosen. The
model behind them is a real extraction of the painted scene the package's
own tests drop, with the platform reporting systemBlue.

The reviewer was given all four and told only that the third and fourth
are the first two after a click on the last card in the row.

## The reviewer's reply, verbatim

> I read all four. Here is what jumps out, as a Mac user.
>
> **The window has no title bar and no traffic lights.** The app's own header starts at y=0: "Themer" and "Back to styles" sit exactly in the 70pt strip macOS reserves for close/minimize/zoom. If this is a real window, those controls are either absent or landing on top of the app's own text. My first reaction is "how do I close this, and where do I grab it to move it?" Nothing in the top 55px reads as draggable chrome.
>
> **The bottom edge cuts content in half.** In the two "offered" shots the Warning row is sliced through the middle of the word: half the label, a sliver of colour, then the window ends. That is the single ugliest thing in the frame. It doesn't read as "scroll for more", it reads as a rendering bug. In the "following" shots the Neutral row is flush against the last pixel of the window with zero bottom padding, and the rounded panel never gets a bottom corner. Every panel bleeds off the edge.
>
> **Clicking the macOS accent card throws away my file.** I dropped in harbour.png. I clicked the last card, and now the header thumbnail is a flat blue rectangle labelled "macOS accent colour" and the filename is gone. But the subtitle still says "syntax base github by day, dracula by night", the row still shows harbour-derived candidates with their percentages, and it still says "drop another image to replace it". So the image is obviously still loaded, the header is just lying about it, and there is no visible way back to "harbour.png". Picking a swatch should not overwrite the identity of the document I opened.
>
> **The appearance toggle is manual, and there's no "follow the system".** Two states, sun and moon, with a blue thumb. On a Mac I expect the window to change with System Settings, or at minimum to offer Light/Dark/Auto. Worse, the control is ambiguous: a blue pill covering half a track reads as an on/off switch, not a two-way picker, so blue-over-sun looks like "light mode is switched on" rather than "light is selected". A segmented control would be unmistakable. It's also a small hit target for something this consequential.
>
> **There's an always-on scrollbar hugging the panel's right edge**, a thin hairline overlapping the rounded corner, with the caption text ending a few pixels from it. macOS scrollbars are overlays that stay out of the way; this one is permanently parked in the layout and crowds the text next to it.
>
> **Layout jumps between states.** In the "offered" shots Palette Seed has two rows (Seed and Lifted seed); after clicking, it drops to one, everything below shifts up about 60pt, and the panel keeps a tall empty area under the single remaining row. Same panel, same scroll position, contents teleport.
>
> **The typeface isn't SF.** The letterforms and digits read as a generic sans, and on macOS that's noticeable immediately: the window doesn't look like it belongs to the OS even before you get to anything else.
>
> **The copy reads like a debug legend, not a UI.** Long grey run-on sentences right-aligned in every section header, separated by middle dots: "a dot marks where each pick lives · nine steps a role · 100 nearest the page · each row ends with its role's pinned base, and Neutral pins none". Three of them stacked down the page, all competing with their own section titles, all low-contrast grey. And the sentence changes per appearance ("Lifted seed" in light vs "Lifted seed pinned in the light scheme" in dark), so the app is narrating its internals at me.
>
> **Nothing here is adjustable.** It's called Themer, but every control is either a card to click or a button that says "Keep this theme". No way to nudge the hue, no discard, no undo, no indication of what "keep" writes or where. The only exit is a text link top-left.
>
> Smaller stuff: the dot markers on the ramp cells drop to near-invisible in a few places (white on salmon at Error 700 in dark, black on mid-blue at Primary 500 in light); "drop another image to replace it" is plain grey text right next to a real filled button, so it reads as a disabled second button; and the dark page background is close to pure black with near-white text, which is more glaring than the dark grey Mac apps generally use.

## What was fixed

**The identity block no longer changes when the last card is clicked.**
This was the one finding about the work this task did, and it was right:
the first draft renamed the identity block to the setting's name and
replaced the picture on the mat with the platform's colour while the
window followed. The reviewer read that as the window having discarded
the file, with the caption, the candidate row and the standing offer all
still describing it. Choosing the platform's colour is choosing a colour,
not opening a different document, so the picture and its name stay
exactly where a click on any other card leaves them, and what says the
choice is what says it for every other card: the ring on the cell, and
the line under the tab strip naming the colour the page is rendered
from. `TestFollowingLeavesThePictureWhereItIs` pins it.

## What was not fixed

Everything else the reviewer saw predates this task and is untouched by
it. Recorded here rather than acted on:

- **No title bar, no window buttons.** A capture artifact. The window
  carries the full-size-content treatment and the platform draws its
  three buttons into the title row at runtime; a headless render has no
  window, so `windowButtonsEnd` reports zero and the row leads at the
  page margin instead of past them. `TestTheTitleRowLeadsPastTheWindowButtons`
  covers the real placement.
- **Content cut at the bottom edge.** The tab panel is a scroller and the
  capture is at the top of it; the panel reaching the window's own margin
  is the layout.
- **The scheme switch has no "follow the system" state.** It opens on the
  desktop's answer and takes the window's own from the first press, with
  no third position and no way back — a real gap, and about light and
  dark rather than about the theme colour.
- **The permanently visible scrollbar**, the **section captions** reading
  as a debug legend, the **near-black dark page**, the **ramp dot markers**
  that lose contrast on a few cells, and the **standing offer** reading as
  a disabled button beside the keep affordance.
- **The face is not SF.** The design system ships its own faces.
- **Nothing is adjustable.** The window offers colours to choose, not a
  colour to build; a hue control is a different application.
