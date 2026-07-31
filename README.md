# vibrantgio/.github

The organization's front door and the root of its plan. No library code lives
here — that is in the twenty sibling repositories listed on the
[organization page](https://github.com/vibrantgio). This repository holds three
things.

**[`profile/README.md`](profile/README.md) — the organization page.** GitHub
renders it at [github.com/vibrantgio](https://github.com/vibrantgio): what
VibrantGio is, where to start reading, and the layered table of the whole stack.
That file, not this one, is the org page. This README renders only on
[this repository's own page](https://github.com/vibrantgio/.github), so the two
are edited separately and say different things.

**[`llms.txt`](llms.txt) — the canonical agent guide.** The file to hand a
coding assistant before it writes a line of VibrantGio code: the module
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

- [`scripts/clone-all.sh`](scripts/clone-all.sh) — clone all twenty siblings
  into `.repos/`, pulling any already present. The whole set every time: the
  plan edits the module graph, and no task can see an edge whose other end is
  missing. Plain `git` over HTTPS, no `gh` required.
- [`scripts/inventory.sh`](scripts/inventory.sh) — survey those clones and print
  a Markdown table: README, `AGENTS.md`, `doc.go`, CI, Gio and rx versions, and
  module count per repo. Every count the plan asserts is checked against this,
  not remembered.

Across the twenty repositories there are 36 modules — nineteen at repository
roots, ten nested in subdirectories with tags that carry the subdirectory as a
prefix, and seven example applications in `workbench`, which has no root module
of its own. All 36 declare Go 1.25.1; every one that depends on Gio is on
gioui.org v0.10.1 and every one that depends on rx is on
github.com/reactivego/rx v0.3.0 — one version of each, organization-wide.
