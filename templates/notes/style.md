**Frozen — do not build on this.** ADR-003 moved the typeface into the theme:
`theme/tokens.Typography` is a theme token carrying a full `TextStyle` per
MD3 role — typeface, weight, size, line height, tracking — plus the face
collection and a lazily built shaper. This module's MD2 scale is superseded by
it. `style` was frozen rather than deleted, so every existing import still
compiles; every exported symbol carries a `Deprecated:` marker naming its
`theme/tokens.Typography` replacement (C1.4). F3.3's major-bump sweep took
the alias shims out of prism and spectrum and deliberately left this module
standing — that is ADR-003's arrangement, not an oversight to finish.

One real bug was fixed rather than inherited: `H1` and `H2` were both 96 sp —
`TextStyle.Size` is `unit.Sp`, not `unit.Dp` — where MD2's H2 is 60. They
differed only in weight, so a document using both got no size hierarchy. C1.4
set `H2` to 60. Do not copy these numbers forward.

Do not add a new import of this module anywhere — that freeze is ADR-003's
point rather than an accident. Nothing here says who imports it today, and
nothing above does either: a public API's consumers are unknowable, and the
list that used to live in this note was wrong within a phase of being written,
naming migrated-off callers and one that had never imported it at all.
