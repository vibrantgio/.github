# AGENTS.md — vibrantgio/.github

This repository is the **plan root** and the **front door** of the
`github.com/vibrantgio` organization. No library code lives here. If you have
been dropped into this working tree with no other context, this file and
`PLAN.md` are the two you need.

## Start at PLAN.md

[`PLAN.md`](PLAN.md) is the entry point: seven phases that turn twenty-one
loosely related repositories into one Gio design system — front-door
documentation (A), the module graph (B), typography (C), generative colour
(D), Material's ideas reimagined for desktop (E), proof and release (F), a
design-agent surface (G). The architecture decisions behind them are ADRs in
its Reference section.

Work is picked up one `####` task at a time, and the way to pick it up is

    mdplan next PLAN.md

run from this directory. It prints the plan's standing rules, the phase and
goal context, and the first unchecked task. Do that task's steps and nothing
else. Check each one off as you genuinely finish it:

    mdplan toggle -s "<task heading>" --item "<substring of the step text>" PLAN.md

The plan's prose is not authority. Every task so far has found at least one
assertion in it that was wrong — a count, a version, a tag. Verify claims
against the clones under `.repos/` (`scripts/inventory.sh` is the survey), and
correct the plan where it is wrong: `mdedit` does the structural edits
(`mdedit --help` for the op table — it shares mdplan's `-s` section targeting
but does not default the filename, so name `PLAN.md` explicitly).

## The working tree

    .github/              <- you are here: plan root and org front door, not a clone
      PLAN.md             the plan
      llms.txt            the canonical agent guide (see below)
      AGENTS.md           this file
      README.md           this repository's own page
      profile/README.md   what renders at github.com/vibrantgio
      scripts/            clone-all.sh, inventory.sh, sync-agents.sh
      templates/          AGENTS.md and its per-repo rows in repos.tsv
      .repos/             <- gitignored; the twenty sibling repositories
        mvu/ spectrum/ prism/ pulse/ cadence/ markdown/
        font/ style/ textdraw/ backdrop/ gradient/ circle/
        ivg/ svg/ seen/ csg/ kiwi/ noise/ traer/
        workbench/

This repository is the *parent directory* of the siblings, not one of them.
That is a load-bearing fact: `scripts/sync-agents.sh` renders an `AGENTS.md`
into a named repo under `.repos/` and deliberately cannot reach here, which is
why this file is hand-written and describes a plan rather than a module. Every
sibling's `AGENTS.md` is generated — edit `templates/AGENTS.md` for wording that
applies to all of them, `templates/repos.tsv` for one repo's role and layer
line, and `templates/notes/<repo>.md` for anything longer; the module and build
paragraphs are measured from the clone and are not written by hand.
`scripts/clone-all.sh` populates `.repos/` and pulls what is already there — run
it if the directory is missing or stale. Almost all work happens inside
`.repos/<name>`; the plan and the guide live here at the root.

Those twenty repositories hold **36 Go modules**: nineteen at repository roots,
ten nested in subdirectories whose tags carry the subdirectory as a prefix, and
seven example applications in `workbench`, which has no root module of its own.
`find .repos -name go.mod` is the list — do not hand-maintain it.

**There is no `go.work` here yet, and the modules do not resolve against each
other's working copies.** Each one resolves its siblings from published tags,
so a cross-repo change is invisible to the other side until it is tagged and
pushed. Task B2.1 (goal `G-B2`) is what writes the workspace over all 36
modules, and it comes after G-B1 on purpose: a workspace resolves shared
dependencies at the highest version any member asks for, so joining the modules
while their Gio versions were still spread would have broken the ones on the
older version. G-B1 has aligned them; the workspace is B2.1's job, not an
earlier task's. `.gitignore` lists both `go.work` and `go.work.sum`, so
whatever B2.1 settles, the workspace is an artifact of this tree and no member
repo ever gets a `replace` directive. ADR-006 in `PLAN.md` is the full
argument.

## Four rules you must not discover late

These are `PLAN.md`'s preamble, restated because learning them after the fact
is expensive. `mdplan next` reprints them with every task; read them there too.

**One task, one commit.** Do the steps of exactly one `####` task, then commit
in each repository you touched, with the task heading in the subject line and
the trailer `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`.
Commit on the default branch; feature branches get lost here.

**Green before commit.** In every Go module you touched, `go build ./... && go
test ./...` must pass. Golden-image tests count — when a change legitimately
moves pixels, regenerate the goldens within the same task and say so in the
commit body. Never commit red.

**Never push without asking.** These are public repositories. Commit locally;
pushing is Rene's call, made explicitly, at goal boundaries. Two things in the
plan genuinely cannot finish without a push — the cross-repo tag seams of
ADR-006, and all of G-F3 — and both stop and ask rather than pushing.

**Stop if a task is too big.** Tasks are cut to fit roughly 100K tokens of one
agent run. If one turns out larger, check off what you genuinely finished,
commit it, and report that the task needs splitting, with a proposed split. Do
not push through: a task that silently runs for hours is the failure mode this
plan exists to prevent.

## llms.txt answers a different question

[`llms.txt`](llms.txt) is the organization's canonical agent guide, and it
exists exactly once — here. Its raw URL is

    https://raw.githubusercontent.com/vibrantgio/.github/master/llms.txt

and every repository's `AGENTS.md` links that URL instead of copying the
content, so there is one version to read and one to edit (ADR-004).

**It covers writing Gio code against these libraries, not working this plan.**
Module inventory and current tags, the application skeleton, the MVU loop and
rx semantics, typography, layers, icons, the pitfalls that are not guessable —
read it before you write a line of VibrantGio application code. It says nothing
about tasks, checkboxes, commits or the working tree; for those, this file and
`PLAN.md` are the answer. Editing the guide is itself plan work, so the rules
above still apply to it.
