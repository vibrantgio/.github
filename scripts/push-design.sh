#!/usr/bin/env bash
# push-design.sh — regenerate the Vibrant Gio design bundle and push it to Claude Design.
#
# Claude Design project: "Vibrant Gio"
#   projectId: da0b9b0d-09d0-4497-9762-0684e531b5af
#   (also recorded in scripts/design-project.txt)
#
# DesignSync is a Claude-session tool, not a CLI: no `designsync` binary exists.
# This script performs the local half (regenerate design/ from spectrum) and then
# prints the exact DesignSync sequence for the Claude agent running it to execute.
# Later plan phases invoke this script from Claude sessions, which carry the tool.
#
# Usage: scripts/push-design.sh   (from the plan root, /Users/rene/code/w/vibrantgio)
set -euo pipefail

PLAN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPECTRUM="$PLAN_ROOT/.repos/spectrum"
DESIGN="$PLAN_ROOT/design"
PROJECT_ID="$(head -1 "$PLAN_ROOT/scripts/design-project.txt" | awk '{print $1}')"

echo "==> Regenerating $DESIGN from spectrum/cmd/vg-tokens"
(cd "$SPECTRUM" && go run ./cmd/vg-tokens -out "$DESIGN")

echo "==> Regenerated tree vs committed copy:"
git -C "$PLAN_ROOT" status --porcelain -- design/ || true

cat <<EOF

==> Now push with the DesignSync tool (Claude session step — no CLI exists):
    1. DesignSync finalize_plan:
         projectId: $PROJECT_ID
         localDir:  $DESIGN
         writes:    ["readme.md", "theme.json", "styles.css", "foundations/*.html"]
         deletes:   []
       -> returns a planId (the plan is single-use; re-run finalize_plan for every push)
    2. DesignSync write_files with that planId, uploading via localPath:
         readme.md, theme.json, styles.css,
         foundations/color.html, foundations/type.html, foundations/layout.html
    3. Verify: DesignSync list_files shows all six paths; spot-check with get_file.
EOF
