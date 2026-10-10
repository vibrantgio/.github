# One shell pattern, read off three windows — exploration

## 1. Standing and sources

Drawn from all three sources' own standing notes, and from the git log of the three files.

This is pool material. Nothing in it is a dispatch, no task is cut from it, and no ruling in it is settled by it. It merges three documents that were written separately over five weeks and overlap heavily; the three sources stay where they are until the owner rules on this one.

**The three windows read.** vaultview and mindchat are the two windows in the library's own tree that drew their own frame; the recorder is the recorder application outside the org, which copied vaultview's frame and then read the three side by side. A pattern derived from two windows that agree is a pattern that breaks on the third, so all three are read, and where they disagree the disagreement is stated once and sent to the owner in section 12 rather than averaged.

**The words are the library's.** The strip across the content column's top is the TOOLBAR; the identifiers that still say otherwise (`PaneFrame.BandFill`, `pane.BandDp`, `desktop.BandLead`) are named here only as identifiers, and the prose never uses that word for the strip. The window's own fill under everything is `PaneFrame.Surface`. The row's name column is `sidebar.TitleInset`. Dialog is the pattern, and modal is the mode a dialog puts the window in, never a pattern. A switch is the on/off control alone: the control that recalls a pane is a borderless button with a symbol title, and a chooser between scopes is a segmented control. It is a symbol, never a `glyph`; a focus ring, never a `halo`; a pane, never a `panel`. The round the recorder is pinned to (`patterns v1.3.0`) still calls `PaneFrame.Surface` by its old name and `sidebar.TitleInset` by its old one; the pinned spellings are named below only where a reader of that source would otherwise not find the field.

**What the library ships today.**

| file | lines | what it holds |
|---|---|---|
| `patterns/shell/paneframe.go` | 182 | `PaneFrame` (the value), `Bounds`, `ContentX`, `Under`, `Layout`, `PaneWidthDp` |
| `patterns/pane/pane.go` | 464 | the geometry constants, `Buttons`, `Surface`/`RimColor`/`Shadow`, `Bounds`, `Layout`, `PaintShadow`, `FillTrailingCorners`, `EdgeSpan`, `SeamTop`, `Strip`, `DragSpacer`, `DragFill` |
| `patterns/sidebar/sidebar.go` | 1100 | of which the three windows use `ExpandedWidth`, `RowHeight`, `SelectionInset`/`SelectionRadius`, `SymbolBox`/`SymbolInset`/`TitleInset`/`CountInset`, `SectionHeight`, `PaintSelection`, `SelectionFill`, `SelectionLabel`, `RowTarget`, `PaintSymbol`, `PaintCount`, `PaintSection`, `SectionStyle`, `SectionForeground`, `SymbolForeground`, `CountForeground` |

`patterns/splitter` ships the hand-hold, and `mvu.RememberFrame` keeps the window's own frame. Nothing keeps the arrangement inside the window, and nothing lays out a toolbar.

**Provenance of the three merged documents.**

| source | what it is | written | later commits |
|---|---|---|---|
| `explorations/standard-shell-plan.md` | a phase draft, 242 lines: what the library lacks for a Mac three-column recorder and transcript application, ranked by how much per-app hand-rolling each item removes | 2026-09-06 | 2026-10-07, progress ruled the library's and the level meter the application's |
| `explorations/off-the-shelf-shells.md` | an exploration, 268 lines: on the ruling that a layout nobody uses leaves the library and that mindchat and vaultview become the shells an application starts from | 2026-09-06 | five appended notes — the third arrangement and the footer slots (2026-10-01), the ask for the application's life hooks (2026-10-01), the collapse and expand proposal (2026-10-02), the addendum measured on Voice Memos (2026-10-02), the second addendum on bounds (2026-10-02) |
| `explorations/shell-shared-parts.md` | a specification, 439 lines: fifteen shared parts with their three-window tables, sixteen rulings, and the duplication count | 2026-10-02 | 2026-10-02, a pass to clear the retired-words guard |

The draft is the recorder's list of what it lacks, written before it had a shell. The exploration is the library's reading of the two windows it already has. The specification is the part-by-part reading of all three, and it is the one the other two are now read through: it supplies what the exploration asks for and does not have, and it does not restart the exploration's arrangements, sequence or open questions.

## 2. The Language first: the words still to coin or rule against

Drawn from the draft's list of new entries and the exploration's list of words to coin, with every entry DOMAIN now carries removed to section 14.

Every word below that DOMAIN does not carry is a word for the owner to coin or rule against before the code that would use it exists. That is why this comes first: it is the Language's goal, not the code's.

All eleven are answered in the Language on the ontology session's recommendation (2026-10-10), each marked below with the entry that answers it.

1. **The arrangements' names.** Answered by the Language: Shell, which names the variants two-column and three-column.
2. **The segmented control.** Answered by the Language: Segmented control.
3. **The slider, with its seek-bar face.** Answered by the Language: Slider.
4. **The plain text-field face.** Answered by the Language: Text field, the borderless face.
5. **An alert's trailing action.** Answered by the Language: Alert stands as written, so an action stands beside the alert, no slot.
6. **The circular button face.** Answered by the Language: Button, the round face.
7. **The inline pill span.** Answered by the Language: Link.
8. **The foot.** Answered by the Language: Footer.
9. **The slide.** Answered by the Language: Pane, which collapses and expands.
10. **The recall pair's own word.** Answered by the Language: Pane, the one Toggle Sidebar button.
11. **What the name inside a transcript paragraph is called.** Answered by the Language: Link.

## 3. What exists and who uses it

Drawn from the exploration's inventory table, unchanged but for the words.

| In the library | Consumers | Verdict proposed |
|---|---|---|
| shell, sidebar-header-main layout | feeds | migrates to a shipped shell, then leaves |
| shell, split-pane layout | feeds, nested in the above | its drag is the splitter now; the layout leaves with the shell |
| shell, three-column layout | none | leaves the library |
| pane | mindchat, vaultview | stays: it is the shells' leading part |
| sidebar, navbar | gallery specimens only | navbar stays for the marketing shell; sidebar's fate is the source list's ruling |

Three applications each drew their own window: vaultview (pane, note column, aside, one toolbar, a status bar), mindchat (pane, content column with a toolbar, transcript and input bar), feeds (the shell's sidebar-header-main with a split pane inside). The recorder is the fourth and copied vaultview's. Vaultview's and mindchat's frames share their vocabulary already: the pane as an inset object with the backdrop showing around it, the recall convention (a control that travels with the pane cannot be the one that recalls it), the window buttons measured from the glass, the toolbar as a title row. That shared frame is the shell to ship.

## 4. The arrangements

Drawn from the exploration's two arrangements, the recorder's third, and the specification's reading of the toolbar.

One pattern with named variants, not separate shells:

1. **Two-column.** The pane down the leading edge, a content column beside it with one toolbar across its top. Mindchat's window; vaultview with its aside away is the same window.
2. **Two-column, with the inspector.** The same, plus a trailing aside on a splitter and a status bar under the column. Vaultview's window. The aside is a slot that may be empty, and an empty aside takes no width.
3. **Three-column.** The pane down the leading edge at 220 dp with the recall control in both halves, then a list column of absolute width on a splitter — default 300 dp, clamped 220 to 480, keeping its width when the window resizes — then the content column absorbing the rest. The recorder's window. The platform's windows of this shape are Mail, Notes, and Voice Memos with its folder sidebar.

All three carry: the pane on a splitter, the widths and the window frame remembered, the recall control in both halves, Tab order across the columns in reading order, and a toolbar holding the recall control, a title and the trailing acts. A footer slot under each column is optional and takes no height when empty; so is the pane's own footer — a hairline the pane's width and one row under it.

**The toolbar's span is a disagreement, and it is the only one about the arrangements themselves.** The three sources read it three ways, and the reading is not averaged:

- **One toolbar across all three columns, at one height**, with the window buttons on the pane strip's line. The draft, 2026-09-06.
- **One toolbar across the list and content columns, one share per column.** The recorder, 2026-10-01: the list's share shows a title (the folder's name) and, while the pane is away, the recall control and the pane's primary act as bordered toolbar buttons; the content's share holds the trailing acts with a search field at the trailing end.
- **One toolbar across the content column only.** The exploration, 2026-09-06, and the specification, 2026-10-02: the strip is what the content column carries across its top, and the pane carries its own strip with the window buttons and its own marks in it.

The draft's reading is superseded (section 14); the other two are live and the question is ruling 2.

Each window keeps its own answer to whether the pane stands beside every view or only some: vaultview has a screen with no frame at all, mindchat's pane always stands, the recorder's stands on one of four views. All three are the same shape once stated as a predicate the window supplies, and the frame already takes the answer as a width.

The empty-content placeholder ("No session selected") is the application's content, not the shell's.

## 5. Seeing without a screen

Drawn from the draft's second goal and the exploration's sequence.

These come first, because every later task's exit leans on them and because every review of these windows this round was rendered without a screen through vaultview's local renderer.

**The whole-window renderer as a library.** A layer stack at a size, with a theme and a model, to an image, in both schemes, with no display. The reference implementations are `workbench/vaultview/golden_test.go`'s window render and the launcher's `window_render_test.go`. Vaultview, mindchat and the launcher adopt it and their local renderers go, goldens byte-identical. Where it lives is open: `components/golden`, or a new `mvu/render`.

**An mvu test driver.** Feed Init and Update a message list, run the commands to quiescence, return the model history, so an acceptance test asserts on the model with no window. The reference implementations are the sim tests in `workbench/feeds` (`g52c_sim_test.go`, `g52d_sim_test.go`), and feeds adopts it. It can follow at any time; the renderer cannot.

## 6. The shared parts, part by part

Drawn from the specification, part for part; part 12 is rewritten to the later bounds reading and part 13 is brought current against the shipped splitter.

"Shell geometry" below means the share of each file that composes the window's chrome arrangement, as against the share that is the window's own content. Line counts include the prose that documents them, because in this codebase the prose is the larger half of a shell part and the extraction deletes it with the code.

### 6.1 The frame: Bounds, ContentX, Under, Layout

