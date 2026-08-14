#!/usr/bin/env bash
# push-design.sh — regenerate the Vibrant Gio design bundle and push it to Claude Design.
#
# Claude Design project: "Vibrant Gio"
#   projectId: da0b9b0d-09d0-4497-9762-0684e531b5af
#   (also recorded in scripts/design-project.txt)
#
# DesignSync is a Claude-session tool, not a CLI: no `designsync` binary exists.
# This script performs the local half (regenerate the sibling design
# repository's bundle from theme) and then
# prints the exact DesignSync sequence for the Claude agent running it to execute.
# Later plan phases invoke this script from Claude sessions, which carry the tool.
#
# Usage: scripts/push-design.sh   (from the .github plan root)
set -euo pipefail

PLAN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME="$PLAN_ROOT/../theme"
DESIGN="$PLAN_ROOT/../design"
PROJECT_ID="$(head -1 "$PLAN_ROOT/scripts/design-project.txt" | awk '{print $1}')"

echo "==> Regenerating $DESIGN from theme/cmd/vg-tokens"
(cd "$THEME" && go run ./cmd/vg-tokens -out "$DESIGN")

echo "==> Regenerated tree vs committed copy:"
git -C "$DESIGN" status --porcelain || true

cat <<EOF

==> Now push with the DesignSync tool (Claude session step — no CLI exists):
    1. DesignSync finalize_plan:
         projectId: $PROJECT_ID
         localDir:  $DESIGN
         writes:    ["readme.md", "theme.json", "styles.css", ".design-sync/conventions.md", "foundations/*.html", "components/*.html", "fonts/*"]
         deletes:   []
       -> returns a planId (the plan is single-use; re-run finalize_plan for every push)
    2. DesignSync write_files with that planId, uploading via localPath:
         readme.md, theme.json, styles.css,
         .design-sync/conventions.md (hand-authored, G3.1 — inlined into the
         design agent's system prompt),
         foundations/color.html, foundations/type.html, foundations/layout.html,
         components/buttons.html, components/cards.html,
         components/dialog.html, components/forms.html,
         components/navigation.html, components/table.html,
         fonts/roboto-regular.ttf, fonts/roboto-medium.ttf,
         fonts/robotomono-regular.ttf and both fonts/LICENSE-* files
    3. Verify: DesignSync list_files shows every path; spot-check with get_file.
    4. Ask Rene to poke the design system once in the claude.ai chat (open it
       and make any trivial edit or request). The pane renders cards and
       resolves brand fonts from _ds_manifest.json, which only the app's own
       self-check compiles — API uploads never trigger it. Until the poke,
       new pages show no cards and new fonts stay "missing", however correct
       the uploaded files are. Verified empirically at G1.1-time: uploads
       changed nothing in the manifest; one chat-side poke rebuilt it.
EOF
