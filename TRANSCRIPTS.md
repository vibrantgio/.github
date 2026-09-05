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

Rene: So I'm wondering if we now should fold mark into badge and
retain the badge as name. Bootstrap does have the Profile 9 count in
a badge and it does have succes/danger/warning/info primary and
secondary. That is also part of the mark right success/danger etc...
^0002-fold-mark-into-badge

Rene: So this means that tag will be migrated to a component named
badge. I want this to be quite abrupt, no affordances for other
programs. Diarizer needs to go cold turkey and convert to the new
status quo, once we are ready. If we do it with little steps
everything churns like hell and I want it to arrive quickly, not be
working on it for 3 days and then concluding it is not what I want
again. We are going to be transforming the library once again,
perhaps we need to schedule the golden snapshots phase after we do
our work to prevent a lot of duplicated work. ^0002-cold-turkey

Rene: I want you to review the ontology work we have done until now
to find things that have been under defined. Also
https://getbootstrap.com/docs/4.0/components is perhaps something to
consider to see if we are lacking obvious components in our stable.
^0002-underdefined-review

Rene: I will circle back to this, but first tell me how the badge
and chip differ in visual language and why the badge doesn't have a
dilineation around it. ^0002-badge-chip-visual

Rene: I would expect the badge to have a background hue, I just
could not imagine that not being the case. Did the reviewer noticed
this too? ^0002-badge-background-hue

Rene: Think about an eyebrow and what it should look like in a hero
and when you decide it is pure typography then don't burden the
badge with it. ^0002-eyebrow-typography

Rene: I'm worried that the badge with text is not going to be to my
liking. Are we still able to do the mindchat badge for "connection
was authenticated" the green checkmark icon?
^0002-green-check-stays

Rene: so what does "it wears its hue as a tinted container" actually
mean. Can you describe that succint and clearly.
^0002-tinted-container-meaning

Rene: hue-as-wash / hue-as-ink / hue-as-shout is somthing that needs
to be in DOMAIN.md and explained succintly ^0002-hue-voices

Rene: So the hue always refers to the fill color of color of the
component not the On Color ? ^0002-hue-vs-oncolor

Rene: OK component fill and foreground are concepts that need to be
in DOMAIN.md ^0002-fill-foreground

Rene (2026-08-31): The issue is that you invent
language without consulting me. This gets out of hand quickly
because I don't gave a clue what you are talking about. Another
issue I have is that the DOMAIN.md has grown some warts already as
your analysis uncovered. What are we going to be doing about that?
^0002-no-invented-language

Rene (on "pressed dark"): You made up words again, a human would say
darkened or made darker. The same hue is implied if I darken
something the hue stays the same that is implicit.
^0002-say-darkened

Rene (2026-09-01): So there is an axis that allows the Rest color to
be determined based on emphasis derived from theme seed and a single
pinned (explicit override). Showing the Filled button again before
the Pinned confused me. So I assume a Pinned color will also have
all the darkening (is that called tinting?) applied to it.
^0002-pinned-darkening

Rene (crunch selection, 2026-09-01, via the warts prompt): the
selected row's text is the role colour, darkened — "floored ink"
rewords to fill/foreground terms. ^0002-accent-ink-darkened

Rene (crunch selection, same prompt): focus is a persistent state —
grouped with selected/checked/active, speaking through the accent.
^0002-focus-persistent

Rene (crunch selection, same prompt): the Fill entry says "badges",
not the undefined "statements". ^0002-say-badges

Rene (2026-09-01): Tonal and badge use the same tint, behaviour
tells them apart. Also we need to stop proliferating schemes when
there is almost no practical visual difference. That only leads to
us talking past eachother because I don't understand why some color
is not also changing. Turns out it would be some other color scheme
it adheres to. ^0002-tonal-same-tint

Rene: First tell me the meaning of selected, checekd etc as you know
it now. For both transient and persistent states. Now review the
ontology work again for under defined things.
^0002-second-review

Rene: Let's talk about role, as I noticed there is now a container
role and omncontainer role, explore everything role
^0002-explore-role

Rene: Role is too generic. And you then load it up with all it's
several meanings. Let's find a name for attachment roles. So I think
attachment is a concept that can be used as a hanger to introduce a
number of related concepts like anchor trigger, etc. So you are not
talking about role related but attachment related concepts.
^0002-attachment-not-role

