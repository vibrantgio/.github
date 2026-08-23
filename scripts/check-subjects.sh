#!/usr/bin/env bash
# check-subjects.sh — ADR-008's gate: no bare rx.Subject outside its homes.
#
# ADR-008 sorts cross-widget state into three destinations — a message into the
# model, a plain value owned by the frame goroutine, or a genuine stream — and
# rules that a bare `rx.Subject` is none of them. This script is the part of
# that decision a reader cannot forget to apply. It scans every Go file under
# the sibling clones (or the directories named on the command line), finds every use of
# the `rx.Subject` constructor, and fails on any that is not in a sanctioned
# home.
#
# Two measured defects are what the rule is about, both written up in
# github.com/vibrantgio/mvu/stream's package doc: rx.Subject leaks a
# subscription slot for the life of the process, so the 33rd subscriber dies
# with "out of subject subscriptions"; and a departed subscriber's frozen
# cursor pins the producer, which on the Gio frame goroutine is a hung
# application. rx.Behavior — which mvu/stream.Value wraps — has neither.
#
# WHAT THIS GATE CANNOT SEE, and the reason it is written here rather than
# pretended away. G0C.2b took the census the hard way and found four exported
# observables in cadence — popover.Arbitration, tooltip.Arbitration,
# modal.Stack and their snapshots — that nothing in twenty-one repositories
# subscribed to. Not one of them would have tripped the rx.Subject rule: every
# one went through prism/coordination.Subject, the wrapper that was approved at
# the time, and every one was published to on a real schedule. What was wrong
# with them was that nobody was listening, and no grep can see an absence of
# readers. Three measurements say the deadness itself is not checkable here at
# any price worth paying:
#
#   - The organization is not the world. These are public modules, so "no
#     consumer in twenty-one repositories" is not "no consumer" — and every
#     newly exported observable begins with no in-org reader, which makes the
#     signal loudest exactly when it is least informative.
#   - The population is almost entirely legitimate. 84 non-test declarations in
#     the organization name rx.Observable, and all but a handful are either the
#     theme parameter every component takes (`th rx.Observable[theme.Theme]`)
#     or the widget observable a component *is*. A check whose allowlist has to
#     name them all is a typed census, which is the defect this whole goal
#     removed.
#   - It cannot even be spelled without a parser. `Arbitration
#     rx.Observable[ArbitrationSnapshot]` inside a `var (` block and `Open
#     rx.Observable[bool]` inside a Props struct are the same line of text; the
#     first was one of the four dead buses and the second is components and patterns'
#     entire component contract.
#
# So the deadness check is not attempted. The first question to ask about an
# exported observable is not what publishes to it but who reads it, and that
# question is a reviewer's; llms.txt says so under "Pitfalls when working on
# the org's repos".
#
# WHAT IS CHECKABLE, AND IS CHECKED: the *shape* all four of them arrived in.
# Every one was an exported package-level `var` of observable type, assigned
# from an `init()` and owned by nobody — a bus at process scope in a toolkit
# whose windows are the real scope. That is decidable from the text (a `var`
# at column zero is not a struct field) and it is the third of ADR-008's own
# arguments: the value is the scope, so an observable nobody can be handed is
# an observable nobody can own. It reads zero across the organization as of
# G0C.6, which is what makes it a gate rather than a chore: it starts green and
# fires when the shape returns. It is NOT the deadness check and must not be
# read as one — an observable passed properly through Props with no subscriber
# is just as dead, and only a reader will notice.
#
# ---------------------------------------------------------------------------
# What counts as a use
#
# The scan is lexical but not naive. Comments and string literals are removed
# by a small Go lexer in the awk program below — a state machine over line
# comments, block comments, interpreted strings, raw strings and rune literals
# — because the organization's Go files mention `rx.Subject` in prose 40-odd
# times and would otherwise report a census of its own history. The import is
# resolved too: the local name for github.com/reactivego/rx is read out of each
# file's own import block, so an aliased import is still caught and a file that
# does not import rx at all is never searched. A dot import of rx defeats the
# resolution and is reported as a failure in its own right rather than silently
# passing.
#
# TEST FILES ARE COUNTED, NOT JUDGED, and that is a decision rather than an
# oversight. At the time of writing all 21 remaining uses in the organization
# are in _test.go harnesses, every one of them standing in for a model
# observable a test needs to drive by hand. None of the three defects can reach
# out of one: the slot leak is bounded by the test binary, the producer that
# could be pinned is the test goroutine, and the 50 µs delivery quantum is
# nobody's frame budget. Converting them would buy nothing and would make the
# gate's first act a 21-file diff nobody asked for. So the count is printed on
# every run — an occurrence added to a test is visible immediately — and
# `--tests` lists them. It is deliberately not pinned to a constant: a number
# in a file is a second copy of a measurable fact, which is the defect the goal
# this script comes from spent six tasks removing.
#
# ---------------------------------------------------------------------------
# The allowlist, and why it has one entry rather than two
#
# ADR-008 names two sanctioned homes for the primitive. Only one of them needs
# an entry here, and the difference is the finding G0C.5 made:
#
#   components/coordination  — allowed, for as long as the package exists. It is
#       deprecated in place (byte-for-byte, not forwarded: a forwarder to
#       mvu/stream.Value would compile everywhere and silently change delivery
#       policy, subscriber ceiling and buffering). Its removal is scheduled for
#       components' v1.0.0 alongside ADR-001's and ADR-003's alias shims, and when
#       it goes this entry goes with it — the stale-entry note below is what
#       says so.
#
#   mvu/stream               — NOT here, because it does not need to be. It is the
#       organization's one sanctioned observable and it contains no bare
#       rx.Subject at all: G0C.5's measurement was that the primitive did not
#       need writing, it needed choosing, and rx.Behavior was already what the
#       job wanted. Listing a home that uses nothing would be an allowlist
#       entry that can never go stale, which is an entry that can never be
#       wrong and therefore says nothing. If mvu/stream ever does need a bare
#       Subject, add it here and the reason with it.
#
# Entries are package paths relative to github.com/vibrantgio, so
# `components/coordination` covers the package and nothing above or beside it.
#
# ---------------------------------------------------------------------------
# Usage:
#   scripts/check-subjects.sh            # from the .github plan root: every
#                                        # module beside .github
#   scripts/check-subjects.sh DIR [DIR..]  # check specific trees
#   scripts/check-subjects.sh --tests    # also list the _test.go occurrences
#
# The rule lives in this one file. Run it from the plan root. There is no
# per-repo CI.
#
# Exit status: 0 when no non-test file outside the allowlist uses rx.Subject
# and no package exports a package-level observable; 1 when one does, or when a
# file dot-imports rx; 2 when the tree is not set up to answer the question.
#
# Verified against the defect rather than against an opinion: run over cadence
# at dab2904~1 — the tree before this goal started — the second rule reports
# all four of the buses ADR-008 removed (popover.Arbitration,
# tooltip.Arbitration, modal.Stack, toast.Notifications) and nothing else.

