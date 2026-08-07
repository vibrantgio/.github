**`./...` has never been able to carry `-golden.update` here**, though this
file claimed it could until F5.5. `internal/lint` stores no goldens and never
links the harness, so its test binary rejects a flag it was never told about
and the whole run fails before a single image is written. Name the three
packages — `go test . ./highlight ./svgimage -golden.update` — as the Golden
images section above does.

F5.5 deleted `markdown/internal/golden`, this repository's copy of the shared
harness — one of twenty-nine in the organization.
