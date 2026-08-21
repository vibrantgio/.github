# Vibrant Gio

Vibrant Gio is a design system for native desktop applications on macOS, Windows
and Linux, written in pure Go on [Gio](https://gioui.org). An application is a
Model-View-Update loop over [reactivego/rx](https://github.com/reactivego/rx)
observables — state, theme and rendering are all driven reactively — and the
design decisions follow Material Design's *generative* ideas, design tokens and
semantic roles rather than a transcription of the Android widget set.

<p>
  <img src="launcher-dark.png" alt="Workbench launcher in dark mode — app cards on a live seen 3D field" width="49%">
  <img src="launcher-light.png" alt="Workbench launcher in light mode" width="49%">
</p>
<p>
  <img src="mindchat-dark.png" alt="MindChat in dark mode — streaming chat client with providers, model picker, and markdown replies with highlighted code" width="49%">
  <img src="mindchat-light.png" alt="MindChat in light mode" width="49%">
</p>

Two of the example applications, each captured in the OS dark and light
appearance. Every window re-themes live when the system appearance switches —
these four shots are one running process per app with the appearance flipped
underneath it. The entire palette is derived from a single seed colour.

## Start here

- **[workbench/todos/](https://github.com/vibrantgio/workbench/tree/master/todos)** —
  the smallest complete application, and the one to read before writing your
  own. Six larger references sit beside it in
  [workbench](https://github.com/vibrantgio/workbench): `sitedocs`, `feeds`,
  `vaultview`, `mindchat`, `iconbrowser` and `launcher`.
- **[llms.txt](https://raw.githubusercontent.com/vibrantgio/workbench/master/llms.txt)** —
  the guide for writing Vibrant Gio applications, and the file to hand a
  coding assistant. Module inventory with current versions, the application
  skeleton, MVU and rx semantics, typography, and the pitfalls that are not
  guessable.
- **[design/DESIGN.md](https://github.com/vibrantgio/design/blob/master/DESIGN.md)** —
  the architecture and why it is shaped this way: the layering, the generative
  colour model, the deliberate desktop divergences from Material Design 3, and
  the decision records.

## The stack

Nineteen modules, one per repository, layered: a module may import only
modules in a lower tier, plus anything in the support row, and CI enforces
that direction.

| Tier | Module | What it is |
| --- | --- | --- |
| 0 | [mvu](https://github.com/vibrantgio/mvu) | Model-View-Update runtime for Gio: `NewWindow`, the update/view loop, messages, commands, and the `MessageOp` widget protocol |
| 0 | [font](https://github.com/vibrantgio/font) | Roboto and Roboto Mono packaged as Gio faces — six weights, Thin to Black, regular and italic, plus the mono face for code |
| 0 | [style](https://github.com/vibrantgio/style) | Frozen: the old MD2 type scale and `FontFaces()`, superseded by theme's Typography — kept for existing consumers, never added to a new app |
| 0 | [textdraw](https://github.com/vibrantgio/textdraw) | Low-level text drawing: glyph-level control, measurement, alignment, label backgrounds |
| 0 | [backdrop](https://github.com/vibrantgio/backdrop) | Solid colour fill widget |
| 0 | [gradient](https://github.com/vibrantgio/gradient) | Linear gradient fill widget |
| 0 | [circle](https://github.com/vibrantgio/circle) | Mathematically precise circles via Bézier approximation |
| 1 | [theme](https://github.com/vibrantgio/theme) | The theme runtime and every design token: colour ramps and pins derived from one seed by the CIELAB/OKLCh engine, Typography, Density, Motion, Elevation; live OS dark-mode, accent-colour and accessibility tracking, preference persistence, window integration, token export |
| 2 | [components](https://github.com/vibrantgio/components) | Component foundation: button, input, list, richtext, scrollbar, icon, layout, keyed identity, initial values, cache, coordination, bench |
| 3 | [effects](https://github.com/vibrantgio/effects) | Effects layer: tween, spring, springbutton, transition, glow, depth, blur, motion, and a shared animation conductor |
| 4 | [patterns](https://github.com/vibrantgio/patterns) | Pattern library: shell, navbar, sidebar, table, pagination, tabs, modal, alert, popover, tooltip, toast, card, accordion, breadcrumb, hero, feature, pricing, testimonial |
| 4 | [markdown](https://github.com/vibrantgio/markdown) | GFM document rendering on components widgets, with chroma syntax highlighting and SVG images |
| — | [ivg](https://github.com/vibrantgio/ivg) | IconVG: compact binary format for vector icons, with a converter for the Material Design icon set |
| — | [svg](https://github.com/vibrantgio/svg) | SVG parsing and rendering, with Gio, raster, PDF and seen drivers |
| — | [seen](https://github.com/vibrantgio/seen) | 3D scene graph rendered to SVG or Gio |
| — | [csg](https://github.com/vibrantgio/csg) | Constructive solid geometry on meshes using BSP trees |
| — | [kiwi](https://github.com/vibrantgio/kiwi) | Cassowary constraint solver, with a Gio layout binding |
| — | [noise](https://github.com/vibrantgio/noise) | Perlin and Simplex noise, 2D and 3D |
| — | [traer](https://github.com/vibrantgio/traer) | Particle-system physics: springs, attractions, Verlet integration |

Ten further modules live in subdirectories of the repositories above, such as
`ivg/raster/gio` and `svg/driver/pdf` —
[llms.txt](https://raw.githubusercontent.com/vibrantgio/workbench/master/llms.txt)
lists them all with current versions.

Two repositories hold no module in the table:
[workbench](https://github.com/vibrantgio/workbench), the seven example
applications and the canonical guide, and
[design](https://github.com/vibrantgio/design), the exported token bundle
together with the architecture rationale. Every module in the organization
builds on gioui.org v0.10.1, github.com/reactivego/rx v0.3.0 and Go 1.25.1.
