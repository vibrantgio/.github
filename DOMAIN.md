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
| **splitter** | resizing two regions against each other by dragging the seam between them |
| **link** | following a reference — text that names its destination |
| **menu** | a floating list of items, each performing an action or recording a choice |
| **breadcrumb** | going back up the hierarchy — each step a link, the last where you are |
| **pagination** | moving between numbered pages of content |

### Signal

A component that is read, never operated: its only purpose is to
inform. A signal tells you something; it is never the matter itself
— that is content. There are two kinds. A status signal indicates
one of the four statuses and is coloured in that status's role; a
badge may also carry no status, and is then coloured Neutral:

| Status signal | Tells |
|---|---|
| **badge** | the system's word, count or glyph about content |
| **alert** | a situation, standing in the page flow until it resolves |
| **toast** | an event, floating briefly and leaving by itself |

The other signals carry no status and no role of their own; each is
coloured in the foreground of what it sits in — the developer does
not choose a colour for it:

| Signal | Tells |
|---|---|
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
either: an alert in Warning is an alert indicating Warning.

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

The small glyph a component draws. A mark shows a recorded state —
the checkbox's check, the radio's dot — or offers a dismissal — the
close cross on a badge or an Input chip. A mark is a part of a
structure, never a component. It is drawn in its role's mark colour.
Only the user's own operation repaints a mark that shows a state; a
focused control gets a ring around it and its mark is left alone.

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

### Theme

Everything a window draws with, derived from one seed: the colours
of every role and level in both schemes, and the axes — density,
radius, typography roles — read by every component. A window has one
theme at a time. It follows the platform — its scheme from the
system's appearance, its colours the platform's own, its theme
colour the system's accent colour unless the user has kept one in
the themer — and every application on the machine draws with the
same one.

### Platform

The operating system the application runs on: macOS. The application
looks like a macOS application. Wherever the platform and Material
differ, the platform's value is read off the platform and Material's
is dropped: the platform's system colours for the four statuses, its
control heights for density, its accent colour for the accent, its
controls' shapes for the controls. Where the platform's published
guideline and what the platform actually draws differ, what it draws
wins: measured beats published. Where the platform paints a colour
at an alpha — a label, a separator, a hover — it composites in
encoded sRGB, not in linear light, and so do we; a value read off a
capture matches to the byte only that way. What the platform does
not define the Language defines.

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
| **Comfortable** | the default: the platform's regular control height as measured, room around every control |
| **Compact** | more on screen: the platform's small control height, tighter padding |

A text field has a height of its own, the platform's, taller than
the regular control; a checkbox its own, smaller; a list's rows the
platform's row height; a sidebar's rows their own, taller than a
list's. All are measured into the reference, not derived from the
control height.

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
a typography role, never in a bare size. Each family below comes in
Large, Medium and Small.

| Family | Sets |
|---|---|
| **Display** | the largest text — a hero title |
| **Headline** | section-opening text |
| **Title** | the name of a thing — a card, a dialog |
| **Label** | text on controls and captions |
| **Body** | reading text |
| **Code** | monospaced text, one size |
| **Document headings** | the six heading steps of a prose document, derived from Body rather than borrowed from Headline and Title |

### Measure

The width a run of text is allowed to reach, from typography: long
lines tire the reader, so a paragraph stops at its measure however
wide the region is. Content narrower than its region is centred
within the region; nothing widens to fill. Wide content that keeps
its own size — a code block, a table — sits in a scroll area no
wider than the measure.

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

A position in the window's depth: backdrop, chrome, content, raised,
floating. Each level's fill is the platform's, read off the platform
per scheme, never derived from another level's; no level is lighter
or darker than another by rule.

| Level | Holds | Platform fill |
|---|---|---|
| **backdrop** | nothing: the window's own plane, showing wherever nothing stands | the window background |
| **chrome** | the chrome regions — sidebars, toolbars, navbars, inspectors, status bars, panes | the sidebar material with wallpaper tinting off, measured into the reference |
| **content** | the document being read, lists, tables | the text background |
| **raised** | on the content and attached to it — cards, fields, filled insets | the platform's grouped box: a small step from the surface beneath, darker in light and lighter in dark, measured into the reference; a field the platform's field |
| **floating** | detached, placed by an attachment or over a scrim — dialogs, toasts, menus, popovers, tooltips | the window background, under the platform's shadow |

