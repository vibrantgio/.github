# Dark ramp curve fix — standalone plan

Resolves open-rulings items **144** (the 35 L\* canyon between dark
steps 400 and 500) and **145** (steps 100–400 read as one colour).
Runs independently of PLAN.md so it does not interfere with the
implementing agent working there; execute with mdplan against this
file. Foundation for the chip re-anatomy
([[m3-chip-ontology|explorations/m3-chip-ontology.md]]), but has no
dependency on any chip work in either direction.

**Module affected: `theme` only.** The behaviour change is the
`darkTones` table in `theme/tokens/seed.go` (and `hcDarkTones` steps
100–600, defined as "the default scale unchanged"). Every dark-mode
colour derives from these nine numbers at runtime; nothing else in
`theme` hardcodes the old values, and `theme` carries no goldens.

**The isolated commit (owner A/B requirement).** Task 1 lands as one
commit on theme master containing the new curve and its pinning test,
nothing else. To compare before/after: `git -C theme checkout <sha>`
vs `<sha>^`, then run the gallery or workbench — go.work resolves
theme locally, so every app flips with it. Record the sha in this
file's task 1 entry when it lands.

## Design constraints for the new curve

The nine dark L\* values must satisfy, and the new test must pin:

- Strictly monotonic 100→900 (page-ward to ink-ward), endpoints near
  the current 8 and 94.
- No canyon: against the dark 100/200 grounds, some step lands in the
  3:1 neighbourhood (non-text minimum: outlines, icons) and some in
  the 4.5:1 neighbourhood (text minimum) — the coverage light already
  has (2.65/3.99/6.16).
- No mush: adjacent steps distinguishable (current 100→400 measure
  1.12/1.18/1.44 against each other; step 200 currently equals the
  section-panel luminance exactly).
- Existing APCA gates keep passing: step 900 |Lc| ≥ 90 and step 700
  |Lc| ≥ 60 over the 100/200 grounds; every pin's on-colour |Lc| ≥ 60
  over its pin.
- Knock-on depths move deliberately, not accidentally: step 500 feeds
  Divider, FocusRing, and the container chroma read; step 100 depth
  feeds the dark pins' on-colours; the container picker walks the ramp
  nearest step 500 that reaches floor. Re-derive, eyeball in the
  gallery, and note the shifts in the commit body.
- `hcDarkTones` 100–600 updated to match the new defaults; the
  high-contrast property (each depth measures at least the default's)
  re-verified by the existing gate.

## Tasks

- [ ] 1. Reshape the dark tone curve in theme/tokens/seed.go
  Design the nine new `darkTones` values against the constraints
  above, update `hcDarkTones` 100–600 to match, add a contrast-
  coverage test in `theme/tokens` that pins the no-canyon and no-mush
  properties with measured numbers (so the splice can never reopen),
  and update the seed.go header provenance notes. All theme tests
  green. Land as **one commit** on theme master — the A/B flip
  commit — and record its sha here. Worker: gio-worker.

- [ ] 2. Regenerate the design repo token sheets
  Run `theme/cmd/vg-tokens` and commit the regenerated `design/`
  output on its master. Mechanical. Worker: gio-worker-mechanical.

- [ ] 3. Close the rulings and release
  Mark open-rulings items 144/145 resolved (and re-check 132, which
  they name) with a pointer to the flip commit; tag theme with a
  patch bump per the nested-module release procedure. Worker:
  gio-worker-mechanical.

## Out of scope

Consumer re-verification (gallery/app dark-mode review, golden
re-bakes in component repos) happens when consumers next bump theme —
for most of them that is the chip phase, which starts from this fix.
