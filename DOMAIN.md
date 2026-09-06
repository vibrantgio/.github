# Vibrant Gio — the design system's language

## Language

### Component

What the system ships as one named unit — button, chip, picker,
badge — defined by its purpose, structure and variants. When a
component's contract does not fit a consumer, the component is
extended; the affordance is never re-assembled app-side. "Widget" is
not a term of this language: it stays Gio's own word (layout.Widget,
anything that can be laid out). A component is defined by itself,
never assembled from other components: where it carries one — the
badge's close, the picker's menu — that is a fixed part of its
structure, not a slot. Every component is one of two kinds — a
control is a component, and a signal is a component:

| Kind | The user |
|---|---|
| **control** | operates it — to act or to choose |
| **signal** | reads it — its only purpose is to inform |

### Control

A component the user operates to act or to choose.

| Control | Offers |
|---|---|
| **button** | performing an action — always visible, always the same action |
| **chip** | acting on something in the content — filter by it, take it, remove it |
| **picker** | choosing one from many — the trigger shows the choice |
| **checkbox** | recording a yes or no |
| **radio** | recording which one, of a visible few that exclude each other |
| **switch** | turning something on or off, taking effect at once |
| **text field** | entering and editing text |
| **search field** | finding content — matches are highlighted as you type |
| **scrollbar** | moving the view through content larger than its surface |
| **list** | moving through a sequence of rows and choosing one |
| **scroll area** | seeing the rest of one piece of content that keeps its own size |
| **link** | following a reference — text that names its destination |
| **menu** | a floating list of items, each performing an action or recording a choice |
| **breadcrumb** | going back up the hierarchy — each step a link, the last where you are |
| **pagination** | moving between numbered pages of content |

### Signal

A component that is read, never operated: its only purpose is to
inform. A signal tells you something; it is never the matter itself
— that is content.

| Signal | Tells |
|---|---|
| **badge** | the system's word, count or glyph about content |
| **alert** | a situation, standing in the page flow until it resolves |
| **toast** | an event, floating briefly and leaving by itself |
| **icon** | a concept as a glyph — names an action or a thing at a glance |
| **tooltip** | the name of a control or the meaning of a signal, on demand |
| **text label** | a name or caption, set in a typography role |

A signal may carry a control without becoming one — the dismissible
badge's close. The affordance always belongs to the carried control,
never to the signal.

### Content

The matter the application exists to show: prose, pictures, data —
what the user came to read or edit. Content stands at level 0; its
originator is a person — the user, or the author who wrote it —
never the developer and never the system, which only speak about
it. Content is rendered by modules — the markdown
document, an image — not shipped as a component: components stand
beside content or act on it. The controls inside content — its
links — are carried the way a signal carries its close: the
affordance belongs to the link, the prose around it stays read-only.

### Originator

Who a component speaks for.

| Originator | Says | Example |
|---|---|---|
| **the user** | their own entries and tokens | the filter token they typed |
| **the developer** | words placed when the application was built | the "Popular" label, a control's caption, the eyebrow |
| **the system** | what the running application computes | the unread count, the key-check verdict, "filtered by X" |

A signal's originator is never the user: it speaks for the developer
or the system. Content originates with a person — the user, or the
author who wrote it — never with the developer's labels and never
with the system.

### Action

Something the application does because the user asked for it:
sending the message, keeping the colour, opening a menu. Performing
an action changes more than the control that offered it — a control
that only records a choice, like a checkbox taking a yes, has not
performed an action.

### Affordance

An action a control offers and shows it offers:
pressing a button, picking from a menu, dismissing a token. The
affordance is the action, not the component — the same affordance can
be built in more than one place or variant and remains one
affordance.

### Variant

The same affordance in a different setting — where the control
lives — never a different behaviour and never a different
prominence; that is emphasis. A colour role is not a variant
either: an alert in Warning is an alert speaking Warning.

| Variant | Of | Meaning |
|---|---|---|
| **form** | picker | a field among fields |
| **chrome** | picker | in a chrome region — a toolbar, a navbar |

### Emphasis

How important an action is on the surface it sits on, ranked most
pronounced to least. Emphasis lives where interaction lives:
signals have none.

