**Frozen — do not build on this.** ADR-003 moves the typeface into the theme:
`Typography` becomes a theme token carrying a full `TextStyle` per MD3 role —
typeface, weight, size, line height, tracking — plus the face collection and a
lazily built shaper. This module's MD2 scale is superseded by it. `style` is
frozen rather than deleted, so every existing import keeps compiling through
the deprecation window; every exported symbol carries a `Deprecated:` marker
naming its `spectrum/tokens.Typography` replacement (C1.4), and the shims go
in the major bump, F3.3.

One real bug was fixed rather than inherited: `H1` and `H2` were both 96 sp —
`TextStyle.Size` is `unit.Sp`, not `unit.Dp` — where MD2's H2 is 60. They
differed only in weight, so a document using both got no size hierarchy. C1.4
set `H2` to 60. Do not copy these numbers forward.

Nothing in the design system imports `style` — that is the point of ADR-003.
Its consumers are demo mains under mvu, ivg, svg and traer, plus the workbench
applications `todos`, `iconbrowser`, `launcher` and `mindchat`, which Phase F
migrates off it.
