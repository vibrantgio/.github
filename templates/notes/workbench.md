**`mindchat/` is the exception to the sentence above.** It has pixel tests
too, but they diff two renders in memory rather than storing an image, so it
links the harness without appearing in the list. No application inlines a
copy of that harness any more — `sitedocs/` alone once carried two, in
adjacent files.

**The `.gitignore` denies everything by default.** Its first line is `*`, and
what follows re-admits exactly: Markdown at any level, `LICENSE`,
`.claude/skills/**`, and the seven application trees minus their compiled
binaries. A file you add anywhere else — a script, a new top-level directory,
a `.json` fixture outside an app — does not show up in `git status` and is
silently not committed. Check with `git check-ignore -v <path>` before
concluding a write failed.

**There is no `llms.txt` here.** The canonical agent guide lives once, in
`vibrantgio/.github`, at the raw URL above; this repository links it and
keeps neither a copy nor a pointer file. Do not add one back.

**Development planning does not happen here.** The organization's plan lives
once, in `vibrantgio/.github`. The finished plan this repository was built
against, the performance baselines it measured and the feedback notes it
filed were removed once that became true; their content is in this
repository's git log and nowhere else. The architecture rationale
`DESIGN.md` left earlier, for `vibrantgio/design`, together with its
archived first edition `DESIGN-v1.md`; that pre-move history stays in this
log too.

**`README.md` lists every application in the repository.** It gains a
section when one is added and loses one when an application is removed, so
read it as current and keep it that way. Where a document and the
application source disagree, the source wins and the document is a bug to
file.

**Arbiters are created in each application's layer function, and that is the
composition root that matters.** ADR-008 gave `patterns`'s popover, tooltip and
modal a plain `Arbiter` passed through `Props`, and the value *is* the scope —
one set per window. `theme/window.Render` calls the build function once per
window, and `feeds` and `mindchat` each compose every arbitrable widget they
own inside exactly one layer built there (`feedsShellLayer`, `ContentLayer`),
so the arbiters are made in those function bodies and threaded down through
every builder call site below them. A second arbitrable layer would have to
take them as parameters, because it would be composed beside this one rather
than within it. The other five applications compose none of these components
and have none.

**Toasts are model state here, not a side channel.** `toast.Queue` lives in
the `feeds` and `vaultview` models, `toast.Requested`/`toast.Expired` are
reduced in `Update`, and every call site raises one with
`toast.Notify(gtx, ...)` on the same `gtx.Ops` its neighbouring application
message already uses. A toast is therefore visible to a test that drives the
app through messages, which it was not before.