| Emphasis | Of | Meaning |
|---|---|---|
| **Filled** | button | the one action a surface is about |
| **Tonal** | button | a secondary action |
| **Ghost** | button | an incidental action; claims no colour of its own |

### Structure

The ordered parts a component is drawn from, each
required or optional. Notation: brackets mark the optional parts, as
in [icon] text [x]. A component's or pattern's own trim — header,
footer, close, seam — is structure, not chrome.

### Mark

The small glyph a component draws to show a recorded state or to
offer a dismissal: the checkbox's check, the radio's dot, the close
cross on a badge or an Input chip. A mark is a part of a structure,
never a component; the role it is drawn in is the role's mark
colour. Only the user's own operation repaints a state mark — focus
rings the control and leaves the mark alone.

### Pattern

A composition: components and regions arranged into a
larger recurring shape, reusable across purposes. Patterns place
components; they do not redraw them. What makes it a pattern is
that its parts are slots the developer fills; a thing with no slot
is a component, however large.

| Pattern | Composes |
|---|---|
| **accordion** | a vertical stack of collapsible sections, a chevron per open state |
| **card** | a rounded surface raised one step on what it is in, with header, body and footer slots — singles something out |
| **feature** | an icon-title-body grid for a marketing "features" section |
| **group** | a hairline around related components at the surface's own level, optionally labelled — divides the page |
| **hero** | the marketing landing block: eyebrow, display title, subtitle, visual, a call-to-action pair |
| **inspector** | a chrome column beside the content showing the properties of what is selected in it |
| **modal** | a centred dialog floating over a full-window scrim — header, body, footer actions |
| **navbar** | the horizontal bar of brand, links and actions; the active link marked |
| **notifications** | the column that receives notifications and presents them — today as toasts — positioned, stacked and timed |
| **pane** | a chrome column set in from the window's edges rather than being one of them, the backdrop showing around it |
| **popover** | a small surface floating beside its anchor, a tail pointing at it |
| **pricing** | a row of tier groups, the recommended tier a card wearing a badge |
| **shell** | the top-level application layout: the composition of the chrome regions |
| **sidebar** | a collapsible vertical column — expanded with labels or collapsed to a rail of icons; the active entry marked |
| **status bar** | the chrome strip along the window's bottom, reporting on the document |
| **table** | data in rows and columns, sortable and filterable — a list whose rows have columns |
| **tabs** | a horizontal tab strip, the active tab underlined, its content panel below |
| **testimonial** | quote cards naming their author — social proof |
| **toolbar** | the chrome strip along the window's top holding the controls that act on the document |

### Axis

An independent dial every component reads rather than
restates.

| Axis | Governs |
|---|---|
| density | how tightly controls pack — the control height and inner padding |
| radius | corner stops |
| scheme | light and dark |
| typography roles | the type stack's named styles |

### Density

How tightly controls pack, set once for the whole window and never
per component. It governs the control height and the padding inside
a control. There is no per-component size: a component that must be
smaller than the control height states its offset from it, as the
chip does; one that ignores it, like the badge, says so and is sized
to its text.

| Setting | Meaning |
|---|---|
| **Comfortable** | the default: room around every control |
| **Compact** | more on screen: shorter controls, tighter padding |

### Radius

How rounded corners are, in named stops from square to fully
round. A component names the stop it uses and never states a
number.

| Stop | Meaning |
|---|---|
| **None** | square |
| **Sm** | barely softened |
| **Base** | the default corner |
| **Md**, **Lg**, **Xl**, **Xl2**, **Xl3** | rounder, in order |
| **Full** | a pill or a full circle |

### Scheme

Whether the theme is light or dark. Every colour is derived per
scheme from the same roles and levels; the backdrop is darkest and
each level is lighter in both.

| Scheme | Meaning |
|---|---|
| **Light** | dark foreground on light surfaces |
| **Dark** | light foreground on dark surfaces |

### Typography role

A named style of the type stack. A text label or a heading is set in
a typography role, never in a bare size. Always spoken with the
qualifier: a bare "role" is a colour role. Each family below comes
in Large, Medium and Small.

| Family | Sets |
|---|---|
| **Display** | the largest text — a hero title |
| **Headline** | section-opening text |
| **Title** | the name of a thing — a card, a dialog |
| **Label** | text on controls and captions |
| **Body** | reading text |
| **Code** | monospaced text, one size |
| **Document headings** | the six heading steps of a prose document, derived from Body rather than borrowed from Headline and Title |