Standing higher is told the way the platform tells it: a raised
thing by the box's small step of fill, no hairline and no shadow; a
floating thing by its shadow. A field inside a card is raised on the card the
same way. Cards do not nest: grouping within a card is its
structure.

### Backdrop

The window's own plane, filled with the platform's window
background. It shows wherever nothing stands — around an inset pane.
Nothing is drawn at it and no foreground is ever measured against
it: the backdrop is only ever what shows around.

### Seam

The hairline where two flush regions meet — the sidebar against the
content, the navbar's foot, the status bar's top. It is the
platform's separator colour: black or white
at a tenth, laid over whatever is beneath, so it reads on any fill
without being derived; drawn once, by the region above or leading.
An inset object needs no seam: the backdrop showing around it does
that work. A seam the user can drag is a splitter.

### Scrim

The translucent veil a modal draws over everything beneath it: it
dims what it covers and blocks input to it, isolating the dialog
above. A scrim is not a surface — nothing stands on it.

### Chrome

The window's furniture: every region placed directly on the
backdrop that frames the document rather than being it — navbar,
toolbar, sidebar, inspector, status bar, pane. Its fill is the
platform's sidebar material with wallpaper tinting off, measured
into the reference for each scheme: a shade darker than the content
in both, told from it by that shade and a seam. What the platform
adds on top — the wallpaper showing through the glass — a window
that cannot see the desktop does not paint. The shell pattern is
the composition of chrome regions; a variant is "chrome" when the
control lives in a chrome region. Chrome is window-scale only: the
trim inside a component or pattern — a card's header, a dialog's
footer, a table's header row — is that thing's structure, never
chrome.

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
Placement is against the window, not the region the anchor is in: a
floating surface leaves that region — a scroller, a column — and is
clipped by the window alone. It leaves with its anchor: when the
anchor scrolls out of view, the surface is dismissed.

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

### Theme colour

The one colour a user may choose. On macOS it is the accent colour
from the system's Appearance settings unless the user picks another
in the themer; on other platforms the themer sets it. It stands in
wherever the platform uses its accent colour — the default button,
the selection, the focus ring — and nothing else derives from it: no
ramp, no palette.

### Colour role

One of the theme's named colours, from which every actual colour
that carries its name is derived. Each role owns a ramp — its hue
run from light to dark, walked in numbered steps — and colours
derived from it: its tinted container, its foreground, its mark
colour.

| Roles | Family |
|---|---|
| **Neutral** | no hue of its own; the greys |
| **Primary, Secondary, Tertiary** | the accent trio |
| **Error, Success, Warning, Info** | the status four, one per status — the platform's system red, green, orange and blue; Warning is orange, never yellow; yellow is the highlighter's |

When this document says "role" without saying which kind, it means
a colour role.

### Contrast

How well a foreground reads on a fill, measured as APCA lightness
contrast, Lc. It is the one measure: a foreground is derived until it
clears the floor for its kind — text, or a mark — and the On colour
of a saturated fill is whichever of its two candidates reads better
by it. A floor is a least Lc; a number the code keeps to size a
step or a walk is a dial, not a floor. The floor values are the
plan's, not the Language's. The floors choose colours the platform
did not already choose: a pair measured off the platform — white on
systemGreen, say — stands as the platform paints it, floor or no
floor. A fill the user chose takes as its foreground whichever of
black or white reads better on it, and that is the answer even when
neither clears the floor. When the measure ties, the scheme's text
colour wins.

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

What draws the content on the fill: text, glyph, stroke. A
foreground comes in three kinds:

| Kind | On what | How it is got |
|---|---|---|
| the text colour | a surface | one stored colour, Neutral's darkest step |
| a derived foreground | a pale fill, or the surface itself, for a role's text, link or mark | the role's own hue at reading strength, worked out from the ramp against that surface until it reads |
| an On colour | a saturated fill, or the inverse pair | one stored colour per role, a neutral knocked out for contrast; the only place a foreground leaves the role's hue |