The window composition a leading pane makes — the window's own fill under everything, the pane one margin inside the leading, top and bottom edges, the content column flush against its trailing side, the toolbar across that column's top and the main content under it.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `frameState.layout`, frame.go:512-666 | `windowFrame.layout`, frame.go:128-212 | `appShell`, shellchrome.go:185-290 |
| measures | `frameGeometry`, frame.go:484-511, over `frameGeom`, frame.go:465-483 | `frame.Bounds` + `shell.ContentX` inline, frame.go:149-150 | `frame.Bounds` + `shell.ContentX` inline, shellchrome.go:183-184 |
| spends | `PaneFrame.Under`, frame.go:556-560 | `PaneFrame.Under`, frame.go:151 | `PaneFrame.Layout`, shellchrome.go:251 |
| lines | 155 + 28 + 19 = 202 | 85 | 106 |

**In the library.** All of it, in two halves. `Bounds` and `ContentX` answer the arrangement without laying anything out; `Under` paints the window's fill, the content column's fill, the two corners the pane rounds away from on its flush side, and the pane with its column in it; `Layout` is `Under` plus the three slots plus `pane.PaintShadow` last.

**Re-derived.** vaultview and mindchat spend `Under` and compose their own columns above it, because each has an arrangement `Layout` does not express — vaultview a trailing aside, a footer under the content column, and the note column laid out BEFORE the toolbar over it and replayed after (frame.go:576-585, 609-613: the toolbar carries the find and the find's count is the document's answer); mindchat the transcript laid out before the row over it (frame.go:159-182: a bordered control's cast shadow reaches past the row's footer and a transcript drawn over it would cut it off with a ruled line) and the picker's surface last of all. The recorder spends `Layout` and pays for it: it re-offsets every rectangle its three slots measured back into window coordinates by hand afterwards (shellchrome.go:253-272, 20 lines), because `Layout` tells the caller nothing about where it put them.

**Proposed, and what it deletes.** `Layout` gains an op-order it does not have, named concretely: `PaneFrame.MainFirst bool`, the main slot recorded and replayed under the toolbar's ops rather than drawn after them (two of three need it, both for the same reason); `PaneFrame.Over layout.Widget`, one slot laid out last after `PaintShadow` at the content column's own box (mindchat's picker and the recorder's microphone drop-down are the same thing); and `PaneFrame.Layout` returning a `PaneLayout` value — `Pane`, `ContentX`, `Strip`, `Toolbar`, `Main`, `Footer` as rectangles in WINDOW coordinates, which is `frameGeom` and the geometry half of `chromeObs` generalised and what both windows' probes assert against. Deletes: vaultview `frameGeom` and `frameGeometry` (47) outright and ~60 of `layout`'s 155; mindchat ~25 of 85; the recorder the hand re-offsetting (20) and ~35 of `appShell`'s 106.

### 6.2 The frame's fills, and the slot nobody fills

Which fill stands where: the window's own, the content column's, and the one behind the pane's two flush-side corners over the toolbar's rows.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| `Surface` | `tok.col.WindowBackground`, frame.go:557 | `t.col.WindowBackground`, frame.go:145 | `tok.color.WindowBackground` (the pinned name on the pin), shellchrome.go:231 |
| `ContentFill` | `tok.col.TextBackground`, frame.go:558 | `t.palette.Transcript`, frame.go:146 | `tok.color.ControlBackground`, shellchrome.go:232 |
| `BandFill` | not passed | not passed | not passed |
| the toolbar's own fill | none; `bandSurface` reports the region under it, frame.go:256-263 | none | none; `chromeBand` paints nothing, headerstrip.go:449-452 |
| what chrome foreground flattens onto | `chromeSurface(tok.col)` per site, main.go:158 | `t.palette` fields per site | six `on*` helpers, palette.go:45-82 |

**In the library.** The three fields, and `FillTrailingCorners` behind them.

**Re-derived.** The rule "a toolbar carries no fill of its own; its foreground flattens onto the region beneath it" is stated three times in three vocabularies — a function, a palette field, one of six helpers. `BandFill` is passed by none of the three. It exists for a window whose toolbar paints a fill across the content column, and no window in the family is one.

**Proposed, and what it deletes.** The `PaneLayout` value carries `ToolbarFill color.NRGBA` — what a control standing in the toolbar flattens onto, which is `ContentFill` where `BandFill` is zero and `BandFill` where it is not: one reading handed to the caller instead of three derivations. `BandFill` itself goes to the owner (ruling 3). Deletes: vaultview `bandSurface` (8); mindchat nothing in lines, one palette field's reason; the recorder `onContent` (8) and the per-site judgement of which of the six to call in the toolbar.

### 6.3 The pane's strip

The strip across the pane's top that the window's three control buttons stand inside: their run skipped at the leading end, a stretch that moves the window across the middle, and the pane's own marks at the trailing corner.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| reserved by | `treeView.layout`'s vertical Flex, tree.go:384-454 | `SidebarPane`'s vertical Flex, view.go:927-970 | `folderPane`'s vertical Flex, folderpane.go:623-719 |
| drawn by | `treeView.topStrip`, tree.go:455-471 | `SidebarStrip`, view.go:971-1000 | `paneStrip`, folderpane.go:720-759 |
| lead | `treeView.buttonEdge`, tree.go:285-295 | `stripLead(windowButtonsEnd())`, frame.go:294-301 | `desktop.BandLead(pane.ButtonGapDp, bandInset)` inline, folderpane.go:749 |
| marks | one: the recall control, in the corner | two: recall, `MarkGapDp` drag spacer, new chat in the corner | two: new folder, `MarkGapDp` drag spacer, recall in the corner |
| lines | 71 + 17 + 11 = 99 | 44 + 30 + 12 = 86 | 97 + 40 = 137 |

**In the library.** `pane.Strip(gtx, lead, controls...)` — it skips the lead less the margin, fills the middle with `DragFill`, lays the controls out in reading order and closes with a `DragSpacer(MarginDp)`. `pane.StripDp` (36 dp ≈ 8.3 mm), `pane.MarkGapDp` (18 dp ≈ 4.1 mm), `pane.ButtonGapDp` (17 dp ≈ 3.9 mm).

**Re-derived.** Three things, identically. The reservation: every window reserves `min(gtx.Dp(pane.StripDp), size.Y)` as the first Rigid of the pane's vertical Flex and draws the strip AFTERWARDS at `layout.Exact(size.X, stripH)`, and every window writes the same paragraph saying why — it is a statement about the keyboard, not about paint (tree.go:440-453, view.go:935-940/966-968, folderpane.go:628-631/712-714). The lead: three spellings of `desktop.BandLead`/`BandLeadFrom` over `pane.ButtonGapDp`. The drag spacer between two marks: `desktop.DragRun(gtx, gtx.Dp(pane.MarkGapDp))` written out at the call site in both two-mark windows (view.go:994-996, folderpane.go:753-755) although `pane.DragSpacer(pane.MarkGapDp)` is exactly that.

**Proposed, and what it deletes.** `pane.Column(gtx, c, bounds, pane.ColumnSlots{Strip, Head, Rows, Footer})` — one helper that reserves the strip, lays the optional slots out in reading order, draws the strip last, and reports what it arranged. The marks go in as `pane.Marks(controls ...layout.Widget)`, which interleaves `MarkGapDp` spacers itself. The lead is not a parameter: `pane.Strip` already knows `ButtonGapDp` and the only thing a caller supplies is the no-buttons fallback inset, so it becomes `pane.StripLead(fallback unit.Dp)`. Deletes: vaultview `topStrip` (17), `buttonEdge` (11), ~20 of `treeView.layout`'s 71; mindchat `SidebarStrip` (30), `windowButtonsEnd` (12), ~18 of `SidebarPane`'s 44; the recorder ~18 of `paneStrip`'s 40, ~14 of `folderPane`'s 97, and the strip's probe arithmetic (folderpane.go:731-744, 14 lines), replaced by the `PaneLayout` value's `Marks`.

### 6.4 The two drawings of a chrome mark: bare on the pane, bordered in the toolbar

One rule with two drawings — a mark standing on the PANE is bare (no capsule, no fill, no rim); a mark standing in the TOOLBAR is the platform's bordered toolbar control — and which one a mark takes is a property of what it stands on, not of the control it belongs to.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| bare | `paneMark`, frame.go:1182-1206 | `paneMark`, frame.go:416-435, through `paneToggle` 436-439 and `paneNewChat` 440-454 | `paneMark`, folderpane.go:768-797 |
| bordered | `chromeControl`, frame.go:1207-1229, through `railToggleControl` 1151-1181 | `controlBox`, frame.go:455-481, through `sidebarToggle` 386-394 and `newChatMark` 395-415 | `chromeControl`, headerstrip.go:685-711 |
| mark box | `markLargeDp` = 24, main.go:446-450 | `paneMarkDp` = 24, frame.go:103-106 | `markLargeDp` = 24, folderpane.go:760-767 |
| bare foreground | `tok.col.ToolbarLabel` | `t.col.ToolbarLabel` | `tok.color.ToolbarLabel` |
| records state | no | yes: `RenderState.Checked` on the bordered half, frame.go:455-481 | no |
| lines | 25 + 23 + 31 = 79 | 20 + 4 + 15 + 27 + 9 + 21 = 96 | 30 + 27 = 57 |

**In the library.** The RULE, in `patterns/pane`'s package doc (pane.go:64-70), with the measurement off `voicememos-multi-folder-2026-09-18.png`. Nothing draws it. `components/button.BorderedFace` and `BorderedShadow` draw the bordered half's face; `components/icons.Mark` draws the figure.

**Re-derived.** Both drawings, three times, body for body. The bare one is the same twelve lines everywhere: the 24 dp box, `icons.Mark(name)`, `ToolbarLabel`, `pointershape.OverSize`, the three semantic ops, inside the caller's `Clickable`. The bordered one is the same twenty: `button.RenderState{Variant: Chrome, Hovered, Pressed, Focused}`, `BorderedFace`, `BorderedShadow` around the `Clickable` (never inside it — all three state the reason in the same words), the three semantic ops. 24 dp ≈ 5.5 mm is stated three times under three names.

**Proposed, and what it deletes.** Two functions in `patterns/pane` and one constant: `pane.MarkDp` (24 dp), the box both drawings centre a figure in; `pane.Mark(gtx, c, click, mark icons.Painter, title string) layout.Dimensions`, the bare drawing; and `pane.ToolbarControl(gtx, c, rad, den, click, mark icons.Painter, title string, checked bool) layout.Dimensions`, the bordered drawing, with `checked` for mindchat's recorded state. Both take an `icons.Painter` rather than an `icons.Name`, which is what the recorder needs: two of its three pane symbols come from the Material set because `components/icons` has no waveform and no trash can, and it adapts them through its own `iconPainter` (actionbutton.go); a painter-shaped seam removes that adapter from the caller. Deletes: vaultview 79, mindchat 96, the recorder 57 — 232 lines of three identical pairs.

