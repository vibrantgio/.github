#!/usr/bin/env bash
#
# Survey the twenty repositories beside .github and print a Markdown table.
#
# This is the check that every count in PLAN.md is measured against, not
# remembered from. Phase A's tasks were cut from a survey taken before the
# clone existed; run this before trusting any of them.
#
# Columns:
#   README   README.md at the repo root
#   AGENTS   AGENTS.md at the repo root
#   doc.go   root = doc.go beside the root go.mod
#            pkg  = no root doc.go, but at least one deeper in the tree
#            -    = no doc.go anywhere in the repo
#   CI       a .github/workflows/ directory anywhere in the repo
#   gio      distinct gioui.org versions across every go.mod in the repo
#   rx       distinct github.com/reactivego/rx versions, likewise
#   mods     number of go.mod files (a repo may be a multi-module repo)
#
# Run scripts/clone-all.sh first; this script only reads.

set -euo pipefail

cd "$(dirname "$0")/.."
WS=$(cd .. && pwd) # workspace root: the siblings' parent

if [ ! -d "$WS/mvu" ]; then
	printf 'no clones beside .github — run scripts/clone-all.sh first\n' >&2
	exit 1
fi

# Distinct versions of $2 across every go.mod under repo $1, comma-joined.
versions() {
	local found
	found=$(find "$1" -name go.mod -not -path '*/.git/*' -exec cat {} + 2>/dev/null |
		sed -E 's/^[[:space:]]*(require[[:space:]]+)?//' |
		awk -v mod="$2" '$1 == mod && $2 ~ /^v/ { print $2 }' |
		sort -u | paste -sd, -)
	printf '%s' "${found:--}"
}

no_readme=0
no_agents=0
no_docgo_root=0
no_docgo_any=0
no_ci=0
total=0

printf '| repo | README | AGENTS | doc.go | CI | gio | rx | mods |\n'
printf '| --- | --- | --- | --- | --- | --- | --- | --- |\n'

for path in "$WS"/*/; do
	repo=$(basename "$path")
	[ "$repo" = .github ] && continue # the plan root is a sibling, not a surveyed repo
	total=$((total + 1))

	if [ -f "$path/README.md" ]; then readme=y; else readme=n; no_readme=$((no_readme + 1)); fi
	if [ -f "$path/AGENTS.md" ]; then agents=y; else agents=n; no_agents=$((no_agents + 1)); fi

	if [ -f "$path/doc.go" ]; then
		docgo=root
	elif [ -n "$(find "$path" -name doc.go -not -path '*/.git/*' -print -quit)" ]; then
		docgo=pkg
		no_docgo_root=$((no_docgo_root + 1))
	else
		docgo='-'
		no_docgo_root=$((no_docgo_root + 1))
		no_docgo_any=$((no_docgo_any + 1))
	fi

	if [ -n "$(find "$path" -type d -path '*/.github/workflows' -not -path '*/.git/*' -print -quit)" ]; then
		ci=y
	else
		ci=n
		no_ci=$((no_ci + 1))
	fi

	mods=$(find "$path" -name go.mod -not -path '*/.git/*' | wc -l | tr -d ' ')

	printf '| %s | %s | %s | %s | %s | %s | %s | %s |\n' \
		"$repo" "$readme" "$agents" "$docgo" "$ci" \
		"$(versions "$path" gioui.org)" \
		"$(versions "$path" github.com/reactivego/rx)" \
		"$mods"
done

printf '\n%d repos: %d without README, %d without AGENTS.md, %d without a root doc.go (%d without a doc.go anywhere), %d without CI.\n' \
	"$total" "$no_readme" "$no_agents" "$no_docgo_root" "$no_docgo_any" "$no_ci"

# The six-module spine is called out on its own because G-A3 asserts a count
# for it: core modules with no doc.go anywhere in the repo.
spine_bare=""
for repo in mvu theme components effects patterns markdown; do
	[ -d "$WS/$repo" ] || continue
	if [ -z "$(find "$WS/$repo" -name doc.go -not -path '*/.git/*' -print -quit)" ]; then
		spine_bare="$spine_bare $repo"
	fi
done
printf 'spine modules with no doc.go anywhere:%s\n' "${spine_bare:- none}"
