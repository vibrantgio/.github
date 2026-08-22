**`notosansmono` is optional, and keeping it optional is the design.** It is
Noto Sans Mono Regular — one weight — carrying the arrows, box drawing, block
elements, geometric shapes, punctuation and operators Roboto and Roboto Mono
lack. Do **not** add it to `tokens.DefaultTypography.Faces`: the default
typography's shaper leaves system fonts on, so a desktop already covers those
characters and more, and putting this face in the default would link 596 KB
into every binary that draws text to duplicate the platform. It is for the case with no
platform to fall back to — a container, a kiosk — and for a test that
legitimately draws a symbol while keeping its faces pinned. Both append it the
same way, in one line:

    tokens.DefaultTypography.WithFaces(notosansmono.FontFace())

The package comment carries the measured coverage table and the file's
provenance and SHA-256; `notosansmono_test.go` asserts that table block by
block, so change the TTF and the test tells you what moved.

**`notocoloremoji` is optional, and keeping it optional is the design.** It is
Noto Color Emoji Regular — one weight — carrying the CBDT/PNG color emoji
the rest of the collection cannot resolve. Do **not** add it to
`tokens.DefaultTypography.Faces`: putting 9.9 MB in the default would parse
that TTF on every golden and every pinned shaper in the organization, and no
existing golden contains emoji. Gio's system fallback does not supply a
color-emoji face either, so a document that draws emoji appends this one
the same way as the symbol face:

    tokens.DefaultTypography.WithFaces(notocoloremoji.FontFace())

Nothing names `"Noto Color Emoji"` as a role's Typeface; the shaper reaches
it only as fallback. The live stream wears it: `Typography.WithEmoji` /
`EmojiTypography()` append this face, and `LiveTheme` / `Brand` emit that
value. Goldens stay on `DefaultTypography`. The package comment records
the file's SHA-256, that the face is one 109 ppem CBDT/PNG strike, and the
measured ZWJ behaviour (go-text applies the face's GSUB; this package does
not compose sequences).
