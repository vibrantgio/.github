# AGENTS.md — vibrantgio/.github

This repository is the **plan root** and the **front door** of the
`github.com/vibrantgio` organization. No library code lives here. If you have
been dropped into this working tree with no other context, this file and
`PLAN.md` are the two you need.

## Start at PLAN.md

[`PLAN.md`](PLAN.md) is the entry point: eight phases that turn twenty-one
loosely related repositories into one Gio design system — front-door
documentation (A), the module graph (B), typography (C), generative colour
(D), Material's ideas reimagined for desktop (E), proof and release (F), a
design-agent surface (G), and the desktop seam (H). The architecture
decisions behind them are ADRs in its Reference section.

Work is picked up one `####` task at a time, and the way to pick it up is

    mdplan next PLAN.md

run from this directory. It prints the plan's standing rules, the phase and
goal context, and the first unchecked task. Do that task's steps and nothing
else. Check each one off as you genuinely finish it:

    mdplan toggle -s "<task heading>" --item "<substring of the step text>" PLAN.md

The plan's prose is not authority. Every task so far has found at least one
assertion in it that was wrong — a count, a version, a tag. Verify claims
against the sibling clones (`scripts/inventory.sh` is the survey), and
correct the plan where it is wrong: `mdedit` does the structural edits
(`mdedit --help` for the op table — it shares mdplan's `-s` section targeting
but does not default the filename, so name `PLAN.md` explicitly).

## The working tree

The checkout mirrors the organization: one directory per repository, all
siblings, `.github` among them rather than above them. The parent directory —
the *workspace root* — is not a repository at all; it is just the folder the
org is checked out into.

    <workspace root>/     <- not a repository; go.work lives here, generated
      go.work             the development workspace (generated, never committed)
      .github/            <- you are here: plan root and org front door
        PLAN.md           the plan
        AGENTS.md         this file
        README.md         this repository's own page
        profile/README.md what renders at github.com/vibrantgio
        scripts/          clone-all.sh, inventory.sh, sync-versions.sh,
                          push-design.sh, and the four gates —
                          check-layers.sh, check-no-workspace.sh,
                          check-versions.sh, check-subjects.sh
        explorations/     spike proposals not yet scheduled into the plan
      mvu/ theme/ components/ effects/ patterns/ markdown/
      font/ style/ textdraw/ backdrop/ gradient/ circle/
      ivg/ svg/ seen/ csg/ kiwi/ noise/ traer/
      workbench/ design/

This repository is one sibling among twenty-two, and the only one that is not
surveyed. This file is hand-written and describes a plan rather than a
module. Every sibling's `AGENTS.md` is a short static pointer to `llms.txt`
— what the module is, and the guide URL. It is not generated.

`scripts/clone-all.sh` clones the siblings and pulls what is already there —
run it if clones are missing or stale. Almost all work happens inside a sibling
clone; the plan lives here, the guide in `workbench/llms.txt`.

Those twenty-one repositories hold **39 Go modules**: twenty-one at repository
roots, eleven nested in subdirectories whose tags carry the subdirectory as a
prefix, and seven applications in `workbench`, each its own module released on
its own cadence beside the repository's root module.
The go.mod files beside this checkout are the list — do not hand-maintain it.

**`go.work` at the workspace root joins them**, so a module resolves its
siblings from the working tree rather than from published tags. It is
*generated*, by `clone-all.sh`, from the go.mod files actually present — a
workspace describes one developer's checkout, so a repository you have not
cloned is simply absent rather than a dangling `use` line. It is committed
nowhere: the workspace root is not a repository, and G0E.1 retired the old
committed copy that described a gitignored checkout. Re-run `clone-all.sh`
after cloning or removing a repository rather than editing it.

That convenience is also the standing trap, and it is why green has two
meanings. Outside this tree — CI, `go get`, pkg.go.dev — each `go.mod` resolves
against published tags, so a cross-repo change is invisible to the other side
until it is tagged and pushed, and a module can build here while being broken
for everyone. `scripts/check-no-workspace.sh` is what measures that gap. No
member repo ever gets a `go.work` or a `replace` directive. ADR-006 in
`PLAN.md` is the full argument.

## `scripts/` — four that do work, four that refuse

Four produce something:

- **`clone-all.sh`** clones all twenty-one siblings beside this checkout, pulling any
  already present. The whole set every time: this plan edits the module graph,
  and no task can see an edge whose other end is missing.
- **`inventory.sh`** surveys those clones and prints a Markdown table — README,
  `AGENTS.md`, `doc.go`, CI, Gio and rx versions, modules per repo. Every count
  the plan asserts is checked against this rather than remembered.
- **`sync-versions.sh`** writes the measured module versions into the
  workbench clone's `llms.txt`, reading `git tag` in every clone and rewriting
  nothing but the version tokens; `-n` writes nothing. A number typed into
  prose has no gate on it; this is the rewriter. Run it after cutting a tag,
  in the same task.
- **`push-design.sh`** regenerates `design/` from theme's `cmd/vg-tokens` and
  then prints the exact DesignSync sequence to run. There is no `designsync`
  binary — the upload half is a Claude-session step, so this script does the
  local half and hands over.

