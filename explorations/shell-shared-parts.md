# The shell pattern, as three windows show it — exploration

Received 2026-10-02 from the recorder application outside the org, read
off vaultview's, mindchat's and its own frame side by side. Pool
material beside off-the-shelf-shells.md until the owner shapes it;
nothing here is a dispatch. The application's own name is replaced
throughout by "the recorder".


The specification of what the three windows share, read off the three frames side by side on 2026-10-02, for the library to extract one shell pattern from which all three are derived. It answers the owner's ruling of 2026-10-02 (TRANSCRIPTS 0008, "There has to be a way to make this more DRY"; DESIGN 0032): the recorder copied vaultview's frame first, and what the windows share is now named part by part.

**Three readings, not two.** The ruling names vaultview and the recorder. mindchat is read alongside them because it is the second reading of the same frame already in the library's own tree, and a pattern derived from two windows that agree is a pattern that breaks on the third. Where the three disagree, the disagreement is stated and sent to the owner (§3) rather than averaged.

**The words are the library's.** The strip across the content column's top is the TOOLBAR (it is `band` in the recorder's code today, and `chromeRow` in mindchat's; the library is retiring "band" for it and the identifiers become `Toolbar`, `desktop.BandLead` included, once its sweep runs). The window's own fill under everything is `PaneFrame.Surface`. Both names are the library's current ones; the round the recorder is pinned to (`patterns v1.3.0`) still calls that field `Plane` and still calls the row's name column `sidebar.LabelInset` where head calls it `TitleInset`. Every reference below uses the library's current word and names the pinned one only where a reader of the recorder's source would otherwise not find it.

**What the library already proposes.** The library's own exploration of this shell (vibrantgio, `off-the-shelf-shells`) has the arrangements, the sequence and the open questions already: one pattern with named variants (pane and column; pane, column and aside; and, from the recorder, pane, list and content), the status bar generalised to a foot per column, the pane's own foot slot, the remembered widths and shown state held by the shell, and the slide pooled beside the frame rather than inside it. Nothing here restarts that. This document supplies what the exploration asks for and does not have: the part-by-part reading of the three frames, with each window's site, its line count, what it re-derives, and what the extraction deletes.

**What the library ships today.** `patterns/shell/paneframe.go` is 182 lines: `PaneFrame` (the value), `Bounds`, `ContentX`, `Under`, `Layout`, and `PaneWidthDp`. `patterns/pane/pane.go` is 464 lines: the geometry constants, `Buttons`, `Surface`/`RimColor`/`Shadow`, `Bounds`, `Layout`, `PaintShadow`, `FillTrailingCorners`, `EdgeSpan`, `SeamTop`, `Strip`, `DragSpacer`, `DragFill`. `patterns/sidebar/sidebar.go` is 1100 lines, of which the three windows use the measured parts and helpers: `ExpandedWidth`, `RowHeight`, `SelectionInset`/`SelectionRadius`, `SymbolBox`/`SymbolInset`/`TitleInset`/`CountInset`, `SectionHeight`, `PaintSelection`, `SelectionFill`, `SelectionLabel`, `RowTarget`, `PaintSymbol`, `PaintCount`, `PaintSection`, `SectionStyle`, `SectionForeground`, `SymbolForeground`, `CountForeground`.

---

## §1 — The shared parts

### 1. The frame: Bounds, ContentX, Under, Layout

The window composition a leading pane makes — the window's own fill under everything, the pane one margin inside the leading, top and bottom edges, the content column flush against its trailing side, the toolbar across that column's top and the main content under it.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `frameState.layout`, frame.go:512-666 | `windowFrame.layout`, frame.go:128-212 | `appShell`, shellchrome.go:185-290 |
| measures | `frameGeometry`, frame.go:484-511, over `frameGeom`, frame.go:465-483 | `frame.Bounds` + `shell.ContentX` inline, frame.go:149-150 | `frame.Bounds` + `shell.ContentX` inline, shellchrome.go:183-184 |
| spends | `PaneFrame.Under`, frame.go:556-560 | `PaneFrame.Under`, frame.go:151 | `PaneFrame.Layout`, shellchrome.go:251 |
| lines | 155 + 28 + 19 = 202 | 85 | 106 |

**What already lives in the library.** All of it, in two halves. `PaneFrame.Bounds` and `ContentX` answer the arrangement without laying anything out; `Under` paints the window's fill, the content column's fill, the two corners the pane rounds away from on its flush side, and the pane with its column in it; `Layout` is `Under` plus the three slots plus `pane.PaintShadow` last.

**What each window still re-derives.** vaultview and mindchat spend `Under` and compose their own columns above it, because each has an arrangement `Layout` does not express — vaultview a trailing aside, a foot under the content column, and the note column laid out BEFORE the toolbar over it and replayed after (frame.go:576-585, 609-613: the toolbar carries the find and the find's count is the document's answer); mindchat the transcript laid out before the row over it (frame.go:159-182: a bordered control's cast shadow reaches past the row's foot and a transcript drawn over it would cut it off with a ruled line) and the picker's surface last of all. the recorder spends `Layout`, and pays for it: it re-offsets every rectangle its three slots measured back into window coordinates by hand afterwards (shellchrome.go:253-272, 20 lines), because `Layout` tells the caller nothing about where it put them.

**Proposed shape.** `Layout` gains an op-order it does not have. Three facts the windows agree on and `Layout` cannot express: (a) the main content may be laid out before the toolbar and replayed after it, (b) a slot may be drawn after the shadow, (c) the slots' offsets are worth reporting. Name them concretely:

- `PaneFrame.MainFirst bool` — the main slot is recorded and replayed under the toolbar's ops rather than drawn after them. Two of three windows need it; both state the same reason (a cast shadow, and a count the document settles).
- `PaneFrame.Over layout.Widget` — one slot laid out last, after `PaintShadow`, at the content column's own box. mindchat's picker and the recorder's microphone drop-down are the same thing: a surface that hangs off a toolbar control over the content below it.
- `PaneFrame.Layout` returns a `PaneLayout` value — `Pane`, `ContentX`, `Strip`, `Toolbar`, `Main`, `Foot` as rectangles in WINDOW coordinates. That is `frameGeom` (vaultview) and the geometry half of `chromeObs` (the recorder) generalised, and it is what both windows' probes assert against.

**What the extraction deletes.** vaultview: `frameGeom` and `frameGeometry` (47 lines) outright; `layout` drops to the aside, the foot and the record of what it arranged (~60 of 155). mindchat: `layout` drops to the picker's cap and the transcript (~25 of 85). the recorder: the hand re-offsetting (20 lines) and the arrangement arithmetic in `appShell` (~35 of 106).

### 2. The frame's fills, and the slot nobody fills

Which fill stands where: the window's own, the content column's, and the one behind the pane's two flush-side corners over the toolbar's rows.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| `Surface` | `tok.col.WindowBackground`, frame.go:557 | `t.col.WindowBackground`, frame.go:145 | `tok.color.WindowBackground` (passed as `Plane` on the pin), shellchrome.go:231 |
| `ContentFill` | `tok.col.TextBackground`, frame.go:558 | `t.palette.Transcript`, frame.go:146 | `tok.color.ControlBackground`, shellchrome.go:232 |
| `BandFill` | not passed | not passed | not passed |
| the toolbar's own fill | none; `bandSurface` reports the region under it, frame.go:256-263 | none | none; `chromeBand` paints nothing, headerstrip.go:449-452 |
| what chrome foreground flattens onto | `chromeSurface(tok.col)` per site, main.go:158 | `t.palette` fields per site | `onPlane`/`onContent`/`onChrome`/`onCard`/`onPushButton`/`onField`, palette.go:45-82 |

**What already lives in the library.** The three fields, and `FillTrailingCorners` behind them.

