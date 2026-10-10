#!/usr/bin/env bash
# check-guides.sh — refuse migration history in a live guide.
#
# The live guides are workbench/llms.txt and the README of every repository.
# They describe what ships and how to use it. What a module was called, what
# a version broke, which identifier is gone and what to do if an older answer
# mentions it are not part of that: a reader who never saw the old shape is
# only slowed down by it, and a reader who did has git. So the history is
# deleted rather than carried, and this script is what keeps it deleted.
#
# WHAT IT LOOKS FOR, and each phrase is here because it was found in a guide:
#
#   older code              "if you find this in older code"
#   older answer            the same sentence about an assistant's answer
#   used to                 "the assignment every app used to re-derive"
#   no longer               "the static surface no longer takes"
#   formerly                a name introduced by its dead one
#   previously              the same
#   was renamed             "a file written before the key was renamed"
#   renamed from            "renamed from iconvg to ivg"
#   once lived              "transition, which once lived in spectrum"
#   the old                 "the old fallback practice", "the old defect"
#   breaking release        a release note in a README
#   is a breaking           the same note in the present tense
#   gone, not deprecated    the heading sentence of a migration list
#   ADR-N                   a decision record cited by number in published
#                           text: say what the rule is instead
#   level argument          the retired parameter
#   "base"                  the retired key in the kept-theme file
#   spectrum prism          the retired module names, on word boundaries. A
#   pulse cadence           sentence that needs the ordinary word (a billing
#                           cadence, a pulse of light) says it another way,
#                           because a guide naming a module nobody can import
#                           is worse than a guide short one synonym.
#   patterns/tag            retired packages
#   patterns/modal
#   TypeScale               a retired type, bare or qualified
#   popover.Arbitration     the coordination buses, with their snapshots
#   tooltip.Arbitration
#   modal.Stack
#   toast.Notifications
#
# WHAT IS NOT JUDGED. A frozen record is not rewritten to follow a later
# decision: reviews/, TRANSCRIPTS.md, PLAN.md, DOMAIN.md, design/DESIGN-v1.md
# and the pool are records of what was said on a date, and none of them is a
# README. Testdata READMEs are fixtures, judged by the tests that read them.
# Another session's .claude worktree is a second checkout of the same
# sources, not this tree's. Code comments are out of scope on purpose: a
# comment carries the constraint its code cannot show, and the guides are
# what a reader is pointed at.
#
# Usage (run from the plan root, i.e. from .github, or anywhere):
#   .github/scripts/check-guides.sh    exit non-zero on any hit
#
# Exit status: 0 when every guide is clean, 1 on any hit, 2 when the tree
# cannot answer the question.

set -uo pipefail

cd "$(dirname "$0")/.."
WS=$(cd .. && pwd) # workspace root: the siblings' parent

PHRASES=(
	'older code'
	'older answer'
	'used to'
	'no longer'
	'formerly'
	'previously'
	'was renamed'
	'renamed from'
	'once lived'
	'the old'
	'breaking release'
	'is a breaking'
	'gone, not deprecated'
	'ADR-[0-9]'
	'level argument'
	'"base"'
	'\bspectrum\b'
	'\bprism\b'
	'\bpulse\b'
	'\bcadence\b'
	'patterns/tag'
	'patterns/modal'
	'TypeScale'
	'popover\.Arbitration'
	'tooltip\.Arbitration'
	'modal\.Stack'
	'toast\.Notifications'
)

guides=$(
	find "$WS" \
		-path '*/.claude/*' -prune -o \
		-path '*/.git/*' -prune -o \
		-path '*/testdata/*' -prune -o \
		\( -name 'README.md' -o -name 'llms.txt' \) -print | sort
)
[ -n "$guides" ] || {
	printf 'check-guides: no guide found under %s — run scripts/clone-all.sh first\n' "$WS" >&2
	exit 2
}

pattern=$(
	IFS='|'
	printf '%s' "${PHRASES[*]}"
)

hits=$(printf '%s\n' "$guides" | tr '\n' '\0' | xargs -0 grep -n -i -E -- "$pattern" /dev/null)

nguides=$(printf '%s\n' "$guides" | wc -l | tr -d ' ')

if [ -n "$hits" ]; then
	printf 'MIGRATION HISTORY IN A LIVE GUIDE:\n'
	printf '%s\n' "$hits" | sed "s|^$WS/|  |"
	n=$(printf '%s\n' "$hits" | wc -l | tr -d ' ')
	printf '\nA guide says what ships and how to use it. Delete the history, or\n'
	printf 'rewrite the sentence to state the current design plainly.\n'
	printf 'check-guides: FAILED (%s hit(s) in %s guide(s) checked)\n' "$n" "$nguides"
	exit 1
fi

printf 'check-guides: OK (%s guides)\n' "$nguides"