Rene: So we are defining things in DOMAIN.md and what I see is
precious information space being dedicated to outdated information.
"formerly filed under the too generic 'role'"
^0002-no-history-in-language

Rene: Surface and Component are used in Attachment but not defined
beforehand. Also elevation ladder and level need introduction.
Because to float one needs to differentiate between levels.
^0002-define-before-use

Rene: what are registers named in the definition of component
^0002-registers-in-component

Rene: If there is a list in a definition use a table
^0002-lists-become-tables

Rene: affordance is not defined before its use
^0002-define-affordance

Rene: define control before affordance ^0002-define-control

Rene: inside control make a table with button,chip,picker,checkbox
and define what they offer. ^0002-control-table

Rene: So control references widget and therefore we need widget
defined before hand plus it hints at something other than control.
Both widget and the other thing need to be defined
^0002-define-widget-signal

Rene: move fill and foreground up next to ground, and in general go
through and using the pattern we established just now find out where
more definitional holes are and let's address them
^0002-holes-sweep

Rene: I would rephrase -> it informs and offers nothing -> its only
purpose is to inform ^0002-signal-rephrase

Rene: I can't rule on the "confirm the text floor line for the chip
label" just yet. I do want switch added to the control table an
while you are at it add other obvious missing controls to the table,
I don't expect you to invent new ones but to just enumerate what we
know to be controls ^0002-enumerate-controls

Rene: I agree with the wording for the diff in switch vs checkbox
^0002-switch-checkbox-diff

Rene (2026-09-01): The wording of Button is insufficiently clear, it
is now the last entry in the language section and defined as
"persisten verb" (wtf?). Secondly, is it wise to introduce a heading
per language entry, we now have one big section with not structure
^0002-button-wording-headings

Rene: "emphasis register" concept sounds alien to me, we need to
define it or rename it. What is the meaning of the word register in
this context? ^0002-register-alien

Rene: Variant is better, because register in computation a register
is one of a small fixed number of locations where you can store data
to be used in CPU ops ^0002-variant-not-register

Rene (on the heading-per-entry proposal, four groups): SGTM
^0002-headings-sgtm

Rene: Voice could use a table ^0002-voice-table

Rene: Floor needs it own definition and any specific elevations
perhaps too. Just noticed the use of elevation and levels. Floor
sounds more like a level than an elevation. WDYT
^0002-floor-level-elevation

Rene: I don't like floor as the word for the windows own lowest
level. I lean towards backdrop ^0002-backdrop-not-floor

Rene: Let's rule the placement arbiter next ^0002-rule-placement

Rene (crunch selection, via the placement prompt): preference plus
fit — the author states a preferred side; the attachment arbitrates
against reality; the surface lands fully visible, flips when the
preferred side lacks room, scrolls inside itself when too tall;
content is never cut off. ^0002-placement-preference-fit

Rene: You can also add the standard patterns to the DOMAIN.md with
definitions, right? ^0002-pattern-table

Rene: Sorry but a newcomer will not know what the hell you are
talking about. Ground is not a neutral word. You must understand
that for humans, we use a single language with concepts that make
general sense indendent of context. And yes we do use skeuomorphism
words that mimic real world concepts, but we keep that limited
because every skeuomorphism has to be learned.
^0002-ground-not-neutral

Rene: The intent definition reads weird. Intent in my opinion is
what someone is trying to accomplish with their actions. Intent as
used here more feels like the prupose of the Chip, because this is
solely related to chips right? ^0002-purpose-not-intent

Rene: Should you even still mention intent even when talking about
Purpose. This refers to a previous no longer present situation that
a fresh reader of the spec will not be able to connect to anything
^0002-no-intent-mention

Rene: Define action ^0002-define-action

Rene: Note that widget now says a control and a signal is a widget.
Also widgets don't divide into two that points to a whole part
relationship. We are talking about a abstract/concrete the 'is a'
relation ship. That leaves component the odd one out.
^0002-widget-is-a

Rene: So I don't know how far the widget concept has escaped already
into the code. So gioui.org defines widgets in a certain way. We now
are rededining widget again while we have choosen to use component
and even named a module after it. So I think a Signal is a Component
and a Control is a Component. We reserve widget for the gioui.org
concept of a widget. And allow for not having an abstract term that
we can hang components and patterns under. ^0002-widget-is-gios

