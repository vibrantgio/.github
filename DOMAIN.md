# Vibrant Gio — the design system's language

## Language

### Accent

How a persistent state is shown: the platform's selection colour for
the place — the list's selected row, the sidebar's pill, the menu's
picked row — as the fill, with white text. On a focused control the
accent is the ring around it, in the theme colour.

### Accordion

The pattern stacking collapsible sections: each section a title row
with a chevron turned by its open state, and a body shown while
open.

### Action

Something the application does because the user asked for it:
sending the message, keeping the colour, opening a menu. Performing
an action changes more than the control that offered it — a control
that only records a choice, like a checkbox taking a yes, has not
performed an action.

### Active

The persistent state marking where the user is: the
current tab, the current sidebar entry, the open document. Positional
and one-of-many. Distinct from selection: selected is the thing you
chose, active is the place you are; both are persistent and speak
through the accent.

### Affordance

An action a control offers and shows it offers:
pressing a button, picking from a menu, dismissing a token. The
affordance is the action, not the component — the same affordance can
be built in more than one place or variant and remains one
affordance.

### Alert

The status signal for a situation: a rounded box on the content's
own background inside a separator hairline — an icon, a title in the
text colour, a body — standing in the content's flow until the situation
resolves. The developer gives an alert one of four: Error, Success,
Warning or Info, and the icon shows it in that status's system
colour; an alert given no status is Info. There is no other choice —
no Neutral alert, no alert in the theme colour. It holds text about the
situation, never a control: an action on the situation stands beside
the alert, or the situation is a modal's job.

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
alone: no component may use it as a name — the picker's
chrome-variant trigger is Toolbar.

### Axis

An independent dial every component reads rather than
restates.

| Axis | Governs |
|---|---|
| density | how tightly controls pack — the control height and inner padding |
| radius | corner stops |
| scheme | light and dark |
| typography roles | the type stack's named styles |

### Backdrop

The window's own surface, filled with the platform's window
background. It shows wherever nothing stands — around an inset pane.
Nothing is drawn at it and no foreground is ever measured against
it: the backdrop is only ever what shows around.

### Background

The colour behind everything in a region: what shows wherever
nothing is drawn. The platform names one per kind of region — the
window background behind the window, the text background behind a
document, the control background behind a list or a table — and each
is a colour role read off the platform per scheme. Whatever a
component draws, it draws over the background of the region it is
in.

### Badge

The small status signal: the system's word or sign
about content — read, not used. One purpose, three utterances:

| Utterance | Example | Fill |
|---|---|---|
| a word | "Popular" | the status's system colour at full strength with white text, as the platform draws a count badge; Neutral wears the system grey |
| a count | the unread 9 | the same |
| a symbol | the key-check verdict | may stand bare, the symbol in the status's system colour — the symbol's shape gives the meaning; the green check and the red cross differ by form before they differ by hue |

It covers what iOS calls a badge too. Not a control: sized to
its content like an inline annotation, not sized to the control
height, visibly lighter than any control. The developer gives a
badge one of the four statuses — Error, Success, Warning, Info — or
no status. A status colours it in that status's role; a badge with
no status is coloured Neutral, a plain category label. There is no
other choice — no badge in the theme colour. Hue is never its only channel: hue
alone collapses for colour-blind readers. Filled/Tonal emphasis does not exist on a badge;
emphasis lives where interaction lives. A badge may be dismissible
(the close mark keeps an invisible control-sized hit area); what
separates a dismissible badge from an Input chip is the
originator, not the close — a badge is applied by the developer or
the system *about* the thing, an Input chip is a token the user
entered themselves. Dismissing a badge removes only the badge, never
behaviour — so a system-originated summary of view state, "filtered
by X", is plain text or a close-less badge, removed where that state
is set. A developer-originated badge is a fixture: nothing the user
did made it appear, so it is never dismissible.

### Breadcrumb

The control going back up the hierarchy: a row of names separated
by chevrons, each a link to its place. The last is where you are —
plain text, not a link. It is generated from the path; nothing is
filled into it.

### Button

The control that performs an action when pressed. It
is a fixture: placed by the developer, always visible, always offering
the same action — it does not appear from content the way a chip
does, and it does not record a state. Marking a choice is never a
button's job, whatever its emphasis; that is the Filter
chip's purpose.
A button with a face is bordered, the platform's term: on chrome the
capsule, in a form the push button, each measured; a button with no
face is borderless. Its title is text, a symbol, or both.

