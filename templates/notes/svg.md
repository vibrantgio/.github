**`driver/seen` does not build from a clean checkout**, and did not before
this file existed. Its `go.sum` pins `github.com/vibrantgio/seen/context/gio
v0.0.7` to a hash that no published form of that module produces, so the build
stops with a checksum mismatch before compiling anything. `workbench/launcher`
is stuck on the identical line.

Nothing local is missing and no push closes it: the tag on GitHub, the module
proxy and a `GOPROXY=direct` fetch all agree with one another and all disagree
with `go.sum`, which records content that was never published. Dropping the
two `seen/context/gio v0.0.7` lines and re-running `go mod tidy` restores the
build — `go mod tidy` on its own cannot, because it verifies before it
rewrites. Do that deliberately, in a change that says so, rather than as a
side effect of unrelated work.

The root module and the other three drivers are green.
