# Vibrant Gio — the design system's language

## Language

**Widget** — anything the system draws as one self-contained unit;
every visible piece of a window is a widget. Widgets divide in two:

| Kind | The user |
|---|---|
| **control** | operates it — to act or to choose |
| **signal** | reads it — it informs and offers nothing |

**Control** — a widget the user operates to act or to choose.

| Control | Offers |
|---|---|
| **button** | performing an action — a persistent verb, always there |
| **chip** | acting on something the content sprouted — filter by it, take it, remove it |
| **picker** | choosing one from many — the trigger shows the choice |
| **checkbox** | recording a yes or no |

**Signal** — a widget that is read, never operated: it tells a
status or a fact. The badge is the archetype. A signal may carry one
control on it — the dismissible badge's close — without becoming a
control itself.

**Affordance** — an action a control offers and shows it offers:
pressing a button, picking from a menu, dismissing a token. The
affordance is the action, not the widget — the same affordance can
be built in more than one place or register and remains one
affordance.

**Intent** — why a small control exists; what chips are defined by.
The four chip intents:

| Intent | Meaning |
|---|---|
| **Assist** | a contextual smart action |
| **Filter** | refine content from a set; toggles, marked when selected |
| **Input** | a token the user entered; dismissible |
| **Suggestion** | a generated prompt the user may take |

**Register** — the same affordance at a different volume or in a
different setting, never a different behaviour.

| Register | Of | Meaning |
|---|---|---|
| **form** | picker | a field among fields |
| **chrome** | picker | in a toolbar or header |
| **Filled** | button | the one action a surface is about |
| **Tonal** | button | a secondary action |
| **Ghost** | button | an incidental action; claims no colour of its own |

**Emphasis** — how important an action is on the surface it sits
on. The button's registers Filled, Tonal and Ghost speak it, loudest
to quietest. Emphasis lives where interaction lives: signals have
none.

**Anatomy** — the ordered parts a component is drawn from, each
required or optional. Notation: brackets mark the optional parts, as
in [icon] text [x].

**Component** — a control or signal the system ships as one named
unit — button, chip, picker, badge — defined by its intent, anatomy
and registers. When a component's contract does not fit a consumer,
the component is extended; the affordance is never re-assembled
app-side.

**Pattern** — a composition: components and regions arranged into a
larger recurring shape — hero, navbar, modal, the shell. Patterns
place components; they do not redraw them.

**Axis** — an independent dial every component reads rather than
restates.

| Axis | Governs |
|---|---|
| density | control heights — the control ladder |
| radius | corner stops |
| scheme | light and dark |
| typography roles | the type stack's named styles |

**Surface** — a plane that content and controls stand on. Every
surface stands at a level of the elevation ladder; the window itself
is the lowest. A floating surface stands at a higher level than the
surface it floats from — that difference in level is what floating
is. In an attachment, Surface names the floating one.

**Elevation ladder** — the ordered levels surfaces stand at. The
floor is the window's own level, the darkest region in both schemes;
each step up is one level, and a surface's colours are derived
against the level it stands at.

**Chrome** — the window's furniture: every region that frames the
document rather than being it — toolbar, header, sidebar, rail,
status bar. Chrome fills at the window's floor in both schemes; the
shell pattern is the composition of chrome regions; a register is
"chrome" when the control lives in that furniture. palette.Chrome
names the colours the furniture draws.

**Attachment** — the relationship between a floating surface and
what it floats from. Its parts, which any widget can play:

| Part | Meaning |
|---|---|
| **Anchor** | the element the floating surface is positioned against |
| **Trigger** | the interaction that opens or closes it |
| **Surface** | the floating thing itself |
| **Placement** | which side it opens on, and who arbitrates |

Anchor and trigger usually coincide; they are still two parts, and
none is a component. "Anchor" is reserved for the attachment part
alone: no component may carry it as a name. The
picker's chrome-register trigger, shipped as picker.Anchor, renames
to picker.Toolbar when the chip re-anatomy round touches it
(deprecated alias until then).

**Role** — a colour identity of the theme. Each role owns a ramp —
its hue run from light to dark — and answers derived from it: its
tinted container, its ink, its mark.

| Roles | Family |
|---|---|
| **Neutral** | no hue of its own; the greys |
| **Primary, Secondary, Tertiary** | the accent trio |
| **Error, Success, Warning, Info** | the status four |

Wherever a ruling says "role-tinted" or "the role's own hue", this
is the role it means. Typography roles are a different thing
entirely — the type stack's named styles, under Axis, always spoken
with the qualifier.

**Ground** — the surface a control stands on, as that control sees
it; every colour a control draws is derived against its ground,
never absolute.

**State** — what is happening to a control right now.

