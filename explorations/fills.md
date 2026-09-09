# How things are filled

This document is about fills: the colour a surface, a region or a
control paints behind whatever it holds, and the cases where it
paints nothing and the surface beneath shows through. It is not about
foregrounds — text, glyphs, strokes drawn on top are out of scope,
except where an edge stands in for a fill.

It has three parts. The first is the current situation, read off the
code on 2026-09-09 and measured on the default seed in both schemes.
The second will be the future situation, taken from the applications
we want to look like. The third will be the rules that get us from the
one to the other. Only the first part is written.

Values are given as grey levels (0–255) where the colour is
achromatic, otherwise as hex. "Light" and "dark" are the two schemes.

---

## Part 1 — The current situation

### 1.1 Where a fill's colour comes from

Every colour in the theme is realized from three numbers: a lightness
(CIELAB L*), a hue and a chroma. Lightness is what the whole fill
system runs on; hue and chroma are held fixed per role and clipped
until the colour fits the screen.

**Ramps.** Each of the eight roles — Neutral, Primary, Secondary,
Tertiary, Error, Success, Warning, Info — owns a ramp of nine steps,
100 to 900. All eight ramps share one lightness curve per scheme:

| step | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|
| light L* | 97 | 92 | 85 | 74 | 63 | 51 | 39 | 28 | 6 |
| dark L* | 8 | 13 | 19 | 30 | 46 | 64 | 82 | 86 | 94 |

Steps 100–400 are the surface band, the part of the ramp that fills
are drawn from. Steps 700–900 are where text lives. The Neutral ramp
has chroma zero: every neutral is a pure grey. So every fill that is
not role-tinted is a grey, and the only thing that distinguishes one
neutral fill from another is its lightness.

**Pins.** A few colours are fixed rather than walked. The one that
matters for fills is the content pin, the fill of level 0. In dark it
is the neutral ramp's step 100, grey 24. In light it is not a ramp
step: it is placed one raise step (4.88 L*) below white, which lands
on grey 241. This is the "headroom" clause: the pin keeps exactly one
step of room under white so that a raise on the content can be
lighter than the content.

**Tints.** A role's tinted container is its ramp's step 300
lightness, at the role's hue, with chroma capped at 0.055. Neutral's
container has no chroma so it is simply grey 212 light, grey 46 dark.
Every container measures 1.31:1 against the content in both schemes.

### 1.2 The levels

Six levels are named. Each is derived from the content pin by a
lightness offset, not read from the ramp, so most of them are not ramp
steps at all.

| level | how it is placed | light | dark |
|---|---|---|---|
| backdrop | two chrome steps below the pin | grey 207 | grey 17 |
| chrome | one chrome step below the pin (4.88 L* light, 1.48 L* dark) | grey 227 | grey 21 |
| 0, the content | the pin | grey 241 | grey 24 |
| 1, raised | one raise step above the pin | white | grey 34 |
| 2, floating | part of the headroom above the pin, never below level 1 | white | grey 46 |
| 3, floating, top | the whole headroom above the pin | white | grey 71 |
| inverse | the other scheme's step 200 | grey 34 | grey 232 |

The dark column climbs in even steps. The light column collapses:
levels 1, 2 and 3 are all white, because the pin sits one step below
white and one step is all the room there is. Below the pin the light
scheme has plenty of room and uses it — chrome is 14 grey levels
darker than the content and the backdrop 20 more.

### 1.3 The raise walk

A raised surface is not read from the level table. It is walked: take
the lightness of the surface beneath, add one raise step (the distance
between neutral steps 100 and 200, about 4.9 L*), stop at the ceiling
— white in light, step 400 in dark — and realize at the content's hue
and chroma. Whatever a thing stands on, raised means one step lighter
than that.

When the step is not there, the walk still returns a fill, equal to
the surface beneath, and marks the raise as "seamed": the raise is
told by a hairline at its edge instead of by its fill. The threshold
is a contrast ratio of 1.09 between fill and surface (the
"raise floor"). The seam colour is solved for a 1.51:1 separation
against the surface, darker in light and lighter in dark.

On the default seed, walking up from the content:

| raise | light | dark |
|---|---|---|
| 1 | white, told by fill | grey 34, fill |
| 2 | white, **seamed** (seam grey 210) | grey 44, fill |
| 3 | white, seamed | grey 55, fill |
| 4 | white, seamed | grey 66, fill |
| 5 | white, seamed | grey 71, clamped, **seamed** (seam grey 99) |

