# Adopting Material 3's chip ontology

Owner prompt (2026-08-30): "we are lacking a shared design ontology —
our chips look like ass because we derived their appearance from
toolbar buttons on macOS. Investigate m3.material.io/components/chips
and propose how we can adopt this as our chips."

Owner ruling (2026-08-30, follow-up): the current chip is condemned
outright — grossly oversized, to be moved away from entirely; nothing
of its appearance is preserved or defended. Chips must be subtle. A
rounded rect is acceptable; the pill is not a requirement. This
confirms the §3c direction (outline-resting body, corner-small,
smaller-than-button height) as the destination, not an option.

Sources: the M3 chips overview/guidelines (taxonomy), and the
canonical Compose Material3 token files (AssistChipTokens,
FilterChipTokens, InputChipTokens — exact values quoted below were
read from androidx source, not from memory).

## 1. The diagnosis, sharpened

The complaint is structural, not cosmetic. Today's chip is a
*platform artifact*: its fill is a measured 1.28 L\* step read off
Mail's toolbar pop-up capsules (components/chip doc, Phase BB), its
silhouette is the platform's capsule, and its own documentation
defines it negatively — "not a quiet button", "not patterns/tag" —
because there is no positive vocabulary to define it in. The system's
thesis is *Material's generative ideas reimagined for native Go*; the
chip inverted that and generated its appearance from the platform
instead.

The deeper gap: M3 organizes small pills by **intent**. We organize
them by **provenance** — which control we measured. The intent
vocabulary M3 puts in one component is scattered across three of
ours:

- **components/chip** — a data-bearing summary (assist-flavoured),
  plus an anchor face (which M3 would not call a chip at all — it is
  a menu/dropdown affordance) and a badge face.
- **patterns/tag** — status labels AND the dismissible pill, which is
  M3's *input chip* wearing a different name.
- **components/button's emphasis axis** — the chip doc explicitly
  routes selection to "Tonal when picked, Ghost when not", which is
  M3's *filter chip* re-homed onto buttons.

No shared ontology means every new pill re-litigates its family. That
is the thing to fix; the appearance follows from it.

## 2. What M3 actually specifies (verified)

**Four intents, one anatomy.**

| intent | for | behaviour |
|---|---|---|
| Assist | a contextual smart action | clickable, never selected |
| Filter | refine content from a set | toggles; checkmark when selected |
| Input | a token the user entered | dismissible (trailing ✕); avatar-capable |
| Suggestion | a generated prompt/query | clickable, usually label-only |

Chips appear *dynamically from content or context*; buttons are
persistent verbs. That is M3's chip/button boundary, and ours can be
the same sentence.

**Anatomy (token values from androidx source):** container 32 dp
tall; shape corner-small (8 dp) — a rounded rect, **not a pill**;
label = LabelLarge; icons 18 dp (input avatar 24 dp, corner-full);
flat+unselected carries a 1 dp OutlineVariant outline and **no
fill**; selected drops the outline to 0 and fills SecondaryContainer
with OnSecondaryContainer ink; unselected label = OnSurfaceVariant
(assist: OnSurface), leading icon = Primary; elevated variants fill
SurfaceContainerLow at Level1 (hover Level2, drag Level4); disabled =
OnSurface at 38% for ink, 12% for container/outline; focus indicator
= Secondary.

The load-bearing idea: **the resting chip is an outline, not a fill —
colour arrives with meaning** (selection, elevation-for-protection,
or a role-tinted icon). Our current chip is the reverse: an
always-filled capsule whose fill carries no meaning beyond "I am a
chip".

## 3. The proposal

### 3a. Mint the ontology ADR

One ADR that adopts M3's intent taxonomy as the system's small-pill
vocabulary: **Assist, Filter, Input, Suggestion** on components/chip;
chips are things content sprouts, buttons are persistent verbs;
patterns/tag narrows to the *status label* (non-interactive,
role-hued — the one thing M3's taxonomy genuinely lacks and we
genuinely need); the dismissible tag migrates to the Input chip; the
"selection rides button emphasis" rule is repealed in favour of the
Filter chip. The anchor face is explicitly ruled on (see 3e).

### 3b. Grow the token vocabulary generatively (the real work)

M3's chip spec consumes four colour roles we do not have:
OutlineVariant, OnSurfaceVariant, SecondaryContainer/OnSecondary-
Container, SurfaceContainerLow. We should NOT copy M3's fixed tone
assignments — our system's own contribution is that every colour is
*derived against floors*. We already do exactly this for status
containers: `tokens.StatusContainer(role)` / `OnStatusContainer` /
`MarkOn` (theme/tokens/containers.go). The move:

