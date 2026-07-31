**The reference images are golden images without a flag.** The four
`TestImage*` tests render a 1024×1024 PNG and compare its bytes against
`ref_p2d.png`, `ref_p3d.png`, `ref_s2d.png` and `ref_s3d.png`, embedded from
the repository root. No command line regenerates them; `noise_test.go`
declares

    const write_reference_image = false

and each test writes its PNG only while that constant is `true`.

Regenerating therefore takes two runs, because the bytes a test compares
against were embedded when the binary was built — before that same run
overwrote the file. Flip the constant to `true`: `go test ./...` rewrites the
four PNGs and still fails; run it again and it passes against what it just
wrote. Look at the images, flip the constant back to `false`, confirm the
tests are still green, and say in the commit that you moved them. Leaving it
`true` makes the tests self-approving.
