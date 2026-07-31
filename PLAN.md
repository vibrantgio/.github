# VibrantGio — one coherent design system

Turn twenty-one loosely related repositories into a single design system for
native desktop apps on macOS/Windows/Linux, built on Gio, whose design
decisions are directed by Material Design's *generative* ideas reimagined for
native Go — and make that system legible to a coding assistant that is pointed
at nothing more than `github.com/vibrantgio`.

**Working tree.** This repo (`vibrantgio/.github`) is the plan root and the org
front door. Every other repo is cloned to `.repos/<name>` beneath it and is
gitignored. Work happens inside `.repos/<name>`; the plan and the canonical
agent guide live here at the root.

**One task, one commit.** Do the steps of exactly one `####` task, then commit
in each repo you touched with the task heading in the subject line and the
trailer `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`.

**Green before commit.** In every module you touched: `go build ./... && go
test ./...` must pass. Golden-image tests are part of that — when a change
legitimately moves pixels, regenerate the goldens *within the same task* and
say so in the commit body. Never commit red.

**Never push without asking.** These are public repositories. Commit locally;
pushing is Rene's call, made explicitly, at goal boundaries. Two things in this
plan genuinely cannot finish without a push — the cross-repo tag seams in
ADR-006 and the whole of G-F3 — and both stop and ask rather than pushing.

**Stop if a task is too big.** Tasks are cut to fit ~100K tokens of Opus 5 at
high effort. If one turns out larger than that, check off what you genuinely
finished, commit it, and report that the task needs splitting — with a proposed
split. Do not push through. A task that silently runs for hours is the failure
mode this plan exists to prevent.

## Phase A: Front door — make the org legible to a coding assistant

Nothing here changes a line of library code. It fixes the reason an assistant
pointed at the org currently finds nothing: the canonical guide is buried one
repo deep and unlinked, eleven of the twenty sibling repos have no README at
all — twelve counting this one — and not one of the six core modules has a
`doc.go` anywhere, so pkg.go.dev is blank for the entire stack.

Phase A is self-contained and lands value immediately. Do not let later phases
block it.

