# A standard shell and the controls a recorder needs — draft phase

Drafted 2026-09-06 from the earwitness session's list of what the
library lacks for a Mac three-column recorder and transcript
application (folder pane, session list with a record control at its
foot, transcript column). Held apart from PLAN.md until Rene rules;
appends after the ontology session's Phase BT lands. Phase letter
follows execution order at append time; BU is a placeholder.

The list is ranked by how much per-app hand-rolling each item
removes. Three applications in the workbench re-derived the shell,
the source list and the window render each on their own; those
app-local versions are the reference implementations named per task.
Every new word below that is not in DOMAIN.md is a word for Rene to
coin or approve before its code exists, so the first goal is the
Language's, not the code's. No tagging task appears: nothing is tagged
until the system is finished, and a consumer pins commits until then.

## Phase BU: The standard shell and the recorder's controls

### G-BU1: The Language names what the phase builds

#### BU1.1: New entries for the shell's parts and the missing controls

- [ ] DOMAIN gains, or rules against, entries for: the three-column
  shell (pane, list column, detail column, one band across all three,
  the window buttons on the pane strip's line); the source list (the
  pane's sectioned list of places with marks, labels, trailing counts
  or badges, a selection tint and a neutral cursor, a foot for the
  pane's own acts); a one-of-few inline choice control with no panel
  (the "All | Current folder" scope switch; chips are few-of-few, the
  picker is a menu, tabs carry a panel); a slider, with its seek-bar
  face; a progress signal, determinate and indeterminate; a level
  meter that holds a peak; a plain text-field face with no bezel at
  rest that grows with its content; a disclosure group, unless the
  accordion already stands alone as one section; an alert's trailing
  action; a circular button face; a paragraph's inline pill span.
- [ ] Exit: entries in DOMAIN, rows in AGENTS.md's retired table where
  a word retires; commit and push `.github`.

### G-BU2: Seeing and testing without a screen

These come first because every later task's exit leans on them.

#### BU2.1: Whole-window rendering as a library

- [ ] `components/golden` (or a new `mvu/render`) gains a
  whole-window renderer: a layer stack at a size, with a theme and a
  model, to an image, both schemes, no display. Reference:
  `workbench/vaultview/golden_test.go`'s window render and the
  launcher's `window_render_test.go`.
- [ ] Vaultview, mindchat and the launcher adopt it and their local
  renderers go; goldens byte-identical.
- [ ] Exit: green in the library and the three apps by name; commit
  and push.

#### BU2.2: An mvu test driver

- [ ] `mvu` gains a driver: feed Init and Update a message list, run
  the commands to quiescence, return the model history, so acceptance
  tests assert on the model with no window. Reference: the sim tests
  in `workbench/feeds` (`g52c_sim_test.go`, `g52d_sim_test.go`).
- [ ] Feeds' sim tests adopt it.
- [ ] Exit: green in `mvu`, `mvu/example` and feeds by name; commit
  and push.

### G-BU3: The three-column shell

#### BU3.1: The frame

- [ ] `patterns/shell` gains the three-column frame ruled in BU1.1:
  pane, list column, detail column; one band across all three at one
  height; the window buttons on the pane strip's line; the backdrop
  showing around the pane. The existing `ThreeColumn` is passed over
  because it pins a navbar band; say in the commit body whether it
  stays or goes. Reference: `workbench/vaultview/frame.go` and
  `workbench/mindchat/frame.go`.
- [ ] Exit: green in `patterns` and the gallery by name; a gallery
  specimen; fresh-eyes review in both schemes; commit and push.

#### BU3.2: The splitter and the widths

- [ ] The frame's seams are splitters: a full-height draggable seam
  between pane and list and between list and detail, an absolute list
  width, drag claims over the empty runs, widths remembered through
  `mvu.RememberFrame`. Builds on Phase BT's splitter in vaultview
  (G-BT3); when BT lands first this task generalises it, otherwise it
  lands first and BT adopts it.
- [ ] Exit: green in `patterns` and vaultview by name; commit and push.

#### BU3.3: Recall and Tab order

- [ ] The pane's recall toggle wired both ways (the pane's own control
  and the window's), Tab order across the three columns in reading
  order. Reference: vaultview's `frame.go` and `tree.go`.
- [ ] Vaultview and mindchat adopt the frame; their app-local frames
  go; goldens regenerate with the cause named.
- [ ] Exit: green in `patterns`, vaultview and mindchat by name;
  fresh-eyes review of both windows; commit and push.

#### BU3.4: The source list

- [ ] `patterns/sourcelist` (name per BU1.1): sections with headings,
  rows with a mark, a label and a trailing count or badge, selection
  tint from the primary tint step with a neutral cursor, keyboard
  traversal, a foot slot. `patterns/sidebar` is flat, icon-and-label,
  fixed width; say whether it stays. Reference: vaultview's tree rail.
- [ ] Exit: green in `patterns` and the gallery by name; specimen;
  fresh-eyes review; commit and push.

#### BU3.5: Shortcuts as a table

- [ ] `mvu/desktop` (or `components/keyed`) gains a shortcuts helper:
  a table of chord to message with the window-wide key area done
  once. Reference: `workbench/feeds/shortcut.go`; the mindchat lockup
  is the failure it prevents.
- [ ] Feeds and mindchat adopt it.
- [ ] Exit: green in the library and both apps by name; commit and
  push.

### G-BU4: The desktop's tenants

Each delivered as messages into the loop, the way the menu bar and
drops already are (`mvu/desktop/menu_darwin.go`, `drop_darwin.go`).
One task per tenant so each fits one run and its stub side is
written with it.

#### BU4.1: The status item

- [ ] A menu-bar item with its own menu, as messages.
- [ ] Exit: green in `mvu/desktop` and `mvu/example`; commit and push.

#### BU4.2: The window level and the panels

- [ ] A floating window level option; open, save and folder panels as
  commands answering with messages; reveal in Finder.
- [ ] Exit: as BU4.1.

#### BU4.3: Notifications and the hotkey

- [ ] User notifications with an action message on click; a global
  hotkey as a message.
- [ ] Exit: as BU4.1.

#### BU4.4: The application's life

- [ ] The terminate hook with a veto (quit as a message), reopen and
  did-become-active events, the About panel.
- [ ] Exit: as BU4.1.

### G-BU5: The controls the design needs

#### BU5.1: The search field at a tag

- [ ] `components/input`'s search field (BR4.2) gains a focus tag,
  Escape clears, and per-keystroke messages carrying the text.
- [ ] Exit: green in `components` and vaultview by name; commit and
  push.

#### BU5.2: One of few, inline

- [ ] The control BU1.1 names for a one-of-few inline choice with no
  panel, in `components`; a gallery specimen; the chip and picker docs
  say how it differs.
- [ ] Exit: green; specimen; fresh-eyes review; commit and push.

#### BU5.3: The slider and its seek-bar face

- [ ] A slider control with a seek-bar face for playback position.
- [ ] Exit: green; specimen; fresh-eyes review; commit and push.

#### BU5.4: The progress signal

- [ ] Determinate and indeterminate progress.
- [ ] Exit: green; specimen; commit and push.

#### BU5.5: The level meter

- [ ] A meter that self-schedules like the animated components and
  holds a peak. Reference: `effects/springbutton`'s scheduling.
- [ ] Exit: green; specimen; commit and push.

#### BU5.6: The plain text-field face

- [ ] No bezel at rest, multi-line, growing with content; an editable
  title in a header and a paragraph edited in place are its two uses.
- [ ] Exit: green; specimen; fresh-eyes review; commit and push.

#### BU5.7: The disclosure group

- [ ] A header row with a chevron over a collapsible body, or the
  ruling that the accordion already is one; vaultview's Properties
  panel is the app-local version and adopts it.
- [ ] Exit: green in `patterns` and vaultview by name; commit and push.

#### BU5.8: The alert's action

- [ ] A trailing action slot on the alert, per BU1.1's ruling (DOMAIN
  today says an alert holds words, never a control, so this is a
  Language change or a ruling against).
