---
date: 2026-09-10
task: CA2.1
phase: CA
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CA2.1 fresh-eyes review — mindchat's conversation in both schemes

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, the window frame's own seam not being a scrollbar, and a still
capture being unable to show a fade, an animation or the text cursor —
and told nothing else.

## How the captures were taken

**No window was opened.** The whole mindchat window was rendered
headlessly at 1024×768, one device pixel per point — the size the
application's window opens at — by `TestWholeWindowRender` in
`workbench/mindchat`, run with `-window.dump`. Four frames were handed
over: the two `-stream` ones, which catch a conversation part way
through so all four kinds of line stand in one viewport at once (two
settled exchanges, one of them failed, a third prompt with a note under
it and the answer not yet started), and the two `-pane` ones, which
carry the longer settled conversation with its lists and code fence.
Light first in each pair.

## The reviewer's reply, verbatim

> I read all four. Here is what I would actually complain about, in rough order of how fast it would come out of my mouth.
>
> **It isn't using the system font.** Every string in the window — the sidebar labels, "Send a message", the message body, the code block — is set in a Go/Roboto-family face, not SF Pro. The straight-legged `R` in "Reactive layouts", the loose tracking, and the mono forms in `for _, msg := range` give it away instantly. Related, and worse because it's a content bug: the bulleted list in the pane shots renders "an editor's cursor" and "the caret's blink phase" with straight ASCII apostrophes. On macOS that reads as raw unprocessed output.
>
> **The traffic lights are hand-drawn, and the metrics are wrong.** They measure 14px across at a 23px centre pitch, with the red centre at x=25.5, y=26. Apple's are 12px at a 20px pitch, ~20px in from both edges. They're also sitting inside the sidebar's inset card rather than at the window's own corner, which is what pushes them the extra 6px in and down. Flat discs with no rim shading, too.
>
> **There is no toolbar on the right side of the divider.** I measured it: from x=248 to the right edge, the band from y=0 to y=44 is `#f1f1f1` — byte-identical to the message-stream fill below it, with no separator, no material, no anything. The chrome strip you built exists only over the sidebar and dies at x=247. So "Reactive layouts" and the `OpenAI · gpt-5.5` picker are just floating on the scroll surface, and in the pane shots the first bubble already comes within 22px of the picker with nothing between them. Content will slide straight under the title.
>
> **Nothing lines up.** Left edges going right: divider at 247, composer at 256, title text at 260, assistant avatar at 341, message text at 386. Right edges: message column ends at 925, the model picker at 1009, the composer at 1015, the scrollbar at 1021 — four different right margins inside 96px. The two hairline dividers use two different insets (the sidebar's runs x=20–235, eleven px in; the composer's runs x=260–1011, four px in). And "Searching the web…" in the light/dark stream shots is centred on the *pane* (centre x=630) instead of on the message column (centre x=656), so it sits 25px left of everything above it and reads as an accident.
>
> **Corner radii are from 2009.** The composer field and the code block round at ~2px; the model picker at ~2px on its stroke; the sidebar selection is radius 0. On a Mac in 2026 a 40px-tall text field with a 2px radius and a hard 1px `#797979` border is an HTML `<input>`, full stop — especially since the divider nine pixels above it is `#d4d4d4`, five times lighter. Two hairlines in the same 10px band at wildly different weights. Dark mode does the same thing (`#6d6d6d` border, `#2e2e2e` divider).
>
> **The sidebar selection is the VS Code idiom, not the macOS one.** It's a full-bleed square band, x=9 to 246, 42px tall, with a 2px accent stripe pinned to the left edge. macOS uses an inset rounded rectangle with no stripe. And the purple is hard-coded — `#723AD4` in light, `#3F0085` fill in dark — so it ignores whatever accent and highlight colour I've set in System Settings. Same for the dark fill, which is a very saturated deep purple running the full width of the row.
>
> **In light mode the conversation list looks disabled.** The three unselected names measure `#5C5C5C` — exactly the same grey as the "Send a message" placeholder and the "Searching the web…" status line. The selected row's label is near-black. So light mode reads as one live item and three greyed-out ones. (Dark mode is `#CCCCCC` and fine; this one is light-only.) The same grey on the placeholder is too dark in the other direction — at 6.4:1 on white it reads like text already typed into the field.
>
> **The window frame is finished on one half only.** An 8–9px gutter of `#CFCFCF` (`#111111` in dark) wraps the sidebar card's left, top and bottom, then stops dead at the divider. The result is that row 0 and row 767 of the window are two-tone: grey from x=0–247, `#f1f1f1` from 248–1023, all the way across. The top-right and bottom-right corners are hard 90° squares while the top-left and bottom-left are rounded at ~5px.
>
> **The iconography is four different systems.** A solid filled gear next to "Settings", a 2px stroked rectangle for the sidebar toggle, a thin `+` beside it, a filled pencil and a thin `×` in the selected row, and a solid filled disclosure triangle in the "HTTP 410: Gone" card — Apple moved outline-view disclosure to a chevron several releases ago. Nothing is SF Symbols and nothing shares an optical weight. The row actions are also ~12px glyphs at ~6px spacing, far under a 28pt hit target, and they're permanently visible rather than revealed on hover — including an unread dot on the conversation I am currently reading.
>
> Two smaller ones. The scrollbar knob in the pane shots is `#898989` in light and `#878787` in dark — the same mid-grey both ways, where macOS uses black-at-50% over light content and white-at-50% over dark, so in dark mode it's a conspicuously bright bar. And red is doing two jobs 150px apart: `for` and `range` are red keywords in the code block, and red is the error colour on the 410 card right below it.

## What was fixed

One finding, and it is this task's own: **the system note was centred on
the band rather than on the column of text.** The band a turn stands in
carries the assistant's mark in a gutter down its leading side, so a line
centred in the band lands a half-gutter — 25 dp, exactly the reviewer's
measurement — left of the prose above it. `systemNote` now centres on the
same column the answer's text and the prompt's card read to, and the two
stored conversation goldens were regenerated with that as the cause.

## What was not fixed, and why

Everything else is outside what CA2.1 changed. Recorded here rather than
discarded, grouped by where it would have to be answered:

- **Not the platform's font, and straight apostrophes in body text.**
  The typeface is the theme's, org-wide. The apostrophes are the demo
  conversation's own source, not a rendering fault.
- **The window controls' metrics, the missing toolbar band on the
  content side, the frame finished on one half only, the two dividers at
  two insets.** All of this is the window's chrome and its frame — the
  composition Phase V and the floating-pane work own, not the
  conversation inside it.
- **Four different trailing margins.** One of the four is now this
  task's: the conversation stops at its measure and therefore short of
  the composer and the scrollbar. That is the measure doing its job, and
  a reading column that ran to the same edge as the composer would be
  the defect the measure exists to prevent.
- **Corner radii, the sidebar's selection idiom, the hard-coded accent,
  the light scheme's list greys, the placeholder's grey, the scrollbar
  knob's one mid-grey in both schemes.** Token and component questions,
  each of them org-wide rather than mindchat's.
- **The alert's filled triangle.** `components/alert` draws one chevron
  for all four statuses and says so; the per-status icon set is already
  waiting on `components/icon`.
- **The iconography being four systems, and the row actions' hit area.**
  The conversation list's own, untouched here.
- **Red doing two jobs.** The code fence's keyword red is the chroma
  style's and the failure's is the Error role's; whether a chat body's
  syntax colours should be held off the status hues is a ruling, not a
  patch.