### Caption

A line of text under a picture or beside a control saying what it
shows or does, set smaller than the text it explains, read and never
operated.

### Card

The pattern singling something out: the platform's grouped box —
one rounded surface whose fill is a small step from the surface it
is in, darker in light and lighter in dark, no hairline and no
shadow, measured into the reference from System Settings — with
header, body and footer slots. It holds content that must stand
apart from the content around it — a summary, a preview, the
recommended tier. What a card holds stands on the card; a field in
it is a raised thing on the card. A card holds content, never
another card. It never wears a role: what the developer says about it
is a badge in its header.

### Casing

Text in the window is cased as the platform cases it: a
control's title and a menu item in title case ("Switch Vault",
"Save As…"); a field's label, a caption, a section heading and a
sentence of prose in sentence case ("Base URL:", "Text highlight
colour"); never in capitals throughout.

### Checkbox

The binary control recording a yes or no. Its recorded yes is the
checked state; only the user's own operation repaints the mark.
Structure: the box and its title. As on the platform the title is
part of the control — clicking it operates the box — set beside it
at the platform's measured gap, in the text colour, and faded with
the box when the control is disabled.

### Checked

The persistent state of a binary control: the user's
recorded yes on a checkbox, switch or radio. It survives hover and
focus.

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

### Chrome

The window's furniture: every region placed directly on the
backdrop that frames the document rather than being it — navbar,
toolbar, sidebar, inspector, status bar, pane. Its fill is the
platform's sidebar material with wallpaper tinting off, measured
into the reference for each scheme: a shade darker than the content
in both, set apart from it by that shade and, where the two are flush, a
seam. What the platform
adds on top — the wallpaper showing through the glass — a window
that cannot see the desktop does not paint. The shell pattern is
the composition of chrome regions; a variant is "chrome" when the
control lives in a chrome region. Chrome is window-scale only: the
trim inside a component or pattern — a card's header, a dialog's
footer, a table's header row — is that thing's structure, never
chrome.

### Colour role

One of the theme's named colours. The names are the platform's —
the label colours, the window and content backgrounds, the
separator, the selection colours, the accent, the system colours —
each holding one value per scheme, read off the platform or measured
into the reference. Nothing is derived from a role: a role is
painted at its value. Two families have names of the Language's
own:

| Roles | Family |
|---|---|
| **Neutral** | no status: the platform's system grey where a fill is needed, its secondary label where a sign is |
| **Error, Success, Warning, Info** | the status four, one per status — the platform's system red, green, orange and blue; Warning is orange, never yellow; yellow is the highlighter's |

The theme colour is a role too: the platform's accent.

When this document says "role" without saying which kind, it means
a colour role.

### Column

A region or a part of a table that runs the full height, standing
side by side with others: the sidebar, the content and the inspector
are the window's columns; a table's columns each hold one field of
every row.

### Component

What the system ships as one named unit — button, chip, picker,
badge — defined by its purpose, structure and variants. When a
component's contract does not fit a consumer, the component is
extended; the affordance is never re-assembled app-side. "Widget" is
not a term of this language: it stays Gio's own term (layout.Widget,
anything that can be laid out). A component is defined by itself,
never assembled from other components: where it has one — the
badge's close, the picker's menu — that is a fixed part of its
structure, not a slot. Every component is one of two kinds — a
control is a component, and a signal is a component:

| Kind | The user |
|---|---|
| **control** | operates it — to act or to choose |
| **signal** | reads it — its only purpose is to inform |

### Content

The matter the application exists to show: prose, pictures, data —
what the user came to read or edit. Content stands at level 0; its
originator is a person — the user, or the author who wrote it —
never the developer and never the system, which only speak about
it. Content is rendered by modules — the markdown
document, an image — not shipped as a component: components stand
beside content or act on it. The controls inside content — its
links — are held the way a signal holds its close: the
affordance belongs to the link, the prose around it stays read-only.

### Contrast

How well a foreground reads on a fill, measured as APCA lightness
contrast, Lc. It is the one measure: a foreground reads when it
clears the floor for its kind — text, or a mark — and the text on a
fill the platform did not pair is whichever of black or white reads
better by it. A floor is a least Lc. The floor values are the
plan's, not the Language's. The floors choose colours the platform
did not already choose: a pair measured off the platform — white on
systemGreen, say — stands as the platform paints it, floor or no
floor. A fill the user chose takes as its foreground whichever of
black or white reads better on it, and that is the answer even when
neither clears the floor. When the measure ties, the scheme's text
colour wins.

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
list's; a control standing in the toolbar its own, taller than the
regular control. All are measured into the reference, not derived
from the control height.

