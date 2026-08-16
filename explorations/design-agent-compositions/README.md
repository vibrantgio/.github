# Design-agent compositions — the validation record

Archived copies of the screens the claude.ai design agent composed during the
two validation rounds, kept because the live project deletes its anti-pattern
examples (see below) and the before/after pair is the evidence.

- `app-shell-g32.html` — the first validation round (2026-08-15). Faults
  recorded at the time: an inline-styled status tag, an invented `.table-wrap`
  frame, grounds on `--color-neutral-100` instead of the semantic pin.
- `incident-review-i23.html` — the second round (2026-08-16), after status
  chips entered the vocabulary and the conventions gained the three rules.
  The status fault is gone — `.tag.error/.warning/.success` composed
  correctly in three contexts. The frame and the ramp-step ground recurred,
  both **near-verbatim identical** to the first screen's rules — evidence of
  copying from the surviving example rather than of the conventions failing.
  Consequence: the first screen was deleted from the live project; project
  files are what composition sessions copy from, so an anti-pattern example
  is an active contaminant, not a harmless record.