### 6.5 The toolbar across the content column: its depth and its gutters

The strip the content column carries across its top, on the window buttons' line, holding what acts on the document.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `layoutToolbar`, frame.go:867-983 | `chromeRow`, frame.go:213-253 | `chromeBand`, headerstrip.go:433-684 |
| depth | `toolbarHeight()` = `pane.BandDp`, frame.go:244-255 | `ChromeRowHeight` = `2 * windowButtonRun.Center`, theme.go:324-338 | `bandDepth` = `unit.Dp(pane.BandDp)`, headerstrip.go:133-146 |
| leading gutter, pane standing | `noteInsetDp` = 24 dp ≈ 5.5 mm, note.go:61 | `chromeInsetDp` = 12 dp ≈ 2.8 mm, frame.go:79-83 | `bandInset` = 16 dp ≈ 3.7 mm, headerstrip.go:147-149 |
| trailing gutter | `bandTrailingDp` = 8 dp ≈ 1.8 mm | `chromeInsetDp` = 12 dp | `bandInset` = 16 dp |
| gap, two bordered controls | `bandGapDp` = 16 dp ≈ 3.7 mm | `controlGapDp` = 14 dp ≈ 3.2 mm | `bandControlGap` = 8 dp ≈ 1.8 mm |
| gap, bare title to control | `bandNameGapDp` = 14 dp ≈ 3.2 mm | `chromeGapDp` = 12 dp | `bandNameGap` = 16 dp |
| composition | Flex Horizontal, Alignment Middle, Rigid/Flexed(1)/Rigid | the same | the same |
| lines | 117 | 41 | 252 |

**In the library.** `pane.BandDp` (52 dp ≈ 12.0 mm) and the arithmetic behind it (`2*ButtonInsetDp + desktop.WindowButtonDiameter`), and `pane.SeamTop`, the row a line between two flush regions starts on, under the toolbar. The toolbar itself: nothing.

**Re-derived.** The depth, three ways, to the same 52: one names `pane.BandDp`, one names it through a local alias, one re-does the arithmetic from `pane.Buttons.Center`. The composition — a horizontal Flex, Middle alignment, a leading cluster of Rigids, one `Flexed(1)` draggable middle, a trailing cluster of Rigids, both gutters as Rigid children rather than an Inset round the Flex — is written out three times. The four gutters and gaps are stated with six different numbers under nine different names, every one carrying its own measurement prose (vaultview's const block spends ~85 of its 108 lines on them).

**Proposed, and what it deletes.** `shell.Toolbar` as a value spent into `PaneFrame.Toolbar`, not a layout call: `shell.Toolbar{Lead []layout.Widget, Trail []layout.Widget, Gutter shell.ToolbarGutter}`, laying the two clusters out with the measured gaps between them, the draggable middle between the clusters, and the gutters as Rigid children. `shell.ToolbarMetrics` names the four measurements once, as the platform's readings with the captures cited, and a window states a deviation rather than a value. `shell.ToolbarDepth` is `pane.BandDp` and nothing else. Deletes: vaultview `toolbarHeight` (12), ~45 of `layoutToolbar`'s 117, ~60 of the const block's gutter prose; mindchat `ChromeRowHeight` (15) and ~20 of `chromeRow`'s 41; the recorder ~30 of its const block and ~70 of `chromeBand`'s 252 — the Flex, the two gutters, the drag middle, and the trailing group's back-to-front placement arithmetic (headerstrip.go:638-663), which exists only because the window measures where Flex put its own children.

### 6.6 The toolbar's leading rule

Where the toolbar's own content may start: its gutter in from the content column while the pane stands, and past the window control buttons' run once the pane is away — a measurement in exactly one state.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `layout` chooses, frame.go:600-607; `toolbarLeading()`, frame.go:1007-1019; `frameState.toolbarLeading`, frame.go:344-352 | `chromeLead`, frame.go:280-293; `stripLead`, frame.go:294-301 | inline in `chromeBand`, headerstrip.go:465-487 |
| rule | `lead = 0` standing (the Flex then spends `noteInsetDp`); `desktop.BandLead(pane.ButtonGapDp, frameEdgeDp)` away | `chromeInsetDp` standing; `desktop.BandLeadFrom(buttonsEnd, pane.ButtonGapDp, chromeInsetDp)` away | `max(bandInset, BandLead(ButtonGapDp, bandInset) − ContentX)`, measured in WINDOW columns, both states and every state between |
| static-render seam | `frameState.leading func() unit.Dp`, frame.go:325-334 | `var windowButtonsEnd = desktop.LeadingInset`, view.go:1001-1012 | none: the probe reads the real measurement |
| lines | 13 + 9 + 8 = 30 | 14 + 8 + 12 = 34 | 23 |

**In the library.** `desktop.BandLead(gap, fallback)` and `desktop.BandLeadFrom(buttonsEnd, gap, fallback)`; `pane.ButtonGapDp` as the air a toolbar owes the buttons.

**Re-derived.** The choice between the two rules, and the fact that the Toggle Sidebar button must lead from one window column whether it stands bare on the pane or bordered in the toolbar, so the control does not move under the pointer — stated in all three files in nearly the same sentence. Two of the three read the rule as a FLAG at either end, which is correct only while the pane arrives and leaves in one frame; the recorder had to correct it to the larger of the two measured in window columns when its collapse and expand motion landed, because read as a flag the toolbar's leading edge steps about 80 dp ≈ 18.4 mm at the instant the pane reaches zero. Two of three also carry a pinning seam so a stored render does not depend on a live window's measurement, in two different shapes (a function field on the frame; a package-level variable).

**Proposed, and what it deletes.** One function, and it is the corrected one: `shell.ToolbarLead(gtx, bounds image.Rectangle, fallback unit.Dp) unit.Dp` — the larger of the toolbar's own gutter and the inset past the buttons' run, both expressed as columns of the window, which is the same answer whether the pane stands collapsed or expanded, and passes between them without a step. It ships with the pane's collapse and expand motion (part 6.12) because that is when the flag reading breaks, and it ships even for a window whose pane does not collapse and expand because a flag that happens to be correct is still the wrong statement. The pinning seam becomes `desktop.PinLeadingInset(unit.Dp)` in `mvu/desktop`, one shape for both windows' needs. Deletes: vaultview 30 and the `leading` field off `frameState`; mindchat 34; the recorder 23.

### 6.7 The recall convention and its halves

A control that travels with the pane cannot be the one that recalls it: the pane's own controls ride its strip, and the control that brings the pane back stands in the toolbar — two halves of one control rather than duplicates of one, wearing one figure at one size on one line.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| halves | one pair: hide / show | two pairs: the pane's recall, and new chat (the primary act, which survives the pane going) | two pairs: the pane's recall, and new folder |
| pane half | `treeView.hideControl`, tree.go:472-487 | `paneToggle`/`paneNewChat`, frame.go:436-454, spent by `SidebarStrip` | `paneMark` calls in `paneStrip`, folderpane.go:750-757 |
| toolbar half | `layoutRailToggle`, frame.go:1138-1150 | `toggleControl`/`newChatControl`, frame.go:348-385 | the `bandCarriesPaneControls` branch of `chromeBand`, headerstrip.go:514-533 |
| when the toolbar half stands | `m.SidebarHidden` | `m.SidebarHidden` | `bandCarriesPaneControls(view, m)`, headerstrip.go:282-296 |
| gesture source | TWO `Clickable`s per pair (`frameState.toggleClick`, `treeView.hideClick`) | TWO per pair, deliberately: "a control and its recalling half are two clickables, not one shared one", frame.go:114-120 | ONE per pair: `hw.pane.toggle` and `hw.pane.create`, drawn bare in the strip and bordered in the toolbar, drained once by `paneClicks`, folderpane.go:478-521 |
| figure | `icons.Sidebar`, both halves | `icons.Sidebar` and `icons.Plus`, both halves | `icons.Sidebar` and `icons.Plus`, both halves |
| lines | 16 + 13 = 29 | 19 + 38 = 57 | 8 + 20 = 28 |

**In the library.** The convention, as prose, in `patterns/pane`'s package doc (pane.go:72-79). No code.

**Re-derived.** Which half stands where, per pair, per state; that both halves wear one figure; and the message each dispatches. Two of the three carry two `Clickable`s per pair and one carries one — and only one of the two halves is ever on screen at a time, so the two-`Clickable` arrangement is a second gesture source for one affordance with nothing gained. The recorder's is the DRY reading and the one that matches the project's loop discipline: one gesture source, one `MessageOp` through the one update.

**Proposed, and what it deletes.** A value the window holds, not a widget — `{Click *widget.Clickable, Mark icons.Painter, PaneTitle, ToolbarTitle string, Message any, Checked bool}` with a slice of them carried on `PaneFrame`. The frame draws them bare at the pane's trailing corner while the pane stands and bordered at the toolbar's leading end while it is away, in the declared order, and it is the frame — not each window — that knows which state puts them where. One `Clickable` per pair is the type's shape, which settles ruling 29 by construction if the owner rules that way. The type takes the name the Language gives it: the Toggle Sidebar button (section 2, item 10). Deletes: vaultview 29, mindchat 57, the recorder 28 — and, in each, the branch in the toolbar's composition that decides whether the halves stand there at all.

### 6.8 The window's drag over the chrome's empty runs

Under the full-size-content treatment the native title bar hands over no window drag, so the toolbar and the pane's strip claim it back over the parts of themselves that hold no control — and only over those, since a move action swallows the press before any control beneath it sees one.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| fixed gap | `dragSpacer`, frame.go:1020-1030 | `dragSpacer`, frame.go:482-489 | inline closure per spacer, headerstrip.go:503-509 |
| flexible middle | `dragFill`, frame.go:1031-1036 | `dragFill`, frame.go:490-492 | inline closure, headerstrip.go:593-597 |
| strip's | `pane.Strip` supplies both | `pane.Strip` supplies both; the mark gap written out, view.go:994-996 | `pane.Strip` supplies both; the mark gap written out, folderpane.go:753-755 |
| lines | 17 | 11 | ~14 over four call sites |

**In the library.** `pane.DragSpacer(w unit.Dp)` and `pane.DragFill` — pane.go:447-464, byte for byte what all three windows wrote for themselves, with `desktop.DragRun(gtx, px)` under both.

**Re-derived.** Both of them, in all three windows, from a package every one of them already imports. This is the clearest single duplication in the family: two exported functions, three private copies, zero behavioural difference.

**Proposed, and what it deletes.** No new shape is needed; `shell.Toolbar` (part 6.5) spends `pane.DragSpacer`/`pane.DragFill` internally so no window names them either. Deletes: vaultview 17, mindchat 11, the recorder ~14.

### 6.9 The pane's column: the row, the pill, the symbol, the count, the section

The column standing inside the pane: rows at the platform's sidebar pitch with the symbol, the name and the trailing column each where the platform draws it, the platform's pill under the selected row, and a section heading where the collection divides.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| row | `treeView.drawRow`, tree.go:675-769, in `rows`' `LayoutSelectable` callback, tree.go:488-579 | `ChatRow`, view.go:1130-1281, in `railState.layout`, view.go:878-920 | `folderPaneRow`, folderpane.go:859-937, in `folderPane`'s list callback, folderpane.go:646-679 |
| pitch | `sidebar.RowHeight` | `sidebar.RowHeight` | `sidebar.RowHeight` (32 dp ≈ 7.4 mm) |
| pill | `sidebar.PaintSelection` + `SelectionFill` + `SelectionLabel` | `sidebar.PaintSelection` | `sidebar.PaintSelection` + `SelectionFill` + `SelectionLabel` |
| emphasis | the rail's own focus tag decides, tree.go:528 | the rail's own focus tag decides, view.go:899 | always emphasized: the pane is on no focus ring, folderpane.go:873-881 |
| symbol | `sidebar.PaintSymbol` + `SymbolForeground` | hand-drawn, `drawChatSymbol`, view.go:1299 | `sidebar.PaintSymbol` + `SymbolForeground`, through `paneRowMark`, folderpane.go:798-820 |
| name column | `sidebar.TitleInset` + the tree's own indent | `sidebar.TitleInset` via an `Inset` | `sidebar.TitleInset` (the pinned name on the pin) |
| name role | `tok.typ.BodyMedium` | the palette's own | `tok.typ.LabelLarge` — the role the pattern sets a row's name in and measures the count against |
| count | none | none | `sidebar.PaintCount` + `CountForeground` |
| section | none (the run is deliberately unheaded, tree.go:80-82) | none ("a list with exactly one section does not announce itself", view.go:931-933) | one: `paneSectionBlock` over `sidebar.PaintSection`, folderpane.go:833-858 |
| target | `sidebar.RowTarget` + a `gesture.Click` per row | `sidebar.RowTarget` + a `gesture.Click` per row | a `widget.Clickable` per row |
| row's own extras | disclosure, indent, the find's highlight (`drawFound`, 42) | rename and delete marks, the stream dot | none |
| lines | 95 + ~45 of 92 = 140 | 152 + 43 = 195 | 79 + 14 + 12 + 12 + ~35 of 97 = 152 |

**In the library.** Every measurement and every painter, and all three windows use them — this is the part the library has already extracted furthest. What it does not have is the ROW: the order the painters are called in, the flattening of each foreground onto the fill the row actually lands on, the count owning its column so the name truncates against it, and the heading laid out OUTSIDE the row's click target.

**Re-derived.** That order, three times, with three different answers to the same questions: which typography role a row's name takes (two windows disagree with the pattern's own), whether the symbol comes from the pattern's painter or from the window's own drawing, and whether the row's target is a `gesture.Click` (so the whole rail is one focus stop) or a `widget.Clickable` per row (so the rows are not on the ring at all).

