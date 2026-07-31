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
# opening role sentence and the layer line. Three more are measured from the
# clone itself, never typed: the module paragraph (root module path, nested
# modules and their prefixed tags, or the absence of a root module), the
# build-and-test paragraph that follows from it, and the golden-image
# paragraph — which packages keep stored PNGs, which flag regenerates them,
# and where that flag has to go on the command line. Repositories without
# goldens get no such paragraph. Anything longer goes in an optional
# templates/notes/<repo>.md, appended verbatim.
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

# The golden-image paragraph for repo $1, measured from its clone. Empty when
# the repository stores no golden images at all. Sets the global `golden`.
#
# Golden-image regeneration is gated behind a flag in every repository that
# has goldens, and the flag is invisible: nothing in a clone documents it, so
# an agent working inside one repository cannot make a legitimate pixel change
# green. Worse, the incantation the flag's own doc comments give — `go test
# -flag ./...` — does not work. `go test` cannot know that an unfamiliar flag
# is boolean, so it stops treating the rest of the line as package arguments:
# `./...` is handed to the test binary, and the package in the current
# directory is tested instead. The flag has to come *after* the packages.
#
# Whether the packages can then be spelled `./...` depends on the repository,
# so bare() measures it: a test binary that declares no goldens rejects the
# flag outright, so `./...` works only where every test package has goldens.
# Elsewhere they are named one by one. This paragraph is the only place in the
# organization where any of that is written down.
goldens() {
	local dir=.repos/$1 pkgs=() args=() flag="" path pkg i

	while IFS= read -r path; do
		pkg=${path%/testdata/golden}
		pkg=${pkg#"$dir"}
		pkg=${pkg#/}
		pkgs+=("${pkg:-.}")
	done < <(find "$dir" -type d -path '*/testdata/golden' -not -path '*/.git/*' | sort)

	golden=""
	[ ${#pkgs[@]} -gt 0 ] || return 0

	flag=$(find "$dir" -name '*.go' -not -path '*/.git/*' -exec awk '
		match($0, /flag\.Bool\("[^"]*"/) {
			name = substr($0, RSTART + 11, RLENGTH - 12)
			if (index(name, "golden")) { print name; exit }
		}' {} + | awk 'NR == 1')
	[ -n "$flag" ] || die "$1 stores golden images but declares no golden flag — teach goldens() its shape"

	local lead trail note
	if [ -f "$dir/go.mod" ]; then
		if bare "$dir" "${pkgs[@]}"; then
			args=("./...")
			note="The flag comes last on purpose: \`go test\` cannot tell that an unfamiliar flag is boolean, so anything after it stops being a package argument. \`go test -$flag ./...\` tests whatever package the repository root holds, not \`./...\`."
		else
			for ((i = 0; i < ${#pkgs[@]}; i++)); do
				if [ "${pkgs[$i]}" = "." ]; then args+=("."); else args+=("./${pkgs[$i]}"); fi
			done
			note="Both halves of that line matter. \`go test\` cannot tell that an unfamiliar flag is boolean, so a flag placed before the packages swallows them: \`go test -$flag ./...\` tests whatever package the repository root holds, not \`./...\`. And \`./...\` cannot stand in for the list — this module has test packages that store no goldens, and a test binary rejects a flag it never declared."
		fi
		lead="**Golden images.** Tests in $(count ${#pkgs[@]} package) compare rendered output against PNGs committed under \`testdata/golden/\`. When a change legitimately moves pixels, regenerate them within the same change, look at what came out, and say so in the commit. From the repository root:"
		trail="    go test ${args[*]} -$flag"
	else
		lead="**Golden images.** Tests in $(count ${#pkgs[@]} 'module directory' 'module directories') — $(dirlist "${pkgs[@]}") — compare rendered output against PNGs committed under \`testdata/golden/\`. When a change legitimately moves pixels, regenerate them within the same change, look at what came out, and say so in the commit. From inside the directory concerned:"
		trail="    go test . -$flag"
		note="The flag comes last on purpose: \`go test\` cannot tell that an unfamiliar flag is boolean, so anything after it stops being a package argument."
	fi

	golden=$(wrap "$lead")$'\n\n'"$trail"$'\n\n'$(wrap "$note")
}

# True when every test package of the root module in clone $1 stores goldens,
# so `./...` can carry the flag. $2... are the golden package directories.
# Test files inside a nested module do not count: `./...` never reaches them.
bare() {
	local dir=$1 pkgs=() nested=() path pkg m hit
	shift
	pkgs=("$@")

	while IFS= read -r path; do
		[ "$path" = "$dir/go.mod" ] || nested+=("$(dirname "${path#"$dir"/}")")
	done < <(find "$dir" -name go.mod -not -path '*/.git/*')

	while IFS= read -r path; do
		pkg=$(dirname "$path")
		pkg=${pkg#"$dir"}
		pkg=${pkg#/}
		pkg=${pkg:-.}
		hit=0
		for m in ${nested[@]+"${nested[@]}"}; do
			case $pkg in "$m" | "$m"/*) hit=1 ;; esac
		done
		for m in "${pkgs[@]}"; do
			[ "$m" = "$pkg" ] && hit=1
		done
		[ "$hit" -eq 1 ] || return 1
	done < <(find "$dir" -name '*_test.go' -not -path '*/.git/*')

	return 0
}

# "`a/`", "`a/` and `b/`", "`a/`, `b/` and `c/`".
dirlist() {
	local out="" item
	while [ $# -gt 0 ]; do
		item="\`$1/\`"
		shift
		if [ -z "$out" ]; then
			out=$item
		elif [ $# -eq 0 ]; then
			out="$out and $item"
		else
			out="$out, $item"
		fi
	done
	printf '%s' "$out"
}

# Count $1 of noun $2, spelled out: "one nested module", "seven modules".
# $3 overrides the plural where adding an s is wrong.
count() {
	local words=(zero one two three four five six seven eight nine ten)
	local n=$1 word=$1
	if [ "$n" -lt ${#words[@]} ]; then word=${words[$n]}; fi
	if [ "$n" -eq 1 ]; then
		printf '%s %s' "$word" "$2"
	else
		printf '%s %s' "$word" "${3:-$2s}"
	fi
}

# The rendered AGENTS.md for repo $1, on stdout.
render() {
	local repo=$1 role layer notes="" line out block n
	local -a lines=()

	role=$(field "$repo" 3) || die "no row for '$repo' in $TABLE — add one (see its header)"
	layer=$(field "$repo" 2)
	[ -n "$role" ] || die "$TABLE: '$repo' has no role sentence"
	[ -n "$layer" ] || die "$TABLE: '$repo' has no layer line"
	if [ -f "$NOTES_DIR/$repo.md" ]; then notes=$(cat "$NOTES_DIR/$repo.md"); fi

	local modules build golden
	survey "$repo"
	goldens "$repo"

	while IFS= read -r line; do
		# {{GOLDEN}} and {{NOTES}} are optional blocks, already wrapped —
		# emitted verbatim, and when empty they take the blank line that
		# introduced them with them.
		case $line in
		'{{GOLDEN}}' | '{{NOTES}}')
			if [ "$line" = '{{GOLDEN}}' ]; then block=$golden; else block=$notes; fi
			if [ -n "$block" ]; then
				lines+=("$block")
			else
				n=${#lines[@]}
				if [ "$n" -gt 0 ] && [ -z "${lines[$((n - 1))]}" ]; then
					unset "lines[$((n - 1))]"
				fi
			fi
			continue
			;;
		esac
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
			lines+=("$(wrap "$out")")
		else
			lines+=("$out")
		fi
	done < "$TEMPLATE"

	printf '%s\n' "${lines[@]}" |
		awk 'NF { blanks = 0; while (blanks++ < held) print ""; held = 0; print; next } { held++ }'
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
