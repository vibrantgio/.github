# vibrantgio/.github

The organization's front door and the root of its plan. No library code lives
here — that is in the twenty-one sibling repositories listed on the
[organization page](https://github.com/vibrantgio).

**[`profile/README.md`](profile/README.md) — the organization page.** GitHub
renders it at [github.com/vibrantgio](https://github.com/vibrantgio): what
Vibrant Gio is, where to start reading, and the layered table of the whole stack.
That file, not this one, is the org page. This README renders only on
[this repository's own page](https://github.com/vibrantgio/.github), so the two
are edited separately and say different things.

**[`PLAN.md`](PLAN.md) — the plan.** How Vibrant Gio itself is built. Eight
phases that turn the repositories from a loose collection into one design
system. The architecture decisions behind them are ADRs in its Reference
section. Work is picked up one `####` task at a time —
`mdplan next PLAN.md` — and each task is one commit.

**[`llms.txt`](https://github.com/vibrantgio/workbench/blob/master/llms.txt)
is not in this repository.** It lives in `workbench` and is the guide for
writing an *application* with Vibrant Gio — modules and tags, the bootstrap
skeleton, MVU and rx, typography, the pitfalls that bite app code. It is
not how you work this plan. Its URL is

    https://raw.githubusercontent.com/vibrantgio/workbench/master/llms.txt

Every sibling's `AGENTS.md` is a short static pointer to that URL.

## Working tree

The checkout mirrors the organization: one directory per repository, all
siblings, this one — `.github` — among them rather than above them. Their
shared parent, the workspace root, is not a repository; `go.work` lives there,
*generated* by `clone-all.sh` from the go.mod files actually present, joining
the modules so they resolve each other from the checkout — the members never
carry a workspace themselves, and the workspace itself is committed nowhere.

Eight scripts live in `scripts/`. Four of them do work.

- [`scripts/clone-all.sh`](scripts/clone-all.sh) — clone all twenty-one siblings
  beside this checkout, pulling any already present, then regenerate `go.work`. The whole set every time: the
  plan edits the module graph, and no task can see an edge whose other end is
  missing. Plain `git` over HTTPS, no `gh` required.
- [`scripts/inventory.sh`](scripts/inventory.sh) — survey those clones and print
  a Markdown table: README, `AGENTS.md`, `doc.go`, CI, Gio and rx versions, and
  module count per repo. Every count the plan asserts is checked against this,
  not remembered.
- [`scripts/sync-versions.sh`](scripts/sync-versions.sh) — write the measured
  module versions into the workbench clone's `llms.txt`, reading `git tag` in
  every clone and touching nothing but the version tokens. It is the last step
  of a release. A number typed into prose has no gate on it; this is the rewriter.
- [`scripts/push-design.sh`](scripts/push-design.sh) — regenerate the sibling
  [`design`](https://github.com/vibrantgio/design) repository's bundle from
  theme's `cmd/vg-tokens` and print the DesignSync
  sequence that uploads it. There is no `designsync` binary: the script does
  the local half and hands the push to the agent running it.

Four more answer a single yes-or-no question, and each refuses to let one kind
of wrong thing be committed quietly.

- [`scripts/check-layers.sh`](scripts/check-layers.sh) — refuses an import from
  a module into a repository at or above its own tier. It runs `go list -deps`
  over the nineteen tabled root modules — all twenty-one minus `design` and
  `workbench`, the applications — and judges every `github.com/vibrantgio` edge
  against ADR-001's tier table, so the layering is measured rather than
  intended. Run it here, from the plan root. Its `--edges` mode reports
  that one walk as TSV instead of judging it.
- [`scripts/check-no-workspace.sh`](scripts/check-no-workspace.sh) — refuses to
  let the workspace flatter the tree. It builds and tests all 39 modules with
  `GOWORK=off`, the way `go get` and pkg.go.dev see them, because under
  `go.work` a module compiles against a sibling's working copy while its own
  `go.mod` still points at a stale tag. It also fails on a `replace` directive
  in any member.
- [`scripts/check-versions.sh`](scripts/check-versions.sh) — refuses a typed
  version number in `llms.txt`. It runs `sync-versions.sh -n` and fails on any
  difference, so the guide cannot claim a tag the repositories do not carry.
- [`scripts/check-subjects.sh`](scripts/check-subjects.sh) — refuses a bare
  `rx.Subject` outside the one package ADR-008 still allows it in, and refuses
  an exported package-level observable anywhere. The first leaks a subscription
  slot per process and pins its producer; the second is the shape all four of
  the coordination buses ADR-008 deleted arrived in, every one of them with no
  subscriber in the entire organization. Occurrences in `_test.go` files are
  counted and reported, never judged — the header says why.

Across the twenty-one repositories there are 39 modules — twenty-one at
repository roots, eleven nested in subdirectories with tags that carry the
subdirectory as a prefix, and seven applications in `workbench` beside that
repository's root module. `workbench` and `design` carry no tags; they are
consumed from the branch tip.
All 39 declare Go 1.25.1; every one that depends on Gio is on
gioui.org v0.10.2 and every one that depends on rx is on
github.com/reactivego/rx v0.3.0 — one version of each, organization-wide.