### Dialog

The platform's term for the box that asks for a decision and blocks
the window until it is answered: on macOS a sheet attached to the
window's title bar, elsewhere a box floating over the window. The
modal pattern draws the library's; the open panel is the platform's
own.

### Disclosure

The platform's control that opens and closes what it heads: a small
chevron pointing right when closed and down when open, at an outline
row's leading end or at a section heading's trailing end.

### Elevation

The dimension of how high a surface stands. It is
spoken in levels, never in its own units.

### Emphasis

How important an action is on the surface it sits on, ranked most
pronounced to least. Emphasis lives where interaction lives:
signals have none.

| Emphasis | Of | Meaning |
|---|---|---|
| **Filled** | button | the one action a surface is about |
| **Tonal** | button | a secondary action |
| **Ghost** | button | an incidental action; claims no colour of its own |

### Eyebrow

The hero's kicker: a short overline in the type stack
that introduces the headline. Pure typography — a typographic role,
not a badge: it has no status, no fill,
says nothing about content; it is the developer speaking, not the
system. Wears type styling (size, tracking, a hue if the theme says
so), never a badge's fill.

### Feature

The marketing pattern presenting capabilities as an icon-title-body
grid, so many features read as one set.

### Fill

The field a component paints behind its content: a colour role,
painted at the platform's value for the scheme. A role the platform
paints at an alpha composites over the surface beneath, in encoded
sRGB.

| Fill | Who wears it |
|---|---|
| the platform's push button fill, measured | the Tonal button, the disabled button, the chip at rest, the picker's trigger |
| the theme colour | the Filled button — the one action a surface is about |
| the platform's selection colour for the place | the selected chip, the picked row, the sidebar's active entry |
| the status's system colour at full strength | the worded or counted badge |
| the content's own background inside a separator hairline | the alert |
| the window's own background inside a separator hairline | the toast, the tooltip |
| none | the Ghost button at rest, the symbol badge |

Transient states lay the platform's hover and press overlays over the
fill, or over the surface where there is none.

### Focus ring

The ring the platform draws around the outside of the focused
control, a few pixels wide, in the platform's keyboard focus colour,
the control keeping its own edge and size; one drawing for every
control.

### Focused

The persistent state marking where keyboard input goes: the control
that receives the typing and reacts to Enter or Space. It stays
until focus moves elsewhere — Tab, or a click. A control that took
the keyboard for a while and is then dismissed — a find field
closed, a menu let go — gives it back to where it came from, as the
platform does. Its accent is the ring around the control, and the ring is all it may draw: a checked
control that is focused gets the ring and keeps its mark — redrawing
a checked box as unchecked would let one state overwrite another.

### Foreground

What draws the content on the fill: text, symbol, stroke. A
foreground comes in three kinds:

| Kind | On what | What it is |
|---|---|---|
| the text colour | a surface, the push button fill, the alert, the toast, the tooltip | the platform's label colour; its secondary label for lesser text and for Neutral's bare sign |
| a status colour | a bare symbol, the alert's icon, the toast's icon | the status's system colour itself |
| the selected text | the theme colour, a selection colour, a status's fill | the platform's alternate selected control text — white in both schemes; on a fill the user chose, black or white, whichever reads better |

Fill and foreground are read off the platform as the pair the
platform paints.

### Glow

Light spreading from a shape into what surrounds it: a gradient of
the shape's colour fading out from its edge over the glow's spread,
the distance it reaches. A glow is an effect a component asks for,
never a level and never a shadow.

### Group

The pattern dividing the content: a hairline of the separator colour
drawn around related components so the eye chunks them, no fill of
its own — what it holds stands on the surface the group is in —
optionally titled. It singles nothing out. A group may hold a
card; it never holds another group. It wears no role.

Which of the two a developer reaches for answers one question: am I
dividing the content, or singling something out? A form in sections, a
list of articles, a row of tiers — groups. The one thing that must
stand apart — a card.

### Hairline

A line one pixel wide at 1x, whatever its colour: a seam, a rim, a
group's outline.

### Heading