So in light the system has one fill-told raise and then hairlines all
the way up. In dark it has four.

### 1.4 State fills

A state never adds an alpha layer over a fill. It moves the fill along
its ramp, toward the text end — darker in light, lighter in dark:

| mechanism | what moves | how far |
|---|---|---|
| ramp step walk (role, step, state) | a fill named by ramp step | hover one step, press/selected two |
| solid walk (role, state) | a pinned role fill such as Primary | its lightness one or two steps along the role's ramp |
| pinned walk (colour, state) | any given fill | same, along the neutral scale |
| level walk (level, state) | the level's fill | hover: one step, or however deep it takes to clear 1.25:1 against the level (the "state floor"); press one step more |

Selected, pressed and dragged are one and the same depth. Checked and
active are not token states; components choose their own fill for
them. Disabled changes no colour: it multiplies alpha by 0.38. Focused
changes no fill: it draws a ring.

On the default seed the level walk gives, for hover / press:

| level | light | dark |
|---|---|---|
| chrome | grey 204 / grey 174 | grey 41 / grey 59 |
| 0 | grey 216 / grey 189 | grey 43 / grey 64 |
| 1 | grey 229 / grey 208 | grey 51 / grey 78 |

Note the direction: in light a hovered thing on the content is
*darker* than the content, while a raised thing on the content is
*lighter*. Hover and raise pull opposite ways in light and the same
way in dark.

### 1.5 The highlight, the scrim, the inverse pair

- **Highlight.** The highlighter's own hue (yellow), chroma as high as
  the screen allows, at neutral step 300 lightness in light and 400 in
  dark: #e7d700 light, #4e4800 dark. On a given surface it walks
  deeper while the text still clears its floor, then back, taking the
  first step that clears 1.25:1 against the surface.
- **Scrim.** Not a token. The modal paints black at 50% alpha in both
  schemes, the one literal colour the library's lint allows.
- **Inverse.** The other scheme's step 200 and 900, used as a pair:
  grey 34 with light text in light, grey 232 with dark text in dark.

### 1.6 What "no fill" means

The token layer never returns a transparent colour. Every resolver
returns an opaque fill, and when nothing clears a floor it returns
the best-separating step rather than nothing. Transparency is a
component's decision: it paints the zero colour, or it paints nothing.
Two things are transparent by design in the token layer's terms — the
ghost button at rest and the scrollbar's track — and a great many
things are transparent because nobody paints them, listed below.

### 1.7 What each thing paints

The columns: what it paints at rest; what it leaves to the surface
beneath; how the fill changes with state; what edge it draws. "Level"
means the thing takes a level from its caller (default: the content)
and derives from that; "fixed" means it reads one level whatever it
stands on. No component, pattern or markdown block takes the colour of
the surface beneath as an input — a level is the only handle.

**Chrome**

| thing | fill at rest | transparent | with state | edge |
|---|---|---|---|---|
| shell, two-column and three-column | backdrop under the whole window; main slot at the content | sidebar and aside slots — the shell paints nothing under them | — | splitter |
| shell, stacked page | the content pin | — | — | — |
| navbar | chrome, fixed | slots | none | active entry: 2 dp Primary underline |
| sidebar | chrome, fixed | each row | selected row: Primary step 200 walked to selected — an absolute ramp step, not walked from the chrome; no hover, no press | — |
| pane | chrome, fixed, rounded, inset 1 px | 8 dp of backdrop around it | none | hairline solved off its fill |
| splitter | the seam colour, 1 dp | 6 dp hit band | grabbed: neutral step 500, 2 dp; hover: nothing | it is the seam |
| accordion | chrome, fixed | body slots | headers: no hover, press or open fill | 1 dp seam under each header |
| status bar (three-column foot) | chrome, fixed, 48 dp | — | — | none |
| toolbar, inspector | no pattern exists; the inspector is the aside slot, unfilled | | | |
| scrollbar | track nothing; thumb neutral ≥700 at alpha 100 | track | hover/drag: alpha 170; find marks in the highlight | — |

**Content and markdown**