- **Container(role) / OnContainer(role)** — generalize the existing
  status-container derivation to the accent trio; SecondaryContainer
  falls out as `Container(Secondary)`.
- **OutlineVariant** — a derived neutral rung that clears the
  GraphicFloor-for-boundaries against Surface AND Background (our
  improvement: M3's fixed outline famously goes near-invisible on
  some grounds; ours would be floored by construction).
- **OnSurfaceVariant** — the muted-ink rung, floored at TextFloor.
- **SurfaceContainerLow** — we already have the elevation ladder;
  `SurfaceAt(Level1)` is its analogue. No new token needed.

**Hard dependency:** open-rulings **144/145** — the dark ramp's
missing middle (no step between 1.9:1 and 6.6:1) is *exactly where
outlines and containers live in dark*. Adopting M3 chips before
fixing the dark ramp curve would make dark outlines either invisible
or shouting. The ramp fix is the foundation task of this adoption,
not a separate nicety. (It also resolves 138's neighbourhood: 146/147
— accent pinning — intersect the same derivation.)

### 3c. Re-anatomize components/chip

Keep what is genuinely ours and scheme-proof:
- the ground-relative colour model (a chip derives against the storey
  it stands on — this is *better* than M3's absolute tones and is
  what the three-storey gallery specimens prove),
- the contrast floors (MarkOn/TextFloor/GraphicFloor),
- the pure/live twin architecture, the 44 dp pointer target, density
  plumbing.

Replace the platform-derived appearance:
- **Silhouette**: corner-small — `Radius.Lg` (8) — replaces the pill.
- **Resting body**: outline (1 dp OutlineVariant-equivalent), no
  fill. The measured 1.28 L\* toolbar step retires to the ADR's
  history section.
- **Selected**: `Container(Secondary)` fill + `OnContainer` ink,
  outline off, leading checkmark (Filter) — drawn via the existing
  state walk rather than M3's opacity state-layers (our walk is the
  system's own feedback grammar; only the resting targets change).
- **Height** (ruled 2026-08-30): a `ChipHeight` row on Density at
  `ControlHeight − 4` — the relation, not a pin. Comfortable lands on
  M3's exact 32, Compact on 24, and "chips are smaller than buttons"
  is stated once instead of per-density.
- **Icons**: 18 dp leading/trailing, 24 dp avatar slot for Input.

### 3d. Fold the neighbours in

- **patterns/tag** keeps Filled/Tonal/Success/Warning/Error as the
  non-interactive status label, restyled to the shared anatomy
  (corner-small, outline-or-container) so tag and chip read as one
  family at two interactivity levels. `RenderDismissible` deprecates
  toward the Input chip.
- **components/button** drops the "selection = Tonal/Ghost" doctrine
  from its docs; selection lives on Filter chips. (Bonus: this
  narrows what the Ghost register must carry, easing item 139.)

### 3e. The anchor face — the one deliberate exception (decide)

mindchat's picker anchor is not an M3 chip; M3 would build it as a
menu-button. Options:
1. **Keep it as the system's one platform-native face** — explicitly
   documented as the exception where the host platform's pop-up
   vocabulary wins (chevron pair, Md corner, measured proportions).
2. Migrate it toward the dropdown family (components/input) and
   retire the face.
Recommendation: (1) now, (2) only if a real menu component lands
later. The exception is honest if the ADR names it.

## 4. Sequencing sketch (pick and choose; not yet planned)

1. Dark ramp curve fix (items 144/145) — the foundation.
2. Token vocabulary: Container(role)/OnContainer, OutlineVariant,
   OnSurfaceVariant, Density.ChipHeight (+ export/design regen).
3. The ontology ADR.
4. components/chip re-anatomy: four intents, outline-resting body,
   selected container, checkmark; goldens; gallery chip block redrawn
   around intents (assist/filter-selected/input-with-✕/suggestion ×
   three storeys).
5. patterns/tag restyle + dismissible migration; button doc repeal.
6. Apps adopt (mindchat picker per the 3e ruling); release.

Each numbered line is roughly one phase; 2–3 could merge. Nothing
here moves into PLAN.md until the owner picks.

## 5. What this costs and what it buys

Costs: the Phase BB measurement work becomes history (the ADR should
say so plainly rather than bury it); every chip/tag golden and the
mindchat picker's look move; dark adoption is gated on the ramp fix.

Buys: one intent vocabulary shared by chip, tag and button docs — the
"shared design ontology" the prompt asked for; a resting chip that is
quiet by construction instead of by measurement; selection, dismissal
and suggestion as first-class, testable intents; and a colour story
where every M3 role is re-derived through our floors, which is the
system's thesis actually applied to its most visible small control.
