#!/usr/bin/env bash
#
# Write the measured module versions into llms.txt.
#
#   scripts/sync-versions.sh [-n]
#
# llms.txt is the canonical guide, and the first thing it tells an assistant is
# which version of each module to require. That list was hand-typed for eight
# phases and by G0C.6 it had drifted three minors: it claimed prism v0.3.1
# where the tag was v0.6.0, and was wrong for five of the eight modules that
# matter — under a line reading "EVERY TAG ABOVE IS RELEASED AND CURRENT". An
# assistant following it would `go get prism@v0.3.1` and receive none of phase
# G. Nothing had noticed, because nothing could: a number typed into prose has
# no gate on it.
#
# This is the same lesson, and the same remedy, as scripts/sync-agents.sh — a
# fact `git tag` can answer must not be typed — with one difference that is the
# whole reason a second script exists. sync-agents.sh renders AGENTS.md files
# from templates; llms.txt is prose with embedded numbers, not a render, so it
# needs its own rewriter. The guide lives in the workbench clone (ADR-004,
# amended: workbench showcases building apps with Vibrant Gio, so the guide
# that teaches exactly that lives beside the reference apps), and this script
# reaches across to it.
#
# WHAT IS GENERATED, AND WHAT IS NOT. Only version numbers move. The role
# descriptions beside them, the layer headings and every word of prose are
# hand-written and are left exactly as they are — this script rewrites the
# version token on a line it recognises and nothing else on that line. Four
# shapes are recognised, and they are all of llms.txt's version numbers:
#
#   §Modules and versions   "  components  v0.6.1  components: ..."
#   §Nested modules         "  github.com/vibrantgio/components/gallery  v0.6.1  ..."
#   §Minimal go.mod         "      github.com/vibrantgio/components v0.6.1"
#   the External pins line  "External pins: gioui.org v0.10.2, ... go 1.25.1"
#
# The prose around them was rewritten by G0C.6 so that it names no numbers at
# all: a paragraph that restates the table is a second copy of it, and the
# second copy is the one that goes stale. If you find yourself typing a version
# into llms.txt, that is the defect, not the fix.
#
# THE COLUMNS SURVIVE BECAUSE OF THE NO-DOUBLE-DIGIT RULE, which is a pleasant
# accident worth knowing: every legal tag in this organization is exactly six
# characters, `vX.Y.Z` with one digit each, because the Release protocol rolls
# the component above rather than letting one reach two digits. So a version
# never changes width and the description column never moves. The script pads
# anyway — it adjusts the run of spaces that follows — so that a wider version
# would reflow one line rather than corrupt the table, but it should never have
# to.
#
# WHICH TAG IS "THE" VERSION. The highest tag in the repository under `sort
# -V`, skipping any tag with a two-digit component. Those exist: theme
# carries v0.0.10 through v0.0.15 and effects v0.0.10 through v0.0.12, cut before
# anyone read the protocol, immutable on the remotes and buried by the
# protocol's own remedy. They sort *below* v0.1.0 and so would lose anyway, but
# they are skipped explicitly and counted, because a rule enforced by luck is
# not enforced.
#
# Nested modules are read from the same place: a tag `raster/gio/v0.1.6` in the
# ivg repository is `github.com/vibrantgio/ivg/raster/gio` at v0.1.6. `git tag`
# is the only input; no clone is built, fetched or written to.
#
# workbench has no tags and wants none — the Release protocol's last round is a
# verification round, and the seven applications are installed from the branch
# tip. design is untagged the same way: nothing pins it, so it is consumed
# from the branch tip until something does. A repository with no legal tag is
# reported and skipped, not invented.
#
# With -n it writes nothing and exits non-zero if llms.txt would change, which
# is what scripts/check-versions.sh runs. Nothing is staged, committed or
# pushed.
#
# Exit status: 0 when llms.txt is up to date (or was updated); 1 under -n when
# it would change; 2 when the tree cannot answer the question.

set -uo pipefail

