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
content and context.

**Picker** — the pick-one-from-many control: one shared **Menu**
(the surface) behind two register triggers (**Field**, form;
**Toolbar**, chrome — shipped as picker.Anchor, renaming per the
Role entry). Single-choice by contract — the trigger shows
the value. Multiselect of a few visible options is the Filter chip's;
a summarizing multi-picker does not exist until a consumer outgrows
that.

**Tag** — the non-interactive status label, drawn in a role's own
hue. It does not move under the pointer; the dismissible pill is the
Input chip's, not the tag's.

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

## Example dialogue

Rene: anchor doesn't even look like a chip where it stands. So how
does chip:anchor relate to Dropdown in components?

Orchestrator: they are the same affordance built twice — the form
register's trigger owns its menu, the chrome register's trigger is
placed by a popover — so it becomes one picker: one Menu, two
register triggers, and the anchor face leaves the chip family it was
never ontologically part of.

Sources: [[TRANSCRIPTS#^0001-anchor-not-chip]]