- [ ] Exit: green; goldens; commit and push.

#### BU5.9: The circular button face

- [ ] A circular face for the button so a record disc is a button
  with its pinned fill rather than a drawing.
- [ ] Exit: green; specimen; commit and push.

### G-BU6: List and text extras

#### BU6.1: Tail-follow

- [ ] `components/list` sticks to the end while at the end, releases
  when the reader scrolls up, and offers a jump-to-latest affordance.
  Reference: mindchat's transcript.
- [ ] Mindchat adopts it.
- [ ] Exit: green in `components` and mindchat by name; commit and push.

#### BU6.2: The two-line row

- [ ] A row recipe for `components/list`: leading mark, title, subtitle
  with trailing meta, a badge, selection and cursor. Reference: feeds'
  article rows.
- [ ] Exit: green; specimen; commit and push.

#### BU6.3: The inline pill span

- [ ] `components/paragraph` gains a clickable inline pill span, so a
  transcript segment is one flowing paragraph with its speaker label
  inside it; mentions and tags in chat are the second use.
- [ ] Exit: green in `components` and markdown by name; specimen;
  commit and push.

## Not planned

Waveforms, tables beyond what exists, the marketing patterns, any
audio component beyond the meter and the seek-bar face. Tagging: not
until the system is finished; consumers pin commits.