A line of text naming the content beneath it, set apart from that
content by its typography role alone and never operated: in a document the
six heading levels; in a sidebar a section's heading, set small; in
a group its title; in a table the header row's titles. A heading word in a
document that can be operated is the exception the Link entry names.

### Hero

The marketing pattern opening the content: an eyebrow, a display title,
a subtitle, an optional visual and a call-to-action pair,
introducing what the content is about.

### Highlight

A yellow fill laid behind content to show the user where the content
they sought is. It is the platform's find highlight as Mail paints
it, measured per scheme into the reference: a pale yellow on the
light scheme, a muted yellow in the dark one, and the text on it keeps
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

### Icon

The signal showing a symbol for a concept: it names an action or a
thing at a glance. It is drawn in the foreground of what it sits in
— a button's icon in the button's foreground, an icon on the content
in the text colour — and has no role of its own. Inside a
control's structure an icon is a part, not a signal of its own.
A mark is named by what it depicts, never by what it does: one
mark serves several actions, and the same picture has one name.

### Image

Content as a picture: it is read, never operated.

### Inspector

The pattern of a column beside the content, showing the
properties of whatever is selected in it and offering the controls
that change them. It follows the selection; empty selection, empty
inspector.
It is chrome: it wears the sidebar
material, with a seam to the content, and a list in it selects as
the sidebar does, with the inset pill.

### Label

The signal naming or explaining something: text standing by itself
on the surface, set in a typography role — the platform's term for
such text. It says what a thing is. It is drawn in the text
colour of the surface it sits on and has no role.

### Level

A position in the window's depth: backdrop, chrome, content, raised,
floating. Each level's fill is the platform's, read off the platform
per scheme, never derived from another level's; no level is lighter
or darker than another by rule.

| Level | Holds | Platform fill |
|---|---|---|
| **backdrop** | nothing: the window's own surface, showing wherever nothing stands | the window background |
| **chrome** | the chrome regions — sidebars, toolbars, navbars, inspectors, status bars, panes | the sidebar material with wallpaper tinting off, measured into the reference |
| **content** | the document being read, lists, tables | the text background |
| **raised** | on the content and attached to it — cards, fields, filled insets | the platform's grouped box: a small step from the surface beneath, darker in light and lighter in dark, measured into the reference; a field the platform's field |
| **floating** | detached, placed by an attachment or over a scrim — dialogs, toasts, menus, popovers, tooltips | the window background, under the platform's shadow |

Standing higher is told the way the platform tells it: a raised
thing by the box's small step of fill, no hairline and no shadow; a
floating thing by its shadow. A field inside a card is raised on the card the
same way. Cards do not nest: grouping within a card is its
structure.

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

### List

The control for a sequence of rows: the user moves through them
and may choose one, by pointer or keyboard. A chosen row is in the
selection state. A menu is a list that floats; a table is a list
whose rows have columns. A list is a focusable wherever it stands,
and shows the focus as the platform does for its place: in the
content or a dialog, the focus ring around the list; in a sidebar,
the pill's colour; in a menu, the held row and no ring.

### Mark

The small symbol a component draws. A mark shows a recorded state —
the checkbox's check, the radio's dot — or offers a dismissal — the
close cross on a badge or an Input chip. A mark is a part of a
structure, never a component. It is drawn in its role's mark colour.
Only the user's own operation repaints a mark that shows a state; a
focused control gets a ring around it and its mark is left alone.

### Markdown document

Content rendered as a readable document: paragraphs, headings,
lists, code snippets, images. The links inside it are held
controls; everything else is read.

### Material

The platform's term for a background that shows what is behind the
window through it, blurred and tinted: the sidebar material, the
menu material. Each is painted here flat, at its value measured with
wallpaper tinting off.

### Measure

The width a run of text is allowed to reach, from typography: long
lines tire the reader, so a paragraph stops at its measure however
wide the region is. Content narrower than its region is centred
within the region; nothing widens to fill. Wide content that keeps
its own size — a code block, a table — sits in a scroll area no
wider than the measure.

### Menu

The floating list component: items stacked on a surface at level 3,
opened by a trigger and placed by the attachment rules. Each item
either performs an action — a context menu's Copy — or records a
choice — the picker's option. One menu, many openers: the picker's
triggers, a secondary click on content, a menu bar.

### Modal

