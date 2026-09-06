#!/usr/bin/env bash
# check-retired-words.sh — find, classify and forbid the retired words.
#
# AGENTS.md's "Retired words" table names the words the Language has retired
# and the word to say instead. This script is that table made executable: it
# walks every module in the flat checkout, matches each retired word on word
# boundaries, case-insensitively, and files every hit by module and by kind.
#
#   identifier  a Go token outside comments and string literals
#   comment     a Go comment
#   string      a Go string or rune literal
#   doc         *.md, *.html and llms.txt prose
#
# Telling those four apart is why scripts/retiredwords/ exists: the Go files
# are tokenized with go/scanner, so `Wash` in a comment is never filed as an
# identifier and `container/list` in an import is filed as the string it is.
# A regex over source cannot make that distinction, and the sweeps that
# follow this inventory are cut along exactly that line — comments and docs
# first, proven comment-only, then identifiers with their consumers.
#
# Word forms. Each word matches its own inflections — s, es, ed, ing, ly —
# so "washes" and "registered" are hits on wash and register. Identifiers are
# split into their words first, on underscores and camel-case humps, with a
# run of capitals broken before the capital that starts the next word
# (ghostWash -> ghost, Wash; HTMLCanvas -> HTML, Canvas; Level2 -> Level, 2),
# so `markWash`, `LevelFloor` and `tierPrimaryInk` are hits on the word they
# carry inside them. A word that only appears inside a longer word is not a
# hit: Markdown, background and foreground are not mark and ground.
#
# Senses. Most rows retire one *sense* of a word and keep the others, so a
# match is not yet a defect. Every kept sense is an explicit rule in the
# EXCLUSIONS table below, each carrying the one-line reason it is kept —
# never a blanket skip of a module, which would blind the guard to the
# retired sense in the same file. `excluded` mode prints every exclusion the
# run applied, with its reason, so the table can be audited against the tree
# rather than trusted.
#
# What is not walked: .git, testdata, and the design bundle's generated
# outputs — design/readme.md and design/foundations/*.html, written by
# theme/cmd/vg-tokens from prose that lives in theme/export, which this
# sweep does cover; fixing them at the source is the only fix that survives
# the next regeneration. design/styles.css and design/theme.json are
# generated from the same place and carry no prose extension, so they are
# outside the file set to begin with. Nested modules are walked with their
# repository and counted under it, because BR2.7's split is per repository.
#
# Frozen records. A record of what was found, measured or said on a date is
# not rewritten to follow a later Language: reviews/, TRANSCRIPTS.md, PLAN.md
# above the first unchecked task, DOMAIN.md from its Decisions down, and
# explorations/open-rulings.md's "Review provenance" foot are excluded for
# that reason and say so in `excluded` output. The two boundaries inside a
# file are measured, not written down — the first unchecked box, the
# provenance heading — so they move as the plan is worked. Everything else
# in .github is judged: AGENTS.md, DOMAIN's Language, the READMEs, the live
# pool items and the plan from the task in hand downward are the texts a
# packet is written from, and a retired word in one of them is a carrier.
#
# Usage:
#   scripts/check-retired-words.sh inventory [MODULE...]  # the work list
#   scripts/check-retired-words.sh check [MODULE...]      # exit 1 on any hit
#   scripts/check-retired-words.sh excluded [MODULE...]   # what was excluded
#
#   --kind=K[,K]   restrict to identifier, comment, doc, string
#   --word=W[,W]   restrict to some of the retired words
#
# Run it from the .github plan root: like check-layers.sh it judges the whole
# working tree, which a single repository's CI cannot see. With no MODULE it
# walks every sibling of .github and .github itself.
#
# Exit status: 0, or 1 in `check` mode when any hit survives the exclusions.

set -u

# The retired words, from AGENTS.md's table. Both spellings of emphasised
# are matched: the word is the same word.
WORDS="wash,ink,shout,ground,floor,storey,ladder,rung,register,intent,anatomy,voice,volume,loud,quiet,widget,mark,elevated,reach,canvas,author,container,outlined,filled,highlighted,featured,emphasised,emphasized"

MODULES="backdrop circle components csg design effects font gradient ivg kiwi markdown mvu noise patterns seen style svg textdraw theme traer workbench .github"

