---
date: 2026-09-08
task: BW3.1
phase: BW
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BW3.1 fresh-eyes review — the vault window with a heading word under the command key

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, the frame's own seam not being a scrollbar, and a still capture
being unable to show a fade, an animation, or the pointer — and told
nothing else.

## How the captures were taken

**No window was opened.** The whole vault window was rendered headlessly
at 1100×800, one device pixel per point — the size the application's
window opens at — in the light scheme and in the dark, from the note
column's own static renderer. Each render was driven through an input
router: the command key held and the pointer moved onto the word
"questions" in the second paragraph, the word a heading of the same note
("Open questions") holds. The two images the reviewer read are the
frames that followed.

The reviewer was given only the two held frames. The at-rest pair was
rendered afterwards, for the measurements below.

## The reviewer's reply, verbatim

> I looked at both files at pixel level as well as at 1x. Here's what a macOS daily driver would object to, in the order they'd notice it.
>
> **The Command-hover does nothing you can see.** That's the whole point of these two captures, and the affordance is missing. The word "questions" (note column, x≈355–424, y≈319) is already a coloured, underlined link at rest — exactly like "the principles" and "Sources" one paragraph up. Holding Command changes it from `#723AD4` to `#804ED8` in light and from `#D0C4FF` to `#D5CAFF` in dark. That is a five-to-six-percent lightness nudge on ~100 glyph pixels; it is invisible at 1x, and it's the *only* thing that happens. No highlight rect behind the word (the fill there is still `#F1F1F1` / `#181818`, unbroken), no preview popover, no destination echoed anywhere — and the bottom-left of the note column, where "21 lines" sits, is exactly the slot where a link target would normally be shown while you hold the key. Anyone coming from Obsidian, Xcode, or VS Code expects Cmd-hover to produce an unmistakable state change plus a peek at what's on the other end; here you can't tell the modifier registered at all.
>
> Worse, in light mode the hover moves the *wrong direction*. `#723AD4` on `#F1F1F1` is about 5.7:1; the hovered `#804ED8` is about 4.6:1. Hovering makes the target *weaker* and drops it to within a hair of the 4.5 floor. Dark mode goes lighter too, which there is correct — so the two schemes are applying the same lightening rule and only one of them means "stronger."
>
> **The two side panels are built to different rules.** The folder rail is an inset card: it starts at x=9, is boxed by a 1px `#BABABA` border at x=8 and x=247, and is inset 8px on all four sides, floating on a *third* fill (`#CFCFCF` light, `#111111` dark) that appears nowhere else on screen except as that thin gutter down the left edge and under the card at the bottom. The outline/backlinks panel on the right (x=781–1099) has the same fill as that card but no border, no inset, and runs flush into the window edge. Same architectural role, two different treatments — and macOS sidebars are flush, full-height, and translucent, not floating bordered boxes. Related: there's a sidebar-collapse toggle at the rail's top-right and no equivalent for the right panel.
>
> **Nothing is reserved for the window controls.** Content begins at y=0: the rail's outer gutter at the top, "Second Brain" baselined at y≈25 in the note column. There are no traffic lights anywhere, and if the title bar is hidden (which this layout implies), the close/minimise/zoom buttons would land on the folder card's top-left corner, right above the search field. There's also no obvious drag region.
>
> **The code block is wearing a text field's clothes.** The box at x=272–749, y=443–485 has a 1px `#797979` border and rounded corners — the *identical* border colour and weight as the "Find a note…" search input in the sidebar, which is 40px tall to this one's 48px. Its content, the word "code", is greyish (`#4C4F69`) and vertically centred like placeholder text. Every macOS developer will read that as an empty, possibly disabled text field and click it expecting a caret. Its fill also doesn't agree across schemes: `#EFF1F5` on `#F1F1F1` in light is no fill distinction at all (the border does all the work), while `#1E1E2E` on `#181818` in dark is a visibly blue box.
>
> **The selected outline row is a different design in each scheme, and it isn't the user's colour.** Light: `#D8CEFF` wash with the normal dark label on top — a very quiet selection, barely separated from the `#E3E3E3` panel. Dark: `#3F0085`, a fully saturated violet block with near-white text — the most aggressive colour on the screen, and a saturated near-primary violet on near-black is precisely what macOS dark mode avoids. Same state, two different patterns and two very different levels of prominence. On top of that it's hardcoded purple: this app ignores the accent and highlight colours set in System Settings, and the body links are purple rather than following the accent either. That's a standing complaint about any Mac app that ships its own selection colour.
>
> **The three columns don't agree on where the bottom is.** The rail's "Rescan / Switch Vault" text sits at y≈760–772 above a 1px rule at y=743, and the card stops 8px short of the window bottom. "21 lines" in the note column sits at y≈783–791 — about 20px lower, with no rule above it and only 8px of clearance below. The right panel has no footer at all and just runs out after "No notes link here." at y≈749. There's no single status line across the window, and the two things that *are* footers are visibly out of register.
>
> **Smaller things that would still get mentioned.** The text isn't in the system font — the straight-legged R, the single-storey g, the digit forms in "21 lines" are Roboto-family, not SF Pro, so the app won't match anything else on the desktop and won't track the user's text-size settings. The divider weights are inconsistent: the card border is `#BABABA`, the note/right-panel seam is `#D4D4D4`, and the rule between Outline and Backlinks is also `#D4D4D4` but only 1px against `#E3E3E3` — nearly invisible. The selected outline pill is off-centre in its panel (15px of inset on the left, 22px on the right). Disclosure controls are chevrons where a Mac outline view uses triangles. And the vault name "Second Brain" is parked over the note column while "Switch Vault" lives at the bottom of the folder rail — the label and its control are at opposite corners of the window, and on a Mac that name belongs in the window title or the sidebar header.

