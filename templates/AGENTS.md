# AGENTS.md — {{REPO}}

{{ROLE}}

**Layer.** {{LAYER}} {{GRAPH}} That direction is measured rather than typed — `scripts/check-layers.sh --edges` reports the graph and `scripts/sync-agents.sh` renders these sentences from it — so correcting them here changes nothing. The other direction is measured too and deliberately not written down: the gate checks the graph both ways, but a public API's consumers are unknowable, so this file says what its module needs and never who needs it.

**Read the canonical guide before you write code against this module.** It is
the organization's one agent guide — the module inventory with current tags,
the application skeleton, the MVU loop and rx semantics, typography, and the
pitfalls that are not guessable. It lives exactly once, in `vibrantgio/.github`,
and this file links it rather than copying it:

    https://raw.githubusercontent.com/vibrantgio/.github/master/llms.txt

{{MODULES}}

{{BUILD}}

{{GOLDEN}}

{{NOTES}}
