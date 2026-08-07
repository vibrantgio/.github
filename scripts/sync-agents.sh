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
#
# fold, and not an awk reimplementation of it: fold counts characters, awk's
# length() counts bytes, and this organization's prose is full of `→` and `—`.
# Swapping one for the other silently reflowed all twenty AGENTS.md files by a
# word or two per em dash. It is not worth twenty commits.
#
# What fold will not do is keep a word intact when the word is longer than the
# width — it breaks mid-identifier and leaves the backticks unbalanced. So no
# generated paragraph may contain a token that long. Put it on its own
# indented line, outside the wrapped text, the way the golden block already
# does with the `go test` command.
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
#
# A second paragraph follows it, added by F5.4, saying what CI does and does
# not check about those images. It is here rather than in templates/AGENTS.md
# because it is only true where goldens exist, and its wording turns on
# whether the clone has a workflow at all — measured, like everything else in
# this function, never typed.
#
# F5.7 gave that paragraph a third state and a settled answer. The question
# F5.4 left open — do the images run on CI? — has been asked of a real run
# now, and the answer was no, everywhere. The follow-up question is the one
# that decided what to write: install the drivers and they *do* run, and then
# nine of pulse's twenty-one images fail, because every golden in the
# organization was recorded on macOS and Linux mesa does not rasterise them
# identically. So the paragraph no longer says "expect the answer to be that
# they skipped" and leaves the reader to wonder whether that is an oversight.
# It says the images are compared on a developer's machine, that this is
# deliberate, and what was measured to make it deliberate.
#
# Which of the three states a clone is in is still measured rather than typed,
# and the measurement is now two questions instead of one: is there a workflow,
# and does it install the runtime GL drivers? The second is read off the
# workflow's *executable* lines only. The driver names appear in that file
# either way — the comment above its build step lists them precisely so nobody
# repeats the experiment blind — so a grep that did not first drop comment
# lines would report every repository as gating on pixels when none of them
# does.
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

	flag=$(goldenflag "$1")
	[ -n "$flag" ] || die "$1 stores golden images but no reachable golden flag declares one — teach goldenflag() its shape"

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
		lead="**Golden images.** Tests in $(count ${#pkgs[@]} package) compare rendered output against PNGs committed under \`testdata/golden/\`. $(harness "$1" "$flag") When a change legitimately moves pixels, regenerate them within the same change, look at what came out, and say so in the commit. From the repository root:"
		trail="    go test ${args[*]} -$flag"
	else
		lead="**Golden images.** Tests in $(count ${#pkgs[@]} 'module directory' 'module directories') — $(dirlist "${pkgs[@]}") — compare rendered output against PNGs committed under \`testdata/golden/\`. $(harness "$1" "$flag") When a change legitimately moves pixels, regenerate them within the same change, look at what came out, and say so in the commit. From inside the directory concerned:"
		trail="    go test . -$flag"
		note="The flag comes last on purpose: \`go test\` cannot tell that an unfamiliar flag is boolean, so anything after it stops being a package argument."
	fi

	# What CI does with those images. A golden test that cannot open a
	# headless window calls t.Skipf, and a skipped test passes, so a green
	# run and a matching image are independent facts — which is what F5.4
	# went looking for, what F5.7 settled, and what this paragraph refuses to
	# let be forgotten.
	local cistate wf=$dir/.github/workflows/ci.yml
	if [ -f "$wf" ] && drivers "$wf"; then
		cistate="**These images are compared on CI, and a red run may mean the pixels moved.** The workflow installs the runtime GL drivers, not only the \`-dev\` headers, so \`headless.NewWindow\` succeeds on the runner and every golden test renders and diffs instead of skipping. The \`$(cijob "$wf")\` job's *Were the golden images compared, or skipped?* step publishes which of the two actually happened, together with a per-image count of any mismatch, as a workflow annotation — and annotations, unlike run logs, need no token: \`GET /repos/vibrantgio/$1/commits/<sha>/check-runs\` returns them. Read it before assuming a failure is in the code, because the organization's goldens were recorded on macOS and a Linux renderer does not reproduce all of them exactly; F5.7 measured that at nine of pulse's twenty-one images."
	elif [ -f "$wf" ]; then
		cistate="**A green CI run does not say these images matched. They are compared only on a developer's machine, and that is deliberate.** The harness answers a failed \`headless.NewWindow\` with \`t.Skipf\`, a skipped test passes, and the runner has no GL driver for it to open — so the pixels and the build status are independent facts. The \`$(cijob "$wf")\` job's *Were the golden images compared, or skipped?* step, added by F5.4, publishes which of the two happened as a workflow annotation, readable without a token at \`GET /repos/vibrantgio/$1/commits/<sha>/check-runs\`; it has answered SKIPPED on every run. F5.7 then measured the alternative rather than leaving it as an open question. Adding the drivers gio's own Linux CI installs — \`libegl1\`, \`libegl-mesa0\`, \`libglx-mesa0\`, \`libgl1-mesa-dri\`, \`mesa-libgallium\`, \`libgbm1\`, \`mesa-vulkan-drivers\` — does work: on pulse the verdict flipped to COMPARED on the next run. Nine of that repository's twenty-one images then failed, 12782 pixels apart, while the three drawn on the CPU still matched exactly. Every golden in the organization was recorded on macOS, so the gate would not be asserting that the images are right, only that Linux mesa and Metal rasterise identically — which they do not, and need not. **So CI gates the build and the tests, never the pixels**, and moving an image is checked where it is regenerated."
	else
		cistate="**Nothing but a developer's machine has ever compared these images.** This repository has no CI workflow, so the stored PNGs are checked only where they are regenerated. That is not the weaker half of an arrangement — it is the same guarantee the four repositories with CI have, for the reason F5.7 measured: a golden test whose \`headless.NewWindow\` fails answers with \`t.Skipf\` and passes, and installing the drivers that would make it render instead turns nine of pulse's twenty-one images red, because the organization's goldens were recorded on macOS and Linux mesa does not reproduce them exactly. CI there gates the build and the tests and not the pixels, by decision. Here there is simply no run to ask."
	fi

	# The deterministic-shaper paragraph, generated rather than typed for the
	# same reason as everything else here: F5.6 wrote it into five AGENTS.md
	# files by hand, byte-identical, and five copies of a paragraph is five
	# chances for one of them to go stale. It belongs to golden tests rather
	# than to any one repository, so it rides with this block and appears in
	# exactly the repositories that store images.
	# Three pieces rather than one paragraph, because the widen-the-collection
	# call is 81 characters and wrap() will not break a word: it goes on its
	# own line, like the go test command above it.
	local shaper widen after
	shaper="**A golden test pins its faces; application code does not.** Every golden and pixel test here builds its shaper with \`tokens.DefaultTypography.DeterministicShaper()\` — the default typography's faces and nothing else, system fonts off, so the stored PNGs are the same on every machine. Applications call \`Shaper()\` instead, which falls back to the platform's own fonts so that text outside Roboto and Roboto Mono still resolves. The two are not interchangeable: a golden written against \`Shaper()\` passes on the machine that wrote it and fails on one with a different font set, which is the failure the split constructor exists to make impossible."
	widen="When a test genuinely needs a glyph the default faces lack, widen the collection rather than reach for the system:"
	after="Then assert that the shaper resolved the rune, rather than storing the result as pixels. A stored image proves the glyph came out somewhere; only the assertion says which face drew it."

	golden=$(wrap "$lead")$'\n\n'"$trail"$'\n\n'$(wrap "$note")$'\n\n'$(wrap "$cistate")$'\n\n'$(wrap "$shaper")$'\n\n'$(wrap "$widen")$'\n\n'"    tokens.DefaultTypography.WithFaces(notosansmono.FontFace()).DeterministicShaper()"$'\n\n'$(wrap "$after")
}

