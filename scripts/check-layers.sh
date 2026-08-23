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
#   |  1   | theme                                            |
#   |  2   | components                                       |
#   |  3   | effects                                          |
#   |  4   | patterns, markdown                                |
#   |  —   | ivg, svg, seen, csg, kiwi, noise, traer (support)|
#
# Nested-module exemption (ADR-001): the demo modules components/gallery and
# mvu/example may import above their parent's tier, so they are skipped
# entirely; their parents may NOT inherit that freedom — a parent's packages
# are selected by module path, so a demo's edges never leak into the parent's
# judgment, and a parent importing its own nested module is itself flagged.
# Other nested modules (ivg/raster/gio, svg/driver/*, kiwi/gio, traer/gio,
# seen/context/gio) are adapters outside the table and are skipped; the
# workbench apps — with the workbench root module that collects them, and
# design, the published bundle — are applications at the top of the stack and
# may import anything, so they are skipped too. The workbench root is named on
# its own beside `workbench/*`: it is a module path with no directory after
# it, so the pattern that catches its apps does not catch it, and without the
# name it would fall through to the table and be reported as untabled.
#
# Usage:
#   scripts/check-layers.sh              # from the .github plan root: checks
#                                        # all 19 root modules beside .github
#                                        # (requires clone-all.sh + go.work)
#   scripts/check-layers.sh DIR [DIR..]  # check specific module directories;
#                                        # this is what each repo's CI runs,
#                                        # as `check-layers.sh .`
#   scripts/check-layers.sh --edges      # emit the measured graph as TSV on
#                                        # stdout and say nothing else there
#
# --edges exists so that the one derivation in this file can be *read* as well
# as judged. Two measurements of one fact is the defect G0.1 closed, so there
# must not be a second walk of the graph anywhere in the organization —
# extend this one.
#
# In --edges mode the judgment is unchanged, but the *scope* widens: the
# default target becomes every module beside .github, all 39, because a guide
# has to describe the exempt ones too — an application repository is mostly
# its applications, and a demo's edges are the ones most easily mistaken for
# its parent's, `components/gallery`'s to effects being the cycle the whole of
# phase B went after. They are measured and emitted, still never judged.
#
# What a guide never prints is this graph read backwards. Both directions are
# measured here and the tier rule is judged on both, because a forbidden edge
# has two ends; only the forward half is rendered into prose. A module's
# importers are not its own fact to state, and a list of them taken from these
# clones would read as complete while seeing no further than the organization
# does. Human report lines go to stderr so stdout
# carries nothing but the TSV, one line per edge:
#
#   <module>  <kind>  <tier>  <imported module>  <direct|indirect>  <pkgs,of,it>
#
# all paths relative to github.com/vibrantgio, kind one of root/demo/app/
# adapter/untabled, tier `-` for anything not judged, and a module with no
# organization imports emitted once with `-` in the last three fields so that
# "imports nothing here" is a measured fact rather than an absent row.
#
# The edge list is the dependency *closure*, because that is what ADR-001
# judges: patterns reaching font only through components is still patterns depending
# on font, and a tier rule that ignored inherited edges would be no rule. The
# direct/indirect column keeps the other question answerable — what does this
# module's own source name — so that neither has to be guessed from the other.
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
    theme)                                            echo 1 ;;
    components)                                       echo 2 ;;
    effects)                                          echo 3 ;;
    patterns|markdown)                                 echo 4 ;;
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
#   Empty since F3.3. The last entry was spectrum->pulse, carried only by the
#   deprecated spectrum/transition alias shim (B3.4); the shim went in
#   spectrum v0.2.0 and the entry went with it, so every upward edge the
#   phases opened is now closed and any new one is a hard failure. An entry
#   added back here must name the task that removes it again.
# ---------------------------------------------------------------------------
ALLOWED_EDGES="style->font style->textdraw"
RECORDED_EDGES=""

recorded_reason() {
  case "$1" in
    *) echo "transitional edge, no reason recorded" ;;
  esac
}

