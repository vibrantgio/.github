**The mirror harness, and the organization's first non-Go dependency.**
`mirror/` is the G1.1 golden comparison harness: it renders a bundle page in
headless Chromium (driven by chromedp), renders the corresponding Gio
component through `components/golden` with theme's `DeterministicShaper()`,
and scores the pair with a perceptual box-downscale metric
(`mirror.Distance`, threshold `mirror.Tolerance`, both calibrated from
measured pairs — the numbers live on the const). Until this package,
everything in the organization built and tested with a Go toolchain alone;
the harness adds an external browser binary, installed with
`brew install --cask chromium` and pinned by `mirror.ChromiumVersion` — the
harness asserts the binary's `--version` at startup and fails loudly on a
mismatch, so a brew upgrade is an explicit re-baseline (re-run
`TestCalibration`, update the const and `Tolerance` together), never a
silent renderer swap.

**Verdicts are read on one machine.** Rene's Mac (darwin/arm64, the machine
carrying Chromium 153.0.8008.0) is authoritative. CI cannot be: a runner
opens no headless Gio window, so the Gio half answers `t.Skipf` and a
skipped test passes — the F5.7 trap. The harness skips loudly when Chromium
or headless Gio is missing; a green run whose log shows skips is not a
verdict. `go test ./...` still passes on a Chromium-less machine by design.

**Fixtures are not bundle.** `mirror/fixtures/*.html` are embedded
calibration pages (one faithful token-built mirror, three deliberately
wrong variants) served beside the bundle in tests. `scripts/push-design.sh`
uploads exactly six paths; the fixtures are not among them and must never
be.
