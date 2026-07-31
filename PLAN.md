# VibrantGio — one coherent design system

Turn twenty-one loosely related repositories into a single design system for
native desktop apps on macOS/Windows/Linux, built on Gio, whose design
decisions are directed by Material Design's *generative* ideas reimagined for
native Go — and make that system legible to a coding assistant that is pointed
at nothing more than `github.com/vibrantgio`.

**Working tree.** This repo (`vibrantgio/.github`) is the plan root and the org
front door. Every other repo is cloned to `.repos/<name>` beneath it and is
gitignored. Work happens inside `.repos/<name>`; the plan and the canonical
agent guide live here at the root.

**One task, one commit.** Do the steps of exactly one `####` task, then commit
in each repo you touched with the task heading in the subject line and the
trailer `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`.

**Green before commit.** In every module you touched: `go build ./... && go
test ./...` must pass. Golden-image tests are part of that — when a change
legitimately moves pixels, regenerate the goldens *within the same task* and
say so in the commit body. Never commit red.

**Never push without asking.** These are public repositories. Commit locally;
pushing is Rene's call, made explicitly, at goal boundaries.

**Stop if a task is too big.** Tasks are cut to fit ~100K tokens of Opus 5 at
high effort. If one turns out larger than that, check off what you genuinely
finished, commit it, and report that the task needs splitting — with a proposed
split. Do not push through. A task that silently runs for hours is the failure
mode this plan exists to prevent.

## Phase A: Front door — make the org legible to a coding assistant

Nothing here changes a line of library code. It fixes the reason an assistant
pointed at the org currently finds nothing: the canonical guide is buried one
repo deep and unlinked, twelve repos have no README at all, and no module root
has a `doc.go`, so pkg.go.dev is blank for the entire stack.

Phase A is self-contained and lands value immediately. Do not let later phases
block it.

