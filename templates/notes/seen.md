**`PLAN.md` here is seen's own plan, not the organization's.** It covers one
refactor of the camera and viewport pipeline and every task in it is checked
off — `mdplan next PLAN.md` prints DONE, which is how to re-check that. Its
header describes sibling checkouts directly under the workspace root with no
repository at that root — which was wrong for the whole span when the clones
hid under `.github`'s gitignored `.repos/` (B2.1 through G0E.1), and this note
said so. G0E.1 flattened the tree back to exactly that shape, so the header's
paths resolve again; only its claim that `go.work` is missing stays wrong —
`clone-all.sh` generates one at the workspace root. The organization's plan
lives in the `.github` sibling. Do not follow this one unless the task
you were handed is one of its tasks.

**`solid/` is an adaptation of `vibrantgio/csg`, not a dependency on it.** The
BSP algorithm is the same; the types are not. seen's copy is rewritten onto
`point.Point`, `face.Faces` and `transform.Transform` so that a `*Solid` is a
`seen.Object` that drops straight into a scene, and this repository requires
nothing to get it. A fix in one is not a fix in the other.