**Proposed, and what it deletes.** `sidebar.Row` as a recipe, not a `layout.Widget`: `sidebar.Row{Symbol icons.Painter, Label string, Count string, Selected, Unemphasized bool, Fill color.NRGBA}` with `sidebar.PaintRow(gtx, shaper, c, typ, row) sidebar.RowGeom`. It calls the painters in the order the platform draws them, flattens every foreground onto the right fill, lets the count own its column, and returns the geometry the probes assert (the row's box, the symbol's box, the name's first column, the count's column, the pill and its radius). `sidebar.PaintSectionBlock(gtx, shaper, c, typ, heading)` wraps the `SectionHeight` block round `PaintSection` so no window states the block. The pattern keeps the extras OUT: vaultview's disclosure and indent, its find highlight, mindchat's two row marks and its stream dot are each a `layout.Widget` the recipe takes as a leading or trailing slot (`sidebar.Row.Before`, `sidebar.Row.After`), not a case in the pattern. Deletes: vaultview ~55 of `drawRow`'s 95 (the disclosure, the indent and `drawFound` stay); mindchat ~70 of `ChatRow`'s 152 (the two marks and the dot stay); the recorder `folderPaneRow` to ~20 of 79, plus `paneRowText` (12) and `paneSectionBlock` (14) outright.

### 6.10 The pane's footer and the column's footer

Two footer slots, optional, taking no height when empty: one inside the pane under its rows, one under the content column.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| pane's footer | none; the vault's acts moved to the toolbar | `SidebarFooter`, view.go:1013-1057: a hairline the pane's width, then a `FooterRowHeight` row (46 dp ≈ 10.6 mm) with the gear and "Settings" | the new-folder flow's name row and the refusal line, `folderPane`'s trailing children, folderpane.go:684-706, drawn only while the flow is open |
| column's footer | `layoutStatusBar`, status.go:129, at `statusBarHeight(tok)`, status.go:81-83 (one `LabelMedium` line box plus `2*sp.S1`) | none | `shellFooter`, shellchrome.go:325-364, at `shellFooterHeight` = 32 dp ≈ 7.4 mm |
| spent at | `op.Offset(contentX, footTop)`, `Exact(size.X−contentX, size.Y−footTop)`, frame.go:617-625 | — | the last Rigid of `shellMain`'s vertical Flex over the content column, shellchrome.go:299-312 |
| lines | ~10 of `layout` + 3 | 45 | 40 + ~25 of `folderPane` |

**In the library.** Nothing for either. `pane.SeamTop` knows where a flush region's seam starts, which is the toolbar's lower edge, and that is the only neighbouring fact the library has.

**Re-derived.** The geometry of a footer under the content column, twice, identically: offset by where the column begins and by the column's height less the footer's, at exactly the column's width — never the window's, because the pane runs past it to the window's bottom edge. The two windows disagree only on the depth (a derived line box against a flat 32 dp) and on what stands in it. The pane's own footer is drawn once, in mindchat, with the hairline rule stated there ("the hairline is the pane's OWN, drawn inside its outline and running only the pane's width"), and the recorder draws the same hairline-then-row shape for a different payload (folderpane.go:689-705).

**Proposed, and what it deletes.** Two slots and one rule, which is what the exploration already proposes: `PaneFrame.Footer layout.Widget`, laid out across the content column at the depth it reports with the main slot taking what is left; and `pane.ColumnSlots.Footer` (part 6.3), a hairline the pane's width followed by the slot, taking no height when the slot is nil. `shell.FooterSeam(gtx, c)` draws the one hairline both footers want, so neither window states which separator token it is. Deletes: vaultview ~10 lines of offset arithmetic; mindchat the hairline and row scaffold of `SidebarFooter` (~15 of 45); the recorder the Flex and offset bookkeeping in `shellMain` (~20 of 27) and the hairline in `folderPane`.

### 6.11 The remembered width and the shown state

What the window keeps of its own arrangement across launches: how wide the pane stands, and whether it stands at all.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| width | state: `frameState.railW`, moved by a splitter, defaulting to `treeWidthDp` = 240 dp ≈ 55.2 mm | constant: `SidebarWidth` = `sidebar.ExpandedWidth` = 220 dp ≈ 50.6 mm, theme.go:202-210 | constant: `paneWidth` = `shell.PaneWidthDp` = `sidebar.ExpandedWidth`, folderpane.go:539-556 |
| width kept | yes: `columnMemory`, remember.go (254 lines) — `layout.json` in the OS config directory, debounced 500 ms, clamped on read, written again as the window goes away | n/a | n/a |
| shown state kept | **no** — `m.SidebarHidden` is toggled (model.go:506) and never persisted | yes — `Model.SidebarHidden`, "remembers across launches", messages.go:125-127, through the config | yes — `appConfig.FolderPane *bool`, libraryconfig.go:74-78, `savePaneVisible` 167-171, `resolveFolderPane` 291-300 |
| reported | every frame, last: `f.widths.record(...)`, frame.go:656-658 | on the recall | on the recall, `persistPaneCmd`, folderpane.go:342-364 |
| lines | ~254 + 8 | ~12 | ~45 |

**In the library.** `mvu.RememberFrame(win, appName)` keeps the WINDOW's own frame — its size and its place on the desktop — and all three windows call it. Nothing keeps the arrangement INSIDE the window.

**Re-derived.** The one window with a draggable pane writes a whole file to keep its width, with its own debounce, its own clamping-on-read, its own NaN guard and its own write-on-destroy; the two windows with a fixed pane keep the shown flag through their own application config in two different shapes. And the three disagree on whether the flag is kept at all: vaultview forgets it, and a reader who sends the rail away finds it back on the next launch.

**Proposed, and what it deletes.** `shell.RememberArrangement(appName string) (*shell.Arrangement, error)`, next to `mvu.RememberFrame` and with its debounce — `shell.Arrangement` holding `PaneWidth unit.Dp`, `PaneShown bool` and, for the third arrangement, `ListWidth unit.Dp`, each clamped on read against bounds the caller states. The frame reports to it; the window reads it at launch and passes nothing else. That is the exploration's point that the shell remembers the pane's width and shown state and the list's width while the application persists nothing of the frame, and it makes forgetting the flag impossible. Deletes: vaultview `remember.go` entire (254), less the `clampRail`/`clampAside` bounds it hands the shell; mindchat the `SidebarHidden` lane through `Config`, `Init` and `Update` (~12); the recorder `appConfig.FolderPane`, `savePaneVisible`, `resolveFolderPane`, `persistPaneCmd`, `msgPanePersisted`, `withFolderPane` (~60).

### 6.12 The pane's collapse and expand motion

The pane collapses and expands rather than being switched, so the content column reflows, the toolbar re-measures, the pane's corners move and the shadow casts from the new bounds.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | none: `Hidden` is a flag | none: `Hidden` is a flag | `paneslide.go` entire, 188 lines, one app-local control |
| what it supplies | — | — | `(*paneSlide).width(gtx, standing, mo) unit.Dp`, paneslide.go:66-105 |
| sweep | — | — | `effects/tween` between 0 and `paneWidth` over `MotionScale.DurNormal` (250 ms) on `EaseStandard`, reversal from the drawn width, one frame asked for per frame while moving and none while collapsed or expanded, instant under the reduced scale |
| its own arithmetic | — | — | `bezierEase`, paneslide.go:130-188 (59 lines): the CSS cubic-bezier solve, because nothing in the library evaluates a `tokens.Bezier` |