### Surface

A plane that content and controls stand on. Every
surface stands at a level; the window's own — the backdrop — is the
lowest. A floating surface stands at a higher level than the
surface it floats from — that difference in level is what floating
is. In an attachment, Surface names the floating one.

### Elevation

The dimension of how high a surface stands. It is
spoken in levels, never in its own units.

### Level

A position on the elevation, numbered from the backdrop
up. A surface's colours are derived against the level it stands at,
and in both schemes a surface nearer the viewer is lighter — the
backdrop is darkest, whatever the scheme. Standing higher comes in
two kinds:

| Kind | Meaning |
|---|---|
| **raised** | one step above the surface it stands on, attached to it — a card on the content, a field on that card |
| **floating** | detached: placed by an attachment or over a scrim, above everything raised beneath it |

Raised is relative — a field inside a card is raised on the card —
so the numbers below name the usual stack, not a ceiling. A raise
is walked one step from the surface beneath, never read off a table
of levels: whatever a thing stands on, raised means one step
lighter than that. Where the scheme has no lighter step left — the
light scheme under white, the top of the dark band — the raise is
still told, by a seam at its edge instead of by its fill; a raise
never vanishes. The content plane keeps headroom above it for that
reason: in the light scheme it stands one step below white, and
white is the first raise on it, so a card on the content is told by
its fill in both schemes and the seam is kept for the raise above
that — a field on a card. Cards do not nest: grouping within a card
is its structure.

| Level | Holds |
|---|---|
| **backdrop** | nothing: the bare window plane, showing wherever nothing stands |
| **chrome** | the chrome regions — navbars, toolbars, sidebars, inspectors, status bars, panes |
| **0** | the content itself: the document being read |
| **1** | raised on the content — cards, filled insets, fields |
| **2** | floating — dialogs and toasts |
| **3** | floating, top of the elevation — menus, popovers and tooltips |

### Backdrop

The lowest level: the window's own plane, what an empty window
shows, the darkest region in both schemes. Nothing is drawn at it;
everything else stands on it, and it shows wherever nothing stands
— around an inset pane. It is what the backdrop module paints first
in every application, a tint darker than the chrome placed on it.
Nothing has the backdrop behind it, so no foreground — no text, no
ring, no mark — is ever derived against it: the backdrop is only
ever what shows around.

### Seam

The hairline where two flush regions meet — the sidebar against the
content, the navbar's foot, the status bar's top. Regions that share
one fill depend on it to say where one ends and the next begins, so
it is derived to be findable against both in either scheme, and
drawn once, by the region above or leading. An inset object needs
no seam: the backdrop showing around it does that work.

### Scrim

The translucent veil a modal draws over everything beneath it: it
dims what it covers and blocks input to it, isolating the dialog
above. A scrim is not a surface — nothing stands on it.

### Chrome

The window's furniture: every region placed directly on the
backdrop that frames the document rather than being it — navbar,
toolbar, sidebar, inspector, status bar, pane. Chrome is a level of its
own, the first above the backdrop and a tint lighter than it in
both schemes; the shell pattern is the composition of chrome
regions; a variant is "chrome" when the control lives in a chrome
region. Chrome is window-scale only: the trim inside a component
or pattern — a card's header, a dialog's footer, a table's header
row — is that thing's structure, never chrome.

### Attachment

The relationship between a floating surface and
what it floats from. Its parts, which any component can play:

| Part | Meaning |
|---|---|
| **Anchor** | the element the floating surface is positioned against |
| **Trigger** | the interaction that opens or closes it |
| **Surface** | the floating thing itself |
| **Placement** | which side it opens on — the developer's preference, arbitrated by the attachment against fit |

Placement is preference plus fit: the developer states the preferred
side, and the attachment arbitrates against reality — the surface
must land fully visible inside the window. No room on the preferred
side flips it to the side that has room; a surface taller than the
room it wins scrolls inside itself. Content is never cut off.

Anchor and trigger usually coincide; they are still two parts, and
none is a component. "Anchor" is reserved for the attachment part
alone: no component may carry it as a name — the picker's
chrome-variant trigger is Toolbar.

