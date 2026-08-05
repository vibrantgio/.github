#!/usr/bin/env bash
# check-layers.sh — enforce ADR-001's layering across the Vibrant Gio stack.
#
# For each module it runs `go list -deps` over the module's own packages and
# asserts that every github.com/vibrantgio dependency edge is one the ADR-001
# tier table permits. Judgment is module-level: each dependency package is
# mapped to its module, each module to its repo, each repo to a tier. A module
# may import only repos in a STRICTLY lower tier, plus the support libraries.
# Support libraries may import nothing in the table.
#
#   | Tier | Modules                                          |
#   |  0   | mvu, font, style, textdraw, backdrop, gradient, circle |
#   |  1   | spectrum                                         |
#   |  2   | prism                                            |
#   |  3   | pulse                                            |
#   |  4   | cadence, markdown                                |
#   |  —   | ivg, svg, seen, csg, kiwi, noise, traer (support)|
#
# Nested-module exemption (ADR-001): the demo modules prism/gallery and
# mvu/example may import above their parent's tier, so they are skipped
# entirely; their parents may NOT inherit that freedom — a parent's packages
# are selected by module path, so a demo's edges never leak into the parent's
# judgment, and a parent importing its own nested module is itself flagged.
# Other nested modules (ivg/raster/gio, svg/driver/*, kiwi/gio, traer/gio,
# seen/context/gio) are adapters outside the table and are skipped; the
# workbench apps are applications at the top of the stack and may import
# anything, so they are skipped too.
#
# Usage:
#   scripts/check-layers.sh              # from the .github plan root: checks
#                                        # all 19 root modules under .repos/
#                                        # (requires clone-all.sh + go.work)
#   scripts/check-layers.sh DIR [DIR..]  # check specific module directories;
#                                        # this is what each repo's CI runs,
#                                        # as `check-layers.sh .`
#
# CI distribution: the tier table lives in this one file, so each core repo's
# workflow fetches the raw script from the .github repo and runs it against
# its own checkout:
#   curl -fsSL https://raw.githubusercontent.com/vibrantgio/.github/master/scripts/check-layers.sh
# In CI there is no workspace, so `go list -deps` resolves dependencies from
# the module proxy at published tags — the check judges the released graph,
# while a run from the plan root judges the working tree.
#
# Exit status: non-zero if any non-allowlisted forbidden edge exists.

set -u

ORG=github.com/vibrantgio

# repo name -> tier: 0..4, or S for the support row, empty if not in the table.
tier_of() {
  case "$1" in
    mvu|font|style|textdraw|backdrop|gradient|circle) echo 0 ;;
    spectrum)                                         echo 1 ;;
    prism)                                            echo 2 ;;
    pulse)                                            echo 3 ;;
    cadence|markdown)                                 echo 4 ;;
    ivg|svg|seen|csg|kiwi|noise|traer)                echo S ;;
    *)                                                echo "" ;;
  esac
}

# ---------------------------------------------------------------------------
# Allowlist. Each entry names one exact repo->repo edge. Removing an entry
# makes the check FAIL if that edge (re)appears — that is the mechanism by
# which a transitional edge's removal becomes enforced.
#
# ALLOWED_EDGES: permitted forever by ADR-001 despite the strict-lower rule.
#   style->font, style->textdraw — the one explicit intra-tier allowance;
#   ADR-003 freezes style rather than deleting it, so the edge is admitted
#   instead of renumbering tier 0.
#
# RECORDED_EDGES: known transitional violations. The check reports them and
# still exits 0, until the named task removes the edge and the entry.
#   spectrum->pulse — only via the deprecated alias shim spectrum/transition
#     (B3.4); the shim and this entry die in F3.3.
# ---------------------------------------------------------------------------
ALLOWED_EDGES="style->font style->textdraw"
RECORDED_EDGES="spectrum->pulse"

recorded_reason() {
  case "$1" in
    "spectrum->pulse") echo "deprecated alias shim spectrum/transition (B3.4); removed by F3.3" ;;
  esac
}

in_list() { # word list -> 0 if word is in the space-separated list
  case " $2 " in *" $1 "*) return 0 ;; esac
  return 1
}

TIERED="mvu font style textdraw backdrop gradient circle spectrum prism pulse cadence markdown"
SUPPORT="ivg svg seen csg kiwi noise traer"

# Default target: every root module under .repos/ next to this script's repo.
if [ "$#" -gt 0 ]; then
  DIRS="$*"
else
  root=$(cd "$(dirname "$0")/.." && pwd)
  DIRS=""
  for name in $TIERED $SUPPORT; do
    d="$root/.repos/$name"
    if [ ! -f "$d/go.mod" ]; then
      echo "error: $d/go.mod not found — run scripts/clone-all.sh first" >&2
      exit 2
    fi
    DIRS="$DIRS $d"
  done
fi

violations=0
checked=""   # repo names actually judged, for staleness reporting
used=""      # allowlist entries actually exercised