# ---------------------------------------------------------------------------
# The exclusions. One rule per line:
#
#   word :: kind :: field :: regex :: reason
#
# word   one retired word, a comma list of them, or * for all
# kind   identifier, comment, doc, string, a comma list, or *
# field  path, line, match, token, rawtoken (the token as written, case
#        kept), quoted (whether the word sits inside
#        quotes or backticks), or ctx (path and line together); prefixed
#        with ! it excludes every hit whose field does NOT match, which is
#        how a word retired in one sense only is judged in that sense alone
# regex  an extended regular expression, matched against the lower-cased
#        field, so write it in lower case
# reason one line, printed by `excluded`, stating why the sense is kept
#
# The separator is :: because the regexes are full of | alternations.
#
# A hit is excluded when any rule matches it. Removing a rule makes its hits
# defects again, which is the mechanism by which a sense stops being kept.
# ---------------------------------------------------------------------------
# Read rather than $(cat <<...): bash 3.2, which is what /usr/bin/env bash
# still finds on macOS, mis-parses an apostrophe inside a here-document
# inside a command substitution, and these reasons are full of them.
EXCLUSIONS=""
read -r -d '' EXCLUSIONS <<'RULES' || true
*::*::path::^\.github/scripts/::The guard names every retired word in order to find it.
*::*::path::^\.github/reviews/::A fresh-eyes review records what a reviewer said on a date; rewriting it falsifies the record.
*::*::path::^\.github/transcripts\.md$::The owner's own words, kept verbatim.
*::comment,doc::quoted::^yes$::In prose, a word inside quotes or backticks is named, or quoted from what says it, rather than used. A Go string literal is not: those quotes are the literal's own.
voice::*::ctx::voice memos::Voice Memos is a macOS application, measured in the platform reference.
*::doc::ctx::^\.github/agents\.md \|::AGENTS.md's Retired words table is the list itself: the rows name the words, they do not use them.
*::comment,doc,string::line::gioui\.org::A line naming Gio's own import path names a third party's API, not ours.
*::identifier::rawtoken::^(Action|Alert|AV|Communication|Content|Device|Editor|File|Hardware|Image|Maps|Navigation|Notification|Places|Social|Toggle)[A-Z]::Material Symbols icon names — AVVolumeUp, MapsLocalCarWash, ContentMarkUnread — are a third party's identifiers, mirrored here.
widget::identifier::token::widget(s)?$::A value or the type of Gio's layout.Widget, which the row keeps as Gio's.
widget::identifier::rawtoken::^(WidgetImageProvider|widgetProvider|TestWidgetImageProvider|TestImageWidgetFallthroughs)$::markdown's provider of an image as Gio's layout.Widget; the name says the type it returns.
widget::*::line::(^|[^a-z])(layout\.widget|widget\.[a-z])::layout.Widget and Gio's widget package on the line: Gio's own API.
author::comment,doc::line::(the go authors|copyright)::A third party's copyright notice, inherited verbatim.
widget::doc,comment::line::[a-z]+\.widget\(::A call to a real exported function named Widget in a code fence or a doc comment; renaming it is the identifier round's.
widget::doc::line::ui-widget::jQuery UI's own CSS class name in a third-party example page.
*::doc::path::^seen/plan\.md$::A repo-local plan awaiting the owner's ruling on its future.
*::doc::path::^design/design-v1\.md$::A superseded document kept for history, frozen like the other records.

mark::*::!ctx::(mark component|component mark|/mark/|mark package)::The glyph a control draws and the verb are kept; only the former component's name was retired, and a line that means the component says so.
floor::identifier::!token::(floor(level|storey|surface|tint)|(level|storey|chrome|backdrop|surface)floor)::A floor in an identifier is a lower bound — a contrast floor, a perceptibility floor, math.Floor; the retired sense would join it to an elevation word.
floor::comment,doc,string::!line::(elevation|storey|ladder|ground floor|floor level|floor of the)::A contrast floor or another lower bound; the retired sense is an elevation level and says so with the elevation words.
canvas::*::path::^(svg|ivg|seen|kiwi)/::The SVG specification's canvas — the drawing area a graphics library exposes — spoken by the SVG and IconVG renderers and the scene libraries they drive.
reach::*::!ctx::(reachable|out of reach|within reach|can(not)? reach (it|them|the)|reach(es)? the (control|button|target|item|row|link))::"reach" is retired for operating a control only — reachable, out of reach, cannot reach the control. A value reaching a limit, and reaching for an API, are ordinary English.
register::identifier::token::^register::The verb: registering a handler, a target or a collector.
register::identifier::rawtoken::^TestRegister::A test of a function named Register, the verb.
register::identifier::path::^(mvu|seen)/::The runtime's own registration API — what a handler does.
register::*::path::^ivg/::CREG and NREG are machine registers in the IconVG format's own specification.
register::comment,doc,string::ctx::(handler|listener|callback|event|registry|modbus|holding|device|sk150|driver|hook|collector|subscrib|registering|registered|filter|area|shortcut|register adds|in register and|to register\.|re-register|register(s|ed|ing)? (a|an|the|each|every|it|its|no|its own|themselves|tags?|hover|focus|pointer|key|absorb|region|hit)([^a-z]|$)|registers (a|an|the|each|every|it|its)([^a-z]|$))::"register" as what a handler or a Modbus device does, which the row keeps.
container::*::!ctx::card::The tinted field — ContainerOn, StatusContainer, containerChroma — and Go's own container/list, which the row keeps; only a card's surface was retired.
filled,outlined::*::!ctx::((filled|outlined) (card|group|tier)|card--(filled|outlined)|props\.filled)::The button's Filled variant, an outlined icon, a filled path and a filled inset keep their words; only a card called filled or outlined was retired.
highlighted,featured,emphasised,emphasized::*::!ctx::(pricing|tier)::Syntax highlighting, the highlighter, a feature block and Material's Emphasized easing keep their words; only a pricing tier's was retired.
author::*::path::^markdown/::In the markdown module the author is the one who wrote the document.
author::*::ctx::(wrote|writes|written|article|testimonial|front ?matter|commit|content|document|feed|post|avatar|name|role|drew|drawn|authored|icon|glyph|path)::"author" as who wrote the content — an article, a testimonial, markdown front matter, a commit — which the row keeps.
quiet::*::match::^quietly$::The ordinary adverb — a check that fails quietly — not a variant's prominence.
loud::*::match::^loudly$::The ordinary adverb — a check that fails quietly — not a variant's prominence.
volume::*::path::^(seen|csg)/::A volume is a solid in the geometry these renderers work in.
RULES
#
# Three exemptions the plan names carry no rule, because nothing in the tree
# matches them: mvu and Gio name no "intent" of their own, no vendored source
# and no material-package call carries Gio's own "ink", and reference/ holds
# no retired word. A rule for any of them would be an entry that matched
# nothing, and `excluded` is how that is checked: every rule above fires.

usage() { sed -n '/^# Usage:/,/^# Exit status/p' "$0" | sed 's/^# \{0,1\}//'; }

MODE=""
KINDS=""
ONLY_WORDS=""
ARGS=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    inventory|check|excluded) MODE="$1" ;;
    --kind=*) KINDS="${1#--kind=}" ;;
    --word=*) ONLY_WORDS="${1#--word=}" ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "check-retired-words: unknown option: $1" >&2; exit 2 ;;
    *) ARGS="$ARGS $1" ;;
  esac
  shift