## What was measured against the reply

**The word is not a link at rest.** The reply's first sentence rests on
it being one, and the at-rest pair says otherwise. Over the box the
reviewer named (x 355–425, y 310–328), the at-rest capture holds one
foreground: `rgb(19,19,19)` in light and `rgb(238,238,238)` in dark —
the page's prose, on the page's own fill, with no underline. The held
capture holds `rgb(128,78,216)` and `rgb(213,202,255)` over the same box,
plus the underline. So the command key turns prose into a link and back,
which is 16.5:1 prose against 4.7:1 link in the light scheme: a change of
hue, of value and of decoration, not a five-percent nudge. The reviewer
had only the held frames and read the word against the two ordinary
links a paragraph above it, which is the comparison the picture offered.

**The hover treatment does move the wrong way in the light scheme.**
Measured: the document's link colour is `rgb(114,58,212)`, 5.68:1 on the
light page; the hovered colour is `rgb(128,78,216)`, 4.65:1 — a fifth of
the contrast given up, landing a hair above the 4.5 text floor. In the
dark scheme the same rule reads 11.0:1 against 11.6:1, a gain. The
reviewer's two numbers are right and their reading of them is right.
This is the paragraph's own hover treatment for every link in the
library, not something this task introduced — and a heading word is only
ever seen hovered, so it always wears the weaker of the two colours.
Recorded for pooling; changing it moves link pixels in every repo that
draws one.

**A heading word is drawn exactly like any other link.** True, and
ruled: the Language says a heading word *is* a link while the key is
held — the same fill, the same underline, the same pointing hand. What
the reviewer is asking for underneath it is a way to tell a destination
inside this note from one outside it, which no link in this system
distinguishes today. Recorded for pooling as a question about links, not
fixed here.

**No destination is echoed anywhere.** True. The note column's foot
carries the line count and nothing else, and the window has no place
that says where a link goes. It is an application's job, not the
document's; recorded for pooling.

## What was changed

Nothing. Every finding is either a misread the at-rest pair settles, a
ruled property of the heading word, or a defect wider than this task:
the link hover's direction in the light scheme belongs to
components/paragraph and moves every link in the org; the rail card
against the flush right panel, the reserved window-control strip, the
code fence reading as a text field, the outline selection's two
treatments, the three columns' feet, the typeface, and the divider
weights are the vault window's and the theme's.

## For pooling

- The link hover treatment lightens in both schemes, so in a light
  scheme a hovered link loses contrast (5.68:1 → 4.65:1, measured
  against the light page). A hover should read as stronger in both.
- Nothing distinguishes a link that goes somewhere inside the document
  from one that leaves it, and nothing anywhere in the window says where
  a link goes while the pointer is on it.
- The vault window's rail is an inset bordered card while its right pane
  is flush and unbordered; the two panes have no common footer line, and
  the three columns end at three different heights.
- The window reserves no strip for the window controls.
- A code fence and a search field wear the same border colour and
  weight, so a fence with one short line reads as an empty text field.
- The outline's selected row is a pale wash in the light scheme and a
  saturated slab in the dark one: one state, two treatments, and the
  dark one is the more pronounced.
- The application ships its own accent rather than following the
  platform's, and sets its text in a face that is not the system's.
