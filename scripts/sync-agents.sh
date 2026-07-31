#!/usr/bin/env bash
#
# Render templates/AGENTS.md into named repositories under .repos/.
#
#   scripts/sync-agents.sh [-n] <repo> [<repo>...]
#
# Every repository in the organization carries the same AGENTS.md, in the same
# shape, differing only in what it says about itself (ADR-004, and the doc
# contract under goal G-A2). This script is how that stays true: the wording
# lives in templates/AGENTS.md and is edited once.
#
# Two of the fields are per-repo and come from templates/repos.tsv — the
# opening role sentence and the layer line. Two more are measured from the
# clone itself, never typed: the module paragraph (root module path, nested
# modules and their prefixed tags, or the absence of a root module) and the
# build-and-test paragraph that follows from it. Anything longer goes in an
# optional templates/notes/<repo>.md, appended verbatim.
#
# It writes AGENTS.md and reports a unified diff of what it changed. It never
# stages, commits or pushes: one task, one commit, and the commit is yours to
# make in the repository itself. With -n it writes nothing at all.
#
# This repository's own AGENTS.md is not reachable from here and must not be:
# .github is the parent directory of the clones, not one of them. It is
# hand-written, describes a plan rather than a module, and task A1.6 wrote it.
#
# Run scripts/clone-all.sh first; this script only reads .repos/.

set -euo pipefail

cd "$(dirname "$0")/.."

TEMPLATE=templates/AGENTS.md
TABLE=templates/repos.tsv
NOTES_DIR=templates/notes
WIDTH=76

die() {
	printf 'sync-agents: %s\n' "$1" >&2
	exit 1
}

usage() {
	printf 'usage: scripts/sync-agents.sh [-n] <repo> [<repo>...]\n'
	printf '  -n, --dry-run   render and diff, write nothing\n'
	printf '  -h, --help      this\n'
}

# Wrap a paragraph to $WIDTH columns, without trailing blanks.
wrap() {
	printf '%s\n' "$1" | fold -s -w "$WIDTH" | sed 's/[[:space:]]*$//'
}

# Field $2 of the row for repo $1 in the table.
field() {
	awk -F'\t' -v repo="$1" -v col="$2" \
		'$1 == repo { print $col; found = 1; exit } END { exit !found }' "$TABLE"
}