![[#ADR-004: The canonical agent guide lives here]]
### G-A1: Establish the guide and the front door

All work in this repo unless a step says otherwise.

#### A1.1: Set up the working tree

Create the local layout every later task assumes.

- [x] Add `.gitignore` with `.repos/`, `go.work.sum` and `.DS_Store`.
- [x] Write `scripts/clone-all.sh`: clone all twenty sibling repos into `.repos/`, skipping any already present, and `git pull --ff-only` those that are. Plain `git clone https://github.com/vibrantgio/<name>.git` — do not assume `gh` is installed.
- [x] Name all twenty in the script, since nothing else in the working tree knows the list: **the stack** — mvu, spectrum, prism, pulse, cadence, markdown; **the leaves** — font, style, textdraw, backdrop, gradient, circle; **the support libraries** — ivg, svg, seen, csg, kiwi, noise, traer; **the apps** — workbench.
- [x] Run it; confirm twenty directories exist under `.repos/`.
- [x] Record in the script's header comment that `.github` itself is the parent directory, not a clone — and that the whole set is cloned every time, because the module graph is what this plan edits and no task can see an edge whose other end is missing.
- [x] Write `scripts/inventory.sh`: per repo, report whether it has a `README.md`, an `AGENTS.md`, a root `doc.go` and a `.github/workflows/`, plus its current Gio and rx versions.
- [x] Run it and paste the table into the commit body. Every count this plan still asserts — twelve missing READMEs, six missing `doc.go`, twenty missing `AGENTS.md`, no CI anywhere — is checked against that table and corrected here if it is wrong. Phase A's tasks were cut from a survey, not from the clone. (The dependency half of that survey is already settled: G-B1 put every module on one Gio, one rx and `go 1.25.1`.)

#### A1.2: Move llms.txt here and correct its inventory
`workbench/llms.txt` is the only agent guide in the org. Promote it to this
repo's root, where the org front door can link it.

- [x] `git mv` the file content into `./llms.txt` (copy across repos; it is a new file here).
- [x] Correct the module inventory table against the real tags. Do not copy the list below by hand — read it out of the clones (`git -C .repos/<name> tag | sort -V | tail -1`), because it has already gone stale once. Measured 2026-07-31, after the G-B1 retagging: mvu v0.4.3, prism v0.1.2, spectrum v0.0.6, pulse v0.0.6, cadence v0.2.3, markdown v0.0.6, seen v0.0.7, traer v0.0.8, svg v0.0.8, ivg v0.1.6, backdrop v0.0.3, noise v0.0.3, style v0.0.5, textdraw v0.0.4, font v0.0.4, circle v0.0.4, kiwi v0.0.6, gradient v0.0.3, csg v0.0.1. Note `gradient` — the old table omitted it entirely — and `csg`, which the old table showed as untagged.
- [x] List the ten nested modules too — they are invisible in a repo listing and an assistant will not guess them: `prism/gallery`, `mvu/example`, `ivg/raster/gio`, `kiwi/gio`, `traer/gio`, `seen/context/gio`, `svg/driver/{gio,pdf,raster,seen}`. Their tags carry the subdirectory prefix (`raster/gio/v0.1.6`), which is not obvious.
- [x] Add a header line naming this file the single canonical guide and giving its raw URL.
- [x] In `.repos/workbench`, replace `llms.txt` with a three-line pointer to the canonical URL, and update `workbench/README.md`'s reference to it. Commit in workbench.
#### A1.3: Give the guide a typography section
The guide is why assistants ship gofont apps: it lists `style` and `font` in the
inventory but omits them from the bootstrap and the minimal `go.mod`, and has no
typography section at all. Document today's correct practice. Phase C replaces
this section wholesale.

- [x] Add a `## Typography` section: build one `*text.Shaper` from `style.FontFaces()` and pass it to every component's `Shaper` prop.
- [x] State the rule plainly: never `gofont`, never `text.NoSystemFonts()` with the Go collection, never append the two.
- [x] Note that components default to gofont internally when `Shaper` is nil, so the prop is not optional today.
- [x] Add `github.com/vibrantgio/style` (and `github.com/vibrantgio/textdraw`, direct as soon as the app draws its own text) to the minimal `go.mod` block; `github.com/vibrantgio/font` is style's INDIRECT dependency — `todos/go.mod` carries it `// indirect` — so do not list it as a direct require.
- [x] Point at the correct reference app and name the known-wrong ones until Phase F.

**Corrected by A3.2.** This task assumed `todos/` already followed the
practice, and the section it produced named `todos/view.go`,
`iconbrowser/view.go` and `launcher/view.go` as correct. Only `launcher` is.
All three build the shaper at layer scope, but todos and iconbrowser spend it
only on their own `textdraw` calls — `todos/upsertdialog.go`'s two
`button.Button` calls and `iconbrowser/view.go`'s `input.TextField` omit
`Shaper:`, so those components render in gofont. The section was pointing
assistants at two apps exhibiting the defect it warns about. A3.2 rewrote the
REFERENCE CODE paragraph to name launcher alone and say what the other two get
wrong; the app code is F1.1's to fix.
#### A1.4: Rewrite the org profile README

`profile/README.md` is what renders on the organization home page. Today it
opens with screenshots and never mentions the guide, DESIGN.md, or where to
start.

- [x] Open with a one-paragraph statement of what VibrantGio is and what it targets.
- [x] Immediately follow with a **Start here** block linking `llms.txt`, `workbench/DESIGN.md`, and `workbench/todos/`.
- [x] Keep the layered stack table; correct it to ADR-001's tier table — all nineteen modules, not just the six-module spine — and mark layers that are mid-migration.
- [x] Keep the screenshots, moved below the entry points.

![[#ADR-001: Spectrum is the foundation, not a consumer]]

#### A1.5: Write this repo's root README

The repo root is separate from `profile/`. It currently has no README at all.

- [x] Explain that this repo holds three things: the org profile page, `PLAN.md`, and the canonical `llms.txt`.
- [x] Link all three, plus `scripts/clone-all.sh`.
- [x] Note that `profile/README.md` — not this file — is what renders on the org page.

#### A1.6: Write this repo's AGENTS.md

A1.5's README is written for a human evaluating the repo. This file is for the
agent that has just been dropped into this working tree with no other context —
and by G-A2's own argument, a README is not the file it finds.

It is written by hand rather than from the G-A2 template, because it describes
a plan and a working tree rather than a library module.

**There is no `go.work` here yet.** This step was written asserting that one at
this root is what makes the modules resolve against each other; it does not
exist, `.gitignore` lists it, and B2.1 is the task that writes it. Stating
otherwise in `AGENTS.md` would have taught the next agent that a cross-repo
change is visible to the other side when it is not. Creating the workspace does
not belong here either — Phase A changes no module resolution, and B2.1 owns
the verification sweeps that go with it — so the step below says what is true
today and points forward.

- [x] Write `AGENTS.md` at this repo's root: what this repo is, that `PLAN.md` is the entry point, and that `mdplan next` is how work is picked up.
- [x] State the working-tree layout — sibling repos live in gitignored `.repos/`, this repo is their parent and not a clone, and each module today resolves its siblings from published tags rather than from the working tree; the `go.work` that changes that is B2.1's, not this task's.
- [x] Restate the four rules from `PLAN.md`'s preamble that an agent must not discover late: one task one commit, green before commit, never push without asking, stop if a task is too big.
- [x] Link `llms.txt` — but say plainly that it covers writing Gio code against the libraries, not working the plan, so an agent knows which file answers which question.
- [x] Commit here.
### G-A2: Put an AGENTS.md in every repo

`AGENTS.md` at a repo root is the file an assistant finds without being told.
Twenty repos, none have one. This is the single highest-leverage change in the
plan.

This goal covers the twenty sibling repos under `.repos/`. This repo's own
`AGENTS.md` is A1.6, and `scripts/sync-agents.sh` deliberately cannot reach it:
`.github` is the parent directory, not a clone.

![[#The repo doc contract]]

#### A2.1: Author the template and the sync script

- [x] Write `templates/AGENTS.md` here: what this repo is, which layer it sits in, the canonical guide's raw URL, the build/test command, and "read the guide before you write code against this module". Rendered, that is about thirty wrapped lines, not the fifteen this step first estimated — five short paragraphs plus the module paragraph the doc contract also asks for.
- [x] Make the layer line and the one-sentence role substitutable per repo. They live in `templates/repos.tsv`, one tab-separated row per repo; anything longer than a line — a deprecation notice, a platform caveat — goes in an optional `templates/notes/<repo>.md`.
- [x] Write `scripts/sync-agents.sh` that renders the template into a named repo under `.repos/` and reports a diff without committing. It also measures the module and build paragraphs from the clone — root module path, nested modules and their prefixed tags, or the absence of a root module — so those are never hand-typed. `-n` writes nothing.
- [x] Dry-run it against `.repos/prism` and check the output reads well.

#### A2.2: Roll out to the core stack

- [x] Render `AGENTS.md` into mvu, prism, spectrum, pulse, cadence.
- [x] Set each one's role line from the layer table in ADR-001.
- [x] Commit in each of the five repos.

#### A2.3: Roll out to workbench, markdown and the text/draw repos
Carried forward from A2.2: teach the sync script the golden-image flag before
rendering anything, so these eight repos are right first time and the five
already done are re-rendered rather than left to drift.

- [x] Teach `scripts/sync-agents.sh` a third measured paragraph — which packages keep PNGs under `testdata/golden/`, which flag regenerates them, and the command line that actually works — plus the `{{GOLDEN}}` line in the template. Re-render and commit in mvu, spectrum, prism, pulse and cadence; mvu has no goldens and does not move.
- [x] Render into workbench, markdown, font, style, textdraw, backdrop, gradient, circle.
- [x] For `style`, add the ADR-003 freeze note. For `textdraw`, an honest one: ADR-003 freezes `style` and says nothing about `textdraw`, nothing in Phase C touches it, and `MeasureText`, `FillText` and `FillLabel` have no replacement in the design system. Both notes live in `templates/notes/<repo>.md`.
- [x] Commit in each of the eight repos.

**The `-golden.update` incantation in every repo's own doc comments does not
work.** `go test` cannot tell that an unfamiliar flag is boolean, so it stops
treating the rest of the line as package arguments: `go test -golden.update
./...` hands `./...` to the test binary and tests whatever package the current
directory holds. The flag has to come *after* the packages. And `./...` only
works where every test package stores goldens — markdown — because a test
binary rejects a flag it never declared; prism, pulse, spectrum and cadence
all have test packages without goldens, so their packages are named one by
one. The script measures which case a repo is in.

**`workbench/launcher` does not build**, and did not before this task. Its
`go.sum` pins `github.com/vibrantgio/seen/context/gio v0.0.7` to a hash that
no published form of that module produces, so the build stops with a checksum
mismatch. `svg/driver/seen` is stuck on the identical line — A2.4 found it,
and A2.3 missed it by only building the app modules. The diagnosis first
recorded here was wrong: the tag is **not** unpushed. `git ls-remote` shows
GitHub carrying exactly the local tag, and a `GOPROXY=direct` fetch of it
hashes to what the proxy serves — `OJip+UYN…`. Both disagree with `go.sum`,
which records `cCJSzFNE…` for a `context/gio` that was never published, down
to a different `/go.mod` hash. No push closes this seam, because there is
nothing local to push: seen is clean and zero commits ahead. Dropping the two
`seen/context/gio v0.0.7` lines and re-running `go mod tidy` restores the
build — `go mod tidy` alone cannot, since it verifies before it rewrites.
That makes it a consumer-side `go.sum` repair, not one of the ADR-006 tag
seams; whoever schedules it should fix both modules in one change. The other
six app modules are green.
#### A2.4: Roll out to the graphics and geometry repos

These are support libraries, not design-system layers; their AGENTS.md says so.

- [x] Render into ivg, svg, seen, csg, kiwi, noise, traer.
- [x] Mark each as a support library that the design system consumes but that does not depend on it.
- [x] Commit in each of the seven repos.

**No golden paragraph rendered for any of the seven**, and that is correct:
none of them keeps a `testdata/golden/` directory. `noise` comes closest and
is the reason it has a notes file — four tests compare a rendered PNG against
`ref_*.png` embedded from the repository root, and the only way to regenerate
them is to flip `const write_reference_image` in `noise_test.go` to `true`.
Because the bytes each test compares against were embedded when the binary was
built, that takes two runs: the first rewrites the PNGs and still fails, the
second passes against what it just wrote. Verified, not inferred.

**`csg` and `kiwi` have no consumer anywhere in the organization**, so their
layer lines say so instead of reciting the formula. seen carries an adaptation
of csg's BSP kernel as its own `solid` package — same algorithm, rewritten
onto `point.Point`, `face.Faces` and `transform.Transform` so a solid is a
`seen.Object` — rather than importing the module. kiwi's only caller is the
single example in its own `gio` module.

**The support libraries do not depend on the design system, but three of their
nested modules do.** `ivg/raster/gio`, `svg/driver/gio` and `traer/gio` require
the tier-0 leaves `style`, `textdraw` and `circle` — always and only for demo
programs, never for library code. The layer lines say that rather than claiming
a clean separation that the `go.mod` files contradict.

### G-A3: READMEs and package docs
Eleven repos have no README: prism, cadence, spectrum, pulse, font, style,
textdraw, gradient, circle, seen and kiwi — exactly the eleven the tasks
below write. That half of A1.1's inventory holds up.

The other half does not, and A3.2 disproved it. The inventory said the six
core modules "have no `doc.go` anywhere, so pkg.go.dev shows nothing for the
whole stack". The inference is false — pkg.go.dev renders a package comment
wherever it lives, and a `doc.go` is a convention, not a requirement — and
so is the conclusion. Measured across the six by `go doc`:

| module | packages with a package comment |
| --- | --- |
| mvu | 0 of 1 — genuinely blank |
| prism | 13 of 16 before A3.2; a11y, theme and tokens were the gaps |
| spectrum | 4 of 4 |
| pulse | 7 of 7 |
| cadence | 19 of 19 — `modal/gallery` has a `Command gallery` comment too |
| markdown | 4 of 4 |

A3.3 re-measured cadence and found no gap at all: every one of the eighteen
pattern packages carries a multi-paragraph package comment, and the
`modal/gallery` main carries a `Command gallery` one. A3.4 confirmed the
count a third time and was rewritten from "add a `doc.go` to each of the
eighteen" into the audit it actually is. That audit found the comments'
weakness is not absence but thinness: six of the eighteen — alert,
breadcrumb, card, feature, navbar and sidebar — described the pattern and
then stopped, naming no pitfall a caller could trip on. Presence of a
package comment is not evidence of a good one, so measure the later
modules for quality, not for count.

A3.6 found the failure one step further along. pulse's seven comments are
the longest in the organization and three of them are numerically false —
a settle time, a frame count and an intensity claim that the code does not
produce. Length is not evidence either. Where a comment states a number,
run it before believing it.

So A3.4 through A3.7 are mostly audits, not writing jobs. Run `go doc` over
every package in the module first; write where there is nothing, expand a
one-liner into the two-to-five-sentence shape, verify the rest against the
API — numbers included — and leave them be. Do not rehouse a good comment in a `doc.go` for the
sake of the filename. Outside the spine, font, ivg, seen and traer carry a
root `doc.go` and svg carries package-level ones.

Describe the layer and the role — not the API surface, which Phases B–E will
change.

![[#The repo doc contract]]
#### A3.1: prism README

- [x] Write `.repos/prism/README.md` per the doc contract.
- [x] List the packages and one line each: a11y, bench, button, cache, coordination, icon, initial, input, keyed, layout, list, richtext, scrollbar, theme, tokens.
- [x] Note that `theme` and `tokens` move to spectrum in Phase B and will remain as aliases.
- [x] Commit in prism.

#### A3.2: prism package docs
The premise was wrong. Eleven of the fourteen packages listed here already
carried a package comment — in a regular source file rather than a `doc.go`,
which pkg.go.dev does not care about. Only `a11y`, `theme` and `tokens` had
none at all. `icon`, excluded from the list on the correct grounds that it
had a comment, had a one-liner like `input` and `layout` did.

- [x] Add a `doc.go` with a package comment to the three prism packages that genuinely lack one: a11y, theme, tokens.
- [x] Replace the one- or two-sentence comments on button, input, layout and icon with a `doc.go`, deleting the old comment so each package has exactly one. Leave bench, cache, coordination, initial, keyed, list, richtext and scrollbar alone — verify their comments against `go doc` and move on; rehousing a good comment in a `doc.go` is churn.
- [x] Two to five sentences each: what it is, when to reach for it, what it assumes.
- [x] Fix `internal/golden`'s own package comment, which teaches `go test -golden.update ./...` — the exact invocation AGENTS.md documents as broken.
- [x] Correct three factual errors in `llms.txt`, found while checking prism's API: `Initial[T]` is really `initial.Value[T]`; `KeyedDefer` does not exist and the API is `keyed.Defer(factory)` returning `*keyed.Deferred[K,V]`; and the Typography section's REFERENCE CODE named todos, iconbrowser and launcher as correct when only launcher passes the shaper into a component. Commit separately in this repo.
- [x] `go build ./... && go test ./...` in both prism modules; commit in prism.

Left for later, recorded here rather than fixed: `bench`, `cache`,
`coordination` and `richtext` cite `DESIGN §…`, `BASELINE.md`,
`EXPERIMENT-B.md` and `EXPERIMENT-C.md` from their package comments.
`DESIGN.md` and `BASELINE.md` live in `vibrantgio/workbench`, unreachable
from prism's pkg.go.dev page; the two `EXPERIMENT` files exist in no
repository in the org.
#### A3.3: cadence README

- [x] Write `.repos/cadence/README.md` per the doc contract.
- [x] Group the eighteen packages by kind — shells, data, overlays, marketing — with one line each.
- [x] Commit in cadence.

#### A3.4: cadence package docs

A3.4 was authored as *add a `doc.go` to each of the eighteen*. A3.3
measured the module and found nineteen of nineteen packages already
carrying a package comment, which contradicts both the corrected table
above and this goal's own rule against rehousing a good comment in a
`doc.go` for the sake of the filename. Rewritten as the audit it is.

- [x] Re-measure with `go doc` — nineteen of nineteen already carry a package comment, so there is nothing to write and nothing to move into a `doc.go`.
- [x] Audit the eighteen patterns against the doc contract — what the package is for, the real prop shape, one honest pitfall — with prism's comments as the bar. Rewrite in place the ones that are thin or wrong; leave the rest alone.
- [x] Record `cadence/feature`'s missing `Shaper` prop in its package comment, and fix `modal/gallery`'s pre-split run path — from the cadence root it is `go run ./modal/gallery`.
- [x] `go build ./... && go test ./...`; commit in cadence.

#### A3.5: spectrum README and package docs

A3.5 re-measured spectrum with `go doc` and found 4 of 4 packages already
carrying a package comment, exactly as G-A3's table says — so "add `doc.go`
where missing" had nothing to add, and rehousing four good comments in four
new files would have been the churn this goal warns against. The step is an
audit, and the audit's finding matches A3.4's on cadence: the weakness is
thinness, not absence. All four described their package and stopped short of
a pitfall a caller could trip on, and three carried claims worth correcting
— `window`'s comment was two paragraphs of design-phase narrative,
`preferences` offered a rationale (config vs data) in place of a pitfall,
and `transition` explained its split from pulse without saying what its
interpolation cannot do. All four were rewritten in place.

Two defects surfaced that nothing in this plan had recorded. The appearance
observable is **cold**: every subscription starts its own ticker and polls
the `Source` independently, so one `LiveTheme` handed to n consumers polls n
times per interval — measured, not inferred — and on macOS each poll is a
`defaults` fork+exec. All seven workbench apps hand it to two layers today.
And `spectrum/transition` has no consumer anywhere in the organization:
`LiveTheme` swaps palettes in one step, so the cross-fade the package exists
for does not happen in any application, though
`workbench/sitedocs/content/spectrum-live-theme.md` says it does.

- [x] Write `.repos/spectrum/README.md` per the doc contract, describing the foundation role it takes in Phase B.
- [x] Audit the package comments on preferences, system, transition and window against the doc contract; rewrite the thin ones in place.
- [x] State plainly in the README that palette injection does not exist yet and arrives in Phase D.
- [x] `go build ./... && go test ./...`; commit in spectrum.

#### A3.6: pulse README and package docs
A3.6 re-measured pulse with `go doc` and found 7 of 7 packages already
carrying a package comment, exactly as G-A3's table says — and these are the
longest in the organization, several running to four sections with worked
examples. "Add `doc.go` where missing" had nothing to add, so the step is an
audit, as in A3.4 and A3.5.

The finding is a new one. pulse's comments are not thin; they are **wrong**,
and wrong in the way a long confident comment is worst: three of the seven
state a number that the code does not produce. `depth` says shadow intensity
is a function of elevation — it is a single constant alpha at every level,
and only the geometry varies. `motion` says its default spring settles in
~30 frames, "coordinated with `DefaultFrames` so opacity and scale finish
together" — measured, `NewEnter(Options{})` reaches `Settled(0.005)` at frame
52, with scale still at 0.991 when the fade ends. `springbutton` says a press
settles near 250 ms — measured against its own tolerance, 25 frames, ~415 ms
at 60 Hz. Prose describing an API can rot quietly; a number in a comment is a
test that never runs. Where a later task's audit finds one, measure it.

Three defects surfaced that nothing in this plan had recorded. `spring`'s
zero-value `Options` — the fallback a caller gets by passing `Options{}` —
takes **873 frames**, about fifteen seconds at 60 Hz, to settle to 0.005;
neither in-module consumer goes near it. `motion.Options.Spring` falls back
to `DefaultSpring` only when the whole struct is zero, so setting `Stiffness`
alone silently takes `Damping` and `Mass` from `spring`'s soft defaults
instead, giving a damping ratio near 0.02 that rings for thousands of frames.
And `depth`'s interior fill is a hard rectangle painted at full alpha, so the
rounded foreground every one of its three callers paints leaves the shadow's
square corners showing through as dark wedges.

Three of the seven packages have no consumer anywhere in the organization —
`conductor` and `glow` are imported by nothing at all, `motion` by nothing
outside its own tests. `springbutton` is the only variant that was ever
built, and no phase of this plan claims the rest.

- [x] Write `.repos/pulse/README.md` per the doc contract.
- [x] Audit the package comments on conductor, depth, glow, motion, spring, springbutton and tween against the doc contract; rewrite in place the ones that are thin or wrong, and verify every number in them against the code.
- [x] Record the rule that pulse components are explicit variants of prism components, never global decorators.
- [x] `go build ./... && go test ./...`; commit in pulse.
#### A3.7: mvu and markdown package docs
Half writing, half audit. mvu is the writing half: 0 of 1, genuinely blank,
and as tier 0 its package comment is the most-read text in the org after
llms.txt. markdown is the audit half — the row above says 4 of 4 and it
holds: root, `highlight`, `svgimage` and `internal/golden` all carry
comments already, so this task judges them against the doc contract and
rewrites the thin ones *in place*. The original step said "neither has
package docs" and asked for four new `doc.go` files; three of those four
would have rehoused a good comment for the sake of a filename, which G-A3
forbids. mvu has no natural root file, so a `doc.go` there is right.

The named suspect was half right: markdown's root comment cites
`DESIGN §Markdown`, and that document is in **workbench**, a different
repository, so a pkg.go.dev reader cannot follow it — but the comment is
multi-paragraph, not the one-liner the note claimed. Length was not the
problem; the unfollowable citation and the absence of any pitfall were.

**And llms.txt is not wholly accurate either.** Rule 1 said mvu's window
joins frame events with the layers "via `rx.WithLatestFrom2`". That
identifier does not exist anywhere in the organization — `command grep -r`
across all twenty clones returns nothing. `Window.Render` subscribes the
`CombineLatest` of the layers on an rx goroutine, stores each result as an
`atomic.Pointer` snapshot and calls `Invalidate`; the events goroutine
reads the snapshot on the next frame. The rule's *conclusion* was right,
which is why it survived this long. Corrected here. Treat the guide as
measured-until-proven like everything else.

- [x] Write the mvu package comment as `doc.go` — the loop, commands, `MessageOp`, and the AutoConnect counts, agreeing with llms.txt.
- [x] Audit markdown's root, `highlight` and `svgimage` comments in place against the doc contract; measure every number and behaviour before carrying it forward.
- [x] Refresh markdown's README to link the canonical guide.
- [x] `go build ./... && go test ./...`; commit in both.
#### A3.8: text and drawing repo READMEs

Six small repos, a one-pager each — what it does, its one type or function, and
where it sits.

- [ ] Write READMEs for font, style, textdraw, gradient, circle.
- [ ] Expand backdrop's one-line README to the same shape.
- [ ] In `style` and `font`, state that they are not yet wired into the component stack and that Phase C fixes this.
- [ ] Commit in each of the six repos.

#### A3.9: support library READMEs

- [ ] Write READMEs for seen and kiwi.
- [ ] Expand svg's stub README to the doc contract's shape.
- [ ] Leave ivg, csg, noise, traer READMEs as they are; add only the canonical-guide link.
- [ ] Commit in each repo touched.

## Phase B: Repair the module graph

Mechanical, low-risk, and it unblocks everything after it. `spectrum` (theme
runtime) depends on `prism` (components), so the theme sits *above* what it
themes and no application can supply a palette.

**G-B1 is done.** The module cycle is cut, and every module in the org is on
one Gio, one rx and one `go` directive, published as a tagged baseline where
each module references its siblings' current tags. What remains in this phase
is the workspace (G-B2) and the inversion itself (G-B3).

Type aliases make the package moves non-breaking — every downstream repo keeps
compiling untouched.

![[#ADR-001: Spectrum is the foundation, not a consumer]]

### G-B1: Break the cycle and align versions

Done — and it cost far less than these tasks assumed. Three of them were cut
against a picture of the drift that turned out to be wrong, so the findings are
recorded here rather than in a commit message nobody will read again:

- **The breaking change was not in Gio v0.10.** `font.Font.Variant` — the one
  API removal that bit anything — went in **v0.9**, and `font` had already
  fixed it in the commit tagged `v0.0.3`. What actually failed to build were
  two modules still pinned to `font` v0.0.1 and v0.0.2, plus four `go.sum`
  files missing the `golang.org/x/net` entry that `gioui.org/app` gained in
  v0.10. Both classes are dependency staleness, not API drift.
- **Not one golden image moved.** All 160 still match. B1.4–B1.6 were sized
  almost entirely around regenerating them; that work did not exist.
- **Most modules were already on v0.10.0.** Only eight were on v0.9, and
  `kiwi/gio` was already on v0.10.1. "Three Gio versions in play" was true but
  described a much smaller gap than it sounded like.

The alignment went further than this goal asked, because the versions being
"all over the place" was the real complaint: every *directly required* external
dependency now resolves to a single version org-wide, and all 36 modules
declare `go 1.25.1`. Transitive-only deps are deliberately left alone —
`go mod tidy` strips a pin on a module the pinning module does not itself
import, so they cannot be unified and chasing them re-diverges every tidy.

#### B1.1: Cut pulse out of prism

`prism/gallery/main.go` imports `pulse/springbutton`. That single demo file is
what puts `pulse` in prism's `go.mod` and closes the cycle.

- [x] Give `prism/gallery` its own `go.mod` as a nested module requiring prism and pulse.
- [x] Remove `github.com/vibrantgio/pulse` from prism's `go.mod`; `go mod tidy`.
- [x] Confirm `go list -m all` in prism no longer mentions pulse.
- [x] `go build ./... && go test ./...` in both prism and prism/gallery; commit in prism.
- [x] Note the extraction hazard: every prism ≤ v0.0.9 still carries `gallery/` inside the prism module, so the nested module's own import path is ambiguous until a prism without it is published. `gallery` was therefore tagged separately, after prism v0.1.0.

#### B1.2: Survey the Gio v0.9 → v0.10 drift

- [x] Read Gio's v0.10 release notes and changelog; list every breaking API change.
- [x] Grep the six core modules for each one; record which repos and which files are hit.
- [x] Count the golden images in prism, pulse, cadence and markdown — 160, of which zero moved.
- [x] Write the findings into this goal's preamble above; re-cut B1.3–B1.6 accordingly.
- [x] Commit here in the plan repo.

#### B1.3: Align mvu and spectrum

- [x] Set gioui.org v0.10.1 and reactivego/rx v0.3.0 in mvu and spectrum.
- [x] `go mod tidy` in each.
- [x] Migrate spectrum's four `Subscribe` call sites: rx v0.3.0 moved the scheduler out of the argument list and into a context, so `Subscribe(observer, scheduler)` became `Subscribe(ctx, observer)`. All four are in tests; prism's idiom — `context.Background()` for synchronous helpers, `rx.GoroutineContext()` for the concurrent one — was already correct and was copied.
- [x] Bump spectrum and pulse to mvu v0.4.1: published mvu v0.2.0 calls the old `Subscribe` itself and cannot compile against rx v0.3.0.
- [x] `go build ./... && go test ./...` in both; commit in each.

#### B1.4: Align prism and its galleries

- [x] Set the same versions in prism and `prism/gallery`. (`prism/button/gallery` and `prism/icon/gallery` are ordinary packages inside prism, not modules — only the top-level gallery was ever separate.)
- [x] `go mod tidy`; no goldens moved.
- [x] `go build ./... && go test ./...`; commit in prism.

#### B1.5: Align pulse and markdown

- [x] Set the same versions in pulse and markdown.
- [x] `go mod tidy` in each; no goldens moved.
- [x] `go build ./... && go test ./...` in each; commit in each.

#### B1.6: Align cadence

- [x] Set the same versions in cadence.
- [x] `go mod tidy`; all eighteen packages green, no goldens moved.
- [x] `go build ./... && go test ./...`; commit in cadence.

#### B1.7: Align the leaf repos

- [x] Set the same Gio version in font, style, textdraw, backdrop, gradient, circle.
- [x] Align the support libraries too — svg, seen, ivg, kiwi, traer, noise and csg all carry Gio-dependent nested modules or are reached from the core.
- [x] Fix the one real bug this surfaced: raising svg's `go` directive enabled Go 1.24's non-constant-format-string vet check, which caught `parser/elementfuncs.go:441` passing a pre-concatenated message to the printf-like `HandleError`. Any SVG element whose tag contained a `%` was misformatted.
- [x] `go mod tidy`, build and test each.
- [x] Commit in each repo touched.

### G-B2: One workspace, one resolution strategy

Everything from here to the end of Phase E is a cross-repo change, and twenty
separate Go modules do not compile against each other's uncommitted work by
wishing. B3.3 is where it bites first: `prism/tokens` becomes an alias for a
`spectrum/tokens` that no published spectrum tag contains. Settle how the
modules resolve before moving a single package.

**This comes after G-B1, not before it.** A workspace computes one build list
across all its members, so the moment `go.work` exists every module resolves
its shared dependencies at the highest version any member asks for. With the
Gio versions still spread that would have compiled the v0.9 modules against
v0.10 and failed. G-B1 settled it, so the ordering constraint is now satisfied
rather than pending — but keep the ordering, because it is the reason this
works.

**A second, sharper hazard, learned the hard way during G-B1.** A single
member requiring a version that does not exist yet breaks the *entire*
workspace, not just that member: MVS resolves across all members, so one
unresolvable requirement takes every module down at once. Writing a go.mod
that names a tag you are about to cut turns a 36-module green sweep into
5-of-36. Pin published versions, verify, and only then cut tags.

![[#ADR-006: One workspace while developing, tags at the seams]]

#### B2.1: Establish the Go workspace

- [ ] Write `go.work` at the root of this repo listing all **36** modules — nineteen repository roots (`workbench` has no root module of its own), the ten nested ones: `prism/gallery`, `mvu/example`, `ivg/raster/gio`, `kiwi/gio`, `traer/gio`, `seen/context/gio` and `svg/driver/{gio,pdf,raster,seen}`, and `workbench`'s seven apps: `feeds`, `iconbrowser`, `launcher`, `mindchat`, `sitedocs`, `todos`, `watchlist`. Generate the list with `find .repos -name go.mod`; do not hand-maintain it. (`prism/button/gallery` and `prism/icon/gallery` are packages, not modules.)
- [ ] Confirm that from each module, `go build ./... && go test ./...` resolves its siblings from the working tree rather than the module cache.
- [ ] Confirm the resolved Gio and rx versions are the single ones G-B1 settled on — if the workspace pulls something higher, a module was missed and B1 is not actually done.
- [ ] Confirm the same commands under `GOWORK=off` still pass, resolving from published tags. This is what CI sees, and the gap between the two is what ADR-006 manages. Both sweeps were green at 36/36 when the G-B1 baseline was tagged; this task is about making that repeatable, not discovering it.
- [ ] Write `scripts/check-no-workspace.sh`: run the whole stack with `GOWORK=off` and report which modules fail and why. Expect failures from B3.3 onward; the script records the debt, it does not pay it.
- [ ] Confirm no member repo carries a `replace` directive, and note in the script header that none may be added — a committed `replace` in a public module breaks every consumer outside this working tree.
- [ ] Settle whether `go.work` is committed here: A1.1's `.gitignore` ignores it *and* `go.work.sum`, while this step was written assuming the file itself is committed and only the sum ignored. ADR-006 forbids it only in *member* repos, so either is defensible — decide, then make `.gitignore` and this step agree.
- [ ] Commit the script here, and `go.work` too if the step above says so.
### G-B3: Invert the foundation

Move the token and theme contract down into spectrum so the theme runtime is
beneath the components it themes. Alias shims keep prism's import paths alive
for one release.

#### B3.1: Move the tokens into spectrum

- [ ] Copy `prism/tokens/*.go` (including tests) to `.repos/spectrum/tokens/`.
- [ ] Keep the package name `tokens` and every exported identifier unchanged.
- [ ] `go build ./... && go test ./...` in spectrum; commit.

#### B3.2: Move the theme contract into spectrum

- [ ] Copy `prism/theme/*.go` (including tests) to `.repos/spectrum/theme/`, repointing its tokens import.
- [ ] Repoint `spectrum/system` and `spectrum/window` at the local theme package; drop the prism requirement from spectrum's `go.mod` if nothing else needs it.
- [ ] `go build ./... && go test ./...` in spectrum; commit.

#### B3.3: Leave alias shims in prism

- [ ] Replace `prism/tokens`'s bodies with type aliases and variable re-exports pointing at `spectrum/tokens`.
- [ ] Do the same for `prism/theme`.
- [ ] Mark both packages `Deprecated:` with the replacement path.
- [ ] Confirm prism, pulse, cadence and markdown all still compile with no source changes; commit in prism.

#### B3.4: Move transition into pulse

`spectrum/transition` depends on `pulse/tween`, which would make the foundation
depend on the effects layer. It is animation code; it belongs in pulse.

- [ ] Copy `spectrum/transition` to `.repos/pulse/transition`, repointing imports at `spectrum/tokens`.
- [ ] Leave a deprecated alias shim at `spectrum/transition`.
- [ ] Build and test both; commit in each.

#### B3.5: Make the layering enforceable

- [ ] Write `scripts/check-layers.sh` here: for each module, `go list -deps` and assert only the edges ADR-001's tier table permits — the whole table, including the tier 0 leaves and the support-library row, not just the six-module spine.
- [ ] Teach it the nested-module exemption: `prism/gallery` and `mvu/example` may import above their parent's tier; their parents may not.
- [ ] Run it across all twenty modules; fix or record any violation it finds.
- [ ] Wire it into each core repo's CI workflow. A1.1's inventory says which repos have a `.github/workflows/` at all — where there is none, add a minimal build-and-test workflow first, since the check has to run somewhere.
- [ ] Commit the script here and the workflow change in each repo.

## Phase C: The theme owns the typeface

The fix for the Roboto problem. `TypeScale` is fifteen `float32` sizes — there
is nowhere in the theme to put a typeface, so all seventeen `Props` structs and
118 function signatures carry a `*text.Shaper`, every one of which falls back to
`gofont.Collection()` inside library source.

![[#ADR-003: The theme owns the typeface]]

### G-C1: Define the typography token

#### C1.1: TextStyle and Typography

- [ ] In `spectrum/tokens`, add `TextStyle{Typeface, Weight, Size, LineHeight, Tracking}`.
- [ ] Add `Typography` with one `TextStyle` per MD3 role — Display/Headline/Title/Label/Body × Large/Medium/Small.
- [ ] Populate `DefaultTypography` with the MD3 metrics: sizes as today, plus the matching line heights and tracking.
- [ ] Unit-test that every role has a non-zero size, weight and line height.
- [ ] Build, test, commit in spectrum.

#### C1.2: Make Roboto the default face

- [ ] Add `Faces []font.FontFace` to `Typography`, defaulting to `vibrantgio/font/roboto.FontFaces()`.
- [ ] Add a `Shaper()` method that builds the shaper once, lazily, and caches it.
- [ ] Add `github.com/vibrantgio/font` to spectrum's `go.mod`.
- [ ] Test that the default shaper resolves Roboto for every weight the scale names.
- [ ] Build, test, commit in spectrum.

#### C1.3: Put typography in the theme

- [ ] Add `Typography rx.Observable[tokens.Typography]` to `theme.Theme`.
- [ ] Update `theme.Default()`, `theme.AutoLightDark()`, `system.LiveTheme()` and `system.FromSourceTheme()` to emit it.
- [ ] Update the prism alias shim so `prism/theme.Theme` still matches.
- [ ] Build and test spectrum and prism; commit in each.

#### C1.4: Deprecate the standalone type scale

`style`'s MD2 scale is superseded, and it carries a real bug — `H1` and `H2` are
both 96 dp, where MD2's H2 is 60.

- [ ] Mark every exported symbol in `style` `Deprecated:` with the `spectrum/tokens.Typography` replacement.
- [ ] Fix the `H2` size to 60 so the deprecated path is at least correct.
- [ ] Note in `style`'s README that it is frozen.
- [ ] Build, test, commit in style.

### G-C2: Migrate components off gofont

One task per component group. Each ends with green tests — including
regenerated goldens, which will move for every one of these.

Pattern for each component: read `Typography` from the theme, use the role's
`TextStyle` for typeface, weight, size and line height, and keep `Props.Shaper`
only as an explicit override that defaults to the theme's shaper. No library
file may import `gofont` when the group is done.

#### C2.1: prism/button

- [ ] Take the shaper and `LabelLarge` style from the theme's `Typography`.
- [ ] Remove the `gofont` import and the inline fallback shaper.
- [ ] Keep `Props.Shaper` as an override; document it as such.
- [ ] Regenerate goldens; build, test, commit.

#### C2.2: prism/input

- [ ] Migrate textfield, dropdown, checkbox and radio the same way.
- [ ] Remove every `gofont` import in the package.
- [ ] Regenerate goldens; build, test, commit.

#### C2.3: prism remaining packages

- [ ] Migrate richtext, list, scrollbar and layout.
- [ ] Migrate `prism/gallery` (nested module) and `prism/button/gallery`.
- [ ] Confirm no `gofont` import remains anywhere in prism, tests included.
- [ ] Regenerate goldens; build, test, commit.

#### C2.4: pulse

- [ ] Migrate springbutton and depth.
- [ ] Confirm no `gofont` import remains in pulse.
- [ ] Regenerate goldens; build, test, commit.

#### C2.5: cadence — data and navigation

- [ ] Migrate table, tabs, sidebar, navbar, pagination.
- [ ] Regenerate goldens; build, test, commit.

#### C2.6: cadence — overlays

- [ ] Migrate tooltip, alert, accordion, toast, popover, modal.
- [ ] Regenerate goldens; build, test, commit.

#### C2.7: cadence — content and shells

- [ ] Migrate card, hero, feature, pricing, testimonial, breadcrumb, shell.
- [ ] Confirm no `gofont` import remains anywhere in cadence.
- [ ] Regenerate goldens; build, test, commit.

#### C2.8: markdown

- [ ] Migrate the document renderer, highlight and svgimage to theme typography.
- [ ] Confirm no `gofont` import remains, tests included.
- [ ] Regenerate goldens; build, test, commit.

### G-C3: Lock it in

The rule that prevents this whole class of regression.

#### C3.1: The no-gofont lint

- [ ] Write a Go test that walks the module and fails on any `gioui.org/font/gofont` import.
- [ ] Add it to prism, pulse, cadence and markdown.
- [ ] Confirm it fails when a gofont import is reintroduced deliberately, then passes.
- [ ] Wire it into each repo's CI; commit in each.

#### C3.2: The no-literal-colour lint

- [ ] Write a test that fails on `color.NRGBA{...}` literals outside `spectrum/tokens` — and `spectrum/color` too, which D1.1 creates a phase from now.
- [ ] Add it to prism, pulse, cadence and markdown; allow-list the deliberate exceptions with a comment explaining each.
- [ ] Wire into CI; commit in each.

#### C3.3: Refresh the guide's typography section

A1.3 documented the shaper-passing practice this phase has just deleted. The
canonical guide is the plan's own front door; leaving it wrong through Phases D
and E teaches every assistant exactly the defect Phase C existed to remove.
F2.1 rewrites the whole file — this is the one section that cannot wait for it.

- [ ] Replace `llms.txt`'s `## Typography` section with the theme-owned contract: read `Typography` from the theme, never construct a shaper, never pass `Shaper` except as a deliberate override.
- [ ] Note that the no-gofont lint now runs in CI, so the old practice fails the build rather than merely being discouraged.
- [ ] Keep the known-wrong app list — F1 is what fixes those — but say plainly that the library contract has moved and the apps have not caught up yet.
- [ ] Commit here.

## Phase D: Generative colour
Material Design's real contribution is not its palette, it is that colour is
*derived*: one seed becomes tonal palettes becomes semantic roles, with light
and dark as tone mappings rather than two hand-written structs. Today the token
package wears MD3's names over Tailwind's values, ships thirteen flat colours,
and exposes no way for an application to supply a palette at all.

G-D1 is firm — the approach was validated against the MD3 default seed before
this plan was written. G-D2 and G-D3 are provisional; re-cut them against what
Phases B and C actually landed before starting G-D2.

![[#ADR-002: CIELAB tone with OKLCh hue and chroma]]

### G-D0: Choose the role-assignment model
ADR-002 settles how tones are *derived*. It does not settle how they are
*assigned*, and there are three coherent answers in the field:

- **MD3** — thirteen tone stops (0, 10, … 95, 99, 100). Tones are purely
  perceptual: tone 40 means lightness 40, and a separate role table says which
  tone each role takes in light and in dark. The table is where the design
  knowledge lives, and it is maintained twice.
- **Radix** — twelve steps whose *number carries the meaning*: step 3 is the
  component background, step 9 the solid fill, step 11 low-contrast text. Paired
  light and dark scales are built so the same step works in both, so dark mode
  swaps one scale instead of maintaining a second role table. Contrast is
  guaranteed in APCA (Lc 60 and Lc 90 for steps 11 and 12 over step 2).
- **Claude Design** — nine steps, 100–900, generated in OKLCH on a shared
  perceptual lightness scale so the same step of any ramp carries the same
  visual weight. 500 is the role's base; 100–300 are tinted fills, hovers and
  subtle borders; 700–900 are text on tinted fills and pressed states. Fewer
  steps than Radix, same functional idea.

For a component library this is not cosmetic: it decides whether prism and
cadence read a role table or a step index, and whether dark mode is a second
table to keep in sync. Deciding after G-D2 costs seven migrations; deciding here
costs one spike.

The third option carries a practical argument the other two do not. G-E0 pushes
the token sheet to Claude Design, and Phase G builds a component surface there.
If spectrum's ramp and that surface's ramp disagree, every prototype speaks a
different vocabulary from the app it is prototyping — the exact incoherence this
plan exists to remove.

#### D0.1: Spike — choose the ramp model and the contrast metric

Timeboxed. The deliverable is a recommendation with evidence, not an
implementation — write no code into `spectrum`. A throwaway script is fine and
should be thrown away.

- [ ] Read each model's own account of itself: Radix's twelve-step purposes and paired dark scales, MD3's role→tone table, and the Claude Design project's readme and `theme.json` for the 100–900 OKLCH ramp.
- [ ] If that last project is not reachable from this machine, say so plainly and decide between the two models that are. Do not block on it, and do not guess at a ramp you could not read.
- [ ] Lay all three against the same surfaces: app background, card, hover, pressed, subtle border, strong border, solid fill, low-contrast text, body text.
- [ ] Note where nine steps cannot express something twelve can, and whether prism and cadence actually need that distinction.
- [ ] Generate all three mappings from the `#6750A4` seed with a throwaway script and compare the resulting surfaces side by side, light and dark.
- [ ] Evaluate APCA (Lc) against WCAG 2 ratios on the light-on-dark pairs specifically — WCAG 2 is known to over-rate them, and spectrum tracks OS dark mode by default.
- [ ] Weigh the prototyping argument explicitly: matching Claude Design's ramp keeps one vocabulary across the app and the design surface, and that is worth real points against a model that scores better in isolation.
- [ ] Decide, and write the outcome into `## Reference` as ADR-007, embedded into Phase D.
- [ ] Amend ADR-002 wherever the decision contradicts it. That ADR currently commits to keeping "MD3's role vocabulary and its tone-assignment tables", which a functional-step model replaces outright. Its *mathematics* — CIELAB tone with OKLCh hue and chroma — survives all three models and is not reopened here.
- [ ] Re-cut G-D2 to match the decision, and adjust D2.4's contrast target if APCA wins.
- [ ] Check the three later places that already assume a ramp shape — E0.1's `--color-*` token families, E0.2's colour page and its step-purpose notes, and G1.2's class vocabulary — and re-cut whichever no longer reads true.
- [ ] Commit in the plan repo.

### G-D1: The colour engine
Built in `spectrum/color`, with no external dependency. The CIELAB conversion
chain is lifted from `reactivego/luminance` rather than imported — ADR-002
records why.

#### D1.1: The CIELAB tone axis

MD3's tone *is* CIELAB L\*, so this axis is what the whole palette hangs from.
`reactivego/luminance` already implements the chain correctly and without
dependencies; lift the math in rather than taking the package as a dependency.

- [ ] Create `spectrum/color`; lift the sRGB ↔ XYZ(D65) ↔ CIELAB conversions from that package's `luminance.go`.
- [ ] Keep the D65 white point and the CIE ϵ/κ constants exactly as they are.
- [ ] Leave behind `Lighten`, `Darken`, `LightenRGBA`, `DarkenRGBA` and `Kn` — a chroma.js port tuned to the retired MD2 Color Tool, and MD3 has no lighten/darken concept.
- [ ] Note in the file header that these functions came out of MD2-era tone work, so a later reader does not go looking for MD3 semantics in them.
- [ ] Write the round-trip tests the original never had: the sRGB cube at 1% tolerance, plus published CIELAB reference values.
- [ ] Build, test, commit.

#### D1.2: OKLab and OKLCh

Hue and chroma come from OKLab. This is the axis pair plain CIELAB `a,b` cannot
hold perceptually constant.

- [ ] Add sRGB ↔ linear sRGB ↔ OKLab ↔ OKLCh conversions alongside the CIELAB chain.
- [ ] Round-trip tests across the sRGB cube at 1% tolerance.
- [ ] Test against published OKLab reference values.
- [ ] Build, test, commit.

#### D1.3: Gamut mapping

The defect that makes the copied code unusable as-is: `luminance.RGB` clamps R,
G and B independently, which is not gamut mapping. Measured on the MD3 default
seed `#6750A4`, it costs 41 chroma and 20° of hue at the light end — tone 100
lands on `#ffefff` instead of white, tone 0 on `#01003f` instead of black.
Tones 10–70 are unaffected and already exact.

- [ ] Implement chroma reduction at constant L\* and constant OKLCh hue to bring an out-of-gamut colour into sRGB.
- [ ] Replace every independent per-channel clamp on the conversion path.
- [ ] Test the hard cases: saturated blues and purples at tones 0, 90, 95, 99 and 100.
- [ ] Assert tone 100 is exactly white and tone 0 exactly black, for every hue.
- [ ] Assert a mapped result is always in gamut and its hue never moves more than 1°.
- [ ] Build, test, commit.

#### D1.4: Tones and contrast

- [ ] Add `Tone(hue, chroma float64, tone int) color.NRGBA` — tone 0–100 on the L\* axis at fixed OKLCh hue and chroma.
- [ ] Add WCAG relative-luminance and contrast-ratio helpers.
- [ ] Test that tone is monotonic in luminance across all thirteen MD3 stops.
- [ ] Regression-test the `#6750A4` palette: tone 40 must reproduce the seed exactly.
- [ ] Build, test, commit.
### G-D2: The role set

#### D2.1: Define the full MD3 role set

- [ ] Extend `ColorTokens` to the full set: Primary/Secondary/Tertiary/Error each with On, Container and OnContainer; Surface with the five SurfaceContainer levels; OnSurface, OnSurfaceVariant; Outline, OutlineVariant; InverseSurface, InverseOnSurface, InversePrimary; Scrim, Shadow.
- [ ] Keep every field name currently in use so nothing breaks.
- [ ] Build, test, commit.

#### D2.2: Derive a palette from a seed

- [ ] Add `FromSeed(seed color.NRGBA) (light, dark ColorTokens)` using the MD3 tone assignments.
- [ ] Golden-test the default seed against a recorded palette.
- [ ] Replace `DefaultLight`/`DefaultDark` with values derived from the default seed.
- [ ] Remove the verbatim Tailwind ramp from the semantic layer. Per ADR-002 it may survive only as an optional named palette provider — never behind a role name, which is the arrangement that made the tokens three design systems in a trench coat.
- [ ] Build, test, commit.

#### D2.3: State layers

- [ ] Add hover, focus, pressed, dragged and disabled opacity tokens.
- [ ] Add a helper that composites a state layer over a role colour.
- [ ] Build, test, commit.

#### D2.4: Contrast conformance

- [ ] Test that every On*/base pair meets WCAG AA in both light and dark.
- [ ] Test the same for the high-contrast variant once E3.3 lands, or record the gap.
- [ ] Fix any tone assignment that fails; commit.

#### D2.5: Migrate prism to the new roles

- [ ] Replace flat-token uses with the role that matches each surface's meaning.
- [ ] Regenerate goldens; build, test, commit.

#### D2.6: Migrate cadence to the new roles

- [ ] Same, across all eighteen packages.
- [ ] Regenerate goldens; build, test, commit.

#### D2.7: Migrate pulse and markdown to the new roles

- [ ] Same, including `pulse/transition`'s per-field interpolation, which must cover every new role.
- [ ] Regenerate goldens; build, test, commit.

### G-D3: Let applications and the OS drive the palette

#### D3.1: Palette injection

The gap that makes branding impossible today: `LiveTheme` hardcodes the default
palette, so choosing your own colours means giving up OS dark-mode tracking.

- [ ] Add options so a caller supplies a seed or a full palette and still gets live light/dark switching.
- [ ] Update `LiveTheme` and `FromSourceTheme` to take them.
- [ ] Test that a custom seed survives a light→dark transition.
- [ ] Build, test, commit.

#### D3.2: Wire the macOS accent

`spectrum/system` already reads `AppleAccentColor` and then discards it.

- [ ] Map the accent index (−1..7) to its seed colour.
- [ ] Regenerate the palette when the accent changes.
- [ ] Test with a fake `Source` driving each index.
- [ ] Build, test, commit.

#### D3.3: Windows and Linux accent sources

- [ ] Read the Windows accent colour from the registry.
- [ ] Read the GNOME/KDE accent where available; fall back to the seed otherwise.
- [ ] Document per platform what is and is not supported.
- [ ] Build, test, commit.

## Phase E: Reimagined for desktop
Where MD3 assumes touch and Android, diverge deliberately and say why. This is
what makes the system VibrantGio's rather than a port.

G-E1 is firm. G-E2 and G-E3 stay provisional; re-cut them when Phase D lands.

![[#ADR-005: MD3's system, not MD3's look]]

### G-E0: Token export and the prototyping surface

Every decision in this phase is a look-and-feel decision, and each one is far
cheaper to judge in a browser than by regenerating Gio goldens. Build the export
first so the rest of Phase E can use it.

The foundations are *derived* values — once ADR-002's engine exists, emitting
them is a serialiser, not a second design system. The target is the project
layout `claude.ai/design` consumes: `theme.json` as the machine-readable
parameters, `styles.css` as the token sheet, and foundation pages that render
the scales at real sizes. Components are explicitly out of scope here; they are
Phase G, after they stop changing.

Generated output lives in `design/` at the root of this plan repo and is
committed, so every push is a reviewable diff.

**G-E0 exports what Phase D landed** — colour, type, spacing, radius. Density,
tonal elevation and the motion set all change later in this very phase, so
G-E5 re-exports at the end of it. Do not reach for them here; the tokens do not
exist yet.

#### E0.1: The token serialiser

- [ ] Create `spectrum/export`: given a `theme.Theme` emission, write `theme.json` and the `:root` / dark token sheet of `styles.css`.
- [ ] Emit the token families Claude Design expects: `--color-*` (role bases plus their tonal ramps, in whatever shape ADR-007 chose), `--font-*`, `--space-*`, `--radius-*`, and `--shadow-*` from today's elevation levels — E2.1 replaces those with surface roles and E5.1 re-emits them.
- [ ] Record the generative parameters in `theme.json` — seed hue, saturation, any pinned roles, base radius, heading and body faces — so the theme is reproducible from the file alone. Density and the motion set belong here too but are E5.1's; they do not exist yet.
- [ ] Write a round-trip test: parse the emitted CSS back and assert every value matches the Go token it came from, so the two cannot drift.
- [ ] Add `cmd/vg-tokens` writing the pair into a target directory.
- [ ] Build, test, commit in spectrum.

#### E0.2: The foundation pages

Static HTML that reads only from the emitted token sheet — no hard-coded values,
so a theme change reflows every page.

- [ ] Generate `foundations/color.html`: each role with its full ramp, annotated in ADR-007's own terms — step purposes if it chose a functional ramp, tone values if it chose MD3's — and the measured contrast of each text pair against its ground.
- [ ] Generate `foundations/type.html`: every type role at its real size, weight, line height and tracking, in the actual faces.
- [ ] Generate `foundations/layout.html`: the spacing scale, radius scale and elevation steps as rendered specimens. Elevation as it stands today; E5.1 re-renders it once E2.1 has remapped it to surface roles.
- [ ] Generate `readme.md` for the project describing the system and naming the token families — the file a human or an agent reads first.
- [ ] Confirm every page renders correctly against a dark theme emission as well as light.
- [ ] Build, test, commit in spectrum; commit the generated `design/` here.

#### E0.3: Push to Claude Design

- [ ] Run `cmd/vg-tokens` into `design/`, then push it to the VibrantGio design project with DesignSync — plan first, write the sentinel, write the files, re-arm the sentinel.
- [ ] Open the project and confirm the foundation pages render as generated.
- [ ] Write `scripts/push-design.sh` capturing the regenerate-and-push sequence so later phases re-push in one step.
- [ ] Record the project UUID here in the plan repo, next to the script.
- [ ] Commit here.

### G-E1: Density
Desktop density is the sharpest divergence from MD3, and the one users feel
first. Targets come from shadcn/ui's metrics rather than being invented, per
ADR-005.

#### E1.1: Measure the target metrics

Establish the numbers before changing any component, so every later task has one
table to work from and reviewers can argue with the source rather than the
diffs.

- [ ] Record shadcn/ui's control metrics: default and small button heights, input height, base radius, and the spacing step between stacked controls.
- [ ] Record MD3's equivalents alongside them, and macOS's 28 pt standard control height as the native reference point.
- [ ] Write the three-way table into `spectrum/tokens/density.go` as a doc comment — it is the justification for every number below it.
- [ ] Pick `Comfortable` and `Compact` values from that table; keep prism's existing 44 dp as `Comfortable` only if the table supports it.
- [ ] Commit here in the plan repo if the table changes ADR-005's claims; otherwise commit in spectrum.

#### E1.2: The density token

- [ ] Add `Density` to `spectrum/tokens` with `Comfortable` and `Compact`, carrying control height, inner padding and the minimum hit target.
- [ ] Add it to `theme.Theme` as an observable, alongside Typography.
- [ ] Keep the WCAG 2.5.5 minimum hit target independent of density — `Compact` may shrink the visual control but never the pointer target.
- [ ] Unit-test that both settings satisfy the hit-target floor.
- [ ] Build, test, commit in spectrum.

#### E1.3: Density through prism

- [ ] Replace the hardcoded `minHeight = 44dp` in `prism/button` with the density-derived value.
- [ ] Apply density to input, checkbox, radio, dropdown and list row height.
- [ ] Apply density to `prism/icon`'s default sizes — an icon that stays put while its control shrinks is the tell that density is only half-wired.
- [ ] Add a golden per component at each density.
- [ ] Build, test, commit in prism.

#### E1.4: Density through cadence

- [ ] Apply density to table row height, navbar height, sidebar item height, tabs and pagination controls.
- [ ] Check the overlays — modal, popover, tooltip, toast — for control metrics that should follow density too.
- [ ] Add a golden per component at each density.
- [ ] Build, test, commit in cadence.
### G-E2: Tonal elevation

#### E2.1: Elevation becomes a surface role

- [ ] Map each `ElevationLevel` to its `SurfaceContainer` role rather than a shadow depth in dp.
- [ ] Migrate prism and cadence surfaces to the tonal mapping.
- [ ] Regenerate goldens; build, test, commit.

#### E2.2: Shadows become opt-in vibrancy

- [ ] Keep `pulse/depth` as an explicit effect, not a default.
- [ ] Document when a shadow is right and when tonal elevation is, and the cost difference in Gio.
- [ ] Build, test, commit.

### G-E3: Motion and accessibility as theme inputs

#### E3.1: MD3 motion

- [ ] Replace the CSS easing names with MD3's standard and emphasized easing sets.
- [ ] Add MD3's duration stops alongside them.
- [ ] Add spring specifications for the pulse physics path.
- [ ] Update pulse to consume them; regenerate goldens; build, test, commit.

#### E3.2: Accessibility preferences reach the theme

- [ ] Route `prism/a11y`'s reduced-motion and contrast observables into the theme so components read one source.
- [ ] Move the a11y source into spectrum if the layering requires it; leave an alias in prism.
- [ ] Test that reduced motion makes animated components snap to their target.
- [ ] Build, test, commit.

#### E3.3: High-contrast palette

- [ ] Derive a high-contrast variant from the same seed by widening tone separation.
- [ ] Switch to it when the OS reports increased contrast.
- [ ] Assert WCAG AAA on the variant's On*/base pairs.
- [ ] Build, test, commit.

### G-E4: Blur
Gio exposes no blur primitive and no custom shaders — `op/paint` offers
`ColorOp`, `ImageOp`, `LinearGradientOp`, `PushOpacity`, and an `ImageFilter`
that only selects linear vs nearest *scaling*. But `gioui.org/gpu/headless`
provides the missing piece: `NewWindow(w, h)`, `Frame(*op.Ops)` and
`Screenshot(*image.RGBA)` render an op list to an offscreen GPU surface and
read the pixels back. That is a real backdrop-blur pipeline built from Gio's
own primitives — render the layer behind, read it, blur it, paint it as an
`ImageOp`. The org already depends on this package: it is what
`prism/internal/golden` and every cadence and pulse golden test are built on.

Own the blur itself rather than importing one. All three candidates were
measured and all three are compromised: `disintegration/imaging` works but has
been unmaintained since 2021; `anthonynsimon/bild`'s Gaussian is roughly twice
as slow and its `Box` is 16× slower than its own Gaussian, which looks like a
bug; `esimov/stackblur-go` silently returns a uniform image from an
`*image.RGBA` source and reports no error.

Measured on a ten-core Apple Silicon machine; a 60 fps frame budget is 16.7 ms.
Full pipeline for a 1440×900 backdrop — headless render, readback, blur —
where the divisor is the resolution the backdrop is *rendered* at, since the
blur destroys that detail anyway:

    ÷1  1440×900   69.2 ms
    ÷2   720×450   12.9 ms
    ÷4   360×225    3.8 ms      <- the working configuration
    ÷8   180×112    1.6 ms

Two caveats that shape the design. `headless.NewWindow` costs 1.1 ms, so the
offscreen surface is allocated per size and reused, never per frame. And
headless rendering is not available on every platform — the golden harness
already calls `t.Skipf` when it is not — so anything shipping this at runtime
needs a defined fallback rather than a crash.

#### E4.1: The blur kernel

Three successive box blurs approximate a Gaussian to within a few percent —
the same approach CSS implementations use — and a separable box blur is
trivially parallelisable.

- [ ] Create `pulse/blur`: a separable 3-pass box blur over `image.NRGBA`, horizontal then vertical, parallelised across `runtime.NumCPU()`.
- [ ] Test convergence against a reference Gaussian: compare per-channel variance reduction and assert the difference stays within a few percent.
- [ ] Test the edges — a blur that darkens or wraps at the borders is the usual bug; assert a uniform input stays uniform right up to the edge.
- [ ] Benchmark against the table above and record the numbers in the package doc.
- [ ] Build, test, commit in pulse.

#### E4.2: Cached blur for static imagery

The simple case, and the one with no platform caveat: a known source image
blurred once and reused.

- [ ] Add a helper that blurs a source image and returns a `paint.ImageOp`, caching on source identity, radius and target size.
- [ ] Support the downscale-blur-upscale path for large radii; expose the divisor and default it from the radius.
- [ ] Test that a repeated call with unchanged inputs does no work, and that a size or radius change invalidates.
- [ ] Build, test, commit in pulse.

#### E4.3: The headless backdrop pipeline

- [ ] Add a backdrop type that owns a `headless.Window`, renders a caller-supplied layer into it at a reduced resolution, reads it back, blurs it, and yields a `paint.ImageOp` stretched to full size.
- [ ] Allocate the headless window per size and reuse it; reallocate only on resize.
- [ ] Choose the divisor from the blur radius so callers ask for a look, not a resolution.
- [ ] Handle unavailable headless rendering explicitly — a documented fallback (flat tinted surface), never a panic.
- [ ] Decide and document the refresh policy: this runs on the events thread and stalls it, so it must be driven by content change, not by every frame.
- [ ] Benchmark the assembled pipeline and confirm it matches the table above.
- [ ] Build, test, commit in pulse.

#### E4.4: Evaluate blur-based glow

`pulse/glow` composes eight linear gradients — four edges, four corners —
because Gio has no radial gradient. A real blur gives a true radial falloff and
works for arbitrary shapes, not rectangles only. Whether it *wins* depends on
whether the cache holds while the glow animates.

- [ ] Prototype a glow that renders the shape offscreen, blurs it, and paints the result.
- [ ] Compare against the current eight-gradient halo: visual quality, and cost per frame when the glow animates and the cache misses.
- [ ] Decide. Keep the gradient path if the animated case cannot be cached cheaply — a correct approximation beats a slow exact answer.
- [ ] Record the decision and its evidence in `pulse/glow`'s package doc either way.
- [ ] Build, test, commit in pulse.

### G-E5: Re-export the foundations

G-E0 exported what Phase D had landed. Density, tonal elevation and the motion
set have all moved since, so the emitted tokens and the pushed design project
are now behind the theme they claim to describe. Bring them level before Phase
F freezes the documentation — and before Phase G builds a component vocabulary
on top of them.

#### E5.1: Re-emit and re-push

- [ ] Extend `spectrum/export` with what Phase E added: the density tokens, the tonal-elevation surface roles replacing `--shadow-*` as the default, and MD3's easing and duration sets.
- [ ] Add density, the elevation model and the motion set to `theme.json`'s generative parameters, so the file still reproduces the theme on its own.
- [ ] Regenerate `foundations/layout.html` against tonal elevation rather than shadow depths, and show the spacing and control metrics at both density settings.
- [ ] Confirm E0.1's round-trip test still passes across the widened token set — it is the only thing stopping the CSS and the Go tokens drifting.
- [ ] Run `scripts/push-design.sh`; open the project and confirm the foundation pages render.
- [ ] Build, test, commit in spectrum; commit the regenerated `design/` here.

## Phase F: Prove it, document it, release it

A design system is only coherent if its own reference applications agree. Right
now seven apps give three different answers about fonts alone.

Tasks here are provisional; re-cut them when Phase E lands.

![[#Release protocol]]

### G-F1: Make the example apps agree

#### F1.1: The apps that are already close

- [ ] Migrate todos, iconbrowser and launcher to the new theme API.
- [ ] Drop their manual `style.FontFaces()` shaper construction — typography now comes from the theme.
- [ ] Run each; confirm it renders in Roboto and switches light/dark live.
- [ ] Commit in workbench.

#### F1.2: feeds

- [ ] Remove the `gofont` shaper and every per-component `Shaper` pass-through.
- [ ] Migrate to the new theme and role tokens.
- [ ] Run it; confirm the table, tabs, modals and toasts all render correctly.
- [ ] Build, test, commit.

#### F1.3: watchlist

- [ ] Same migration; keep the `wiring_test.go` AutoConnect count correct.
- [ ] Run it; confirm CRUD, context menus and popovers.
- [ ] Build, test, commit.

#### F1.4: sitedocs

- [ ] Same migration, including the markdown-rendered docs pages.
- [ ] Run it; confirm hero, pricing, accordion sidebar and the docs routes.
- [ ] Build, test, commit.

#### F1.5: mindchat

- [ ] Remove the appended `gofont.Collection()` — this app currently mixes both font sets.
- [ ] Migrate to the new theme; confirm the markdown chat bodies and chroma highlighting still match the palette.
- [ ] Run it; confirm the split pane, modals and streaming indicators.
- [ ] Build, test, commit.

#### F1.6: The mvu examples
mvu is tier 0, and `mvu/example` is already its own module (tagged
`example/v0.4.3`) — checked during G-B1, so the trap `prism/gallery` was in
does not apply here. Keep it that way: pointing the example at theme typography
while it shared mvu's module would make the foundation require spectrum and
re-close a cycle from the other direction.

- [ ] Drop the `style` dependency from `mvu/example`; use theme typography. Note `example/go.mod` also requires `github.com/vibrantgio/font` DIRECTLY, because `edit` imports `font/roboto/regular/normal` for a single face — drop that too.
- [ ] Update `edit` and `04-hello` — the only two consumers of `style` inside `mvu/example`. Org-wide there are fifteen more: the workbench apps `todos`, `iconbrowser`, `launcher` and `mindchat` (covered by F1.1-F1.5), plus eleven example programs under `ivg/raster/gio`, `svg/driver/gio` and `traer/gio` that Phase F does not touch.
- [ ] Run `scripts/check-layers.sh`; confirm mvu itself still requires nothing above tier 0.
- [ ] Build, test, commit.
### G-F2: Regenerate the documentation

#### F2.1: Rewrite llms.txt for the shipped system

- [ ] Replace the Phase A typography section with the theme-owned contract — no shapers passed by hand.
- [ ] Document seed-derived colour, palette injection, density and the role set.
- [ ] Update the module inventory and the minimal `go.mod` to the released tags.
- [ ] Rewrite the pitfalls section against what actually bit during Phases B–E.
- [ ] Commit here.

#### F2.2: Rewrite DESIGN.md

- [ ] Rewrite `workbench/DESIGN.md` around the new layering, the generative colour model and the desktop divergences.
- [ ] Fold ADR-001 through ADR-007 in as decision records — including ADR-006, whose workspace rule is the one an outside contributor cannot infer from the repos.
- [ ] Keep the old document as `DESIGN-v1.md` for history.
- [ ] Commit in workbench.

#### F2.3: Refresh every repo README

- [ ] Update the prism, spectrum, pulse and cadence READMEs against the shipped API.
- [ ] Remove the "arrives in a later phase" notes now satisfied.
- [ ] Update the deprecation notes in style, textdraw and the prism alias shims.
- [ ] Commit in each repo touched.

#### F2.4: Refresh the org front door

- [ ] Update `profile/README.md`'s stack table to the final layering.
- [ ] Retake the launcher and mindchat screenshots in both appearances on the new palette.
- [ ] Confirm every link from the org page resolves.
- [ ] Commit here.

### G-F3: Release

#### F3.1: Tag the foundation

A tag has to reach GitHub before the layer above it can resolve it, so every
task in G-F3 stops and asks before pushing. This is the one goal in the plan
that local-only work cannot finish.

- [ ] Verify `scripts/check-layers.sh` passes across the stack.
- [ ] Run `scripts/check-no-workspace.sh`: the whole stack, `GOWORK=off`, green. The workspace has been covering version skew since Phase B and this is where that debt comes due.
- [ ] Tag mvu first — `spectrum/window` imports it, so it is tier 0 and everything waits on it — then font and spectrum.
- [ ] Ask Rene to push the tags. Do not push them.
- [ ] Confirm the tags resolve from a clean module cache with the workspace disabled.

#### F3.2: Tag the component layers

- [ ] Update prism and pulse to the released spectrum tag; build and test.
- [ ] Tag prism, then pulse; ask Rene to push each before the next one moves.
- [ ] Confirm resolution from a clean cache, workspace disabled.

#### F3.3: Tag the pattern layer and the apps

- [ ] Promote `prism/internal/golden`'s capture to an exported package *before* the major is cut. G1.1 needs it from outside prism, and finding that out after the bump costs a whole second prism release for a one-line visibility change.
- [ ] Update cadence and markdown to the released tags; build and test. mvu was tagged in F3.1.
- [ ] Tag both; ask Rene to push.
- [ ] Update every workbench app's `go.mod` to the released tags; build, test, run each. Tag the nested demo modules — `prism/gallery`, `mvu/example` — here too; they sit above everything they demonstrate.
- [ ] Drop the deprecated alias shims from prism and spectrum, and tag the majors that removes.
- [ ] Run `scripts/check-no-workspace.sh` one last time, after the majors. Green here means every `go.mod` in the org is honest without the workspace propping it up — which is the actual definition of released.

## Phase G: The design-agent surface

Phase E exported the foundations. This phase adds the component layer, which
turns `claude.ai/design` from a token reference into a place where a design
agent composes whole screens out of VibrantGio's own parts — screens that then
port to Gio because they were built from the same tokens and the same
component vocabulary.

**Not the converter path.** `/design-sync`'s converter expects a JavaScript
design system: a lockfile, a bundlable `dist/`, React components on
`window.<globalName>.*`, `.d.ts` prop contracts. VibrantGio is Go and Gio, so
none of it applies. The skill is explicit that the upload *format* is the
contract and the converter is only one route to it. Produce the layout directly.

**The shape to copy is a CSS-class system** — a token sheet plus a class
vocabulary (`.btn`, `.card`, `.input`, `.table`, `.nav`, `.dialog`) with plain
HTML component pages whose markup can be read and copied. Six component pages
and five foundations is the whole proven surface; this is not a port of all
thirty prism and cadence packages.

**Fidelity is the whole game.** A component that renders wrong here renders
wrong in every design the agent ever builds with it. The mirror is a second
implementation and will drift unless something holds it — so it is verified
against prism's and cadence's existing golden images, not by eye. That
harness is G1.1 and everything else depends on it.

Sequenced after Phase F because components are rewritten throughout C, D and E;
mirroring them earlier is rework.

### G-G1: The mirror and its harness

#### G1.1: Golden comparison harness
Without this, the rest of the phase is guesswork dressed as work.

**The Gio half already exists.** `prism/internal/golden` renders a widget into a
`gioui.org/gpu/headless` window and returns the pixels — `Capture`, `Render` and
`PixelDiff` — and every cadence and pulse golden test is built on it. Reuse it;
do not write a second Gio capture path. What is new is the browser side and the
comparison metric.

`PixelDiff` counts exact byte mismatches, which is right for catching a
regression between two Gio renders and useless across two different renderers.
This task needs a perceptual metric instead.

- [ ] Use prism's exported golden capture, promoted in F3.3. If that bullet was skipped, go back and do it there and re-tag — do not reach into `internal` from here, and do not write a second Gio capture path.
- [ ] Pick the browser automation and record why. chromedp keeps the harness one Go test with no second toolchain; Playwright shapes text better and drags in Node. Neither is installed today, so check before committing to one.
- [ ] Write the browser half: render a component page headless at a fixed viewport and capture a screenshot.
- [ ] Align the two: same nominal size, same theme emission, same component state.
- [ ] Implement a perceptual comparison — downscale both and compare in a perceptual space, or score structural similarity. Text shaping and antialiasing differ between Gio and a browser, so the bar is "reads as the same component", not pixel equality.
- [ ] Pick and justify the tolerance from real pairs, not in the abstract.
- [ ] Prove it: run it against one deliberately wrong variant and confirm it fails, and against a re-render of the same component and confirm it passes.
- [ ] Commit here.
#### G1.2: The component class vocabulary

- [ ] Define the class layer in `styles.css`, built only on the tokens E0.1 emits — no literal colours, sizes or radii.
- [ ] Cover the interaction states explicitly: hover, pressed, keyboard focus ring, disabled, selected.
- [ ] Derive state colours from the tonal ramp rather than ad-hoc mixes, matching how prism resolves them.
- [ ] Confirm the sheet still passes E0.1's round-trip test.
- [ ] Commit here.

### G-G2: The component pages

One task per group. Each page is plain, readable HTML; each ends green against
the G1.1 harness for every variant and state it shows.

#### G2.1: Buttons, tags and forms

- [ ] Build `components/buttons.html`: every prism/button variant, size and state, plus tags.
- [ ] Build `components/forms.html`: text field, checkbox, radio and dropdown on native elements, no script.
- [ ] Run the harness against prism's button and input goldens; close the gaps.
- [ ] Commit here.

#### G2.2: Cards, elevation and tables

- [ ] Build `components/cards.html`: the card pattern and each elevation step.
- [ ] Build `components/table.html`: cadence/table's header, row rules, sort affordance and zebra treatment.
- [ ] Run the harness against the cadence card and table goldens; close the gaps.
- [ ] Commit here.

#### G2.3: Navigation

- [ ] Build `components/navigation.html`: navbar, sidebar, tabs and breadcrumb.
- [ ] Include the selected, hover and focus states for each.
- [ ] Run the harness against the corresponding cadence goldens; close the gaps.
- [ ] Commit here.

#### G2.4: Overlays

- [ ] Build `components/dialog.html`: modal over its backdrop at the top elevation, plus popover, tooltip and toast.
- [ ] Show the scrim and the focus-trapped state, since those carry the elevation and colour decisions.
- [ ] Run the harness against the cadence overlay goldens; close the gaps.
- [ ] Commit here.

### G-G3: Ship it

#### G3.1: The conventions header

This file is inlined into the design agent's system prompt. It is the difference
between an agent that uses the vocabulary and one that invents its own, so every
sentence must be something the agent can act on without guessing.

- [ ] Write `.design-sync/conventions.md`: the class families with their real names, the token families, where the truth lives, and one idiomatic build snippet taken from a page that already passes the harness.
- [ ] State the Gio-specific caveats — text shaping differs, and blur is a cached offscreen pass driven by content change rather than a live CSS `backdrop-filter`, so a design that assumes continuous blur under motion will not port.
- [ ] Validate it: every class, token and component name it mentions must exist in the emitted `styles.css` or the component pages. Cut or fix anything that does not resolve.
- [ ] Commit here.

#### G3.2: Push and validate with the agent

- [ ] Regenerate the full bundle and push it with `scripts/push-design.sh`.
- [ ] Ask the design agent to compose a screen that exercises a shell, a table, a modal and a form.
- [ ] Check the result against the conventions: real classes, real tokens, no invented vocabulary.
- [ ] Record what the agent got wrong as follow-up work — that list is the honest measure of whether the surface is good.
- [ ] Commit here.

## Reference

Decision records and shared contracts. `mdplan next` never visits this section
directly — the phases and goals above pull pieces of it in by embed.

### ADR-001: Spectrum is the foundation, not a consumer

**Decision.** The token and theme contract moves from `prism` down into
`spectrum`. The design-system spine becomes:

```
mvu  →  spectrum  →  prism  →  pulse  →  cadence  →  markdown
```

`spectrum/transition` moves to `pulse/transition`, since it is animation code.
That move removes an edge that already exists rather than preventing a
hypothetical one: `spectrum/transition` imports `pulse/tween` today, in
non-test code, so the foundation depends on the effects layer right now —
tier 1 reaching into tier 3. `spectrum/window` may keep its `mvu` dependency;
mvu carries no design tokens.

**The full tier table.** The spine above is six of the nineteen modules, and
`scripts/check-layers.sh` has to judge all of them. Nineteen, not twenty:
`workbench` is the twentieth sibling repo but carries no root module — it is
seven app modules in subdirectories, and no library imports them. A module may
import only modules in a strictly lower tier, plus anything in the support row:

| Tier | Modules | May import |
| --- | --- | --- |
| 0 | mvu, font, style, textdraw, backdrop, gradient, circle | support libraries only |
| 1 | spectrum | tier 0 |
| 2 | prism | tiers 0–1 |
| 3 | pulse | tiers 0–2 |
| 4 | cadence, markdown | tiers 0–3 |
| — | ivg, svg, seen, csg, kiwi, noise, traer | nothing in this table |

`font` is in tier 0 because C1.2 makes spectrum depend on it for the default
Roboto faces. Without that row the check script would reject the exact edge
ADR-003 requires — which is how a layering rule quietly becomes a nuisance
someone disables.

One intra-tier edge already exists and the table has to admit it: `style`
imports `font` and `textdraw`, both tier 0, which the rule above forbids.
ADR-003 freezes `style` rather than deleting it, so `check-layers.sh` permits
that single edge explicitly instead of renumbering the tier.

The support libraries in the last row are consumed by the design system and
never depend on it. That is the whole of their contract, and it is what their
`AGENTS.md` says (A2.4).

**Nested demo modules are exempt from being imported, not from importing.**
`prism/gallery` (B1.1) and `mvu/example` may depend on layers above their
parent; their parents may not inherit that edge. This is the mechanism that
keeps a demo from re-closing a cycle — the org's one real cycle, pulse into
prism, was a single demo file's doing. `mvu/example` was already a separate
module before this plan started, which is why mvu never had the same problem.

**Why.** `spectrum` — the theme runtime — depends on `prism`, the component
library it exists to theme. The theme therefore sits above what it themes,
which is why `LiveTheme` hardcodes `tokens.DefaultLight`/`DefaultDark` and why
there is no palette injection point anywhere in the stack. That inversion is
what G-B3 fixes and is still open.

The second half of this problem is closed. `prism` and `pulse` used to require
each other, and that cycle pinned `spectrum` and `pulse` to `prism v0.0.3`
while `cadence` ran on `v0.0.8` and `markdown` on `v0.0.9`. B1.1 cut it; every
module in the org now resolves one current prism.

**How it stays non-breaking.** `prism/tokens` and `prism/theme` remain as
packages containing only type aliases and re-exported variables. Every
downstream import path keeps working, unchanged, for one release cycle. The
shims are deleted in F3.3, which is the major bump.

### ADR-002: CIELAB tone with OKLCh hue and chroma
**Decision.** Derive tonal palettes on two axes: **tone is CIELAB L\***, exactly
as MD3 defines it, and **hue and chroma come from OKLCh**. Keep MD3's role
vocabulary and its tone-assignment tables; replace both the colour mathematics
and the hardcoded values now in `prism/tokens`.

This is HCT's architecture with OKLab substituted for CAM16.

**Its role vocabulary is subject to D0.1.** The G-D0 spike reopens the question
of how tones are *assigned* — MD3's role→tone tables, Radix's twelve functional
steps, or the nine-step ramp — and D0.1 amends this ADR if the answer is not
MD3. The mathematics is not reopened: CIELAB tone with OKLCh hue and chroma
survives whichever model wins, because all three need a perceptually even
lightness axis and none of them supplies one.

**Why not what's there now.** The current token package is three design systems
in a trench coat: MD3 type roles, a verbatim Tailwind v3 palette wearing MD3
semantic names, Tailwind spacing and radius keys, MD3 elevation levels, and CSS
easing names. No single system's design logic survives the mix — which is
precisely why nothing feels designed together.

**Why not HCT.** MD3's own space carries CAM16 and viewing-condition machinery
that buys little on a desktop screen and is substantial to implement correctly.

**Why not plain OKLCh.** OKLab's L is not CIELAB L\*. Deriving tones from it
means "tone 40" stops meaning what Google means by it, and every MD3
tone-assignment table has to be re-derived by eye. Keeping L\* as the tone axis
keeps that vocabulary for free.

**Why OKLCh for the other two axes.** Holding CIELAB `a,b` constant while
sweeping L\* does not hold *perceived* hue constant — the blue shift is exactly
why Google built HCT rather than using CIELAB directly. OKLab fixes it in a
short, testable conversion chain, with no dependency and no viewing-condition
model.

**On `reactivego/luminance`.** That package already implements the
sRGB ↔ XYZ(D65) ↔ CIELAB chain correctly and without dependencies, and its
`Lab()`/`RGB()` pair is precisely the tone axis this ADR needs. Its math is
**lifted into `spectrum/color`, not imported.** Same author, so this is
reuse rather than a dependency decision with anyone else in the loop.

Not imported because the package is MD2-era by design: its `Lighten`/`Darken`
API and `Kn = 18` constant are a chroma.js port tuned to reproduce the retired
material.io Color Tool, and MD3 has no lighten/darken concept at all. It also
declares `go 1.14`, carries no tests, and its `go.mod` pulls `fogleman/gg` and
`golang.org/x/exp` because its examples share the module — which would drag
freetype into the foundation's module graph.

Lifted: the conversion chain, the D65 white point, the CIE ϵ/κ constants. The
file header says these came out of MD2-era tone work — not as attribution, but
so a later reader knows the lineage and does not expect MD3 semantics from them.

Left behind: `Lighten`, `Darken`, `LightenRGBA`, `DarkenRGBA`, `Kn`, and the
per-channel clamp in `RGB()` — which is not gamut mapping and is replaced in
D1.3.

**Tailwind's ramps** may survive as an optional palette provider. They must not
appear in the semantic layer.
### ADR-003: The theme owns the typeface

**Decision.** `Typography` is a theme token carrying, per MD3 role, a full
`TextStyle` — typeface, weight, size, line height, tracking — plus the face
collection and a lazily built shaper. Roboto is the default because the default
typography names it. `Props.Shaper` survives only as an explicit per-call
override. No library source file may import `gioui.org/font/gofont`; a CI lint
enforces it.

**Why.** `TypeScale` is fifteen `float32` sizes and nothing else, so the theme
has no seam for a typeface at all. The consequence is mechanical: seventeen
`Props` structs and 118 function signatures carry a `*text.Shaper`, and prism,
pulse, cadence and markdown all construct
`text.NewShaper(text.NoSystemFonts(), text.WithCollection(gofont.Collection()))`
inside library code. gofont is not merely used by the examples — it is the
compiled-in default of the component library. Meanwhile `font` and `style`, the
repos that package Roboto and a type scale, have no consumer in library source
anywhere in the organization: `font` is imported by `style` and by two `mvu`
examples, and `style` by thirteen mains, every one of them a demo — two in
`mvu/example`, four under `ivg/raster/gio/example`, three under
`svg/driver/gio/example`, four in `traer/gio`.

`style` is frozen rather than deleted: its MD2 scale is superseded by
`Typography`, and it keeps working through the deprecation window.

### ADR-004: The canonical agent guide lives here

**Decision.** `llms.txt` lives at the root of this repo and is the single
source. Every repository carries an `AGENTS.md` that links its raw URL. The
content is never duplicated — only pointed at.

**Why.** The guide is genuinely good: 360 accurate lines on the MVU loop, rx
semantics, `AutoConnect` counts and real pitfalls. It exists exactly once,
inside `workbench/`, and nothing links to it — not the org profile, not any
repo README, and no repo has an `AGENTS.md` or `CLAUDE.md` at all. An assistant
pointed at the organization reads the profile README, finds a repo list and
screenshots, and stops.

It also, in its current form, teaches the defect: it lists `style` and `font` in
the module inventory but omits both from the bootstrap skeleton and the minimal
`go.mod`, and has no typography section. An assistant that follows it perfectly
ships a gofont application.

### ADR-005: MD3's system, not MD3's look

**Decision.** Take MD3's *system* and reject MD3's *look*. Specifically:

- **From MD3:** the generative token model (ADR-002), the type-role scale, state
  layers, tonal elevation, and the motion semantics.
- **From shadcn/ui:** density, restraint, and the component inventory. Its
  metrics are the target for the `Density` token — copy them rather than
  inventing numbers.
- **From neither:** the visual identity. That comes from `pulse` — glow, depth,
  spring physics — which is what DESIGN.md already names as the point of the
  project.

**Why.** MD3 is touch-first: 48 dp targets, generous spacing, large type, and a
component set shaped for phones — FAB, navigation rail, bottom sheet, chips,
snackbar. Adopting its look would make a Mac app read as an Android port, which
defeats the word "native" in the project's own vision statement.

Cadence has *already* made this choice without recording it. Its inventory —
shell, navbar, sidebar, table, pagination, tabs, modal, alert, popover, tooltip,
toast, card, accordion, breadcrumb, hero, feature, pricing, testimonial — is
shadcn's inventory, not MD3's. MD3 has no breadcrumb, no data table and no
pricing section. This ADR ratifies a decision the code made a year ago, so the
next contributor stops trying to reconcile the two.

The hardcoded `minHeight = 44dp` in `prism/button` is the same tension showing
up as a magic number. E1.1 replaces it with a token.

**What shadcn is not adopted for.** Its colour model is flat, hand-authored
semantic pairs — `--background`/`--foreground`, `--primary`/`--primary-foreground`
— written twice, once under `:root` and once under `.dark`. That is structurally
what `prism/tokens` already does, so taking it would be standing still. shadcn
moved to OKLCH values without moving to generation; MD3 generates without a
modern space; ADR-002 does both.

Its distribution model is also not adopted: copying component source into the
consumer's repo has no Go idiom, and fights module versioning and golden tests.
The philosophy behind it does carry over — components should be readable and
forkable, not opaque configuration surfaces.

### ADR-006: One workspace while developing, tags at the seams

**Decision.** Development across the twenty modules happens under a single
`go.work` at the root of this repo, listing every module in `.repos/` plus the
nested ones. No member repo ever gets a `replace` directive, and `go.work` is
never committed into a member repo.

A cross-repo change is therefore green in two different senses, and this plan
means both:

- **Green under the workspace** — `go build ./... && go test ./...` with the
  workspace active, resolving siblings from the working tree. This is what
  "green before commit" means for every task.
- **Green without it** — the same commands under `GOWORK=off`, resolving each
  `go.mod` against published tags. This is what CI sees, and what a stranger
  running `go get` sees.

**The two diverge at seams.** A seam is any task that creates or changes a
dependency edge, and B3.3 is the first: `prism/tokens` becomes an alias for a
`spectrum/tokens` that no published spectrum tag contains. At each seam the
lower module is tagged and pushed before the upper module's `go.mod` names it —
a stop-and-ask, per the plan preamble. `scripts/check-no-workspace.sh` (B2.1)
reports the outstanding debt at any point.

The seams are: B3.3 (spectrum gains tokens and theme), C1.3 (theme gains
Typography), D2.2 (the derived role set), E1.2 (density), E3.1 (motion). Each
is a goal boundary, which is where the preamble already puts push decisions.

**The workspace is established in B2.1, after G-B1 and not before.** A
workspace resolves shared dependencies at the highest version any member
requires, so joining all 36 modules while the Gio versions were still spread
would have broken the ones on the older versions — a self-inflicted failure
looking exactly like the drift G-B1 existed to fix. Align, then join. G-B1 has
now aligned them, so B2.1 inherits a workspace that goes green rather than one
that has to be fought into shape.

**Why not `replace` directives.** They would have to be committed to be useful
to the next task, and a committed `replace` in a public module breaks every
consumer who is not sitting in this working tree. `go.work` is what Go added
for exactly this, and it is invisible downstream.

**Why not defer it all to F3.** Because the seams are load-bearing and there
are five of them. Phases C, D and E each move a contract down into spectrum and
then migrate four repos onto it. Leaving twenty modules mutually unbuildable
for three phases would make "never commit red" unenforceable across most of the
plan's length — and a rule that cannot be checked is not a rule.

**The seam procedure is proven, not theoretical.** G-B1 ran it end to end. Tag
and push the bottom layer, bump the layer above onto those tags, verify with
`GOWORK=off`, tag and push it, repeat. Seven layers, in this order:

```
0  mvu font traer svg seen ivg kiwi noise csg circle gradient backdrop textdraw
1  style  kiwi/gio  seen/context/gio  svg/driver/{pdf,raster}
2  svg/driver/{gio,seen}  ivg/raster/gio  traer/gio
3  prism      4  pulse      5  spectrum      6  cadence markdown
7  workbench/*  mvu/example  prism/gallery
```

Three things that cost time and will cost it again. A module's *newest tag* is
authoritative, not the proxy's `@v/list` — that endpoint caches and will report
a version behind for a while after a push, which reads as false staleness. And
tagging a whole layer in one round leaves each new tag referencing its
siblings' *previous* tags; making the set self-referencing needs the second
pass, so budget both.

The third is about how easily a local cache can fake a result. **Deleting a tag
from git does withdraw the version — but Go keeps two caches, and clearing one
is not enough.** Besides the module cache at `$GOMODCACHE/cache/download`, Go
keeps a bare git clone per repository under `$GOMODCACHE/cache/vcs`, and that
clone still holds tags that have been deleted upstream. Evicting only the
download cache and re-resolving therefore appears to prove the version is still
published, when it is really being served out of the stale clone. Evict both,
or use `go clean -modcache`, before concluding anything about what a stranger
can fetch.

Measured after evicting both: `raster/gio@v0.1.7` and `seen/context/gio@v0.0.8`
each fail with `unknown revision`, while the versions that replaced them
resolve normally.

**`GOPRIVATE` covers `github.com/vibrantgio/*` here**, so `proxy.golang.org` is
bypassed entirely for this org and every module resolves straight from GitHub.
That is why a deleted tag really is gone rather than pinned in the proxy's
immutable storage — but it also means the proxy's own endpoints say nothing
useful about these modules, and `git ls-remote` is the only authority worth
consulting.

### The repo doc contract

Every repository gets the same two files, in the same shape.

`AGENTS.md` — twenty-five wrapped lines for a leaf, forty-odd once the golden
paragraph is there, rendered by `scripts/sync-agents.sh` from
`templates/AGENTS.md` and never hand-written in the repo it lands in:

- One sentence: what this repo is.
- Which layer it occupies, per ADR-001.
- The canonical guide's raw URL, and an instruction to read it before writing code against this module.
- The build and test command.
- How to regenerate golden images, where the repo has them — nothing else in the organization says.
- Anything that would surprise someone: nested modules, deprecation status, platform-specific files.

The first two are per-repo rows in `templates/repos.tsv`; anything longer than
a line goes in `templates/notes/<repo>.md`; the module, build and golden-image
paragraphs are measured from the clone. Editing the wording for all twenty
means editing the template, not twenty files.

`README.md` — a page, written for a human evaluating the module:

- What it is and what problem it solves, in a paragraph.
- Where it sits in the stack, with a link to the org page.
- Its packages, one line each.
- One short, real usage example — copied from a working app, not invented.
- A link to the canonical guide.
- Honest status: what does not work yet, and which phase fixes it.

Describe the layer and the role, not the API surface — the API surface changes
in Phases B through E, and F2.3 is where READMEs are brought up to the shipped
reality.

### Release protocol

Modules are tagged bottom-up, one layer at a time, and each layer is verified
from a clean module cache before the layer above it moves:

```
mvu  →  font, spectrum  →  prism  →  pulse  →  cadence, markdown  →  workbench apps
```

mvu is tagged first, not with the pattern layer: `spectrum/window` imports it,
which makes it tier 0 in ADR-001 and puts everything else behind it. The nested
demo modules — `prism/gallery`, `mvu/example` — tag last with the apps, since
they sit above everything they demonstrate.

No layer is tagged while `scripts/check-layers.sh` fails, and none while
`scripts/check-no-workspace.sh` does. The deprecated alias shims from ADR-001
and ADR-003 are removed only in the final major bump, after every in-org
consumer has moved off them.

**No double-digit component in any tag. Ever.** A version component never
reaches two digits: when a series hits `.9`, the next release rolls the
component above it.

```
v0.0.9  ->  v0.1.0        never v0.0.10
v0.1.9  ->  v0.2.0        never v0.1.10
v0.9.0  ->  v1.0.0        never v0.10.0
```

This is not a preference to weigh against others — it is a hard rule. A tag is
immutable the moment the proxy sees it, so a `v0.0.10` cannot be withdrawn,
only buried under a correction that leaves it in the list forever. Check the
existing tags before cutting a new one.

**A nested module's tag mirrors its root's version.** A module in a
subdirectory is tagged `<subdir>/vX.Y.Z`, and that tag requires the root at
exactly `vX.Y.Z`:

```
kiwi  v0.0.6   ->  gio/v0.0.6          requires kiwi v0.0.6
svg   v0.0.8   ->  driver/seen/v0.0.8  requires svg  v0.0.8
mvu   v0.4.3   ->  example/v0.4.3      requires mvu  v0.4.3
```

The order is root first, submodule second. Get the root correct, commit it,
tag it — **and push the tag**, because until it is on the remote the submodule
cannot `go get` it. Only then update the submodule to require that version,
commit, and tag it with the same number. The submodule's commit therefore
lands *after* the root's, which is right: the submodule depends on the root,
never the reverse.

A submodule is **not** re-tagged every time the root moves — only when
something relevant to it actually changed. `svg` at v0.0.8 while `driver/gio`
is still at v0.0.7 is the normal, correct state, not drift.

What the rule forbids is letting the submodule run on its own counter.
Bumping `gio/v0.0.6` to `gio/v0.0.7` because the submodule changed, while the
root is still at v0.0.6, destroys the correspondence — and then no version
number tells you which root it belongs to. If the submodule needs a new tag
and the matching root number is already taken by an older tag, cut a fresh
root tag rather than letting the submodule run ahead.

**A tag is retractable only until someone fetches it without `GOPRIVATE`.**
This is the safety margin that makes everything above survivable, and it is
worth understanding precisely, because it is temporary and it is not a
property of Go — it is a property of who has fetched what, so far.

`GOPRIVATE` here covers `github.com/vibrantgio/*`, so Go bypasses both
`proxy.golang.org` and `sum.golang.org` for this org and resolves straight
from GitHub. While that holds for everyone who has fetched a module, a wrong
tag really can be deleted or moved: it never left the repo and the clones.

The instant one person **without** `GOPRIVATE` resolves a version, that ends,
permanently. The proxy fetches and stores the module immutably, and
`sum.golang.org` appends its hash to a transparency log that is append-only by
construction. From then on the number is spent: deleting the git tag changes
nothing, and reusing it means shipping different bytes under a hash the log
has already committed to.

So the state *is* checkable, and worth checking before relying on being able
to take a tag back:

```
curl -sI https://proxy.golang.org/<module>/@v/<version>.info
   404  ->  not yet mirrored; the tag can still be moved or deleted
   200  ->  spent; that number is fixed forever, correct it going forward
```

**But the check is not free, and this is the trap.** The proxy fetches from
origin on a cache miss, so probing a version that exists is one of the ways it
gets mirrored. `sum.golang.org/lookup` is worse: it will compute and append
the entry if it is missing. The observation causes the thing being observed.

Therefore: **while a tag is still in flux, use `git ls-remote`** — it is
authoritative, and inert. Probe the proxy only once a version is final, or
when the specific question is whether escape is still possible and the answer
changes what you do next.

Measured after the G-B1 baseline work: all eight versions deleted during it —
`raster/gio v0.1.7`, `context/gio v0.0.8`, `driver/gio v0.0.8`, `example`
v0.3.1/v0.3.2/v0.4.2, `traer gio/v0.0.9`, `kiwi gio/v0.0.7` — were still
clean on both the proxy and the sumdb. That was luck bounded by a small
window, not a repeatable guarantee.