**What each window still re-derives.** The rule "a toolbar carries no fill of its own; its ink flattens onto the region beneath it" is stated three times in three vocabularies — vaultview as a function (`bandSurface`), mindchat as a palette field, the recorder as one of six `on*` helpers. **`BandFill` is passed by none of the three.** It exists for a window whose toolbar paints a fill across the content column, and no window in the family is one.

**Proposed shape.** The `PaneLayout` value of part 1 carries `ToolbarFill color.NRGBA` — what a control standing in the toolbar flattens onto, which is `ContentFill` where `BandFill` is zero and `BandFill` where it is not. One reading, handed to the caller, instead of three derivations. `BandFill` itself goes to the owner (§3, R6): a field with no consumer is either dropped or given one.

**What the extraction deletes.** vaultview `bandSurface` (8). mindchat: nothing in lines, one palette field's reason. the recorder: `onContent` (8 of palette.go) and the per-site judgement of which of the six to call in the toolbar.

### 3. The pane's strip

The band across the pane's top that the window's three control buttons stand inside: their run skipped at the leading end, a stretch that moves the window across the middle, and the pane's own marks at the trailing corner.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| reserved by | `treeView.layout`'s vertical Flex, tree.go:384-454 (Rigid of `pane.StripDp`) | `SidebarPane`'s vertical Flex, view.go:927-970 | `folderPane`'s vertical Flex, folderpane.go:623-719 |
| drawn by | `treeView.topStrip`, tree.go:455-471 | `SidebarStrip`, view.go:971-1000 | `paneStrip`, folderpane.go:720-759 |
| lead | `treeView.buttonEdge`, tree.go:285-295 → `toolbarLeading()` | `stripLead(windowButtonsEnd())`, frame.go:294-301 | `desktop.BandLead(pane.ButtonGapDp, bandInset)` inline, folderpane.go:749 |
| marks | one: the toggle, in the corner | two: toggle, `MarkGapDp` drag spacer, new chat in the corner | two: new folder, `MarkGapDp` drag spacer, toggle in the corner |
| lines | 71 + 17 + 11 = 99 | 44 + 30 + 12 = 86 | 97 + 40 = 137 |

**What already lives in the library.** `pane.Strip(gtx, lead, controls...)` — it skips the lead less the margin, fills the middle with `DragFill`, lays the controls out in reading order and closes with a `DragSpacer(MarginDp)`. `pane.StripDp` (36 dp ≈ 8.3 mm), `pane.MarkGapDp` (18 dp ≈ 4.1 mm), `pane.ButtonGapDp` (17 dp ≈ 3.9 mm).

**What each window still re-derives.** Three things, identically. (a) The reservation: every window reserves `min(gtx.Dp(pane.StripDp), size.Y)` as the first Rigid of the pane's vertical Flex and draws the strip AFTERWARDS, at `layout.Exact(size.X, stripH)`, and every window writes the same paragraph of prose saying why — it is a statement about the keyboard, not about paint (tree.go:440-453, view.go:935-940/966-968, folderpane.go:628-631/712-714). (b) The lead: three spellings of `desktop.BandLead`/`BandLeadFrom` over `pane.ButtonGapDp`. (c) The drag spacer between two marks: `desktop.DragRun(gtx, gtx.Dp(pane.MarkGapDp))` written out at the call site in both two-mark windows (view.go:994-996, folderpane.go:753-755) although `pane.DragSpacer(pane.MarkGapDp)` is exactly that.

**Proposed shape.** `pane.Column(gtx, c, bounds, pane.ColumnSlots{Strip, Head, Rows, Foot})` — one helper that reserves the strip, lays the three optional slots out in reading order, draws the strip last, and reports what it arranged. The marks go in as `pane.Marks(controls ...layout.Widget)`, which interleaves `MarkGapDp` spacers itself, so no caller writes a spacer between two marks again. The lead is not a parameter: `pane.Strip` already knows `ButtonGapDp` and the only thing a caller supplies is the no-buttons fallback inset, so it becomes `pane.StripLead(fallback unit.Dp)`.

**What the extraction deletes.** vaultview `topStrip` (17), `buttonEdge` (11), the reservation and the re-layout in `treeView.layout` (~20 of 71). mindchat `SidebarStrip` (30), `windowButtonsEnd` (12), the reservation in `SidebarPane` (~18 of 44). the recorder `paneStrip`'s Flex half (~18 of 40) and the reservation in `folderPane` (~14 of 97). The strip's probe arithmetic in `paneStrip` (folderpane.go:731-744, 14 lines) is replaced by the `PaneLayout` value's `Marks`.

### 4. The two drawings of a chrome mark: bare on the pane, bordered in the toolbar

One rule with two drawings — a mark standing on the PANE is bare (no capsule, no fill, no rim); a mark standing in the TOOLBAR is the platform's bordered toolbar control — and which one a mark takes is a property of what it stands on, not of the switch it belongs to.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| bare | `paneMark`, frame.go:1182-1206 | `paneMark`, frame.go:416-435, through `paneToggle` 436-439 and `paneNewChat` 440-454 | `paneMark`, folderpane.go:768-797 |
| bordered | `chromeControl`, frame.go:1207-1229, through `railToggleControl` 1151-1181 | `controlBox`, frame.go:455-481, through `sidebarToggle` 386-394 and `newChatMark` 395-415 | `chromeControl`, headerstrip.go:685-711 |
| mark box | `markLargeDp` = 24, main.go:446-450 | `paneMarkDp` = 24, frame.go:103-106 | `markLargeDp` = 24, folderpane.go:760-767 |
| bare foreground | `tok.col.ToolbarLabel` | `t.col.ToolbarLabel` | `tok.color.ToolbarLabel` |
| records state | no | yes: `RenderState.Checked` on the bordered half, frame.go:455-481 | no |
| lines | 25 + 23 + 31 = 79 | 20 + 4 + 15 + 27 + 9 + 21 = 96 | 30 + 27 = 57 |

**What already lives in the library.** The RULE, in `patterns/pane`'s package doc (pane.go:64-70, "the platform's bordered toolbar control is the BAND's drawing, not the pane's", with the measurement off `voicememos-multi-folder-2026-09-18.png`). Nothing draws it. `components/button.BorderedFace` and `BorderedShadow` draw the bordered half's face; `components/icons.Mark` draws the figure.

**What each window still re-derives.** Both drawings, three times, body for body. The bare one is the same twelve lines everywhere: the 24 dp box, `icons.Mark(name)`, `ToolbarLabel`, `pointershape.OverSize`, the three semantic ops, inside the caller's `Clickable`. The bordered one is the same twenty: `button.RenderState{Variant: Chrome, Hovered, Pressed, Focused}`, `BorderedFace`, `BorderedShadow` around the `Clickable` (never inside it — all three state the reason in the same words), the three semantic ops. 24 dp ≈ 5.5 mm is stated three times under three names.

**Proposed shape.** Two functions in `patterns/pane`, one constant:

- `pane.MarkDp` (24 dp) — the box both drawings centre a figure in. One statement; `markLargeDp`, `paneMarkDp` and the recorder's `markLargeDp` all become it.
- `pane.Mark(gtx, c, click, mark icons.Painter, title string) layout.Dimensions` — the bare drawing.
- `pane.ToolbarControl(gtx, c, rad, den, click, mark icons.Painter, title string, checked bool) layout.Dimensions` — the bordered drawing, with `checked` for mindchat's recorded state.

Both take an `icons.Painter` rather than an `icons.Name`, which is what the recorder needs: two of its three pane symbols come from the Material set because `components/icons` has no waveform and no trash can, and it adapts them through its own `iconPainter` (actionbutton.go). A painter-shaped seam removes that adapter from the caller.