![[#ADR-004: The canonical agent guide lives here]]

### G-A1: Establish the guide and the front door

All work in this repo unless a step says otherwise.

#### A1.1: Set up the working tree

Create the local layout every later task assumes.

- [ ] Add `.gitignore` with `.repos/` and `.DS_Store`.
- [ ] Write `scripts/clone-all.sh`: clone all twenty sibling repos into `.repos/`, skipping any already present, and `git pull --ff-only` those that are.
- [ ] Run it; confirm twenty directories exist under `.repos/`.
- [ ] Record in the script's header comment that `.github` itself is the parent directory, not a clone.

#### A1.2: Move llms.txt here and correct its inventory

`workbench/llms.txt` is the only agent guide in the org. Promote it to this
repo's root, where the org front door can link it.

- [ ] `git mv` the file content into `./llms.txt` (copy across repos; it is a new file here).
- [ ] Correct the module inventory table against the real tags: mvu v0.4.1, prism v0.0.9, spectrum v0.0.3, pulse v0.0.3, cadence v0.2.0, markdown v0.0.3, seen v0.0.5, traer v0.0.7, svg v0.0.6, ivg v0.1.4, backdrop v0.0.2, noise v0.0.2, style v0.0.3, textdraw v0.0.3, font v0.0.3, circle v0.0.3, kiwi v0.0.5, gradient v0.0.2, csg untagged.
- [ ] Add a header line naming this file the single canonical guide and giving its raw URL.
- [ ] In `.repos/workbench`, replace `llms.txt` with a three-line pointer to the canonical URL, and update `workbench/README.md`'s reference to it. Commit in workbench.

#### A1.3: Give the guide a typography section

The guide is why assistants ship gofont apps: it lists `style` and `font` in the
inventory but omits them from the bootstrap and the minimal `go.mod`, and has no
typography section at all. Document today's correct practice — the one `todos/`
already follows. Phase C replaces this section wholesale.

- [ ] Add a `## Typography` section: build one `*text.Shaper` from `style.FontFaces()` and pass it to every component's `Shaper` prop.
- [ ] State the rule plainly: never `gofont`, never `text.NoSystemFonts()` with the Go collection, never append the two.
- [ ] Note that components default to gofont internally when `Shaper` is nil, so the prop is not optional today.
- [ ] Add `github.com/vibrantgio/style` and `github.com/vibrantgio/font` to the minimal `go.mod` block.
- [ ] Point at `todos/view.go` as the correct reference and name `feeds`/`watchlist`/`sitedocs`/`mindchat` as known-wrong until Phase F.

#### A1.4: Rewrite the org profile README

`profile/README.md` is what renders on the organization home page. Today it
opens with screenshots and never mentions the guide, DESIGN.md, or where to
start.

- [ ] Open with a one-paragraph statement of what VibrantGio is and what it targets.
- [ ] Immediately follow with a **Start here** block linking `llms.txt`, `workbench/DESIGN.md`, and `workbench/todos/`.
- [ ] Keep the layered stack table; correct it to the layer order in ADR-001 and mark layers that are mid-migration.
- [ ] Keep the screenshots, moved below the entry points.

![[#ADR-001: Spectrum is the foundation, not a consumer]]

#### A1.5: Write this repo's root README

The repo root is separate from `profile/`. It currently has no README at all.

- [ ] Explain that this repo holds three things: the org profile page, `PLAN.md`, and the canonical `llms.txt`.
- [ ] Link all three, plus `scripts/clone-all.sh`.
- [ ] Note that `profile/README.md` — not this file — is what renders on the org page.

### G-A2: Put an AGENTS.md in every repo

`AGENTS.md` at a repo root is the file an assistant finds without being told.
Twenty repos, none have one. This is the single highest-leverage change in the
plan.

![[#The repo doc contract]]

#### A2.1: Author the template and the sync script

- [ ] Write `templates/AGENTS.md` here: ~15 lines — what this repo is, which layer it sits in, the canonical guide's raw URL, the build/test command, and "read the guide before writing code against this module".
- [ ] Make the layer line and the one-sentence role substitutable per repo.
- [ ] Write `scripts/sync-agents.sh` that renders the template into a named repo under `.repos/` and reports a diff without committing.
- [ ] Dry-run it against `.repos/prism` and check the output reads well.

#### A2.2: Roll out to the core stack

- [ ] Render `AGENTS.md` into mvu, prism, spectrum, pulse, cadence.
- [ ] Set each one's role line from the layer table in ADR-001.
- [ ] Commit in each of the five repos.

#### A2.3: Roll out to workbench, markdown and the text/draw repos

- [ ] Render into workbench, markdown, font, style, textdraw, backdrop, gradient, circle.
- [ ] For `style` and `textdraw`, add the deprecation note from ADR-003 — they are superseded by the Phase C typography token.
- [ ] Commit in each of the eight repos.

#### A2.4: Roll out to the graphics and geometry repos

These are support libraries, not design-system layers; their AGENTS.md says so.

- [ ] Render into ivg, svg, seen, csg, kiwi, noise, traer.
- [ ] Mark each as a support library that the design system consumes but that does not depend on it.
- [ ] Commit in each of the seven repos.

### G-A3: READMEs and package docs

Twelve repos have no README; six core modules have no `doc.go` anywhere, so
pkg.go.dev shows nothing for the whole stack. Describe the layer and the role —
not the API surface, which Phases B–E will change.

![[#The repo doc contract]]

#### A3.1: prism README

- [ ] Write `.repos/prism/README.md` per the doc contract.
- [ ] List the packages and one line each: a11y, bench, button, cache, coordination, icon, initial, input, keyed, layout, list, richtext, scrollbar, theme, tokens.
- [ ] Note that `theme` and `tokens` move to spectrum in Phase B and will remain as aliases.
- [ ] Commit in prism.

#### A3.2: prism package docs

- [ ] Add a `doc.go` with a package comment to each prism package that lacks one: a11y, bench, button, cache, coordination, initial, input, keyed, layout, list, richtext, scrollbar, theme, tokens.
- [ ] Two to five sentences each: what it is, when to reach for it, what it assumes.
- [ ] `go build ./... && go test ./...`; commit in prism.

#### A3.3: cadence README

- [ ] Write `.repos/cadence/README.md` per the doc contract.
- [ ] Group the eighteen packages by kind — shells, data, overlays, marketing — with one line each.
- [ ] Commit in cadence.

#### A3.4: cadence package docs

- [ ] Add `doc.go` to each of the eighteen: accordion, alert, breadcrumb, card, feature, hero, modal, navbar, pagination, popover, pricing, shell, sidebar, table, tabs, testimonial, toast, tooltip.
- [ ] `go build ./... && go test ./...`; commit in cadence.

#### A3.5: spectrum README and package docs

- [ ] Write `.repos/spectrum/README.md` per the doc contract, describing the foundation role it takes in Phase B.
- [ ] Add `doc.go` where missing across preferences, system, transition, window.
- [ ] State plainly in the README that palette injection does not exist yet and arrives in Phase D.
- [ ] `go build ./... && go test ./...`; commit in spectrum.

#### A3.6: pulse README and package docs

- [ ] Write `.repos/pulse/README.md` per the doc contract.
- [ ] Add `doc.go` where missing across conductor, depth, glow, motion, spring, springbutton, tween.
- [ ] Record the rule that pulse components are explicit variants of prism components, never global decorators.
- [ ] `go build ./... && go test ./...`; commit in pulse.

#### A3.7: mvu and markdown package docs

Both have READMEs already; neither has package docs.

- [ ] Add `doc.go` to the mvu root package and to markdown's root, highlight, and svgimage.
- [ ] Refresh markdown's README to link the canonical guide.
- [ ] `go build ./... && go test ./...`; commit in both.

#### A3.8: text and drawing repo READMEs

Six small repos, a one-pager each — what it does, its one type or function, and
where it sits.

- [ ] Write READMEs for font, style, textdraw, gradient, circle.
- [ ] Expand backdrop's one-line README to the same shape.
- [ ] In `style` and `font`, state that they are not yet wired into the component stack and that Phase C fixes this.
- [ ] Commit in each of the six repos.

#### A3.9: support library READMEs

- [ ] Write READMEs for seen and kiwi.
- [ ] Expand svg's stub README to the doc contract's shape.
- [ ] Leave ivg, csg, noise, traer READMEs as they are; add only the canonical-guide link.
- [ ] Commit in each repo touched.

## Phase B: Repair the module graph

Mechanical, low-risk, and it unblocks everything after it. Today `spectrum`
(theme runtime) depends on `prism` (components), so the theme sits *above* what
it themes and no application can supply a palette; `prism` and `pulse` form a
module cycle; and three different Gio versions are in play across the stack.

Type aliases make the package moves non-breaking — every downstream repo keeps
compiling untouched.

![[#ADR-001: Spectrum is the foundation, not a consumer]]

### G-B1: Break the cycle and align versions

#### B1.1: Cut pulse out of prism

`prism/gallery/main.go` imports `pulse/springbutton`. That single demo file is
what puts `pulse` in prism's `go.mod` and closes the cycle.

- [ ] Give `prism/gallery` its own `go.mod` as a nested module requiring prism and pulse.
- [ ] Remove `github.com/vibrantgio/pulse` from prism's `go.mod`; `go mod tidy`.
- [ ] Confirm `go list -m all` in prism no longer mentions pulse.
- [ ] `go build ./... && go test ./...` in both prism and prism/gallery; commit in prism.

#### B1.2: Align the core stack on one Gio and one rx

- [ ] Set gioui.org v0.10.1 and reactivego/rx v0.3.0 in mvu, prism, spectrum, pulse, cadence, markdown.
- [ ] `go mod tidy` in each; resolve any API drift from the v0.9→v0.10 move.
- [ ] `go build ./... && go test ./...` in each of the six.
- [ ] Commit in each repo.

#### B1.3: Align the leaf repos

- [ ] Set the same Gio version in font, style, textdraw, backdrop, gradient, circle.
- [ ] `go mod tidy`, build and test each.
- [ ] Commit in each of the six repos.

### G-B2: Invert the foundation

Move the token and theme contract down into spectrum so the theme runtime is
beneath the components it themes. Alias shims keep prism's import paths alive
for one release.

#### B2.1: Move the tokens into spectrum

- [ ] Copy `prism/tokens/*.go` (including tests) to `.repos/spectrum/tokens/`.
- [ ] Keep the package name `tokens` and every exported identifier unchanged.
- [ ] `go build ./... && go test ./...` in spectrum; commit.

#### B2.2: Move the theme contract into spectrum

- [ ] Copy `prism/theme/*.go` (including tests) to `.repos/spectrum/theme/`, repointing its tokens import.
- [ ] Repoint `spectrum/system` and `spectrum/window` at the local theme package; drop the prism requirement from spectrum's `go.mod` if nothing else needs it.
- [ ] `go build ./... && go test ./...` in spectrum; commit.

#### B2.3: Leave alias shims in prism

- [ ] Replace `prism/tokens`'s bodies with type aliases and variable re-exports pointing at `spectrum/tokens`.
- [ ] Do the same for `prism/theme`.
- [ ] Mark both packages `Deprecated:` with the replacement path.
- [ ] Confirm prism, pulse, cadence and markdown all still compile with no source changes; commit in prism.

#### B2.4: Move transition into pulse

`spectrum/transition` depends on `pulse/tween`, which would make the foundation
depend on the effects layer. It is animation code; it belongs in pulse.

- [ ] Copy `spectrum/transition` to `.repos/pulse/transition`, repointing imports at `spectrum/tokens`.
- [ ] Leave a deprecated alias shim at `spectrum/transition`.
- [ ] Build and test both; commit in each.

#### B2.5: Make the layering enforceable

- [ ] Write `scripts/check-layers.sh` here: for each module, `go list -deps` and assert only the edges ADR-001 permits.
- [ ] Run it across all core modules; fix or record any violation it finds.
- [ ] Wire it into each core repo's CI workflow.
- [ ] Commit the script here and the workflow change in each repo.

## Phase C: The theme owns the typeface

The fix for the Roboto problem. `TypeScale` is fifteen `float32` sizes — there
is nowhere in the theme to put a typeface, so all seventeen `Props` structs and
118 function signatures carry a `*text.Shaper`, every one of which falls back to
`gofont.Collection()` inside library source.

![[#ADR-003: The theme owns the typeface]]

### G-C1: Define the typography token

#### C1.1: TextStyle and Typography

- [ ] In `spectrum/tokens`, add `TextStyle{Typeface, Weight, Size, LineHeight, Tracking}`.
- [ ] Add `Typography` with one `TextStyle` per MD3 role — Display/Headline/Title/Label/Body × Large/Medium/Small.
- [ ] Populate `DefaultTypography` with the MD3 metrics: sizes as today, plus the matching line heights and tracking.
- [ ] Unit-test that every role has a non-zero size, weight and line height.
- [ ] Build, test, commit in spectrum.

#### C1.2: Make Roboto the default face

- [ ] Add `Faces []font.FontFace` to `Typography`, defaulting to `vibrantgio/font/roboto.FontFaces()`.
- [ ] Add a `Shaper()` method that builds the shaper once, lazily, and caches it.
- [ ] Add `github.com/vibrantgio/font` to spectrum's `go.mod`.
- [ ] Test that the default shaper resolves Roboto for every weight the scale names.
- [ ] Build, test, commit in spectrum.

#### C1.3: Put typography in the theme

- [ ] Add `Typography rx.Observable[tokens.Typography]` to `theme.Theme`.
- [ ] Update `theme.Default()`, `theme.AutoLightDark()`, `system.LiveTheme()` and `system.FromSourceTheme()` to emit it.
- [ ] Update the prism alias shim so `prism/theme.Theme` still matches.
- [ ] Build and test spectrum and prism; commit in each.

#### C1.4: Deprecate the standalone type scale

`style`'s MD2 scale is superseded, and it carries a real bug — `H1` and `H2` are
both 96 dp, where MD2's H2 is 60.

- [ ] Mark every exported symbol in `style` `Deprecated:` with the `spectrum/tokens.Typography` replacement.
- [ ] Fix the `H2` size to 60 so the deprecated path is at least correct.
- [ ] Note in `style`'s README that it is frozen.
- [ ] Build, test, commit in style.

### G-C2: Migrate components off gofont

One task per component group. Each ends with green tests — including
regenerated goldens, which will move for every one of these.

Pattern for each component: read `Typography` from the theme, use the role's
`TextStyle` for typeface, weight, size and line height, and keep `Props.Shaper`
only as an explicit override that defaults to the theme's shaper. No library
file may import `gofont` when the group is done.

#### C2.1: prism/button

- [ ] Take the shaper and `LabelLarge` style from the theme's `Typography`.
- [ ] Remove the `gofont` import and the inline fallback shaper.
- [ ] Keep `Props.Shaper` as an override; document it as such.
- [ ] Regenerate goldens; build, test, commit.

#### C2.2: prism/input

- [ ] Migrate textfield, dropdown, checkbox and radio the same way.
- [ ] Remove every `gofont` import in the package.
- [ ] Regenerate goldens; build, test, commit.

#### C2.3: prism remaining packages

- [ ] Migrate richtext, list, scrollbar and layout.
- [ ] Migrate `prism/gallery` (nested module) and `prism/button/gallery`.
- [ ] Confirm no `gofont` import remains anywhere in prism, tests included.
- [ ] Regenerate goldens; build, test, commit.

#### C2.4: pulse

- [ ] Migrate springbutton and depth.
- [ ] Confirm no `gofont` import remains in pulse.
- [ ] Regenerate goldens; build, test, commit.

#### C2.5: cadence — data and navigation

- [ ] Migrate table, tabs, sidebar, navbar, pagination.
- [ ] Regenerate goldens; build, test, commit.

#### C2.6: cadence — overlays

- [ ] Migrate tooltip, alert, accordion, toast, popover, modal.
- [ ] Regenerate goldens; build, test, commit.

#### C2.7: cadence — content and shells

- [ ] Migrate card, hero, feature, pricing, testimonial, breadcrumb, shell.
- [ ] Confirm no `gofont` import remains anywhere in cadence.
- [ ] Regenerate goldens; build, test, commit.

#### C2.8: markdown

- [ ] Migrate the document renderer, highlight and svgimage to theme typography.
- [ ] Confirm no `gofont` import remains, tests included.
- [ ] Regenerate goldens; build, test, commit.

### G-C3: Lock it in

The rule that prevents this whole class of regression.

#### C3.1: The no-gofont lint

- [ ] Write a Go test that walks the module and fails on any `gioui.org/font/gofont` import.
- [ ] Add it to prism, pulse, cadence and markdown.
- [ ] Confirm it fails when a gofont import is reintroduced deliberately, then passes.
- [ ] Wire it into each repo's CI; commit in each.

#### C3.2: The no-literal-colour lint

- [ ] Write a test that fails on `color.NRGBA{...}` literals outside `spectrum/tokens` and `spectrum/color`.
- [ ] Add it to prism, pulse, cadence and markdown; allow-list the deliberate exceptions with a comment explaining each.
- [ ] Wire into CI; commit in each.

## Phase D: Generative colour
Material Design's real contribution is not its palette, it is that colour is
*derived*: one seed becomes tonal palettes becomes semantic roles, with light
and dark as tone mappings rather than two hand-written structs. Today the token
package wears MD3's names over Tailwind's values, ships thirteen flat colours,
and exposes no way for an application to supply a palette at all.

G-D1 is firm — the approach was validated against the MD3 default seed before
this plan was written. G-D2 and G-D3 are provisional; re-cut them against what
Phases B and C actually landed before starting G-D2.

![[#ADR-002: CIELAB tone with OKLCh hue and chroma]]

### G-D0: Choose the role-assignment model

ADR-002 settles how tones are *derived*. It does not settle how they are
*assigned*, and there are two coherent answers:

- **MD3's way** — tones are perceptual (tone 40 means lightness 40), and a
  separate role table says which tone each role takes in light and in dark.
- **Radix's way** — the step number carries the meaning (step 3 *is* the
  component background, step 9 *is* the solid fill, step 11 *is* low-contrast
  text), and light and dark scales are built so the same step works in both.
  Dark mode swaps one scale instead of maintaining a second role table.

For a component library this is not a cosmetic choice: it decides whether
prism and cadence read a role table or a step index, and whether dark mode is
a second table to keep in sync. Deciding after G-D2 costs seven migrations.
Deciding here costs one spike.

#### D0.1: Spike — Radix step semantics and APCA contrast

Timeboxed. The deliverable is a recommendation with evidence, not an
implementation — write no code into `spectrum`. A throwaway script is fine and
should be thrown away.

- [ ] Read Radix's 12-step scale: the stated purpose of each step, and how the paired dark scales preserve step semantics.
- [ ] Lay it against MD3's role→tone table for the same surfaces: app background, card, hover, border, solid fill, body text.
- [ ] Generate both mappings from the `#6750A4` seed with a throwaway script and compare the resulting surfaces side by side, light and dark.
- [ ] Evaluate APCA (Lc) against WCAG 2 ratios on the light-on-dark pairs specifically — WCAG 2 is known to over-rate them, and spectrum tracks OS dark mode by default.
- [ ] Decide, and write the outcome into `## Reference` as ADR-006, embedded into Phase D.
- [ ] Re-cut G-D2 to match the decision, and adjust D2.4's contrast target if APCA wins.
- [ ] Commit in the plan repo.

### G-D1: The colour engine
Built in `spectrum/color`, with no external dependency. The CIELAB conversion
chain is lifted from `reactivego/luminance` rather than imported — ADR-002
records why.

#### D1.1: The CIELAB tone axis

MD3's tone *is* CIELAB L\*, so this axis is what the whole palette hangs from.
`reactivego/luminance` already implements the chain correctly and without
dependencies; lift the math in rather than taking the package as a dependency.

- [ ] Create `spectrum/color`; lift the sRGB ↔ XYZ(D65) ↔ CIELAB conversions from that package's `luminance.go`.
- [ ] Keep the D65 white point and the CIE ϵ/κ constants exactly as they are.
- [ ] Leave behind `Lighten`, `Darken`, `LightenRGBA`, `DarkenRGBA` and `Kn` — a chroma.js port tuned to the retired MD2 Color Tool, and MD3 has no lighten/darken concept.
- [ ] Note in the file header that these functions came out of MD2-era tone work, so a later reader does not go looking for MD3 semantics in them.
- [ ] Write the round-trip tests the original never had: the sRGB cube at 1% tolerance, plus published CIELAB reference values.
- [ ] Build, test, commit.

#### D1.2: OKLab and OKLCh

Hue and chroma come from OKLab. This is the axis pair plain CIELAB `a,b` cannot
hold perceptually constant.

- [ ] Add sRGB ↔ linear sRGB ↔ OKLab ↔ OKLCh conversions alongside the CIELAB chain.
- [ ] Round-trip tests across the sRGB cube at 1% tolerance.
- [ ] Test against published OKLab reference values.
- [ ] Build, test, commit.

#### D1.3: Gamut mapping

The defect that makes the copied code unusable as-is: `luminance.RGB` clamps R,
G and B independently, which is not gamut mapping. Measured on the MD3 default
seed `#6750A4`, it costs 41 chroma and 20° of hue at the light end — tone 100
lands on `#ffefff` instead of white, tone 0 on `#01003f` instead of black.
Tones 10–70 are unaffected and already exact.

- [ ] Implement chroma reduction at constant L\* and constant OKLCh hue to bring an out-of-gamut colour into sRGB.
- [ ] Replace every independent per-channel clamp on the conversion path.
- [ ] Test the hard cases: saturated blues and purples at tones 0, 90, 95, 99 and 100.
- [ ] Assert tone 100 is exactly white and tone 0 exactly black, for every hue.
- [ ] Assert a mapped result is always in gamut and its hue never moves more than 1°.
- [ ] Build, test, commit.

#### D1.4: Tones and contrast

- [ ] Add `Tone(hue, chroma float64, tone int) color.NRGBA` — tone 0–100 on the L\* axis at fixed OKLCh hue and chroma.
- [ ] Add WCAG relative-luminance and contrast-ratio helpers.
- [ ] Test that tone is monotonic in luminance across all thirteen MD3 stops.
- [ ] Regression-test the `#6750A4` palette: tone 40 must reproduce the seed exactly.
- [ ] Build, test, commit.
### G-D2: The role set

#### D2.1: Define the full MD3 role set

- [ ] Extend `ColorTokens` to the full set: Primary/Secondary/Tertiary/Error each with On, Container and OnContainer; Surface with the five SurfaceContainer levels; OnSurface, OnSurfaceVariant; Outline, OutlineVariant; InverseSurface, InverseOnSurface, InversePrimary; Scrim, Shadow.
- [ ] Keep every field name currently in use so nothing breaks.
- [ ] Build, test, commit.

#### D2.2: Derive a palette from a seed

- [ ] Add `FromSeed(seed color.NRGBA) (light, dark ColorTokens)` using the MD3 tone assignments.
- [ ] Golden-test the default seed against a recorded palette.
- [ ] Replace `DefaultLight`/`DefaultDark` with values derived from the default seed.
- [ ] Build, test, commit.

#### D2.3: State layers

- [ ] Add hover, focus, pressed, dragged and disabled opacity tokens.
- [ ] Add a helper that composites a state layer over a role colour.
- [ ] Build, test, commit.

#### D2.4: Contrast conformance

- [ ] Test that every On*/base pair meets WCAG AA in both light and dark.
- [ ] Test the same for the high-contrast variant once E3.3 lands, or record the gap.
- [ ] Fix any tone assignment that fails; commit.

#### D2.5: Migrate prism to the new roles

- [ ] Replace flat-token uses with the role that matches each surface's meaning.
- [ ] Regenerate goldens; build, test, commit.

#### D2.6: Migrate cadence to the new roles

- [ ] Same, across all eighteen packages.
- [ ] Regenerate goldens; build, test, commit.

#### D2.7: Migrate pulse and markdown to the new roles

- [ ] Same, including `pulse/transition`'s per-field interpolation, which must cover every new role.
- [ ] Regenerate goldens; build, test, commit.

### G-D3: Let applications and the OS drive the palette

#### D3.1: Palette injection

The gap that makes branding impossible today: `LiveTheme` hardcodes the default
palette, so choosing your own colours means giving up OS dark-mode tracking.

- [ ] Add options so a caller supplies a seed or a full palette and still gets live light/dark switching.
- [ ] Update `LiveTheme` and `FromSourceTheme` to take them.
- [ ] Test that a custom seed survives a light→dark transition.
- [ ] Build, test, commit.

#### D3.2: Wire the macOS accent

`spectrum/system` already reads `AppleAccentColor` and then discards it.

- [ ] Map the accent index (−1..7) to its seed colour.
- [ ] Regenerate the palette when the accent changes.
- [ ] Test with a fake `Source` driving each index.
- [ ] Build, test, commit.

#### D3.3: Windows and Linux accent sources

- [ ] Read the Windows accent colour from the registry.
- [ ] Read the GNOME/KDE accent where available; fall back to the seed otherwise.
- [ ] Document per platform what is and is not supported.
- [ ] Build, test, commit.

## Phase E: Reimagined for desktop
Where MD3 assumes touch and Android, diverge deliberately and say why. This is
what makes the system VibrantGio's rather than a port.

G-E1 is firm. G-E2 and G-E3 stay provisional; re-cut them when Phase D lands.

![[#ADR-005: MD3's system, not MD3's look]]

### G-E0: Token export and the prototyping surface

Every decision in this phase is a look-and-feel decision, and each one is far
cheaper to judge in a browser than by regenerating Gio goldens. Build the export
first so the rest of Phase E can use it.

The foundations are *derived* values — once ADR-002's engine exists, emitting
them is a serialiser, not a second design system. The target is the project
layout `claude.ai/design` consumes: `theme.json` as the machine-readable
parameters, `styles.css` as the token sheet, and foundation pages that render
the scales at real sizes. Components are explicitly out of scope here; they are
Phase G, after they stop changing.

Generated output lives in `design/` at the root of this plan repo and is
committed, so every push is a reviewable diff.

#### E0.1: The token serialiser

- [ ] Create `spectrum/export`: given a `theme.Theme` emission, write `theme.json` and the `:root` / dark token sheet of `styles.css`.
- [ ] Emit the token families Claude Design expects: `--color-*` (role bases plus their tonal ramps), `--font-*`, `--space-*`, `--radius-*`, `--shadow-*`.
- [ ] Record the generative parameters in `theme.json` — seed hue, saturation, any pinned roles, density, base radius, heading and body faces — so the theme is reproducible from the file alone.
- [ ] Write a round-trip test: parse the emitted CSS back and assert every value matches the Go token it came from, so the two cannot drift.
- [ ] Add `cmd/vg-tokens` writing the pair into a target directory.
- [ ] Build, test, commit in spectrum.

#### E0.2: The foundation pages

Static HTML that reads only from the emitted token sheet — no hard-coded values,
so a theme change reflows every page.

- [ ] Generate `foundations/color.html`: each role with its full ramp, the step-purpose notes, and the measured contrast of each text pair against its ground.
- [ ] Generate `foundations/type.html`: every type role at its real size, weight, line height and tracking, in the actual faces.
- [ ] Generate `foundations/layout.html`: the spacing scale, radius scale and elevation steps as rendered specimens.
- [ ] Generate `readme.md` for the project describing the system and naming the token families — the file a human or an agent reads first.
- [ ] Confirm every page renders correctly against a dark theme emission as well as light.
- [ ] Build, test, commit in spectrum; commit the generated `design/` here.

#### E0.3: Push to Claude Design

- [ ] Run `cmd/vg-tokens` into `design/`, then push it to the VibrantGio design project with DesignSync — plan first, write the sentinel, write the files, re-arm the sentinel.
- [ ] Open the project and confirm the foundation pages render as generated.
- [ ] Write `scripts/push-design.sh` capturing the regenerate-and-push sequence so later phases re-push in one step.
- [ ] Record the project UUID here in the plan repo, next to the script.
- [ ] Commit here.

### G-E1: Density
Desktop density is the sharpest divergence from MD3, and the one users feel
first. Targets come from shadcn/ui's metrics rather than being invented, per
ADR-005.

#### E1.1: Measure the target metrics

Establish the numbers before changing any component, so every later task has one
table to work from and reviewers can argue with the source rather than the
diffs.

- [ ] Record shadcn/ui's control metrics: default and small button heights, input height, base radius, and the spacing step between stacked controls.
- [ ] Record MD3's equivalents alongside them, and macOS's 28 pt standard control height as the native reference point.
- [ ] Write the three-way table into `spectrum/tokens/density.go` as a doc comment — it is the justification for every number below it.
- [ ] Pick `Comfortable` and `Compact` values from that table; keep prism's existing 44 dp as `Comfortable` only if the table supports it.
- [ ] Commit here in the plan repo if the table changes ADR-005's claims; otherwise commit in spectrum.

#### E1.2: The density token

- [ ] Add `Density` to `spectrum/tokens` with `Comfortable` and `Compact`, carrying control height, inner padding and the minimum hit target.
- [ ] Add it to `theme.Theme` as an observable, alongside Typography.
- [ ] Keep the WCAG 2.5.5 minimum hit target independent of density — `Compact` may shrink the visual control but never the pointer target.
- [ ] Unit-test that both settings satisfy the hit-target floor.
- [ ] Build, test, commit in spectrum.

#### E1.3: Density through prism

- [ ] Replace the hardcoded `minHeight = 44dp` in `prism/button` with the density-derived value.
- [ ] Apply density to input, checkbox, radio, dropdown and list row height.
- [ ] Add a golden per component at each density.
- [ ] Build, test, commit in prism.

#### E1.4: Density through cadence

- [ ] Apply density to table row height, navbar height, sidebar item height, tabs and pagination controls.
- [ ] Check the overlays — modal, popover, tooltip, toast — for control metrics that should follow density too.
- [ ] Add a golden per component at each density.
- [ ] Build, test, commit in cadence.
### G-E2: Tonal elevation

#### E2.1: Elevation becomes a surface role

- [ ] Map each `ElevationLevel` to its `SurfaceContainer` role rather than a shadow depth in dp.
- [ ] Migrate prism and cadence surfaces to the tonal mapping.
- [ ] Regenerate goldens; build, test, commit.

#### E2.2: Shadows become opt-in vibrancy

- [ ] Keep `pulse/depth` as an explicit effect, not a default.
- [ ] Document when a shadow is right and when tonal elevation is, and the cost difference in Gio.
- [ ] Build, test, commit.

### G-E3: Motion and accessibility as theme inputs

#### E3.1: MD3 motion

- [ ] Replace the CSS easing names with MD3's standard and emphasized easing sets.
- [ ] Add MD3's duration stops alongside them.
- [ ] Add spring specifications for the pulse physics path.
- [ ] Update pulse to consume them; regenerate goldens; build, test, commit.

#### E3.2: Accessibility preferences reach the theme

- [ ] Route `prism/a11y`'s reduced-motion and contrast observables into the theme so components read one source.
- [ ] Move the a11y source into spectrum if the layering requires it; leave an alias in prism.
- [ ] Test that reduced motion makes animated components snap to their target.
- [ ] Build, test, commit.

#### E3.3: High-contrast palette

- [ ] Derive a high-contrast variant from the same seed by widening tone separation.
- [ ] Switch to it when the OS reports increased contrast.
- [ ] Assert WCAG AAA on the variant's On*/base pairs.
- [ ] Build, test, commit.

## Phase F: Prove it, document it, release it

A design system is only coherent if its own reference applications agree. Right
now seven apps give three different answers about fonts alone.

Tasks here are provisional; re-cut them when Phase E lands.

![[#Release protocol]]

### G-F1: Make the example apps agree

#### F1.1: The apps that are already close

- [ ] Migrate todos, iconbrowser and launcher to the new theme API.
- [ ] Drop their manual `style.FontFaces()` shaper construction — typography now comes from the theme.
- [ ] Run each; confirm it renders in Roboto and switches light/dark live.
- [ ] Commit in workbench.

#### F1.2: feeds

- [ ] Remove the `gofont` shaper and every per-component `Shaper` pass-through.
- [ ] Migrate to the new theme and role tokens.
- [ ] Run it; confirm the table, tabs, modals and toasts all render correctly.
- [ ] Build, test, commit.

#### F1.3: watchlist

- [ ] Same migration; keep the `wiring_test.go` AutoConnect count correct.
- [ ] Run it; confirm CRUD, context menus and popovers.
- [ ] Build, test, commit.

#### F1.4: sitedocs

- [ ] Same migration, including the markdown-rendered docs pages.
- [ ] Run it; confirm hero, pricing, accordion sidebar and the docs routes.
- [ ] Build, test, commit.

#### F1.5: mindchat

- [ ] Remove the appended `gofont.Collection()` — this app currently mixes both font sets.
- [ ] Migrate to the new theme; confirm the markdown chat bodies and chroma highlighting still match the palette.
- [ ] Run it; confirm the split pane, modals and streaming indicators.
- [ ] Build, test, commit.

#### F1.6: The mvu examples

- [ ] Drop the `style` dependency from `mvu/example`; use theme typography.
- [ ] Update `edit` and `04-hello`, the only two consumers of `style` in the org.
- [ ] Build, test, commit.

### G-F2: Regenerate the documentation

#### F2.1: Rewrite llms.txt for the shipped system

- [ ] Replace the Phase A typography section with the theme-owned contract — no shapers passed by hand.
- [ ] Document seed-derived colour, palette injection, density and the role set.
- [ ] Update the module inventory and the minimal `go.mod` to the released tags.
- [ ] Rewrite the pitfalls section against what actually bit during Phases B–E.
- [ ] Commit here.

#### F2.2: Rewrite DESIGN.md

- [ ] Rewrite `workbench/DESIGN.md` around the new layering, the generative colour model and the desktop divergences.
- [ ] Fold ADR-001 through ADR-004 in as decision records.
- [ ] Keep the old document as `DESIGN-v1.md` for history.
- [ ] Commit in workbench.

#### F2.3: Refresh every repo README

- [ ] Update the prism, spectrum, pulse and cadence READMEs against the shipped API.
- [ ] Remove the "arrives in a later phase" notes now satisfied.
- [ ] Update the deprecation notes in style, textdraw and the prism alias shims.
- [ ] Commit in each repo touched.

#### F2.4: Refresh the org front door

- [ ] Update `profile/README.md`'s stack table to the final layering.
- [ ] Retake the launcher and mindchat screenshots in both appearances on the new palette.
- [ ] Confirm every link from the org page resolves.
- [ ] Commit here.

### G-F3: Release

#### F3.1: Tag the foundation

- [ ] Verify `scripts/check-layers.sh` passes across the stack.
- [ ] Tag font and spectrum.
- [ ] Confirm the tags resolve from a clean module cache.

#### F3.2: Tag the component layers

- [ ] Update prism and pulse to the released spectrum tag; build and test.
- [ ] Tag prism, then pulse.
- [ ] Confirm resolution from a clean cache.

#### F3.3: Tag the pattern layer and the apps

- [ ] Update cadence, markdown and mvu to the released tags; build and test.
- [ ] Tag all three.
- [ ] Update every workbench app's `go.mod` to the released tags; build, test, run each.
- [ ] Drop the deprecated alias shims from prism and spectrum, and tag the majors that removes.

## Phase G: The design-agent surface

Phase E exported the foundations. This phase adds the component layer, which
turns `claude.ai/design` from a token reference into a place where a design
agent composes whole screens out of VibrantGio's own parts — screens that then
port to Gio because they were built from the same tokens and the same
component vocabulary.

**Not the converter path.** `/design-sync`'s converter expects a JavaScript
design system: a lockfile, a bundlable `dist/`, React components on
`window.<globalName>.*`, `.d.ts` prop contracts. VibrantGio is Go and Gio, so
none of it applies. The skill is explicit that the upload *format* is the
contract and the converter is only one route to it. Produce the layout directly.

**The shape to copy is a CSS-class system** — a token sheet plus a class
vocabulary (`.btn`, `.card`, `.input`, `.table`, `.nav`, `.dialog`) with plain
HTML component pages whose markup can be read and copied. Six component pages
and five foundations is the whole proven surface; this is not a port of all
thirty prism and cadence packages.

**Fidelity is the whole game.** A component that renders wrong here renders
wrong in every design the agent ever builds with it. The mirror is a second
implementation and will drift unless something holds it — so it is verified
against prism's and cadence's existing golden images, not by eye. That
harness is G1.1 and everything else depends on it.

Sequenced after Phase F because components are rewritten throughout C, D and E;
mirroring them earlier is rework.

### G-G1: The mirror and its harness

#### G1.1: Golden comparison harness

Without this, the rest of the phase is guesswork dressed as work.

- [ ] Write a harness that renders a component page headless at a fixed viewport and captures a screenshot.
- [ ] Align it with the Gio goldens: same nominal size, same theme emission, same component state.
- [ ] Emit a per-component difference score against the corresponding `testdata/golden` image.
- [ ] Pick and justify a tolerance — text shaping and antialiasing differ between Gio and a browser, so the bar is "reads as the same component", not pixel equality.
- [ ] Prove it: run it against one deliberately wrong variant and confirm it fails.
- [ ] Commit here.

#### G1.2: The component class vocabulary

- [ ] Define the class layer in `styles.css`, built only on the tokens E0.1 emits — no literal colours, sizes or radii.
- [ ] Cover the interaction states explicitly: hover, pressed, keyboard focus ring, disabled, selected.
- [ ] Derive state colours from the tonal ramp rather than ad-hoc mixes, matching how prism resolves them.
- [ ] Confirm the sheet still passes E0.1's round-trip test.
- [ ] Commit here.

### G-G2: The component pages

One task per group. Each page is plain, readable HTML; each ends green against
the G1.1 harness for every variant and state it shows.

#### G2.1: Buttons, tags and forms

- [ ] Build `components/buttons.html`: every prism/button variant, size and state, plus tags.
- [ ] Build `components/forms.html`: text field, checkbox, radio and dropdown on native elements, no script.
- [ ] Run the harness against prism's button and input goldens; close the gaps.
- [ ] Commit here.

#### G2.2: Cards, elevation and tables

- [ ] Build `components/cards.html`: the card pattern and each elevation step.
- [ ] Build `components/table.html`: cadence/table's header, row rules, sort affordance and zebra treatment.
- [ ] Run the harness against the cadence card and table goldens; close the gaps.
- [ ] Commit here.

#### G2.3: Navigation

- [ ] Build `components/navigation.html`: navbar, sidebar, tabs and breadcrumb.
- [ ] Include the selected, hover and focus states for each.
- [ ] Run the harness against the corresponding cadence goldens; close the gaps.
- [ ] Commit here.

#### G2.4: Overlays

- [ ] Build `components/dialog.html`: modal over its backdrop at the top elevation, plus popover, tooltip and toast.
- [ ] Show the scrim and the focus-trapped state, since those carry the elevation and colour decisions.
- [ ] Run the harness against the cadence overlay goldens; close the gaps.
- [ ] Commit here.

### G-G3: Ship it

#### G3.1: The conventions header

This file is inlined into the design agent's system prompt. It is the difference
between an agent that uses the vocabulary and one that invents its own, so every
sentence must be something the agent can act on without guessing.

- [ ] Write `.design-sync/conventions.md`: the class families with their real names, the token families, where the truth lives, and one idiomatic build snippet taken from a page that already passes the harness.
- [ ] State the Gio-specific caveats a browser cannot express — no native backdrop blur, different text shaping — so designs are not built on affordances that will not port.
- [ ] Validate it: every class, token and component name it mentions must exist in the emitted `styles.css` or the component pages. Cut or fix anything that does not resolve.
- [ ] Commit here.

#### G3.2: Push and validate with the agent

- [ ] Regenerate the full bundle and push it with `scripts/push-design.sh`.
- [ ] Ask the design agent to compose a screen that exercises a shell, a table, a modal and a form.
- [ ] Check the result against the conventions: real classes, real tokens, no invented vocabulary.
- [ ] Record what the agent got wrong as follow-up work — that list is the honest measure of whether the surface is good.
- [ ] Commit here.

## Reference

Decision records and shared contracts. `mdplan next` never visits this section
directly — the phases and goals above pull pieces of it in by embed.

### ADR-001: Spectrum is the foundation, not a consumer

**Decision.** The token and theme contract moves from `prism` down into
`spectrum`. The layer order becomes:

```
mvu  →  spectrum  →  prism  →  pulse  →  cadence  →  markdown
```

`spectrum/transition` moves to `pulse/transition`, since it is animation code
and would otherwise make the foundation depend on the effects layer.
`spectrum/window` may keep its `mvu` dependency; mvu carries no design tokens.

**Why.** Today `spectrum` — the theme runtime — depends on `prism`, the
component library it exists to theme. The theme therefore sits above what it
themes, which is why `LiveTheme` hardcodes `tokens.DefaultLight`/`DefaultDark`
and why there is no palette injection point anywhere in the stack. Separately,
`prism` and `pulse` require each other, forming a module cycle that keeps
`spectrum` and `pulse` pinned to `prism v0.0.3` while `cadence` runs on
`v0.0.8` and `markdown` on `v0.0.9`.

**How it stays non-breaking.** `prism/tokens` and `prism/theme` remain as
packages containing only type aliases and re-exported variables. Every
downstream import path keeps working, unchanged, for one release cycle. The
shims are deleted in F3.3, which is the major bump.

### ADR-002: CIELAB tone with OKLCh hue and chroma
**Decision.** Derive tonal palettes on two axes: **tone is CIELAB L\***, exactly
as MD3 defines it, and **hue and chroma come from OKLCh**. Keep MD3's role
vocabulary and its tone-assignment tables; replace both the colour mathematics
and the hardcoded values now in `prism/tokens`.

This is HCT's architecture with OKLab substituted for CAM16.

**Why not what's there now.** The current token package is three design systems
in a trench coat: MD3 type roles, a verbatim Tailwind v3 palette wearing MD3
semantic names, Tailwind spacing and radius keys, MD3 elevation levels, and CSS
easing names. No single system's design logic survives the mix — which is
precisely why nothing feels designed together.

**Why not HCT.** MD3's own space carries CAM16 and viewing-condition machinery
that buys little on a desktop screen and is substantial to implement correctly.

**Why not plain OKLCh.** OKLab's L is not CIELAB L\*. Deriving tones from it
means "tone 40" stops meaning what Google means by it, and every MD3
tone-assignment table has to be re-derived by eye. Keeping L\* as the tone axis
keeps that vocabulary for free.

**Why OKLCh for the other two axes.** Holding CIELAB `a,b` constant while
sweeping L\* does not hold *perceived* hue constant — the blue shift is exactly
why Google built HCT rather than using CIELAB directly. OKLab fixes it in a
short, testable conversion chain, with no dependency and no viewing-condition
model.

**On `reactivego/luminance`.** That package already implements the
sRGB ↔ XYZ(D65) ↔ CIELAB chain correctly and without dependencies, and its
`Lab()`/`RGB()` pair is precisely the tone axis this ADR needs. Its math is
**lifted into `spectrum/color`, not imported.** Same author, so this is
reuse rather than a dependency decision with anyone else in the loop.

Not imported because the package is MD2-era by design: its `Lighten`/`Darken`
API and `Kn = 18` constant are a chroma.js port tuned to reproduce the retired
material.io Color Tool, and MD3 has no lighten/darken concept at all. It also
declares `go 1.14`, carries no tests, and its `go.mod` pulls `fogleman/gg` and
`golang.org/x/exp` because its examples share the module — which would drag
freetype into the foundation's module graph.

Lifted: the conversion chain, the D65 white point, the CIE ϵ/κ constants. The
file header says these came out of MD2-era tone work — not as attribution, but
so a later reader knows the lineage and does not expect MD3 semantics from them.

Left behind: `Lighten`, `Darken`, `LightenRGBA`, `DarkenRGBA`, `Kn`, and the
per-channel clamp in `RGB()` — which is not gamut mapping and is replaced in
D1.3.

**Tailwind's ramps** may survive as an optional palette provider. They must not
appear in the semantic layer.
### ADR-003: The theme owns the typeface

**Decision.** `Typography` is a theme token carrying, per MD3 role, a full
`TextStyle` — typeface, weight, size, line height, tracking — plus the face
collection and a lazily built shaper. Roboto is the default because the default
typography names it. `Props.Shaper` survives only as an explicit per-call
override. No library source file may import `gioui.org/font/gofont`; a CI lint
enforces it.

**Why.** `TypeScale` is fifteen `float32` sizes and nothing else, so the theme
has no seam for a typeface at all. The consequence is mechanical: seventeen
`Props` structs and 118 function signatures carry a `*text.Shaper`, and prism,
pulse, cadence and markdown all construct
`text.NewShaper(text.NoSystemFonts(), text.WithCollection(gofont.Collection()))`
inside library code. gofont is not merely used by the examples — it is the
compiled-in default of the component library. Meanwhile `font` and `style`, the
repos that package Roboto and a type scale, have exactly two consumers in the
entire organization, both of them `mvu` examples.

`style` is frozen rather than deleted: its MD2 scale is superseded by
`Typography`, and it keeps working through the deprecation window.

### ADR-004: The canonical agent guide lives here

**Decision.** `llms.txt` lives at the root of this repo and is the single
source. Every repository carries an `AGENTS.md` that links its raw URL. The
content is never duplicated — only pointed at.

**Why.** The guide is genuinely good: 360 accurate lines on the MVU loop, rx
semantics, `AutoConnect` counts and real pitfalls. It exists exactly once,
inside `workbench/`, and nothing links to it — not the org profile, not any
repo README, and no repo has an `AGENTS.md` or `CLAUDE.md` at all. An assistant
pointed at the organization reads the profile README, finds a repo list and
screenshots, and stops.

It also, in its current form, teaches the defect: it lists `style` and `font` in
the module inventory but omits both from the bootstrap skeleton and the minimal
`go.mod`, and has no typography section. An assistant that follows it perfectly
ships a gofont application.

### ADR-005: MD3's system, not MD3's look

**Decision.** Take MD3's *system* and reject MD3's *look*. Specifically:

- **From MD3:** the generative token model (ADR-002), the type-role scale, state
  layers, tonal elevation, and the motion semantics.
- **From shadcn/ui:** density, restraint, and the component inventory. Its
  metrics are the target for the `Density` token — copy them rather than
  inventing numbers.
- **From neither:** the visual identity. That comes from `pulse` — glow, depth,
  spring physics — which is what DESIGN.md already names as the point of the
  project.

**Why.** MD3 is touch-first: 48 dp targets, generous spacing, large type, and a
component set shaped for phones — FAB, navigation rail, bottom sheet, chips,
snackbar. Adopting its look would make a Mac app read as an Android port, which
defeats the word "native" in the project's own vision statement.

Cadence has *already* made this choice without recording it. Its inventory —
shell, navbar, sidebar, table, pagination, tabs, modal, alert, popover, tooltip,
toast, card, accordion, breadcrumb, hero, feature, pricing, testimonial — is
shadcn's inventory, not MD3's. MD3 has no breadcrumb, no data table and no
pricing section. This ADR ratifies a decision the code made a year ago, so the
next contributor stops trying to reconcile the two.

The hardcoded `minHeight = 44dp` in `prism/button` is the same tension showing
up as a magic number. E1.1 replaces it with a token.

**What shadcn is not adopted for.** Its colour model is flat, hand-authored
semantic pairs — `--background`/`--foreground`, `--primary`/`--primary-foreground`
— written twice, once under `:root` and once under `.dark`. That is structurally
what `prism/tokens` already does, so taking it would be standing still. shadcn
moved to OKLCH values without moving to generation; MD3 generates without a
modern space; ADR-002 does both.

Its distribution model is also not adopted: copying component source into the
consumer's repo has no Go idiom, and fights module versioning and golden tests.
The philosophy behind it does carry over — components should be readable and
forkable, not opaque configuration surfaces.

### The repo doc contract

Every repository gets the same two files, in the same shape.

`AGENTS.md` — about fifteen lines:

- One sentence: what this repo is.
- Which layer it occupies, per ADR-001.
- The canonical guide's raw URL, and an instruction to read it before writing code against this module.
- The build and test command.
- Anything that would surprise someone: nested modules, deprecation status, platform-specific files.

`README.md` — a page, written for a human evaluating the module:

- What it is and what problem it solves, in a paragraph.
- Where it sits in the stack, with a link to the org page.
- Its packages, one line each.
- One short, real usage example — copied from a working app, not invented.
- A link to the canonical guide.
- Honest status: what does not work yet, and which phase fixes it.

Describe the layer and the role, not the API surface — the API surface changes
in Phases B through E, and F2.3 is where READMEs are brought up to the shipped
reality.

### Release protocol

Modules are tagged bottom-up, one layer at a time, and each layer is verified
from a clean module cache before the layer above it moves:

```
font, spectrum  →  prism  →  pulse  →  cadence, markdown, mvu  →  workbench apps
```

No layer is tagged while `scripts/check-layers.sh` fails. The deprecated alias
shims from ADR-001 and ADR-003 are removed only in the final major bump, after
every in-org consumer has moved off them.