### State

What is happening to a control right now.

| Kind | States | Meaning |
|---|---|---|
| transient | hover, press | accompany an interaction in progress and pass with it |
| persistent | selected, checked, active, focused | outlive the pointer and mark meaning |

**Rest** is the absence of every state. **Disabled** is not a state
the user causes: the system has withdrawn the control; it is drawn
faded and no state applies until it returns.

### Role

A colour identity of the theme. Each role owns a ramp — its hue run
from light to dark, walked in numbered steps — and answers derived
from it: its tinted container, its foreground, the colour of its
marks.

| Roles | Family |
|---|---|
| **Neutral** | no hue of its own; the greys |
| **Primary, Secondary, Tertiary** | the accent trio |
| **Error, Success, Warning, Info** | the status four — Warning is orange, never yellow; yellow is the highlighter's |

Wherever a ruling says "role-tinted" or "the role's own hue", this
is the role it means. Typography roles are a different thing
entirely — the type stack's named styles, under Axis, always spoken
with the qualifier.

### Fill

The field a component paints behind its content, always
derived against the surface it stands on, never a stored swatch —
never absolute.

| Fill | Who wears it |
|---|---|
| the role's hue diluted toward the surface beneath — a pale tinted field | badges, persistent states and the Tonal button, all in one shared tint; behaviour tells them apart |
| the role's hue at full saturation | Filled emphasis only — reserved for where interaction lives; a badge's fill is never saturated |
| none | the ghost button at rest, the glyph badge |

Transient states walk the fill — hover and press step it away
from the surface beneath.

### Foreground

What draws the content on the fill: text, glyph,
stroke. On a tinted or absent fill the foreground is the same hue at
reading strength — never an independent "on colour" token; only on
Filled emphasis' saturated fill does the foreground leave the hue,
knocked out to a neutral for contrast. Fill and foreground are two
renditions of one identity, not a stored pair, and they are the spec
vocabulary.

### Accent

How a persistent state speaks: a role-tinted fill with
the role colour, darkened, as foreground — the same in a menu, a
sidebar or a list. On a focused control the accent is the ring
around it.

### Selection

The persistent state marking the thing you chose:
the picked menu row, the marked Filter chip. Walking the neutral
ramp for a persistent state is the transient grammar applied to the
wrong kind of state.

### Checked

The persistent state of a binary control: the user's
recorded yes on a checkbox, switch or radio. It survives hover and
focus.

### Active

The persistent state marking where the user is: the
current tab, the current sidebar entry, the open document. Positional
and one-of-many. Distinct from selection: selected is the thing you
chose, active is the place you are; both are persistent and speak
through the accent.

### Focused

The persistent state marking where keyboard input goes: the control
that receives the typing and reacts to Enter or Space. It stays
until focus moves elsewhere — Tab, or a click. Its accent is the
ring around the control, and the ring is all it may draw: focus may
ring a checked control, never repaint its mark — redrawing a checked
box as unchecked is one state's grammar overwriting another's.

### Chip

A small, subtle control that stands beside the content and comes
and goes with it, defined by its purpose — one of four — never by looks
or platform provenance:

| Purpose | Meaning |
|---|---|
| **Assist** | a contextual smart action |
| **Filter** | refine content from a set; toggles, marked when selected |
| **Input** | a token the user entered; dismissible |
| **Suggestion** | a generated prompt the user may take |

Not a button at low prominence: a button is a fixture. Structure:
[icon] text [x]. The line against the badge is read/use: if you read
it, it is a badge; if you use it, it is a chip.

### Button

The control that performs an action when pressed. It
is a fixture: placed by the developer, always visible, always offering
the same action — it does not appear from content the way a chip
does, and it does not record a state. Marking a choice is never a
button's job, whatever its emphasis; that is the Filter
chip's purpose.

### Breadcrumb

The control going back up the hierarchy: a row of labels separated
by chevrons, each a link to its place. The last is where you are —
plain text, not a link. It is generated from the path; nothing is
filled into it.

### Pagination

The control moving between numbered pages of content: page buttons
flanked by previous and next, generated from the page count. The
current page is active.

### Menu