**What the extraction deletes.** vaultview 79 lines (all of `paneMark`, `chromeControl`, `railToggleControl`). mindchat 96 (all six). the recorder 57 (both). That is 232 lines of three identical pairs.

### 5. The toolbar across the content column: its depth and its gutters

The strip the content column carries across its top, on the window buttons' line, holding what acts on the document.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `layoutToolbar`, frame.go:867-983 | `chromeRow`, frame.go:213-253 | `chromeBand`, headerstrip.go:433-684 |
| depth | `toolbarHeight()` = `pane.BandDp`, frame.go:244-255 | `ChromeRowHeight` = `2 * windowButtonRun.Center`, theme.go:324-338 | `bandDepth` = `unit.Dp(pane.BandDp)`, headerstrip.go:133-146 |
| leading gutter, pane standing | `noteInsetDp` = 24 dp ≈ 5.5 mm, note.go:61 | `chromeInsetDp` = 12 dp ≈ 2.8 mm, frame.go:79-83 | `bandInset` = 16 dp ≈ 3.7 mm, headerstrip.go:147-149 |
| trailing gutter | `bandTrailingDp` = 8 dp ≈ 1.8 mm, frame.go (const block) | `chromeInsetDp` = 12 dp | `bandInset` = 16 dp |
| gap, two bordered controls | `bandGapDp` = 16 dp ≈ 3.7 mm | `controlGapDp` = 14 dp ≈ 3.2 mm | `bandControlGap` = 8 dp ≈ 1.8 mm |
| gap, bare title to control | `bandNameGapDp` = 14 dp ≈ 3.2 mm | `chromeGapDp` = 12 dp | `bandNameGap` = 16 dp |
| composition | Flex Horizontal, Alignment Middle, Rigid/Flexed(1)/Rigid | the same | the same |
| lines | 117 | 41 | 252 |

**What already lives in the library.** `pane.BandDp` (52 dp ≈ 12.0 mm) and the arithmetic behind it (`2*ButtonInsetDp + desktop.WindowButtonDiameter`); `pane.SeamTop`, which is the row a line between two flush regions starts on, under the toolbar. The toolbar itself: nothing.

**What each window still re-derives.** The depth, three ways, to the same 52: one names `pane.BandDp`, one names it through a local alias, one re-does the arithmetic from `pane.Buttons.Center`. The composition — a horizontal Flex, Middle alignment, a leading cluster of Rigids, one `Flexed(1)` draggable middle, a trailing cluster of Rigids, both gutters as Rigid children rather than an Inset round the Flex (the recorder corrected to that in G1.2.5 and vaultview was already there) — is written out three times. The four gutters and gaps are stated with six different numbers under nine different names, every one of them carrying its own measurement prose (vaultview's const block spends ~85 of its 108 lines on them).

**Proposed shape.** `shell.Toolbar` as a value spent into `PaneFrame.Toolbar`, not a layout call: `shell.Toolbar{Lead []layout.Widget, Trail []layout.Widget, Gutter shell.ToolbarGutter}`. It lays the two clusters out with the measured gaps between them, the draggable middle between the clusters, and the gutters as Rigid children. `shell.ToolbarMetrics` names the four measurements once, as the platform's readings with the captures cited, and a window states a deviation rather than a value. `shell.ToolbarDepth` is `pane.BandDp` and nothing else.

**What the extraction deletes.** vaultview: `toolbarHeight` (12) and the Flex scaffold of `layoutToolbar` (~45 of 117) and ~60 of the const block's gutter prose. mindchat: `ChromeRowHeight` (15) and the scaffold of `chromeRow` (~20 of 41). the recorder: `bandDepth`/`bandInset`/`bandControlGap`/`bandNameGap` (~30 of the const block) and the scaffold of `chromeBand` (~70 of 252 — the Flex, the two gutters, the drag middle, and the trailing group's back-to-front placement arithmetic at headerstrip.go:638-663, which exists only because the window measures where Flex put its own children).

### 6. The toolbar's leading rule

Where the toolbar's own content may start: its gutter in from the content column while the pane stands, and past the window control buttons' run once the pane is away — a measurement in exactly one state.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `layout` chooses, frame.go:600-607; `toolbarLeading()`, frame.go:1007-1019; `frameState.toolbarLeading`, frame.go:344-352 | `chromeLead`, frame.go:280-293; `stripLead`, frame.go:294-301 | inline in `chromeBand`, headerstrip.go:465-487 |
| rule | `lead = 0` standing (the Flex then spends `noteInsetDp`); `desktop.BandLead(pane.ButtonGapDp, frameEdgeDp)` away | `chromeInsetDp` standing; `desktop.BandLeadFrom(buttonsEnd, pane.ButtonGapDp, chromeInsetDp)` away | `max(bandInset, BandLead(ButtonGapDp, bandInset) − ContentX)`, measured in WINDOW columns, both states and every state between |
| static-render seam | `frameState.leading func() unit.Dp`, frame.go:325-334 | `var windowButtonsEnd = desktop.LeadingInset`, view.go:1001-1012 | none: the probe reads the real measurement |
| lines | 13 + 9 + 8 = 30 | 14 + 8 + 12 = 34 | 23 |

**What already lives in the library.** `desktop.BandLead(gap, fallback)` and `desktop.BandLeadFrom(buttonsEnd, gap, fallback)`; `pane.ButtonGapDp` as the air a toolbar owes the buttons.

**What each window still re-derives.** The choice between the two rules, and the fact that both halves of the pane's switch must lead from one window column so the control does not move under the pointer — stated in all three files in nearly the same sentence. Two of the three read the rule as a FLAG at either end, which is correct only while the pane arrives and leaves in one frame; the recorder had to correct it to the larger of the two measured in window columns when the slide landed (G1.2.7), because read as a flag the toolbar's leading edge steps about 80 dp ≈ 18.4 mm at the instant the pane reaches zero. Two of three also carry a pinning seam so a stored render does not depend on a live window's measurement, in two different shapes (a function field on the frame; a package-level variable).

**Proposed shape.** One function, and it is the corrected one: `shell.ToolbarLead(gtx, bounds image.Rectangle, fallback unit.Dp) unit.Dp` — the larger of the toolbar's own gutter and the inset past the buttons' run, both expressed as columns of the window, which is the same answer at both rests and passes between them without a step. It ships with the slide (part 12) because that is when the flag reading breaks, and it ships even for a window with no slide because a flag that happens to be correct is still the wrong statement. The pinning seam becomes `desktop.PinLeadingInset(unit.Dp)` in `mvu/desktop`, one shape for both windows' needs.

**What the extraction deletes.** vaultview 30 lines and the `leading` field off `frameState`. mindchat 34. the recorder 23.

### 7. The recall convention and its halves

A control that travels with the pane cannot be the one that recalls it: the pane's own controls ride its strip, and the control that brings the pane back stands in the toolbar — two halves of one switch rather than duplicates of one control, wearing one figure at one size on one line.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| halves | one switch: hide / show | two switches: the pane's toggle, and new chat (the primary act, which survives the pane going) | two switches: the pane's toggle, and new folder |
| pane half | `treeView.hideControl`, tree.go:472-487 | `paneToggle`/`paneNewChat`, frame.go:436-454, spent by `SidebarStrip` | `paneMark` calls in `paneStrip`, folderpane.go:750-757 |
| toolbar half | `layoutRailToggle`, frame.go:1138-1150 | `toggleControl`/`newChatControl`, frame.go:348-385 | the `bandCarriesPaneControls` branch of `chromeBand`, headerstrip.go:514-533 |
| when the toolbar half stands | `m.SidebarHidden` | `m.SidebarHidden` | `bandCarriesPaneControls(view, m)`, headerstrip.go:282-296 |
| gesture source | TWO `Clickable`s per switch (`frameState.toggleClick`, `treeView.hideClick`) | TWO per switch, deliberately: "a control and its recalling half are two clickables, not one shared one", frame.go:114-120 | ONE per switch: `hw.pane.toggle` and `hw.pane.create`, drawn bare in the strip and bordered in the toolbar, drained once by `paneClicks`, folderpane.go:478-521 |
| figure | `icons.Sidebar`, both halves | `icons.Sidebar` and `icons.Plus`, both halves | `icons.Sidebar` and `icons.Plus`, both halves |
| lines | 16 + 13 = 29 | 19 + 38 = 57 | 8 + 20 = 28 |