in_list() { # word list -> 0 if word is in the space-separated list
  case " $2 " in *" $1 "*) return 0 ;; esac
  return 1
}

TIERED="mvu font style textdraw backdrop gradient circle theme components effects patterns markdown"
SUPPORT="ivg svg seen csg kiwi noise traer"

EDGES=0
ARGS=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -e|--edges) EDGES=1 ;;
    -h|--help)
      sed -n '2,80p' "$0" | sed -n '/^# Usage:/,/^#$/p' | sed 's/^# \{0,1\}//'
      exit 0 ;;
    -*) echo "check-layers: unknown option: $1" >&2; exit 2 ;;
    *)  ARGS="$ARGS $1" ;;
  esac
  shift
done

# The human report. In --edges mode stdout belongs to the TSV alone, so every
# line of prose this script writes goes through here and lands on stderr.
say() {
  if [ "$EDGES" = 1 ]; then printf '%s\n' "$*" >&2; else printf '%s\n' "$*"; fi
}

# Default target: every root module beside .github next to this script's repo —
# or, when the graph is being read rather than judged, every module there.
if [ -n "$ARGS" ]; then
  DIRS=$ARGS
else
  root=$(cd "$(dirname "$0")/../.." && pwd) # workspace root: the siblings' parent
  DIRS=""
  if [ "$EDGES" = 1 ]; then
    DIRS=$(find "$root" -mindepth 2 -not -path "$root/.github/*" -name go.mod -not -path '*/.git/*' 2>/dev/null |
      sed 's|/go\.mod$||' | sort)
    if [ -z "$DIRS" ]; then
      echo "error: no modules under $root — run scripts/clone-all.sh first" >&2
      exit 2
    fi
  else
    for name in $TIERED $SUPPORT; do
      d="$root/$name"
      if [ ! -f "$d/go.mod" ]; then
        echo "error: $d/go.mod not found — run scripts/clone-all.sh first" >&2
        exit 2
      fi
      DIRS="$DIRS $d"
    done
  fi
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
    *) say "-- $mod: not a $ORG module, skipped"; continue ;;
  esac
  rel=${mod#"$ORG"/}

  # What sort of module this is, and therefore whether ADR-001 judges it. The
  # four exempt kinds are still *measured* in --edges mode: a guide describes
  # the graph, and the graph includes the demos and the applications.
  kind=root
  case "$rel" in
    components/gallery|mvu/example) kind=demo ;;
    workbench|workbench/*|design) kind=app ;;
    */*)                       kind=adapter ;;
  esac
  name=$rel
  tier=""
  if [ "$kind" = root ]; then
    tier=$(tier_of "$name")
    [ -n "$tier" ] || kind=untabled
  fi

  judge=0
  [ "$kind" = root ] && judge=1
  if [ "$judge" = 0 ] && [ "$EDGES" = 0 ]; then
    case "$kind" in
      demo)     echo "-- $rel: nested demo module, exempt (may import above its parent's tier)" ;;
      app)      echo "-- $rel: application, top of the stack, exempt" ;;
      adapter)  echo "-- $rel: nested adapter module, outside the tier table, skipped" ;;
      untabled) echo "-- $name: not in the ADR-001 table, skipped" ;;
    esac
    continue
  fi
  [ "$judge" = 1 ] && checked="$checked $name"

  # The module's own packages, excluding any nested module's (in workspace
  # mode ./... would otherwise match e.g. components/gallery from inside components —
  # this filter is half of the nested-module exemption). Each line is
  # "package module import import ...": the third field onward is what that
  # package names in its own import block, which is how --edges tells a
  # dependency this module reaches for itself from one it merely inherits.
  # It rides on this call rather than a second `go list` — the direct edges
  # and the closure are one measurement, asked once.
  pkgs=$(cd "$dir" && go list -f '{{.ImportPath}} {{with .Module}}{{.Path}}{{else}}-{{end}}{{range .Imports}} {{.}}{{end}}' ./... 2>&1) || {
    echo "error: go list failed in $dir:" >&2
    echo "$pkgs" >&2
    [ "$judge" = 1 ] && violations=$((violations + 1))
    continue
  }
  own=$(echo "$pkgs" | awk -v m="$mod" '$2 == m { print $1 }')
  deppkgs=""
  depmods=""
  directmods=""
  if [ -z "$own" ]; then
    say "-- $name: no packages, skipped"
    [ "$EDGES" = 1 ] || continue
  else
    # Full non-test dependency closure, as "package module" pairs.
    deppkgs=$(cd "$dir" && go list -deps -f '{{.ImportPath}} {{with .Module}}{{.Path}}{{end}}' $own 2>&1) || {
      echo "error: go list -deps failed in $dir:" >&2
      echo "$deppkgs" >&2
      [ "$judge" = 1 ] && violations=$((violations + 1))
      continue
    }
    depmods=$(echo "$deppkgs" | awk -v org="$ORG/" -v m="$mod" \
      'index($2, org) == 1 && $2 != m { print $2 }' | sort -u)
    if [ "$EDGES" = 1 ]; then
      directmods=$(echo "$deppkgs" | awk -v m="$mod" -v want="$(
        echo "$pkgs" | awk -v m="$mod" '$2 == m { for (i = 3; i <= NF; i++) print $i }' |
          sort -u | tr '\n' ' ')" '
        BEGIN { n = split(want, a, " "); for (i = 1; i <= n; i++) w[a[i]] = 1 }
        ($1 in w) && $2 != "" && $2 != m { print $2 }' | sort -u | tr '\n' ' ')
    fi
  fi

  # The measured graph, for readers rather than for judgment. A module with no
  # organization imports still gets a row: "imports nothing here" is a fact
  # sync-agents.sh has to be able to render, and an absent row cannot say it.
  if [ "$EDGES" = 1 ]; then
    if [ -z "$depmods" ]; then
      printf '%s\t%s\t%s\t-\t-\t-\n' "$rel" "$kind" "${tier:--}"
    else
      for depmod in $depmods; do
        case " $directmods " in
          *" $depmod "*) via=direct ;;
          *)             via=indirect ;;
        esac
        printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$rel" "$kind" "${tier:--}" \
          "${depmod#"$ORG"/}" "$via" \
          "$(echo "$deppkgs" | awk -v dm="$depmod" '$2 == dm { print $1 }' |
             sed -e "s|^$depmod/||" -e "s|^$depmod\$|.|" | sort -u |
             tr '\n' ',' | sed 's/,$//')"
      done
    fi
    { [ "$judge" = 1 ] && [ -n "$own" ]; } || continue
  fi

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
        say "   RECORDED  $name (tier $tier) -> $deprepo (tier $deptier): $(recorded_reason "$edge")"
        say "             pulls in: $pulled"
        edges="$edges $deprepo(recorded)"
      else
        [ -n "$verdict" ] || verdict="VIOLATION: tier $tier may not import tier $deptier"
        say "   $verdict"
        say "             edge: $mod -> $depmod"
        say "             pulls in: $pulled"
        bad=1
        violations=$((violations + 1))
        edges="$edges $deprepo(FORBIDDEN)"
      fi
    else
      edges="$edges $deprel"
    fi
  done
  if [ "$bad" = 0 ]; then
    say "ok $name (tier $tier):${edges:- no vibrantgio imports}"
  else
    say "FAIL $name (tier $tier):$edges"
  fi
done

# Staleness: an allowlist entry whose from-module was judged but whose edge no
# longer exists should be deleted, so the edge's return becomes a failure.
for edge in $ALLOWED_EDGES $RECORDED_EDGES; do
  from=${edge%%->*}
  if in_list "$from" "$checked" && ! in_list "$edge" "$used"; then
    say "note: allowlist entry '$edge' matched nothing — the edge is gone; delete the entry so its return fails the check"
  fi
done

if [ "$violations" -gt 0 ]; then
  echo "check-layers: FAILED ($violations violation(s))" >&2
  exit 1
fi
say "check-layers: OK"
