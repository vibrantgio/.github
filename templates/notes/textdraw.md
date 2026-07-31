**Superseded for typography, still live as a drawing primitive.** ADR-003
moves the typeface into the theme: `Typography` becomes a theme token carrying
a full `spectrum/tokens.TextStyle` per MD3 role. Once that lands, this
module's `TextStyle` is no longer the type anything in the design system
should be styling text with — `style`, its only in-org library consumer, is
frozen by the same ADR.

Read that as a warning against new dependencies, not as a removal: ADR-003
freezes `style`, and says nothing about freezing `textdraw`. Nothing in
Phase C touches this module, `MeasureText`, `FillText` and `FillLabel` have no
replacement in the design system — they draw straight onto a `*text.Shaper`,
below the widget layer — and three workbench applications call them directly
today. F2.3 revisits this note once Phase C has shipped and the real
replacement surface is known.