Fill and foreground are derived from the same role and the same
surface, never kept as a pair.

### Accent

How a persistent state is shown: a role-tinted fill with
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
ring around the control, and the ring is all it may draw: a checked
control that is focused gets the ring and keeps its mark — redrawing
a checked box as unchecked would let one state overwrite another.

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
height, visibly lighter than any control. The developer gives a
badge one of the four statuses — Error, Success, Warning, Info — or
no status. A status colours it in that status's role; a badge with
no status is coloured Neutral, a plain category label. There is no
other choice — no badge in Primary. Hue is never its only channel: hue
alone collapses for colour-blind readers. Filled/Tonal emphasis does not exist on a badge;
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
icon, a title, a body — standing in the page flow until the
situation resolves. The developer gives an alert one of four: Error,
Success, Warning or Info, and it is coloured in that status's role;
an alert given no status is Info. There is no other choice — no
Neutral alert, no alert in Primary. It holds words about the
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

The status signal that presents a notification for a set time: a
small annotation floating at level 2 that appears when the
notification is raised and leaves by itself when the time is up. It
is filled inverse — the other scheme's surface and foreground — so
it stands out as a message over any content in either scheme. The
developer gives a toast one of four: Error, Success, Warning or
Info, and a toast given no status is Info; that status is indicated
by its icon and mark, and there is no other choice — no Neutral
toast, no toast in Primary. Structure:
icon, text, close mark; the close is its only control. The
presentation and its timing are what make it a toast; the
notification is the message it carries. It appears in the
notifications column.

### Status

The system's report on the condition of something. There are four:
Error, it failed or is wrong; Success, it completed as intended;
Warning, it needs care before it goes wrong; Info, it is worth
knowing, neither good nor bad. Each status has a colour role of its
own in the theme, the status four, so that a signal's hue indicates
which status it carries. Three signals carry a status, divided by
what each is about and how long it stays:

| Component | Is about | Where | Until |
|---|---|---|---|
| **badge** | a thing, with a status or without one | inline with it | it stops being true |
| **alert** | a situation | in the page flow | the situation resolves |
| **toast** | an event | floating at level 2 | it leaves by itself |

The tooltip is not of the family: it names a control on demand and
indicates no status. None of the three changes behaviour when
dismissed.

### Highlight

A yellow fill laid behind content to show the user where the content
they sought is. It is the platform's find highlight as Mail paints
it, measured per scheme into the reference: a pale yellow on the
light page, a muted yellow on the dark one, and the text on it keeps
its colour. The system applies it to content, and it lasts as long
as its cause:

| Cause | Marks | Until |
|---|---|---|
| a search | every match, the current one stronger — in the content, and where each lies on the scrollbar | the query is dismissed |
| a followed link | the arrived-at content | it fades by itself, moments later |

The current match is the same yellow laid on more strongly. The
arrival highlight is a highlight flash: it appears at once when the
content comes into view and fades over a moment, never cut off. The
yellow is the highlight's alone; Warning is orange so that it can be.

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
it. Finding within a page, it also says how many matches there are
and which is current, and steps between them — Enter to the next,
Shift+Enter to the previous — scrolling the current one into view.
What it holds originates with the user.

### Scrollbar

The control moving the view through content larger than its
surface: a thumb on a track whose size mirrors how much of the
content is visible. Operating it moves the view, never the content.
While a search is on, the track shows where the matches lie in the
content, the current one stronger, beside the thumb and never under
it.

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

### Splitter

The control resizing two regions against each other: the seam
between them, made operable. It draws as the seam draws, at the
seam's width, and thickens and firms while a hand is on it; its hit
area is wider than the line, and the pointer shows the resize over
it. Dragging it moves the boundary within the bounds each region
allows, never past them. The seam is the line; the splitter is that
line operated.

### Link

