**`PLAN.md` here is seen's own plan, not the organization's.** It covers one
refactor of the camera and viewport pipeline, and its header describes a
workspace that no longer exists — sibling checkouts directly under
`~/code/w/vibrantgio`, wired together by a `go.work` that is not there. The
organization's plan lives in `vibrantgio/.github`. Do not follow this one
unless the task you were handed is one of its tasks.

**`solid/` is an adaptation of `vibrantgio/csg`, not a dependency on it.** The
BSP algorithm is the same; the types are not. seen's copy is rewritten onto
`point.Point`, `face.Faces` and `transform.Transform` so that a `*Solid` is a
`seen.Object` that drops straight into a scene, and this repository requires
nothing to get it. A fix in one is not a fix in the other.