**In the library.** `PaneFrame.Width unit.Dp`; `effects/tween`; `tokens.MotionScale` with its durations and `tokens.Bezier` with its control points and no arithmetic. What the drawing already does take is bounds whose leading edge lies off the window: `pane.Layout`, `pane.PaintShadow` and `pane.FillTrailingCorners` draw rim, corners, shadow and clipped contents correctly from a rectangle with a negative leading edge, the renderer clipping at the glass.

**Re-derived.** One window carries the control and the other two cannot move their pane at all. The 59 lines of `bezierEase` are the sharpest finding: the theme publishes the easing family's control points and nothing in the library evaluates them, so every consumer that wants the theme's curve writes the solve.

**Proposed, and what it deletes — the bounds reading.** The pane translates: it does not narrow in place. So the pane's collapse and expand motion yields BOUNDS, not a width — from the margin plus the swept width minus the pane's full width, to the margin plus the swept width, clipped to the window — and the frame needs a way to take them. What cannot take such bounds today is the MEASUREMENT: `pane.Bounds` and `shell.PaneFrame.Bounds` anchor the leading edge at the margin and clamp the width to half the window, and `PaneFrame.Layout` derives its own bounds from the width and accepts none (`Under` already does). So the measurement functions learn to take a leading edge off the window, and the collapse and expand motion supplies one. The three parts are in section 7. Deletes: the recorder `paneslide.go` and its four tests, and the row leaves `make controls`; vaultview and mindchat delete nothing and gain the collapse and expand motion.

### 6.13 The splitter on the pane's trailing edge

A boundary the reader may move, drawn where the pane's own rim runs straight, thickening under the hand that takes it.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `railProps` 707-755, `layoutRailSplitter` 756-776; and the aside's pair, `asideProps` 799-845, `layoutAsideSplitter` 777-798 | none | none: the pane is a sidebar, not a split view |
| line at rest | the pane's own rim, `pane.RimColor` over the rows `pane.EdgeSpan` reports | — | — |
| bounds | the rail's own clamp and the note column's floor (`noteFloor`, frame.go:693-706) | — | — |
| lines | 49 + 21 + 47 + 22 + 11 + 10 = 160 | 0 | 0 |

**In the library.** `patterns/splitter` — the Splitter entry made code, drawn at the seam's width in the seam's colour, thicker and firmer while a hand is on it, a hit area wider than the line, the resize pointer over it, dragging clamped to the bounds each region allows. It landed in the library, with vaultview's two seams adopting it, and the shell's own split-pane drag was hoisted into it in the same round (section 14). So this part is no longer a reading of one window's private code: it is a generalisation of shipped code into the frame. `pane.EdgeSpan` (the rows the trailing edge runs straight, so a line neither crosses a rounded corner nor leaves a pixel out on the window's surface) and `pane.SeamTop` exist for it.

**Re-derived.** What is still missing is the composition: the props, the clamps, and the conversion of a dragged pixel back to a kept dp. Only one window has a pane on a splitter, so there is no duplication to remove — but there is a pattern to state, because the shipped shell is ruled to stand its pane on one and the other two windows will then have it. The parts worth fixing before two more copies exist: the boundary is the rim's own LEADING edge and not the pane's trailing one; the line runs exactly `EdgeSpan`'s rows; the hand-hold runs the same rows as the line; the clamp is the pane's own bounds with the content column's floor over them; and `pxPerDp` is how a reported pixel becomes a kept dp.

