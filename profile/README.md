# VibrantGio

A design system and UI stack for [Gio](https://gioui.org) — immediate-mode GUI in pure Go, reactive at the core: rx observables drive state, themes, and rendering.

## Stack

| Repo | Layer |
| --- | --- |
| [mvu](https://github.com/vibrantgio/mvu) | Model-View-Update runtime: rx-based reactive core, MessageOp widget protocol |
| [spectrum](https://github.com/vibrantgio/spectrum) | Reactive theme runtime: live OS dark-mode and accent tracking, animated theme transitions |
| [prism](https://github.com/vibrantgio/prism) | Component foundation: themed, accessible widgets with typed design tokens |
| [cadence](https://github.com/vibrantgio/cadence) | Pattern library: application shells, tables, modals, popovers, tabs, toasts, navbars |
| [pulse](https://github.com/vibrantgio/pulse) | Effects layer: tweens, spring physics, glow, depth, coordinated motion |
| [workbench](https://github.com/vibrantgio/workbench) | Architecture docs, llm.txt, and complete example apps |

## Text & drawing

| Repo | |
| --- | --- |
| [font](https://github.com/vibrantgio/font) | Roboto in five weights, packaged for Gio |
| [style](https://github.com/vibrantgio/style) | Typography scale (H1–H6, Body, Button, Caption), wired to Roboto |
| [textdraw](https://github.com/vibrantgio/textdraw) | Low-level text drawing: glyph-level control, alignment, label backgrounds |
| [backdrop](https://github.com/vibrantgio/backdrop) | Solid colour fill widget |
| [gradient](https://github.com/vibrantgio/gradient) | Linear gradient fill widget |
| [circle](https://github.com/vibrantgio/circle) | Mathematically precise circles via Bézier approximation |

## Graphics & geometry

| Repo | |
| --- | --- |
| [ivg](https://github.com/vibrantgio/ivg) | Compact binary format for simple vector graphics |
| [svg](https://github.com/vibrantgio/svg) | SVG parsing and rendering, with a Gio driver |
| [seen](https://github.com/vibrantgio/seen) | 3D scenes rendered to SVG or Gio |
| [csg](https://github.com/vibrantgio/csg) | Constructive solid geometry on meshes using BSP trees |
| [kiwi](https://github.com/vibrantgio/kiwi) | Cassowary constraint-solving algorithm |
| [noise](https://github.com/vibrantgio/noise) | Perlin and Simplex noise, 2D/3D |
| [traer](https://github.com/vibrantgio/traer) | Particle-system physics engine |
