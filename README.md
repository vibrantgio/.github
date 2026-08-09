# vibrantgio/.github

The organization's front door and the root of its plan. No library code lives
here — that is in the twenty sibling repositories listed on the
[organization page](https://github.com/vibrantgio). This repository holds three
things.

**[`profile/README.md`](profile/README.md) — the organization page.** GitHub
renders it at [github.com/vibrantgio](https://github.com/vibrantgio): what
Vibrant Gio is, where to start reading, and the layered table of the whole stack.
That file, not this one, is the org page. This README renders only on
[this repository's own page](https://github.com/vibrantgio/.github), so the two
are edited separately and say different things.

**[`llms.txt`](llms.txt) — the canonical agent guide.** The file to hand a
coding assistant before it writes a line of Vibrant Gio code: the module
inventory with current tags, the application skeleton, MVU and rx semantics,
typography, and the pitfalls that are not guessable. Its canonical URL is

    https://raw.githubusercontent.com/vibrantgio/.github/master/llms.txt

It exists exactly once, here. `workbench/llms.txt`, its old home, is now a
three-line pointer at that URL, and the per-repo `AGENTS.md` files that Phase A
adds link it rather than copy it — so there is one version to read and one to
edit.

**[`PLAN.md`](PLAN.md) — the plan.** Seven phases that turn the repositories
from a loose collection into one design system: the front-door documentation
(A), repairing the module graph (B), giving the theme ownership of the typeface
(C), generative colour (D), reimagining Material Design's ideas for desktop (E),
proving and releasing it (F), and a design-agent surface (G). The architecture
decisions behind them are recorded as ADRs in its Reference section. Work is
picked up one `####` task at a time — `mdplan next PLAN.md` — and each task is
one commit.

## Working tree

The sibling repositories are cloned into `.repos/<name>` beneath this one and
are gitignored; this repository is their parent directory, not one of them.
`go.work`, committed here, joins all 36 of their modules so they resolve each
other from the checkout — the members never carry a workspace themselves.

Seven scripts live in `scripts/`. Four of them do work.

- [`scripts/clone-all.sh`](scripts/clone-all.sh) — clone all twenty siblings
  into `.repos/`, pulling any already present. The whole set every time: the
  plan edits the module graph, and no task can see an edge whose other end is
  missing. Plain `git` over HTTPS, no `gh` required.
- [`scripts/inventory.sh`](scripts/inventory.sh) — survey those clones and print
  a Markdown table: README, `AGENTS.md`, `doc.go`, CI, Gio and rx versions, and
  module count per repo. Every count the plan asserts is checked against this,
  not remembered.
- [`scripts/sync-agents.sh`](scripts/sync-agents.sh) — render
  [`templates/AGENTS.md`](templates/AGENTS.md) into named clones and report a
  diff, writing nothing with `-n`. Every repository carries the same
  `AGENTS.md` in the same shape (ADR-004); only two fields are typed per repo —
  the role sentence and the tier half of the layer line — and those live in
  [`templates/repos.tsv`](templates/repos.tsv). Everything else is measured
  from the clone and so cannot drift: the module, build and golden-image
  paragraphs, and both directions of the layer paragraph's dependency claim.
  It never commits.
- [`scripts/push-design.sh`](scripts/push-design.sh) — regenerate
  [`design/`](design) from spectrum's `cmd/vg-tokens` and print the DesignSync
  sequence that uploads it. There is no `designsync` binary: the script does
  the local half and hands the push to the agent running it.

Three more answer a single yes-or-no question, and each refuses to let one kind
of wrong thing be committed quietly.

- [`scripts/check-layers.sh`](scripts/check-layers.sh) — refuses an import from
  a module into a repository at or above its own tier. It runs `go list -deps`
  over the nineteen root modules and judges every `github.com/vibrantgio` edge
  against ADR-001's tier table, so the layering is measured rather than
  intended; the twelve repositories that have CI fetch this same file and run
  it as `check-layers.sh .`. Its `--edges` mode reports that one walk as TSV instead
  of judging it, and the layer sentence in all twenty `AGENTS.md` files is
  rendered from that.
- [`scripts/check-no-workspace.sh`](scripts/check-no-workspace.sh) — refuses to
  let the workspace flatter the tree. It builds and tests all 36 modules with
  `GOWORK=off`, the way CI, `go get` and pkg.go.dev see them, because under
  `go.work` a module compiles against a sibling's working copy while its own
  `go.mod` still points at a stale tag. It also fails on a `replace` directive
  in any member.
- [`scripts/check-agents.sh`](scripts/check-agents.sh) — refuses a generated
  `AGENTS.md` that was corrected in the clone. It re-renders every repository
  and fails on any whose committed file differs. The way the drift happens is
  that a correction lands in the generated file instead of the template, where
  it survives only until the next render throws it away; this is what notices.

Across the twenty repositories there are 36 modules — nineteen at repository
roots, ten nested in subdirectories with tags that carry the subdirectory as a
prefix, and seven example applications in `workbench`, which has no root module
of its own. All 36 declare Go 1.25.1; every one that depends on Gio is on
gioui.org v0.10.1 and every one that depends on rx is on
github.com/reactivego/rx v0.3.0 — one version of each, organization-wide.
