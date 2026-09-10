---
date: 2026-09-10
task: CB2.1
phase: CB
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CB2.1 fresh-eyes review — mindchat's settings dialog with a live and a failed key

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about in this window? It was briefed on the recorded
misreads — a dark foreground reading grey at 1x, the chrome regions
sharing one fill by design, a light card standing white on off-white by
design, the window buttons being stand-ins painted by the harness, a
still capture being unable to show a fade, a hover, a focus ring or a
text cursor, and the default-model menu staying inside the dialog by
ruling — and told nothing else.

## How the captures were taken

**No window was opened.** The whole mindchat window was rendered
headlessly at 1024×768, one device pixel per point — the size the
application's window opens at — by `TestWholeWindowVerdictRender` in
`workbench/mindchat`, added in this task and run with `-window.dump`.
Four frames were handed over: the settings dialog open on a provider
whose key the last `/models` fetch accepted (the Success verdict) and on
one whose key it rejected (the Error verdict), each in both schemes.
Light first in each pair.

## The reviewer's reply, verbatim

> I read all four. Findings, ranked.
>
> ## 1. Not one of the three text fields has a label
>
> The right-hand pane is a bare stack at x=414: a field containing "OpenAI", a field showing `https://api.openai.com/v1`, and a field of dots. Nothing says which is the display name, which is the base URL, which is the key. On macOS every prefs field carries a right-aligned label to its left — and this dialog proves it can, because "DEFAULT MODEL" one row down *is* labelled. Two consequences a dev hits immediately:
>
> - The URL field is rendered in placeholder grey (light: `#5C5C5C` vs the name field's `#131313`), so it is actually *empty*. You can only learn that by staring at two shades of grey. In dark the two collapse: placeholder `#CCCCCC` vs value `#EEEEEE` — indistinguishable at a glance, so in dark you genuinely cannot tell whether a custom endpoint is configured.
> - "OpenAI" appears three times in one 350px-wide region — selected list row, first item of the top row, and the name field — with no indication that they are different things.
>
> ## 2. The rejected-key feedback is a raw HTTP string, in the wrong place, in the success slot
>
> `HTTP 401: invalid_api_key` is a verbatim provider error code, snake_case and all, shown to the user. No plain-language "that key was rejected", no next step (check the key, check the base URL, check billing).
>
> Worse is where it sits: x=415, y≈468 — 86px *below* and 315px *left* of the red ✗ at (738, 382) that it explains. It lands in the gap right above the DEFAULT MODEL row (13px away) and far from the checkbox above it (36px away), so it optically attaches to the model picker, reading as "the model list failed" rather than "your key was rejected". And it occupies the exact slot that says "2 chat models listed" in the good state, so success text and error text are the same line — the model count silently vanishes on failure.
>
> Meanwhile the default-model popup and the window header both still confidently read "OpenAI · gpt-5.5" while the provider is rejecting every call. Nothing in the bad state contradicts them.
>
> ## 3. The row of four provider names is an unlabelled dead tab bar
>
> "OpenAI  xAI  OpenRouter  Groq" at y≈241 has no selected state at all — I sampled all four labels and they are pixel-identical (`#131313` light, `#EEEEEE` dark). No underline, no pill, no box. Directly below-left is a PROVIDERS list that *does* have a selection and its own + / − buttons, and that list contains only two of the four names. So: are these tabs (then they contradict the list and none is selected), chips that add a provider (then they don't look like buttons), or a static "we support these" note? Nothing answers it.
>
> Their spacing is distributed by centre, not by gap, so the gaps read uneven: OpenAI→xAI is 66px, xAI→OpenRouter 52px, OpenRouter→Groq 49px.
>
> ## 4. Dark mode loses structure the light scheme has
>
> - **The PROVIDERS list box disappears.** Light: panel `#E7E7E7` on a `#FFFFFF` dialog — a clear card. Dark: panel `#2B2B2B` on a `#2E2E2E` dialog, a 3-level difference. The list has no container, and the + / − buttons at (267/295, 465) float on nothing.
> - **Text fields nearly vanish too**: fill `#393939` on `#2E2E2E` is 11 levels; the fields survive on their 1px border alone.
> - **Prominence is inverted between the schemes.** Light: selected row is a pale `#D8CEFF` tint, Save is saturated `#723AD4` with white text. Dark: the selected list row is a full-strength `#3F0085` slab while Save is pastel `#D0C4FF`. In the dark capture the loudest thing in the dialog is a list row, and the primary button is the palest — it reads as disabled next to it.
>
> ## 5. The field stack has a ragged right edge
>
> Name and Base URL run 414→771. The API key field stops at 721 so the ✓/✗ and the retry glyph can sit outside it. Three stacked fields, two widths, 50px of step. Reserve the icon gutter on all three (or put the state inside the field) so the column ends on one line.
>
> ## 6. Cancel is not drawn as a button
>
> It is bare text at (613, 557) next to a filled Save. macOS pairs a bordered push button with the default button; as drawn, Cancel reads as a link and its hit area is unguessable. Related: light Save is tinted like a default button, dark Save is not, so "what does Return do" changes with the colour scheme.
>
> ## 7. The one label in the dialog is orphaned, and the two popups disagree
>
> "DEFAULT MODEL" sits at x=251 — in the *left* column, tucked under the providers panel — while its popup starts at x=512. That's ~260px of dead space between label and control, and the label optically belongs to the panel above it. It is also styled exactly like the "PROVIDERS" list header (same small-caps grey), so a section header and a field label are indistinguishable.
>
> The popup itself shows a single ▲. The identical model chooser in the window header shows a single ⌄. macOS pop-up buttons use the up/down chevron pair; here two controls that set the same value use two different indicators and neither is the platform one.
>
> ## 8. The checkbox reads like a changelog entry and its scope is wrong
>
> "Web search tool (server-side; xAI and OpenAI)" — a semicolon-ed parenthetical is release-note prose, not a control label. And it names two providers while living inside the *OpenAI* provider pane, so there's no telling whether ticking it affects this provider or the app. If it's global it belongs outside the per-provider panel.
>
> ## 9. Vertical rhythm breaks at the bottom of the pane
>
> Fields are 10px apart (302→312, 352→362), the checkbox is 17px under the last field, then there is a 36px void before the status/error line — which then sits only 13px above the DEFAULT MODEL row. The status line is closer to the control it does not describe than to the one it does. That's the mechanical cause of finding 2.
>
> ## Nits
>
> - The status ✓/✗ is a 16px filled circle (730–745) and the retry is a ~12px ring (757–768). Both are icon-only, unlabelled, well under a 24pt target, and the *non*-interactive one (status) is the one drawn as a solid button-like disc, so it's the more clickable-looking of the two.
> - The checkbox box starts at x=416 against a field column edge of x=414 — 2px out of the grid.
> - "2 chat models listed" is passive and dead-ends: listed where? There's no way to see them from here.
> - Settings is a modal centred over the conversation, blocking the whole app — a Mac dev expects ⌘, and a real Settings window, and would notice they can't scroll back to copy something out of the chat while pasting a key.

## What was fixed

Nothing. Every finding lands outside this task's two changes, and the
two that land on them are the ruled design rather than a defect:

**Finding 6, Cancel is not drawn as a button.** This is the task's own
decision looked at cold, and it is worth keeping the reviewer's words
for whoever revisits it. The complaint is not that the label vanishes —
it measures 6.69:1 on the dialog's white fill in light and 8.46:1 on its
`#2E2E2E` fill in dark — but that the least pronounced emphasis carries
no resting face, so nothing outlines where the hit area is. That is what
Ghost *is*: no fill at rest, the surface's own walk under the pointer.
The bordered push button this platform draws beside a default button is
not a variant components offers, and outlined was refused as a fourth
emphasis on purpose (a border is a property of a surface, not a step on
a prominence scale). The alternative in the task's gift, Tonal, was
rendered and rejected: its tint measures 1.48:1 against the dialog in
light and 1.45:1 in dark, which puts a second purple button beside Save
and reads as a pair of equals rather than as one default action — and in
dark it would stand *darker* than the pastel Save the reviewer already
calls the palest thing in the dialog. So Ghost stands, and whether a
plain resting face belongs on the prominence scale is a question for the
button's emphasis axis, not for this dialog.

**The nit about the verdict disc looking more clickable than the retry
ring.** The disc is the ruled shape: the verdict was a green disc with a
check before the badge conversion and this task put it back. What the
nit is really about is the re-check affordance beside it, which is a
~12px ring with no button face — the same complaint the pool already
carries about the `+` and `−` under the provider list.

Everything else is recorded for pooling. Several are sharper measurements
of complaints the pool holds from BV1.4 (the unlabelled fields and the
orphaned DEFAULT MODEL caption, the chromeless row of provider names, the
provider lists disagreeing, the dark provider panel standing three values
off the dialog, the selection prominence swapping between schemes, and
settings being a modal that commits with Save). What is new: the base-URL
field showing a placeholder that cannot be told from a value in dark; the
raw HTTP error string, its placement 86px below and 315px left of the
verdict it explains, and its occupying the slot the model count uses so
the count vanishes on failure while the header and the picker go on
naming the model; the text fields surviving on their border alone in dark;
the ragged right edge where the key field stops 50px short of the two
above it to make room for the verdict and the re-check; the two chevrons
disagreeing between the dialog's picker and the header's; the web-search
checkbox's release-note wording and its unclear scope; and the vertical
rhythm at the foot of the pane that puts the status line nearer the row it
does not describe.
