#!/usr/bin/env bash
#
# Clone every VibrantGio repository into .repos/ beneath this one.
#
# This repo — vibrantgio/.github — is the parent directory, not a clone. It is
# the plan root and the org front door; the twenty siblings live under .repos/
# and are gitignored.
#
# The whole set is cloned every time, not a subset. What this plan edits is the
# module graph, and no task can see an edge whose other end is missing.
#
# Plain git over https: gh is not assumed to be installed.

set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p .repos

# The stack, bottom to top.
STACK=(mvu spectrum prism pulse cadence markdown)

# Leaf libraries: typography, drawing helpers.
LEAVES=(font style textdraw backdrop gradient circle)

# Support libraries — consumed by the design system, never dependent on it.
SUPPORT=(ivg svg seen csg kiwi noise traer)

# Applications.
APPS=(workbench)

REPOS=("${STACK[@]}" "${LEAVES[@]}" "${SUPPORT[@]}" "${APPS[@]}")

for name in "${REPOS[@]}"; do
	if [ -d ".repos/$name/.git" ]; then
		printf 'pull  %s\n' "$name"
		git -C ".repos/$name" pull --ff-only --quiet
	else
		printf 'clone %s\n' "$name"
		git clone --quiet "https://github.com/vibrantgio/$name.git" ".repos/$name"
	fi
done

printf '\n%d repositories under .repos/\n' "$(find .repos -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
