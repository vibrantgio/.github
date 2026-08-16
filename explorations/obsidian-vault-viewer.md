# An Obsidian vault viewer in the workbench

**Status:** proposed, not started — an exploration in the pick-and-choose
pool, not scheduled work.
**Author:** drafted 2026-08-16
**Shape:** written in `PLAN.md`'s task shape (`####` headings, `- [ ]` steps)
so it can be lifted into the plan without rewriting. It is *not* in `PLAN.md`
and `mdplan` does not see it.

---

#### The question

**Can the existing Vibrant Gio vocabulary plus the in-org markdown renderer
carry a usable read-only Obsidian-vault viewer with wikilink following,
adding no new external dependency?**

Falsifiable, one bit. "Usable" is pinned by the stage exit criteria in §6:
open a vault folder, read any note, click any `[[wikilink]]` and land where
Obsidian would land, come back. Everything below exists to answer the
question; the decisive halves are §4.2 (whether the resolution rules fit in
app-local pure functions) and D2 (whether wikilinks can be recognised
without touching the parser).

---

#### 1. Why this is worth building

- **It dogfoods the markdown repo against a hostile corpus.** Today the
  renderer's only in-org consumer surface is `workbench/sitedocs`, whose
  sources are curated, embedded at build time
  (`sitedocs/docs_content.go:1-3`), and written to render well. A vault is
  the opposite: user files, YAML frontmatter, wikilinks, embeds, arbitrary
  nesting. What breaks there is exactly what a real application hits first.
- **The org's own working documents are vault-shaped.** CrunchGate trunks
  cite `[[SLICES#0003 — Checkout#Slice 1]]` and `[[TRANSCRIPTS#^id]]`; the
  `mdedit` tooling stamps, follows and checks those links daily — and
  nothing in the org can *display* them. The viewer closes that loop with
  the org's own files as the test corpus.
- **It exercises navigation vocabulary no workbench app exercises.**
  sitedocs routes among a dozen fixed pages compiled into the binary;
  every other app owns its data model outright. Nothing yet navigates
  open-ended user content: a history stack with back/forward,
  resolution-driven links, a disclosure file tree, a backlinks aside. Those
  are the patterns a document-centric application needs, and the workbench
  census (eight after this: `todos`, `iconbrowser`, `sitedocs`, `feeds`,
  `watchlist`, `mindchat`, `launcher`, plus the viewer) has a genre hole
  where the document reader should be.
- **It is the natural drag-and-drop consumer.** ADR-010's drop target is
  released in `mvu/desktop`; "drop a vault folder on the window, the vault
  opens" is one `FilesDropped` message away. Deliberately not scheduled
  here — the viewer must be complete without it — but no other app wants a
  folder drop this naturally.

---

#### 2. What exists, precisely

**The markdown repo carries everything but the wikilinks.**
`markdown.Parse(source []byte) []Block` walks a goldmark AST — goldmark
with `extension.GFM`, constructed inline at `markdown/parse.go:20` — into a
fully public block model: `Heading`, `Paragraph`, `List` (with GFM task
checkboxes), `Blockquote`, `CodeBlock`, `Rule`, `Table`, `Image`
(`markdown/block.go:62-160`), with inline content as styled `Span` runs
carrying `Bold/Italic/Code/Strikethrough/URL` (`markdown/block.go:44-57`).
Raw HTML is dropped by design (`markdown/parse.go:284-285`).

`markdown.Document` renders the blocks through components/list so long
documents stay O(visible) (`markdown/document.go:29,94-101`), and
`NewDocumentAt(blocks, first)` starts the viewport at a given top-level
block index (`markdown/document.go:70`). Link rendering *and click
handling already exist*: a `Span` with a non-empty URL becomes a richtext
hyperlink — "Consecutive spans sharing the same URL form one link"
(`components/richtext/richtext.go:23-24`) — underlined, hover-treated,
keyboard-focusable, firing `richtext.Style.OnLinkClick(gtx, url)`
(`components/richtext/richtext.go:102,245-246`). The markdown `Style` doc
says it outright: "Derive the token-themed default with [FromTokens], then
set Text.OnLinkClick" (`markdown/style.go:58-59`). sitedocs wires exactly
this hook to open web links (`sitedocs/docs.go:72,85-99`).