# The sentence about which harness these tests link, for repo $1 with flag $2.
#
# Measured, and the measurement is the point: F5.5 replaced twenty-nine
# inlined harnesses with one, and the five AGENTS.md files that then named the
# sharers by hand each named a different subset. Reading it off the clones
# means the sentence cannot drift when a repository starts or stops storing
# images.
#
# Two shapes, because the repository that *declares* the flag has the opposite
# problem from the ones that link it: prism cannot break itself by adding a
# second declaration, but it can move every stored image in the organization
# with one edit — 185 of them, in four other repositories — and its own test
# run would not show it.
harness() {
	local repo=$1 flag=$2 pkg=github.com/vibrantgio/prism/golden others
	others=$(sharers "$repo")
	if [ -n "$(flagdecl ".repos/$repo")" ]; then
		printf '`%s` is the harness they use, and since F5.5 it is the organization'\''s only one: %s link it too, so a change to it moves every stored image in the organization and not only this repository'\''s. Regenerate all of them before believing a change here is pixel-neutral.' \
			"$pkg" "$others"
	else
		printf 'They render through `%s`, which declares `-%s` and is shared with %s. Do not inline a copy of it, and do not declare a second `-%s`: two registrations of one flag name in a single test binary panic in `flag.Bool` at init, before any test runs.' \
			"$pkg" "$flag" "$others" "$flag"
	fi
}