done
if [ -z "$MODE" ]; then
  echo "check-retired-words: name a mode: inventory, check or excluded" >&2
  usage >&2
  exit 2
fi

root=$(cd "$(dirname "$0")/../.." && pwd) # workspace root: the siblings' parent
here=$(cd "$(dirname "$0")/.." && pwd)    # the .github plan root
[ -n "$ARGS" ] && MODULES="$ARGS"

# The file set: every Go file and every prose file of each module, minus the
# generated design outputs, .git and testdata.
list_files() {
  for name in $MODULES; do
    d="$root/$name"
    if [ ! -d "$d" ]; then
      echo "error: $d not found — run scripts/clone-all.sh first" >&2
      exit 2
    fi
    find "$d" -type f \( -name '*.go' -o -name '*.md' -o -name '*.html' -o -name 'llms.txt' \) \
      -not -path '*/.git/*' -not -path '*/testdata/*' \
      -not -path "$root/design/readme.md" -not -path "$root/design/README.md" \
      -not -path "$root/design/foundations/*.html" 2>/dev/null
  done | sed "s|^$root/||" | sort
}

# Frozen boundaries, measured rather than written down: the plan is frozen
# above the first task still to do, DOMAIN's records begin at its Decisions,
# and the pool's begin at its "Review provenance" foot.
plan_frozen=0
if [ -f "$here/PLAN.md" ]; then
  plan_frozen=$(grep -n '^ *- \[ \]' "$here/PLAN.md" | head -1 | cut -d: -f1)
  [ -n "$plan_frozen" ] || plan_frozen=$(wc -l < "$here/PLAN.md")