**Proposed, and what it deletes.** `PaneFrame.Resize *shell.PaneResize` — nil for a window whose pane is fixed, which is two of three today. It holds the `splitter.State`, the bounds (`Min`, `Max` in dp) and the content column's floor, draws the hand-hold over `EdgeSpan`'s rows in `pane.RimColor`, and reports the new width to the `shell.Arrangement` of part 6.11. `shell.PxPerDp(gtx)` carries the metric once. Deletes: vaultview ~110 of its 160 (the rail's half entire; the aside's splitter stays as the aside's own until the aside becomes a slot).

### 6.14 The window buttons' placement and the full-size-content treatment

The three control buttons are measured from the window's own glass and from nothing drawn beneath them, and under the full-size-content treatment the application places them and owns the strip they stand in.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| options | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1100, 800)`, main.go:66-69 | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1024, 768)` + `app.MinSize(575, 256)`, main.go:45-49 | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1100, 760)` + `app.MinSize`, main.go:574-578 |
| re-asserted | `desktop.ShowWindowButtons(mvuWin)`, main.go:89 | `desktop.ShowWindowButtons(mvuWin)`, main.go:63 | `desktop.ShowWindowButtons(w)`, main.go:595 |
| placed | per screen: `placeWindowButtons(buttonPlacementFor(m))`, main.go:388-399 over `buttonPlacement` 290-307 and `buttonPlace atomic.Value` — the picker screen asks for none | once: `desktop.PlaceWindowButtonsAt(WindowButtonInset, WindowButtonCenter)`, main.go:64, over `windowButtonRun = pane.Buttons`, theme.go:314-323 | once: `desktop.PlaceWindowButtonsAt(pane.Buttons.Leading, pane.Buttons.Center)`, main.go:603 |
| top inset | `chromeHeight()`/`underChrome`/`insetTop`, main.go:346-376 (24) — overlays clear the larger of the laid-out toolbar and `desktop.TopInset()` | — | retired: `desktop.TopInset()` reports zero and `shellTopInset` went with it |
| lines | ~24 + 48 = 72 | ~12 | ~10 |

**In the library.** `pane.Buttons = desktop.ButtonRunAt(pane.ButtonInsetDp)` — the whole run, derived from the platform's measured 19 dp inset; and `desktop.FullSizeContent()`, `ShowWindowButtons`, `PlaceWindowButtonsAt`, `LeadingInset`, `TopInset`.

**Re-derived.** The three-call sequence, with the placement spelled three ways — the run's fields, a local alias of them, and the run itself. One window needs the placement to be per screen, because a screen that lays out under the native strip must ask for no placement at all, and it carries 48 lines of its own to make that idempotent. One window still carries 24 lines of overlay inset arithmetic for a mixed case the other two do not have.

**Proposed, and what it deletes.** `shell.PaneWindow(opts ...app.Option) []app.Option` — the treatment's options with the caller's appended — and `shell.StandWindowButtons(win)`, which both re-asserts and places at `pane.Buttons` in one call, idempotently, and takes an optional `func() bool` for a window with a screen that wants the native strip instead. Deletes: vaultview ~48 (`buttonPlacement`, `buttonPlacementFor`, `buttonPlace`, `placeWindowButtons`); mindchat ~10 and the `WindowButtonInset`/`WindowButtonCenter` aliases; the recorder ~6.

### 6.15 The shadow cast last

The shadow the pane casts falls on what stands AROUND it, and a column that paints its own fill after the pane has laid out would cover it — so the shadow is painted after every column has painted, with the pane's own box cut out of the drawing so the late call lands what an early one landed.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `pane.PaintShadow(gtx, tok.col, g.pane)` after the columns and before the splitters, frame.go:634-638 | `pane.PaintShadow(gtx, t.col, bounds)` after the picker, frame.go:188-194 | `PaneFrame.Layout` casts it, shellchrome.go:251 |
| lines | ~5 + 12 of prose | ~2 + 7 of prose | 0 |

**In the library.** `pane.PaintShadow`, and the reason stated twice — once in `pane`'s doc (pane.go:280-296) and once in `PaneFrame.Layout`'s (paneframe.go:146-153).

**Re-derived.** The call, and the paragraph explaining it, in the two windows that compose their own columns. The paragraph is nearly word for word the same in both (frame.go:634-638 against frame.go:188-193), and both are restatements of the library's own.

**Proposed, and what it deletes.** `PaneFrame.Under` already paints everything beneath the columns; its counterpart is `PaneFrame.Over(gtx, c, bounds)` — the shadow, and anything else the frame owes after a caller's own columns. A window that composes its own arrangement then spends `Under` first and `Over` last and states no reason, because the pair's names are the reason. Deletes: vaultview 17 (the call and its prose), mindchat 9, the recorder nothing.

## 7. The pane's collapse and expand motion, and the easing

Drawn from the exploration's collapse and expand proposal of 2026-10-02 and its two addenda of the same day, with the specification's part on the motion read through them.

**What the recorder found.** `shell.PaneFrame` has two states for the pane, hidden and not, and `pane.Bounds` answers an empty rectangle for the first, so the pane arrives and leaves in one frame. Voice Memos, the window the pane's measurements were taken off, collapses and expands its sidebar. No workbench application moves its pane, so the recorder carries one app-local control that turns the one bool the frame takes into the one width the frame takes. Its size is stated twice and the two do not agree: 180 lines in the proposal, 188 when the file was counted part by part. The larger is the one the counts of section 13 are built on. Everything else follows from the number: the content column reflows, the toolbar re-measures, the pane's corners move, the shadow casts from the new bounds.

**What it takes in the library, in three parts of increasing reach.**

1. **`tokens.Bezier` gains an evaluator** (`At(t) float64`). The theme publishes the easing family's control points and nothing evaluates them, so every consumer that wants the theme's curve writes the CSS cubic-bezier solve. It is needed by every consumer of the easing family whether or not a pane slides, and it is what deletes 59 of the recorder's 188 lines.
2. **`effects/tween` gains an eased constructor** over that evaluator, removing the closure idiom from every caller wanting the theme's curve. The package's own doc names the gap.
3. **A slide ships beside the frame, not inside it** — a small exported type in `patterns/pane` the caller holds and spends into the frame, with the away rest staying the caller's business. The recorder recommends this over the frame holding the animation, because the frame is a value built fresh every frame with no lifetime, and the same slide would drive an aside without the frame knowing. One rule ships with it: the toolbar's leading inset while the pane is mid-sweep is the larger of the toolbar's own gutter and the inset past the window's control buttons, so it passes without a step (part 6.6).

**What the pane's collapse and expand motion hands over.** Not a width: bounds. The pane translates, so the motion yields the offset as well as the width — bounds from the margin plus the swept width minus the pane's full width, to the margin plus the swept width, clipped to the window — and the measurement functions learn to take a leading edge off the window. The drawing already takes such bounds; the measurement is what refuses them.

**Measured on Voice Memos (macOS 26), 2026-10-02, with real pointer clicks and 100 ms captures.**

- The pane **translates as one object**, its column anchored to its trailing rim, entering from and leaving past the window's leading edge with its own margin and rounded corners; no row is clipped in place and no title truncated.
- The content column's leading edge is the pane's trailing rim throughout.
- The window's three buttons stay on the glass while the pane passes under their line.
- The new-folder and recall marks **snap to their resting positions from the first frame** — on the pane's corner line while it is still arriving, bordered in the toolbar from the first frame of the departure.
- The whole motion is **about 300 ms**: the rim moved 228, 163, 84 px across the 100 ms captures.
- The **travel is the pane's width plus its margin**, 228 dp for a 220 dp pane, so the away rest leaves no sliver of rim on the glass.
- **Mid-travel the toolbar's bordered recall pair stands over the pane's chrome material** rather than the content fill: the pane passes under the toolbar as it passes under the window buttons.

The sweep's own duration is a disagreement with the token the recorder's control spends (`MotionScale.DurNormal`, 250 ms) and is ruling 27.

## 8. What each window keeps, and the slot it arrives through

Drawn from the specification's second part, with feeds and the goldens rule from the exploration.

The pattern leaves slots for these; it does not absorb them. Each is named with the slot it arrives through, so the extraction has somewhere to put it.

**vaultview.**

| kept | what it is | the slot |
|---|---|---|
| the backlinks aside | a trailing FLUSH chrome column, 320 dp ≈ 73.6 mm, absolute width, parted from the note by a plain seam; `aside.go`, 675 lines | the aside variant's own slot; an empty aside takes no width |
| the aside's splitter | the trailing boundary, line from the toolbar's foot to the window's, hand-hold over the document row alone | `shell.AsideResize`, the counterpart of part 6.13's `PaneResize` |
| the status bar | one `LabelMedium` line box plus `2*sp.S1`, holding the note's line count and what the window is showing; `status.go`, 145 lines | `PaneFrame.Footer` (part 6.10) |
| the find in the page | the toolbar carries the field and the note marks the matches; `bandFind` (frame.go:264-277), `find.go` 331 lines, the field built per frame for the count's sake | a `shell.Toolbar.Trail` `layout.Widget`, with `MainFirst` carrying the ordering the count needs |
| the window's navigation | the segmented back/forward pair, `layoutNavigation` 35 + `navSegment` 21 | `shell.Toolbar.Lead` `layout.Widget`s |
| the note's name | bare text in the toolbar, `layoutNoteName` 26 + `noteName` 9 + `vaultName` 10 | a `shell.Toolbar.Lead` `layout.Widget` |
| the tree's own row parts | the disclosure, the per-depth indent, the find's highlight (`drawFound` 42, `foundRun` 17, `runWidth` 17) | `sidebar.Row.Before` and the row's own name painter (part 6.9) |
| the note column | `note.go`, 1057 lines | `PaneFrame.Main` |

**mindchat.**

| kept | what it is | the slot |
|---|---|---|
| the pane's footer | a hairline the pane's width and one 46 dp row with the gear and "Settings"; Settings stands here and nowhere else, and `Cmd-,` is how it is reached while the pane is away | `pane.ColumnSlots.Footer` (part 6.10) |
| the chat title | the window's one orientation cue once the pane is away, with a muted placeholder for an unnamed chat and `titleMaxDp` = 360 dp ≈ 82.8 mm; `chatTitle` 23 + `titleVerdict`/`chatTitleText` 23 | a `shell.Toolbar.Lead` `layout.Widget` |
| the model picker | a reserved cap in the toolbar whose surface hangs over the transcript, drawn last; the reservation (frame.go:229-240) + `layoutPicker` 26 + `modelmenu.go` 259 | a `shell.Toolbar.Trail` `layout.Widget` for the cap, `PaneFrame.Over` for the surface |
| the row's two marks and the stream dot | rename and delete revealed on the active row, the pulse on a streaming chat | `sidebar.Row.After` (part 6.9) |
| the transcript and the input bar | `ChatPane` + `messages.go` + `markdown.go` | `PaneFrame.Main` |
| the undo bar | a transient surface bottom-centre over the transcript | the main slot's own; it is not chrome |

**the recorder.**

| kept | what it is | the slot |
|---|---|---|
| the record control | the one control the toolbar's trailing end exists for: start/stop, the pause beside it while the take runs, Cancel and Done on a stopped take; `recordstrip.go` 1261 lines, `recordTargetDp` 44 dp ≈ 10.1 mm centred in the 52 dp toolbar with 4 dp either side | a `shell.Toolbar.Trail` `layout.Widget` |
| the microphone picker | the button in the toolbar's trailing group and the drop-down that overhangs the content below it; `devicepick.go` 758 lines, drawn after the frame and its shadow | a `shell.Toolbar.Trail` `layout.Widget` for the button, `PaneFrame.Over` for the drop-down — the same slot mindchat's picker needs |
| the live level meter | stands between the microphone and the record control while the take runs; `bandMeterBar` 15 | a `shell.Toolbar.Trail` `layout.Widget`, conditional |
| the bottom chrome strip | the gears at the leading edge and the model cluster beside it, one line of state about the models; `shellFooter` 40 + `modelCluster` 73 + `footerModelState` 32 + `arrivalBar` 29 + `gearsButton` 9 | `PaneFrame.Footer` (part 6.10) — the same slot vaultview's status bar needs |
| the search field | `components/input.SearchField` in the Chrome variant's Toolbar recess, beside the folder's name, 200 dp wide, with the collision rule that the name yields (`bandNameRoom` 35) | a `shell.Toolbar.Lead` `layout.Widget`; the collision rule is the toolbar's, the field is the window's |
| the opened session's acts | Delete and Reveal after the name on the transcript view; `bandIconButton` 14 + `iconButtonOn` 27 | `shell.Toolbar.Lead` `layout.Widget`s — but see ruling 33: they are the application's own hover-pill icon buttons today, not the platform's bordered control |
| Recently Deleted's Empty | the act over the whole listing, beside the name of the listing it acts on; `trash.go` 435 | a `shell.Toolbar.Lead` `layout.Widget`, conditional |
| the way back | the folder's name as a control on the three views that replace the list, with its pill's air spent outside the gutter so the text column does not move; `bandBackName` 73 | a `shell.Toolbar.Lead` `layout.Widget` |
| the four views and the per-view table | which view is on screen and what the toolbar carries there; `shellView` 19, `viewHasPane` 6, `bandCarries*` 58, `bandKinds` 49 | the window's own: it is what fills `shell.Toolbar.Lead`/`Trail` per frame |
| the pane's new-folder flow | the name row and the in-place refusal at the pane's footer while the flow is open; `paneNameRow` 60 | `pane.ColumnSlots.Footer` — the same slot mindchat's Settings row needs |
| the pane's counts, symbols and heading | the session counts, the waveform and bin marks the library's set lacks, the "Folders" heading | `sidebar.Row`'s `Count` and `Symbol` (part 6.9) |

**feeds.** It is the fourth window and was not read part by part, because it does not compose a pane frame: it stands on the shell's sidebar-header-main layout with a split pane nested inside it. It moves onto one of the shipped arrangements — the feeds list in the pane, the articles in the list or content column, the article in the aside or in the content column — and the two old layouts are then unconsumed and leave. Which arrangement it takes is ruling 5, and the answer decides whether the old split pane is missed.

**The goldens rule.** Goldens regenerate once per application with the cause named; the abrupt rule applies, and no compatibility layouts are kept.

## 9. The desktop's tenants and the application's life

Drawn from the draft's fourth goal and the recorder's early ask of 2026-10-01.

Each is delivered as messages into the loop, the way the menu bar and the drops already are (`mvu/desktop/menu_darwin.go`, `drop_darwin.go`). One task per tenant, so each fits one run and its stub side is written with it.

1. **The status item.** A menu-bar item with its own menu, as messages.
2. **The window level and the panes.** A floating window level option; open, save and folder panes as commands answering with messages; reveal in Finder.
3. **Notifications and the hotkey.** User notifications with an action message on click; a global hotkey as a message.
4. **The application's life.** The terminate hook with a veto (quit as a message), reopen and did-become-active events, the About pane.

**The recorder asks for the fourth ahead of the rest, and states why.** Its menu bar landed on the desktop module's menu bar at v1.1.0, every item a message through the loop. Its quit path cannot, because the module has no terminate or reopen hook, no workbench application has one, and Gio exposes no delegate seam, so it is Objective-C on the application's delegate, which belongs in the library before an application uses it. Asked as drafted: applicationShouldTerminate as a hook the application answers from its loop (a veto, so a running recording stops and finalises first and the application then quits itself), applicationShouldHandleReopen, and did-become-active, each delivered as a message on the window's stream the way the bar's items are, callbacks hopping off the main queue as the drop target's do. The About pane is not needed yet. The timing is the owner's: it may share a round with the shell or come earlier (ruling 10).

## 10. The controls queue

Drawn from the draft's two control goals, minus what landed or was ruled out, ordered as the recorder says it will ask, one slice at a time.

The recorder will ask per slice, each time by reading the workbench exemplar, generalising the pattern into the library, and adopting it afterwards.

1. **The session list and folders.** The pane's column as a row recipe (part 6.9), and the two-line row for `components/list`: leading mark, title, subtitle with trailing meta, a badge, selection and cursor, from feeds' article rows.
2. **Recording.** The recorder's slice names the record row's level meter and its pill. The level meter was ruled the application's, not the library's (section 14); which of the draft's items the slice's pill means is not stated anywhere. What the draft does ask for that a record row needs is the round button face, so a record disc is a button with its pinned fill rather than a drawing.
3. **Following live.** Tail-follow in `components/list`: it sticks to the end while at the end, releases when the reader scrolls up, and offers a jump-to-latest affordance, from mindchat's transcript. And the clickable inline span in `components/paragraph`, so a transcript segment is one flowing paragraph with its speaker's name inside it; mentions and tags in chat are the second use. That span is a link, answered by the Language (ruling 16).
4. **Review.** A slider with the playback face.
5. **Transcription.** Determinate and indeterminate progress, as the Progress entry states it: a bar filling from the leading end when the end is known, the platform's indeterminate indicator when not, read and never operated. Ruled the library's (section 14).
6. **Assignment.** The dialog, which the library already ships as a pattern; the draft asks nothing new for it.
7. **Search.** The segmented control for a one-of-few inline choice with no pane (the "All | Current folder" scope chooser), with the chip and picker docs saying how it differs. The search field itself landed (section 14); what the draft asked for and nothing records as landed is per-keystroke messages carrying the text.
8. **Microphones, setup, import, speakers, export.** No library item from the draft is named for these slices.

Asked by the draft and not named in the slice order: the borderless text field face (grows with its text), multi-line, for an editable title in a header and a paragraph edited in place; the alert's trailing action, answered by the Language: beside the alert, no slot (ruling 14); the disclosure group, whose Language half is answered and whose remaining half is vaultview's Properties pane adopting the accordion; and the shortcuts helper — a table of chord to message with the window-wide key area done once, from feeds' `shortcut.go`, with the mindchat lockup as the failure it prevents, adopted by feeds and mindchat.

Not planned, from the draft: waveforms, tables beyond what exists, the marketing patterns, and any audio component beyond the playback face. Nothing is tagged until the system is finished, and a consumer pins commits until then.

## 11. Sequencing, one task per run

Drawn from the exploration's proposed goals and the specification's part order, with the draft's exit lines.

One task per run. Each task is green in the library and in every named application before it is committed, and the modules are named in the task rather than left to the worker to find.

1. **The Language.** The arrangements named; the words of section 2 coined or ruled against; the Toggle Sidebar button's word; the footer's word. Entries in DOMAIN, rows in AGENTS.md's retired table where a word retires. One task, and it is first because every later task's identifiers come out of it.
2. **Seeing without a screen.** The whole-window renderer in a library; vaultview, mindchat and the launcher adopt it and their local renderers go, goldens byte-identical. One task. The mvu driver can follow at any time.
3. **The shell, extracted from vaultview** into the shell pattern as the aside variant with the aside optional; vaultview adopts in the same task, since it is the reference and this is a move, not a copy. One task, possibly two if the recall and Tab wiring outgrows it. The parts of section 6 it carries are the frame's op-order and `PaneLayout`, the fills, the pane's column helper, the two mark drawings, the toolbar value and its metrics, the toolbar's leading rule, the Toggle Sidebar button, the two footers, the remembered arrangement, the window treatment, and the shadow's counterpart.
4. **Mindchat adopts** the pane-and-column arrangement; its frame goes. One task, fresh eyes on the window.
5. **Feeds adopts**; the sidebar-header-main, split-pane and three-column layouts leave the library; the gallery's shell specimens become the named arrangements. One task.
6. **The source list** from vaultview's tree and mindchat's conversation list; both adopt. One task, after the Language.
7. **The third arrangement** — three-column — with the list column's splitter and its remembered width.
8. **The pane's collapse and expand motion, and the easing** (section 7), in its three parts; the measurement functions learn to take a leading edge off the window and the toolbar's leading rule ships with it.
9. **The desktop's tenants** (section 9), one task per tenant; the application's life may come earlier.
10. **The controls queue** (section 10), one slice at a time as it is asked for.

**The exit discipline**, per task: green in the library and in every named module, nested ones by name; a gallery specimen where a control or a pattern is added; a fresh-eyes review in both schemes where anything is drawn; goldens regenerated once per application with the cause named; `scripts/check-retired-words.sh check` reporting OK; commit and push in every touched repository and in `.github`. No tagging task.

## 12. Open rulings for the owner

Drawn from the specification's sixteen rulings, the exploration's four open questions, and the disagreements the merge found between the three sources. Deduplicated; thirty-four in five groups, one line each, with the recommendation where a source carries one.

**Scope and shape.**

1. One pattern with named variants, or separate shells? Recommended: one pattern, since the aside toggles at runtime in vaultview.
2. How far does the toolbar span in the three-column arrangement — list and content with a share per column, or the content column alone? Three sources, three readings (section 4); no recommendation on record.
3. `PaneFrame.BandFill`, a slot nobody fills. Recommended: drop it (three windows, zero consumers, and `Under` carries 12 lines of corner-splitting for it); it comes back when a window is its reason.
4. Does the pane stand beside every view, or per view? Recommended: per view, as a predicate the window supplies — all three are that shape once stated so, and the frame already takes the answer as a width.
5. Is feeds' reading layout the three-column arrangement, or two columns with the article in the content column? The answer decides whether the old split pane is missed.
6. The launcher's window: does it adopt an arrangement or stay bespoke?
7. Does `patterns/sidebar` stay as the pane's column, or is the source list a new pattern? The draft proposes a new one and calls the existing one flat, icon-and-label and fixed width; the specification's shape assumes it stays and grows a row recipe. No recommendation on record.
8. Where does the whole-window renderer live — `components/golden`, or a new `mvu/render`?
9. Where does the shortcuts helper live — `mvu/desktop`, or `components/keyed`?
10. When do the application's life hooks land — with the shell's round, or earlier, as the recorder asks? The timing is the owner's.

**The Language.** The full list of words still to coin or rule against is section 2; these are the ones with alternatives already on the table.

11. The arrangements' names: the descriptive triple ("pane and column"; "pane, column and aside"; "pane, list and content"), or the platform's "two-column" and "three-column"; answered by the Language: Shell names the variants two-column and three-column.
12. The naming the extraction carries. Recommended: the library's current words — `PaneFrame.Surface`, `sidebar.TitleInset`, `Toolbar` throughout for the strip across the content column, `desktop.BandLead` renamed with it — and the recorder follows on its next pin.
13. The recall pair's own word: the specification calls the pair a switch and proposes that type name, and DOMAIN gives switch to the on/off control alone; answered by the Language: Pane, the one Toggle Sidebar button.
14. The alert's trailing action: a change to the Alert entry, which today says an alert holds text and never a control, or a ruling against the ask; answered by the Language: beside the alert, no slot.
15. A word for the foot — the pane's own, and the one under a content column — of which DOMAIN carries neither; answered by the Language: Footer.
16. What the speaker's name inside a flowing transcript paragraph is called: the draft's inline pill span, or the recorder's chip; answered by the Language: Link.

**The footers, and the acts in them.**

17. Where does an application-level act (Settings) live — nowhere in the chrome, the pane's footer with a chord while the pane is away, or the content column's footer always? Recommended: rule the principle first, that an act surviving the pane's going away may not live only in the pane's footer, then the column's footer, with the pane's footer for acts belonging to the pane's own collection.
18. Does the status bar belong to the shell or to the application? Recommended: a shell slot, generalised to a footer per column.
19. The footer's depth: a derived line box (one `LabelMedium` line plus `2*sp.S1`) or a flat 32 dp ≈ 7.4 mm. The two windows that have one disagree; no recommendation on record.

**The measurements.** Numbers are not averaged.

20. The toolbar's leading gutter while the pane stands: 24 dp ≈ 5.5 mm, 12 dp ≈ 2.8 mm, 16 dp ≈ 3.7 mm. Recommended: the rule is right in all three and only the number differs — the gutter IS the content column's own inset, so ship `ToolbarMetrics.Lead` with no default and make the window name it.
21. The toolbar's trailing gutter: 8 dp ≈ 1.8 mm, 12 dp, 16 dp. Recommended: 8 dp, the one gutter the platform measures identically in four stored toolbar windows and the one not derived from the column's content; the recorder's 16 came from its retired header strip, and the record control moves 8 dp ≈ 1.8 mm trailing-ward when it changes, a look to be seen before it lands.
22. The gap between two bordered controls standing apart: 16 dp ≈ 3.7 mm (Finder's, and `reference/macos/controls.md`'s), 14 dp ≈ 3.2 mm (Notes'), 8 dp ≈ 1.8 mm. Recommended: two measurements with two meanings — 16 between two merely adjacent, 14 between two that belong together — ship both and retire the 8, which matches no capture.
23. The gap between a bare title and a bordered control: 14 dp ≈ 3.2 mm (measured twice in Finder), 12 dp, 16 dp. Recommended: 14 dp, the only measured room between a bare title and a bordered control in any stored toolbar, read on both appearances.
24. Is the toolbar's depth named once? Recommended: one name, `shell.ToolbarDepth = pane.BandDp`; the window that re-does the arithmetic arrives at the same 52 dp ≈ 12.0 mm.
25. The typography role a pane row's name is set in: `BodyMedium`, the window's own palette, `LabelLarge`. Recommended: `LabelLarge`, the pattern's own role and the one the count's placement depends on.
26. The pane's default width: 220 dp ≈ 50.6 mm (`sidebar.ExpandedWidth`, which two windows spend and the third arrangement states) against 240 dp ≈ 55.2 mm (vaultview's default under its splitter). No recommendation on record.
27. The pane's collapse and expand motion's duration: `MotionScale.DurNormal`, 250 ms, which the recorder's control spends, against the about 300 ms measured on Voice Memos (the rim moved 228, 163, 84 px across 100 ms captures). No recommendation on record.

**Behaviour.**

28. Which mark takes the pane's trailing corner? Recommended: the primary act leading and the recall control in the corner, per the pane pattern's own measurement off `voicememos-multi-folder-2026-09-18.png` (new folder at x 209-230, the recall control at x 252-271); mindchat's is reversed and should flip.
29. One `Clickable` per recall pair, or two? Recommended: one — only one half is ever on screen, so the second is a second gesture source for one affordance against this project's one-source, one-`MessageOp` discipline; the proposed type carries one, and the window that chose two deliberately should have its stated reason answered in the same breath; answered by the Language: one button.
30. Is the pane's shown state kept across launches? Recommended: yes, and by the shell rather than three application configs; a reader who sends the pane away and finds it back on the next launch is reading a defect.
31. Is the pane's column a keyboard stop? Two of three are; the third is on no focus ring, so its unemphasized pill can never be shown and the emphasized one is drawn always. Recommended: the third joins the ring, which means `sidebar.RowTarget` and a `gesture.Click` per row rather than a `widget.Clickable` per row.
32. The toolbar's leading rule mid-sweep: a flag at either end, or the larger of the two measured in window columns? Recommended: the corrected rule, for every window whether or not its pane collapses and expands — read as a flag the leading edge steps about 80 dp ≈ 18.4 mm at the instant the pane reaches zero.
33. Is every control in the toolbar the platform's bordered control? Two windows say yes without exception; the third draws Delete and Reveal as its own hover-pill icon buttons and the Empty chip and the record control with its own faces. Recommended: the record control is application-special and stays, Delete and Reveal become the bordered control; it decides whether `shell.Toolbar` may assume its `Lead` entries are bordered.
34. Does a row's symbol come from the pattern's painter or the window's own drawing? Two of three spend `sidebar.PaintSymbol`, the third hand-draws. No recommendation on record.

## 13. What the extraction is worth

Drawn from the specification's count, unchanged.

**What each window spends on its frame today.**

| window | the files that compose the window | lines read | shell geometry | its own content |
|---|---|---|---|---|
| vaultview | `frame.go` 1229 + `tree.go`'s pane half ≈ 255 of 886 + `remember.go` 254 + `main.go`'s window half ≈ 72 of 481 | 1810 | ≈ 1340 | ≈ 470 |
| mindchat | `frame.go` 492 + `view.go`'s pane half ≈ 326 of 1440 + `theme.go`'s chrome block ≈ 37 of 346 + `main.go`'s window half ≈ 12 of 84 | 867 | ≈ 560 | ≈ 307 |
| the recorder | `shellchrome.go` 620 + `headerstrip.go` 899 + `folderpane.go`'s layout half ≈ 375 of 997 + `paneslide.go` 188 + `palette.go`'s toolbar lane ≈ 20 of 119 + `main.go`'s window half ≈ 10 of 951 | 2112 | ≈ 1185 | ≈ 927 |
| **total** | | **4789** | **≈ 3085** | **≈ 1704** |

**What remains after the extraction.** The window keeps what fills the slots and nothing of the arrangement.

| window | shell geometry today | after | deleted | what is left of it |
|---|---|---|---|---|
| vaultview | ≈ 1340 | ≈ 300 | ≈ 1040 | the aside's splitter until the aside becomes a slot (≈ 80), the clamps it hands the shell (≈ 30), the per-screen placement predicate (≈ 15), the toolbar's and footer's slot payloads' wiring (≈ 100), the tree row's own parts (≈ 75) |
| mindchat | ≈ 560 | ≈ 215 | ≈ 345 | the chat title and its verdict (≈ 46), the picker's cap and `layoutPicker` (≈ 38), the footer's Settings payload (≈ 30), `ChatRow`'s own marks and dot (≈ 80), the window's options (≈ 2), the slot wiring (≈ 20) |
| the recorder | ≈ 1185 | ≈ 455 | ≈ 730 | the per-view table (≈ 145), the toolbar's item bookkeeping for the probe (≈ 60), the pane's new-folder flow (≈ 85), the footer's gears and model cluster (≈ 185), the row's symbol adapter and section predicate (≈ 40), the slot wiring (≈ 60) — and `paneslide.go` and `bezierEase` go to zero |
| **total** | **≈ 3085** | **≈ 970** | **≈ 2115** | |

**What the library gains.** `patterns/shell/paneframe.go` is 182 lines today and `patterns/pane/pane.go` 464. The parts proposed above — the `PaneLayout` value and the op-order fields, `shell.Toolbar` with its metrics, `shell.ToolbarLead`, `pane.Mark` and `pane.ToolbarControl`, `pane.Column` and `pane.Marks`, the Toggle Sidebar button's value type, the two footer slots and `shell.FooterSeam`, `shell.RememberArrangement`, the pane's collapse and expand motion with `tokens.Bezier.At` and the eased tween, `shell.PaneResize`, `shell.PaneWindow` and `shell.StandWindowButtons`, and `sidebar.Row`/`PaintRow`/`PaintSectionBlock` — are an estimated 700 to 900 lines of library written once, prose included, much of it moved rather than written: the measurement prose each window carries today is the pattern's own and has one home.

**The net figure.** The extraction removes about 2100 lines from the three windows and adds about 800 to the library: a net reduction of around 1300 lines, and — the point of the ruling that started it — one statement of each measurement instead of three.

## 14. Already ruled or landed

Drawn from PLAN.md's checked tasks, DOMAIN's Language and the sources' own later notes. This is the one place in this document that cites plan task identifiers.

- **BT3.1, 2026-09-06, `patterns/splitter`:** the Splitter entry made code — the seam's width and colour, thicker and firmer under a hand, a hit area wider than the line, the resize pointer, dragging clamped to each region's bounds — hoisted from the shell's split-pane drag and vaultview's aside splitter, the shell adopting it in the same task.
- **BT3.2, 2026-09-06, `workbench/vaultview`:** a splitter between the rail pane and the note column, clamped to a minimum rail width and a minimum note measure, the aside's seam becoming the same splitter, both widths remembered. So part 6.13 generalises shipped code, not one window's private control.
- **BT1.1, 2026-09-06, `mvu`:** a window's size and position remembered in device-independent units, debounced, in the OS config directory under the application's name, applied before the first frame, with the application's defaults when the file is missing or unreadable or the frame fits no screen.
- **BT1.2, 2026-09-06, `workbench/vaultview`:** vaultview adopts it, and its rail and aside widths join the same file. So part 6.11 proposes the arrangement's half of a mechanism whose window half ships.
- **BR4.2, 2026-09-06, `components/input` and `workbench/vaultview`:** the search field — looking glass, text, optional clear mark; it looks as the user types, marks matches with the highlight token, and the clear mark empties it and dismisses the highlight; vaultview adopted it and the gallery gained the specimen.
- **CI1.1, 2026-09-29, `workbench/vaultview`:** the note column stops taking the keyboard from a rail click.
- **CI1.2, 2026-09-29, `workbench/vaultview`:** a closed find field gives the keyboard back to where it came from.
- **CI1.3, 2026-09-30, `workbench/vaultview`:** the toolbar's magnifier records where the keyboard was, as the shortcut does. With BR4.2 and the two above, the draft's ask for the search field at a tag is met but for one half: nothing records per-keystroke messages carrying the text as landed, and that half stays in the queue (section 10).
- **CI4.1, 2026-10-05, `workbench/vaultview`:** the aside's rows stand at the sidebar's row height, 32 dp, as the tree's rows do since they wear the same pill, the text centred in the row by the row itself with no vertical inset, the backlinks pane's cap and share following the row height.
- **Progress, ruled 2026-10-07, DOMAIN:** progress is the library's — a bar filling from the leading end when the end is known, the platform's indeterminate indicator when it is not, read and never operated, leaving when the task ends.
- **The level meter, ruled out 2026-10-07, DOMAIN:** it is the application's, not the library's; the draft's item stays only as a record of the ask and is not planned.
- **Toolbar, 2026-09-02, DOMAIN:** the strip along the window's top holding the controls that act on the document, its controls in the chrome variant, holding controls and never content — which answers the exploration's question of the strip against the navbar, the navbar staying for the marketing shell.
- **Accordion, 2026-09-02, and Disclosure, 2026-09-30, DOMAIN:** the pattern stacking collapsible sections, and the platform's control that opens and closes what it heads — which answers the draft's "a disclosure group, unless the accordion already stands alone"; what remains is vaultview's Properties pane adopting the accordion.
- **Sidebar, 2026-09-18 and 2026-09-23, DOMAIN:** rows at the sidebar's row height, each a symbol, a title and a trailing count where the entry has one; sections headed by a small heading and parted by space alone; a section is a collection the application keeps apart, never a sorting of one collection by kind; the sidebar is one focusable with its own key traversal; the window buttons inside the pane; the pill measured off Voice Memos and Finder. That is the source list the draft asked for, and the sidebar's fate now turns on ruling 7 rather than on the Language.
- **Pane, Pill, Label, Title and Symbol, 2026-09-30, DOMAIN:** the pane as an inset object a control can send away, the pill as the platform's selection shape, and symbol in place of the retired word.
- **Switch, 2026-10-07 and 2026-10-08, DOMAIN:** a switch is the on/off control alone, the control that recalls a pane is a borderless button with a symbol title, and a chooser between scopes is a segmented control — which names the draft's one-of-few inline choice; the segmented control's own entry is still to write (section 2).
- **Seam and Splitter, ruled 2026-09-06, DOMAIN:** the hairline where two flush regions meet, and that line made operable; the draggable one is a splitter, a control.
- **The library's three-column layout, ruled 2026-09-06:** a layout nobody uses leaves the library, and it has no consumer. So the draft's note to say in a commit body whether it stays or goes is answered — it goes, with the sidebar-header-main and split-pane layouts, once feeds is off them.
- **The band-fill slot with no consumer, measured 2026-10-02:** `PaneFrame.BandFill` is passed by none of the three windows. The finding is not in dispute; whether the field is dropped is ruling 3.
- **The eleven words, 2026-10-10, DOMAIN:** section 2's words answered on the ontology session's recommendation — Shell, Segmented control, Slider, Header, Footer, Button, Text field, Pane, Link and Alert.

**Superseded readings.** Each was written, then overtaken by a later reading in the same pool, and is recorded so it is not read as live.

- **One toolbar across all three columns at one height** (the draft, 2026-09-06), with the window buttons on the pane strip's line — superseded by the exploration and the specification, which read the pane's strip as the pane's own, carrying the window buttons and the pane's marks, and the toolbar as what a content column carries. What stays live is how far the toolbar spans in the three-column arrangement (ruling 2).
- **The pane narrowing in place** (the recorder's own control, 2026-10-02) — superseded the same day by the Voice Memos measurement: the pane translates as one object, no row clipped in place and no title truncated. The recorder is correcting its control to translate.
- **The width-only collapse and expand motion** (the collapse and expand proposal, 2026-10-02: a type the caller spends into `PaneFrame.Width`, the collapsed state staying the caller's `width <= 0`, restated unchanged in the specification) — superseded the same day by the second addendum: the pane pattern's drawing already takes bounds whose leading edge is off the window and the measurement does not, so the motion yields bounds and the measurement functions learn to take a leading edge off the window. The travel is the pane's width plus its margin, 228 dp for a 220 dp pane, not the width alone.

**The recorder's own rulings, kept only as their library halves.** Its owner ruled there on 2026-10-01 that the application changes its shell first and then takes its slices one at a time, each by reading the workbench exemplar, generalising the pattern into the library and adopting it afterwards; on 2026-10-02 that its shell is copied from vaultview first — the pane frame, the pane strip with bare marks, the sidebar helpers' rows and pill, the recall convention — and that what the two windows then share is named so the library extracts one shell pattern both derive from, the copy having landed and the reading of section 6 being what followed; and that the record control is application-special and stays, which is why ruling 33 asks only about the rest of its toolbar. Everything else those rulings settled is the application's own — its task identifiers, its corrections to its own code, its persistence lanes — and is not carried here; where the library inherits something from them it stands above as a part or as a ruling.
