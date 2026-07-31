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

**`README.md` and `DESIGN.md` are behind the code.** The README still
describes three example applications where there are seven, and DESIGN.md
predates the layering ADR-001 sets out. F2.2 and F2.3 rewrite them; until
then, trust the application source over either document.
