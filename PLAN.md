# Vibrant Gio — one coherent design system

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

- [x] Open with a one-paragraph statement of what Vibrant Gio is and what it targets.
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

- [x] Write READMEs for font, style, textdraw, gradient, circle.
- [x] Expand backdrop's one-line README to the same shape.
- [x] In `style` and `font`, state that they are not yet wired into the component stack and that Phase C fixes this.
- [x] Commit in each of the six repos.

#### A3.9: support library READMEs

- [x] Write READMEs for seen and kiwi.
- [x] Expand svg's stub README to the doc contract's shape.
- [x] Leave ivg, csg, noise, traer READMEs as they are; add only the canonical-guide link.
- [x] Commit in each repo touched.

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

#### B2.0: Repair the seen/context/gio go.sum pin

`workbench/launcher` and `svg/driver/seen` do not build **from a clone**: both
pin `github.com/vibrantgio/seen/context/gio v0.0.7` to hashes of content that
exists nowhere. Diagnosed in full under [[#Defects found but not fixed]] — do
not re-litigate whether a push fixes it. It does not: git, the proxy and
`sum.golang.org` all agree with each other and all disagree with `go.sum`.

Do not be reassured by `go install …/launcher@latest` working — it does, on a
clean machine, because `go install pkg@version` never consults a dependency
module's `go.sum` and falls through to the checksum database. That path is
healthy and stays healthy. This task is about the clone-and-build path, which
is the one every later task uses.

This runs **before** B2.1, and the ordering is the point. Every one of the 36
modules becomes a workspace member, so once `go.work` exists the bad `go.sum`
entry is never consulted and both modules build green in the tree while staying
broken for everyone outside it. Fix it while the breakage is still observable.

- [x] In each of the two modules, drop the two `seen/context/gio v0.0.7` lines from `go.sum` and re-run `go mod tidy`. Tidy alone will not do it: it verifies before it rewrites. Both lines are wrong — the `h1:` and the `/go.mod` — so removing one is not enough.
- [x] Sweep all 36 modules for the same stale pair, not just these two — the bad hashes could have been recorded anywhere that ever resolved that tag.
- [x] Check what `go mod tidy` writes back against `sum.golang.org` (`curl https://sum.golang.org/lookup/github.com/vibrantgio/seen/context/gio@v0.0.7`): `h1:OJip+UYN…` and `/go.mod h1:qmUvReYG…`. `GOPRIVATE` covers `github.com/vibrantgio/*` on the development machine, so the checksum database is *not* consulted automatically — this cross-check has to be done by hand or the repair could re-record a wrong hash unnoticed.
- [x] Build and test both modules, with no workspace in effect. Confirm `go env GOWORK` is empty first, so the repair is verified against published tags rather than masked by the tree.
- [x] Strike the entry in [[#Defects found but not fixed]], leaving the record in place.

#### B2.1: Establish the Go workspace

- [x] Write `go.work` at the root of this repo listing all **36** modules — nineteen repository roots (`workbench` has no root module of its own), the ten nested ones: `prism/gallery`, `mvu/example`, `ivg/raster/gio`, `kiwi/gio`, `traer/gio`, `seen/context/gio` and `svg/driver/{gio,pdf,raster,seen}`, and `workbench`'s seven apps: `feeds`, `iconbrowser`, `launcher`, `mindchat`, `sitedocs`, `todos`, `watchlist`. Generate the list with `find .repos -name go.mod`; do not hand-maintain it. (`prism/button/gallery` and `prism/icon/gallery` are packages, not modules.)
- [x] Confirm that from each module, `go build ./... && go test ./...` resolves its siblings from the working tree rather than the module cache.
- [x] Confirm the resolved Gio and rx versions are the single ones G-B1 settled on — if the workspace pulls something higher, a module was missed and B1 is not actually done.
- [x] Confirm the same commands under `GOWORK=off` still pass, resolving from published tags. This is what CI sees, and the gap between the two is what ADR-006 manages. Both sweeps were green at 36/36 when the G-B1 baseline was tagged; this task is about making that repeatable, not discovering it.
- [x] Write `scripts/check-no-workspace.sh`: run the whole stack with `GOWORK=off` and report which modules fail and why. Expect failures from B3.3 onward; the script records the debt, it does not pay it.
- [x] Confirm no member repo carries a `replace` directive, and note in the script header that none may be added — a committed `replace` in a public module breaks every consumer outside this working tree.
- [x] Settle whether `go.work` is committed here. **Decided by Rene: it is committed.** A1.1's `.gitignore` ignored both it and `go.work.sum`; the `go.work` line is now removed and only `go.work.sum` stays ignored. ADR-006 forbids a workspace only in *member* repos, and this repo is not one — it holds no module. Committing it means the 36-module list is reviewable and identical for everyone, rather than being silently regenerated per machine.
- [x] Commit the script and `go.work` here. Note in `go.work`'s header that the members live under the gitignored `.repos/`, so the file is committed while the checkout it points at is not — `scripts/clone-all.sh` has to run first or every `use` line dangles.
### G-B3: Invert the foundation

Move the token and theme contract down into spectrum so the theme runtime is
beneath the components it themes. Alias shims keep prism's import paths alive
for one release.

#### B3.1: Move the tokens into spectrum

- [x] Copy `prism/tokens/*.go` (including tests) to `.repos/spectrum/tokens/`.
- [x] Keep the package name `tokens` and every exported identifier unchanged.
- [x] `go build ./... && go test ./...` in spectrum; commit.

#### B3.2: Move the theme contract into spectrum

- [x] Copy `prism/theme/*.go` (including tests) to `.repos/spectrum/theme/`, repointing its tokens import.
- [x] Repoint `spectrum/system` and `spectrum/window` at the local theme package; drop the prism requirement from spectrum's `go.mod` if nothing else needs it.
- [x] `go build ./... && go test ./...` in spectrum; commit.

#### B3.3: Leave alias shims in prism

- [x] Replace `prism/tokens`'s bodies with type aliases and variable re-exports pointing at `spectrum/tokens`.
- [x] Do the same for `prism/theme`.
- [x] Mark both packages `Deprecated:` with the replacement path.
- [x] Confirm prism, pulse, cadence and markdown all still compile with no source changes; commit in prism.

#### B3.4: Move transition into pulse

`spectrum/transition` depends on `pulse/tween`, which would make the foundation
depend on the effects layer. It is animation code; it belongs in pulse.

- [x] Copy `spectrum/transition` to `.repos/pulse/transition`, repointing imports at `spectrum/tokens`.
- [x] Leave a deprecated alias shim at `spectrum/transition`.
- [x] Build and test both; commit in each.

#### B3.5: Make the layering enforceable

- [x] Write `scripts/check-layers.sh` here: for each module, `go list -deps` and assert only the edges ADR-001's tier table permits — the whole table, including the tier 0 leaves and the support-library row, not just the six-module spine.
- [x] Teach it the nested-module exemption: `prism/gallery` and `mvu/example` may import above their parent's tier; their parents may not.
- [x] Run it across all twenty modules; fix or record any violation it finds.
- [x] Wire it into each core repo's CI workflow. A1.1's inventory says which repos have a `.github/workflows/` at all — where there is none, add a minimal build-and-test workflow first, since the check has to run somewhere.
- [x] Commit the script here and the workflow change in each repo.

## Phase C: The theme owns the typeface

The fix for the Roboto problem. `TypeScale` is fifteen `float32` sizes — there
is nowhere in the theme to put a typeface, so all seventeen `Props` structs and
118 function signatures carry a `*text.Shaper`, every one of which falls back to
`gofont.Collection()` inside library source.

![[#ADR-003: The theme owns the typeface]]

### G-C1: Define the typography token

#### C1.1: TextStyle and Typography

- [x] In `spectrum/tokens`, add `TextStyle{Typeface, Weight, Size, LineHeight, Tracking}`.
- [x] Add `Typography` with one `TextStyle` per MD3 role — Display/Headline/Title/Label/Body × Large/Medium/Small.
- [x] Populate `DefaultTypography` with the MD3 metrics: sizes as today, plus the matching line heights and tracking.
- [x] Unit-test that every role has a non-zero size, weight and line height.
- [x] Build, test, commit in spectrum.

#### C1.2: Make Roboto the default face

- [x] Add `Faces []font.FontFace` to `Typography`, defaulting to `vibrantgio/font/roboto.FontFaces()`.
- [x] Add a `Shaper()` method that builds the shaper once, lazily, and caches it.
- [x] Add `github.com/vibrantgio/font` to spectrum's `go.mod`.
- [x] Test that the default shaper resolves Roboto for every weight the scale names.
- [x] Build, test, commit in spectrum.

#### C1.3: Put typography in the theme

- [x] Add `Typography rx.Observable[tokens.Typography]` to `theme.Theme`.
- [x] Update `theme.Default()`, `theme.AutoLightDark()`, `system.LiveTheme()` and `system.FromSourceTheme()` to emit it.
- [x] Update the prism alias shim so `prism/theme.Theme` still matches.
- [x] Build and test spectrum and prism; commit in each.

#### C1.4: Deprecate the standalone type scale

`style`'s MD2 scale is superseded, and it carries a real bug — `H1` and `H2` are
both 96 sp (`textdraw.TextStyle.Size` is `unit.Sp`, not `unit.Dp`), where MD2's
H2 is 60. The two differ only in weight, Thin and Light, so a document using
both gets no size hierarchy at all.

Four workbench applications import `style`, not zero — see the correction in
ADR-003 — so these markers land on shipped code.

- [x] Mark every exported symbol in `style` `Deprecated:` with the `spectrum/tokens.Typography` replacement.
- [x] Fix the `H2` size to 60 so the deprecated path is at least correct.
- [x] Note in `style`'s README that it is frozen.
- [x] Build, test, commit in style.

### G-C2: Migrate components off gofont

One task per component group. Each ends with green tests — including
regenerated goldens, which will move for every one of these.

Pattern for each component: read `Typography` from the theme, use the role's
`TextStyle` for typeface, weight, size and line height, and keep `Props.Shaper`
only as an explicit override that defaults to the theme's shaper. No library
file may import `gofont` when the group is done.

#### C2.1: prism/button

- [x] Take the shaper and `LabelLarge` style from the theme's `Typography`.
- [x] Remove the `gofont` import and the inline fallback shaper.
- [x] Keep `Props.Shaper` as an override; document it as such.
- [x] Regenerate goldens; build, test, commit.

#### C2.2: prism/input

- [x] Migrate textfield, dropdown, checkbox and radio the same way.
- [x] Remove every `gofont` import in the package.
- [x] Regenerate goldens; build, test, commit.

#### C2.3: prism remaining packages

- [x] Migrate richtext, list, scrollbar and layout.
- [x] Migrate `prism/gallery` (nested module) and `prism/button/gallery`.
- [x] Confirm no `gofont` import remains anywhere in prism, tests included.
- [x] Regenerate goldens; build, test, commit.

#### C2.4: pulse

- [x] Migrate springbutton and depth.
- [x] Confirm no `gofont` import remains in pulse.
- [x] Regenerate goldens; build, test, commit.

#### C2.5: cadence — data and navigation

- [x] Migrate table, tabs, sidebar, navbar, pagination.
- [x] Regenerate goldens; build, test, commit.

#### C2.6: cadence — overlays

- [x] Migrate tooltip, alert, accordion, toast, popover, modal.
- [x] Regenerate goldens; build, test, commit.

#### C2.7: cadence — content and shells

- [x] Migrate card, hero, feature, pricing, testimonial, breadcrumb, shell.
- [x] Confirm no `gofont` import remains anywhere in cadence.
- [x] Regenerate goldens; build, test, commit.

#### C2.8: markdown

- [x] Migrate the document renderer, highlight and svgimage to theme typography.
- [x] Confirm no `gofont` import remains, tests included.
- [x] Regenerate goldens; build, test, commit.

### G-C3: Lock it in

The rule that prevents this whole class of regression.

#### C3.1: The no-gofont lint

- [x] Write a Go test that walks the module and fails on any `gioui.org/font/gofont` import.
- [x] Add it to prism, pulse, cadence and markdown.
- [x] Confirm it fails when a gofont import is reintroduced deliberately, then passes.
- [x] Wire it into each repo's CI; commit in each.

#### C3.2: The no-literal-colour lint

- [x] Write a test that fails on `color.NRGBA{...}` literals outside `spectrum/tokens` — and `spectrum/color` too, which D1.1 creates a phase from now.
- [x] Add it to prism, pulse, cadence and markdown; allow-list the deliberate exceptions with a comment explaining each.
- [x] Wire into CI; commit in each.

#### C3.3: Refresh the guide's typography section

A1.3 documented the shaper-passing practice this phase has just deleted. The
canonical guide is the plan's own front door; leaving it wrong through Phases D
and E teaches every assistant exactly the defect Phase C existed to remove.
F2.1 rewrites the whole file — this is the one section that cannot wait for it.

- [x] Replace `llms.txt`'s `## Typography` section with the theme-owned contract: read `Typography` from the theme, never construct a shaper, never pass `Shaper` except as a deliberate override.
- [x] Note that the no-gofont lint now runs in CI, so the old practice fails the build rather than merely being discouraged.
- [x] Keep the known-wrong app list — F1 is what fixes those — but say plainly that the library contract has moved and the apps have not caught up yet.
- [x] Commit here.

## Phase D: Generative colour
Material Design's real contribution is not its palette, it is that colour is
*derived*: one seed becomes tonal palettes becomes semantic roles, with light
and dark as tone mappings rather than two hand-written structs. Today the token
package wears MD3's names over Tailwind's values, ships thirteen flat colours,
and exposes no way for an application to supply a palette at all.

G-D1 is firm — the approach was validated against the MD3 default seed before
this plan was written. G-D2 was re-cut by D0.1 to ADR-007's model. G-D3 stays
provisional; re-cut it against what Phase D actually lands before starting it.

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

D0.1 has run and decided: the functional family wins, in Claude Design's nine-step vocabulary, with Radix's paired dark scales and APCA guarantees folded in.

![[#ADR-007: Nine functional steps, paired dark ramps, APCA contrast]]

#### D0.1: Spike — choose the ramp model and the contrast metric

Timeboxed. The deliverable is a recommendation with evidence, not an
implementation — write no code into `spectrum`. A throwaway script is fine and
should be thrown away.

- [x] Read each model's own account of itself: Radix's twelve-step purposes and paired dark scales, MD3's role→tone table, and the Claude Design project's readme and `theme.json` for the 100–900 OKLCH ramp.
- [x] If that last project is not reachable from this machine, say so plainly and decide between the two models that are. Do not block on it, and do not guess at a ramp you could not read.
- [x] Lay all three against the same surfaces: app background, card, hover, pressed, subtle border, strong border, solid fill, low-contrast text, body text.
- [x] Note where nine steps cannot express something twelve can, and whether prism and cadence actually need that distinction.
- [x] Generate all three mappings from the `#6750A4` seed with a throwaway script and compare the resulting surfaces side by side, light and dark.
- [x] Evaluate APCA (Lc) against WCAG 2 ratios on the light-on-dark pairs specifically — WCAG 2 is known to over-rate them, and spectrum tracks OS dark mode by default.
- [x] Weigh the prototyping argument explicitly: matching Claude Design's ramp keeps one vocabulary across the app and the design surface, and that is worth real points against a model that scores better in isolation.
- [x] Decide, and write the outcome into `## Reference` as ADR-007, embedded into Phase D.
- [x] Amend ADR-002 wherever the decision contradicts it. That ADR currently commits to keeping "MD3's role vocabulary and its tone-assignment tables", which a functional-step model replaces outright. Its *mathematics* — CIELAB tone with OKLCh hue and chroma — survives all three models and is not reopened here.
- [x] Re-cut G-D2 to match the decision, and adjust D2.4's contrast target if APCA wins.
- [x] Check the three later places that already assume a ramp shape — E0.1's `--color-*` token families, E0.2's colour page and its step-purpose notes, and G1.2's class vocabulary — and re-cut whichever no longer reads true.
- [x] Commit in the plan repo.

### G-D1: The colour engine
Built in `spectrum/color`, with no external dependency. The CIELAB conversion
chain is lifted from `reactivego/luminance` rather than imported — ADR-002
records why.

#### D1.1: The CIELAB tone axis

MD3's tone *is* CIELAB L\*, so this axis is what the whole palette hangs from.
`reactivego/luminance` already implements the chain correctly and without
dependencies; lift the math in rather than taking the package as a dependency.

- [x] Create `spectrum/color`; lift the sRGB ↔ XYZ(D65) ↔ CIELAB conversions from that package's `luminance.go`.
- [x] Keep the D65 white point and the CIE ϵ/κ constants exactly as they are.
- [x] Leave behind `Lighten`, `Darken`, `LightenRGBA`, `DarkenRGBA` and `Kn` — a chroma.js port tuned to the retired MD2 Color Tool, and MD3 has no lighten/darken concept.
- [x] Note in the file header that these functions came out of MD2-era tone work, so a later reader does not go looking for MD3 semantics in them.
- [x] Write the round-trip tests the original never had: the sRGB cube at 1% tolerance, plus published CIELAB reference values.
- [x] Build, test, commit.

#### D1.2: OKLab and OKLCh

Hue and chroma come from OKLab. This is the axis pair plain CIELAB `a,b` cannot
hold perceptually constant.

- [x] Add sRGB ↔ linear sRGB ↔ OKLab ↔ OKLCh conversions alongside the CIELAB chain.
- [x] Round-trip tests across the sRGB cube at 1% tolerance.
- [x] Test against published OKLab reference values.
- [x] Build, test, commit.

#### D1.3: Gamut mapping

The defect that makes the copied code unusable as-is: `luminance.RGB` clamps R,
G and B independently, which is not gamut mapping. Measured on the MD3 default
seed `#6750A4`, it costs 41 chroma and 20° of hue at the light end — tone 100
lands on `#ffefff` instead of white, tone 0 on `#01003f` instead of black.
Tones 10–70 are unaffected and already exact.

- [x] Implement chroma reduction at constant L\* and constant OKLCh hue to bring an out-of-gamut colour into sRGB.
- [x] Replace every independent per-channel clamp on the conversion path.
- [x] Test the hard cases: saturated blues and purples at tones 0, 90, 95, 99 and 100.
- [x] Assert tone 100 is exactly white and tone 0 exactly black, for every hue.
- [x] Assert a mapped result is always in gamut and its hue never moves more than 1°.
- [x] Build, test, commit.

#### D1.4: Tones and contrast

- [x] Add `Tone(hue, chroma float64, tone int) color.NRGBA` — tone 0–100 on the L\* axis at fixed OKLCh hue and chroma.
- [x] Add WCAG relative-luminance and contrast-ratio helpers.
- [x] Test that tone is monotonic in luminance across all thirteen MD3 stops.
- [x] Regression-test the `#6750A4` palette: tone 40 must reproduce the seed exactly.
- [x] Build, test, commit.
### G-D2: The functional ramps
Re-cut by D0.1 to ADR-007's model: nine-step functional ramps (100–900) with
pinned bases, a paired dark ramp instead of a second role table, interaction
states as step walks, and APCA as the contrast gate.

#### D2.1: Define the ramp vocabulary

- [x] Extend `ColorTokens` to ADR-007's shape: a nine-step `Ramp` type (steps 100–900); ramps for Neutral, Primary, Secondary, Tertiary and Error; a pinned base per accent role; and the thin semantic layer — background, surface, text, divider — resolved from ramp steps.
- [x] Keep every field name currently in use as an alias into a ramp step or a pin, so nothing breaks; mark the MD3-only names deprecated for F3.3's shim deletion.
- [x] Build, test, commit.

#### D2.2: Derive paired ramps from a seed

- [x] Add `FromSeed(seed color.NRGBA) (light, dark ColorTokens)`: both ramps per role on ADR-007's shared lightness scale, dark as the paired scale — same step, same job — with the primary base pinned to the seed exactly.
- [x] Golden-test the default seed `#6750A4` against a recorded palette; the pinned base must reproduce the seed byte-for-byte.
- [x] Replace `DefaultLight`/`DefaultDark` with values derived from the default seed.
- [x] Remove the verbatim Tailwind ramp from the semantic layer. Per ADR-002 it may survive only as an optional named palette provider — never behind a role name, which is the arrangement that made the tokens three design systems in a trench coat.
- [x] Build, test, commit.

#### D2.3: States as step walks

ADR-007 replaces MD3's alpha state layers: hover and pressed are adjacent ramp
steps relative to the ground, which keeps every state a real, addressable
colour the token sheet can emit.

- [x] Add a resolver from (role, ground, state) to a colour: hover one step past the ground, pressed and selected two, solid-fill states walking from the pin toward 900.
- [x] Keep disabled as an opacity and focus as the focus-ring colour; dragged follows pressed.
- [x] Test that resolved states stay on the ramp and are monotonic along it.
- [x] Build, test, commit.

#### D2.4: Contrast conformance

- [x] Add an APCA (Lc) helper alongside D1.4's WCAG helpers.
- [x] Test ADR-007's guarantees in both ramps: step 900 at Lc ≥ 90 and step 700 at Lc ≥ 60 over the step-100 and step-200 grounds; each pinned base's on-colour at Lc ≥ 60 over the base.
- [x] Report WCAG 2 AA for the same pairs alongside — conformance claims cite it — without gating on it.
- [x] Fix the scale tunings that fail: the spike already measured light-mode 900-on-200 at Lc 87, so the 900 stop deepens.
- [x] Test the same for the high-contrast variant once E3.3 lands, or record the gap.
- [x] Commit.

#### D2.5: Migrate prism to the ramps

- [x] Replace flat-token uses with the semantic alias or ramp step that matches each surface's meaning, resolving states through D2.3.
- [x] Regenerate goldens; build, test, commit.

#### D2.6: Migrate cadence to the ramps

- [x] Same, across all eighteen packages.
- [x] Regenerate goldens; build, test, commit.

#### D2.7: Migrate pulse and markdown to the ramps

- [x] Same, including `pulse/transition`'s per-field interpolation, which must cover every ramp step and pin.
- [x] Regenerate goldens; build, test, commit.
### G-D3: Let applications and the OS drive the palette

#### D3.1: Palette injection

The gap that makes branding impossible today: `LiveTheme` hardcodes the default
palette, so choosing your own colours means giving up OS dark-mode tracking.

- [x] Add options so a caller supplies a seed or a full palette and still gets live light/dark switching.
- [x] Update `LiveTheme` and `FromSourceTheme` to take them.
- [x] Test that a custom seed survives a light→dark transition.
- [x] Build, test, commit.

#### D3.2: Wire the macOS accent

`spectrum/system` already reads `AppleAccentColor` and then discards it.

- [x] Map the accent index (−1..7) to its seed colour.
- [x] Regenerate the palette when the accent changes.
- [x] Test with a fake `Source` driving each index.
- [x] Build, test, commit.

#### D3.3: Windows and Linux accent sources

- [x] Read the Windows accent colour from the registry.
- [x] Read the GNOME/KDE accent where available; fall back to the seed otherwise.
- [x] Document per platform what is and is not supported.
- [x] Build, test, commit.

## Phase E: Reimagined for desktop
Where MD3 assumes touch and Android, diverge deliberately and say why. This is
what makes the system Vibrant Gio's rather than a port.

G-E1 is firm. G-E2 and G-E3 were provisional until Phase D landed; both have
now been re-cut against ADR-007 as shipped — the MD3 vocabulary they were
first written in (`SurfaceContainer` roles, WCAG AAA gates) no longer exists
to map to.

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

- [x] Create `spectrum/export`: given a `theme.Theme` emission, write `theme.json` and the `:root` / dark token sheet of `styles.css`.
- [x] Emit the token families Claude Design expects: `--color-<role>-100…900` ramps plus the pinned bases (`--color-bg`, `--color-surface`, `--color-text`, `--color-accent`, …) per ADR-007 — the exact families the reference project documents — then `--font-*`, `--space-*`, `--radius-*`, and `--shadow-*` from today's elevation levels — E2.1 replaces those with surface roles and E5.1 re-emits them.
- [x] Record the generative parameters in `theme.json` — seed hue, saturation, any pinned roles, base radius, heading and body faces — so the theme is reproducible from the file alone. Density and the motion set belong here too but are E5.1's; they do not exist yet.
- [x] Write a round-trip test: parse the emitted CSS back and assert every value matches the Go token it came from, so the two cannot drift.
- [x] Add `cmd/vg-tokens` writing the pair into a target directory.
- [x] Build, test, commit in spectrum.

#### E0.2: The foundation pages

Static HTML that reads only from the emitted token sheet — no hard-coded values,
so a theme change reflows every page.

- [x] Generate `foundations/color.html`: each role with its full 100–900 ramp and its pin, annotated with ADR-007's step purposes — 100–300 tinted fills and hovers, 500 mid, 700–900 text and pressed — and the measured APCA Lc (with the WCAG ratio alongside) of each text pair against its ground.
- [x] Generate `foundations/type.html`: every type role at its real size, weight, line height and tracking, in the actual faces.
- [x] Generate `foundations/layout.html`: the spacing scale, radius scale and elevation steps as rendered specimens. Elevation as it stands today; E5.1 re-renders it once E2.1 has remapped it to surface roles.
- [x] Generate `readme.md` for the project describing the system and naming the token families — the file a human or an agent reads first.
- [x] Confirm every page renders correctly against a dark theme emission as well as light.
- [x] Build, test, commit in spectrum; commit the generated `design/` here.

#### E0.3: Push to Claude Design

- [x] Run `cmd/vg-tokens` into `design/`, then push it to the Vibrant Gio design project with DesignSync — plan first, write the sentinel, write the files, re-arm the sentinel.
- [x] Open the project and confirm the foundation pages render as generated.
- [x] Write `scripts/push-design.sh` capturing the regenerate-and-push sequence so later phases re-push in one step.
- [x] Record the project UUID here in the plan repo, next to the script.
- [x] Commit here.

### G-E1: Density
Desktop density is the sharpest divergence from MD3, and the one users feel
first. Targets come from shadcn/ui's metrics rather than being invented, per
ADR-005.

#### E1.1: Measure the target metrics

Establish the numbers before changing any component, so every later task has one
table to work from and reviewers can argue with the source rather than the
diffs.

- [x] Record shadcn/ui's control metrics: default and small button heights, input height, base radius, and the spacing step between stacked controls.
- [x] Record MD3's equivalents alongside them, and macOS's 28 pt standard control height as the native reference point.
- [x] Write the three-way table into `spectrum/tokens/density.go` as a doc comment — it is the justification for every number below it.
- [x] Pick `Comfortable` and `Compact` values from that table; keep prism's existing 44 dp as `Comfortable` only if the table supports it.
- [x] Commit here in the plan repo if the table changes ADR-005's claims; otherwise commit in spectrum.

#### E1.2: The density token

- [x] Add `Density` to `spectrum/tokens` with `Comfortable` and `Compact`, carrying control height, inner padding and the minimum hit target.
- [x] Add it to `theme.Theme` as an observable, alongside Typography.
- [x] Keep the WCAG 2.5.5 minimum hit target independent of density — `Compact` may shrink the visual control but never the pointer target.
- [x] Unit-test that both settings satisfy the hit-target floor.
- [x] Build, test, commit in spectrum.

#### E1.3: Density through prism

- [x] Replace the hardcoded `minHeight = 44dp` in `prism/button` with the density-derived value.
- [x] Apply density to input, checkbox, radio, dropdown and list row height.
- [x] Apply density to `prism/icon`'s default sizes — an icon that stays put while its control shrinks is the tell that density is only half-wired.
- [x] Add a golden per component at each density.
- [x] Build, test, commit in prism.

#### E1.4: Density through cadence

- [x] Apply density to table row height, navbar height, sidebar item height, tabs and pagination controls.
- [x] Check the overlays — modal, popover, tooltip, toast — for control metrics that should follow density too.
- [x] Add a golden per component at each density.
- [x] Build, test, commit in cadence.
### G-E2: Tonal elevation
The pre-D cut of this goal asked E2.1 to "map each `ElevationLevel` to its
`SurfaceContainer` role". No such role exists any more: ADR-007 retired MD3's
role tables, and the landed `ColorTokens` carries ramps, pins and a thin
semantic layer instead. What survives is the idea ADR-005 kept — on desktop a
raised surface reads as raised by tint first and shadow second — and ADR-007
gives it a sharper form than MD3 ever had: elevation is to surfaces what D2.3
made states to fills, a walk up the neutral ramp. Level 0 is the app
background (the `bg` pin on the step-100 ground), level 1 the card surface
(step 200), each level above one step further. Because the dark ramp is a
paired scale, a raised surface lightens in dark mode and darkens in light
mode with no second rule — MD3's dark-mode surface tint, the one thing tonal
elevation existed to encode, falls out of the pairing for free.

The landed code is already halfway there without saying so: modal, popover
and tooltip all paint `Surface` (step 200), `cadence/toast` hand-rolls a
step-300 fill under its shadow, and only card and toast cast shadows at all.
What is missing is the token that names the ladder: `ElevationScale` still
holds MD3's six shadow depths in dp, `theme.Theme.Elevation` emits it to no
subscribers, and `pulse/depth` reads the package variable directly. Shadows
are not deleted — ADR-005's desktop reading is subtle shadows *plus* surface
steps — they become the secondary, opt-in cue E2.2 scopes.

#### E2.1: Elevation becomes a surface step

- [x] Redefine `ElevationScale` in `spectrum/tokens`: each level carries the neutral ramp step of its surface fill — level 0 the `bg` pin over the step-100 ground, level 1 step 200, level 2 step 300, level 3 step 400 — alongside its shadow depth in dp, which survives as the secondary cue. Keep all six named levels so `pulse/depth` and the cadence call sites still compile; levels 4 and 5 clamp to level 3's step, exactly D2.3's clamp, with a doc comment marking them for F3.3's shim sweep — desktop has no six-storey stack.
- [x] Add the resolver from (`ColorTokens`, `ElevationLevel`) to the surface colour; test that every level's fill sits on the neutral ramp, that the clamp holds, and that D2.3's state walks compose on top — hover on a level-1 surface is step 300 in both modes, courtesy of the paired scales.
- [x] Keep `theme.Theme.Elevation` emitting the remapped scale — the observable finally carries something worth subscribing to.
- [x] Leave the `--shadow-*` emission in `spectrum/export` untouched; E5.1 replaces it with the surface roles once the migration lands, per E0.1's note.
- [x] Build, test, commit in spectrum.

#### E2.2: Shadows become opt-in vibrancy

FX.3 and the defect register both point here for "when is a shadow
appropriate at all"; this task owns that verdict, FX.3 owns the geometry of
the shadows that keep theirs.

- [x] Decide, per ADR-005, when a shadow is right: it marks what floats and can leave — toast, popover — not what is raised in place, which reads as raised by its surface step. Audit the `depth.Shadow` callers — `cadence/card`'s `Elevated` variant, `cadence/toast`, `workbench/mindchat` — against that criterion and record each verdict.
- [x] Keep `pulse/depth` an explicit effect, never a component default; document in its package doc when a shadow is right, when a surface step is, and the cost difference in Gio — eight gradient fills plus an interior fill per shadow (measured; the earlier "a dozen" was an estimate) versus one `FillShape` for a step.
- [x] Build, test, commit in pulse; commit here if the verdicts change this plan's text.

#### E2.3: Migrate prism and cadence to the ladder

Split out of the pre-D E2.1, which bundled the token change and the migration
into one oversized task. E2.2's verdicts come first; this task executes them.

- [x] cadence: resolve every raised surface through the ladder — card at level 1 (the outlined variant keeps its step-500 stroke; `Elevated` becomes a level-2 fill, dropping its shadow — E2.2's verdict: a card is raised in place, not floating), modal, popover and tooltip picking their level deliberately (record the choice in each package doc), toast replacing its hand-rolled `Step(300)` fill with a level-2 resolution under its accent tint.
- [x] prism: `input/dropdown`'s menu surface takes its level from the ladder rather than flat `Surface`; sweep the other `Surface` consumers for any that are really a raised level.
- [x] Regenerate the moved goldens and say so in the commit body; build, test, commit in prism and cadence.
### G-E3: Motion and accessibility as theme inputs
This goal survives Phase D better than G-E2 did — nothing here leaned on the
retired role tables — but the ground truth moved anyway. `tokens.Motion`
holds CSS easing names that nothing consumes: toast fades over a local
400 ms constant, tooltip delays over a local 500 ms, and `pulse/motion`
counts its own frames. The a11y observables live a tier too high —
`spectrum/preferences` imports `prism/a11y`, the upward edge
`scripts/check-layers.sh` records against E3.2. And D2.4 left the
high-contrast gate as a skipped test naming E3.3, in ADR-007's APCA terms,
where the pre-D cut still asked for a WCAG AAA assertion.

#### E3.1: MD3 motion

ADR-005 takes MD3's motion semantics; this is where they land. It is also an
ADR-006 seam — spectrum's widened `MotionScale` is tagged before pulse and
cadence consume it.

- [x] Replace `MotionScale`'s CSS easing presets with MD3's standard and emphasized sets (standard, accelerate, decelerate, in both families), keeping the `Bezier` shape the export can already serialise.
- [x] Map the five existing duration stops onto MD3's duration roles rather than adopting all sixteen — desktop wants fewer stops and faster ones; record the mapping and its reasoning in the token doc comment the way `density.go` records its metrics table.
- [x] Add spring specifications — mass, stiffness, damping presets — for the pulse physics path, coordinating with FX.2, whose defaults fix decides what a usable preset even is.
- [x] Wire the first consumers, because today there are none: `pulse/motion`'s frame counts, toast's `fadeWindow` and tooltip's `DefaultDelay` resolve from `Theme.Motion` rather than local constants.
- [x] Regenerate the moved goldens; build, test, commit in spectrum, then pulse and cadence.

#### E3.2: Accessibility preferences reach the theme

- [x] Move the a11y source into spectrum as `spectrum/a11y`, leaving a deprecated alias package in prism for F3.3's shim sweep. The layering requires the move: `spectrum/preferences` already imports `prism/a11y`, the recorded upward edge in `scripts/check-layers.sh`.
- [x] Delete the `spectrum->prism` entry from that script's `RECORDED_EDGES` and its `recorded_reason`, and commit that here — the lint drops back to one recorded edge (B3.4's shim, which F3.3 removes).
- [x] Route the observables into the theme so components read one source: `LiveTheme` composes `ReduceMotion` into the Motion emission — durations to zero, animated components snap — and `HighContrast` into the Color emission, selecting E3.3's variant. Until E3.3 lands the hook selects the default palette, so the wiring is testable now.
- [x] Test that reduced motion snaps: an animated component under `ReduceMotion` reaches its target in one frame.
- [x] Build, test, commit in spectrum and prism.

#### E3.3: High-contrast palette

- [x] Derive the variant from the same seed — a `FromSeed` option, not a third hand-written scheme — by widening tone separation where it counts: deepen the 700 text step toward the 900 depth, resolve `Divider` from step 500 rather than 300, and push each pinned base's on-colour further from its base.
- [x] Gate it in APCA, not WCAG AAA — ADR-007 retired ratio gates: un-skip `TestAPCAContrastGateHighContrast` in `spectrum/tokens/contrast_test.go`, the gap D2.4 recorded, with the variant's floors above the defaults — step 700 at Lc ≥ 90 where the default asks 60, pinned on-colours at Lc ≥ 75 — and report WCAG AAA alongside without gating on it, ADR-007's arrangement exactly.
- [x] Switch to the variant when the OS reports increased contrast, through E3.2's observable — flip the hook E3.2 left.
- [x] Build, test, commit in spectrum.
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

- [x] Create `pulse/blur`: a separable 3-pass box blur over `image.NRGBA`, horizontal then vertical, parallelised across `runtime.NumCPU()`.
- [x] Test convergence against a reference Gaussian: compare per-channel variance reduction and assert the difference stays within a few percent.
- [x] Test the edges — a blur that darkens or wraps at the borders is the usual bug; assert a uniform input stays uniform right up to the edge.
- [x] Benchmark against the table above and record the numbers in the package doc.
- [x] Build, test, commit in pulse.

#### E4.2: Cached blur for static imagery

The simple case, and the one with no platform caveat: a known source image
blurred once and reused.

- [x] Add a helper that blurs a source image and returns a `paint.ImageOp`, caching on source identity, radius and target size.
- [x] Support the downscale-blur-upscale path for large radii; expose the divisor and default it from the radius.
- [x] Test that a repeated call with unchanged inputs does no work, and that a size or radius change invalidates.
- [x] Build, test, commit in pulse.

#### E4.3: The headless backdrop pipeline

- [x] Add a backdrop type that owns a `headless.Window`, renders a caller-supplied layer into it at a reduced resolution, reads it back, blurs it, and yields a `paint.ImageOp` stretched to full size.
- [x] Allocate the headless window per size and reuse it; reallocate only on resize.
- [x] Choose the divisor from the blur radius so callers ask for a look, not a resolution.
- [x] Handle unavailable headless rendering explicitly — a documented fallback (flat tinted surface), never a panic.
- [x] Decide and document the refresh policy: this runs on the events thread and stalls it, so it must be driven by content change, not by every frame.
- [x] Benchmark the assembled pipeline and confirm it matches the table above.
- [x] Build, test, commit in pulse.

#### E4.4: Evaluate blur-based glow

`pulse/glow` composes eight linear gradients — four edges, four corners —
because Gio has no radial gradient. A real blur gives a true radial falloff and
works for arbitrary shapes, not rectangles only. Whether it *wins* depends on
whether the cache holds while the glow animates.

- [x] Prototype a glow that renders the shape offscreen, blurs it, and paints the result.
- [x] Compare against the current eight-gradient halo: visual quality, and cost per frame when the glow animates and the cache misses.
- [x] Decide. Keep the gradient path if the animated case cannot be cached cheaply — a correct approximation beats a slow exact answer.
- [x] Record the decision and its evidence in `pulse/glow`'s package doc either way.
- [x] Build, test, commit in pulse.

### G-E5: Re-export the foundations

G-E0 exported what Phase D had landed. Density, tonal elevation and the motion
set have all moved since, so the emitted tokens and the pushed design project
are now behind the theme they claim to describe. Bring them level before Phase
F freezes the documentation — and before Phase G builds a component vocabulary
on top of them.

#### E5.1: Re-emit and re-push

- [x] Extend `spectrum/export` with what Phase E added: the density tokens, the tonal-elevation surface roles replacing `--shadow-*` as the default, and MD3's easing and duration sets.
- [x] Add density, the elevation model and the motion set to `theme.json`'s generative parameters, so the file still reproduces the theme on its own.
- [x] Regenerate `foundations/layout.html` against tonal elevation rather than shadow depths, and show the spacing and control metrics at both density settings.
- [x] Confirm E0.1's round-trip test still passes across the widened token set — it is the only thing stopping the CSS and the Go tokens drifting.
- [x] Run `scripts/push-design.sh`; open the project and confirm the foundation pages render.
- [x] Build, test, commit in spectrum; commit the regenerated `design/` here.

## Phase F: Prove it, document it, release it

A design system is only coherent if its own reference applications agree. Right
now seven apps give three different answers about fonts alone.

The tasks here were provisional until Phase E landed; it has, 18/18, and they
are now re-cut against the system as shipped: theme-owned typography, density,
the elevation ladder, MD3 motion and the a11y observables all emitting from
`theme.Theme`, with ADR-007's ramps underneath and blur in pulse. "Agree" is
no longer only about fonts, though the font disagreement is still real —
every one of the seven apps still imports the `prism/tokens` or `prism/theme`
alias paths, reads the deprecated MD3 colour aliases, and five drive
components through the frozen static `Render(…, TypeScale, …)` signatures.
The apps are the last consumers of every deprecated surface in the org, so
G-F1 is what empties the deprecation windows that F3.3's sweep then closes.

![[#Release protocol]]

### G-F0: The mono face

C2.8's migration surfaced an org-level gap and recorded it in its commit: no
monospace face ships anywhere, so markdown code blocks — and
`markdown/style.Style.Mono`, the field that exists to name one — resolve to
Roboto. Two reference apps render code (sitedocs' docs pages, mindchat's chat
bodies), so the gap is visible in exactly the apps G-F1 makes agree, and it
has to close before G-F2 freezes the documentation and G-F3 tags.

The face is Roboto Mono. The theme's default face is Roboto, Roboto Mono is
its designed companion in the same superfamily under the same licence the
`font` repo already packages, and MD3 itself pairs the two. That is a
decision this plan can make without a survey task; recording the reasoning
here is the survey.

#### F0.1: Package the face and give the theme a code style

- [x] Add `font/robotomono`, mirroring `font/roboto`'s per-weight package layout only as far as real use: regular and italic in the weights the highlight path shapes — normal and bold suffice.
- [x] In `spectrum/tokens`, add a `Code` TextStyle to `Typography` — BodyMedium's metrics on the mono face — and append the mono faces to `DefaultTypography.Faces` so the default shaper resolves them.
- [x] Test that the default shaper resolves the mono face at every weight and style the highlight path uses.
- [x] Extend `spectrum/export` with the code role and run `scripts/push-design.sh`, so the design project stays level per E5.1; commit the regenerated `design/` here.
- [x] This widens spectrum's API — an ADR-006 seam whose tag is F3.1's, since Phase F ends in the release; until then the workspace covers it and `scripts/check-no-workspace.sh` reports the debt. Build, test, commit in font and spectrum.

#### F0.2: Wire markdown to it

- [x] Resolve `Style.Mono` and `CodeSize` from the theme's `Code` role in markdown's theme path, so inline code and code blocks leave Roboto.
- [x] Confirm highlight's bold and italic runs shape in the mono face rather than falling back to Roboto's weights.
- [x] Regenerate the moved goldens and say so in the commit body; build, test, commit in markdown.

FX.7 regenerates these same goldens for the token palette; this task lands
first, so the mono face is already under FX.7's goldens rather than moving
them a third time.

### G-F1: Make the example apps agree

The migration pattern, once per app: imports move off the `prism/tokens` and
`prism/theme` alias paths onto spectrum's; colours move off the deprecated
MD3 aliases — `OnBackground`, `OnSurface`, `SurfaceVariant`,
`OnSurfaceVariant`, `Outline` — onto the ramps, pins and semantic fields;
text comes from the theme's Typography, so no app-built shaper, no
`style.FontFaces()`, no gofont; and components are driven through their
theme-driven entry points rather than the frozen static
`Render(…, TypeScale, …)` signatures F3.3 re-cuts. Density, the elevation
ladder and MD3 motion then arrive through the theme with no per-app work —
which is the point: the apps prove the theme carries the whole look.

#### F1.1: The apps that are already close

- [x] Migrate todos, iconbrowser and launcher per the goal's pattern.
- [x] Drop their manual `style.FontFaces()` shaper construction — typography now comes from the theme, and these three are among the last consumers holding ADR-003's `style` freeze window open.
- [ ] Run each; confirm it renders in Roboto, switches light/dark live, and sits at the 36 dp Comfortable control height rather than the pre-E 44.
- [x] Commit in workbench.

#### F1.2: feeds

- [x] Remove the `gofont` shaper and every per-component `Shaper` pass-through — `app.go` builds it, `sidebar.go` alone threads it through four signatures — and the sim and wiring tests that construct their own follow.
- [x] Migrate per the goal's pattern; `articles.go` drives components through static `Render` calls that become theme-driven here.
- [ ] Run it; confirm the table, tabs, modals and toasts render correctly at density, and that pagination — which dropped its prism/button bridge for density's sake (E1.4) — still matches the buttons beside it.
- [x] Build, test, commit.

#### F1.3: watchlist

- [x] Same migration per the goal's pattern — `maincontent.go` and the modals lean hardest on the deprecated aliases and static `Render` calls; keep the `wiring_test.go` AutoConnect count correct.
- [ ] Run it; confirm CRUD, context menus and popovers.
- [x] Build, test, commit.

#### F1.4: sitedocs

- [x] Same migration, including the markdown-rendered docs pages — after F0.2 they are the first app surface where code renders in the mono face; confirm it.
- [ ] Run it; confirm hero, pricing, accordion sidebar and the docs routes.
- [x] Build, test, commit.

#### F1.5: mindchat

- [x] Remove the appended `gofont.Collection()` — this app still mixes both font sets in one shaper (`view.go`).
- [x] Migrate per the goal's pattern; confirm the markdown chat bodies and chroma highlighting match the palette, and code spans render in the mono face.
- [x] Keep its `depth.Shadow` — E2.2's verdict let mindchat and toast keep theirs — and leave its square-cornered geometry to FX.3 rather than fixing it here.
- [ ] Run it; confirm the split pane, modals and streaming indicators.
- [x] Build, test, commit.

#### F1.6: The mvu examples
mvu is tier 0, and `mvu/example` is already its own module (tagged
`example/v0.4.3`) — checked during G-B1, so the trap `prism/gallery` was in
does not apply here. Keep it that way: pointing the example at theme typography
while it shared mvu's module would make the foundation require spectrum and
re-close a cycle from the other direction.

- [x] Drop the `style` dependency from `mvu/example`; use theme typography. Note `example/go.mod` also requires `github.com/vibrantgio/font` DIRECTLY, because `edit` imports `font/roboto/regular/normal` for a single face — drop that too.
- [x] Update `edit` and `04-hello` — the only two consumers of `style` inside `mvu/example`. Org-wide there are fifteen more: the workbench apps `todos`, `iconbrowser`, `launcher` and `mindchat` (covered by F1.1-F1.5), plus eleven example programs under `ivg/raster/gio`, `svg/driver/gio` and `traer/gio` that Phase F does not touch.
- [x] Run `scripts/check-layers.sh`; confirm mvu itself still requires nothing above tier 0.
- [x] Build, test, commit.
### G-F2: Regenerate the documentation

#### F2.1: Rewrite llms.txt for the shipped system

- [x] C3.3 already replaced the typography section; rewrite the rest to the same standard — seed-derived colour in ADR-007's vocabulary (ramps, pins, step walks — not MD3 role tables), palette injection and the OS accent, density, the elevation ladder, MD3 motion and the a11y observables, and when to reach for pulse's blur.
- [x] Update the module inventory and the minimal `go.mod`. The version numbers cannot be final before G-F3 cuts the tags; F3.5 owns that touch-up, so write the inventory here and leave the numbers honest about being pre-release.
- [x] Rewrite the pitfalls section against what actually bit during Phases B–E — the workspace/`GOWORK=off` double meaning of green, B2.0's `go.sum` lesson, goldens regenerated in the task that moves them.
- [x] Commit here.

#### F2.2: Rewrite DESIGN.md

- [x] Rewrite `workbench/DESIGN.md` around the new layering, the generative colour model and the desktop divergences.
- [x] Fold ADR-001 through ADR-007 in as decision records — including ADR-006, whose workspace rule is the one an outside contributor cannot infer from the repos.
- [x] Keep the old document as `DESIGN-v1.md` for history.
- [x] Commit in workbench.

#### F2.3: Refresh every repo README

- [x] Update the prism, spectrum, pulse and cadence READMEs against the shipped API — spectrum grew export, a11y and the elevation ladder since its README was written; pulse grew blur and the motion presets.
- [x] Remove the "arrives in a later phase" notes now satisfied.
- [x] Update the deprecation notes in `style`, the not-deprecated clarification in textdraw, and the alias shims — `prism/tokens`, `prism/theme`, `prism/a11y`, `spectrum/transition` — saying plainly that F3.3 deletes the shims and what happens to `style` (F3.4 records it).
- [x] Commit in each repo touched.

#### F2.4: Refresh the org front door

- [x] Update `profile/README.md`'s stack table to the final layering.
- [ ] Retake the launcher and mindchat screenshots in both appearances on the new palette.
- [x] Confirm every link from the org page resolves.
- [x] Commit here.

### G-FX: Clear the defect register

> Included from [[#Defects found but not fixed]]

Defects found while doing other work, in code no other goal touches. This goal
sits before G-F3 deliberately: each one changes rendering or behaviour, so it
has to land before the tags do, not after.

One task per entry, except where an entry has to be fixed sooner than Phase F —
the `seen/context/gio` pin is scheduled as B2.0, since it breaks two builds
today. An entry can be scheduled anywhere; the register is the record, not the
queue. When the register grows, this goal grows with it — and when a task
lands, strike the entry rather than deleting it, so the record of what was
wrong outlives the fix.

#### FX.1: Correct the svg fill-rule inversion

`svg/parser/svgcursor.go:133` sets `UseNonZeroWinding` when the document asked
for `evenodd` and clears it when the document asked for `nonzero` — backwards
on both values. Work in `.repos/svg`.

- [x] Fix the line. `nonzero` is the SVG initial value, so the condition is `!strings.EqualFold(v, "evenodd")` — or spell it positively against `"nonzero"` and let anything else fall through to the default. Leave `defaultstyle.go:14` alone; its `UseNonZeroWinding: true` is already correct.
- [x] Add a regression test with a self-intersecting path — a five-pointed star drawn as one closed subpath is the standard case, since it renders with a filled centre under non-zero and a hollow centre under even-odd. Assert both `fill-rule` values, and assert that a path stating neither still gets non-zero.
- [x] Drive the test through `driver/raster`, not `driver/gio`. `driver/gio/driver.go:59` is an empty `SetWinding` — deliberately, because `clip.Outline` is non-zero only — so the Gio path cannot observe this defect and cannot validate the fix. `driver/pdf` and `driver/seen` honour the flag too, but raster is the one that yields a comparable image.
- [x] Check the repo's own SVG fixtures for any that state `fill-rule` and whose goldens therefore move. Regenerate them in this task and say so in the commit body, per the plan's green-before-commit rule.
- [x] Note in `svg/README.md` that the defect is fixed — A3.9 documented it there as live, and that text is now wrong.
- [x] Strike the entry in [[#Defects found but not fixed]], leaving the record in place.

`svg/driver/seen` does not build on a stale consumer-side `go.sum` pin of
`seen/context/gio v0.0.7`. That is recorded separately and is not this task's
to fix — build and test the root module and `driver/raster`.

#### FX.2: Make pulse/spring's defaults usable

`spring.Options{}` takes ~873 frames to settle, and overriding one field silently
takes the rest from the same soft defaults. E3.1 has since landed usable
presets — `tokens.Motion.SpringDefault` (k=80, critically damped) is what
`pulse/motion.DefaultSpring` already resolves to — so this fix aligns with a
published number rather than inventing one.

- [ ] Replace `DefaultStiffness`/`DefaultDamping`/`DefaultMass` with `tokens.Motion.SpringDefault`'s values, or make the zero `Options` an error rather than a 15-second animation. Pick one and say which in the commit body.
- [ ] Fix the partial-override trap at `spring.go:114-121`: deriving `Damping` from whatever `Stiffness` and `Mass` end up being — critical damping is `2√(km)` — is the fix that makes a one-field override behave. `pulse/motion.Options.Spring` documents the same trap around its `DefaultSpring` fallback; fix or re-document it to match whichever contract this task picks.
- [ ] Test the settle time of the zero `Options` and of `Options{Stiffness: 80}` alone, asserting frame counts rather than "it looks right".
- [ ] Update the package comments A3.6 wrote: they document the current behaviour accurately, so they become wrong the moment this lands.
- [ ] Check `motion` and `springbutton`, which pass explicit values today and must not move. Regenerate goldens only if they legitimately do; build, test, commit.
- [ ] Strike the register entry.

#### FX.3: Give pulse/depth a rounded interior and an opacity

`depth.go:86` fills the shadow interior with `clip.Rect` at full alpha, so its
callers get square dark wedges behind their rounded corners. E2.2's verdicts
and E2.3's migration have since landed: `cadence/card`'s `Elevated` shadow is
gone — raised in place is a surface step now — leaving two callers,
`cadence/toast` and `workbench/mindchat`, both at `Level3`, both keeping
their shadows as things that float. The when-is-a-shadow-right question is
settled; only the geometry of the survivors remains.

- [ ] Take a corner radius on the shadow call and clip the interior to a matching `clip.RRect`.
- [ ] Add an opacity control, and drop `cadence/toast`'s `PushOpacity` workaround once it exists.
- [ ] Update `cadence/toast` and `workbench/mindchat` to pass the radius they already round their foregrounds to.
- [ ] Golden-test a rounded surface over a shadow — the wedges are exactly what a golden catches and no unit test will.
- [ ] Regenerate the moved goldens in this task and say so in the commit body; build, test, commit.
- [ ] Strike the register entry.

#### FX.4: Guard tween against a nil Lerp

`At` reaches `tw.Lerp` only for `0 < n < Frames`, so the panic hides behind any
test that samples the endpoints.

- [ ] Decide the contract and implement it: either return the nearest endpoint when `Lerp` is nil, or panic immediately on construction with a message naming the field. Constructing-time failure is the better of the two — it cannot reach a frame.
- [ ] Test the interior, not just `At(0)` and `At(Frames)`.
- [ ] Build, test, commit; strike the register entry.

#### FX.5: Make spectrum's appearance stream shared and live

Two defects in the same stream: the observable is cold, so every subscription
polls independently, and `preferences.Observe` completes after one read. E3.2
raised the stakes since this was recorded: `LiveTheme` now composes the a11y
observables — built on the same cold `FromSource` shape, moved down as
`spectrum/a11y` — so each subscriber multiplies pollers across two sources,
not one.

- [ ] Multicast `Live`/`FromSource` so *n* subscribers share one poll loop, and give `spectrum/a11y`'s same-shaped stream the same fix. Verify with the shape A3.5 used — count source reads with a counting `Source` at one and three subscribers, and assert they match.
- [ ] Check every workbench app still tracks dark mode afterwards; each subscribes at least twice, via `BackdropLayer` and `ContentLayer`.
- [ ] Make `preferences.Observe` emit on write, or rename it to something that does not promise a stream. Whichever, `Save` and `Observe` must agree.
- [ ] Build, test, commit; strike both register entries.

#### FX.6: Give cadence/sidebar a scroll region

A nav list taller than the viewport runs off the bottom edge with no way to
reach the rest. E1.4 changed the arithmetic but not the defect: the item
pitch is now `Density.ControlHeight` — 36/28 dp rather than the register's
48 — so the list overflows a few items later and just as irrecoverably; the
package doc says so itself.

- [ ] Wrap the item loop in a scrollable list — `prism/list` is the one the rest of cadence uses.
- [ ] Golden-test a list long enough to overflow, in both the expanded and collapsed widths and at both densities.
- [ ] Consider whether the 192/48 dp column-width constants — still local, still ignoring the horizontal constraint — should respond to it, and record the decision either way.
- [ ] Regenerate goldens; build, test, commit; strike the register entry.

#### FX.7: Let the theme reach highlighted code

The chroma hook colours every run, so `Style.CodeColor` is unreachable and code
blocks leave the token palette.

- [ ] Emit no colour for runs chroma would render in its default foreground, so the documented `Style.CodeColor` fallback at `style.go:20` actually fires.
- [ ] Fail loudly on an unrecognised style name instead of falling back to a dark-background default that renders near-white on the light theme.
- [ ] Golden-test a code block in both themes, asserting the plain runs take the token colour.
- [ ] Regenerate goldens; build, test, commit; strike the register entry. D2.7 and C2.8 both landed, so the double-migration risk this task once dodged is gone — but F0.2 moves the same goldens for the mono face, so it goes first.

#### FX.8: Add the two missing LICENSE files

`gradient` and `circle` ship none; the other eighteen repos do.

- [ ] Copy the licence the rest of the organization uses, with the same holder and year convention. Do not invent a different one.
- [ ] Commit in each repo; strike the register entry.

### G-F3: Release

The Release protocol's double-digit rule was violated before this goal ran:
spectrum v0.0.10–v0.0.15 and pulse v0.0.10–v0.0.12 are on the remotes,
immutable — the protocol's violation note records how. The burial rule sets
this goal's numbers: spectrum's next tag is **v0.1.0**, pulse's is
**v0.1.0**, and neither repo ever sees another v0.0.x.

#### F3.1: Tag the foundation

A tag has to reach GitHub before the layer above it can resolve it, so every
task in G-F3 stops and asks before pushing. This is the one goal in the plan
that local-only work cannot finish.

- [ ] Verify `scripts/check-layers.sh` passes across the stack.
- [ ] Run `scripts/check-no-workspace.sh`: the whole stack, `GOWORK=off`, green. The workspace has been covering version skew since Phase B and this is where that debt comes due.
- [ ] Tag mvu first — `spectrum/window` imports it, so it is tier 0 and everything waits on it — then font, then spectrum at **v0.1.0**, the burial number. Font before spectrum, pushed before spectrum's `go.mod` pins it: C1.2 made spectrum require it, the tier-0/tier-1 edge in ADR-001.
- [ ] Ask Rene to push the tags. Do not push them.
- [ ] Confirm the tags resolve from a clean module cache with the workspace disabled.

#### F3.2: Tag the component layers

- [ ] Update prism and pulse to spectrum v0.1.0; build and test.
- [ ] Tag prism in series — v0.1.9; its v0.1.x series is clean — then pulse at **v0.1.0**, burying its v0.0.10–12; ask Rene to push each before the next one moves.
- [ ] Confirm resolution from a clean cache, workspace disabled.

#### F3.3: The major-bump shim sweep

The deprecation windows Phases B–E opened all close here, in one breaking
release per repo, before the pattern layer and the demos tag. What the sweep
covers, verified against the code rather than remembered:

- the three prism alias packages — `prism/tokens`, `prism/theme` (B3.3),
  `prism/a11y` (E3.2);
- the `spectrum/transition` forwarder (B3.4), and with it the
  `spectrum->pulse` entry in `check-layers.sh`'s `RECORDED_EDGES` — the lint
  drops to zero recorded edges;
- `ColorTokens`' five deprecated MD3 aliases (D2.1): `OnBackground`,
  `OnSurface`, `SurfaceVariant`, `OnSurfaceVariant`, `Outline`;
- `ElevationScale`'s `Level4`/`Level5` depths and `Step4`/`Step5` clamps
  (E2.1) — the desktop ladder tops out at level 3;
- the frozen static render surface that predates C1.1 and E1.2:
  `TypeScale`/`DefaultTypeScale` and every `Render(…, tokens.TypeScale, …)`
  signature — in prism, `button.Render`/`RenderIcon`,
  `input.Render`/`RenderDropdown` and `richtext.FromTokens`; cadence's and
  markdown's are F3.4's. These are re-cut to take `TextStyle` and `Density`,
  not deleted — the golden tests ride them.

- [ ] Promote `prism/internal/golden`'s capture to an exported package *before* the major is cut. G1.1 needs it from outside prism, and finding that out after the bump costs a whole second prism release for a one-line visibility change.
- [ ] Sweep spectrum per the list; tag **v0.2.0**.
- [ ] Sweep prism — the alias packages go, its static signatures re-cut — and re-cut `pulse/springbutton`'s one call into `button.Render`, which the signature change breaks. Regenerate the moved goldens.
- [ ] Tag prism **v0.2.0**, then pulse **v0.1.1** — pulse's own API is unchanged, so it moves in patch; ask Rene to push each in order.
- [ ] Confirm resolution from a clean cache, workspace disabled.

#### F3.4: Re-cut the pattern layer onto the majors

Split from the sweep for size: cadence's static `Render` surface spans
eighteen packages, and every one moves goldens.

- [ ] Update cadence and markdown to spectrum v0.2.0 and prism v0.2.0; re-cut their static signatures — every cadence package's `Render`, plus `markdown/style.FromTokens` — to `TextStyle` and `Density`, matching prism's re-cut.
- [ ] Regenerate the moved goldens and say so in the commit body.
- [ ] Tag cadence **v0.3.0** and markdown **v0.1.0**; ask Rene to push.
- [ ] Record the end of `style`'s ADR-003 freeze window: G-F1 moved the last in-org consumers off it, so it is archived at v0.0.6 — frozen, never re-tagged — rather than swept. Note it in its README and in ADR-003.

#### F3.5: Tag the apps and the nested demos

- [ ] Update every workbench app's `go.mod` to the released tags; build, test, run each.
- [ ] Tag the nested demo modules — `prism/gallery`, `mvu/example` — here, once, at their roots' final numbers. The majors came first deliberately: a nested tag mirrors its root's version, so tagging `prism/gallery` before the prism major would mirror a superseded root and cost a second tag at the major's number to get back in correspondence. `prism/gallery` imports `prism/theme` and `prism/tokens`, the shims F3.3 deletes, so it is updated off them before it is tagged at all; `mvu/example` never imported them.
- [ ] Touch up llms.txt's module inventory and minimal `go.mod` to the tags actually cut — the finalization F2.1 deferred here.
- [ ] Run `scripts/check-no-workspace.sh` one last time, after the majors. Green here means every `go.mod` in the org is honest without the workspace propping it up — which is the actual definition of released.

## Phase G: The design-agent surface

Phase E exported the foundations. This phase adds the component layer, which
turns `claude.ai/design` from a token reference into a place where a design
agent composes whole screens out of Vibrant Gio's own parts — screens that then
port to Gio because they were built from the same tokens and the same
component vocabulary.

**Not the converter path.** `/design-sync`'s converter expects a JavaScript
design system: a lockfile, a bundlable `dist/`, React components on
`window.<globalName>.*`, `.d.ts` prop contracts. Vibrant Gio is Go and Gio, so
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
as MD3 defines it, and **hue and chroma come from OKLCh**. Replace both the
colour mathematics and the hardcoded values now in `prism/tokens`. *(As
originally written this ADR also kept MD3's role vocabulary and its
tone-assignment tables; D0.1 amended that — see below.)*

This is HCT's architecture with OKLab substituted for CAM16.

**Its role vocabulary was subject to D0.1, and D0.1 has answered.** The G-D0
spike reopened the question of how tones are *assigned* — MD3's role→tone
tables, Radix's twelve functional steps, or the nine-step ramp — and ADR-007
chose the nine-step functional ramp with paired dark scales. MD3's
tone-assignment tables are therefore retired; the MD3 role *names* survive
only as deprecated aliases until F3.3. The mathematics was not reopened:
CIELAB tone with OKLCh hue and chroma survives, because all three candidates
need a perceptually even lightness axis and none of them supplies one.

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
keeps that vocabulary for free. *(ADR-007 later retired the tables themselves,
but the axis still pays: G-D1 was validated against MD3's published palettes,
tone numbers stay comparable with Google's, and the D0.1 spike script
reproduced the seed exactly at tone 40 on this axis.)*

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
examples, and `style` only by application code.

A3.8 re-measured that last clause and it was wrong in a way that matters.
`"github.com/vibrantgio/style"` is imported by twenty-one files, not thirteen.
Thirteen are the demo mains the original count named — two in `mvu/example`,
four under `ivg/raster/gio/example`, three under `svg/driver/gio/example`, four
in `traer/gio` — but the other eight are real: `todos` (2), `iconbrowser` (2),
`launcher` (1) and `mindchat` (3), four of the seven workbench applications. So
"every one of them a demo" is false. `style` is not a vestige nobody uses; it is
how every Vibrant Gio application that draws its own text gets its shaper, and
llms.txt's typography section teaches `style.FontFaces()` as the correct
wiring. That does not weaken the ADR — the scale still cannot vary with the
theme, which is the actual argument — but it does mean C1.4's deprecation
markers land on symbols that four shipped applications import, and F2's
migration is a real migration rather than a cleanup.

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
Typography), D2.2 (the derived ramps), E1.2 (density), E3.1 (motion), F0.1
(the mono face — its seam tag is F3.1's, since Phase F ends in the release).
Each is a goal boundary, which is where the preamble already puts push
decisions.

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
bypassed entirely for this org and every module resolves straight from GitHub —
which is why `git ls-remote` is the authority worth consulting from *this*
machine.

**But that is a fact about this machine, not about the modules, and reading it
as the latter was a mistake.** These are public repositories, so anyone whose
`GOPRIVATE` does not cover them resolves through the proxy and verifies against
`sum.golang.org` — and doing so records the version there permanently. Rene
installed `workbench/launcher@latest` on a Raspberry Pi with no `GOPRIVATE` set,
which did exactly that. Measured afterwards: `proxy.golang.org/…/mvu/@v/list`
returns 25 versions and `prism` 12, so the proxy plainly does know these
modules; `sum.golang.org/lookup/…/seen/context/gio@v0.0.7` and
`ivg/raster/gio@v0.1.6` both return 200.

**What that costs: the retraction window closes per version, and nothing local
tells you it has.** A version recorded in the checksum database is immutable
forever. Retag it and every consumer who is not `GOPRIVATE`-covered gets a
permanent checksum mismatch — the same failure `workbench/launcher` shows
today, but unfixable, because no repair to the origin can change what the log
already contains. Evicting both Go caches proves only what *this* machine can
still fetch; it says nothing about the log.

**Do not turn that into a habit of probing.** [[#Release protocol]] already
owns this and states the rule correctly: `sum.golang.org/lookup` *computes and
appends* an entry that is missing, so probing a live version is one of the ways
it gets spent. Use `git ls-remote`, which is authoritative and inert, and probe
only when a version is final or when the answer changes the next action. The
protocol also already records that all eight versions G-B1 deleted were clean
on both the proxy and the sumdb — that measurement does not need repeating
here.

What this passage adds is only the correction above: the org is *not* invisible
to the proxy, so "nothing has fetched it publicly" is an assumption with an
expiry date, not a standing property.

### ADR-007: Nine functional steps, paired dark ramps, APCA contrast

**Decision.** Tone stops map to roles the functional way, in Claude Design's
vocabulary: every colour role carries a **nine-step ramp, 100–900**, where the
step *is* the meaning — 100–300 tinted fills, hovers and subtle borders, 500
the mid-value reference, 700–900 text over tinted fills and pressed states —
and the role's **base is pinned separately** from the ramp, exactly as the
reference project's `theme.json` pins `accent`. **Dark mode is a paired ramp,
not a second table**: the generator emits light and dark scales in which the
same step keeps the same job — Radix's pairing mechanism under Claude Design's
numbering — so a component asks for neutral-200 and gets a light card on a
light ground and a dark card on a dark one, with no second assignment table to
drift. **The contrast gate is APCA**: in both ramps, step 900 must reach Lc 90
and step 700 Lc 60 over the step-100 and step-200 grounds, and each pinned
base's on-colour Lc 60 over the base. WCAG 2 ratios are still computed and
reported — conformance claims cite them — but they do not gate the palette.

MD3's role→tone tables are retired. A thin semantic layer — background,
surface, text, divider, plus the pinned role bases — sits over the ramps so
call sites read intent; the MD3-named fields now in use survive as deprecated
aliases resolved into ramp steps until F3.3 deletes the shims.

**The surface mapping.** Identical in both modes, because the dark ramp is
paired rather than re-assigned:

| Surface | Step |
| --- | --- |
| app background | neutral-100 (or the pinned `bg`) |
| card / raised surface | neutral-200 |
| hovered element background | one step past its ground (200 → 300) |
| pressed / selected background | two steps past its ground |
| subtle border, separator | neutral-300 |
| strong border, focusable edge | neutral-500 |
| solid fill | the pinned role base |
| solid hover / pressed | one / two steps from the pin toward 900 |
| low-contrast text | neutral-700 (Lc ≥ 60 guaranteed) |
| body / high-contrast text | neutral-900 (Lc ≥ 90 guaranteed) |

**The evidence.** All three models were generated from the seed `#6750A4` by a
throwaway script implementing ADR-002's math — CIELAB tone, OKLCh hue and
chroma, chroma-reduction gamut mapping — which reproduces the seed exactly at
tone 40. The Radix columns re-hue its published violet scales to the seed's
hue and chroma; the Claude Design columns use the shared lightness scale
measured from the reference project's own ramps (steps 100–900 ≈ L\* 97, 92,
85, 74, 63, 51, 39, 28, 18). MD3 states are its 8%/12% overlays; the other two
walk ramp steps.

| Surface | MD3 light | Radix light | CD light | MD3 dark | Radix dark | CD dark |
| --- | --- | --- | --- | --- | --- | --- |
| app background | `#faf9ff` | `#fcfcfe` | `#f5f4fc` | `#141318` | `#14121c` | `#18171c` |
| card | `#eeedf4` | `#f9f8fe` | `#e8e7ee` | `#201f24` | `#191622` | `#222126` |
| hover | `#dddce3` | `#e9e5f9` | `#d4d3da` | `#2f2e34` | `#32284f` | `#2e2e33` |
| pressed | `#d5d4db` | `#dfdbf6` | `#b7b6bd` | `#37363c` | `#3c315b` | `#47464c` |
| subtle border | `#c7c5d3` | `#d3ccf2` | `#d4d3da` | `#474551` | `#463b68` | `#2e2e33` |
| strong border | `#787582` | `#c1b8e6` | `#98979e` | `#918f9d` | `#554a7b` | `#9e9da4` |
| solid fill | `#6750a4` | `#735cb1` | `#6750a4` | `#cbbeff` | `#735cb1` | `#a690ea` |
| low-contrast text | `#474551` | `#68559f` | `#5d5c62` | `#c7c5d3` | `#b8abeb` | `#cccbd2` |
| body text | `#1c1b20` | `#332851` | `#2b2a30` | `#e3e2e9` | `#e2def6` | `#eeedf4` |

All three set a competent table — the differences are in who maintains what.
MD3's dark column exists because a second hand-written table says so; the other
two derive it. Radix alone keeps the brand colour identical in dark mode
(step 9 unchanged); MD3 and this ADR lighten the fill and accept that dark
mode shifts the accent, which is also what every Material app already does.

**Where nine cannot say what twelve can.** Hover background and subtle border
collide on step 300 (visible in the CD columns above), and there is no
dedicated solid-hover stop. Neither costs this org anything: prism and cadence
carry exactly two border weights — `Outline` and `OutlineVariant`, which map to
500 and 300 — and derive hover as a state resolution rather than a distinct
token; MD3 itself makes hover an 8% overlay, not a stop. Radix's extra
resolution (hover 4 and active 5 distinct from the border trio 6–8, a solid
hover at 10) buys precision nothing in prism or cadence consumes.

**The seed sits deep, so bases are pins.** `#6750A4` is L\* 40 — step-700
depth on the shared scale, where 500 sits at L\* 63. Reading the solid fill
off the ramp would lighten the brand colour to `#a08ae4`; pinning reproduces
it exactly. This is the reference project's own practice, not a deviation: its
`.btn-primary` uses `--color-accent` — the pin — while the ramp supplies tints
and text shades.

**Why APCA and not WCAG 2.** Spectrum tracks OS dark mode by default, and
WCAG 2's known failure mode is over-rating light-on-dark. Measured on this
seed's own dark palettes: outline-strength text `#918f9d` on an MD3 card
`#201f24` scores WCAG 5.17:1 — a clean AA pass — at APCA Lc −41, unreadable
as body text. The seed's tone 60 `#9983dc` on the dark ground passes AA at
5.85:1 with Lc −42; tone 50 passes AA-large at 4.13:1 with Lc −30. Every one
of those would sail through a ratio gate and fail readers. On pairs that are
genuinely fine the two metrics agree (dark-mode body text lands Lc −87…−96
across all three models), so APCA costs nothing where WCAG was right. Radix
reaches Lc 60/90 by hand-tuning; here the generator meets the same numbers by
test. One tuning the spike already caught: the measured scale's light-mode
900-on-200 pair lands at Lc 87, just under the gate, so D2.4 will push the 900
stop slightly deeper. *(D2.4 landed two tunings, both larger than "slightly":
APCA's soft black clamp caps even pure black near Lc 92 over the L\* 92
step-200 ground, so the light 900 stop deepened from the measured L\* 18 to
L\* 6 — the depth where all five ramps clear Lc 90 with margin — and the dark
pins rose from the measured L\* 65, a mid-tone no text of any colour reaches
Lc 60 over (black tops out near 52, white near 57), to L\* 82, the dark
scale's step-700 depth beside MD3's dark accent tone 80. The dark fill
recorded above, `#a690ea`, survives as the dark primary ramp's step 500; the
shipped dark pin for this seed is `#d0c4ff`. The evidence table itself is the
spike's measurement and stands unchanged.)*

**Why not MD3's tables.** The design knowledge lives in two hand-written
role→tone tables that must be kept in step — dual authorship of dark mode, the
exact drift this plan keeps removing elsewhere — feeding a twenty-six-name
role set whose meaning lives in documentation rather than structure. Its
states are alpha overlays a token sheet cannot address, and its conformance
anchor is the ratio shown above over-rating every dark pair. Its tone
*mathematics* is kept in full (ADR-002); only the assignment tables retire.

**Why not Radix's twelve.** The strongest model in isolation, and this ADR
takes its two best ideas — paired scales and APCA guarantees. But its step
numbers are its vocabulary, and that vocabulary collides with the surface this
org prototypes on: G-E0 pushes the tokens into a Claude Design project whose
entire convention — readme, foundation pages, component CSS — speaks
`--color-*-100…900`. Adopting step-9/step-11 would put a translation table
between every prototype and the app it prototypes, the exact incoherence this
plan exists to remove, and the plan weights that argument explicitly. Its
scales are also hand-tuned per hue rather than generated, so "adopt Radix"
really means "build a different generator and borrow its numbering" — and the
numbering is the part that costs.

**Consequences.**

- **G-D2** is re-cut to this model: D2.1 defines the ramp type, pins and
  semantic layer with the MD3 names as deprecated aliases; D2.2 derives paired
  light/dark ramps from a seed with the base pinned to it exactly; D2.3
  resolves interaction states as step walks rather than opacity overlays;
  D2.4 gates on the Lc numbers above and reports WCAG AA alongside.
- **E0.1** emits `--color-<role>-100…900` plus the pinned bases — the exact
  families the reference project documents.
- **E0.2**'s colour page annotates step purposes and the measured Lc of each
  text pair.
- **G1.2** already assumed ramp-derived states and stands unchanged.
- **ADR-002** is amended: its mathematics stands untouched; its "keep MD3's
  role vocabulary and its tone-assignment tables" clause is superseded here.

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

### Defects found but not fixed

Real defects turned up while doing other work, in code no phase of this plan
touches. They are recorded here so they survive the task that found them. None
is scheduled; each needs a task cut for it before it gets fixed.

~~**`svg` inverts the SVG `fill-rule` property.** `parser/svgcursor.go:133` reads~~

```go
case "fill-rule":
	curStyle.UseNonZeroWinding = strings.EqualFold(v, "evenodd")
```

~~which is backwards. Per the SVG specification `fill-rule` takes `nonzero` (the
initial value) or `evenodd`, so this sets non-zero winding exactly when the
document asked for even-odd, and clears it when the document asked for
non-zero. `defaultstyle.go:14` has the correct default (`UseNonZeroWinding:
true`), so only paths that *state* a `fill-rule` are affected — and they are
affected whichever value they state. The fix is one line, but it changes
rendering, so it needs a self-intersecting-path regression test alongside it.~~

~~What makes it survivable, and easy to miss: `driver/draw.go:43` forwards the
flag to every driver's `SetWinding`, and the Gio driver's is an empty body —
`driver/gio/driver.go:59`, deliberately, because `clip.Outline` is non-zero
only and Gio exposes no even-odd rule. So the defect is *invisible* under the
one driver the design system uses, and live under the three that honour the
flag: `driver/raster`, `driver/pdf` and `driver/seen`. A fix therefore cannot
be validated through the Gio path — it needs a raster or pdf golden.~~

~~Found in A3.9; also recorded in `svg`'s own README, which is the only place a
reader of that repo would see it.~~

**Fixed in FX.1.** The parser now keeps non-zero winding unless the document
states `evenodd`. The regression test lives in `driver/raster` — a pentagram
whose centre has winding number two, asserted filled under `nonzero`, hollow
under `evenodd`, filled when unstated — and rasters through `srwiley/scanFT`,
because the default `rasterx.ScannerGV` ignores `SetWinding` too, so even the
stock raster path could not see the defect. No golden existed to move: the
repository has no golden images at all, per its own README. One trap worth
keeping: the "standard" star path that alternates outer and inner vertices is
the *non*-self-intersecting outline, winding 1 everywhere, and cannot tell the
rules apart — the discriminating path is the one that visits every second
vertex. `svg`'s README now records the parse as fixed and the Gio driver's
winding blindness as the remaining, separate limitation.

**Two modules do not build *from a clone*, on a `go.sum` pin of content that
was never published.** `workbench/launcher` and `svg/driver/seen` both stop
with `verifying github.com/vibrantgio/seen/context/gio@v0.0.7: checksum
mismatch`. A2.4 chased this to the end: `git ls-remote` shows GitHub carrying
the tag, a `GOPROXY=direct` fetch hashes to `OJip+UYN…`, and the proxy serves
the same bytes. `sum.golang.org` publishes the same hash again, plus a `/go.mod`
hash of `qmUvReYG…`. Git, the proxy and the checksum database all agree with
each other, and all three disagree with the committed `go.sum`, whose **both**
lines are wrong — `cCJSzFNE…` and `prWx6vpY…` pin content that exists in no
repository. So this is a consumer-side repair, no push closes it, and `go mod
tidy` alone cannot do it either: it verifies before it rewrites.

**Scope, measured — this does not reach users.** `go install
github.com/vibrantgio/workbench/launcher@latest` succeeds on a machine with no
Vibrant Gio code present; Rene did it on a Raspberry Pi, and it reproduces
here. The reason is that `go install pkg@version` synthesizes an empty main
module, so the *target* module's `go.sum` is never consulted — a dependency's
`go.sum` never is — and verification falls through to `sum.golang.org`, which
holds the correct hash. A committed `go.sum` is only load-bearing when that
module is the **main** module, which is exactly the clone-and-build path. So
the breakage hits contributors and this plan, not anyone installing the
published command. (`GOPRIVATE` covering `github.com/vibrantgio/*` on the
development machine is *not* the cause: the mismatch is against the main
module's own `go.sum`, which fails whether or not the checksum database is
consulted.)

~~Scheduled as **B2.0**, not in G-FX. It blocks two builds now, F1.1 migrates
one of the two broken modules, and B2.1's workspace would mask it — so Phase F
is too late on all three counts.~~

**Fixed in B2.0.** The org-wide sweep found the bad hashes in exactly two
`go.sum` files — `svg/driver/seen` and `workbench/launcher`, the two already
known — and nowhere else in the 34. Dropping both lines and re-tidying
recorded `h1:OJip+UYN…` and `/go.mod h1:qmUvReYG…`, matching what
`sum.golang.org` publishes; `go mod tidy` changed those two lines and nothing
else in either file. Both modules build and test green with `GOWORK` empty, so
the repair is verified against the published tag rather than masked by the
tree. Kept here because the diagnosis is the part worth not relearning: a
`go.sum` can disagree with git, the proxy *and* the checksum database at once,
and `go install pkg@version` will not show it to you.

**`pulse/spring`'s zero-value options are unusable, and a partial override is
worse than none.** `spring.go:114-121` fills `Stiffness`, `Damping` and `Mass`
from their defaults *field by field*. `DefaultStiffness = 0.4` with
`DefaultDamping = 0.7` takes ~873 frames — about 15 seconds at 60 Hz — to
settle to 0.005, so `spring.Options{}` is not a usable default. Worse, setting
one field takes the others from those same soft defaults: `Options{Stiffness:
80}` alone lands at ζ ≈ 0.04, which rings for thousands of frames. Neither
in-module consumer goes near the defaults (motion uses k=80, springbutton
k=300), which is why nothing caught it. A3.6 documented both in the package
comments; the behaviour is unchanged.

**`pulse/depth` paints a hard rectangle under every rounded caller.**
`depth.go:86` fills the shadow's interior with `clip.Rect(shadowBounds)` at
full alpha. All three callers — `cadence/card`, `cadence/toast` and
`workbench/mindchat` — draw a rounded foreground over it, leaving square dark
wedges at the corners. It also exposes no opacity control, which is why
`cadence/toast` wraps it in a `PushOpacity`. Distinct from E2.2, which decides
*when* a shadow is appropriate; this is the geometry being wrong when one is.

**`pulse/tween` panics on a nil `Lerp`, but only in the interior.** `At` returns
the endpoints without interpolating and reaches `tw.Lerp(...)` at
`tween.go:61` only for `0 < n < Frames`, so a test that samples `At(0)` and
`At(Frames)` passes against a `Tween` that will panic on the first real frame.

**`spectrum`'s appearance observable is cold, so *n* consumers means *n*
pollers.** Nothing in `Live → FromSource` or `LiveTheme`'s `rx.Map` multicasts,
so every subscription starts its own poll loop. A3.5 measured it: one
subscriber produced 4 source reads, three produced 222. Every workbench app
subscribes at least twice — `BackdropLayer(th)` and `ContentLayer(th, …)`. The
darwin source throttles *accent* to one exec per `accentInterval`
(`system_darwin.go:28`), but that cache lives on the `Source`, so it does not
dedupe across subscriptions and does not cover the appearance read at all.

**`spectrum/preferences.Observe` completes after one read.**
`preferences.go:121-129` is `rx.Defer` around `rx.Of(p)`, so it emits the
loaded value once and completes. A later `Save` notifies nobody, which makes
the "observable" name misleading for the one job it exists to do.

**`cadence/sidebar` paints past the bottom of the screen.** Items are stacked at
a fixed 48 dp pitch with no scroll region (`sidebar.go:19-21`, `itemDp = 48`),
so a nav list taller than the viewport simply runs off the edge with no way to
reach the rest. The 192/48 dp column widths are local constants that ignore the
horizontal constraint as well.

**`markdown/highlight` makes `Style.CodeColor` unreachable.** The chroma hook
emits a colour for *every* run it produces, so the fallback documented at
`style.go:20` never fires and code blocks leave the token palette entirely.
Separately, an unrecognised style name falls back to chroma's dark-background
default, which renders near-white — illegible on the light theme, and silent.
D2.7 migrates markdown to the new roles and C2.8 moves it to theme typography;
neither would notice a path that bypasses the tokens altogether.

**`gradient` and `circle` ship no LICENSE file.** The other eighteen repos have
one. They are public modules, so this is a packaging defect rather than a
cosmetic one.

### Release protocol

Modules are tagged bottom-up, one layer at a time, and each layer is verified
from a clean module cache before the layer above it moves:

```
mvu, font  →  spectrum  →  prism  →  pulse  →  cadence, markdown  →  workbench apps
```

mvu is tagged first, not with the pattern layer: `spectrum/window` imports it,
which makes it tier 0 in ADR-001 and puts everything else behind it. font sits
beside it, not beside spectrum — C1.2 made spectrum require it for the default
Roboto faces, ADR-001's tier-0/tier-1 edge, so an earlier draft of this
diagram that grouped `font, spectrum` in one round was stale the day that
edge landed. The nested demo modules — `prism/gallery`, `mvu/example` — tag
last with the apps, since they sit above everything they demonstrate.

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

**Violated once, recorded honestly.** The D2 through E5 boundary rounds cut
their seam tags without consulting this section: spectrum ran v0.0.10 through
v0.0.15 and pulse v0.0.10 through v0.0.12, and all nine are on the remotes,
immutable. The remedy is the rule's own: bury them. Spectrum's next tag is
**v0.1.0** and pulse's is **v0.1.0** — never another v0.0.x in either repo —
and G-F3's tasks name those numbers explicitly so the correction cannot be
missed a second time.

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
