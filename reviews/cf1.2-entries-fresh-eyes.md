---
date: 2026-09-13
task: CF1.2
phase: CF
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CF1.2 — the entries read against the renders, cold

Two reviewers, neither having seen the plan or the packet, split by the
groups CF1.1 used: the first took the controls and the signals, the second
the patterns and the text. Both replies are recorded as they wrote them, in
order.

## The first reply, verbatim — the controls and the signals

Measured off the captures at 1× with PIL; every value below is an encoded sRGB triple read from the named file.

## What the pixels say before the entries do

Three facts run through the whole set and decide several entries at once.

**Hover is not painted, except where it is.** The Button render's "Rest" and "Hover" specimens are pixel-identical: the only region where the two crops differ is the label glyphs themselves (difference bbox `(42,10)–(78,21)`, i.e. the word). Same for the chip: unselected Rest and Hover are both `236,236,236` light and `51,58,63` dark, while Press is a genuine step (`213,213,213` / `71,77,82`). But the paragraph's link *does* move on hover — `0,104,218 → 0,99,207` in light, `65,156,255 → 83,165,255` in dark — and the badge's close mark does too (`0,129,242` under hover, `0,123,230` under press). So this is not "a still capture shows no cursor"; some components paint the state and two headline ones don't.

**Nothing in this packet casts a shadow.** The picker's open menu, the toast and the tooltip are each bounded by exactly one hairline and nothing else. That hairline measures `230` over white and `52` over `30,30,30` — precisely black-or-white at a tenth, so the **Seam** entry's arithmetic is confirmed to the value. But the **Level** entry says a floating thing is told "by its shadow," and none of the three floating specimens is.

**Light collapses the levels.** In the chip render the "On a card" band and the "In the chrome" band are both `247,247,247` — the same number. Dark keeps them apart (`42,48,52` raised versus `28,28,28` chrome). Meanwhile content, and the window background the toast and menu are filled with, are all `255,255,255` light / `30,30,30` dark. So the five named levels resolve to two distinct fills in light and three in dark, and no render in the packet contains a backdrop at all — the **Backdrop** entry is unillustrated, and the **Chrome** entry's claim that its fill is read off a different platform source than the grouped box is not something the light render can support, since both land on the same byte.

Separately, **Toast** and **Tooltip** cite "level 2" and "level 3," a numbering the **Level** entry never introduces and which nothing drawn distinguishes.

## Entry by entry

