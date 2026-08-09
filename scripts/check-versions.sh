#!/usr/bin/env bash
# check-versions.sh — llms.txt's version numbers are generated; prove they are.
#
# The canonical guide opens with a table of every module and the tag to require
# it at. Those numbers were typed for eight phases, and by G0C.6 five of the
# eight that matter were wrong — prism by three minors, under a line reading
# "EVERY TAG ABOVE IS RELEASED AND CURRENT". An assistant reading the guide
# would have pinned prism v0.3.1 and received none of phase G. Nothing caught
# it, because a number in prose has nothing to disagree with.
#
# So the numbers are rendered from `git tag` by scripts/sync-versions.sh, and
# this is the gate that says they still are. It re-measures every clone and
# fails if llms.txt would change.
#
# The fix for a failure is never to edit the number. Run
#
#     scripts/sync-versions.sh
#
# after cutting a tag — it is the last step of a release, beside re-running
# scripts/check-agents.sh, whose generated files embed tag versions too.
#
# The rendering is not reimplemented here: `sync-versions.sh -n` already
# measures, renders, diffs and writes nothing, so this runs exactly that and
# judges its report. One renderer, one place for it to be wrong — the same
# arrangement check-agents.sh has with sync-agents.sh.
#
# Usage:
#   scripts/check-versions.sh      # from the .github plan root; no arguments
#
# Exit status: 0 when llms.txt matches the tags; 1 when it has drifted; 2 when
# the tree cannot answer the question.

set -uo pipefail

cd "$(dirname "$0")/.."

SYNC=scripts/sync-versions.sh
[ -x "$SYNC" ] || {
	echo "error: missing or non-executable $SYNC" >&2
	exit 2
}

out=$("$SYNC" -n 2>&1)
rc=$?

case $rc in
0)
	printf '%s\n' "$out" | grep -v '^sync-versions: ' | sed '/^$/d'
	echo "check-versions: OK"
	;;
1)
	printf '%s\n' "$out" | sed 's|^|  |'
	echo
	printf 'llms.txt disagrees with `git tag`. Do not edit the numbers — run:\n\n'
	printf '    scripts/sync-versions.sh\n\n'
	printf 'A version typed into the guide is the defect this check exists for.\n'
	echo "check-versions: FAILED" >&2
	exit 1
	;;
*)
	printf '%s\n' "$out" | sed 's|^|  |'
	echo "check-versions: could not measure" >&2
	exit 2
	;;
esac