| thing | fill at rest | transparent | with state | edge |
|---|---|---|---|---|
| markdown document | nothing — `ContentSurface` is recorded and never painted or read; the host paints the plane | whole page | arrival highlight on the followed heading, fading | — |
| headings, paragraphs, lists, images | nothing | all | — | — |
| code fence | one raise above the content, fixed (in light: white) | — | none | 1 dp rim at 3:1 |
| inline code chip | the same fill as the fence | — | — | same rim |
| table header band | neutral step 300, absolute | — | — | 1 dp seam grid |
| table body rows | nothing, no striping | all | — | seam grid |
| blockquote | nothing | body | — | Primary bar |
| horizontal rule | 1 dp seam | — | — | — |
| find match / current | highlight / highlight walked one hover step | — | — | — |
| task checkbox | unchecked nothing; checked Primary | interior | — | 1.5 px Primary stroke |
| paragraph (component) | nothing | all | link hover: text blended ~10% toward white, a literal | focus ring |
| scroll area, list | nothing | all | fade at the edge in the content colour when overflowing | — |

**Raised things**

| thing | fill at rest | transparent | with state | edge |
|---|---|---|---|---|
| card | one raise above its level | — | none | seam only when the raise came back seamed |
| group | nothing | interior | none | always a hairline at its level |
| table (pattern) | its level; header band one raise above; rows nothing | rows | current row: Primary step 300, absolute | 1 dp seam under header and each row, unconditional |
| tabs | panel at its level; strip one raise above | — | none; selected tab 2 dp Primary underline | strip foot seam when seamed |
| text field, search field | one raise above its level | — | disabled: alpha; focus: border becomes ring; no hover | 1 dp neutral border at 3:1 |
| picker, field variant | one raise above its level | — | as text field | 1 dp border |
| picker, toolbar variant | its level lifted 1.28 L* dark / 0.70 L* light, measured constants | — | hover/press pinned walk | 1 dp rim, omitted when it clears neither side |
| pricing, ordinary tier | nothing | interior | — | hairline at the content |
| pricing, recommended tier | one raise above the content, fixed | — | — | seam when seamed |
| hero, feature | nothing | all | — | — |
| hero, secondary button | one raise above the content, fixed | — | none | 1 dp outline, unconditional |
| testimonial | one raise above the content, fixed | around it | none | 1 dp outline, unconditional |

**Controls by emphasis**

| thing | fill at rest | transparent | with state | edge |
|---|---|---|---|---|
| button, Filled | Primary, solid walk | — | hover/press solid walk; disabled alpha | focus ring inside the fill |
| button, Tonal | Primary container walked to clear its level | — | pinned walk from that | ring |
| button, Ghost | nothing | whole body | hover/press: the level walk | ring |
| chip, unselected | *paints* its level's colour — same as the surface, so reads transparent | reads as surface | hover/press pinned walk, clamped for the label | 1 dp outline at 3:1 |
| chip, Filter selected | Secondary container walked to clear its level | — | walk from the container | none |
| checkbox, unchecked | one raise above its level, inside a 2 dp border | around the box | disabled fades the border only | border |
| checkbox, checked | Primary | around | disabled alpha | none |
| radio | as checkbox; selected: Primary dot, gap at one raise | around | — | edge |
| pagination | neutral step 300 per cell; current Primary step 300, absolute | chevrons | none | none |
| switch | no component exists | | | |

**Signals**

| thing | fill at rest | transparent | with state | edge |
|---|---|---|---|---|
| badge, worded or counted | the role's container walked to clear its level | — | dismiss cap: pinned walk | none |
| badge, glyph only | nothing | whole | — | — |
| alert | the role's container, fixed, full width | — | none | none |
| toast | inverse × alpha | — | alpha | leading edge in the role; shadow left to the notifications column |
| tooltip | inverse | — | none | none |
| icon, breadcrumb | nothing | all | — | — |

**Floating surfaces**

| thing | fill at rest | transparent | with state | edge / shadow |
|---|---|---|---|---|
| picker menu | level 3, fixed, painted per row | — | hovered row: Primary container, fixed; selected: Primary mark | 1 dp border; no shadow, no scrim |
| popover, with tail | level 3, fixed | anchor slot | none | 1 dp outline; no shadow |
| modal | scrim black 50%; surface level 2, fixed | — | — | 1 dp outline; no shadow |
| notifications | nothing; each toast as above | frame | fade | black key shadow under each toast, peak alpha 76 |

