#!/usr/bin/env bash
#
# check-gofmt.sh — refuse a Go file gofmt would rewrite.
#
# It walks the siblings' parent, the way check-no-workspace.sh does, so it
# judges every clone in the working tree rather than one repository: a
# misformatted file in a sibling is as much a defect as one here, and no
# single repository's CI can see the others. Another session's .claude
# worktree is pruned — it is a second checkout of the same sources, not this
# tree's.
#
# It reports; it does not fix. `gofmt -w` on the listed files is the fix, in
# the commit of the repository each file belongs to.
#
# Usage (run from the plan root, i.e. from .github, or anywhere):
#   .github/scripts/check-gofmt.sh    exit non-zero on any file gofmt rewrites
#
# Exit status: 0 when gofmt would change nothing, 1 otherwise.

set -uo pipefail

cd "$(dirname "$0")/.."
WS=$(cd .. && pwd) # workspace root: the siblings' parent

files=$(find "$WS" -path "*/.claude/*" -prune -o -path "*/.git/*" -prune -o -name '*.go' -print | sort)
[ -n "$files" ] || { printf 'check-gofmt: no Go file found under %s\n' "$WS" >&2; exit 1; }

# gofmt -l names the files it would change, one per line, and says nothing
# about the rest.
unformatted=$(printf '%s\n' "$files" | xargs gofmt -l)

if [ -n "$unformatted" ]; then
	printf 'GOFMT WOULD REWRITE THESE FILES:\n'
	printf '%s\n' "$unformatted" | sed "s|^$WS/|  |"
	n=$(printf '%s\n' "$unformatted" | wc -l | tr -d ' ')
	printf '\ncheck-gofmt: FAILED (%s file(s))\n' "$n"
	exit 1
fi

echo "check-gofmt: OK"
