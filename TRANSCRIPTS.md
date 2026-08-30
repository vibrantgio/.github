# Transcripts

Verbatim stakeholder talk, append-only. Conversation 0001 is the
2026-08-30 working session (Rene with the orchestrator) in which the
design ontology was first demanded and its first terms were ruled.

## 0001 — the ontology session (2026-08-30)

Rene: we are lacking a shared design ontology our chips look like ass
because we derived their appearance from toolbar buttons on macOS.
Investigate m3.material.io/components/chips/overview and propose how
we can adopt this as our chips. ^0001-ontology-demand

Rene (written into the chip exploration as a ruling): the current
chip is condemned outright — grossly oversized, to be moved away from
entirely; nothing of its appearance is preserved or defended. Chips
must be subtle. A rounded rect is acceptable; the pill is not a
requirement. ^0001-chip-condemned

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in compontents? ^0001-anchor-not-chip

Rene: I agree chip needs a way to select too. But do you have enough
info to transform this and create component.select? ^0001-chip-selects

Rene: Why not change the picker to allow this usage? This decision to
then fucking handroll it again is just nuts. ^0001-extend-component

Rene: Perhaps this is something for llms.txt also? I mean we need to
start writing down the ontology somewhere because I think the
ontology will conceive the concepts we can talk about. If we don't
agree on the ontology we are bound to talk past each other. Another
problem that lack of ontology has caused is weakly outlined concepts
bleeding into each other. ^0001-language-first

Rene: A new package is additive, minimize version churn is your
priority. ^0001-churn

Rene: according to /crunchgate:method this is DOMAIN.md ^0001-domain-home

Rene (crunch selection): tag keeps dismissible — chip Input and
dismissible tag coexist; the boundary gets written instead of a
migration. ^0001-tag-keeps-dismissible

Rene: what do you use the concept Chrome for in your ontology?
^0001-chrome-question

Rene (running the app, 2026-08-30): Oh my god, we want backward
again... The picker in the main window points both up and down, the
list appears down like a drop down. The picker in the settings window
points down but only shows items above. All selections in the popup
are BLACK. There is now scrollbar so the list in the settings is cut
off. This is really a very big step back in functionality.
^0001-picker-regressions

Rene: Well selection behavior is pretty standard across a platform,
so why have a sudden BLACK/WHITE selection going on. That doesn't
even make sense in our color design language ^0001-selection-not-state

Rene: What you mean to say is that selection is not a TRANSIENT
state ^0001-selection-not-transient

Rene: Also add checked and active as persistent states to the
glossary ^0001-checked-active-glossary

Rene: ontology work has been moved to session ontology
^0001-handover-to-ontology

## 0002 — the ontology session (2026-08-30)

Rene: I will be using the chips session investigate the differences
between tags and chips and when to use either one or the other.
^0002-tag-chip-boundary

Rene: I was also trying to get it to tell me when the other places
the tags are used say as eyebrow in hero pattern was actually a tag
or another thing borrowing tag clothes. Perhaps that is something for
the ontology the way tags are inrtoduced and then used everywhere in
the patterns module ^0002-tag-clothes

Rene: I think the word I keep coming back to when talking about what
is currently known as a tag is the word "badge". ^0002-badge-word

Rene: So let's sequence this properly. In mindchat there is something
iOS/M3 would call a badge, the marker that says that the API key was
correct. ^0002-mindchat-marker

Rene: So I think we should create components, mark and badge because
they are actually more component like than pattern like. Concur?
^0002-mark-and-badge

Rene: Mark -> icon only (or a count) idea is it is meant to be
iconlike not textlike.
Badge -> textual badge
Chip -> [icon] text [x] where [] means optional ^0002-mark-badge-chip

Rene: Are icon buttons something that is available as a component,
perhaps as part of the normal button behavior? These are normally
round and exhibit different behavior to other button controls.
^0002-icon-button-question

Rene: I think we may be making a mistake by swithing the meaning of
badge and mark ^0002-badge-mark-doubt

## 0003 — the chips session (2026-08-30)

Relayed verbatim by the chips session at the ontology session's
request, chronological.

Rene: The current chips are extremely ugly and grosly oversized. A
chip needs to be subtle and does not HAVE to look like a pill, a
rounded rect would be ok also. We need to move AWAY from what is
currently is because I am disgusted by it. So you keep falling back
to some design decision you picked up somewhere and that has driven
this ugly piece of crap into existence. ^0003-chip-condemned-verbatim

Rene: Go with the relation, ChipHeight = ControlHeight − 4
^0003-chip-height

Rene: Let's talk avout chip vs tag ^0003-tag-chip-thread

Rene: So this is way to technical, what the hell man. Rail it in a
little. What concept does a tag represent and what concept does a
chip represent. ^0003-rail-it-in

Rene: a speaker is a chip, is a speaker something you can do?
^0003-speaker-probe

Rene: The component/pattern modules have other tag like entities,
like:
1. the v1 badge show in the Shell pattern
2. the popular badge in the pricing pattern
3. the eyebrow in teh hero pattern
4. trigger in the Tooltip pattern
5. anchor in the Popover pattern
6. the v1 badge in the navbar pattern
7. footer in the card pattern
8. as the actual tag in the tag pattern.
Explain what I am seeing here in all these roles and how that
relates to the chip. ^0003-tag-look-inventory

Rene: What pattern was the tooltip and popover was that a tag that
functioned as trigger/anchor? ^0003-gallery-tag-anchor

Rene: So was the use of a tag as an achor and trigger not in stark
contrast to what they are supposed to be used for?
^0003-tag-as-anchor-contrast

Rene: What do you suggest would be the most appropriate to show here
something that will be there 90% of the time ^0003-gallery-specimen

Rene: check if button can render icon-only ^0003-icon-only-button

Rene (crunch selection, via the chips session's choice prompt; exact
option texts in the chip exploration's owner-rulings block): the
badge is sized to its text — off the control ladder entirely, an
inline annotation visibly lighter than any control; only the close
mark keeps an invisible extended hit area. ^0003-badge-sized-to-text

Rene (crunch selection, same prompt): badge variants are role-hued
only — Success, Warning, Error, Info — plus Neutral for plain
category labels; Filled/Tonal emphasis retires from the badge,
emphasis lives where interaction lives. ^0003-badge-role-hued

Rene (crunch selection, same prompt): voice wins on the
applied-filter display — user-entered tokens are Input chips; a
system-generated summary of view state is plain text or a close-less
badge, removed where it was set. Statements never change behaviour
when dismissed. ^0003-voice-wins
