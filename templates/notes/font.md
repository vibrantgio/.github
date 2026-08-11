**`notosansmono` is optional, and keeping it optional is the design.** It is
Noto Sans Mono Regular — one weight — carrying the arrows, box drawing, block
elements, geometric shapes, punctuation and operators Roboto and Roboto Mono
lack. Do **not** add it to `tokens.DefaultTypography.Faces`: theme's default
shaper leaves system fonts on, so a desktop already covers those characters and
more, and putting this face in the default would link 596 KB into every binary
in the organization to duplicate the platform. It is for the case with no
platform to fall back to — a container, a kiosk — and for a test that
legitimately draws a symbol while keeping its faces pinned. Both append it the
same way, in one line:

    tokens.DefaultTypography.WithFaces(notosansmono.FontFace())

The package comment carries the measured coverage table and the file's
provenance and SHA-256; `notosansmono_test.go` asserts that table block by
block, so change the TTF and the test tells you what moved.