set -uo pipefail

ORG=github.com/vibrantgio

# Package paths, relative to $ORG, that may use a bare rx.Subject. See the
# header before adding one: an entry needs a reason and a way to go stale.
ALLOWED_PACKAGES="components/coordination"

LIST_TESTS=0
ARGS=""
while [ "$#" -gt 0 ]; do
	case "$1" in
	-t | --tests) LIST_TESTS=1 ;;
	-h | --help)
		sed -n '/^# Usage:/,/^#$/p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	-*)
		echo "check-subjects: unknown option: $1" >&2
		exit 2
		;;
	*) ARGS="$ARGS $1" ;;
	esac
	shift
done

if [ -n "$ARGS" ]; then
	ROOTS=$ARGS
else
	root=$(cd "$(dirname "$0")/../.." && pwd) # workspace root: the siblings' parent
	ROOTS="$root"
	if [ ! -d "$ROOTS" ]; then
		echo "error: no $ROOTS — run scripts/clone-all.sh first" >&2
		exit 2
	fi
fi

for r in $ROOTS; do
	[ -d "$r" ] || {
		echo "error: not a directory: $r" >&2
		exit 2
	}
done

# The module table: every go.mod under the roots, as "<dir>\t<module path>".
# A file belongs to the longest directory prefix in this table, which is how a
# nested module's files are attributed to the nested module and not to its
# parent — the same boundary check-layers.sh draws with `go list`.
MODTAB=$(mktemp)
trap 'rm -f "$MODTAB"' EXIT
for r in $ROOTS; do
	find "$r" -name go.mod -not -path '*/.git/*' 2>/dev/null
done | sort -u | while read -r gomod; do
	dir=${gomod%/go.mod}
	mod=$(sed -n 's/^module[[:space:]]*//p' "$gomod" | head -1)
	[ -n "$mod" ] && printf '%s\t%s\n' "$dir" "$mod"
done >"$MODTAB"

if [ ! -s "$MODTAB" ]; then
	echo "error: no go.mod found under:$ROOTS" >&2
	exit 2
fi

FILES=$(for r in $ROOTS; do
	find "$r" -name '*.go' -not -path '*/.git/*' 2>/dev/null
done | sort -u)

if [ -z "$FILES" ]; then
	echo "error: no Go files found under:$ROOTS" >&2
	exit 2
fi

nfiles=$(printf '%s\n' "$FILES" | wc -l | tr -d ' ')
nmods=$(wc -l <"$MODTAB" | tr -d ' ')