The floating list component: items stacked on a surface at level 3,
opened by a trigger and placed by the attachment rules. Each item
either performs an action — a context menu's Copy — or records a
choice — the picker's option. One menu, many openers: the picker's
triggers, a secondary click on content, a menu bar.

### Picker

The pick-one-from-many control: one menu as its surface, behind two
triggers:

| Trigger | Variant |
|---|---|
| **Field** | form |
| **Toolbar** | chrome |

Single-choice by contract — the trigger shows
the value. Multiselect of a few visible options is the Filter chip's;
a summarizing multi-picker does not exist until a consumer outgrows
that.

### Badge

The small status signal: the system's word or sign
about content — read, not used. One purpose, three utterances:

| Utterance | Example | Fill |
|---|---|---|
| a word | "Popular" | tinted container — words are arbitrary content, so hue alone cannot carry the role |
| a count | the unread 9 | tinted container, for the same reason |
| a glyph | the key-check verdict | may stand bare — the glyph's shape carries the meaning; the green check and the red cross differ by form before they differ by hue |

It covers what M3 and iOS call a badge too. Not a control: sized to
its content like an inline annotation, not sized to the control
height, visibly lighter than any control. It speaks only in the
status roles' own hues plus Neutral for plain category labels, and
hue is never its only channel (hue alone collapses for
colour-blind readers). Filled/Tonal emphasis does not exist on a badge;
emphasis lives where interaction lives. A badge may be dismissible
(the close mark keeps an invisible control-sized hit area); what
separates a dismissible badge from an Input chip is the
originator, not the close — a badge is applied by the developer or
the system *about* the thing, an Input chip is a token the user
entered themselves. Dismissing a badge removes only the label, never
behaviour — so a system-originated summary of view state, "filtered
by X", is plain text or a close-less badge, removed where that state
is set. A developer-originated badge is a fixture: nothing the user
did made it appear, so it is never dismissible.

### Alert

The status signal for a situation: a tinted rounded banner — an
icon, a title, a body — speaking one status role, standing in the
page flow until the situation resolves. It holds words about the
situation, never a control: an action on the situation stands beside
the alert, or the situation is a modal's job.

### Notification

What the system tells the user about an event that happened: the
message saved, the export finished, the connection lost. A
notification is the message; how it is shown is a presentation —
today the toast — and the notifications pattern is what receives
and presents it. A notification is raised by message, never drawn
in place.

### Toast

The status signal presenting a notification: a small floating
surface at level 2 that appears when the notification is raised and
leaves by itself after a set time. The presentation and its timing
are what make it a toast; the notification is the message it
carries. Its close is a fixed part; it holds no other control — a
toast with an Undo would be a small dialog on a timer, and is not
of this Language. The column it appears in is the notifications
pattern.

### Status

What the system reports in the status roles' hues. Three signals
share the job, divided by what each speaks about and how long it
stays:

| Component | Speaks about | Where | Until |
|---|---|---|---|
| **badge** | a thing | inline with it | it stops being true |
| **alert** | a situation | in the page flow | the situation resolves |
| **toast** | an event | floating at level 2 | it leaves by itself |

The tooltip is not of the family: it names a control on demand and
reports no status. None of the three changes behaviour when
dismissed.

### Highlight

The marking of the content the user was brought to — the system's
answer to "here is what you sought". A highlight is applied to
content, it is not a component, and it is not of the status family:
it reports no status. It lives exactly as long as its cause:

| Cause | Marks | Until |
|---|---|---|
| a search | every match, the current one stronger | the query is dismissed |
| a followed link | the arrived-at content | it fades by itself, moments later |

The arrival highlight is a highlight flash: the showing and the
subsequent fading together — it appears at once when the content
comes into view and fades over a moment, never cut off.

Its colour is its own, reserved outside the roles — a highlight must
never read as a status, so no status hue may serve as the
highlighter. That colour is yellow, the marker's own; Warning is
orange so that it can be.

### Eyebrow

The hero's kicker: a short overline in the type stack
that introduces the headline. Pure typography — a typographic role,
not a badge: it carries no role, no container,
says nothing about content; it is the developer speaking, not the
system. Wears type styling (size, tracking, a hue if the theme says
so), never the badge's tinted container.

### Checkbox

The binary control recording a yes or no. Its recorded yes is the
checked state; only the user's own operation repaints the mark.