cd "$(dirname "$0")/.."
WS=$(cd .. && pwd) # workspace root: the siblings' parent

ORG=github.com/vibrantgio
GUIDE=../workbench/llms.txt

DRY=0
while [ "$#" -gt 0 ]; do
	case "$1" in
	-n | --dry-run) DRY=1 ;;
	-h | --help)
		sed -n '/^#   scripts\/sync-versions/,/^#$/p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "sync-versions: unknown argument: $1" >&2
		exit 2
		;;
	esac
	shift
done

[ -f "$GUIDE" ] || {
	echo "error: no $GUIDE — clone workbench beside .github first" >&2
	exit 2
}
[ -d "$WS/mvu" ] || {
	echo "error: no clones beside .github — run scripts/clone-all.sh first" >&2
	exit 2
}

VERSIONS=$(mktemp)
NEW=$(mktemp)
trap 'rm -f "$VERSIONS" "$NEW"' EXIT

illegal=0
untagged=""

for dir in "$WS"/*/; do
	repo=$(basename "$dir")
	[ "$repo" = .github ] && continue # the plan root is a sibling, not a surveyed repo
	[ -d "$dir/.git" ] || continue
	# eliasfonts is a local checkout of eliasnaur.com/font, not an org
	# module — its tags and go directive must not enter the guide.
	if [ -f "$dir/go.mod" ] && ! grep -q '^module github.com/vibrantgio/' "$dir/go.mod"; then
		continue
	fi

	# Every tag, split into "<module path under the repo>|<version>" — an empty
	# left side is the root module. A component of two digits or more is
	# skipped: those tags are buried, never resumed (Release protocol).
	tags=$(git -C "$dir" tag 2>/dev/null)
	[ -n "$tags" ] || {
		untagged="$untagged $repo"
		continue
	}

	printf '%s\n' "$tags" | awk -v repo="$repo" '
		{
			v = $0; sub(/^.*\//, "", v)
			if (v !~ /^v[0-9]+\.[0-9]+\.[0-9]+$/) next
			bare = substr(v, 2)
			n = split(bare, c, ".")
			for (i = 1; i <= n; i++) if (length(c[i]) > 1) { print "ILLEGAL\t" repo "\t" $0; next }
			prefix = $0
			if (index($0, "/") > 0) sub(/\/[^\/]*$/, "", prefix); else prefix = ""
			print "TAG\t" (prefix == "" ? repo : repo "/" prefix) "\t" v
		}'
done >"$NEW"

illegal=$(awk -F'\t' '$1 == "ILLEGAL"' "$NEW" | wc -l | tr -d ' ')

# Highest legal tag per module.
awk -F'\t' '$1 == "TAG" { print $2 "\t" $3 }' "$NEW" |
	sort -t"$(printf '\t')" -k1,1 -k2,2V |
	awk -F'\t' '{ v[$1] = $2 } END { for (m in v) print m "\t" v[m] }' |
	sort >"$VERSIONS"

nmod=$(wc -l <"$VERSIONS" | tr -d ' ')
[ "$nmod" -gt 0 ] || {
	echo "error: no legal tags found in any clone" >&2
	exit 2
}

# The external pins, measured across every go.mod rather than typed. If the
# organization is not on one version of something, that disagreement is news
# and the line says so instead of picking a winner.
# Only org modules: eliasfonts (eliasnaur.com/font) is a sibling checkout
# used as a byte source, not a member, and its go 1.16 must not land here.
org_gomods() {
	find "$WS" -name go.mod -not -path '*/.git/*' -print0 |
		xargs -0 awk 'FNR==1 { org = ($1=="module" && $2 ~ /^github\.com\/vibrantgio\//) }
			org { print FILENAME; nextfile }'
}
pin_of() { # module path -> the set of versions required across all go.mod files
	org_gomods |
		xargs awk -v m="$1" '
			$1 == m && $2 ~ /^v/ { print $2 }
			$1 == "require" && $2 == m && $3 ~ /^v/ { print $3 }' |
		sort -u | tr '\n' ' ' | sed 's/ $//'
}
GIO=$(pin_of gioui.org)
RX=$(pin_of github.com/reactivego/rx)
GODIR=$(org_gomods |
	xargs awk '$1 == "go" { print $2 }' | sort -u | tr '\n' ' ' | sed 's/ $//')

awk -v org="$ORG" -v vfile="$VERSIONS" -v gio="$GIO" -v rx="$RX" -v godir="$GODIR" '
	BEGIN {
		FS = "\t"
		while ((getline line < vfile) > 0) {
			split(line, f, "\t")
			ver[f[1]] = f[2]
		}
		close(vfile)
		FS = "\n"
	}

	# Replace the version token in $0, keeping the column that follows it by
	# adding or removing spaces from the gap. head is everything before the
	# version, gap is the run of spaces after it, tail is the rest.
	function put(head, old, gap, tail, want,   d, g) {
		if (want == "" || want == old) return $0
		changed++
		d = length(old) - length(want)
		g = gap
		if (tail == "") return head want
		while (d > 0) { g = g " "; d-- }
		while (d < 0 && length(g) > 1) { g = substr(g, 2); d++ }
		return head want g tail
	}

	# §Modules and versions: "  components  v0.6.1  components: ..."
	match($0, /^  [a-z][a-z0-9]*  +v[0-9]+\.[0-9]+\.[0-9]+ /) {
		name = $0
		sub(/^  /, "", name); sub(/ .*$/, "", name)
		if (name in ver) {
			rest = substr($0, RSTART + RLENGTH - 1)
			hd = substr($0, 1, RSTART + RLENGTH - 2)
			old = hd; sub(/^.*  /, "", old)
			hd = substr(hd, 1, length(hd) - length(old))
			gap = rest; sub(/[^ ].*$/, "", gap)
			tl = substr(rest, length(gap) + 1)
			print put(hd, old, gap, tl, ver[name])
			next
		}
	}

	# §Nested modules: "  github.com/vibrantgio/components/gallery   v0.6.1   ..."
	# §Minimal go.mod:  "      github.com/vibrantgio/components v0.6.1"
	match($0, /^ +github\.com\/vibrantgio\/[a-z0-9\/]+ +v[0-9]+\.[0-9]+\.[0-9]+/) {
		path = $0
		sub(/^ +github\.com\/vibrantgio\//, "", path); sub(/ .*$/, "", path)
		if (path in ver) {
			hd = substr($0, 1, RSTART + RLENGTH - 1)
			old = hd; sub(/^.* /, "", old)
			hd = substr(hd, 1, length(hd) - length(old))
			rest = substr($0, RSTART + RLENGTH)
			gap = rest; sub(/[^ ].*$/, "", gap)
			tl = substr(rest, length(gap) + 1)
			print put(hd, old, gap, tl, ver[path])
			next
		}
	}

	# The external pins line.
	/^External pins: / {
		want = "External pins: gioui.org " gio ", github.com/reactivego/rx " rx ", go " godir
		if ($0 != want) { changed++; print want; next }
	}

	{ print }
	END { exit 0 }
' "$GUIDE" >"$NEW"

if [ -n "$untagged" ]; then
	printf 'no tags (expected for workbench and design — see the Release protocol):%s\n' "$untagged"
fi
if [ "$illegal" -gt 0 ]; then
	printf 'skipped %s tag(s) with a two-digit component — buried, never resumed\n' "$illegal"
fi
printf 'measured %s module version(s) from git tag\n' "$nmod"

if cmp -s "$GUIDE" "$NEW"; then
	echo "sync-versions: $GUIDE is already up to date"
	exit 0
fi

diff -u "$GUIDE" "$NEW" | sed -n '3,$p'

if [ "$DRY" = 1 ]; then
	echo
	echo "dry run: nothing written."
	exit 1
fi

cat "$NEW" >"$GUIDE"
echo
echo "sync-versions: wrote $GUIDE"