for dir in $DIRS; do
  if [ ! -f "$dir/go.mod" ]; then
    echo "error: no go.mod in $dir" >&2
    violations=$((violations + 1))
    continue
  fi
  mod=$(sed -n 's/^module[[:space:]]*//p' "$dir/go.mod" | head -1)
  case "$mod" in
    "$ORG"/*) ;;
    *) echo "-- $mod: not a $ORG module, skipped"; continue ;;
  esac
  rel=${mod#"$ORG"/}
  case "$rel" in
    prism/gallery|mvu/example)
      echo "-- $rel: nested demo module, exempt (may import above its parent's tier)"
      continue ;;
    workbench/*)
      echo "-- $rel: application, top of the stack, exempt"
      continue ;;
    */*)
      echo "-- $rel: nested adapter module, outside the tier table, skipped"
      continue ;;
  esac
  name=$rel
  tier=$(tier_of "$name")
  if [ -z "$tier" ]; then
    echo "-- $name: not in the ADR-001 table, skipped"
    continue
  fi
  checked="$checked $name"

  # The module's own packages, excluding any nested module's (in workspace
  # mode ./... would otherwise match e.g. prism/gallery from inside prism —
  # this filter is half of the nested-module exemption).
  pkgs=$(cd "$dir" && go list -f '{{.ImportPath}} {{with .Module}}{{.Path}}{{end}}' ./... 2>&1) || {
    echo "error: go list failed in $dir:" >&2
    echo "$pkgs" >&2
    violations=$((violations + 1))
    continue
  }
  own=$(echo "$pkgs" | awk -v m="$mod" '$2 == m { print $1 }')
  if [ -z "$own" ]; then
    echo "-- $name: no packages, skipped"
    continue
  fi

  # Full non-test dependency closure, as "package module" pairs.
  deppkgs=$(cd "$dir" && go list -deps -f '{{.ImportPath}} {{with .Module}}{{.Path}}{{end}}' $own 2>&1) || {
    echo "error: go list -deps failed in $dir:" >&2
    echo "$deppkgs" >&2
    violations=$((violations + 1))
    continue
  }
  depmods=$(echo "$deppkgs" | awk -v org="$ORG/" -v m="$mod" \
    'index($2, org) == 1 && $2 != m { print $2 }' | sort -u)

  edges=""
  bad=0
  for depmod in $depmods; do
    deprel=${depmod#"$ORG"/}
    deprepo=${deprel%%/*}
    edge="$name->$deprepo"
    deptier=$(tier_of "$deprepo")
    verdict=""
    if [ "$deprepo" = "$name" ]; then
      verdict="VIOLATION: imports its own nested module $deprel — parents do not inherit the demo exemption"
    elif [ -z "$deptier" ]; then
      verdict="VIOLATION: imports $deprepo, which is not in the ADR-001 table"
    elif [ "$tier" = S ]; then
      verdict="VIOLATION: support library imports $deprepo — support may import nothing in the table"
    elif [ "$deptier" = S ]; then
      : # support row: importable by every tiered module
    elif [ "$deptier" -lt "$tier" ]; then
      : # strictly lower tier: permitted
    fi
    if [ -n "$verdict" ] || { [ "$tier" != S ] && [ "$deptier" != S ] && [ -n "$deptier" ] && [ "$deptier" -ge "$tier" ]; }; then
      pulled=$(echo "$deppkgs" | awk -v dm="$depmod" '$2 == dm { print $1 }' | tr '\n' ' ')
      if in_list "$edge" "$ALLOWED_EDGES"; then
        used="$used $edge"
        edges="$edges $deprepo(allowed)"
      elif in_list "$edge" "$RECORDED_EDGES"; then
        used="$used $edge"
        echo "   RECORDED  $name (tier $tier) -> $deprepo (tier $deptier): $(recorded_reason "$edge")"
        echo "             pulls in: $pulled"
        edges="$edges $deprepo(recorded)"
      else
        [ -n "$verdict" ] || verdict="VIOLATION: tier $tier may not import tier $deptier"
        echo "   $verdict"
        echo "             edge: $mod -> $depmod"
        echo "             pulls in: $pulled"
        bad=1
        violations=$((violations + 1))
        edges="$edges $deprepo(FORBIDDEN)"
      fi
    else
      edges="$edges $deprel"
    fi
  done
  if [ "$bad" = 0 ]; then
    echo "ok $name (tier $tier):${edges:- no vibrantgio imports}"
  else
    echo "FAIL $name (tier $tier):$edges"
  fi
done

# Staleness: an allowlist entry whose from-module was judged but whose edge no
# longer exists should be deleted, so the edge's return becomes a failure.
for edge in $ALLOWED_EDGES $RECORDED_EDGES; do
  from=${edge%%->*}
  if in_list "$from" "$checked" && ! in_list "$edge" "$used"; then
    echo "note: allowlist entry '$edge' matched nothing — the edge is gone; delete the entry so its return fails the check"
  fi
done

if [ "$violations" -gt 0 ]; then
  echo "check-layers: FAILED ($violations violation(s))" >&2
  exit 1
fi
echo "check-layers: OK"
