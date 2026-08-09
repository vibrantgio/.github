#!/usr/bin/env bash
# check-agents.sh — every sibling's AGENTS.md is generated; prove it still is.
#
# For each repository in templates/repos.tsv it renders the file that
# scripts/sync-agents.sh would write and compares it with the one committed in
# the clone. Any difference is drift, and it fails.
#
# This check exists because the drift it looks for actually happened, twice
# over, and nothing noticed. Over several phases agents corrected a generated
# AGENTS.md in the clone — the right words, the wrong file — and the templates
# they were rendered from silently went stale behind them. Four of the twenty
# had diverged by the time anyone ran the generator again, three of them with
# the *file* right and the *template* wrong, so the next sync would have
# reverted accurate documentation to false statements. A generated file with
# no gate on it is not generated; it is a file that happens to have been
# written by a script once.
#
# The fix for a failure is therefore always the same, and it is the opposite
# of the intuitive one: edit the template, then regenerate. Never edit the
# clone's AGENTS.md — sync-agents.sh will overwrite it, and until it does, the
# repository and the org's source of truth disagree.
#
#   templates/repos.tsv        the role sentence and the layer line's tier half
#   templates/notes/<repo>.md  anything longer, appended verbatim
#   templates/AGENTS.md        wording shared by all twenty
#
# and the module, build and golden-image paragraphs — and, since G0.1, both
# directions of the layer paragraph's dependency claim — are measured from the
# clones by sync-agents.sh, so those are never edited anywhere: if one of them
# is wrong, the clone is what changed.
#
# G0.1 also closes this check's one blind spot for free. It proves the file
# matches the template, which said nothing at all about whether the template
# was right; nine layer sentences were false while every file here passed. Now
# that the import lists are rendered from scripts/check-layers.sh's own walk of
# the graph, a stale sentence and a stale render are the same failure, and this
# check catches both.
#
# G0.3 asked the obvious follow-up — should this script also diff the rendered
# layer sentence against check-layers.sh's measured edges? No, and the reason
# is written down here so it is not proposed again. The sentence *is* the
# measurement, formatted. Comparing the two compares a string derived from X
# against X: it agrees by construction, and it would agree just as happily if
# the renderer were wrong. A check that cannot fail is not a gate. Making the
# comparison meaningful would mean deriving the graph a second way, which is
# exactly the duplicate walk G0.1 abolished and check-layers.sh's header
# forbids.
#
# The two ways a rendered layer sentence could still be stale are both closed
# already, by construction rather than by a new comparison:
#
#   - A file committed while the graph has since moved. This script re-measures
#     and re-renders on every run and diffs against what is committed, so that
#     is the failure it already reports.
#   - A stale measurement fed to the renderer. sync-agents.sh reads the graph
#     from $VG_LAYER_EDGES when that names a non-empty file — a cache an
#     outside caller could in principle point at anything. This script does not
#     inherit it: it assigns its own mktemp below before exporting, so a
#     poisoned value cannot reach the renders being judged, and the file is
#     deleted on the way out. A bare sync-agents.sh run with a poisoned cache
#     could write a wrong sentence, and then this check fails on the file it
#     wrote.
#
# The rendering is not reimplemented here. `sync-agents.sh -n` already renders
# and diffs and writes nothing, so this script runs exactly that and judges its
# report. One renderer, one place for it to be wrong.
#
# Usage:
#   scripts/check-agents.sh      # from the .github plan root; no arguments
#
# Nothing is written, staged or committed, by this script or by the generator
# it calls.
#
# Exit status: 0 when every repository matches its render; 1 when any drifted
# or failed to render; 2 when the tree is not set up to answer the question.

set -uo pipefail

cd "$(dirname "$0")/.."

TABLE=templates/repos.tsv
SYNC=scripts/sync-agents.sh

[ -f "$TABLE" ] || { echo "error: missing $TABLE" >&2; exit 2; }
[ -x "$SYNC" ] || { echo "error: missing or non-executable $SYNC" >&2; exit 2; }

