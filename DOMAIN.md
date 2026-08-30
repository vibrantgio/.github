# Vibrant Gio — the design system's language

## Language

**Role** — a part any widget can play in a relationship; not a
component. The attachment roles: **Anchor** (the element a floating
surface is positioned against), **Trigger** (the interaction that
opens or closes it), **Surface** (the floating thing itself),
**Placement** (which side, and who arbitrates). Anchor and trigger
usually coincide; they are still two roles. "Anchor" is reserved for
the role alone (ruled 2026-08-30): no component may carry it as a
name. The picker's chrome-register trigger, shipped as
picker.Anchor, renames to picker.Toolbar when the chip re-anatomy
round touches it (deprecated alias until then).

**Ground** — the plane a control stands on; every colour a control
draws is derived against its ground, never absolute. The elevation
ladder orders grounds; the floor is the window's darkest region in
both schemes.

**Intent** — why a small control exists; the axis chips are defined
on. The four chip intents: **Assist** (a contextual smart action),
**Filter** (refine content from a set; toggles, marked when
selected), **Input** (a token the user entered; dismissible),
**Suggestion** (a generated prompt the user may take).

**Register** — the same affordance at a different volume or in a
different setting, never a different behaviour. The picker's
registers: **form** (a field among fields) and **chrome** (in a
toolbar or header). The button's emphasis registers: Filled, Tonal,
Ghost.

**Chip** — a small, subtle control that content sprouts, defined by
its intent (one of the four), never by looks or platform provenance.
Not a quiet button: buttons are persistent verbs; chips appear from
content and context. Anatomy: optional leading icon, the text,
optional trailing close — [icon] text [x]. The line against the
badge is read/use: if you read it, it is a badge; if you use it, it
is a chip.

**Picker** — the pick-one-from-many control: one shared **Menu**
(the surface) behind two register triggers (**Field**, form;
**Toolbar**, chrome — shipped as picker.Anchor, renaming per the
Role entry). Single-choice by contract — the trigger shows
the value. Multiselect of a few visible options is the Filter chip's;
a summarizing multi-picker does not exist until a consumer outgrows
that.

**Selection** — a persistent state, not a transient one. States
divide in two: transient states (hover, press, focus) accompany an
interaction in progress and walk their fill from the ground;
persistent states (selected, checked, active) outlive the pointer and
mark meaning, so they speak through the accent — a role-tinted
container with floored ink — the same in a menu, a sidebar or a list
(ruled 2026-08-30, after a menu marked selection by escaping to the
inverse surface: a dead end reached by walking the neutral ramp on a
mid-grey ground — the transient grammar applied to a persistent
state).

**Checked** — the persistent state of a binary control: the user's
recorded yes on a checkbox, switch or radio. It survives hover and
focus; a transient state may ring a checked control, never repaint
its mark (the focus treatment that redraws a checked box as unchecked
is the transient grammar overwriting a persistent state).

**Active** — the persistent state marking where the user is: the
current tab, the current sidebar entry, the open document. Positional
and one-of-many. Distinct from selection: selected is the thing you
chose, active is the place you are; both are persistent and speak
through the accent.

**Badge** — the textual status label, drawn in a role's own hue: the
system's word about content — read, not used. Formerly "tag" (renamed
2026-08-30; "tag" leaves the language). A badge may carry a close
affordance (ruled 2026-08-30: the badge keeps dismissible); what
separates a dismissible badge from an Input chip is voice, not the
close — a badge is applied by the system or author *about* the
thing, an Input chip is a token the user entered themselves.
Dismissing a badge removes a label; dismissing an Input chip removes
the user's own entry. The eyebrow is a badge at its quietest: pure
text, no pill. A component, not a pattern.

**Mark** — the icon-like signal a control or region wears: a glyph
or a count, never a word — the moment it speaks a word it is a
badge. Meaning is carried by shape and hue, read at a glance: a
key-check verdict, an unread count. Mark claims what M3 and iOS call
a "badge", freeing that word for the statement. A component, not a
pattern.

**Chrome** — the window's furniture: every region that frames the
document rather than being it — toolbar, header, sidebar, rail,
status bar. Chrome fills at the window's floor in both schemes; the
shell pattern is the composition of chrome regions; a register is
"chrome" when the control lives in that furniture. palette.Chrome
names the colours the furniture draws.

**Button** — a persistent verb. Selection does not ride its emphasis
registers; that is the Filter chip's intent.

**Axis** — an independent dial every component reads rather than
restates: density (control heights), radius (corner stops), scheme
(light/dark), typography roles.

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

2026-08-30 · strategic. The statement label renames tag → badge, and
the icon-like signal becomes its own component, mark. The boundary
is text: a mark is icon-like (a glyph or a count), a badge is
textual, a chip is [icon] text [x] with the brackets optional.
Naming the platform's count-dot sense "mark" claims the word
deliberately — arrivals from M3/iOS find their badge under mark,
freeing badge for the statement. Both are components, not patterns.
Downstream: the tag pattern becomes the badge component; hand-rolled
verdict glyphs (mindchat's key check) hoist into mark; the chip's
old badge face lands in badge territory. Sources:
[[TRANSCRIPTS#^0002-badge-word]],
[[TRANSCRIPTS#^0002-mindchat-marker]],
[[TRANSCRIPTS#^0002-mark-and-badge]],
[[TRANSCRIPTS#^0002-mark-badge-chip]]

## Example dialogue

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in components?

Orchestrator: they are the same affordance built twice — the form
register's trigger owns its menu, the chrome register's trigger is
placed by a popover — so it becomes one picker: one Menu, two
register triggers, and the anchor face leaves the chip family it was
never ontologically part of.

Sources: [[TRANSCRIPTS#^0001-anchor-not-chip]]