Rene: I'm building an audio specifc app with it named diarizer, so I
am a bit of two minds if we should keep it ["volume" in Variant].
Yes, prominence works for me ^0002-prominence-not-volume

Rene: The additonal level Components, States and colors, The
components doesn't work for me. It's confusing me. I'd like the
definitions before the place where they are used preferably. But I
do like the table of Pattern and Control. I see that Signal is
underdefined? We only have badge there? What about markdown code
snippets, text labels, icons, images ^0002-flatten-and-signals

Rene: The rich text is a concundrum because it may actually show
affordance for interaction. ^0002-richtext-conundrum

Rene: Voice is another problematic concept that collides with the
Voice Audio app I'm developing. Originator is also worth
considering? Yes, originator it is ^0002-originator-not-voice

Rene: So are we also complete in the kinds of surfaces we have
available? ^0002-surface-kinds

Rene: I concur with LevelBackdrop. Leave
InverseSurface/OnInverseSurface for now, we may need it when we
expand the set of components and patterns. ^0002-levelbackdrop

Rene: Focused isn't defined by itself only as part of state?
^0002-define-focused

Rene: Is there a better way to say "A small, subtle control that
content sprouts". If you say "appears with" that sounds like
something that is not part of but accompanies content. Yes, take 1
[belongs to the content and comes and goes with it].
^0002-chip-belongs-to-content

Rene: Is there a special reason we need to have Anatomy as a
definition, are we using it regularly so that it deserves its own
word. Is internal layout something we can work with? Structure it is
^0002-structure-not-anatomy

Rene: Purpose is something that has its own definition, but if I
look closely at it, it should be inside the chip section. Every
component has a "purpose" that is not unique to Chip. So we either
need to describe the purpose of every component, or more naturally
admit this is something that is part of anything we describe and
describe the purpose if not obvious for every thing we are
describing. ^0002-purpose-folds-into-chip

Rene: Let's rule the standalone menu next ^0002-rule-menu

Rene (crunch selection, via the menu prompt): the menu is a
component in its own right — a floating surface listing items at
level 3, placed by the attachment rules; an item either performs an
action or records a choice; the picker keeps its contract and opens
this menu, a context menu or menu bar opens the same menu from other
triggers. One menu, many openers. ^0002-menu-own-component

Rene: Let's first do two open: the status-family boundaries
(alert/toast/badge) and "rung". ^0002-rule-status-and-rung

Rene (crunch selection, via the status prompt): the family divides
by subject and lifetime — the badge speaks about a thing, inline,
as long as it is true; the alert about a situation, in the page
flow, until it resolves; the toast about an event, floating, leaving
by itself. The tooltip is not of the family. None changes behaviour
when dismissed. ^0002-status-family

Rene (crunch selection, same prompt): the ramp is walked in STEPS —
the Ramp.Step API's own word; "rung" retires, comments migrate as
rounds touch them. ^0002-step-not-rung

Rene: I have another potential entry for the badge/alert/toast
category. Whenever a link is clicked or a search is executed we
arrive at a position in the content. We should be able to highlight
the content we just arrived at, sort of with a special highligher
color (e.g. yellow) that color should stay there only as long as
either the search is active or when a link is clicked it may even
disappear after a few seconds automatically. What kind of UX are you
aware of that is being used in the industry to cater to this
functionality. ^0002-arrival-highlight

Rene: I concur with your recommendation, crunch highlight into
DOMAIN.md [lifetime follows cause; fade on arrival; query-scoped for
search; colour reserved, never a status hue].
^0002-highlight-ruled

Rene: Add the highlight token and vaultview adoption to the plan
queue ^0002-highlight-planned

Rene: Now for every Control, Signal, Pattern add a definition to the
DOMAIN.md without actually removing them from the tables where they
are listed. ^0002-define-every-row

Rene: I'm having second thoughts about the Signal concept name. Is
Markdown a Signal? Are we not talking about Content? Yes, crunch it
[content as its own concept; signal narrows to annotations; image
and markdown document re-parent to content]. ^0002-content-not-signal


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

## 0004 — the pipeline session (2026-08-31)