### Radio

The one-of-a-few control: a visible group of options that exclude
each other, each shown, one chosen. Choosing one clears the others.
When the options are too many to stay visible, the picker takes
over.

### Switch

The binary control that takes effect at once: flipping it turns
something on or off immediately — nothing waits to be submitted.
The checkbox records; the switch acts.

### Text field

The control for entering and editing text: a bounded field the user
types into. What it holds originates with the user.

### Search field

The control for finding content: a text field that looks as you
type and marks what it finds with the search highlight. Structure:
looking glass, text, [x]. The looking glass names the control at a
glance; the clear mark empties it and dismisses the highlight with
it. What it holds originates with the user.

### Scrollbar

The control moving the view through content larger than its
surface: a thumb on a track whose size mirrors how much of the
content is visible. Operating it moves the view, never the content.

### List

The control for a sequence of rows: the user moves through them
and may choose one, by pointer or keyboard. A chosen row is in the
selection state. A menu is a list that floats; a table is a list
whose rows have columns.

### Scroll area

The control for one piece of content that keeps its own size — a
code block, a preformatted table, a wide diagram: it shows the part
that fits and lets the user move the view to the rest, sideways or
down. Nothing in it is chosen; the content is never reflowed or cut.

### Link

The control following a reference: text that names its destination,
showing its affordance in the text itself. Following it is its only
action. Arriving may set off a highlight flash on the content the
link pointed at, so the reader sees where they were brought.

### Icon

The signal drawing a concept as a glyph: it names an action or a
thing at a glance. Inside a control's structure an icon is a part,
not a signal of its own.

### Tooltip

The signal naming a control or explaining another signal on demand:
a small annotation floating at level 3 beside its trigger, appearing
by itself after a short delay on hover or focus and leaving when they
do. It holds text only, never a control; anything the user must
operate is the job for a popover. Level 3 is where it is placed, not
what it is filled with: nothing stands on a tooltip, so it takes no
surface's fill and is filled inverse — the other scheme's surface
and foreground — so it reads as speech about the thing, not as a
panel. It is the one adoption of the inverse pair.

### Text label

The signal naming or captioning something: a run of text set in a
typography role. It says what a thing is.

### Image

Content as a picture: it is read, never operated.

### Paragraph

Content as a run of styled text wrapped into lines. The links in
it are carried controls; the rest is read.

### Markdown document

Content rendered as a readable document: paragraphs, headings,
lists, code snippets, images. The links inside it are carried
controls; everything else is read.

### Accordion

The pattern stacking collapsible sections: each section a title row
with a chevron turned by its open state, and a body shown while
open.

### Card

The pattern singling something out: one rounded surface raised one
step above the surface it is in, no hairline, the raise doing the
work, with header, body and footer slots. It holds content that must
stand apart from the page around it — a summary, a preview, the
recommended tier. What a card holds stands on the card: its content
as foreground, anything raised in it, a field say, one step above
the card. A card holds content, never another card. A card is never
outlined, and it never wears a role: the developer's word about it
is a badge in its header, and singling out is the raise's work
alone.

### Group

The pattern dividing the page: a hairline drawn around related
components so the eye chunks them, at the level of the surface it is
in and taking that surface's own fill, optionally labelled. It
raises nothing and singles nothing out; nothing is derived against
it, because it has no fill of its own — what it holds stands on the
surface the group is in. A group may hold a card; it never holds
another group. It wears no role: a group is not operated, so it has
no emphasis to speak with, and a role-coloured hairline would borrow
the accent's grammar for something the user never chose.

Which of the two a developer reaches for answers one question: am I
dividing the page, or singling something out? A form in sections, a
list of articles, a row of tiers — groups. The one thing that must
stand apart — a card.
### Feature

The marketing pattern presenting capabilities as an icon-title-body
grid, so many features read as one set.

### Hero

The marketing pattern opening a page: an eyebrow, a display title,
a subtitle, an optional visual and a call-to-action pair,
introducing what the page is about.

### Inspector

The chrome pattern of a column beside the content, showing the
properties of whatever is selected in it and offering the controls
that change them. It follows the selection; empty selection, empty
inspector.

### Modal

