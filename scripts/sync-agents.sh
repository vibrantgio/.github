#!/usr/bin/env bash
# sync-agents.sh — write the managed AGENTS.md block into every repo but
# .github's own copy.
#
# CG4.15's ruling: no support library names a consumer, AGENTS.md included.
# Every repo's AGENTS.md but .github's carries a managed block, delimited by
# BEGIN/END markers below, holding exactly two things:
#
#   - a pointer to the plan root's Retired words table
#     (.github/AGENTS.md, "Retired words"), never a copy of the table
#   - a canonical-guide line pointing at the plan root's AGENTS.md
#
# workbench's block additionally points at its own llms.txt, because that
# is workbench's own document, not a consumer it names. No other repo's
# block, and no line outside a block, points at workbench, llms.txt or an
# application.
#
# Everything outside the markers is the repo's own prose (title,
# description) and is never touched, except once: the legacy
# canonical-guide sentence and its raw.githubusercontent.com/.../llms.txt
# URL, which this task retires, are stripped wherever found so the block
# replaces them rather than sitting beside them. Running the script twice
# changes nothing — the second run finds no legacy line left to strip and
# writes the same block back.
#
# CG4.18 extended the rule to each support repo's README.md: `check` mode's
# open-rulings and consumer-name assertions below run over both AGENTS.md and
# README.md. `write` mode still only touches AGENTS.md — a README's prose is
# hand-edited, not templated.
#
# CG4.20: the consumer-name assertion matches whole words, case-sensitively,
# against the application names as spelled, so a support library's own
# vocabulary (patterns' "Marketing" category) passes and a consumer's name
# (the "marketing" app) still fails. `testdata/consumer-name-pass.md` and
# `testdata/consumer-name-fail.md` fix that pair of cases; `selftest` proves
# them, and `check` runs `selftest` too.
#
# Usage (run from the plan root, i.e. from .github, or anywhere):
#   .github/scripts/sync-agents.sh          write every repo's AGENTS.md
#   .github/scripts/sync-agents.sh check    exit non-zero on any drift
#   .github/scripts/sync-agents.sh selftest prove the consumer-name assertion
#                                            against testdata/, whole-word
#                                            and case-sensitive
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TESTDATA_DIR="$SCRIPT_DIR/testdata"
cd "$ROOT"

MODE="${1:-write}"

BEGIN_MARK="<!-- sync-agents:begin -->"
END_MARK="<!-- sync-agents:end -->"

SUPPORT_REPOS="backdrop circle components csg design effects font gradient ivg kiwi markdown mvu noise patterns seen style svg textdraw theme traer"
WORKBENCH_REPO="workbench"
ALL_REPOS="$SUPPORT_REPOS $WORKBENCH_REPO"

APPLICATIONS="mindchat vaultview feeds todos themer sitedocs sk150 iconbrowser marketing launcher"