### Button
The entry describes a fixture that offers an action and records nothing. Everything it actually asserts is invisible in a still, and everything the render shows, it does not name: five interaction states, a focus ring, an icon-only square face, and a **pinned** fill (`179,38,30`, byte-identical in both schemes — a colour from outside the theme, where the theme's own Filled accent is `0,122,255`, also identical in both schemes). Two concrete disagreements:

- The Hover specimen is rest (above).
- The disabled fill is *exactly* the Tonal fill — `236,236,236` light, `51,58,63` dark. A disabled Filled button and a Tonal button at rest differ only in label colour. The **Emphasis** entry ranks Tonal as "a secondary action"; the render gives that rank the same face as "unavailable."

The icon-only face is a fourth face the Emphasis table has no row for. It is Filled emphasis in a square, not a fourth emphasis — but the Button entry never mentions that a button has a face at all.

### Chip
The four purposes are all there and legible as purposes: `+ Set reminder` (Assist), `Unread` / `✓ Starred` (Filter, unmarked and marked), `Olivia Barnes ×` (Input), `What's due today?` (Suggestion). Two mismatches:

- Structure is given as `[icon] text [x]`. The Input chip leads with an avatar, not an icon. The entry's word does not cover what is drawn there.
- The render's whole top half is a distinction the entry does not make — the same five chips on the content, on a card, and in the chrome. And the chip's own fill is constant across all three (`236,236,236` / `51,58,63`). On the content that is a 19-step contrast; on the card and in the chrome, against `247,247,247`, it is 11. The render poses the surface question and then shows a chip that ignores it.

The read/use line against the badge is untestable in a still, and the badge render undercuts it in words: see Badge below.

### Text field
The entry is three clauses and the render shows all three, plus rest/focused/disabled which it does not name. The disagreement is upstream, with **Level**: the field interior measures `255,255,255` light and `30,30,30` dark — the content fill, no step at all. It is told purely by a hairline. Level files fields under *raised* and says flatly that standing higher is told "by the box's small step of fill, no hairline and no shadow." The field it names is told by a hairline and no step.

### Search field
The longest entry in the packet against one of the thinnest renders. Drawn: rest with placeholder, typed with the clear mark, focused. Not drawn, at all: the match count, which match is current, Enter/Shift+Enter stepping, scrolling a match into view, and the search highlight itself — the entry's central promise, that it "marks what it finds." The highlight pigment does appear in the packet, but in the scrollbar-search render (`253,249,229` light, `62,62,49` dark), never over text and never named by this entry.

### Checkbox
Matches. Unchecked, checked, focused, disabled; binary with no mixed state, as the entry implies. "Only the user's own operation repaints the mark" is not a claim a capture can bear on.

### Radio
Shares the checkbox render, and the sharing costs it. The entry's whole subject is *a group*: options that exclude each other, each shown, one chosen, choosing one clearing the rest. What is drawn is four isolated specimens in states — Unselected, Selected, Focused, Disabled — with no group and therefore no exclusivity. The handover to the picker when options grow too many is likewise unillustrated. Nothing in the pixels separates this entry's subject from the checkbox's except the glyph's roundness.

### Switch
No specimen. The entry's one load-bearing distinction — the checkbox records, the switch acts — is one a still could not show even if a specimen existed; but there is not even a face to check against "binary control."

### Picker
The best-served entry here. Both triggers are drawn and both variants are legible: the form trigger a full-width field, the chrome trigger small and compact in the toolbar. One menu, one value in the trigger, the current row marked. Two notes:

- The menu is the window background with one hairline and no shadow. Under **Level**, that is how a *raised* thing is forbidden to be told and how a *floating* thing is required to be told — the render does neither.
- The form trigger has a filled face (`236,236,236` / `51,58,63`) where the text field, also a field among fields, has no fill at all. Two controls the **Variant** entry would call the same setting are drawn on different principles, and no entry accounts for it.

### List
The entry's four distinctions are choice, the selection state, menu-as-floating-list, and table-as-list-with-columns. The render shows none of them: five plain rows, no selection, no hover, no separators, no keyboard mark, no columns. What it does show — and captions — is virtualization, which the entry does not name.

### Scrollbar
The flattest contradiction in the packet. The entry says the match marks lie "beside the thumb and never under it." Measured, thumb and marks occupy the *identical six columns*, x536–541. The thumb spans y54–75; the topmost match is painted at y60–62, inside that span, replacing the thumb's `109,109,109` with the match colour across the full width. It is not beside the thumb; it is in it.

What the entry gets right: the current match is stronger — `252,244,209` against `253,249,229` in light, `86,86,63` against `62,62,49` in dark.

What is missing: there is no track. Not a faint one; no pixels other than thumb and marks exist in that column. So "a thumb on a track whose size mirrors how much of the content is visible" has nothing to read the ratio against — with 5 of 40 lines showing and a 22px thumb, the proportion is only inferable from the marks.

The scroll-area render, filed under this entry, adds two more things it never names: a horizontal bar laid *over* the content rather than in a gutter (the list render puts it in a gutter — two placements, one entry, no distinction), and an edge dissolve that is a real gradient in the pixels, `255,255,255 → 0,136,255` over about 20 columns at each end.

### Pagination
"Page buttons flanked by previous and next." What is drawn is eight bare numerals and one filled box — only the current page has a face, so the render does not support calling the other eight buttons. Previous and next are bare solid triangles with no face and no disabled treatment; the entry says nothing about what they look like or what happens at page one. "The current page is active" is shown as a Filled face, which the entry does not say.

### Breadcrumb
Everything matches except the word "chevrons." The render draws filled right-pointing triangles — the same glyph the alert uses for its status icon and the pagination uses for prev/next. The Icon render proves actual chevrons exist in the set, captioned *disclosure*, *back*, *forward*. So this is the entry naming one glyph and the render drawing another, not a gap in the icon set. Links blue, last item plain text: correct.

### Paragraph
The entry says "styled text" and stops. The render names and shows five separate axes — weight, style, face, colour, size — and then three link states the entry does not mention. "No wider than its measure" is visible: the run wraps at about 520px inside a 900px frame. The carried-control claim is shown well. This is the one place where the render is richer than the entry in a way that matters, because the link's measured hover shift is what makes the button's and chip's flat hover read as an omission.

### Badge
Mostly sound, and two things wrong.

Sound: Neutral wears the system grey (`142,142,147`); the four statuses are the system colours; word and count utterances are there; and — checked specifically, because the entry forbids it — the dismissible badges are `0,136,255` / `0,145,255`, the **Info** system blue, not the theme accent `0,122,255`. "No badge in the theme colour" holds in the pixels.

Wrong:

- The render's own caption names "the disc," and two full rows of it — a filled status-coloured disc carrying a white check or cross. The entry's three-utterance table has no disc. It says the glyph "may stand bare," and exactly one specimen in the whole render does (the lone green check in the Utterances row); everything else puts the glyph inside a fill the entry never describes.
- The Dismissible row draws **"Filtered by owner ×"** — verbatim the example the entry rules out. The entry: a system-originated summary of view state "is plain text or a close-less badge." The render gives it a close mark, and colours it Info.
- The "Disc, a check" row is five discs of identical shape differing only in hue. Within that row, hue is the only channel — the failure the entry itself names. Form separates check from cross only across the two rows, never within one.

The claims about originator, about a developer-originated badge never being dismissible, and about the invisible hit area are unshowable by nature. "Visibly lighter than any control" is borne out across renders (badge 16px, chip 20px, button 24px, field 28px) but never demonstrated within one, since no control stands beside a badge anywhere.

### Alert
The fill is exactly as written — the content's own background inside a separator hairline (`230` light, `52` dark), rounded box, standing in flow. Two gaps:

- "An icon, a title in the text colour, a body." Every specimen is one line. There is no title-and-body pair anywhere, so the entry's structure is a distinction the render does not make.
- The icon is the same solid triangle in all four specimens, recoloured. Status rides on hue and nothing else — in the one component family where the Badge entry explicitly warns that hue alone collapses. The alert entry carries no such warning, and the render needs it.

Also unshown: an alert given no status defaulting to Info (no status-less specimen), and the no-control rule, which is shown only by absence.

### Toast
The entry describes four things that are not in the pixels.

- **The hairline.** Reading across the toast's right edge: `…255,255,255` at x275, then `247,247,247` at x276. No intermediate row. Vertically at the top edge, `247` holds to y63 and `255` begins at y64. There is no separator hairline anywhere on the toast; it is told from its column by fill alone.
- **The shadow.** None.
- **The icon.** None. The status is carried by a rounded coloured bar down the leading edge — a part the entry never mentions.
- **The close mark.** None, though the entry calls it "its only control."

The fill itself is right (`255,255,255` / `30,30,30`, the window background, the same in either scheme). But it sits in a notifications column filled `247,247,247` / `42,48,52` — the raised fill. So the floating toast is *lighter* than the thing it floats on in light and *darker* in dark, the exact inverse of the raised rule, and no entry in the packet explains why the floating level inverts where raised does not. Timing, "leaves by itself," and level 2 are unshowable.

### Tooltip
The closest match in the packet. Window background, one separator hairline at the measured tenth, text only, no status, byte-identical treatment in both schemes — every clause confirmed. One word is wrong: "beside its trigger." The render puts it above, and captions itself "shown above its trigger." Level 3, the delay, and the hover-or-focus trigger are unshowable.

### Icon
Confirmed, including the part that looked wrong at 1×: the vector icon's disc is `39,39,39` in light and `221,221,221` in dark — the foreground colour, with the surface colour cut out as the glyph. "Drawn in the foreground of what it sits in, no role of its own" survives even inverted. The render adds a category the entry does not name — "the platform control marks," disclosure/back/forward — which are precisely the entry's "part inside a control's structure," except that nothing in the render shows them inside a control. The distinction is stated and then illustrated by five loose glyphs on the content, which is the one place it does not apply.

## The short list

Words the pixels contradict: **Scrollbar** ("never under it" — the mark is painted inside the thumb), **Toast** (hairline, shadow, icon, close mark — none present), **Level** (a field with no step and a hairline; floating told by a hairline, not a shadow), **Badge** ("Filtered by owner" drawn with the close the entry forbids it), **Breadcrumb** (triangles, not chevrons), **Tooltip** (above, not beside).

Distinctions the entries make that nothing shows: **Radio**'s group and exclusivity, **Search field**'s count/current/stepping/highlight, **List**'s selection, menu and table, **Alert**'s title-and-body, **Switch** entire, **Backdrop** entire, the level *numbers* used by Toast and Tooltip, and in light the separation of chrome from raised, which measures to one number.

Things drawn that no entry names: button states, the focus ring, the icon-only face, the pinned colour, chips across three surfaces, the badge disc, the toast's leading colour bar, virtualization, the scroll-area edge dissolve and its overlay horizontal bar, the paragraph's five style axes and its link states, and the platform control marks.

## The second reply, verbatim — the patterns and the text

## What the whole set shows before any single entry

Every fill in these renders lands in one narrow band, and the Language names only part of it. Measured off the captures, light then dark:

| Painted thing | Light | Dark |
|---|---|---|
| window background (page behind card, group, hero, shell) | 255 | 30 |
| chrome — navbar, sidebar, aside, shell footer, tab strip | 247 | 28 |
| card / raised | 247 | 42,48,52 |
| table zebra stripe; markdown table header | 244 | 41 |
| code fence | 239,241,245 | 30,30,46 |
| Tonal button | 236 | 51,58,63 |
| separator | 230 on 255 | 52 on 30 |

Two consequences bear directly on **Level**.

In light, **chrome and raised are the same byte**: 247,247,247 for the sidebar and 247,247,247 for the card. A card and a sidebar are not told apart by fill at all in light; in dark they separate (28 against 42,48,52). The entry says each level's fill is "read off the platform per scheme, never derived from another level's" — that is a claim about provenance, and it is honoured, but the outcome is that two of the five levels are indistinguishable in one of the two schemes, which the entry does not admit is possible.

And **Level** states "no level is lighter or darker than another by rule", while **Chrome** in the same set states chrome is "a shade darker than the content in both". The renders back Chrome and falsify Level: chrome is darker than content in light (247 < 255) and darker in dark (28 < 30). Two entries make opposite claims and the pixels pick a side.

The table stripe sharpens it further. In light a zebra row (244) is a *bigger* step from the page than a card is (247). **Card** says the platform's box step "is what singles it out"; a stripe that singles nothing out steps further. In dark the stripe (41) and the card (42,48,52) are the same step, and only the card's blue tint separates them — a tint the Card entry does not name.

---

## Entry by entry

### Accordion

The entry names a title row, a chevron turned by open state, and a body. The render draws **solid triangles**, not chevrons — ▼ open, ► closed. A chevron is a stroked V; these are filled deltas. Small, but the entry names a glyph the render does not draw.

The render also draws hairlines (230 / 52) the entry never mentions, and places them badly. Measured at x=400: rules at y=99, 243, 291. The open section's rule sits at y=99, *between* its header (75) and its body (109) — and its body has no rule after it, so from y=109 to the next header at y=219 there is a hundred pixels of empty page with no boundary at all. The rule therefore reads as "under the header", not "between sections", and the closed section headed *How a section is bounded* is, in this render, not bounded. The entry says nothing about the rule, so nothing in the words catches this.

The body also reserves roughly 100px it does not use. "A body shown while open" does not cover a body plus an empty reserve.

### Card

Fill measured exactly as written: 247 on 255, 42,48,52 on 30, with no hairline row and no shadow at either edge. The step is real and the entry describes it.

Two disagreements.

- The entry says "the developer's word about it is a badge **in its header**". The render puts *Popular* (142,142,147 / 152,152,157, Neutral) at the card's **foot**, below the body. The **Pricing** render puts the same badge in the header. Same badge, two positions, one of which the entry names.
- The dark step is not only lighter, it is **cooler**: 42,48,52 against a neutral 30,30,30 page. The entry says "a small step from the surface it is in, darker in light and lighter in dark" and gives the step no hue. In dark the tint is doing visible work — it is what separates a card (42,48,52) from a table stripe (41,41,41) — and it has no word.

"A card holds content, never another card" and "a field in it is a raised thing on the card" are not drawn anywhere in this set.

### Group

The most accurate entry here. Hairline 230 on 255 and 52 on 30 — exactly black and white at a tenth, exactly as **Seam** defines the separator colour. No fill inside: 255 inside and 255 outside; 30 and 30. "What it holds stands on the surface the group is in" is literally true in the pixels.

The entry adds rounded corners and internal padding by omission — both drawn, neither named — but nothing contradicts.

Its closing guidance ("a row of tiers — groups") is the correct reading of the Pricing render. See below.

### Hero

Eyebrow, display title, subtitle, CTA pair, no visual — the entry's optional visual is simply absent, which the word "optional" covers.

What the entry does not name: the pair is **Filled + Tonal** (0,122,255 and 236 / 51,58,63). The entry says "a call-to-action pair" and leaves which emphases open; the render commits to a specific pairing, and it is the only place in the set where two emphases appear side by side. That relationship — primary next to secondary — is the hero's whole visual argument and the entry does not claim it.

Also worth noting the dark Tonal fill (51,58,63) sits one rung above the dark card (42,48,52) in the same blue-tinted family. **Emphasis** and **Level** are written as independent axes; in dark they are drawn from the same ramp.

### Feature

"An icon-title-body grid, so many features read as one set."

The render draws **no icons**. It draws three plain filled discs, each a different hue: (2,136,255), (97,85,245), (0,195,208) in light. An icon per **Signal** is "a concept as a glyph" that "carr[ies] no status and no role of its own; each is coloured in the foreground of what it sits in — the developer does not choose a colour for it." Here there is no glyph and three developer-chosen colours. The render contradicts the Signal entry in both halves of its definition, and the Feature entry — which says "icon" — inherits it.

The hue variation also works against the entry's stated purpose. Three different hues are the one thing that stops many features reading as one set.

### Pricing

"Laying tiers side by side **as cards**, one optionally emphasised."

Measured, that is not what is drawn. The outer two tiers are **groups**: hairline 230 / 52, interior 255 / 30, no fill. Only the middle tier is a card: 247 / 42,48,52, no hairline. The harness banner agrees with the pixels and not with the entry — *three tier groups, the middle one the recommended card*. And **Group**'s own guidance agrees with the pixels too: "a row of tiers — groups. The one thing that must stand apart — a card."

So the Pricing entry is the odd one out against both the render and the Group entry. Rewriting it as "tiers side by side as groups, the recommended one a card" would make all three agree.

The word "emphasised" is the second problem. **Emphasis** is defined as a property of buttons, ranked Filled/Tonal/Ghost, and says explicitly that emphasis "lives where interaction lives". The middle tier's prominence is not any of those three; it is a level change (group to card). Two different ideas are sharing one word.

Incidentally all three tier buttons are Filled (0,122,255). Three equally-weighted primary actions in one row is exactly what the Emphasis entry exists to prevent, and nothing in the Pricing entry mentions the buttons.

### Testimonial

"One **centred** card or a row of them." The render draws one card at x=48 in a 900-wide frame, hard left, with 340px of empty page to its right. It is not centred in either scheme. The entry offers two shapes and the render is neither.

Unnamed by the entry and drawn: the opening quotation glyph, the avatar (again a plain blue disc, no image), and a second attribution line — *Fresh eyes* under *A reviewer*. "Named authors" covers the name and nothing else; the render has a name, a byline, and a portrait slot.

### Modal

The entry describes one shape: "a header carrying its title **and** close, a body, **and** a footer of actions." The render draws two, and **neither is that shape**:

- left: title, no close, body, footer (Cancel / Discard)
- right: title **and** close, body, **no** footer

The harness banner names both correctly — *a decision answered from its footer, and a panel closed from the mark at its corner*. The entry names a third shape that appears nowhere, and does not name the distinction the render is built around: a modal that demands an answer has no close; a modal that only reports has no footer. That is the pattern's actual rule and it is missing from the words.

The scrim is drawn, and not as symmetrically as "everything beneath is dimmed" implies. Light: 205 under a 255 page — black at 0.196. Dark: 19 under 30 — black at 0.367. Nearly double the alpha in dark, with no note.

The shadow is where it really diverges. Below the dialog the deepest shadow value is **190 against a 205 scrim in light — 15 levels**, and **17 against 19 in dark — 2 levels**. **Level** says a floating thing is told "by its shadow". In dark the shadow is 2/255 and effectively absent; what tells the dialog is that its fill (30, the window background) is *lighter* than the scrim (19). The mechanism is the scrim, not the shadow, and the entry credits the shadow.

### Popover

- "Floating **beside** its anchor" — the render places it **below**. The popover's own body text even says "holds content below what opened it". Placement below is a legitimate outcome of the attachment rules, but "beside" is not what is drawn.
- "It may hold anything: controls, a menu, a detail" and "use it when the user must operate what it shows" — the render holds two lines of prose and nothing operable. The entry's whole reason-for-being over a tooltip is the one thing not shown.
- The tail is drawn in both, small and pointing at the anchor. Fine.
- **The two schemes tell it apart by different means, and the entry names only one.** Light: fill 255 on a 255 page, no hairline anywhere, told purely by a shadow whose deepest value is 234 — a 1.19:1 step. Dark: a hairline at 42–52 (white at a tenth, the separator colour) around the whole body and tail, with a shadow of 27 against 30. So in light it is a shadow with no outline; in dark it is an outline with almost no shadow. **Level** promises "a floating thing by its shadow" and **Card** establishes that a hairline means something else entirely. The dark popover wears one and no entry accounts for it.

### Navbar

Brand leading and links centred, as written. The active link *Gallery* is marked.

- "**Actions** trailing" — what is drawn trailing is a **v1 badge** (142,142,147), a signal, not a control. Per **Signal**, a badge "is read, never operated". The entry promises actions and the render shows a read-only label.
- "The active link is marked" does not say how, and the render marks it with a **blue underline that is pixel-identical to the Tabs active mark**. Nothing in either entry says the navbar borrows the tab's mark, and nothing distinguishes an active navbar link from a selected tab on sight.

The chrome fill and seam are right and worth recording as agreement: navbar 247 / 28, a foot seam at y=79 measuring 223 (247 × 0.9) in light and 50 (28 + 0.1 × 227) in dark, and **no seam at the top**. That matches **Seam** exactly — "the navbar's foot", "laid over whatever is beneath", "drawn once, by the region above".

But the dark step undercuts **Chrome**'s "a shade darker than the content in both". Light is 8 levels (247 vs 255); dark is **2** (28 vs 30). In dark the shade is not a shade; the seam is carrying the whole distinction. "In both" flattens a 4× asymmetry.

### Tabs

Strip, active tab underlined, panel below — all drawn, as written.

What the entry does not say is that the strip **is filled, with chrome's material**: 247 / 28 with a foot seam at 223 / 50, identical to the navbar, and it stops at x=483 — the width of the section's content, not the window. **Chrome** says in as many words that "Chrome is window-scale only: the trim inside a component or pattern — a card's header, a dialog's footer, a table's header row — is that thing's structure, never chrome." A tab strip is exactly that kind of trim, and it is wearing the chrome material at component scale. Either the Chrome entry's list needs the tab strip added to its exceptions, or the strip should not be painted 247.

### Sidebar

Expanded column beside a collapsed rail, both drawn. Chrome fill 247 / 28 with a trailing seam at 223 / 50 drawn by the sidebar — correct per **Seam**'s "drawn once, by the region above or leading".

The active pill is drawn as promised: (23,139,251) / (25,148,252), rounded, spanning x 33–205 inside a sidebar of 23–214, so roughly 10px inset at each edge, never edge to edge. The label is white.

Three things the entry does not cover.

- **The selected row's icon disappears.** The pill is (23,139,251) and the icon disc inside it is (0,136,255) — the same blue. Contrast against its own pill is essentially 1:1. The entry specifies "a white label" and says nothing about the icon, so the render is free to paint an accent-blue glyph on an accent-blue pill, and does.
- Same defect as **Feature**: the rows' icons are plain discs in four chosen hues (blue, 97,85,245, 0,195,208, 52,199,89), which **Signal** forbids for icons.
- The pill is the full row height (32px, matching the 32px row pitch), so it is inset horizontally and flush vertically. "Inset from the sidebar's edges" reads as all four; two adjacent selected rows would touch.

The entry also claims the pill is "never the list's selection colour". The list render in this set shows no selection, so that distinction cannot be checked against anything here.

The collapsed rail and the expanded column both carry a toggle glyph at the top that the entry never names.

### Pane

This entry disagrees with its render more sharply than any other, and the disagreement runs through **Backdrop**.

- The entry says the backdrop shows around the pane, and **Backdrop** says the backdrop is "the platform's window background". Everywhere else in this set the window background measures **255 light / 30 dark**. In the pane render the surround measures **161 light / 40 dark**. It is 94 levels too dark in light and 10 levels too light in dark — off in *opposite directions* per scheme. Whatever is painted around the pane, it is not the window background this system paints anywhere else.
- **Backdrop** says "Nothing is drawn at it and no foreground is ever measured against it: the backdrop is only ever what shows around." The render draws the entire document on it — three paragraphs of body text sitting directly on the 161 surround, at a measured 5.78:1 against text of 39. On the content fill (255) the same text would be about 13:1. The one thing the Backdrop entry forbids is the thing the Pane render does, and it costs more than half the contrast.
- **Seam** says "An inset object needs no seam: the backdrop showing around it does that work." The pane is drawn with one anyway: 145 on the 161 surround in light (161 × 0.9), 61 on 40 in dark (40 + 0.1 × 215). Full separator colour, all the way round. The entry explicitly rules it out and the render draws it.
- The pane's own body text says "a pane is read through its edges and not through its lightness". Measured, the pane is **86 levels lighter** than its surround in light (247 vs 161) and **12 levels darker** in dark (28 vs 40). It is read overwhelmingly through its lightness in light, weakly in dark, and the polarity flips between schemes.

"Rounded on all corners, the backdrop showing around it on every side" is true of the geometry. Everything the entry says about colour is contradicted.

### Shell

"Sidebar, navbar and main content." The render has **five** regions: navbar, sidebar, main content, a trailing **aside** (*Inspector, outline or details*), and a **footer** status bar under all of it. The banner says *the three-column frame: sidebar, content, aside*. The entry names three of five; the aside and the footer have no mention, and the footer is exactly the "status bar" that **Chrome** lists as a chrome region.

"In the arrangements its variants name" collides with **Variant**, which defines a variant as "the same affordance in a different setting — **where the control lives**" and gives only form/chrome for the picker. A shell arrangement is not a control living somewhere; it is a composition. Either the Shell uses the word loosely or the Variant entry is narrower than the system needs.

And one clean measured defect. The shell's seams are all one pixel — sidebar/content at x=215 (223 / 50), navbar foot at y=79, footer top at y=304 — except the content/aside boundary, which measures **exactly six pixels at full separator strength**, x=558–563 at 230,230,230 in light and 52,52,52 in dark. Not antialiasing; six solid pixels in both schemes. **Seam** says "the hairline where two flush regions meet" and **Splitter** says it draws "at the seam's width". This is six times the width every other seam in the same image uses.

### Splitter

The three goldens are two flat synthetic blocks — (34,85,136) against (136,85,34) — divided by a line at the 50/50, 30/70 and vertical 30/70 positions. The line is 1px in all three, so "at the seam's width" holds here (and contradicts the shell's 6px band above).

The line itself falsifies the entry's other claim. **Seam** says the separator is "black or white at a tenth, **laid over whatever is beneath, so it reads on any fill**". Over (34,85,136), black at a tenth would be (31,77,122). The measured line is **(230,230,230)** — flat opaque grey, identical to what the separator resolves to over a white page. The splitter is painting the light-scheme *result* of the rule instead of applying the rule. These goldens use saturated fills precisely to expose that, and they expose it.

Everything else the entry distinguishes is invisible here by construction: no hover, so no thickening and no firming; no cursor in a still, so no resize pointer; no hit area, which is not painted at all; no drag, so no bounds. And there is **no dark golden for the splitter**, so the white-at-a-tenth half of the rule is untested. Of the entry's six distinctions the renders can carry one and a half.

### Table

The entry describes "a list whose rows have columns, sortable and filterable". Its four renders are **two different tables** that share almost nothing.

The section render: no cell rules at all, a plain header row, a sort triangle on the first column, and **zebra striping** — 244 on 255, 41 on 30, an 11-level alternation in both schemes. Four rows.

The markdown goldens: **every cell ruled** at 230, a filled header band at 244, **per-column alignment** (Package left, Role centred, Stars right), inline code and bold inside cells, no stripes, no sort affordance.

The entry accounts for the first and not the second, and does not name the distinction between them. Neither render shows filtering, and neither shows "however many rows there are" — four and three rows respectively prove nothing about virtualisation. Zebra striping, the sort indicator, cell rules, the header band and column alignment are all drawn and none is named; the header row is at least acknowledged elsewhere, by **Chrome**, as the table's structure.

### Notifications

The column, the stacking and the position anchor are all drawn. The toast fill is the window background (255 / 30) with a light shadow, matching **Level**'s floating row.

The one place the whole set rewards the Language: **Warning measures hue 28°, plainly orange**, exactly as **Highlight** claims when it says "Warning is orange so that [yellow] can be [the highlight's alone]". Error 359°, Success 135°.

But **Info measures 206–208° — (2,136,255) light, (0,145,255) dark — and that is the app's accent.** The Filled button is (0,122,255), the sidebar selection pill (23,139,251), the first feature disc (2,136,255). At a glance they are one blue. **Status** says "Each status has a colour role of its own in the theme, the status four, so that a signal's hue indicates which status it carries." For three of the four it does. For Info the hue also means "this is the primary action" and "this row is selected", so it indicates nothing.

The status is also carried by a **single 8px leading bar** and nothing else — no icon, no tinted fill, no tinted text. The text repeats the word *Error*, *Warning* and so on, which is the only reason the render is readable at all. Neither the Notifications entry nor **Status** describes how a toast wears its status role, and the render's answer is: thinly.

No dismiss control is drawn on any of the four, though **Status** ("None of the three changes behaviour when dismissed") and **Signal** ("the dismissible badge's close") both assume dismissal exists.

### Markdown document

"Paragraphs, headings, lists, code snippets, images. The links inside it are carried controls; **everything else is read**."

The last clause is the problem. The render draws, besides those:

- **Task checkboxes** — three of them, two checked in accent blue, one empty. Whatever their behaviour, they wear a control's whole appearance. They are not "read".
- **A horizontal scrollbar** on the code fence, drawn at 104 / 164. A scrollbar is operated.
- A **blockquote** with a leading bar (189 / 86 — not the separator colour, not any named fill), a **horizontal rule** (230 / 52, which *is* the separator colour), a **table**, **bold / italic / strikethrough**, **inline code chips** (244,245,245 / 41), and **four heading levels** whose top two are nearly the same size.
- **No images**, which the entry names.

So the entry names one thing not drawn and leaves eight things drawn unnamed, two of which are controls its closing clause says do not exist.

The inline chip is worth flagging by name: the harness calls it a "code chip", the Language has no entry for it, and "chip" is already a component with its own purposes. A code-only noun standing in for a concept with no entry.

### Code

The packet is right that there is no entry, and the render makes the case for one. What is drawn:

- A rounded fence with fill **(239,241,245) light / (30,30,46) dark**. In light that is a 16-level darkening of the page. In dark it has **the same lightness as the page** — 30,30,46 against 30,30,30 — and is told apart *only* by 16 levels of blue. No entry in the set names a fill distinguished by hue alone, and **Level** has no room for one.
- A syntax palette of at least six roles — keyword, type, constant, function, string, comment — each a chosen colour. **Signal** says of non-status signals that "the developer does not choose a colour for it". A syntax palette is the largest field of developer-chosen colour in the entire set and the Language says nothing about it.
- **The comments are the least legible text in the block.** Measured against the fence: **2.30:1 in light** (156,160,176) and **3.36:1 in dark** (108,112,134). They are also the longest prose in it.

### Highlight

The best-served entry in the set, and the one with the sharpest single defect.

What agrees. The find highlight is drawn as described, and **the current match really is stronger**: light (252,247,222) for the ordinary matches against **(250,239,189)** for the current; dark (70,70,54) against **(110,110,77)**. The text keeps its colour — (0,0,0) on the light highlight, (255,255,255) on the dark, matching the body text elsewhere. And yellow is the highlight's alone: nothing else in these renders is yellow, and Warning measures 28° orange as the entry promises.

What does not. The entry treats "in the content, and where each lies on the scrollbar" as one thing in one colour. On the scrollbar it does not work.

| | value | contrast vs page |
|---|---|---|
| light, ordinary mark | 253,249,229 | **1.06:1** |
| light, current mark | 252,244,209 | **1.11:1** |
| dark, ordinary mark | 62,62,49 | 1.54:1 |
| dark, current mark | 86,86,63 | 2.22:1 |

At 1.06:1 a 3px tick on a bare white track is not visible. The same yellow works behind text because it has an edge, a word-shaped extent and black glyphs on it; alone on the track it has none of those. In light, the "current one stronger" distinction is 1.06 against 1.11 — a difference of five hundredths, unreadable. In dark both are visible and the current one is genuinely stronger.

Worse, legibility depends on scroll position. Where a mark falls on the thumb it is drawn over 109 (light) and reads at 4.9:1; where it falls on the bare track it reads at 1.06:1. The same mark is either obvious or invisible depending on where the reader happens to be — which is why the vaultview golden, where all three matches are in view and all three marks land inside the thumb, looks fine and the scrollbar section, where they are spread down the track, looks empty.

The entry's second row — the arrival flash from a followed link — has no render, and per the recorded caveat a still cannot show a fade. Half the table is unillustrable by construction.

### Link

Colour and underline are drawn: (0,104,218) light, (65,156,255) dark, underlined in both. "Showing its affordance in the text itself" holds.

The paragraph render shows **three states the entry never names** — its own caption says *idle, hovered, focused* — and measurement is unkind to two of them:

- **hovered** is (0,99,207) light against an idle (0,104,218). Five levels on one channel, eleven on another. In dark, (83,165,255) against (65,156,255). Both are below any threshold at which a reader would notice a state change. The entry attributes the hover feedback entirely to the pointing hand cursor, and the render evidently also tints the text — imperceptibly.
- **focused** draws a rounded ring at (128,179,250) light / (28,99,142) dark, 200 measured pixels of it. A clearly-drawn, deliberate affordance with no word anywhere in the Language.

The cursor itself is correctly absent from a still and is not a defect.

One small thing: "text that names its destination" — the render's second link reads *design system*, which names a topic, not a destination. The first, *link to gioui.org*, does.

### Heading word

The goldens cannot settle the rule, and that is itself the finding.

Only two runs in the prose are blue: **setup** (x 39–79) and **index** (x 279–318). Their colours are byte-identical to each other and to an ordinary link — (0,104,218) light, (65,156,255) dark, both underlined. The prose says of the second that it "is a link already", so the first is presumably the heading word. **A reader cannot tell them apart.** The entry's entire distinction — a word that is prose at rest and a link only under a held key — is drawn with exactly the same pixels as a real link, so the render shows nothing that requires the distinction.

Nor can the still adjudicate whether the rule is being obeyed. If the capture is at rest, then *setup* is drawn as a link at rest, contradicting "at rest it is prose". If the capture is with command held, the entry's own "with the pointer over it" means only one word should be marked — which is consistent with what is drawn — but a still shows no key and no pointer, so nothing confirms it.

What the golden does demonstrate, because the prose was clearly written to test it: the carve-outs hold. **Setups** (not a whole word) is not marked; `index` inside a code span is not marked; **SETUP** is not marked. That last one is the interesting case — "SETUP" equals the heading "Setup" case-insensitively and so *should* be a heading word by the entry's own words. Under the at-rest reading, that is a straight failure of the case-insensitive clause. Under the key-held reading, it is expected, because only the pointed-at word lights. The two readings cannot be told apart from a still, which means this rule needs a render that shows the modifier state, or it cannot be reviewed at all.

---

## Distinctions in this set that no render carries

Stated for completeness, not as defects — several are unillustrable by nature:

- **Level** — the numbering. The entry gives five *named* levels and no numbers, while **Modal** cites "level 2", **Popover** "level 3", and **Status** "floating at level 2". Nothing defines the numbering, and a render cannot show it.
- **Level / Card** — "a field inside a card is raised on the card the same way". No field on a card appears anywhere in the set.
- **Card / Group** — the nesting rules (a card never holds a card; a group never holds a group; a group may hold a card). Nothing nests in any render.
- **Emphasis** — **Ghost** is never drawn. Filled and Tonal both appear; the third rank does not.
- **Status** — **alert** never appears. Badge appears three times and never carries a status; toast appears four times and carries all four. The three-way division rests on two-thirds of its evidence.
- **Variant** — neither picker variant appears. The only thing called a variant in a render is the shell's arrangement, which the Variant entry's definition does not cover.
- **Splitter** — hover thickening, hit area, resize cursor, drag bounds, and the dark scheme entirely.
- **Highlight** — the arrival flash and its fade.
- **Popover** — opening, dismissal, and holding anything operable.
- **Table** — filtering, and any row count large enough to mean something.
- **Sidebar** — "never the list's selection colour"; the list render shows no selection.

## How it was asked

Eighty-five offscreen renders at 1 px per point: the gallery's sections in
both appearances, each drawn with its own heading above it on the
appearance's window plane, by the golden harness's own helpers from a
temporary dump deleted after — `components-button`,
`components-button-emphasis`, `components-button-pinned`, `components-chip`,
`components-textfield`, `components-searchfield`, `components-checkbox`,
`components-picker`, `components-list`, `components-scrollbar`,
`components-scrollbar-search`, `components-scrollarea`,
`components-pagination`, `components-breadcrumb`, `components-paragraph`,
`components-badge`, `components-alert`, `components-toast`,
`components-tooltip`, `components-icon`, `patterns-accordion`,
`patterns-card`, `patterns-group`, `patterns-hero`, `patterns-feature`,
`patterns-pricing`, `patterns-testimonial`, `patterns-modal`,
`patterns-popover`, `patterns-navbar`, `patterns-tabs`,
`patterns-sidebar`, `patterns-pane`, `patterns-shell`, `patterns-table`,
`patterns-notifications`, `markdown-reading` and `markdown-code`, light and
dark.

Four entries name something the gallery carries no specimen of, so the same
renderers' stored images stood in beside them, as CF1.1 did for the text
group: `patterns/shell/testdata/golden/light-split-pane-{50-50,30-70,
vertical-30-70}.png` for Splitter, `markdown/testdata/golden/table-{light,
dark}.png` beside the table section, `workbench/vaultview/testdata/golden/
note-find-{light,dark}.png` for Highlight, and `markdown/testdata/golden/
heading-word-{light,dark}.png` for the heading word. Switch was handed over
with nothing: the gallery draws no switch.

Each entry was handed over as its DOMAIN Language text verbatim, with the
paths of its images under it, and nothing else. The entries: Button, Chip,
Text field, Search field, Checkbox, Radio, Switch, Picker, List, Scrollbar,
Pagination, Breadcrumb, Paragraph, Badge, Alert, Toast, Tooltip, Icon,
Accordion, Card, Group, Hero, Feature, Pricing, Testimonial, Modal, Popover,
Navbar, Tabs, Sidebar, Pane, Shell, Splitter, Table, Notifications, Markdown
document, Highlight and Link — with Level, Chrome, Seam, Backdrop, Status,
Signal, Emphasis and Variant given to both reviewers for context, and a note
that Purpose, the code block and the heading word have no entry of their own,
the first living in a table inside Chip and the last in the closing sentence
of Link.

The set was too large for one reply, so it was split in two by CF1.1's
groups: the controls and the signals to one reviewer, the patterns and the
text to the other. Neither had seen the plan or the packet, neither was given
a checklist, both were handed the recorded misreads verbatim — a dark label
reads grey at 1x; the light sidebar material is the content's white told
apart by a seam and shows what is behind the window; a still capture shows no
fade or cursor; alpha composites in encoded sRGB and every value is measured
off a capture; the window controls in a render are stand-ins painted by the
harness — and both were asked the one question of this task and nothing else.