The pattern that interrupts for a decision: a dialog floating at
level 2 over a scrim, with a header carrying its title and close, a
body, and a footer of actions. The scrim isolates it — everything
beneath is dimmed and deaf until the modal closes.

### Navbar

The chrome pattern spanning the window's top: a brand leading,
links centred, actions trailing. The active link is marked.

### Notifications

The pattern receiving the application's notifications and
presenting them: a position-anchored column where each arrives,
stacks against the others and leaves on its own timing. Today every
notification is presented as a toast; the pattern owns the queue,
the placement and the timing, not the presentation.

### Pane

The chrome pattern setting a column in from the window's edges
rather than making it one of them: rounded on all corners, the
backdrop showing around it on every side. Unlike flush chrome it is
an object — a control can send it away, and what stood beside it
reflows to the window's edge.

### Popover

The attachment pattern for a small surface floating at level 3
beside its anchor, a tail pointing at what it belongs to. It is
opened by an action on its trigger and stays until dismissed — a
click outside, Escape, its close — and it may hold anything: controls,
a menu, a detail of the thing under the anchor. Placement follows
the attachment rules. Use it when the user must operate what it
shows, or read more than a name; merely naming the anchor is the
job for a tooltip.

### Pricing

The marketing pattern laying tiers side by side as cards, one
optionally emphasised.

### Shell

The pattern composing the chrome regions into the application's
top-level layout — sidebar, navbar and main content, in the
arrangements its variants name.

### Sidebar

The chrome pattern of a collapsible vertical column: expanded with
icons and labels, or collapsed to icons alone — collapsed, it is a
rail. The active entry is marked.

### Status bar

The chrome pattern of a strip along the window's bottom: signals
reporting on the document and the application's state — where you
are in it, what is happening to it. It reports; it holds controls
only incidentally.

### Table

The pattern for data in rows and columns: a list whose rows have
columns, sortable and filterable, however many rows there are.

### Tabs

The pattern dividing content into one-of-many panels: a horizontal
strip of titles, the active tab underlined, its panel below.

### Testimonial

The marketing pattern quoting named authors — one centred card or a
row of them — as social proof.

### Toolbar

The chrome pattern of a strip along the window's top, below the
title, holding the controls that act on the document. Its controls
are in the chrome variant; it holds controls, never content. The
picker's chrome trigger is named after it.

## Decisions

### 0001 — intent-over-provenance

