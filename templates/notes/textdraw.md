**Superseded for typography, still live as a drawing primitive.** ADR-003
moved the typeface into the theme: `theme/tokens.Typography` carries a full
`TextStyle` per MD3 role. Since it landed, this module's `TextStyle` is no
longer the type anything in the design system should be styling text with —
`style`, its only in-org library consumer, is frozen by the same ADR.

Read that as a warning against new dependencies, not as a removal: ADR-003
freezes `style` and says nothing about freezing `textdraw`. Phase C came and
went without touching this module; `MeasureText`, `FillText` and `FillLabel`
still have no replacement in the design system — they draw straight onto a
`*text.Shaper`, below the widget layer — and workbench applications still call
them directly. No phase has scheduled a replacement surface, so treat this
module as staying rather than as waiting to be removed.