Rene (reacting to the hue-voices vocabulary, relayed verbatim by the
pipeline session): This is just completely and utterly insane. Who
comes up with this shit. Then use fill and foreground in the specs,
not wash and ink. ^0004-fill-foreground-not-wash-ink

## 0005 — the ontology review session (2026-09-02)

Rene: We are working to make DOMAIN.md authorative for all
development work going on in session vibrantgio. Now review
DOMAIN.md and tell me if we need to define something that is
missing, if we need to define somethings better and whethere there
are definitions in conflict with eachother. ^0005-review-demand

Rene: So interview me about this because this is a lot!

Rene (crunch selection, via the alert/toast prompt): Signals; both
alert and toast are currently part of the patterns module though
and need to be moved to the components module! ^0005-alert-toast-signals

Rene (crunch selection, via the variant prompt): Variant = setting,
Emphasis = prominence. Variant means where a control lives (form,
chrome); emphasis means how important its action is (Filled, Tonal,
Ghost) and leaves the Variant table; where the text means a colour
role, say role. ^0005-variant-setting-emphasis-prominence

Rene (on the pane question): Chrome and backdrop are closely related
here.

Rene: Well the chrome actually is the area inside the window where
everything gets put. It is painted in the backdrop color, so how is
it then not just the backdrop? What differentiates chrome from
backdrop in this case. To me chrome usually means everything painted
by the actual OS, but look up the definion of how chrome was
normally used before google muddled the water with their browser
^0005-chrome-vs-backdrop

Rene: So the question is then when something is chrome according to
the orginal meaning we should paint it at the same backdrop level? I
think you can come up with examples of chrome in our code DOMAIN
here where that does not hold and chrome has a different color. Is
a card chrome? ^0005-is-a-card-chrome

Rene (to "chrome is window furniture only"): Chrome is only for
components/patterns directly placed on the window surface painted
in backdrop color?

Rene: So the problem I have is that you are trying to lump a lot of
things under a common name. So the whole window when completely
vacated from any components inside it is painted at the backdrop
level. What you are seeing is for all intent and purposes the
backdrop. On this you can place several patterns/components that
you could call Chrome and these are also painted at the backdrop
level. I find that conflicting with my sense of logic. I think they
should be separate levels, but you can CHOOSE to keep the colors for
those the same right. What is against doing it this way. Also if
you just talk about things that can be placed on the window surface
i.e. the backdrop, then this has some real logic to it.
^0005-chrome-own-level

Rene: No that is not what I said. I said that we could CHOOSE to do
that, but actually I'd like the backdrop to be a tint darker
^0005-backdrop-tint-darker

Rene (on raised/elevated/floating): If we do 1 then cards in cards
is not possible, right? The question is if you'd want that anyway.
^0005-cards-in-cards

Rene (crunch selection, via the levels prompt): Raised is relative,
floating is above all raised. A raised surface stands one step
above the surface it stands on; floating surfaces are detached and
stand above everything raised beneath them; cards do not nest;
"elevated" leaves the prose; the card's two looks are outlined and
filled, both raised. ^0005-raised-relative

Rene (crunch selection, via the mark prompt): Mark is the glyph a
control draws; add an entry. Mark = the small glyph a component
draws to show a recorded state or offer a dismissal: the checkbox's
check, the radio's dot, the close cross. 0005 retired mark as a
component name only; the Role entry's "its mark" is the colour a
mark is drawn in. ^0005-mark-is-the-glyph

Rene (on "control ladder"): What did control ladder actually mean
previously?

Rene: Density for me in no way say anything about control height.
How is that word even related to that. ^0005-density-word-doubt

Rene: The word isn't even defined in the DOMAIN.md
^0005-axes-undefined

Rene: Write them all into the DOMAIN.md but we will discuss density
further

Rene: No tables in the definitions to show the different values
these can take? ^0005-axis-value-tables

Rene: toolbar is not defined ^0005-toolbar-undefined

Rene: Why would I care if a pattern ships for a term defined in
DOMAIN.md? Doesn't it make it less of something worth defining?
^0005-language-regardless-of-shipping

Rene: in originator there may be 3 levels: system/developer/user
^0005-three-originators

Rene: Let's talk about density. To me it sounds that density is
something that you configure for a whole window. It is not
something you set per component as then size would be more
appropriate, what do you think ^0005-density-window-wide