2026-08-30 · strategic. Components are defined by intent, register
and role — never by which platform control was measured. The chip
that derived its fill and silhouette from macOS toolbar capsules is
condemned and will be re-anatomized; measured platform values may
inform a derivation but may not *be* the definition. Downstream: the
chip re-anatomy, the tag restyle, the repeal of selection-on-button-
emphasis. Sources: [[TRANSCRIPTS#^0001-ontology-demand]],
[[TRANSCRIPTS#^0001-chip-condemned]]

### 0002 — extend-the-component

2026-08-30 · strategic. When a component's contract does not fit a
consumer, the component is extended; the consumer never re-assembles
the affordance app-side. A component gap is the task, not a reason to
hand-roll. Applied first to the picker's drop direction. Sources:
[[TRANSCRIPTS#^0001-extend-component]]

### 0003 — language-first

2026-08-30 · strategic. The ontology is written down and governs: a
concept enters the system only with a Language entry; weakly outlined
concepts bleeding into each other is the failure this exists to
prevent. DOMAIN.md is the canon; llms.txt carries the consumer-facing
distillation. Sources: [[TRANSCRIPTS#^0001-language-first]],
[[TRANSCRIPTS#^0001-domain-home]]

### 0004 — mark-and-badge

Superseded by 0005.

2026-08-30 · strategic. The statement label renames tag → badge, and
the icon-like signal becomes its own component, mark. The boundary
is text: a mark is icon-like (a glyph or a count), a badge is
textual, a chip is [icon] text [x] with the brackets optional.
Naming the platform's count-dot sense "mark" claims the word
deliberately — arrivals from M3/iOS find their badge under mark,
freeing badge for the statement. Both are components, not patterns.
Downstream: the tag pattern becomes the badge component; hand-rolled
verdict glyphs (mindchat's key check) hoist into mark; the chip's
old badge face leaves the chip family the way the anchor face left
for picker, its uses sorted by the text boundary — counts and glyphs
to mark, worded statuses to badge. Sources:
[[TRANSCRIPTS#^0002-badge-word]],
[[TRANSCRIPTS#^0002-mindchat-marker]],
[[TRANSCRIPTS#^0002-mark-and-badge]],
[[TRANSCRIPTS#^0002-mark-badge-chip]]

### 0005 — one-badge

2026-08-30 · strategic. Supersedes 0004. The rename tag → badge
stands; the mark/badge split does not. Splitting by looks (glyph vs
word) violated the system's own axis — the two had one intent, the
system's signal about content — and Bootstrap's badge shows the fold
holds in practice: the "Profile 9" count and the role-hued word live
in one component on one palette. Badge absorbs mark; "mark" leaves
the language. Downstream: one components/badge; mindchat's key-check
verdict is a glyph badge; the chip's old badge face was badges all
along; every 0004 badge ruling (sized to content, role-hued plus
Neutral, dismissible, label-never-behaviour) covers the glyph and
count utterances too. Sources:
[[TRANSCRIPTS#^0002-badge-mark-doubt]],
[[TRANSCRIPTS#^0002-fold-mark-into-badge]]

### 0006 — abrupt-badge-migration

2026-08-30 · strategic. The tag pattern migrates to a component
named badge in one abrupt transformation: no compatibility
affordances, no deprecated aliases, no little steps — consumers
convert cold turkey to the new status quo once the library is ready.
Rationale: stepwise migration churns every version on the way to a
destination that may itself be re-ruled; the transformation must
arrive quickly. Sequencing: the golden-snapshots phase moves to
after this transformation, so snapshots are cut once against the
settled anatomy. Sources: [[TRANSCRIPTS#^0002-cold-turkey]]

### 0007 — shared-recipes

2026-09-01 · strategic. Colour recipes do not proliferate: when two
things would differ by almost no practical visual difference, they
share one recipe, and behaviour — not colour — tells them apart.
Applied first to the Tonal button and the badge: the same tint.
Rationale: parallel near-identical recipes make the system
unreadable — a colour that fails to change reads as a defect until
it turns out to obey some other recipe, and the owners end up
talking past each other. Sources:
[[TRANSCRIPTS#^0002-tonal-same-tint]]

### 0008 — warning-orange-highlight-yellow

2026-09-03 · strategic. Warning's hue is orange, and yellow is
reserved for the highlight. Prior position: Warning sat in the
yellow, so the highlighter — forbidden every status hue — was
derived to the far side of the hue circle and came out lilac. New
position: the highlighter is yellow, the colour a marker is, and
Warning moves to orange to make room; the rule that no status hue
may serve as the highlighter is unchanged and now satisfied by a
yellow marker. What changed: the lilac fill looked bad and did not
read as a marker; a yellow highlight is what every reader expects
from find-in-page. Downstream: the Warning anchor repins in the
seed derivation; the highlighter's hue is re-derived in the yellow
and its measured distances from every status colour re-pinned;
goldens, the CSS export and the design mirror regenerate; every
consumer sees a new Warning. Sources:
[[TRANSCRIPTS#^0005-highlight-yellow]],
[[TRANSCRIPTS#^0005-warning-orange]]

## Example dialogue

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in components?

Orchestrator: they are the same affordance built twice — the form
variant's trigger owns its menu, the chrome variant's trigger is
placed by a popover — so it becomes one picker: one Menu, two
variant triggers, and the anchor face leaves the chip family it was
never ontologically part of.

Sources: [[TRANSCRIPTS#^0001-anchor-not-chip]]

Rene: tell me how the badge and chip differ in visual language and
why the badge doesn't have a dilineation around it.

Orchestrator: delineation is the grammar of interaction. A chip is
an offer, so it draws a boundary — the outline marks the hit area,
promises a press, and its fill walks the transient states. A badge
is speech: the role hue *is* the message, nothing responds to the
pointer, so there is no edge to promise — an outlined badge would
dress as a control and invite a click it cannot honour. The costume
sorts the family: quiet outline, you may act; tinted fill or a bare
glyph, you are being told. (The "bare hued text" this reply
originally allowed was closed by the later container ruling.)

Sources: [[TRANSCRIPTS#^0002-badge-chip-visual]]