**What already lives in the library.** The convention, as prose, in `patterns/pane`'s package doc (pane.go:72-79: "What the package fixes is the geometry both halves stand on"). No code.

**What each window still re-derives.** Which half stands where, per switch, per state; that both halves wear one figure; and the message each dispatches. Two of the three carry two `Clickable`s per switch and one carries one — and only one of the two halves is ever on screen at a time, so the two-`Clickable` arrangement is a second gesture source for one affordance with nothing gained. the recorder's is the DRY reading and the one that matches the project's loop discipline: one gesture source, one `MessageOp` through the one update.

**Proposed shape.** `shell.Switch` as a value the window holds, not a widget: `shell.Switch{Click *widget.Clickable, Mark icons.Painter, PaneTitle, ToolbarTitle string, Message any, Checked bool}`, and `shell.Switches []Switch` carried on `PaneFrame`. The frame draws them bare at the pane's trailing corner while the pane stands and bordered at the toolbar's leading end while it is away, in the declared order, and it is the frame — not each window — that knows which state puts them where. One `Clickable` per switch is the type's shape, which settles R8 by construction if the owner rules that way.

**What the extraction deletes.** vaultview 29, mindchat 57, the recorder 28 — and, in each, the branch in the toolbar's composition that decides whether the halves stand there at all.

### 8. The window's drag over the chrome's empty runs

Under the full-size-content treatment the native title bar hands over no window drag, so the toolbar and the pane's strip claim it back over the parts of themselves that hold no control — and only over those, since a move action swallows the press before any control beneath it sees one.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| fixed gap | `dragSpacer`, frame.go:1020-1030 | `dragSpacer`, frame.go:482-489 | inline closure per spacer, headerstrip.go:503-509 |
| flexible middle | `dragFill`, frame.go:1031-1036 | `dragFill`, frame.go:490-492 | inline closure, headerstrip.go:593-597 |
| strip's | `pane.Strip` supplies both | `pane.Strip` supplies both; the mark gap written out, view.go:994-996 | `pane.Strip` supplies both; the mark gap written out, folderpane.go:753-755 |
| lines | 17 | 11 | ~14 spread over four call sites |

**What already lives in the library.** `pane.DragSpacer(w unit.Dp)` and `pane.DragFill` — pane.go:447-464, byte for byte what all three windows wrote for themselves. `desktop.DragRun(gtx, px)` under both.

**What each window still re-derives.** Both of them, in all three windows, from a package every one of them already imports. This is the clearest single duplication in the family: two exported functions, three private copies, zero behavioural difference.

**Proposed shape.** None needed. The library already ships it; `shell.Toolbar` (part 5) spends `pane.DragSpacer`/`pane.DragFill` internally so no window names them either.

**What the extraction deletes.** vaultview 17, mindchat 11, the recorder ~14.

### 9. The pane's column: the row, the pill, the symbol, the count, the section

The column standing inside the pane: rows at the platform's sidebar pitch with the symbol, the name and the trailing column each where the platform draws it, the platform's pill under the selected row, and a section heading where the collection divides.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| row | `treeView.drawRow`, tree.go:675-769, in `rows`' `LayoutSelectable` callback, tree.go:488-579 | `ChatRow`, view.go:1130-1281, in `railState.layout`, view.go:878-920 | `folderPaneRow`, folderpane.go:859-937, in `folderPane`'s list callback, folderpane.go:646-679 |
| pitch | `sidebar.RowHeight` | `sidebar.RowHeight` | `sidebar.RowHeight` (32 dp ≈ 7.4 mm) |
| pill | `sidebar.PaintSelection` + `SelectionFill` + `SelectionLabel` | `sidebar.PaintSelection` | `sidebar.PaintSelection` + `SelectionFill` + `SelectionLabel` |
| emphasis | the rail's own focus tag decides, tree.go:528 | the rail's own focus tag decides, view.go:899 | always emphasized: the pane is on no focus ring, folderpane.go:873-881 |
| symbol | `sidebar.PaintSymbol` + `SymbolForeground` | hand-drawn, `drawChatSymbol`, view.go:1299 | `sidebar.PaintSymbol` + `SymbolForeground`, through `paneRowMark`, folderpane.go:798-820 |
| name column | `sidebar.TitleInset` + the tree's own indent | `sidebar.TitleInset` via an `Inset` | `sidebar.TitleInset` (`LabelInset` on the pin) |
| name role | `tok.typ.BodyMedium` | the palette's own | `tok.typ.LabelLarge` — the role the pattern sets a row's name in and measures the count against |
| count | none | none | `sidebar.PaintCount` + `CountForeground` |
| section | none (the run is deliberately unheaded, tree.go:80-82) | none ("a list with exactly one section does not announce itself", view.go:931-933) | one: `paneSectionBlock` over `sidebar.PaintSection`, folderpane.go:833-858 |
| target | `sidebar.RowTarget` + a `gesture.Click` per row | `sidebar.RowTarget` + a `gesture.Click` per row | a `widget.Clickable` per row |
| row's own extras | disclosure, indent, the find's highlight (`drawFound`, 42) | rename and delete marks, the stream dot | none |
| lines | 95 + ~45 of 92 = 140 | 152 + 43 = 195 | 79 + 14 + 12 + 12 + ~35 of 97 = 152 |

**What already lives in the library.** Every measurement and every painter, and all three windows use them — this is the part the library has already extracted furthest. What it does not have is the ROW: the order the painters are called in, the flattening of each foreground onto the fill the row actually lands on, the count owning its column so the name truncates against it, and the heading laid out OUTSIDE the row's click target.

**What each window still re-derives.** That order, three times, with three different answers to the same questions: which type role a row's name takes (two windows disagree with the pattern's own), whether the symbol comes from the pattern's painter or from the window's own drawing, and whether the row's target is a `gesture.Click` (so the whole rail is one focus stop) or a `widget.Clickable` per row (so the rows are not on the ring at all).

