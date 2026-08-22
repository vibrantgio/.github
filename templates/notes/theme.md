**Two shapers, and the choice is yours to make.** `tokens.Typography` builds
both, cached in separate fields so neither can hand back the other's:

- `Shaper()` — the system fallback is **on**. This is what applications and
  library components draw with. The embedded faces answer first; the platform's
  fonts answer for everything they lack, which is every arrow, box-drawing
  character and dingbat, because Roboto and Roboto Mono carry none of them.
  Never disable system fonts here to make an output stable — that is the F4.2
  defect, and it ships tofu to every user.
- `DeterministicShaper()` — system fonts **off**, the collection pinned. This
  is what a golden or pixel test draws with, and the reason it exists: a test
  that says which faces it wants cannot drift when the default changes.

Widen the collection with `WithFaces`, which copies and clears both caches:
`tokens.DefaultTypography.WithFaces(notosansmono.FontFace())`. That is how a
test that legitimately draws an arrow stays deterministic, and how an
application that cannot rely on system fonts — a container, a kiosk — ships its
own symbol coverage. The face is optional and is not in
`DefaultTypography.Faces`; see ADR-003.

**Kept `"mono"`.** `brand.Brand` carries `Mono`, persisted as `"mono"` in
`theme.json` beside `"seed"` and `"base"`. Empty, absent, or unknown falls
back to Roboto Mono. `"JetBrains Mono"` restyles `Typography.Code` and
appends the four JetBrains faces via `system.WithTypography`;
`Brand.Options()` includes that option so every app that already does
`LiveTheme(..., brand.Kept().Options()...)` picks it up. Default
typography, goldens, and `DeterministicShaper` stay on Roboto Mono.

**Line height means the line box, and `typeset` is how.**
`tokens.TextStyle.LineHeight` is the CSS thing — the height of one line box,
leading split evenly around the ink — and `gioui.org/widget.Label` does not
deliver it. Gio gives the first line its own ascent plus descent and spends the
line height only on the gap to the next, so a `MaxLines: 1` label measures the
same at every line height there is. `theme/typeset` wraps `widget.Label` and
adds the missing leading; every component in the org that draws a role's text
lays it out through `typeset.Layout`. `theme/export` writes the same number
into `--font-<role>-line-height`, so the two surfaces state one fact.

The consequence for sizing: `Density.ControlHeight` is a **floor**, not a
height. A control draws `max(ControlHeight, lineBox + 2×PaddingY)`, so a
Comfortable text field in BodyLarge is 40 dp against a 36 dp floor while a
Comfortable button in LabelLarge is exactly 36.

**Golden images.** None, and the absence above is that fact rather than an
omission: `sync-agents.sh` renders a Golden images section only for a clone
that has a `testdata/golden/` directory, and `find . -type d -name golden`
here finds none. theme stores no rendered output — it computes colour, type
and layout values and asserts on numbers. The harness the repositories that do
render share is `components/golden`.