The pattern that interrupts for a decision: a dialog floating at
level 2 over a scrim, with a header holding its title and close, a
body, and a footer of actions. The scrim isolates it — everything
beneath is dimmed and deaf until the modal closes.
Choosing a file or a folder is the platform's own open panel where
the platform offers one, and the library's modal where it does not;
on Open the whole window follows the choice.
When a modal opens, its first field holds the keyboard focus, as the
platform's sheet shows.

### Navbar

The pattern spanning the window's top: a brand leading,
links centred, actions trailing. The active link is marked.

### Notification

What the system tells the user about an event that happened: the
message saved, the export finished, the connection lost. A
notification is the message; how it is shown is a presentation —
today the toast — and the notifications pattern is what receives
and presents it. A notification is raised by message, never drawn
in place.

### Notifications

The pattern receiving the application's notifications and
presenting them: a position-anchored column where each arrives,
stacks against the others and leaves on its own timing. Today every
notification is presented as a toast; the pattern owns the queue,
the placement and the timing, not the presentation.

### Originator

Who a component speaks for.

| Originator | Says | Example |
|---|---|---|
| **the user** | their own entries and tokens | the filter token they typed |
| **the developer** | text placed when the application was built | the "Popular" label, a control's caption, the eyebrow |
| **the system** | what the running application computes | the unread count, the key-check verdict, "filtered by X" |

A signal's originator is never the user: it speaks for the developer
or the system. Content originates with a person — the user, or the
author who wrote it — never with the developer's labels and never
with the system.

### Outline

The platform's term for a list whose rows nest: each row may hold
rows beneath it, shown indented one step per depth behind a
disclosure that opens and closes them, and a closed row's rows are
not in the list. It is one focusable like any list; Left and Right
close and open the row or move to its parent and its first child.
The sidebar's tree of folders and the content's tree of headings are
outlines.

### Pagination

The control moving between numbered pages of content: page buttons
flanked by previous and next, generated from the page count. The
current page is active.

### Pane

The pattern setting a column in from the window's edges
rather than making it one of them: set in, rounded on all corners, with the platform's rim and shadow, the window's own surface
showing around it on every side. The sidebar is one. Unlike flush
chrome it is an object — a control can send it away, and what stood
beside it reflows to the window's edge.

### Paragraph

Content as a run of styled text wrapped into lines, no wider than
its measure. The links in it are held controls; the rest is read.

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
| **group** | a hairline around related components at the surface's own level, optionally titled — divides the content |
| **hero** | the marketing landing block: eyebrow, display title, subtitle, visual, a call-to-action pair |
| **inspector** | a column beside the content showing the properties of what is selected in it |
| **modal** | a centred dialog floating over a full-window scrim — header, body, footer actions |
| **navbar** | the horizontal bar of brand, links and actions; the active link marked |
| **notifications** | the column that receives notifications and presents them — today as toasts — positioned, stacked and timed |
| **pane** | a column set in from the window's edges rather than being one of them, the backdrop showing around it |
| **popover** | a small surface floating beside its anchor, a tail pointing at it |
| **pricing** | a row of tier groups, the recommended tier a card wearing a badge |
| **shell** | the top-level application layout: the composition of the regions around the content |
| **sidebar** | a collapsible vertical column — expanded with symbols and titles or collapsed to a rail of symbols; the active entry marked |
| **status bar** | the strip along the window's bottom, reporting on the document |
| **table** | data in rows and columns, sortable and filterable — a list whose rows have columns |
| **tabs** | a horizontal tab strip, the active tab underlined, its content below |
| **testimonial** | quote cards naming their author — social proof |
| **toolbar** | the strip along the window's top holding the controls that act on the document |

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

### Pill

The rounded fill behind a selected row, inset from the row's ends,
its corners fully round: the platform's selection shape in a sidebar
and a menu.

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

### Pointer

The platform's pointer, shaped for what is under it now: the arrow
over controls, lists and chrome, the I-beam over text that can be
selected or edited, the hand over a link. The shape belongs to the
region under the pointer and changes as the pointer crosses into
another; a region never leaves its shape behind.

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

The marketing pattern laying tiers side by side as cards; one of
them may be singled out as the recommended tier.

### Purpose

What a component is for, chosen from the few purposes its entry
names, never a matter of appearance: the chip's four. A component's purpose
decides its behaviour, and a component with one purpose has no
purpose property.

### Radio