Two provider seams keep heavy work out of the library and are available to
the viewer unchanged: `Highlighter` for chroma code highlighting and
`ImageProvider`/`WidgetImageProvider` for image pixels — the library never
performs I/O of its own (`markdown/style.go:33-56`).

**Empirical: what `Parse` does to vault syntax** (probed 2026-08-16 against
the workspace checkout, `markdown v0.1.4` source):

- Wikilinks survive parsing as literal text, intact within one merged span:
  `[[Other Note|the alias]]`, `[[Folder/Deep#Sec]]` and `![[img.png]]`
  all arrive as plain `Span.Text`, URL empty. Goldmark does not consume
  the double brackets.
- A wikilink inside inline code arrives as a span with `Code == true`, so a
  post-parse pass can honour the rule that code is never a link edge
  without re-detecting fences itself.
- Bare YAML frontmatter renders as garbage: the opening `---` becomes a
  `Rule`, and the closing `---` turns the key lines above it into a setext
  level-2 `Heading` ("title: My Note / tags: [a, b]"). Frontmatter must be
  stripped before `Parse` (D5).

**The nearest app is the template.** sitedocs composes a
`patterns/shell` `ThreeColumn` (nil aside) with a navbar, a sidebar stream,
and a routed main slot (`sitedocs/main.go:312-317`); each docs page is a
`patterns/breadcrumb` row over a `markdown.Document` created once and
reused so scroll and link state survive navigation
(`sitedocs/docs.go:101-132,170-195`); navigation is a `SetRoute` message
reduced by a pure `Update` (`sitedocs/model.go`). The shell's `Aside` slot
— "a comments panel, an inspector, or any other contextual surface", with
a user-draggable `AsideWidth` (`patterns/shell/shell.go:108-130`) — is
sitting empty in every current app and is the natural backlinks panel.

**mvu gives the loop and the effects.** `mvu.Loop` over
`Window.Messages()`, `mvu.MessageOp` for same-frame navigation from click
callbacks (the breadcrumb/navbar idiom, `sitedocs/docs.go:162-167`), and
`mvu.Do` commands for async work like the vault scan (`mvu/command.go:28`).

#### 3. What is missing