block_for() {
  local repo="$1"
  if [ "$repo" = "$WORKBENCH_REPO" ]; then
    cat <<BLOCK
$BEGIN_MARK
Read the org guide before you write code against these apps: the plan
root's \`AGENTS.md\`.

Its Retired words table (\`.github/AGENTS.md\`, "Retired words") is the
list; say the right-hand column, not the retired word.

This repository's own \`llms.txt\` is the guide for writing an
application against the libraries.
$END_MARK
BLOCK
  else
    cat <<BLOCK
$BEGIN_MARK
Read the org guide before you write code against this module: the
plan root's \`AGENTS.md\`.

Its Retired words table (\`.github/AGENTS.md\`, "Retired words") is the
list; say the right-hand column, not the retired word.
$END_MARK
BLOCK
  fi
}

# Strip an existing managed block (its markers included) from stdin.
strip_block() {
  awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
    $0 == b { skip=1; next }
    $0 == e { skip=0; next }
    skip { next }
    { print }
  '
}

# Strip the legacy canonical-guide lines this task retires.
strip_legacy() {
  grep -v \
    -e '^Read the org guide before you write code against this module:$' \
    -e '^Read it before you write code against these apps:$' \
    -e "^The org guide lives in this repository as \`llms\.txt\`\.\$" \
    -e '^    https://raw\.githubusercontent\.com/vibrantgio/workbench/master/llms\.txt$'
}

# Drop trailing blank lines, keep exactly one trailing newline.
rstrip_blank() {
  awk 'NF{p=NR} {a[NR]=$0} END{for(i=1;i<=p;i++) print a[i]}'
}

desired_content() {
  local repo="$1" file="$2"
  { strip_block < "$file" | strip_legacy | rstrip_blank; printf '\n'; block_for "$repo"; }
}

sync_one() {
  local repo="$1"
  local file="$repo/AGENTS.md"
  if [ ! -f "$file" ]; then
    echo "sync-agents: missing $file" >&2
    return 1
  fi
  local tmp
  tmp="$(mktemp)"
  desired_content "$repo" "$file" > "$tmp"

  if [ "$MODE" = "check" ]; then
    if ! diff -q "$tmp" "$file" >/dev/null 2>&1; then
      echo "DRIFT: $file"
      rm -f "$tmp"
      return 1
    fi
    rm -f "$tmp"
  else
    mv "$tmp" "$file"
  fi
}

check_no_open_rulings() {
  local status=0
  for repo in $ALL_REPOS .github; do
    for name in AGENTS.md README.md; do
      local file="$repo/$name"
      [ -f "$file" ] || continue
      if grep -q 'open-rulings' "$file"; then
        echo "FORBIDDEN: $file names open-rulings.md"
        status=1
      fi
    done
  done
  return $status
}

# names_hit_in FILE prints, one per line, each consumer name (workbench or
# an application, as spelled: `mindchat vaultview feeds todos themer
# sitedocs sk150 iconbrowser marketing launcher`) that appears in FILE as a
# whole word, case-sensitively — grep -w already is both: it will not match
# "marketing" inside a longer word, and it will not match "Marketing" (the
# patterns category) against the lowercase "marketing" app. Prints nothing
# for a clean file.
names_hit_in() {
  local file="$1"
  if grep -qw 'workbench' "$file"; then
    echo "workbench"
  fi
  local app
  for app in $APPLICATIONS; do
    if grep -qw "$app" "$file"; then
      echo "$app"
    fi
  done
}

check_no_consumer_names() {
  local status=0
  for repo in $SUPPORT_REPOS; do
    for name in AGENTS.md README.md; do
      local file="$repo/$name"
      [ -f "$file" ] || continue
      local hit
      for hit in $(names_hit_in "$file"); do
        echo "FORBIDDEN: $file names $hit"
        status=1
      done
    done
  done
  return $status
}

# selftest proves names_hit_in is whole-word and case-sensitive against a
# fixed pair of fixtures: testdata/consumer-name-pass.md carries "Marketing"
# (patterns' own category name, capitalized, never the app) and must hit
# nothing; testdata/consumer-name-fail.md carries "marketing" (the
# application, spelled as APPLICATIONS spells it) and must hit exactly that.
selftest() {
  local status=0
  local pass_file="$TESTDATA_DIR/consumer-name-pass.md"
  local fail_file="$TESTDATA_DIR/consumer-name-fail.md"

  if [ ! -f "$pass_file" ] || [ ! -f "$fail_file" ]; then
    echo "SELFTEST FAILED: missing fixture under $TESTDATA_DIR" >&2
    return 1
  fi

  local pass_hits fail_hits
  pass_hits="$(names_hit_in "$pass_file")"
  if [ -n "$pass_hits" ]; then
    echo "SELFTEST FAILED: $pass_file (patterns' Marketing category) should hit nothing, hit: $pass_hits" >&2
    status=1
  fi

  fail_hits="$(names_hit_in "$fail_file")"
  if [ "$fail_hits" != "marketing" ]; then
    echo "SELFTEST FAILED: $fail_file (the marketing application) should hit exactly 'marketing', hit: '$fail_hits'" >&2
    status=1
  fi

  if [ "$status" -eq 0 ]; then
    echo "sync-agents selftest: clean"
  fi
  return $status
}

main() {
  if [ "$MODE" = "selftest" ]; then
    selftest
    return $?
  fi

  local status=0

  for repo in $ALL_REPOS; do
    sync_one "$repo" || status=1
  done

  if [ "$MODE" = "check" ]; then
    check_no_open_rulings || status=1
    check_no_consumer_names || status=1
    selftest || status=1
    if [ "$status" -eq 0 ]; then
      echo "sync-agents check: clean"
    fi
  fi

  return $status
}

main