The one-of-a-few control: a visible group of options that exclude
each other, each shown, one chosen. Choosing one clears the others.
When the options are too many to stay visible, the picker takes
over. Each option is a disc and its title, the title part of the
control as the checkbox's is.

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

### Recess

A fill a shade apart from the background around it, with no edge,
that looks sunk into it: the platform's search field on chrome.

### Region

A part of the window with a background of its own: the sidebar, the
toolbar, the content, the inspector, the status bar. A region is
flush when it runs to the window's edges or meets another region at
a seam, and inset when it is a pane.

### Rim

The one-pixel line the platform draws along the edge of a pane or a
recess, lighter than both sides, measured per scheme. A rim belongs
to the object it edges; a seam belongs to the meeting of two flush
regions.

### Row

One entry of a list: as tall as the list's row height, holding the
entry's parts across the list's width. The row is what the keyboard
moves through and what the selection marks.

### Scheme

Whether the theme is light or dark. Every colour role has a value
per scheme, the platform's for that appearance.

| Scheme | Meaning |
|---|---|
| **Light** | dark foreground on light surfaces |
| **Dark** | light foreground on dark surfaces |

### Scrim

The translucent veil a modal draws over everything beneath it: it
dims what it covers and blocks input to it, isolating the dialog
above. A scrim is not a surface — nothing stands on it.

### Scroll area

The control for one piece of content that keeps its own size — a
code block, a preformatted table, a wide diagram: it shows the part
that fits and lets the user move the view to the rest, sideways or
down. Nothing in it is chosen; the content is never reflowed or cut.

### Scrollbar

The control moving the view through content larger than its
surface: a thumb on a track whose size mirrors how much of the
content is visible. Operating it moves the view, never the content.
While a search is on, the track shows where the matches lie in the
content, the current one stronger, beside the thumb and never under
it.

### Seam

The hairline where two flush regions meet — a list column against
the content, the navbar's foot, the status bar's top. It is the
platform's separator colour: black or white
at a tenth, laid over whatever is beneath, so it reads on any fill;
drawn once, by the region above or leading.
An inset object needs no seam: the backdrop showing around it does
that work. A seam the user can drag is a splitter.

### Search field

The control for finding content: a text field that looks as you
type and marks what it finds with the search highlight. Structure:
looking glass, text, [x]. The looking glass names the control at a
glance; the clear mark empties it and dismisses the highlight with
it. Finding within the content, it also says how many matches there are
and which is current, and steps between them — Enter to the next,
Shift+Enter to the previous — scrolling the current one into view.
What it holds originates with the user.
Escape does what the clear mark does: it empties the field and
dismisses the highlight, the keyboard staying in the field. With
nothing typed, Escape closes a find within the content and gives the
keyboard back to where it came from; a search field standing on
chrome has nothing to close and keeps the keyboard, as the platform's
does.
Standing on chrome — a sidebar, a toolbar — it is the platform's
search field there: a flat recess set a shade apart from the
sidebar material, measured per scheme, the ends fully rounded, with
no edge except where the platform draws one — the dark toolbar's
recess has a lighter rim, measured — read into the reference
from System Settings' sidebar and Voice Memos' toolbar.

### Selection

The persistent state marking the thing you chose: the picked menu
row, the marked Filter chip, the sidebar's active entry. It is
painted in the platform's selection colour with white text; the hover
and press overlays are for transient states and paint no selection.
A selected run of text in a field wears the platform's selected
text colour over its selected text background, both measured,
whatever colour the field's other text wears.

### Shell

The pattern composing the regions around the content into the application's
top-level layout — sidebar, navbar and main content, in the
arrangements its variants name.

### Sidebar