# One awk pass over every file. It emits one record per use:
#
#   <kind>\t<package>\t<file>:<line>\t<source line>
#
# kind is one of code/test/dot, package is the path relative to $ORG.
REPORT=$(printf '%s\n' "$FILES" | tr '\n' '\0' | xargs -0 awk \
	-v org="$ORG" -v modtab="$MODTAB" '
	# --- Go lexer, enough of one: return the line with comments and literal
	# --- contents removed. inblock and inraw carry across lines, which is why
	# --- they are file-scoped and reset at FNR == 1.
	function strip(s,   out, i, n, c, d) {
		out = ""; n = length(s); i = 1
		while (i <= n) {
			c = substr(s, i, 1); d = substr(s, i, 2)
			if (inraw)   { if (c == "`") inraw = 0; i++; continue }
			if (inblock) { if (d == "*/") { inblock = 0; i += 2 } else i++; continue }
			if (d == "//") break
			if (d == "/*") { inblock = 1; i += 2; continue }
			if (c == "`")  { inraw = 1; i++; continue }
			if (c == "\"" || c == "\x27") {
				q = c; i++
				while (i <= n) {
					c = substr(s, i, 1)
					if (c == "\\") { i += 2; continue }
					i++
					if (c == q) break
				}
				out = out q q
				continue
			}
			out = out c; i++
		}
		return out
	}

	BEGIN {
		FS = "\t"
		while ((getline line < modtab) > 0) {
			split(line, f, "\t")
			nmod++; mdir[nmod] = f[1]; mpath[nmod] = f[2]
		}
		close(modtab)
		FS = "\n"
	}

	# The package this file belongs to, relative to org: longest module
	# directory that is a prefix of the file path, plus the directory the file
	# sits in inside it.
	function pkgof(path,   i, best, bi, dir, rel) {
		best = ""; bi = 0
		for (i = 1; i <= nmod; i++) {
			if (index(path, mdir[i] "/") == 1 && length(mdir[i]) > length(best)) {
				best = mdir[i]; bi = i
			}
		}
		if (bi == 0) return "?"
		rel = substr(path, length(best) + 2)
		dir = rel
		if (dir ~ /\//) sub(/\/[^\/]*$/, "", dir); else dir = ""
		p = mpath[bi]
		sub("^" org "/", "", p)
		return (dir == "") ? p : p "/" dir
	}

	FNR == 1 {
		inblock = 0; inraw = 0; rxname = ""; dotrx = 0; invar = 0
		pkg = pkgof(FILENAME)
		istest = (FILENAME ~ /_test\.go$/)
	}

	{
		wasblock = inblock; wasraw = inraw
		line = strip($0)

		# Resolve the local name for rx from the import block. The pattern is
		# anchored on the whole raw line, so a commented-out or quoted import
		# cannot match it: a comment line begins with the slashes. A comment
		# TRAILING the spec is allowed — anchoring to bare end-of-line would
		# leave the import unresolved and silently skip the whole file, the
		# one failure mode a gate must not have.
		if (!wasblock && !wasraw && rxname == "" && !dotrx &&
		    $0 ~ /^[ \t]*(import[ \t]+)?([A-Za-z_][A-Za-z0-9_]*[ \t]+|\.[ \t]+|_[ \t]+)?"github\.com\/reactivego\/rx"[ \t]*(\/\/.*|\/\*.*\*\/[ \t]*)?$/) {
			spec = $0
			sub(/[ \t]*"github\.com\/reactivego\/rx"[ \t]*(\/\/.*|\/\*.*\*\/[ \t]*)?$/, "", spec)
			sub(/^[ \t]*/, "", spec)
			sub(/^import([ \t]+|$)/, "", spec)
			sub(/[ \t]+$/, "", spec)
			if (spec == ".") { dotrx = 1; printf "dot\t%s\t%s:%d\t%s\n", pkg, FILENAME, FNR, "dot import of rx" }
			else if (spec == "_") { rxname = "" }
			else if (spec == "") { rxname = "rx" }
			else { rxname = spec }
			next
		}

		# Package-level var declarations. Column zero is the whole test: gofmt
		# indents a struct field and never indents a top-level declaration, so
		# a var block opened here cannot be a type. A var whose observable type
		# is inferred rather than written (`var X = something`) is invisible to
		# this, which is the price of not running a type checker.
		if (line ~ /^var \(/) { invar = 1 }
		else if (invar && line ~ /^\)/) { invar = 0 }
		if (!istest && rxname != "" &&
		    ((invar && line ~ ("^\t[A-Z][A-Za-z0-9_]*[ \t]+" rxname "\\.(Observable|Observer)\\[")) ||
		     (line ~ ("^var [A-Z][A-Za-z0-9_]*[ \t]+" rxname "\\.(Observable|Observer)\\[")))) {
			src = $0
			sub(/^[ \t]+/, "", src)
			printf "global\t%s\t%s:%d\t%s\n", pkg, FILENAME, FNR, src
		}

		if (rxname == "") next
		if (index(line, rxname ".Subject") == 0) next
		src = $0
		sub(/^[ \t]+/, "", src)
		printf "%s\t%s\t%s:%d\t%s\n", (istest ? "test" : "code"), pkg, FILENAME, FNR, src
	}
')

status=0

printf 'check-subjects: %s Go files in %s modules\n' "$nfiles" "$nmods"
printf 'allowlist: %s\n' "$ALLOWED_PACKAGES"

dots=$(printf '%s' "$REPORT" | awk -F'\t' '$1 == "dot"')
if [ -n "$dots" ]; then
	printf '\nDOT IMPORT OF rx — the gate cannot resolve Subject through one:\n'
	printf '%s\n' "$dots" | awk -F'\t' '{ printf "  %s (%s)\n", $3, $2 }'
	status=1
fi

bad=""
while IFS="$(printf '\t')" read -r kind pkg where src; do
	[ "$kind" = code ] || continue
	skip=0
	for p in $ALLOWED_PACKAGES; do
		[ "$pkg" = "$p" ] && skip=1
	done
	[ "$skip" = 1 ] && continue
	bad="$bad$where"$'\t'"$pkg"$'\t'"$src"$'\n'
done <<EOF
$REPORT
EOF

if [ -n "$bad" ]; then
	printf '\nBARE rx.Subject outside its sanctioned home (ADR-008):\n'
	printf '%s' "$bad" | while IFS="$(printf '\t')" read -r where pkg src; do
		[ -n "$where" ] || continue
		printf '  %s\n      package %s\n      %s\n' "$where" "$pkg" "$src"
	done
	printf '\n  The three destinations, and which one this is:\n'
	printf '    1. anything outside the frame needs to know  -> a message, reduced into the model\n'
	printf '    2. only this frame needs to know             -> a plain value the frame owns\n'
	printf '    3. state several consumers watch             -> %s/mvu/stream.Value\n' "$ORG"
	status=1
fi

globals=$(printf '%s' "$REPORT" | awk -F'\t' '$1 == "global"')
if [ -n "$globals" ]; then
	printf '\nEXPORTED PACKAGE-LEVEL OBSERVABLE — a bus at process scope (ADR-008):\n'
	printf '%s\n' "$globals" | awk -F'\t' '{ printf "  %s\n      package %s\n      %s\n", $3, $2, $4 }'
	printf '\n  All four of the buses ADR-008 removed had this shape, and all four\n'
	printf '  turned out to have no subscriber at all. The gate cannot check that\n'
	printf '  second part — go and find the readers yourself — but it can say that\n'
	printf '  an observable nobody can be handed is an observable nobody owns.\n'
	printf '  Create it in the composition root and pass it through Props instead.\n'
	status=1
fi

# Allowlist staleness, in check-layers.sh's spirit: an entry that matches
# nothing should be deleted so the use it permits fails on its return. Only an
# entry whose repository was actually scanned can be judged — in the per-repo
# CI mode the other nineteen are simply not present, which is not staleness.
SCANNED_REPOS=$(awk -F'\t' -v org="$ORG/" '{ p = $2; sub("^" org, "", p); sub("/.*$", "", p); print p }' "$MODTAB" | sort -u | tr '\n' ' ')
for p in $ALLOWED_PACKAGES; do
	case " $SCANNED_REPOS " in *" ${p%%/*} "*) ;; *) continue ;; esac
	if ! printf '%s' "$REPORT" | awk -F'\t' -v p="$p" '$1 == "code" && $2 == p { found = 1 } END { exit !found }'; then
		printf 'note: allowlist entry %s matched nothing — delete it so a bare Subject there fails the check\n' "$p"
	fi
done

ntest=$(printf '%s' "$REPORT" | awk -F'\t' '$1 == "test"' | wc -l | tr -d ' ')
ntestfiles=$(printf '%s' "$REPORT" | awk -F'\t' '$1 == "test" { sub(/:[0-9]+$/, "", $3); print $3 }' | sort -u | wc -l | tr -d ' ')
nglobal=$(printf '%s' "$globals" | /usr/bin/grep -c . || true)
printf 'exported package-level observables: %s (must be 0 — see the header)\n' "$nglobal"
printf 'tests: %s occurrence(s) in %s _test.go file(s) — reported, never judged (see the header)\n' \
	"$ntest" "$ntestfiles"
if [ "$LIST_TESTS" = 1 ] && [ "$ntest" -gt 0 ]; then
	printf '%s' "$REPORT" | awk -F'\t' '$1 == "test" { printf "  %s\n      %s\n", $3, $4 }'
fi

if [ "$status" -ne 0 ]; then
	echo "check-subjects: FAILED" >&2
	exit 1
fi
echo "check-subjects: OK"