# The other repositories under .repos/ that link the shared harness: every
# clone but $1 and the one that declares the flag. "`a`, `b` and `c`".
sharers() {
	local out=() d name
	for d in .repos/*/; do
		name=$(basename "$d")
		if [ "$name" = "$1" ]; then continue; fi
		if ! imports "$d" github.com/vibrantgio/prism/golden; then continue; fi
		if [ -n "$(flagdecl "$d")" ]; then continue; fi
		out+=("$name")
	done
	namelist ${out[@]+"${out[@]}"}
}

# "`a`", "`a` and `b`", "`a`, `b` and `c`". dirlist's sibling, for things that
# are not directories and so must not be spelled with a trailing slash.
namelist() {
	local out="" item
	while [ $# -gt 0 ]; do
		item="\`$1\`"
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

# The golden-update flag that clone $1's test binaries accept.
#
# Until F5.5 every repository with goldens declared its own, so grepping the
# clone found it. F5.5 replaced twenty-eight inlined harnesses with a single
# one — github.com/vibrantgio/prism/golden — which declares the flag exactly
# once and reaches every importing package through the linked test binary.
# Three of the four repositories that store images therefore stopped declaring
# anything themselves, and from F5.5 until F5.7 this script died on all three
# with "declares no golden flag": it was still looking only in the clone, and
# so pulse, cadence and markdown could not have their AGENTS.md regenerated at
# all. F5.7 needed to regenerate exactly those, which is how it surfaced.
#
# So when the clone declares nothing, follow its import to the harness that
# does, and read the name out of *that* clone rather than writing the string
# down here. It belongs to prism/golden; a copy of it in this file would be a
# second place to be wrong.
goldenflag() {
	local dir=.repos/$1 name
	name=$(flagdecl "$dir")
	if [ -z "$name" ] && imports "$dir" github.com/vibrantgio/prism/golden; then
		name=$(flagdecl .repos/prism/golden)
	fi
	printf '%s' "$name"
}

# The golden-update flag declared by the Go sources under directory $1, or
# empty. Separate from goldenflag() so the clone and the shared harness can be
# asked the same question with the same code.
flagdecl() {
	find "$1" -name '*.go' -not -path '*/.git/*' -exec awk '
		match($0, /flag\.Bool\("[^"]*"/) {
			name = substr($0, RSTART + 11, RLENGTH - 12)
			if (index(name, "golden")) { print name; exit }
		}' {} + | awk 'NR == 1'
}

# True when any Go source under directory $1 imports package $2.
#
# find -print0 into xargs rather than `grep -r`: a recursive grep here silently
# skips nothing today, but the organization's one repository with no root
# module is walked by the same helpers, and `|| true` is required regardless —
# `set -o pipefail` is in force above and grep exits 1 on no match, which would
# take the whole script down on the first repository that does not import the
# harness.
imports() {
	local hit
	hit=$(find "$1" -name '*.go' -not -path '*/.git/*' -print0 |
		xargs -0 grep -lF "\"$2\"" 2>/dev/null | awk 'NR == 1' || true)
	[ -n "$hit" ]
}

# True when workflow $1 installs the runtime GL drivers, and not merely the
# -dev headers — which is the difference between a golden test that renders
# and one that skips.
#
# Comment lines are dropped before the match, and that is the whole subtlety.
# Every one of these workflows names the driver packages in the comment above
# its build step, deliberately, so that the next person to consider installing
# them reads F5.7's measurement first. A grep over the raw file would find
# those names in all four and report every repository as gating on pixels.
#
# libgl1-mesa-dri is the marker rather than any of the others because it is
# unambiguous: `libegl1-mesa-dev` and `libgles2-mesa-dev` are already in the
# apt line, so anything matching a shorter mesa prefix would hit a header
# package. This name belongs to no -dev package.
drivers() {
	grep -vE '^[[:space:]]*#' "$1" | grep -q 'libgl1-mesa-dri'
}

# The name of the job that runs the tests in workflow $1: the first key under
# `jobs:`. Read rather than assumed, like every other fact in this file — all
# four workflows call it `build` today, and none of them promises to.
cijob() {
	awk '
		/^jobs:/ { in_jobs = 1; next }
		in_jobs && /^[[:space:]]+[A-Za-z0-9_-]+:/ {
			sub(/^[[:space:]]+/, ""); sub(/:.*/, ""); print; exit
		}' "$1"
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