Four answer one yes-or-no question each, and each exists to make a specific
class of wrong thing impossible to commit quietly:

- **`check-layers.sh` refuses to let a module import a repository at or above
  its own tier.** It runs `go list -deps` over the nineteen tabled root
  modules — all twenty-one minus `design` and `workbench`, the
  applications — and judges
  every `github.com/vibrantgio` edge against ADR-001's tier table, so the
  layering is a measured property rather than an intention. Demo and adapter
  nested modules are exempt and skipped, and so are the applications —
  `workbench`'s and `design`; their parents do not inherit the
  exemption. Run it here, from the plan root. Its `--edges` mode reports
  that one walk as TSV over all 39 modules instead of judging it. There
  must not be a second walk of the graph anywhere in the organization.
- **`check-no-workspace.sh` refuses to let the workspace flatter you.** It
  builds and tests all 39 modules with `GOWORK=off`, which is how CI,
  pkg.go.dev and every consumer outside this tree see them. Under `go.work` a
  module compiles against a sibling's working copy while its own `go.mod` still
  points at a stale tag; this is what notices the difference, and the size of
  that difference is exactly the cross-repo tag debt ADR-006 manages. It also
  fails on a `replace` directive in any member — the most tempting wrong way to
  make it go green, and one that would silently redirect every outside
  consumer.
- **`check-versions.sh` refuses a typed version number in `llms.txt`.** It runs
  `sync-versions.sh -n` and fails on any difference. Before G0C.6 the canonical
  guide claimed prism v0.3.1 where the tag was v0.6.0 and was wrong for five of
  eight modules, under a line reading "EVERY TAG ABOVE IS RELEASED AND
  CURRENT"; nothing caught it because a number in prose has nothing to disagree
  with.
- **`check-subjects.sh` refuses a bare `rx.Subject` outside its one remaining
  home, and an exported package-level observable anywhere.** ADR-008's gate.
  The allowlist holds `components/coordination` and will hold nothing once that
  package is removed; `mvu/stream` is deliberately not on it, because the
  sanctioned primitive contains no `rx.Subject` at all. The second rule catches
  the shape — verified against cadence before this goal, where it reports all
  four of the deleted buses and nothing else — but not the deadness: an
  exported observable with no subscriber is invisible to any tool, and the
  header says so rather than implying otherwise. `_test.go` occurrences are
  counted, printed and never judged.

Nothing runs these four for you: this repository has no CI of its own, and the
per-repo CI can only see its own repo. Run them here before you believe the
tree.

## Four rules you must not discover late

These are `PLAN.md`'s preamble, restated because learning them after the fact
is expensive. `mdplan next` reprints them with every task; read them there too.

**One task, one commit.** Do the steps of exactly one `####` task, then commit
in each repository you touched, with the task heading in the subject line and
a `Co-Authored-By: Claude <model> <noreply@anthropic.com>` trailer naming the
model that actually did the work (currently Fable 5; earlier phases were
Opus 5). Commit on the default branch; feature branches get lost here.

**Green before commit.** In every Go module you touched, `go build ./... && go
test ./...` must pass. Golden-image tests count — when a change legitimately
moves pixels, regenerate the goldens within the same task and say so in the
commit body. Never commit red.

**Push when it's green.** A commit on `master` is not a release — the tag is.
So there is nothing to hold back: once a task's commits are made and green,
push them, in every repository you touched, without asking. Rene works from
more than one machine and other systems consume these repositories; commits
stranded in a local clone are invisible work, and finding them costs him a
manual audit. Do not end a task with a repository ahead of its origin.

**Releases stay deliberate.** The cross-repo tag seams of ADR-006 prescribe the
order — push masters, tag bottom-up, bump pins, `GOWORK=off` verify, second
self-referencing pass — and that order holds in full. It is a sequencing rule,
not a permission gate: follow it end to end rather than stopping between steps.

**Stop if a task is too big.** Tasks are cut to fit roughly 100K tokens of one
agent run. If one turns out larger, check off what you genuinely finished,
commit it, and report that the task needs splitting, with a proposed split. Do
not push through: a task that silently runs for hours is the failure mode this
plan exists to prevent.

## llms.txt answers a different question

[`llms.txt`](https://github.com/vibrantgio/workbench/blob/master/llms.txt) is
the organization's canonical agent guide, and it exists exactly once — in
`vibrantgio/workbench`, the repository that showcases building applications
with Vibrant Gio (ADR-004, amended; this repository is where Vibrant Gio
itself is built). Its raw URL is

    https://raw.githubusercontent.com/vibrantgio/workbench/master/llms.txt

and every repository's `AGENTS.md` is a short static pointer to that URL,
so there is one version to read and one to edit (ADR-004).

**It covers writing Gio code against these libraries, not working this plan.**
Module inventory and current tags, the application skeleton, the MVU loop and
rx semantics, typography, layers, icons, the pitfalls that are not guessable —
read it before you write a line of Vibrant Gio application code. It says nothing
about tasks, checkboxes, commits or the working tree; for those, this file and
`PLAN.md` are the answer. Editing the guide is itself plan work, so the rules
above still apply to it.