**Proposed shape.** `sidebar.Row` as a recipe, not a `layout.Widget`: `sidebar.Row{Symbol icons.Painter, Label string, Count string, Selected, Unemphasized bool, Fill color.NRGBA}` and `sidebar.PaintRow(gtx, shaper, c, typ, row) sidebar.RowGeom`. It calls the painters in the order the platform draws them, flattens every foreground onto the right fill, lets the count own its column, and returns the geometry the probes assert (`RowGeom` is the recorder's `paneRowGeom` — the row's box, the symbol's box, the name's first column, the count's column, the pill and its radius). `sidebar.PaintSectionBlock(gtx, shaper, c, typ, heading)` wraps the `SectionHeight` block round `PaintSection` so no window states the block.

The pattern keeps the extras OUT: vaultview's disclosure and indent, its find highlight, mindchat's two row marks and its stream dot are each a `layout.Widget` the recipe takes as a leading or trailing slot (`sidebar.Row.Before`, `sidebar.Row.After`), not a case in the pattern.

**What the extraction deletes.** vaultview ~55 of `drawRow`'s 95 (the symbol, the name, the trailing run and the flattening; the disclosure, the indent and `drawFound` stay). mindchat ~70 of `ChatRow`'s 152 (the pill, the pitch, the name's column and the symbol; the two marks and the dot stay). the recorder `folderPaneRow` to ~20 of 79, `paneRowText` (12) and `paneSectionBlock` (14) outright.

### 10. The pane's foot and the column's foot

Two foot slots, optional, taking no height when empty: one inside the pane under its rows, one under the content column.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| pane's foot | none; the vault's acts moved to the toolbar | `SidebarFooter`, view.go:1013-1057: a hairline the pane's width, then a `FooterRowHeight` row (46 dp ≈ 10.6 mm) with the gear and "Settings" | the new-folder flow's name row and the refusal line, `folderPane`'s trailing children, folderpane.go:684-706, drawn only while the flow is open |
| column's foot | `layoutStatusBar`, status.go:129, at `statusBarHeight(tok)`, status.go:81-83 (one `LabelMedium` line box plus `2*sp.S1`) | none | `shellFooter`, shellchrome.go:325-364, at `shellFooterHeight` = 32 dp ≈ 7.4 mm |
| spent at | `op.Offset(contentX, footTop)`, `Exact(size.X−contentX, size.Y−footTop)`, frame.go:617-625 | — | the last Rigid of `shellMain`'s vertical Flex over the content column, shellchrome.go:299-312 |
| lines | ~10 of `layout` + 3 (the height) | 45 | 40 + ~25 of `folderPane` |

**What already lives in the library.** Nothing for either. `pane.SeamTop` knows where a flush region's seam starts, which is the toolbar's lower edge, and that is the only neighbouring fact the library has.

**What each window still re-derives.** The geometry of a foot under the content column, twice, identically: offset by where the column begins and by the column's height less the foot's, at exactly the column's width — never the window's, because the pane runs past it to the window's bottom edge. The two windows disagree only on the depth (a derived line box against a flat 32 dp) and on what stands in it. The pane's own foot is drawn once, in mindchat, with the hairline rule stated there ("the hairline is the pane's OWN, drawn inside its outline and running only the pane's width") and the recorder drawing the same hairline-then-row shape for a different payload (`divider` + `paneNameRow`, folderpane.go:689-705).

**Proposed shape.** Two slots and one rule, which is exactly what the library's exploration already proposes (the status bar generalises to a foot per column; the pane gains its own foot slot). Name them: `PaneFrame.Foot layout.Widget` — laid out across the content column at the depth it reports, with the main slot taking what is left — and `pane.ColumnSlots.Foot` (part 3) — a hairline the pane's width followed by the slot, taking no height when the slot is nil. `shell.FootSeam(gtx, c)` draws the one hairline both feet want, so neither window states which separator token it is.

**What the extraction deletes.** vaultview ~10 lines of offset arithmetic in `layout`. mindchat the hairline and the row scaffold of `SidebarFooter` (~15 of 45). the recorder the Flex and the offset bookkeeping in `shellMain` (~20 of 27) and the hairline in `folderPane`.

### 11. The remembered width and the hidden state

What the window keeps of its own arrangement across launches: how wide the pane stands, and whether it stands at all.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| width | state: `frameState.railW`, moved by a splitter, defaulting to `treeWidthDp` = 240 dp ≈ 55.2 mm | constant: `SidebarWidth` = `sidebar.ExpandedWidth` = 220 dp ≈ 50.6 mm, theme.go:202-210 | constant: `paneWidth` = `shell.PaneWidthDp` = `sidebar.ExpandedWidth`, folderpane.go:539-556 |
| width kept | yes: `columnMemory`, remember.go (254 lines) — `layout.json` in the OS config directory, debounced 500 ms, clamped on read, written again as the window goes away | n/a | n/a |
| hidden kept | **no** — `m.SidebarHidden` is toggled (model.go:506) and never persisted | yes — `Model.SidebarHidden`, "remembers across launches", messages.go:125-127, through the config | yes — `appConfig.FolderPane *bool`, libraryconfig.go:74-78, `savePaneVisible` 167-171, `resolveFolderPane` 291-300 |
| reported | every frame, last: `f.widths.record(...)`, frame.go:656-658 | on the toggle | on the toggle, `persistPaneCmd`, folderpane.go:342-364 |
| lines | ~254 + 8 | ~12 | ~45 |

**What already lives in the library.** `mvu.RememberFrame(win, appName)` keeps the WINDOW's own frame — its size and its place on the desktop — and all three windows call it. Nothing keeps the arrangement INSIDE the window.

**What each window still re-derives.** The one window with a draggable pane writes a whole file to keep its width, with its own debounce, its own clamping-on-read, its own NaN guard and its own write-on-destroy; the two windows with a fixed pane keep the shown flag through their own application config in two different shapes. And the three disagree on whether the flag is kept at all: vaultview forgets it, and a reader who sends the rail away finds it back on the next launch.

**Proposed shape.** `shell.RememberArrangement(appName string) (*shell.Arrangement, error)`, next to `mvu.RememberFrame` and with its debounce — `shell.Arrangement` holding `PaneWidth unit.Dp`, `PaneShown bool` and, for the third arrangement the recorder's exploration asks for, `ListWidth unit.Dp`, each clamped on read against bounds the caller states. The frame reports to it; the window reads it at launch and passes nothing else. That is the exploration's point 4 ("the pane's width and shown state and the list's width remembered by the shell; the application persists nothing of the frame"), and it settles R9 by making forgetting the flag impossible.

**What the extraction deletes.** vaultview: `remember.go` entire (254 lines), less the `clampRail`/`clampAside` bounds it hands the shell. mindchat: the `SidebarHidden` lane through `Config`, `Init` and `Update` (~12). the recorder: `appConfig.FolderPane`, `savePaneVisible`, `resolveFolderPane`, `persistPaneCmd`, `msgPanePersisted`, `withFolderPane` (~60).

### 12. The slide

The pane's width swept between its two rests rather than switched, so the content column reflows, the toolbar re-measures, the pane's corners move and the shadow casts from the new bounds — every one of them from the one number the arrangement is already derived from.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | none: `Hidden` is a flag | none: `Hidden` is a flag | `paneslide.go` entire, 188 lines, one app-local control |
| what it supplies | — | — | `(*paneSlide).width(gtx, standing, mo) unit.Dp`, paneslide.go:66-105 |
| sweep | — | — | `effects/tween` between 0 and `paneWidth` over `MotionScale.DurNormal` (250 ms) on `EaseStandard`, reversal from the drawn width, one frame asked for per frame while moving and none at rest, instant under the reduced scale |
| its own arithmetic | — | — | `bezierEase`, paneslide.go:130-188 (59 lines): the CSS cubic-bezier solve, because nothing in the library evaluates a `tokens.Bezier` |

**What already lives in the library.** `PaneFrame.Width unit.Dp` — which is the whole seam a slide needs. `effects/tween`. `tokens.MotionScale` with its durations and `tokens.Bezier` with its control points and no arithmetic.

**What each window still re-derives.** One window carries the control and the other two cannot animate at all. The 59 lines of `bezierEase` are the sharpest finding: the theme publishes the easing family's control points and nothing in the library evaluates them, so every consumer that wants the theme's curve writes the solve.

**Proposed shape.** Three parts in increasing reach, already pooled in the library's exploration and restated here unchanged because the reading has not moved:

- `tokens.Bezier` gains `At(t) float64`. Needed by every consumer of the easing family whether or not a pane slides; it is what deletes 59 of the recorder's 188 lines.
- `effects/tween` gains an eased constructor over that evaluator.
- A slide ships BESIDE the frame, not inside it: `pane.Slide` — a small exported type the caller holds and spends into `PaneFrame.Width`, with `Hidden` staying the caller's `width <= 0`. The frame stays a value built fresh every frame with no lifetime, and the same slide drives an aside without the frame knowing. `shell.ToolbarLead` (part 6) ships with it as the one rule the sweep forces.

**What the extraction deletes.** the recorder: `paneslide.go` and its four tests, and the row leaves `make controls`. vaultview and mindchat delete nothing and gain the slide.

### 13. The splitter on the pane's trailing edge

A boundary the reader may move, drawn where the pane's own rim runs straight, thickening under the hand that takes it.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `railProps` 707-755, `layoutRailSplitter` 756-776; and the aside's pair, `asideProps` 799-845, `layoutAsideSplitter` 777-798 | none | none: the pane is a sidebar, not a split view (DESIGN 0024 §1) |
| line at rest | the pane's own rim, `pane.RimColor` over the rows `pane.EdgeSpan` reports | — | — |
| bounds | the rail's own clamp and the note column's floor (`noteFloor`, frame.go:693-706) | — | — |
| lines | 49 + 21 + 47 + 22 + 11 + 10 = 160 | 0 | 0 |

**What already lives in the library.** `pane.EdgeSpan` (the rows the trailing edge runs straight, so a line neither crosses a rounded corner nor leaves a pixel out on the window's surface) and `pane.SeamTop` (the row a flush region's seam starts on) exist FOR this, and `patterns/splitter` draws the hand-hold. What is missing is the composition: the props, the clamps, and the conversion of a dragged pixel back to a kept dp.

**What each window still re-derives.** Only one window has one, so there is no duplication to remove — but there is a pattern to state, because the exploration already rules that the pane stands on a splitter in the shipped shell and the other two windows will then have one. The parts worth fixing before two more copies exist: the boundary is the rim's own LEADING edge and not the pane's trailing one; the line runs exactly `EdgeSpan`'s rows; the hand-hold runs the same rows as the line; the clamp is the pane's own bounds with the content column's floor over them; and `pxPerDp` is how a reported pixel becomes a kept dp.

**Proposed shape.** `PaneFrame.Resize *shell.PaneResize` — nil for a window whose pane is fixed, which is two of three today. It holds the `splitter.State`, the bounds (`Min`, `Max` in dp) and the content column's floor, draws the hand-hold over `EdgeSpan`'s rows in `pane.RimColor`, and reports the new width to the `shell.Arrangement` of part 11. `shell.PxPerDp(gtx)` carries the metric once.

**What the extraction deletes.** vaultview ~110 of its 160 (the rail's half entire; the aside's splitter stays as the aside's own until the aside becomes a slot — see §2).

### 14. The window buttons' placement and the full-size-content treatment

The three control buttons are measured from the window's own glass and from nothing drawn beneath them, and under the full-size-content treatment the application places them and owns the strip they stand in.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| options | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1100, 800)`, main.go:66-69 | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1024, 768)` + `app.MinSize(575, 256)`, main.go:45-49 | `desktop.FullSizeContent()` + `app.Title` + `app.Size(1100, 760)` + `app.MinSize`, main.go:574-578 |
| re-asserted | `desktop.ShowWindowButtons(mvuWin)`, main.go:89 | `desktop.ShowWindowButtons(mvuWin)`, main.go:63 | `desktop.ShowWindowButtons(w)`, main.go:595 |
| placed | per screen: `placeWindowButtons(buttonPlacementFor(m))`, main.go:388-399 over `buttonPlacement` 290-307 and `buttonPlace atomic.Value` — the picker screen asks for none | once: `desktop.PlaceWindowButtonsAt(WindowButtonInset, WindowButtonCenter)`, main.go:64, over `windowButtonRun = pane.Buttons`, theme.go:314-323 | once: `desktop.PlaceWindowButtonsAt(pane.Buttons.Leading, pane.Buttons.Center)`, main.go:603 |
| top inset | `chromeHeight()`/`underChrome`/`insetTop`, main.go:346-376 (24) — overlays clear the larger of the laid-out band and `desktop.TopInset()` | — | retired in G1.2.5: `desktop.TopInset()` reports zero and `shellTopInset` went with it |
| lines | ~24 + 48 = 72 | ~12 | ~10 |

**What already lives in the library.** `pane.Buttons = desktop.ButtonRunAt(pane.ButtonInsetDp)` — the whole run, derived from the platform's measured 19 dp inset; `desktop.FullSizeContent()`, `ShowWindowButtons`, `PlaceWindowButtonsAt`, `LeadingInset`, `TopInset`.

**What each window still re-derives.** The three-call sequence, with the placement spelled three ways — the run's fields, a local alias of them, and the run itself. One window needs the placement to be per screen, because a screen that lays out under the native strip must ask for no placement at all, and it carries 48 lines of its own to make that idempotent. One window still carries 24 lines of overlay inset arithmetic for a mixed case the other two do not have.

**Proposed shape.** `shell.PaneWindow(opts ...app.Option) []app.Option` — the treatment's options with the caller's appended — and `shell.StandWindowButtons(win)`, which both re-asserts and places at `pane.Buttons` in one call, idempotently, and takes an optional `func() bool` for a window with a screen that wants the native strip instead. That is what vaultview's 48 lines are, generalised, and it is what the other two windows wrote three lines of each because they have only one screen.

**What the extraction deletes.** vaultview ~48 (`buttonPlacement`, `buttonPlacementFor`, `buttonPlace`, `placeWindowButtons`). mindchat ~10 and the `WindowButtonInset`/`WindowButtonCenter` aliases. the recorder ~6.

### 15. The shadow cast last

The ramp the pane casts falls on what stands AROUND it, and a column that paints its own fill after the pane has laid out would cover it — so the shadow is painted after every column has painted, with the pane's own box cut out of the drawing so the late call lands what an early one landed.

| | vaultview | mindchat | the recorder |
|---|---|---|---|
| site | `pane.PaintShadow(gtx, tok.col, g.pane)` after the columns and before the splitters, frame.go:634-638 | `pane.PaintShadow(gtx, t.col, bounds)` after the picker, frame.go:188-194 | `PaneFrame.Layout` casts it, shellchrome.go:251 |
| lines | ~5 + 12 of prose | ~2 + 7 of prose | 0 |

**What already lives in the library.** `pane.PaintShadow`, and the reason stated twice — once in `pane`'s doc (pane.go:280-296) and once in `PaneFrame.Layout`'s (paneframe.go:146-153).

**What each window still re-derives.** The call, and the paragraph explaining it, in the two windows that compose their own columns. The paragraph is nearly word for word the same in both (frame.go:634-638 against frame.go:188-193), and both are restatements of the library's own.

**Proposed shape.** `PaneFrame.Under` already paints everything beneath the columns; its counterpart is `PaneFrame.Over(gtx, c, bounds)` — the shadow, and anything else the frame owes after a caller's own columns. A window that composes its own arrangement then spends `Under` first and `Over` last and states no reason, because the pair's names are the reason.

**What the extraction deletes.** vaultview 17 (the call and its prose), mindchat 9. the recorder nothing: `Layout` already does it.

---

## §2 — What each window keeps as its own

The pattern leaves slots for these; it does not absorb them. Each is named with the slot it arrives through, so the extraction has somewhere to put it.

**vaultview.**

| kept | what it is | the slot |
|---|---|---|
| the backlinks aside | a trailing FLUSH chrome column, 320 dp ≈ 73.6 mm, absolute width, parted from the note by a plain seam (`asideProps`' prose, frame.go:799-824); `aside.go`, 675 lines | the aside variant's own slot — the exploration's "pane, column and aside"; an empty aside takes no width |
| the aside's splitter | the trailing boundary, line from the toolbar's foot to the window's, hand-hold over the document row alone | `shell.AsideResize`, the counterpart of part 13's `PaneResize` |
| the status bar | one `LabelMedium` line box plus `2*sp.S1`, holding the note's line count and what the window is showing; `status.go`, 145 lines | `PaneFrame.Foot` (part 10) |
| the find in the page | the toolbar carries the field and the note marks the matches; `bandFind` (frame.go:264-277), `find.go` 331 lines, the field built per frame for the count's sake (frame.go:430-460) | a `shell.Toolbar.Trail` `layout.Widget`, with `MainFirst` (part 1) carrying the ordering the count needs |
| the window's navigation | the segmented back/forward pair, `layoutNavigation` 35 + `navSegment` 21 | `shell.Toolbar.Lead` widgets |
| the note's name | bare text in the toolbar, `layoutNoteName` 26 + `noteName` 9 + `vaultName` 10 | a `shell.Toolbar.Lead` `layout.Widget` |
| the tree's own row parts | the disclosure, the per-depth indent, the find's highlight (`drawFound` 42, `foundRun` 17, `runWidth` 17) | `sidebar.Row.Before` and the row's own name painter (part 9) |
| the note column | `note.go`, 1057 lines | `PaneFrame.Main` |

**mindchat.**

| kept | what it is | the slot |
|---|---|---|
| the pane's footer | a hairline the pane's width and one 46 dp row with the gear and "Settings"; Settings stands here and nowhere else, and `Cmd-,` is how it is reached while the pane is away | `pane.ColumnSlots.Foot` (part 10) |
| the chat title | the window's one orientation cue once the pane is away, with a muted placeholder for an unnamed chat and `titleMaxDp` = 360 dp ≈ 82.8 mm; `chatTitle` 23 + `titleVerdict`/`chatTitleText` 23 | a `shell.Toolbar.Lead` `layout.Widget` |
| the model picker | a reserved cap in the toolbar whose surface hangs over the transcript, drawn last; `chromeRow`'s reservation (frame.go:229-240) + `layoutPicker` 26 + `modelmenu.go` 259 | a `shell.Toolbar.Trail` `layout.Widget` for the cap, `PaneFrame.Over` (part 1) for the surface |
| the row's two marks and the stream dot | rename and delete revealed on the active row, the pulse on a streaming chat | `sidebar.Row.After` (part 9) |
| the transcript and the input bar | `ChatPane` + `messages.go` + `markdown.go` | `PaneFrame.Main` |
| the undo bar | a transient surface bottom-centre over the transcript | the main slot's own; it is not chrome |

**the recorder.**

| kept | what it is | the slot |
|---|---|---|
| the record control | the one control the toolbar's trailing end exists for: start/stop, the pause beside it while the take runs, Cancel and Done on a stopped take; `recordstrip.go` 1261 lines, `recordTargetDp` 44 dp ≈ 10.1 mm centred in the 52 dp toolbar with 4 dp either side | a `shell.Toolbar.Trail` `layout.Widget` |
| the microphone picker | the button in the toolbar's trailing group and the drop-down that overhangs the content below it; `devicepick.go` 758 lines, drawn after the frame and its shadow (shellchrome.go:274-279) | a `shell.Toolbar.Trail` `layout.Widget` for the button, `PaneFrame.Over` (part 1) for the drop-down — the same slot mindchat's picker needs |
| the live level meter | stands between the microphone and the record control while the take runs; `bandMeterBar` 15 | a `shell.Toolbar.Trail` `layout.Widget`, conditional |
| the bottom chrome strip | the gears at the leading edge and the model cluster beside it, one line of state about the models, the whole cluster dispatching `msgSettingsOpen`; `shellFooter` 40 + `modelCluster` 73 + `footerModelState` 32 + `arrivalBar` 29 + `gearsButton` 9 | `PaneFrame.Foot` (part 10) — the same slot vaultview's status bar needs |
| the search field | `components/input.SearchField` in the Chrome variant's Toolbar recess, beside the folder's name, 200 dp wide, with the collision rule that the name yields (`bandNameRoom` 35) | a `shell.Toolbar.Lead` `layout.Widget`; the collision rule is the toolbar's (part 5), the field is the window's |
| the opened session's acts | Delete and Reveal after the name on the transcript view; `bandIconButton` 14 + `iconButtonOn` 27 | `shell.Toolbar.Lead` widgets — but see R16: they are the app's own hover-pill icon buttons today, not the platform's bordered control |
| Recently Deleted's Empty | the act over the whole listing, beside the name of the listing it acts on; `trash.go` 435 | a `shell.Toolbar.Lead` `layout.Widget`, conditional |
| the way back | the folder's name as a control on the three views that replace the list, with its pill's air spent outside the gutter so the text column does not move; `bandBackName` 73 | a `shell.Toolbar.Lead` `layout.Widget` |
| the four views and the per-view table | which view is on screen and what the toolbar carries there; `shellView` 19, `viewHasPane` 6, `bandCarries*` 58, `bandKinds` 49 | the window's own: it is what fills `shell.Toolbar.Lead`/`Trail` per frame |
| the pane's new-folder flow | the name row and the in-place refusal at the pane's foot while the flow is open; `paneNameRow` 60 | `pane.ColumnSlots.Foot` (part 10) — the same slot mindchat's Settings row needs |
| the pane's counts, symbols and heading | the session counts, the waveform and bin marks the library's set lacks, the "Folders" heading | `sidebar.Row`'s `Count` and `Symbol` (part 9) |

---

## §3 — Open rulings for the owner

Each is a place the three windows disagree, or a slot with no consumer. The three readings are given, then a recommendation.

| # | the question | vaultview | mindchat | the recorder | recommendation |
|---|---|---|---|---|---|
| R1 | The toolbar's leading gutter while the pane stands | `noteInsetDp` 24 dp ≈ 5.5 mm (the note column's own inset, so the title stands over the first glyphs under it) | `chromeInsetDp` 12 dp ≈ 2.8 mm (the transcript's row inset, same reason) | `bandInset` 16 dp ≈ 3.7 mm (the app's own, shared with the bottom strip) | The rule is right in all three and only the number differs: the toolbar's leading gutter IS the content column's own inset, so it is the window's to state and the pattern's to spend. Ship `ToolbarMetrics.Lead` with no default and make the window name it. |
| R2 | The toolbar's trailing gutter | `bandTrailingDp` 8 dp ≈ 1.8 mm, MEASURED in all four stored toolbar windows | `chromeInsetDp` 12 dp | `bandInset` 16 dp | 8 dp. It is the one gutter the platform measures identically in four captures, and unlike R1 it is not derived from the column's content. the recorder's 16 was carried over from the retired header strip; the record control moves 8 dp ≈ 1.8 mm trailing-ward when it changes, which is a look to be seen before it lands. |
| R3 | The gap between two bordered controls standing apart | `bandGapDp` 16 dp ≈ 3.7 mm (Finder's, and the one in `reference/macos/controls.md`) | `controlGapDp` 14 dp ≈ 3.2 mm (Notes', "the closer of the two, which is what a pair belonging together takes") | `bandControlGap` 8 dp ≈ 1.8 mm | Two measurements, two meanings: 16 between two controls that are merely adjacent, 14 between two that belong together. Ship both — `ToolbarMetrics.ControlGap` 16 and `ToolbarMetrics.PairGap` 14 — and retire the recorder's 8, which matches no capture. |
| R4 | The gap between a bare title and a bordered control | `bandNameGapDp` 14 dp ≈ 3.2 mm, MEASURED twice in Finder | `chromeGapDp` 12 dp | `bandNameGap` 16 dp | 14 dp. It is the only measured room between a bare title and a bordered control in any stored band, read on both appearances. |
| R5 | Which mark takes the pane's trailing CORNER | one mark: the toggle, in the corner | new chat in the corner, the toggle inboard | the toggle in the corner, new folder inboard | the recorder's order. `patterns/pane`'s own measurement (pane.go:64-70, the Voice Memos capture: new folder at x 209-230, the toggle at x 252-271) puts the primary act leading and the toggle in the corner. mindchat's is reversed and should flip. |
| R6 | `PaneFrame.BandFill` — a slot nobody fills | not passed | not passed | not passed | Drop it. Three windows, zero consumers, and `Under` carries 12 lines of corner-splitting for it. If a window later paints a fill across its toolbar, the field comes back with that window as its reason. |
| R7 | Where the application-level act (Settings) lives | nowhere in the chrome; the vault's acts are in the toolbar | the pane's foot, and `Cmd-,` while the pane is away | the content column's foot, always reachable | Both feet are slots (part 10) and the pattern rules neither. But the owner should rule the PRINCIPLE: an act that survives the pane going away may not live only in the pane's foot. mindchat's answer leans on a chord; the recorder's answer is reachable in every state. Recommendation: the column's foot, with the pane's foot for acts that belong to the pane's own collection (the recorder's new-folder flow). |
| R8 | One `Clickable` per switch, or two | two | two, deliberately | one | One. Only one half of a switch is ever on screen, so the second `Clickable` is a second gesture source for one affordance, and this project's own discipline is one source dispatching one `MessageOp` through the one update. `shell.Switch` (part 7) carries one, which settles it by construction. mindchat's stated reason should be answered in the same breath. |
| R9 | Is the pane's shown state kept across launches | **no** | yes | yes | Yes, and by the shell (part 11), not by three application configs. A reader who sends the pane away and finds it back on the next launch is reading a defect. |
| R10 | Is the toolbar's depth named once | `pane.BandDp` | `2 * windowButtonRun.Center` | `unit.Dp(pane.BandDp)` | One name: `shell.ToolbarDepth = pane.BandDp`. mindchat's arithmetic arrives at the same 52 dp ≈ 12.0 mm and is a second statement of a measurement the pattern owns. |
| R11 | Is the pane's column a keyboard stop | yes: one focus target, arrows walk the rows, the pill goes emphasized while it holds the keys | yes, the same | **no**: the pane is on no ring (`focusfence.go`), so the unemphasized pill can never be shown and the emphasized one is drawn always | The pattern's own rail is one keyboard stop and two of three windows are. the recorder's pane should join the ring — which means `sidebar.RowTarget` and a `gesture.Click` per row rather than a `widget.Clickable` per row (part 9). This is the ruling already recorded under G1.2.6 and it decides what `sidebar.Row` takes. |
| R12 | Does the pane stand beside every view, or per view | per screen: the picker screen has no frame at all | always | per view: `viewHasPane(view)` is `view == viewHome` only | Per view, as a predicate the window supplies — all three are the same shape once stated that way, and the frame already takes the answer as a width. No library change beyond naming it. |
| R13 | The toolbar's leading rule mid-sweep | a flag at either end | a flag at either end | the larger of the two, measured in window columns | The corrected rule (part 6), shipped for every window whether or not it slides. Read as a flag the leading edge steps about 80 dp ≈ 18.4 mm at the instant the pane reaches zero. |
| R14 | The type role a pane row's name is set in | `BodyMedium` | the palette's own | `LabelLarge` — the role `sidebar.PaintCount` measures the count's column against | `LabelLarge`. It is the pattern's own role and the one the count's placement depends on; the other two are the windows' choices made before the helpers existed. |
| R15 | The naming the extraction carries | — | — | still on the pinned round's `Plane` and `LabelInset` | Ship the extraction with the library's current words — `PaneFrame.Surface`, `sidebar.TitleInset`, and `Toolbar` throughout for the strip across the content column, `desktop.BandLead` renamed with it — and let the recorder follow on the next pin. This document uses them already. |
| R16 | Is every control in the toolbar the platform's bordered control | yes, without exception: "the band holds one control drawn one way" | yes | **no**: Delete and Reveal are the app's own hover-pill icon buttons (`bandIconButton`), and the Empty chip and the record control are the app's own faces | The owner ruled the record control app-special and it stays. Delete and Reveal are plain toolbar acts with no app-special reason, and vaultview's rule is the platform's; recommendation is that they become `pane.ToolbarControl` (part 4). This is the open point already recorded under G1.2.5 and it is listed here because it decides whether `shell.Toolbar` may assume its `Lead` widgets are bordered controls. |

---

## §4 — The duplication count

**What each window spends on its frame today.** "Shell geometry" is the share of each file that composes the window's chrome arrangement — the parts named in §1 — as against the share that is the window's own content. The counts are of source lines including the prose that documents them, because in this codebase the prose is the larger half of a shell part and the extraction deletes it with the code.

| window | the files that compose the window | lines read | shell geometry | its own content |
|---|---|---|---|---|
| vaultview | `frame.go` 1229 + `tree.go`'s pane half ≈ 255 of 886 + `remember.go` 254 + `main.go`'s window half ≈ 72 of 481 | 1810 | ≈ 1340 | ≈ 470 |
| mindchat | `frame.go` 492 + `view.go`'s pane half ≈ 326 of 1440 + `theme.go`'s chrome block ≈ 37 of 346 + `main.go`'s window half ≈ 12 of 84 | 867 | ≈ 560 | ≈ 307 |
| the recorder | `shellchrome.go` 620 + `headerstrip.go` 899 + `folderpane.go`'s layout half ≈ 375 of 997 + `paneslide.go` 188 + `palette.go`'s band lane ≈ 20 of 119 + `main.go`'s window half ≈ 10 of 951 | 2112 | ≈ 1185 | ≈ 927 |
| **total** | | **4789** | **≈ 3085** | **≈ 1704** |

**What remains after the extraction.** The window keeps what fills the slots and nothing of the arrangement.

| window | shell geometry today | after | deleted | what is left of it |
|---|---|---|---|---|
| vaultview | ≈ 1340 | ≈ 300 | ≈ 1040 | the aside's splitter until the aside becomes a slot (≈ 80), the clamps it hands the shell (≈ 30), the per-screen placement predicate (≈ 15), the toolbar's and foot's slot payloads' wiring (≈ 100), the tree row's own parts (≈ 75) |
| mindchat | ≈ 560 | ≈ 215 | ≈ 345 | the chat title and its verdict (≈ 46), the picker's cap and `layoutPicker` (≈ 38), the footer's Settings payload (≈ 30), `ChatRow`'s own marks and dot (≈ 80), the window's options (≈ 2), the slot wiring (≈ 20) |
| the recorder | ≈ 1185 | ≈ 455 | ≈ 730 | the per-view table (`shellView`, `viewHasPane`, `bandCarries*`, `bandKinds`, ≈ 145), the toolbar's item bookkeeping for the probe (≈ 60), the pane's new-folder flow (≈ 85), the foot's gears and model cluster (≈ 185), the row's symbol adapter and section predicate (≈ 40), the slot wiring (≈ 60) — and `paneslide.go` and `bezierEase` go to zero |
| **total** | **≈ 3085** | **≈ 970** | **≈ 2115** | |

**What the library gains.** `patterns/shell/paneframe.go` is 182 lines today and `patterns/pane/pane.go` 464. The parts proposed above — the `PaneLayout` value and the op-order fields, `shell.Toolbar` with its metrics, `shell.ToolbarLead`, `pane.Mark` and `pane.ToolbarControl`, `pane.Column` and `pane.Marks`, `shell.Switch`, the two foot slots and `shell.FootSeam`, `shell.RememberArrangement`, `pane.Slide` with `tokens.Bezier.At` and the eased tween, `shell.PaneResize`, `shell.PaneWindow` and `shell.StandWindowButtons`, and `sidebar.Row`/`PaintRow`/`PaintSectionBlock` — are an estimated 700 to 900 lines of library written once, prose included, much of it moved rather than written: the measurement prose each window carries today is the pattern's own and has one home.

So the extraction removes about 2100 lines from the three windows and adds about 800 to the library: a net reduction of around 1300 lines, and — the point of the ruling — one statement of each measurement instead of three.