# The module and build paragraphs for repo $1, measured from its clone.
# Sets the globals `modules` and `build`.
survey() {
	local dir=.repos/$1 root_mod="" dirs=() paths=() list="" path sub i

	if [ -f "$dir/go.mod" ]; then
		root_mod=$(awk '$1 == "module" { print $2; exit }' "$dir/go.mod")
	fi

	while IFS= read -r path; do
		if [ "$path" != "$dir/go.mod" ]; then
			sub=${path#"$dir"/}
			dirs+=("${sub%/go.mod}")
			paths+=("$(awk '$1 == "module" { print $2; exit }' "$path")")
		fi
	done < <(find "$dir" -name go.mod -not -path '*/.git/*' | sort)

	for ((i = 0; i < ${#dirs[@]}; i++)); do
		list="$list, \`${dirs[$i]}/\` (\`${paths[$i]}\`)"
	done
	list=${list#, }

	local cmd='    go build ./... && go test ./...'

	if [ -n "$root_mod" ] && [ ${#dirs[@]} -eq 0 ]; then
		modules="**Module.** \`$root_mod\`, one module at the repository root."
		build="**Build and test.** From the repository root:"$'\n\n'"$cmd"
	elif [ -n "$root_mod" ]; then
		modules="**Modules.** \`$root_mod\` at the repository root, and $(count ${#dirs[@]} 'nested module'): $list. Nested-module tags carry the directory as a prefix — $(tagshape "$1" "${dirs[0]}")."
		build="**Build and test.** From the repository root, and again inside each nested module directory — \`./...\` does not cross a module boundary:"$'\n\n'"$cmd"
	else
		modules="**Modules.** No module at the repository root: this repository is $(count ${#dirs[@]} module) in subdirectories — $list. Each is built, tested and tagged on its own, with tags that carry the directory as a prefix."
		build="**Build and test.** Inside each of those module directories; there is no root module to run it from:"$'\n\n'"$cmd"
	fi
}

# How the tag for nested module directory $2 of repo $1 is spelled, using the
# clone's own newest tag for it so the illustration is a real one. Only if the
# directory has never been tagged does this fall back to a placeholder version,
# which is spelled to be unmistakably a shape rather than a release.
tagshape() {
	local tag
	tag=$(git -C ".repos/$1" tag --list "$2/v*" --sort=-v:refname | awk 'NR == 1')
	if [ -n "$tag" ]; then
		printf '`%s`, not `%s`' "$tag" "${tag##*/}"
	else
		printf '`%s/vX.Y.Z`, not `vX.Y.Z`' "$2"
	fi
}

# Count $1 of noun $2, spelled out: "one nested module", "seven modules".
count() {
	local words=(zero one two three four five six seven eight nine ten)
	local n=$1 word=$1 plural=s
	if [ "$n" -lt ${#words[@]} ]; then word=${words[$n]}; fi
	if [ "$n" -eq 1 ]; then plural=; fi
	printf '%s %s%s' "$word" "$2" "$plural"
}

# The rendered AGENTS.md for repo $1, on stdout.
render() {
	local repo=$1 role layer notes="" line out

	role=$(field "$repo" 3) || die "no row for '$repo' in $TABLE — add one (see its header)"
	layer=$(field "$repo" 2)
	[ -n "$role" ] || die "$TABLE: '$repo' has no role sentence"
	[ -n "$layer" ] || die "$TABLE: '$repo' has no layer line"
	if [ -f "$NOTES_DIR/$repo.md" ]; then notes=$(cat "$NOTES_DIR/$repo.md"); fi

	local modules build
	survey "$repo"

	{
		while IFS= read -r line; do
			if [ "$line" = '{{NOTES}}' ]; then
				if [ -n "$notes" ]; then printf '%s\n' "$notes"; fi
				continue
			fi
			out=$line
			out=${out//'{{REPO}}'/$repo}
			out=${out//'{{ROLE}}'/$role}
			out=${out//'{{LAYER}}'/$layer}
			out=${out//'{{MODULES}}'/$modules}
			out=${out//'{{BUILD}}'/$build}
			case $out in
			*'{{'*) die "unrendered placeholder in $TEMPLATE: $out" ;;
			esac
			if [ "$out" != "$line" ] && [ ${#out} -gt "$WIDTH" ]; then
				wrap "$out"
			else
				printf '%s\n' "$out"
			fi
		done < "$TEMPLATE"
	} | awk 'NF { blanks = 0; while (blanks++ < held) print ""; held = 0; print; next } { held++ }'
}

dry=0
repos=()
while [ $# -gt 0 ]; do
	case $1 in
	-n | --dry-run) dry=1 ;;
	-h | --help)
		usage
		exit 0
		;;
	-*) die "unknown option: $1" ;;
	*) repos+=("$1") ;;
	esac
	shift
done

[ ${#repos[@]} -gt 0 ] || {
	usage >&2
	exit 2
}
[ -f "$TEMPLATE" ] || die "missing $TEMPLATE"
[ -f "$TABLE" ] || die "missing $TABLE"

written=0
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for repo in "${repos[@]}"; do
	dir=.repos/$repo
	[ -d "$dir" ] || die "no clone at $dir — run scripts/clone-all.sh"
	target=$dir/AGENTS.md

	render "$repo" > "$tmp"

	if [ ! -f "$target" ]; then
		printf '\n== %s: AGENTS.md is new — rendered output follows\n\n' "$repo"
		cat "$tmp"
	elif cmp -s "$target" "$tmp"; then
		printf '\n== %s: AGENTS.md is already up to date\n' "$repo"
		continue
	else
		printf '\n== %s: AGENTS.md changes\n\n' "$repo"
		diff -u -L "$target" -L "$target (rendered)" "$target" "$tmp" || true
	fi

	if [ "$dry" -eq 0 ]; then
		cp "$tmp" "$target"
		written=$((written + 1))
	fi
done

if [ "$dry" -eq 1 ]; then
	printf '\ndry run: nothing written.\n'
else
	printf '\n%d file(s) written. Nothing staged or committed — commit in each repository.\n' "$written"
fi