- **A tree widget with disclosure.** `patterns/sidebar` is deliberately
  flat — `Item{Icon, Label, OnClick, Active}`
  (`patterns/sidebar/sidebar.go:101-106`), fixed 192/48 dp rail, items in a
  components/list scroll region, one keyboard stop. No nesting. sitedocs
  hit the same wall and composed its own accordion-grouped sidebar
  app-locally, bypassing the pattern (`sitedocs/docs_sidebar.go:1-8`) — but
  an accordion is one level of grouping, not a tree of folders. The file
  tree is therefore an app-local composition over `components/list`
  (indent per depth, a disclosure toggle per folder row), per the
  Composition contract the sidebar package itself states ("copy it into
  your own app and modify as needed"). If a second app wants it, it is a
  candidate to graduate into patterns — not before.
- **Wikilink recognition.** Nothing in the org parses `[[...]]` (D2 says
  where it goes).
- **Vault semantics.** Scanning, indexing, and the resolution rules of
  §4.2 exist in the external mdedit tool, not in any org module. The
  semantics are the spec; the code is reimplemented small (§4.2's note).
- **Broken-link styling.** `markdown.Style` maps model spans to richtext
  spans without a per-span colour (`markdown/style.go:203-224`), so an
  unresolvable link cannot render tinted differently from a good one
  without growing the markdown repo. v1 lives with behavioural feedback
  instead (D3).
- **A focus/re-activation event.** mvu's `Render` switch forwards
  `DestroyEvent`, `FrameEvent` and `ViewEvent` and drops everything else
  deliberately (`mvu/window.go:240-272`), so "re-scan when the window
  regains focus" has no seam today (D6).

---

#### 4. The mechanism, precisely

```
  open vault folder (CLI arg; later: file drop)
      │
      ▼  mvu.Do command, off the render goroutine
  scan: walk *.md below root (skip dot-dirs)
      │  fence-aware line scanner per file:
      │  headings (title path), block ids (^id), outgoing wikilinks
      ▼
  Index{ files, basenames, anchors, links, backlinks }  → VaultScanned message
      │
      ▼  on open of a note
  strip frontmatter → markdown.Parse → wikilink span pass → *markdown.Document
      │                                (cached per note, keyed by path)
      ▼
  richtext link click → OnLinkClick(gtx, url)
      │  "wiki:<raw>" → resolve against Index → MessageOp Navigate{...}
      │  http(s)      → system browser (sitedocs' openURL shape)
      ▼
  Update: push history, set current note; View renders
  shell.ThreeColumn: file tree │ breadcrumb + Document │ backlinks aside
```

##### 4.1 Vault scan and index

The index scanner is *not* goldmark: one pass of a small line scanner per
file — tracking fenced-code state so fenced lines contribute no links or
anchors — collecting per file its vault-relative path, basename, heading
list (level + title, in order, so heading *paths* can be resolved), block
ids (`^id`, inline at line end or on an own line below a table/quote/fence),
and outgoing wikilinks (raw text + parse). Full goldmark parsing happens
only per *opened* note. The scan is O(vault bytes) and runs as an `mvu.Do`
command delivering one `VaultScanned{Index}` message; backlinks are the
reverse of the outgoing-link edges, computed once at scan.

Anchor *positions for scrolling* are never taken from the line scanner: when
a note opens, heading→top-level-block-index and blockid→block-index maps
are computed from the parsed `[]Block` itself, so the viewport target and
the rendered content can never disagree (the line scanner only answers
"does this anchor exist" for resolution and link checking).

##### 4.2 Wikilink resolution — the spec

The semantics are Obsidian's, as pinned by the local reference
implementation's documentation (the mdedit `follow`/`links`/`stamp`
contract; see §10's index). That tool is external and is **not imported —
its documented behaviour is the spec, reimplemented small** as pure
functions over the index, table-tested.

Grammar (all forms parse; `!` prefix marks an embed):

```
[[FILE]]   [[FILE|alias]]   [[FILE#A#B]]   [[FILE#^id]]   [[#Heading]]   ![[...]]
```

- The alias is display-only. The file part may carry a path
  (`Folder/Note`) and omits `.md` by convention. Heading paths nest
  (`#A#B` descends A then B). Block ids fit `[A-Za-z0-9-]+`.
- **Vault root:** the folder the viewer opened. When launched on a single
  file instead, the root is the nearest ancestor holding `.obsidian/`,
  else the git checkout's top level, else the file's own directory.
- **File resolution, in order:** (1) the file part as written, relative to
  the linking note's directory; (2) against the vault root, `.md` appended
  when the link omits it; (3) as a unique basename anywhere below the
  root; two or more basename hits are ambiguous and the resolution
  *refuses* — it never guesses (D3 owns the UX).
- **Heading paths** descend the target's heading list by title,
  case-insensitively; an ambiguous title at any level refuses like an
  ambiguous basename. **Block refs** match a stamped `^id`; ids are
  file-unique by the stamp contract, so no ambiguity arm exists.
- **Same-file `[[#H]]`** resolves within the linking note.
- **Code is never an edge:** links inside fenced code blocks and inline
  code spans do not resolve, do not count as backlinks, and do not render
  as links — at render time this falls out of the `Code` span flag (§2's
  probe), and the index scanner honours the same rule fence-aware.
- Comparisons beyond heading titles are exact in v1; Obsidian itself is
  more forgiving (case-insensitive file matching). The delta is recorded
  and revisited only when a real vault trips it — a refinement, not a
  redesign.

##### 4.3 Rendering: two small passes around Parse

1. **Frontmatter strip (pre-Parse).** If the source's first line is
   exactly `---`, cut through the closing `---` (or `...`) line; otherwise
   byte-identical input. No YAML parsing (D5).
2. **Wikilink span pass (post-Parse).** Walk the public `[]Block` model —
   heading, paragraph, list item, blockquote and table-cell spans — and
   split every non-`Code` span's text on the wikilink grammar. A matched
   link becomes its own `Span` with `Text` = alias (or the target as
   written) and `URL` = `"wiki:"` + the raw link body; surrounding text
   keeps its styling. richtext then renders it as a link and delivers the
   click for free (§2). The pass is pure `[]Block → []Block`, unit-tested
   without a window.

D2 argues why this beats a parser extension or a raw-text preprocessor.

##### 4.4 Navigation model

The model is the sitedocs shape grown one notch:

- `current` (vault-relative path + optional anchor), a **history stack**
  with a cursor — `Navigate` pushes and truncates the forward tail,
  `Back`/`Forward` move the cursor; back/forward affordances live in the
  header row and are disabled at the stack's ends.
- **Documents are cached per note** (`map[path]*markdown.Document`),
  created on first visit — the same allocate-once rule sitedocs applies
  per page, so scroll position and link interaction state survive
  revisiting. Anchor targets build with `NewDocumentAt` at the anchor's
  block index.
- **Breadcrumb:** vault name, folder segments, note title — the
  `patterns/breadcrumb` row exactly as the docs pages wear it
  (`sitedocs/docs.go:112-114,156-168`); the vault-name crumb navigates to
  the tree's root state, folder crumbs are labels in v1.
- **File tree** in the shell's sidebar slot (§3's app-local composition):
  folders with disclosure state held in the model, notes as rows,
  the current note rendered active.
- **Backlinks** for the current note in the `Aside` slot: every note whose
  outgoing links resolve to the current note, one row each, click
  navigates. v1 lists note titles; showing the citing line is a later
  nicety.
- v1 ships: open, render, follow, history, breadcrumb. v2 ships: tree,
  backlinks, ambiguity chooser. The split is §6's.

---

#### 5. Decisions to make, with recommendations

##### D1 — Where does the code live?

| Option | Pros | Cons |
| --- | --- | --- |
| a. all app-local in `workbench/vaultview` | zero new modules, zero gates, ships now | wikilink pass and resolver invisible to other consumers |
| b. wikilink pass into the markdown repo now | second consumer gets it free | tier-4 API grown on one consumer's evidence; support-library rules apply to its docs |
| c. new `vaultmodel` repo | clean charter | a 22nd repo for an exploration — grossly premature |

**Recommendation: (a).** Everything app-local; the module is
`github.com/vibrantgio/workbench/vaultview`, dir `workbench/vaultview`, matching
the census's single-noun names. The span pass (§4.3) and the resolver
(§4.2) are written as their own packages *inside* the app so that
graduating either into the markdown repo later is a move, not a rewrite —
and if that day comes, the markdown repo's docs describe the capability
without naming this app, per the org's support-library documentation rule.

##### D2 — How are wikilinks recognised?

| Option | Assessment |
| --- | --- |
| Raw-text preprocessing (rewrite `[[x]]` → `[x](wiki:x)` before Parse) | Must re-detect fenced code, inline code and escapes itself or it corrupts code samples — reimplementing the half of the parser we get for free. Rejected. |
| Goldmark extension via the markdown repo | The parser is constructed inline with no extension seam (`markdown/parse.go:20`); this option requires growing tier-4 API (or forking the parse), for no capability the next option lacks. Rejected for v1; it is the natural shape *if* the pass ever graduates (D1). |
| **Post-parse span pass over the public `[]Block`** | Operates on exported data, needs zero markdown-repo change, and the `Code` flag already marks the spans the rule must skip (§2's probe). One honest limitation: a span is a styling run, so a wikilink spanning a styling boundary (`[[a *b*]]`) is not recognised — Obsidian targets do not carry markdown, so this excludes approximately nothing. |

**Recommendation: the span pass**, with the limitation documented in the
package doc and pinned by a test.

##### D3 — Unresolvable and ambiguous links

Both stay *rendered as links* — stripping them to plain text would hide
the vault's real state from the one tool whose job is showing it.

**Recommendation:** clicking an unresolvable link raises a
`patterns/toast` naming the target ("no note 'X' in this vault");
clicking an ambiguous one refuses the same way in v1 ("'X' matches 3
notes") and gains a `patterns/modal` candidate chooser in v2 — the
resolver already returns the candidate list, only the surface is staged.
Tinting broken links differently is blocked on per-span colour in the
markdown repo (§3) and is explicitly not v1.

##### D4 — Embeds

**Recommendation: `![[...]]` renders as an ordinary wikilink in v1 —
never inline.** Transclusion is a rendering recursion with cycle rules
and a real design surface; a link that navigates to the embedded note
preserves every workflow at a fraction of the cost. Image embeds
(`![[img.png]]`) could later ride the existing `ImageProvider` seam
(`markdown/style.go:39-56`) — noted, not scheduled.

##### D5 — Frontmatter

**Recommendation: recognise and strip, parse nothing.** The `---` block
is cut before `Parse` (§4.3; the probe shows the garbage rendering
otherwise). No YAML dependency enters the app for any reason — the
external-package budget (§7) outranks the nicety. If key facts are ever
shown, they are line-split `key: scalar` pairs rendered as plain text,
and anything that does not split trivially is not shown.

##### D6 — Freshness

**Recommendation: no file watching in v1.** fsnotify is a new external
dependency, and mvu deliberately forwards no focus/stage event to hang a
re-scan on (`mvu/window.go:272`). Instead: navigation re-stats the target
file and re-reads it when the mtime moved (cheap, catches the
edit-in-Obsidian-then-click case), and an explicit Rescan affordance
re-runs the scan command for structural changes. If re-scan-on-focus ever
matters, that is an mvu seam conversation, not an app workaround.

##### D7 — Scope cuts

**Recommendation: no editing, no graph view, no full-text search in v1.**
Editing is a different application; the graph is a different renderer.
One cheap exception deliberately held for v2/v3, not v1: quick-open by
note name — the index already holds every basename and heading, so it is
a filter over data the scan produced, no new machinery. Full-*text*
search stays out entirely.

---

##### D8 — Choosing the vault, and remembering it

The owner's spec, verbatim in requirements form: a vault path given on the
command line wins; without one the app asks — a folder selection — and the
chosen vault becomes the default the next launch uses. The current vault is
stored under `~/.config`.

Three parts, each with a decision:

**Resolution order.** CLI argument → stored default → the picker. A stored
path that no longer exists or is not a directory falls through to the
picker rather than erroring — a renamed vault is an ordinary event, not a
crash. Whatever the launch resolves to is written back to the store, so
"the vault I used last" is maintained without a settings screen.

**The picker.** Gio core ships no native folder dialog, and the candidates
that exist all fail the example constraint: `gioui.org/x/explorer` is a new
external module (and its API targets files, not directories, on several
platforms); an NSOpenPanel bridge is darwin-only cgo in an app meant to
compile everywhere. **Recommendation: an in-app folder browser composed
from the vocabulary** — a breadcrumb for the current directory, a
components/list of child directories (dot-directories hidden), each row
annotated when it holds a `.obsidian/` marker or a count of `*.md` files,
and a filled "Open this vault" action on the current directory. Zero new
dependencies, works on every platform, and the picker is itself a
pattern-composition exercise — a workbench example demonstrating the
vocabulary twice over. The same screen re-enters later as a "Switch vault"
affordance (v2), so it is not first-run-only chrome.

**The store.** A plain-text file holding one absolute path, no format and
no dependency: `~/.config/vaultview/vault` (the `xxxxxx` of the
owner's spec made concrete — the app's own directory, per the owner).
`$XDG_CONFIG_HOME` is honoured when set; otherwise the literal `~/.config`
the owner specified — deliberately NOT `os.UserConfigDir()`, which on macOS
resolves to `~/Library/Application Support` and would put the file where
the spec says it must not be. Written on every successful vault open
(0644, create-dirs); unreadable or empty reads as absent.

#### 6. The build, staged

Each stage ends at a falsifiable criterion; a stage that cannot meet it
stops the line and the finding comes back here.

##### V0: Scaffold, scan, render one note
- [ ] Scaffold `workbench/vaultview` from the todos bootstrap shape: mvu loop, live theme, `shell.ThreeColumn` with nil sidebar and aside. Vault resolution per D8: CLI argument → stored default → the picker screen; the resolved vault is written back to the store on every successful open.
- [ ] The store, with table tests: `~/.config/vaultview/vault` (one absolute path, plain text; `$XDG_CONFIG_HOME` honoured, else literal `~/.config` — never `os.UserConfigDir()`), absent/empty/unreadable reads as no-default, a stored path that stopped being a directory falls through to the picker.
- [ ] The picker screen (D8): breadcrumb + components/list folder browser, dot-directories hidden, rows annotated with the `.obsidian/` marker or `*.md` count, filled "Open this vault" action. Keyboard: arrows move, Return descends, the action opens.
- [ ] Frontmatter stripper with table tests: leading block, `...` terminator, unterminated block, `---` mid-document untouched, byte-identical passthrough otherwise.
- [ ] Fence-aware index scanner: walk `*.md` below the root skipping dot-directories; per file collect headings, block ids, outgoing wikilinks; unit tests include a fenced `[[not-a-link]]` contributing nothing.
- [ ] Run the scan as an `mvu.Do` command; render the first note found through strip → `Parse` → `Document` under a breadcrumb row.
- [ ] **Exit: pointed at a real CrunchGate trunk, the viewer opens and DESIGN.md renders legibly — frontmatter invisible, wikilinks visible as literal text (not yet links), code blocks highlighted. A first argument-less launch asks with the folder browser; the next argument-less launch opens the same vault without asking.**
##### V1: Links follow, history works, the tree at the left
- [ ] Wikilink span pass (§4.3) with table tests: plain, alias, heading path, block ref, same-file, embed, adjacent links, `Code` spans skipped, the styling-boundary limitation pinned.
- [ ] Resolver (§4.2) as pure functions over the index, table-tested per rule: as-written, root + `.md`, unique basename, ambiguous refusal with candidates, heading paths incl. ambiguity, block refs, same-file.
- [ ] `OnLinkClick` interception: `wiki:` resolves and emits `Navigate` via `mvu.MessageOp`; `http(s)` opens the system browser; unresolvable/ambiguous raise the D3 toast.
- [ ] History stack in the model with Back/Forward messages and header affordances; documents cached per note; anchor targets land via `NewDocumentAt` on block indices computed from the parsed blocks (§4.1).
- [ ] The folder tree of the vault at the left — an owner requirement, not polish: an app-local tree over `components/list` in the `shell.ThreeColumn` sidebar slot (V0's nil sidebar becomes this), indent per depth, disclosure toggles with fold state in the model, dot-directories hidden, the current note active, click navigates.
- [ ] **Exit: clicking `[[F#A#B]]` in note X lands the viewport on B in F; Back returns to X with its scroll position intact; Forward returns to F; a link into a code fence does not exist; any note in the vault is reachable through the left tree alone.**
##### V2: Backlinks, ambiguity surface, switch vault
- [ ] Backlinks in the shell's `Aside`: reverse edges for the current note, one row per citing note, click navigates.
- [ ] Ambiguous-link chooser: the D3 modal listing the resolver's candidates; choosing navigates.
- [ ] Breadcrumb grows the folder trail; the vault-name crumb reveals/roots the tree.
- [ ] "Switch vault" affordance re-entering the D8 picker; the store follows the switch.
- [ ] **Exit: the aside lists exactly the notes whose links resolve to the current note and clicking one navigates; an ambiguous link resolves through the chooser; switching vaults re-roots the tree and updates the store.**
##### V3: Harden and land

- [ ] Re-stat on navigate + Rescan affordance (D6); quick-open by name if it stays a filter over the index (D7).
- [ ] Goldens for one rendered note and the tree, following the sitedocs golden shape; README; `doc.go` carrying §4.2 as the package's stated contract.
- [ ] The census work of §8: repos.tsv row wording, `sync-agents.sh`, `llms.txt`, the sitedocs About line, `go.work` regeneration.
- [ ] **Exit: all §8 gates green from a clean checkout; `GOWORK=off` build against published tags only.**

---

#### 7. The external-package budget

The constraint: an example app pulls in essentially nothing new. Measured
from the go.mod files:

- `markdown` already carries `goldmark`, `chroma/v2` (via
  markdown/highlight) and `golang.org/x/image`; `mvu` carries
  `gioui.org` and `reactivego/rx`; `theme` adds `x/sys` — all already in
  every sitedocs build (`workbench/sitedocs/go.mod`).
- The viewer's direct requirements are the sitedocs set exactly:
  `mvu`, `mvu/desktop` (window chrome), `theme`, `components`, `patterns`,
  `markdown` (+`/highlight`), `gioui.org`, `reactivego/rx`.
- **New external dependencies: none.** No YAML (D5), no fsnotify (D6), no
  wikilink library (D2 — the pass is ~a page of code), no import of the
  external reference tool (§4.2 — its documented semantics are the spec).

Verdict: the budget holds by construction; V3's `GOWORK=off` gate proves
it.

---

#### 8. Org gates this must pass when it lands

Not exploration work — landing work, listed so V3 has no surprises.

- `scripts/check-layers.sh:199` classifies `workbench/*` as `kind=app`,
  exempt — applications sit at the top of the stack and may import any
  layer. No gate change.
- **The census lives in three places** and all three enumerate the apps:
  the workbench row of `templates/repos.tsv:56` ("The seven reference
  applications … `todos` … `launcher`"), `llms.txt:15`, and the sitedocs
  About page (`workbench/sitedocs/main.go:339`). An eighth app touches
  all three; the repos.tsv edit renders through `sync-agents.sh` —
  editing the rendered `AGENTS.md` is the org's known silent no-op.
- `go.work` is generated by `scripts/clone-all.sh` from the go.mod files
  present — regenerate, never hand-edit the `use` list.
- `check-no-workspace.sh`: builds and tests with `GOWORK=off` against
  published tags, no `replace` directives.
- `check-subjects.sh`: applies org-wide; the app holds no package-level
  observables if it keeps the todos/sitedocs shape (frame-time cells via
  `atomic.Value`, messages via the loop).
- Versions: workbench apps carry no tags (`llms.txt:95`), so
  `check-versions.sh` gains no row.
- CI: nothing new — the app compiles wherever the other seven do; goldens
  follow the existing skip-without-GL policy.

---

#### 9. Risks

| Risk | Severity | Mitigation |
| --- | --- | --- |
| goldmark eats brackets when a vault note defines a matching link reference (`[[foo]]` + `[foo]: url`) — the span pass then sees a URL-bearing span, not a wikilink | low | rare in real vaults; degrade to the ordinary link goldmark made; pin with a test so the behaviour is chosen, not accidental |
| Wikilink across a styling boundary is invisible to the span pass | low | documented limitation (D2); Obsidian targets do not carry markdown |
| `NewDocumentAt` is documented "Intended for golden-image testing" (`markdown/document.go:69`) yet anchors navigation here | med | it is public API and the only viewport-index door; if the markdown repo ever objects, the ask is a blessed scroll-to-block API — raise it before growing a workaround |
| Anchor drift between the line scanner and the parsed blocks | med | §4.1's rule: scroll targets come from the parsed `[]Block` only; the scanner only answers existence |
| Document cache grows unbounded on a huge vault | low | O(visible) layout bounds per-frame cost; cap or LRU the cache only when a real vault hurts — measure first |
| Big-vault scan latency on open | low | scan is one `mvu.Do` command off the render goroutine; the window renders "scanning…" honestly; O(bytes), no parse |
| Broken links indistinguishable visually from good ones in v1 | low | D3's behavioural feedback; per-span colour is the recorded markdown-repo ask |

---

#### 10. Out of scope

- Editing, creating, renaming, deleting notes. This is a viewer.
- Graph view, canvas files, Obsidian plugins, Dataview, callout syntax
  (callouts render as the plain blockquotes they are), CSS snippets and
  Obsidian themes — Vibrant Gio's theme is the theme.
- Inline transclusion of embeds (D4 renders them as links).
- Full-text search (D7), file watching (D6), multi-vault windows.
- Export, publish, print.
- Writing to `.obsidian/` — the folder is read as a root marker, nothing
  more.

---

#### 11. Reference index

Everything asserted above, with its source, so no one re-derives it.

**Vibrant Gio** (workspace checkouts, 2026-08-16)

| Fact | Location |
| --- | --- |
| `Parse` builds goldmark+GFM inline, no extension seam | `markdown/parse.go:19-23` |
| block model, `Span{…, URL}` | `markdown/block.go:44-160` |
| raw HTML dropped by design | `markdown/parse.go:284-285` |
| `Document` O(visible) via components/list | `markdown/document.go:29,94-101` |
| `NewDocumentAt(blocks, first)` and its stated intent | `markdown/document.go:66-74` |
| "then set Text.OnLinkClick"; `Style.Text` is `richtext.Style` | `markdown/style.go:58-63` |
| provider seams: `Highlighter`, `ImageProvider`, `WidgetImageProvider` | `markdown/style.go:33-56` |
| spans → richtext with no per-span colour | `markdown/style.go:203-224` |
| URL spans are links; consecutive same-URL spans merge; `OnLinkClick` | `components/richtext/richtext.go:23-24,88-102,245-246` |
| gioui.org/x/markdown evaluated and rejected (2026-07-20) | `markdown/README.md:113-121` |
| sitedocs ThreeColumn composition | `workbench/sitedocs/main.go:312-317` |
| docs page = breadcrumb + Document, allocated once | `workbench/sitedocs/docs.go:101-132,170-195` |
| OnLinkClick → system browser, non-http ignored | `workbench/sitedocs/docs.go:72,85-99` |
| docs sources embedded at build time | `workbench/sitedocs/docs_content.go:1-3` |
| sitedocs bypasses patterns/sidebar for nesting | `workbench/sitedocs/docs_sidebar.go:1-8` |
| sidebar Items are flat; fixed 192/48 rail; Composition contract | `patterns/sidebar/sidebar.go` (package doc, `:101-106`) |
| breadcrumb `Item{Label, OnClick}` | `patterns/breadcrumb/breadcrumb.go:53-56` |
| shell `Aside` slot + draggable `AsideWidth` | `patterns/shell/shell.go:108-130` |
| mvu forwards Destroy/Frame/View events only, rest dropped deliberately | `mvu/window.go:240-272` |
| `mvu.Do` command shape | `mvu/command.go:28` |
| workbench apps exempt from tier judgment | `scripts/check-layers.sh:199` |
| the three census locations | `templates/repos.tsv:56`, `llms.txt:15`, `workbench/sitedocs/main.go:339` |
| workbench carries no tags | `llms.txt:95` |
| ADR-010 file-drop target released in `mvu/desktop` | `PLAN.md`, ADR-010 S5 addendum |

**The resolution spec's source** (external; semantics only, no import)

- mdedit skill documentation, `follow` / `links` / `stamp` sections:
  `~/.claude/plugins/cache/trinova-ai/md/0.2.0/skills/edit/SKILL.md`
  — link grammar and every form; vault-root rule (`.obsidian/` ancestor,
  else git top, else base); the three-step file resolution with ambiguous
  refusal; code is never an edge; block-id alphabet and own-line anchors;
  file-unique ids. No source checkout of the tool exists in the
  workspace; its documented behaviour is the spec this document
  reimplements.

**Empirical** (this exploration, 2026-08-16)

- `markdown.Parse` probe: wikilinks and embeds survive as literal span
  text; inline-code wikilinks carry `Code == true`; unstripped
  frontmatter renders as a `Rule` plus a setext level-2 heading of the
  key lines. Probe run against the workspace `markdown` checkout
  (v0.1.4 line), go test, this Mac.