fi
domain_frozen=0
if [ -f "$here/DOMAIN.md" ]; then
  domain_frozen=$(grep -n '^## Decisions' "$here/DOMAIN.md" | head -1 | cut -d: -f1)
  [ -n "$domain_frozen" ] || domain_frozen=0
fi
pool_frozen=0
if [ -f "$here/explorations/open-rulings.md" ]; then
  pool_frozen=$(grep -n '^## Review provenance' "$here/explorations/open-rulings.md" | head -1 | cut -d: -f1)
  [ -n "$pool_frozen" ] || pool_frozen=0
fi

hits=$(cd "$root" && list_files | go run "$here/scripts/retiredwords/main.go" -words "$WORDS") || exit 2

# The rules travel in the environment, not through -v: an -v assignment runs
# escape processing over the value and would eat the backslashes the regexes
# are built from.
export RETIRED_RULES="$EXCLUSIONS"

# LC_ALL=C: the words are ASCII, and a byte-wise awk neither mis-lowers a
# multi-byte rune nor rejects one it cannot decode.
report=$(printf '%s\n' "$hits" | LC_ALL=C awk -F'\t' \
  -v mode="$MODE" -v kinds="$KINDS" -v only="$ONLY_WORDS" \
  -v planfrozen="$plan_frozen" -v poolfrozen="$pool_frozen" -v domainfrozen="$domain_frozen" '
function lc(s) { return tolower(s) }
BEGIN {
  n = split(ENVIRON["RETIRED_RULES"], rl, "\n")
  for (i = 1; i <= n; i++) {
    if (rl[i] == "") continue
    split(rl[i], f, "::")
    rword[i] = f[1]; rkind[i] = f[2]; rfield[i] = f[3]; rre[i] = f[4]; rwhy[i] = f[5]
    rneg[i] = 0
    if (substr(rfield[i], 1, 1) == "!") { rneg[i] = 1; rfield[i] = substr(rfield[i], 2) }
  }
  nrules = n
  nkinds = 0; nwords = 0
  if (kinds != "") { nkinds = split(kinds, kk, ","); for (i = 1; i <= nkinds; i++) wantkind[kk[i]] = 1 }
  if (only != "")  { nwords = split(only, ww, ",");  for (i = 1; i <= nwords; i++) wantword[ww[i]] = 1 }
}
function inlist(what, list,   m, a, i) {
  if (list == "*") return 1
  m = split(list, a, ",")
  for (i = 1; i <= m; i++) if (a[i] == what) return 1
  return 0
}
{
  path = $1; line = $2; kind = $3; word = $4; match_ = $5; token = $6; text = $7
  # A word inside quotes or backticks on the line is named, or quoted from
  # something that says it, rather than used: an odd number of either mark
  # before it means the word sits inside a quoted span.
  # The occurrence judged is the first one that stands as a whole word:
  # a test named TestGroundPicks must not decide for the Props.Ground
  # cited in backticks later on the same line.
  quoted = "no"
  qpos = 0; qfrom = 1
  while ((qp = index(substr(text, qfrom), match_)) > 0) {
    qp += qfrom - 1
    qpre = (qp > 1) ? substr(text, qp - 1, 1) : " "
    qpost = substr(text, qp + length(match_), 1)
    if (qpre !~ /[A-Za-z]/ && qpost !~ /[A-Za-z]/) { qpos = qp; break }
    qfrom = qp + 1
  }
  if (qpos > 0) {
    before = substr(text, 1, qpos - 1)
    nq = gsub(/"/, "\"", before); nb = gsub(/`/, "`", before)
    if (nq % 2 == 1 || nb % 2 == 1) quoted = "yes"
  }
  if (nkinds && !(kind in wantkind)) next
  if (nwords && !(word in wantword)) next

  # The three measured frozen regions, excluded with their reason.
  why = ""
  if (path == ".github/PLAN.md" && line+0 < planfrozen+0)
    why = "The plan above the task in hand is executed history, immutable by the standing rule."
  else if (path == ".github/DOMAIN.md" && domainfrozen+0 > 0 && line+0 >= domainfrozen+0)
    why = "The Language is present tense; the decisions and the recorded dialogue below it are dated records."
  else if (path == ".github/explorations/open-rulings.md" && poolfrozen+0 > 0 && line+0 >= poolfrozen+0)
    why = "Review provenance keeps each section preamble verbatim, as a record of what a reviewer was handed."

  ctx = lc(path " " text)
  for (i = 1; i <= nrules && why == ""; i++) {
    if (!inlist(word, rword[i])) continue
    if (!inlist(kind, rkind[i])) continue
    fld = rfield[i]
    v = (fld == "path") ? lc(path) : (fld == "line") ? lc(text) : \
        (fld == "match") ? lc(match_) : (fld == "token") ? lc(token) : \
        (fld == "rawtoken") ? token : (fld == "quoted") ? quoted : ctx
    hit = (v ~ rre[i])
    if (rneg[i]) hit = !hit
    if (hit) why = rwhy[i]
  }

  split(path, p, "/"); mod = p[1]
  if (why != "") {
    if (mode == "excluded") printf "%s\t%s\t%s\t%s\t%s\t%s\n", mod, path ":" line, kind, word, match_, why
    next
  }
  if (mode == "excluded") next
  count[mod "\t" kind]++
  total[mod]++
  grand++
  printf "%s\t%s\t%s\t%s\t%s\t%s\n", mod, path ":" line, kind, word, token, text > "/dev/stderr"
}
END {
  if (mode == "excluded") exit 0
  for (key in count) print "COUNT\t" key "\t" count[key]
  for (m in total) print "TOTAL\t" m "\t" total[m]
  print "GRAND\t" grand+0
}' 2>"${TMPDIR:-/tmp}/retired-hits.$$" )
rc=$?
[ "$rc" = 0 ] || { rm -f "${TMPDIR:-/tmp}/retired-hits.$$"; exit "$rc"; }

if [ "$MODE" = excluded ]; then
  rm -f "${TMPDIR:-/tmp}/retired-hits.$$"
  printf '%s\n' "$report" | sort
  exit 0
fi

hitfile="${TMPDIR:-/tmp}/retired-hits.$$"
grand=$(printf '%s\n' "$report" | awk -F'\t' '$1 == "GRAND" { print $2 }')
grand=${grand:-0}

if [ "$MODE" = inventory ]; then
  for name in $MODULES; do
    t=$(printf '%s\n' "$report" | awk -F'\t' -v m="$name" '$1 == "TOTAL" && $2 == m { print $3 }')
    [ -n "$t" ] || continue
    echo "== $name: $t"
    for kind in identifier comment doc string; do
      c=$(printf '%s\n' "$report" | awk -F'\t' -v m="$name" -v k="$kind" \
        '$1 == "COUNT" && $2 == m && $3 == k { print $4 }')
      [ -n "$c" ] && printf '   %-11s %s\n' "$kind" "$c"
    done
    awk -F'\t' -v m="$name" '$1 == m { printf "   %s:%s: %s\n", $2, $4, $5 }' "$hitfile"
  done
  echo "check-retired-words: $grand hit(s) outside the exclusions"
  rm -f "$hitfile"
  exit 0
fi

# check
if [ "$grand" != 0 ]; then
  awk -F'\t' '{ printf "%s: %s (%s) %s\n", $2, $4, $3, $6 }' "$hitfile" >&2
  echo "check-retired-words: FAILED ($grand hit(s) outside the exclusions)" >&2
  rm -f "$hitfile"
  exit 1
fi
rm -f "$hitfile"
echo "check-retired-words: OK"