# Column 1 of every row that is neither a comment nor blank. `listed` is the
# same set on one line: the membership test below is a glob over a padded
# string, and a newline between two names is not the space it looks for.
repos=$(awk -F'\t' '/^#/ { next } NF > 1 { print $1 }' "$TABLE")
[ -n "$repos" ] || { echo "error: no rows in $TABLE" >&2; exit 2; }
listed=$(printf '%s' "$repos" | tr '\n' ' ')

for name in $repos; do
	if [ ! -d ".repos/$name" ]; then
		echo "error: no clone at .repos/$name — run scripts/clone-all.sh first" >&2
		exit 2
	fi
done

# One measurement of the dependency graph for all twenty renders. sync-agents.sh
# needs the whole graph to render either direction of a layer sentence, and it
# walks all 36 modules with `go list` to get it — twenty times over, once per
# invocation below, if left alone. The file is scratch, created here and
# deleted on the way out, so the answer can never outlive the tree it was
# measured from; a cached graph that did would be a typed fact again.
VG_LAYER_EDGES=$(mktemp)
export VG_LAYER_EDGES
trap 'rm -f "$VG_LAYER_EDGES"' EXIT

total=0
pass=0
failed=""

for name in $repos; do
	total=$((total + 1))

	if ! out=$("$SYNC" -n "$name" 2>&1); then
		# sync-agents.sh died: a missing row, an unrendered placeholder, a
		# repository that stores goldens the generator cannot describe. Not
		# drift, but the file cannot be vouched for either.
		echo "$out" | sed 's|^|  |'
		echo "FAIL $name: could not be rendered"
		failed="$failed $name"
		continue
	fi

	case $out in
	*"$name: AGENTS.md is already up to date"*)
		echo "ok $name"
		pass=$((pass + 1))
		;;
	*)
		# Everything the generator printed except its own dry-run footer:
		# the header line and the unified diff, or the whole rendered file
		# when the clone has no AGENTS.md at all. The awk holds blank lines
		# until a non-blank follows and drops them before the first one, so
		# the block neither opens nor closes on the blanks the generator's
		# own header and footer leave behind.
		printf '%s\n' "$out" | grep -v '^dry run: nothing written\.$' |
			awk 'NF { if (seen) while (n-- > 0) print ""; n = 0; seen = 1; print; next } { n++ }' |
			sed 's|^|  |'
		echo "FAIL $name: AGENTS.md differs from what the templates render"
		failed="$failed $name"
		;;
	esac
done

# A clone with no row in the table is never rendered and so is never judged.
# The table's own header calls that an error rather than a default, and this
# is where that becomes true.
unlisted=""
for dir in .repos/*/; do
	name=$(basename "$dir")
	case " $listed " in
	*" $name "*) ;;
	*) unlisted="$unlisted $name" ;;
	esac
done
if [ -n "$unlisted" ]; then
	printf 'UNLISTED — cloned but absent from %s, so nothing renders them:%s\n' \
		"$TABLE" "$unlisted"
	printf '  Add a row (see the table'\''s header) rather than leaving the AGENTS.md hand-written.\n'
fi

printf '\ncheck-agents: %d/%d repositories match their render\n' "$pass" "$total"

if [ -n "$failed" ] || [ -n "$unlisted" ]; then
	[ -n "$failed" ] && printf 'failed:%s\n' "$failed"
	printf '\nThe fix is in templates/, not in the clone. Edit templates/repos.tsv\n'
	printf '(role and layer), templates/notes/<repo>.md (anything longer) or\n'
	printf 'templates/AGENTS.md (wording shared by all twenty), then regenerate:\n\n'
	printf '    scripts/sync-agents.sh%s\n\n' "${failed:- <repo>}"
	printf 'Editing the clone'\''s AGENTS.md instead is what this check exists to catch:\n'
	printf 'the next sync reverts it, and the org loses whatever it said.\n'
	echo "check-agents: FAILED" >&2
	exit 1
fi

echo "check-agents: OK"