Rene (to the density sharpening and the originator draft, including
developer-originated badges never being dismissible): yes to both
^0005-yes-density-and-originator

Rene: Should Alert and Toast migrate to the components module?

Rene: A toast is a certain visual presentation with a specific
timing associated with it of a notification. So notifications is
fine, as perhaps in the future we want to have notifications NOT in
the form of toast ^0005-notifications-pattern

Rene: If toast is moved to the components module perhaps it is no
longer required to say explicitly that it is a component and not a
pattern. The only reason you say that is because it was a pattern
previously. For users of the library that is confusing information
to receive ^0005-no-not-a-pattern

Rene: The content flash that occurs after the link is clicked is not
in anyway represented in the DOMAIN.md? ^0005-arrival-flash

Rene: Yes add it and add it to the link definition also because
following a link may activate it. Search is defined already? It is
an edit currently and does not have any distinctive rendering
although you might expect it to at least show a looking glass icon.
^0005-search-undefined

Rene: say highlight flash instead of just flash. Flash means the
showing and subsequent fading. Yes to both your questions related to
search ^0005-highlight-flash-and-search-field

Rene: when should we use a popover and when should we use a tooltip?
^0005-popover-vs-tooltip

Rene (to adding tooltip's scope, the boundary in both entries, and
tooltip at level 3): word

Rene: "and that one which only names its anchor is a tooltip." Why
is this sentence in reverese ^0005-boundary-not-reversed

Rene: reach means interact with ? ^0005-operate-not-reach

Rene: Now let's talk about list, scroll area and rich text

Rene: So to mee scroll area and list look identical. How do they
differ? ^0005-list-vs-scroll-area

Rene: Paragraph sound good, tell me a succint list of other things
that you propose because your text was not clear.

Rene: why is the module not named paragraph? ^0005-richtext-is-paragraph

Rene: write all 8, add the rename to the batch
^0005-list-scroll-area-paragraph

Rene: How is the color of the highlight flash established

Rene: The highlight should ideally be more in the yellow direction.
^0005-highlight-yellow

Rene: That is all nice and dandy but it looks bad and is not
yellowish ^0005-lilac-looks-bad

Rene: warning should have been orange anyway ^0005-warning-orange

Rene (on the peer session's BR1.1 findings): where does this canvas
concept come from suddenly. ^0005-no-canvas

Rene: So the issue is that we have a backdrop level and we have
chrome level backdrop is painted a certain way, but that means that
the pane should paint its own area in the chrome color. Because look
at the levels in DOMAIN.md ^0005-pane-paints-its-own-chrome

Rene: Will this be much slower?

Rene (to the Backdrop derivation sentence, the Seam entry and the
BR1.3 amendment): ok write both and send the peer the amendment
^0005-seam-and-backdrop-derivation

Rene (relayed by the vibrantgio session, pool item 260): the
elevation scale is closed — raised is one step above the surface a
thing stands on, but the theme reads a fixed table ending at level
3, so a card on a modal takes the top tint and a field in that card
has no tint at all; in light every raise above the pin is a whisper
regardless. Rene called it a bug and asked the ontology session to
rule. ^0005-elevation-scale-closed

Rene: Of everything currently mentioned in DOMAIN.md, what "is a"
surface ^0005-what-is-a-surface

Rene: Say a text field is contained by a card, is it raised against
the card?

Rene: I think there are two things here there is a card and there is
a group and we have mixed them toghether. The group creates an
outline to group the controls it contains where a card has a fill
that separates it from the surface it sits on. Ideas?
^0005-group-and-card

Rene: I feel that the component vs pattern distinction runs along
other lines. A pattern is a combination of components that is useful
and multi-purpose so made available to be reused. A component is a
specific piece of functionality that not made up of other parts but
defined by itself. DOn't you think this makes more sense?
^0005-component-closed-pattern-open

Rene: What about alert and toast?

Rene: Pricing becomes a collection of groups? ^0005-pricing-groups

Rene: So wait that would mean a group with an outline, and then
inside the group that you want to stand out a card (without outline)

Rene: So that would mean the pricing has groups for the non
highlighted choice and no outline for the standaout one? Currently
that is handled by a different color outline
^0005-no-accent-outline-on-tiers

Rene: ok write it all and send the peer the ruling