**The applications' own paints.** Each app paints planes of its own
on top of, or instead of, the patterns it uses.

| app | paints | over what a pattern already painted |
|---|---|---|
| launcher | backdrop at the content pin; app cells as groups | — |
| vaultview | backdrop over the window; content pin from the rail's edge; the note plane again at the content pin; the properties panel at the content pin inside a neutral 400 box; aside at chrome | the note plane and properties panel repaint the same colour the frame laid |
| vaultview rail | pane pattern; rows: active Primary step 300, selected chrome hover walk, find highlight | — |
| mindchat | backdrop over a backdrop layer at the content pin; transcript at the content; sidebar rows repaint chrome per row, selected Primary step 300 with a 3 dp Primary bar, hover chrome walk at alpha 128; bot rows at the content again; user rows Primary bubble; undo bar level 2 blended a third toward Primary with a shadow | the transcript fill is painted three deep; rest rows repaint the pane |
| feeds | backdrop at the content pin; sidebar chrome; list and detail at the content; selected feed Primary step 300 | panes over the shell's backdrop; two comments still call the panes "Surface, level 1" |
| themer | backdrop at the content pin; cards one raise above; hover/chosen Primary step 100 light, 300 dark; card edge neutral 400 | — |
| sitedocs | backdrop; title band one raise above; outline column chrome; selected Primary step 300 | — |
| todos | its own dialog with a scrim at alpha 153 | — |

### 1.8 Literal and absolute colours

Colours that are neither derived from a role nor walked from a
surface:

- the modal scrim, black 50%, and the todos scrim, black 60%;
- mindchat's hover alpha 128 and its undo bar blend of 0x33;
- the paragraph's link hover, about 10% white overlay;
- the text field's selection, Primary at alpha 0x40;
- the toolbar variant's lifts of 1.28 and 0.70 L*, measured constants;
- the launcher's HSL literals and marketing's 0.35 mix;
- the depth effect's black key shadow at alpha 76;
- code fence backgrounds from chroma palettes, passed through;
- absolute ramp steps used as fills: Primary step 300 for "selected"
  in vaultview, feeds, sitedocs, mindchat, the table's current row and
  pagination's current page; neutral step 300 for pagination cells,
  the markdown table header and two apps' seams; neutral 400 for two
  edges; neutral 500 for the grabbed splitter; Primary step 200 for the
  sidebar pattern's selected row.

### 1.9 What this adds up to

Stated, not judged:

1. In light, the content is grey 241, chrome grey 227, backdrop grey
   207. Nothing the user reads sits on white. White is reserved for
   the first raise and everything above it.
2. In light there is exactly one fill-told raise. A field on a card,
   a card on a modal, a menu on anything: all white on white, told by
   a hairline. In dark there are four fill-told raises.
3. The two schemes derive by one rule — nearer is lighter — and the
   rule is comfortable in dark and cramped in light. Every light
   value below the content is a consequence of holding the pin one
   step under white.
4. State walks go toward the text end; raises go toward the viewer.
   In light those are opposite directions, so a hovered thing darkens
   on a content that raised things lighten from.
5. Selection has no derivation. Six places reach for Primary step 300
   directly, one for step 200, one for step 100 in light.
6. The only handle a component offers its caller is a level. Nothing
   takes the fill of the surface beneath. A card inside a pane derives
   from "chrome" or "level 0" as told, not from the pane's actual fill.
7. Three of the four workbench apps repaint regions their patterns
   already filled, at the same colour, and mindchat's sidebar rows
   repaint the pane row by row.
8. Floating surfaces separate by a 1 dp outline alone; shadows exist
   in the depth effect and are used only under toasts.
9. Every tint is one number, a chroma cap of 0.055, so Primary and
   Secondary containers coincide on the default seed.

### 1.10 Words in this part that DOMAIN.md does not have

For renaming or ruling: pin, step (as a lightness distance), ramp
(only mentioned), band, headroom, ceiling, walk, raise floor, state
floor, container floor, hairline, outline, rim, border, ring (only
mentioned), plane, strip, bubble, tint (only mentioned), lightness,
chroma, key shadow.

---

## Part 2 — The future situation

To be written from the applications we want to look like.

---

## Part 3 — Rules from here to there

To be written after Part 2.
