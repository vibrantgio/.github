#!/usr/bin/env bash
#
# Build and test every module with GOWORK=off — the way CI, pkg.go.dev and
# every consumer outside this working tree sees them.
#
# The workspace at ../go.work makes the 39 modules resolve each other from the
# checkout. That is the right thing while developing and the wrong thing to
# trust: it hides version skew, because a module can build against a sibling's
# uncommitted state and still be pinned to a stale tag in its own go.mod. This
# script is what closes that gap. The difference between a green run here and a
# green run under the workspace is exactly the debt ADR-006 manages.
#
# It reports; it does not fix. Failures are expected from B3.3 onward, when the
# alias shims land and a module's go.mod points at a tag that does not exist
# yet. That is the plan working as intended — the seam is paid off at G-F3,
# where the tags are cut and pushed in dependency order.
#
# It also fails on a `replace` directive in any member. A replace committed to
# a public module silently redirects every consumer outside this tree, and it
# is the most tempting wrong way to make this script go green.
#
# Exit status is 0 only when every module passes and no replace exists.

set -uo pipefail

cd "$(dirname "$0")/.."
WS=$(cd .. && pwd) # workspace root: the siblings' parent

modules=$(find $WS -name go.mod | sed 's|/go.mod$||' | sort)
total=$(printf '%s\n' "$modules" | wc -l | tr -d ' ')

status=0

# A replace directive is a correctness failure, not a build failure, so it is
# checked separately and reported first.
replaced=$(command grep -l '^replace\|^[[:space:]]*[^ ]* => ' $(find $WS -name go.mod) 2>/dev/null || true)
if [ -n "$replaced" ]; then
	printf 'REPLACE DIRECTIVES — these break every consumer outside this tree:\n'
	printf '%s\n' "$replaced" | sed 's|^|  |'
	printf '\n'
	status=1
fi

pass=0
failed=""

for m in $modules; do
	name=${m#$WS/}
	if out=$(cd "$m" && GOWORK=off go build ./... 2>&1 && GOWORK=off go test ./... 2>&1); then
		pass=$((pass + 1))
	else
		failed="$failed $name"
		status=1
		printf '=== %s ===\n' "$name"
		# The first few lines carry the reason; the rest is usually the same
		# unresolved import repeated per package.
		printf '%s\n' "$out" | command grep -v '^ok \|no test files' | head -5 | sed 's|^|  |'
		printf '\n'
	fi
done

printf 'GOWORK=off: %d/%d modules pass\n' "$pass" "$total"
[ -n "$failed" ] && printf 'failed:%s\n' "$failed"

exit $status