The pattern of a collapsible vertical column, set into the
window as a pane, rounded, with the platform's rim and shadow, the window buttons inside it and its own marks standing bare
in its top trailing corner, measured into the reference from Voice
Memos. No seam parts it from the content; the window's surface around
it does. Expanded it shows symbols and titles, collapsed symbols alone —
collapsed, it is a rail. Its rows stand at the sidebar's own row
height, each a symbol, a title and, at the trailing end, a count
when the entry has one. The symbol names the kind of entry, so rows
of one kind share it, as Voice Memos' folders do. A section is a
collection of entries the application keeps apart — Voice Memos'
folders against its recordings — never a sorting of one collection
by kind; an application with one collection has no sections.
Sections are headed by a small heading and parted by space alone; a section that
collapses keeps that header and takes the platform's disclosure at
its trailing end, measured, never an accordion row; each section
opens and closes on its own, as Mail's and Finder's do, so any
number may stand open at once. The sidebar is one focusable: Up and
Down move through its rows, Return opens the row, and Left and Right do what
the platform's outline does with the rows it has — in a tree they
close and open a folder or move to the parent and the first child,
in a sectioned list Left collapses the row's section, and a flat list
answers neither; a heading is never a stop, and the sidebar keeps the
keyboard even when every section is closed. A click on a row leaves the
keyboard in the sidebar, as Finder and Notes do; the content takes
it on a click inside the content, or when the move began there — a
followed link, back, forward. The active
entry is marked the platform's way: a pill inset from the sidebar's
edges, rounded, in the sidebar's own selection colour with a white
title while the sidebar holds the keyboard, and a grey pill with the
title in the accent colour while it does not — both measured into
the reference from Voice Memos and Finder, never edge to edge and
never the list's selection colour.

### Signal

A component that is read, never operated: its only purpose is to
inform. A signal tells you something; it is never the matter itself
— that is content. There are two kinds. A status signal indicates
one of the four statuses and is coloured in that status's role; a
badge may also have no status, and is then coloured Neutral:

| Status signal | Tells |
|---|---|
| **badge** | the system's word, count or symbol about content |
| **alert** | a situation, standing in the content's flow until it resolves |
| **toast** | an event, floating briefly and leaving by itself |

The other signals have no status and no role of their own; each is
coloured in the foreground of what it sits in — the developer does
not choose a colour for it:

| Signal | Tells |
|---|---|
| **icon** | a concept as a symbol — names an action or a thing at a glance |
| **tooltip** | the name of a control or the meaning of a signal, on demand |
| **label** | text standing by itself that names or explains something, set in a typography role |

A signal may hold a control without becoming one — the dismissible
badge's close. The affordance always belongs to the held control,
never to the signal.

### Splitter

The control resizing two regions against each other: the seam
between them, made operable. It draws as the seam draws, at the
seam's width, and thickens and firms while a hand is on it; its hit
area is wider than the line, and the pointer shows the resize over
it. Dragging it moves the boundary within the bounds each region
allows, never past them. The seam is the line; the splitter is that
line operated.

### State

What is happening to a control right now.

| Kind | States | Meaning |
|---|---|---|
| transient | hover, press | accompany an interaction in progress and pass with it |
| persistent | selected, checked, active, focused | outlive the pointer and mark meaning |

**Rest** is the absence of every state. **Disabled** is not a state
the user causes: the system has withdrawn the control; it is drawn
faded and no state applies until it returns.

### Status

The system's report on the condition of something. There are four:
Error, it failed or is wrong; Success, it completed as intended;
Warning, it needs care before it goes wrong; Info, it is worth
knowing, neither good nor bad. Each status has a colour role of its
own in the theme, the status four, so that a signal's hue indicates
which status it has. Three signals have a status, divided by
what each is about and how long it stays:

| Component | Is about | Where | Until |
|---|---|---|---|
| **badge** | a thing, with a status or without one | inline with it | it stops being true |
| **alert** | a situation | in the content's flow | the situation resolves |
| **toast** | an event | floating at level 2 | it leaves by itself |

The tooltip is not of the family: it names a control on demand and
indicates no status. None of the three changes behaviour when
dismissed.

### Status bar

The pattern of a strip along the window's bottom: signals
reporting on the document and the application's state — where you
are in it, what is happening to it. It reports; it holds controls
only incidentally.

### Structure

The ordered parts a component is drawn from, each
required or optional. Notation: brackets mark the optional parts, as
in [icon] text [x]. A component's or pattern's own trim — header,
footer, close, seam — is structure, not chrome.

### Surface

The flat face that content and controls stand on. Every
surface stands at a level; the window's own — the backdrop — is the
lowest. A floating surface stands at a higher level than the
surface it floats from — that difference in level is what floating
is. In an attachment, Surface names the floating one.

### Switch

The binary control that takes effect at once: flipping it turns
something on or off immediately — nothing waits to be submitted.
The checkbox records; the switch acts.

### Symbol

The platform's term for a small picture standing for a thing or an
action: drawn from the set at its keyline, in the foreground of what
it sits in, named by what it depicts. An icon is the signal that
shows a symbol; a mark is a symbol that shows a state or offers a
dismissal.

### Syntax highlighter style