The control following a reference: text that names its destination,
showing its affordance in the text itself; under the pointer it
shows the pointing hand, the cursor every link shares. Following it
is its only action. Arriving may set off a highlight flash on the
content the link pointed at, so the reader sees where they were
brought. A heading word — a word of the prose that a heading of the
same document equals or contains, whole word, case-insensitive — is a
link only while the command key is held with the pointer over it;
at rest it is prose, and operating it goes to that heading.

### Icon

The signal drawing a concept as a glyph: it names an action or a
thing at a glance. It is drawn in the foreground of what it sits in
— a button's icon in the button's foreground, an icon on the content
in the text colour — and carries no role of its own. Inside a
control's structure an icon is a part, not a signal of its own.

### Tooltip

The signal naming a control or explaining another signal on demand:
a small annotation floating at level 3 beside its trigger, appearing
by itself after a short delay on hover or focus and leaving when they
do. It holds text only, never a control; anything the user must
operate is the job for a popover. It is filled inverse — the other
scheme's surface and foreground, the same in both schemes — so it
reads as a message about the thing, not as a panel, and it carries
no role. The tooltip and the toast are the inverse pair's two
adoptions: the signals that float and tell about a thing.

### Text label

The signal naming or captioning something: a run of text set in a
typography role. It says what a thing is. It is drawn in the text
colour of the surface it sits on and carries no role.

### Image

Content as a picture: it is read, never operated.

### Paragraph

Content as a run of styled text wrapped into lines, no wider than
its measure. The links in it are carried controls; the rest is read.

### Markdown document

Content rendered as a readable document: paragraphs, headings,
lists, code snippets, images. The links inside it are carried
controls; everything else is read.

### Accordion

The pattern stacking collapsible sections: each section a title row
with a chevron turned by its open state, and a body shown while
open.

### Card

The pattern singling something out: the platform's grouped box —
one rounded surface whose fill is a small step from the surface it
is in, darker in light and lighter in dark, no hairline and no
shadow, measured into the reference from System Settings — with
header, body and footer slots. It holds content that must stand
apart from the page around it — a summary, a preview, the
recommended tier. What a card holds stands on the card; a field in
it is a raised thing on the card. A card holds content, never
another card. It never wears a role: the developer's word about it
is a badge in its header.

### Group

The pattern dividing the page: a hairline of the separator colour
drawn around related components so the eye chunks them, no fill of
its own — what it holds stands on the surface the group is in —
optionally labelled. It singles nothing out. A group may hold a
card; it never holds another group. It wears no role.

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
rail. Its rows stand at the sidebar's own row height. The active
entry is marked the platform's way: a pill inset from the sidebar's
edges, rounded, in the sidebar's own selection colour with a white
label — measured into the reference from Voice Memos and Finder,
never edge to edge and never the list's selection colour.

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

### 0009 — apca-contrast

Context: the WCAG 2 contrast ratio ranked black above white on the
platform's blue (5.2:1 against 4.0:1) and put a black label on the
Save button, where white is plainly the more readable.

Decision: the WCAG 2 ratio leaves the system; APCA lightness contrast
is the one measure, for floors and for choosing an On colour.

Rationale: a measure that ranks the less readable colour higher is
not a measure of readability; keeping it because it was already in
use is the kind of loyalty Rene refused.

Sources: [[TRANSCRIPTS#^0005-wcag-is-wrong]],
[[TRANSCRIPTS#^0005-better-metric]]

### 0010 — platform-over-material

Context: the Material-derived status colours read weak — the success
green faint, the error red pink — and the buttons stood almost twice
the height of the platform's, while the platform's own system
colours and control heights were available all along.

Decision: the application looks like a macOS application. Where the
platform and Material differ, the platform's value is read off the
platform: system colours for the four statuses, control heights for
density, the accent colour for the seed.

Rationale: the system exists to build macOS applications; every
Material default that leaks in is a defect against that purpose, and
the answer was always right there. The platform is what it draws, not
what its guideline says: where the two differ, the measured value
wins.

Sources: [[TRANSCRIPTS#^0005-platform-colours]],
[[TRANSCRIPTS#^0005-macos-app]],
[[TRANSCRIPTS#^0005-hard-cut-to-platform]],
[[TRANSCRIPTS#^0005-measured-beats-published]]

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
