**`PLAN.md` here is seen's own plan, not the organization's.** It covers one
refactor of the camera and viewport pipeline and every task in it is checked
off — `mdplan next PLAN.md` prints DONE, which is how to re-check that. Its
header then describes a working tree that is not the one you are in: sibling
checkouts directly under `~/code/w/vibrantgio` with no repository at that
root, wired by a `go.work` it says is missing. Both halves are wrong now. That
root is the `vibrantgio/.github` repository, the clones sit under its
`.repos/`, and B2.1 put a `go.work` there that wires every module in the
organization — so the paths in that header resolve to nothing. The
organization's plan lives in that root. Do not follow this one unless the task
you were handed is one of its tasks.

**`solid/` is an adaptation of `vibrantgio/csg`, not a dependency on it.** The
BSP algorithm is the same; the types are not. seen's copy is rewritten onto
`point.Point`, `face.Faces` and `transform.Transform` so that a `*Solid` is a
`seen.Object` that drops straight into a scene, and this repository requires
nothing to get it. A fix in one is not a fix in the other.