The named set of colours code is highlighted with, one of the styles
the syntax highlighter offers: a colour per kind of token —
keyword, string, comment, name — and the fill of the code block they
stand on. The themer keeps one per scheme, and the code block draws
with the one for the scheme in force. "Syntax highlighter" is the
short form. The style's colours are the style's own; nothing else in
the window is coloured from them.

### Table

The pattern for data in rows and columns: a list whose rows have
columns, sortable and filterable, however many rows there are.

### Tabs

The pattern dividing content into parts shown one at a time: a horizontal
strip of titles, the active tab underlined, the active tab's content
below.

### Testimonial

The marketing pattern quoting named authors — one centred card or a
row of them — as social proof.

### Text field

The control for entering and editing text: a bounded field the user
types into. What it holds originates with the user.

### Theme

Everything a window draws with: the colours of every role and level
in both schemes, the theme colour, and the axes — density, radius,
typography roles — read by every component. A window has one theme
at a time. It follows the platform — its scheme from the system's
appearance, its colours the platform's own, its theme colour the
system's accent colour unless the user has kept one in the themer —
and every application on the machine draws with the same one. The
themer keeps three choices: the theme colour, the typeface code is
set in, and the syntax highlighter style.

### Theme colour

The one colour a user may choose. On macOS it is the accent colour
from the system's Appearance settings unless the user picks another
in the themer; on other platforms the themer sets it. It stands in
wherever the platform uses its accent colour — the default button,
the selection, the focus ring — and nothing else derives from it: no
ramp, no palette.

### Title

The name of a thing, the platform's term. Shown over the thing as a
heading — a window's name in its title bar, a dialog's, a group's,
a section's — or shown by a control as its own text — a button's
title, a checkbox's title beside its box, a sidebar row's title. A
control's title is part of the control and is operated with it.

### Toast

The status signal that presents a notification for a set time: a
small annotation floating at level 2 that appears when the
notification is raised and leaves by itself when the time is up. It
is filled with the window's own background inside a separator
hairline under the platform's shadow, its message in the text colour,
the same in either scheme. The developer gives a toast one of four:
Error, Success, Warning or Info, and a toast given no status is Info;
that status is indicated by its icon in the status's system colour,
and there is no other choice — no Neutral toast, no toast in the
theme colour. Structure:
icon, text, close mark; the close is its only control. The
presentation and its timing are what make it a toast; the
notification is the message it shows. It appears in the
notifications column.

### Toolbar

The pattern of a strip along the window's top, below the
title, holding the controls that act on the document. Its controls
are in the chrome variant; it holds controls, never content. The
picker's chrome trigger is named after it.

### Tooltip

The signal naming a control or explaining another signal on demand:
a small annotation floating at level 3 beside its trigger, appearing
by itself after a short delay on hover or focus and leaving when they
do. It holds text only, never a control; anything the user must
operate is the job for a popover. It is filled with the window's
own background inside a separator hairline, its text in the text
colour, the same in both schemes, and it has no status. The
tooltip and the toast are the two floating signals that tell about a
thing.

### Typography role

A named style of the type stack. A label or a heading is set in
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

### Variant

The same affordance in a different setting — where the control
lives — never a different behaviour and never a different
prominence; that is emphasis. A colour role is not a variant
either: an alert in Warning is an alert indicating Warning.

| Variant | Of | Meaning |
|---|---|---|
| **form** | picker, button, search field | a field among fields, on the content or in a sheet |
| **chrome** | picker, button, search field | in a chrome region — a toolbar, a sidebar, a navbar |

### Window

The platform's window: the frame the application draws in, with the
title bar, the window buttons and the shadow drawn by the platform,
its background the backdrop. Every component and pattern is drawn
inside one.

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

Superseded by 0010: the platform pairs every fill and foreground, so
there are no recipes to share.

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
[[TRANSCRIPTS#^0005-measured-beats-published]],
[[TRANSCRIPTS#^0005-new-baseline]],
[[TRANSCRIPTS#^0005-shapes-promise-stands]]

## Example dialogue

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in components?

Orchestrator: they are the same affordance built twice — the form
variant's trigger owns its menu, the chrome variant's trigger is
placed by a popover — so it becomes one picker: one Menu, two
variant triggers, and the anchor face leaves the chip family it was
never ontologically part of.

Sources: [[TRANSCRIPTS#^0001-anchor-not-chip]]

