**`watchlist/` and `mindchat/` are the two exceptions to the sentence above.**
`watchlist/` kept its two images in `testdata/` directly until F5.5, where a
sweep keyed on the `golden/` path silently missed them; moving onto the shared
harness moved them into line, since the harness resolves that path itself and
no longer takes the caller's word for it. `mindchat/` has pixel tests too, but
they diff two renders in memory rather than storing an image, so it links the
harness without appearing in the list. F5.5 deleted the five inlined copies
these apps carried between them — `sitedocs/` alone had two, in adjacent
files.

**The `.gitignore` denies everything by default.** Its first line is `*`, and
what follows re-admits exactly: Markdown at any level, `LICENSE`, `llms.txt`,
`.claude/skills/**`, and the seven application trees minus their compiled
binaries. A file you add anywhere else — a script, a new top-level directory,
a `.json` fixture outside an app — does not show up in `git status` and is
silently not committed. Check with `git check-ignore -v <path>` before
concluding a write failed.

**`llms.txt` here is a signpost, not the guide.** The canonical agent guide
moved to `vibrantgio/.github` in task A1.2 (ADR-004); the three lines left
behind point at its raw URL, which is the URL above. Do not restore content
into it.

**`README.md` and `DESIGN.md` have caught up.** They used to be behind the
code — three example applications described where there were seven, and a
DESIGN.md that predated ADR-001's layering — and this note used to say so.
F2.2 rewrote DESIGN.md around the inverted layering and F2.3 rewrote the
README around all seven applications, so read them as current. Where a
document and the application source still disagree, the source wins and the
document is a bug to file.