| Kind | States | Meaning |
|---|---|---|
| transient | hover, press | accompany an interaction in progress and pass with it |
| persistent | selected, checked, active, focused | outlive the pointer and mark meaning |

**Rest** is the absence of every state. **Disabled** is not a state
the user causes: the system has withdrawn the control; it is drawn
faded and no state applies until it returns.

**Fill** — the field a component paints behind its content, always
derived against its ground, never a stored swatch.

| Fill | Who wears it |
|---|---|
| the role's hue diluted toward the ground — a pale tinted field | badges, persistent states and the Tonal button, all in one shared tint; behaviour tells them apart |
| the role's hue at full saturation | Filled emphasis only — reserved for where interaction lives; a badge's fill is never saturated |
| none | the ghost button at rest, the glyph badge |

Transient states walk the fill — hover and press step it
from the ground.

**Foreground** — what draws the content on the fill: text, glyph,
stroke. On a tinted or absent fill the foreground is the same hue at
reading strength — never an independent "on colour" token; only on
Filled emphasis' saturated fill does the foreground leave the hue,
knocked out to a neutral for contrast. Fill and foreground are two
renditions of one identity, not a stored pair, and they are the spec
vocabulary.

**Accent** — how a persistent state speaks: a role-tinted fill with
the role colour, darkened, as foreground — the same in a menu, a
sidebar or a list. On a focused control the accent is the ring
around it.

**Selection** — the persistent state marking the thing you chose:
the picked menu row, the marked Filter chip. Walking the neutral
ramp for a persistent state is the transient grammar applied to the
wrong kind of state.

**Checked** — the persistent state of a binary control: the user's
recorded yes on a checkbox, switch or radio. It survives hover and
focus; focus may ring a checked control, never repaint its mark (the
focus treatment that redraws a checked box as unchecked is one
state's grammar overwriting another's).

**Active** — the persistent state marking where the user is: the
current tab, the current sidebar entry, the open document. Positional
and one-of-many. Distinct from selection: selected is the thing you
chose, active is the place you are; both are persistent and speak
through the accent.

**Voice** — who a widget speaks for: the user (their own entries and
tokens) or the system or author (words about the content). A signal
always speaks in the system's voice.

**Chip** — a small, subtle control that content sprouts, defined by
its intent (one of the four), never by looks or platform provenance.
Not a quiet button: buttons are persistent verbs; chips appear from
content and context. Anatomy: [icon] text [x]. The line against the
badge is read/use: if you read it, it is a badge; if you use it, it
is a chip.

**Picker** — the pick-one-from-many control: one shared **Menu**
(the surface) behind two register triggers:

| Trigger | Register |
|---|---|
| **Field** | form |
| **Toolbar** | chrome — shipped as picker.Anchor, renaming per the Attachment entry |

Single-choice by contract — the trigger shows
the value. Multiselect of a few visible options is the Filter chip's;
a summarizing multi-picker does not exist until a consumer outgrows
that.

**Badge** — the small status signal: the system's word or sign
about content — read, not used. One intent, three utterances:

| Utterance | Example | Fill |
|---|---|---|
| a word | "Popular" | tinted container — words are arbitrary content, so hue alone cannot carry the variant |
| a count | the unread 9 | tinted container, for the same reason |
| a glyph | the key-check verdict | may stand bare — the glyph's shape carries the meaning; the green check and the red cross differ by form before they differ by hue |

It covers what M3 and iOS call a badge too. Not a control: sized to
its content like an inline annotation, off the control ladder
entirely, visibly lighter than any control. It speaks only in the
status roles' own hues plus Neutral for plain category labels, and
hue is never its only channel (hue-only variants collapse for
colour-blind readers). Filled/Tonal emphasis does not exist on a badge;
emphasis lives where interaction lives. A badge may be dismissible
(the close mark keeps an invisible control-sized hit area); what
separates a dismissible badge from an Input chip is voice, not the
close — a badge is applied by the system or author *about* the
thing, an Input chip is a token the user entered themselves.
Dismissing a badge removes only the label, never behaviour — so a
system-generated summary of view state, "filtered by X", is plain
text or a close-less badge, removed where it was set. A component,
not a pattern.

**Eyebrow** — the hero's kicker: a short overline in the type stack
that introduces the headline. Pure typography — a typographic role,
not a badge: it carries no variant, no container,
no voice about content; it is the composition speaking, not the
system. Wears type styling (size, tracking, a hue if the theme says
so), never the badge's tinted container.

**Button** — a persistent verb. Selection does not ride its emphasis
registers; that is the Filter chip's intent.

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

## Example dialogue

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in components?

Orchestrator: they are the same affordance built twice — the form
register's trigger owns its menu, the chrome register's trigger is
placed by a popover — so it becomes one picker: one Menu, two
register triggers, and the anchor face leaves the chip family it was
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
