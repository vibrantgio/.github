---
date: 2026-09-05
task: BR1.8
phase: BR
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BR1.8 fresh-eyes review — the arrival highlight in vaultview

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer on this platform
complain about? It was handed two images and nothing else — the whole
vaultview window at 1100x800 in each scheme, offscreen renders at 1 px
per dp, on the first frame after a followed link lands, which is the
frame the arrival marking is drawn at full strength. The dispatch passed
an opus model override; no effort setting was recorded. It was told to
sample pixels before making any claim about a colour, a contrast, an
alignment or a size, and briefed on four recorded misreads — dark
foreground reading grey at 1x, a whisper step reading as none, chrome
regions sharing one fill by design, and a light card being white on
off-white by ruling. It reported none of the four.

The task's own subject is finding 10. Everything above it is the window
around the mark, which the reviewer was free to look at and did.

## The reply, verbatim

I sampled everything below with PIL. Findings worst first.

---

## 1. The code block is themed by a third-party palette, and its most important lines fail contrast

The code surface is **Catppuccin**, byte-exact, not this app's tokens:

| token | light sampled | Latte hex | dark sampled | Mocha hex |
|---|---|---|---|---|
| base | `(239,241,245)` | `#eff1f5` | `(30,30,46)` | `#1e1e2e` |
| comment | `(156,160,176)` | `#9ca0b0` | `(108,112,134)` | `#6c7086` |
| `func` | `(210,16,57)` | `#d20f39` | `(243,139,168)` | `#f38ba8` |
| `main` | `(30,102,245)` | `#1e66f5` | `(137,180,250)` | `#89b4fa` |

Consequences I measured:

- **Comment contrast: 2.30:1 light, 3.36:1 dark.** Both fail 4.5:1, and those two lines are the ones carrying the note's actual point ("A wikilink inside code is a code sample, not navigation"). The syntax tokens around them are fine (light `func` 4.79, `main` 4.34 — also marginal; dark 7.08 / 7.79). The explanation is the least legible thing in the block.
- **The surface doesn't exist in light.** Code fill L\* = 95.10 on a page of L\* = 95.15. Contrast 1.001:1. That is not a quiet step — the luminance is identical; only the 1px border says a block is there. In dark the same surface sits at L\* 11.97 on a page of 8.25, ΔL\* 3.72 — which is **2.5× the app's own panel-to-content step** (1.48). So the code block is simultaneously flat in one scheme and over-elevated in the other, because its fill isn't drawn from the elevation scale at all.

## 2. The disabled Back/Forward chevron is not dim, it is gone — and the enabled one is dimmer than the decoration beside it

Each chevron glyph has exactly 12 fully-covered core pixels, so these are colour differences, not stroke dilution.

| glyph (light) | core | CR vs page |
|---|---|---|
| breadcrumb separator `▸` | `(92,92,92)` | 5.92 |
| `Properties` disclosure | `(93,93,93)` | 5.86 |
| tree disclosure | `(93,93,93)` | 5.16 (on panel) |
| **Back `‹` (enabled)** | `(122,122,122)` | **3.80** |
| **Forward `›` (disabled)** | `(212,212,212)` | **1.31** |

Dark: Back `(155,155,155)` = 6.39, Forward `(46,46,46)` = **1.31**.

So: a live, clickable control is rendered at 3.80:1 while the purely decorative `▸` next to it is at 5.92:1. And `(122,122,122)` is exactly `#5C5C5C` at 80% over `#F1F1F1` — a one-off value that is not one of the light scheme's greys. The same control is 3.80:1 in light and 6.39:1 in dark, a 1.7× gap.

The disabled state lands at 1.31:1 in *both* schemes. At that level the affordance isn't muted, it's erased — nothing tells you a Forward button exists.

## 3. No focus indicator, and two lists both draw an accented selection

I scanned all 880,000 pixels for the accent (`(114,58,212)` light / `(208,196,255)` dark). It occurs **only** at x 272–632, y 178–215 — the two inline links. Nowhere else. On the first frame after following a link there is no ring, no caret, nothing that says where the keyboard is.

Meanwhile the sidebar selection chip and the outline selection chip have **byte-identical fills** — `(216,206,255)` in light, `(63,0,133)` in dark, both 32px tall. macOS convention is that the focused list shows an accented selection and unfocused lists desaturate. Here two panes are equally "selected" at once, so the frame can't tell you which one arrow keys will drive.

## 4. The scrollbar is permanent, in-flow, and louder than the code it scrolls

Thumb: x 286–706, y 643–648 (6px tall, no track).

- Contrast **5.91:1** light (`(92,92,92)` on `#eff1f5`), **10.21:1** dark (`(204,204,204)` on `#1e1e2e`) — i.e. 2.6× and 3.0× the contrast of the comment text it sits under.
- It is laid out in flow and eats the block's bottom padding. Inner box y 571–649; text bands at 586–599, 604–618, 623–638; thumb 643–648. **Top padding 15px, bottom padding 1px.** The single-line code block next to it (inner 500–540, ink 515–526) is a symmetric 15/14, and the search field (inner 53–90, ink 65–77) is 12/13 — so this block is the only cramped one, and the scrollbar is why.
- It is drawn at rest, before any interaction, on the first frame after arrival. macOS overlay scrollbars fade.

Also: line 1 truncates at `not navigat` — last ink at x=737, then 11 blank columns before the border at 749. Whole glyphs are dropped at the 12px padding edge with no ellipsis and no fade, leaving 12px of unused fill. At a glance it reads as a typo, not as overflow.

## 5. The two schemes are not the same design

Measured in L\* (sRGB → CIE L\*):

| step | light ΔL\* | dark ΔL\* |
|---|---|---|
| backdrop → panel | 7.12 (83.12→90.24) | **1.71** (5.06→6.77) |
| panel → content pane | 4.91 (90.24→95.15) | **1.48** (6.77→8.25) |
| panel → field fill | 4.91 | 4.99 |
| pane separator vs panel | 5.32 | **12.16** |

The field step is well matched (4.91 vs 4.99), so this isn't a global "dark is flatter" policy — the window-level ladder is 3–4× flatter in dark while the separator is 2.3× *heavier*. These were picked by hand, not derived.

Two more collapses in light:

- **Light has one muted grey where dark has two.** Histograms, hard ceilings/floors, zero spread past them: breadcrumb ancestor, `29 lines`, and the search placeholder are `(204,204,204)` in dark; the `Outline`/`Backlinks` headers and `No notes link here.` are `(155,155,155)`. In light **all six are exactly `(92,92,92)`** (50/8/53/54/61/32 pixels at that exact value, nothing darker). A hierarchy tier that exists in dark does not exist in light.
- **Light reuses one value for two roles.** Content pane fill and search-field fill are both `(241,241,241)`. Dark keeps them apart (`(24,24,24)` vs `(31,31,31)`). The light field is only visible because it happens to sit on the 227 sidebar; drop it on the content pane and it vanishes.

## 6. Not the system font

Letterform identification from 4× crops, not a colour sample, so flagging it as such: the UI face is a Roboto-class grotesque — straight-legged `R`, single-storey `g`, flat-cut `t` — not SF Pro. This is the first thing a Mac developer says about a Gio app, and it is visible in the title, the tree, and the headings.

## 7. A read-only code block is styled exactly like an editable text field

| | search field | single-line code block |
|---|---|---|
| border L / D | `(121,121,121)` / `(109,109,109)` | `(121,121,121)` / `(109,109,109)` |
| corner radius | ~4px (curve y52–56) | ~4px (curve y499–502) |
| shape | full-width rounded rect | full-width rounded rect |
| fill L\* (dark) | 11.76 | 11.97 |

Identical border colour, identical radius, and in dark the fills differ by 0.2 L\*. Nothing distinguishes "type here" from "this is a code sample."

## 8. Structural asymmetries

- **The sidebar card is inset 8 / 8 / 8 / 0.** Backdrop `(207,207,207)` fills the gutter at left, top and bottom, but only out to x=247; from x=248 the fill is the content pane's `(241,241,241)`. The card's right corners are rounded, so the corner notch exposes `(241,241,241)` while the left corners expose `(207,207,207)` — the same card's four corners sit on two different colours, with a hard discontinuity 2px apart (y=7 x=247 is 207; y=9 x=247 is 241).
- **Two side panels, two container idioms.** Left: inset card, 1px border `(186,186,186)`/`(54,54,54)`, rounded. Right: flush region running to x=1099 with no inset, no border, just a 1px separator at x=780. Same job, different construction.
- **The content column is not centred.** Pane inner 248–779; all content ink 272–749. Left inset 24px, right inset 30px. No vertical scrollbar is drawn anywhere in the frame, so nothing claims the extra 6px.
- **Three panels, three baselines in the same band.** `Outline` header ink centre y=52; breadcrumb text centre y=61.5; search field box centre y=71.5. A 19px stair-step across the window's second row.

## 9. Buttons that look like labels; icons with no weight rule

- `Rescan` (x 25–69) and `Switch Vault` (x 91–168) are drawn at `(19,19,19)` / `(238,238,238)` — **exactly the note-title colour in the tree above them** — with no border, fill, radius or accent. Nothing in the frame says they are actions.
- The sidebar toggle icon is an 18×16 glyph at the full primary foreground (14.48:1 light, 15.74:1 dark) while the navigation chevrons in the same header band are at 3.80:1 and 1.31:1. Two icon sets, four weights, no rule.
- Drawn hit areas are small: toggle 18×16, chevrons 8×14 ink. No button chrome indicates a padded target.

## 10. The highlight has no padding

Mark box x 272–576, y 388–411. Text ink x 272–575. **Left padding 0px, right padding 1px**, square corners, glued to the paragraph's left margin. Vertically it takes the full 24px line box.

The light fill `(231,215,0)` is the only chroma-max colour in the light scheme — everything else there is neutral grey plus one purple `(114,58,212)`. Its dark counterpart `(78,72,0)` is the same hue heavily desaturated, and sits ΔL\* +21.8 above the page while the light one is ΔL\* −10.3 below it: the mark is twice as prominent in dark as in light.

---

**Not defects** (checked, so you don't re-find them): the highlight's own text contrast is fine (12.49 light, 8.04 dark); links pass (5.68 / 11.01); chip text passes (12.56 / 11.68); selected-row text aligns with unselected tree rows at x=59 in both schemes; outline rows are indented by heading level (805 for H1, 812 for H2), which is intended; chips are vertically centred (text 83–96 in a 74–105 chip); body and heading text are `(19,19,19)`/`(238,238,238)` at 16:1 and 15:1 — genuinely full-strength, not faded.

## Triage

**Fixed in this task.** Nothing. The one finding inside BR1.8's subject —
finding 10 — is two observations, and neither is cheap here.

**Answered rather than fixed.**

- **10, first half: the mark has no side padding and square corners.**
  It is drawn as a block-level field sized to the block it marks, and
  the marking's own test in `markdown` pins that it opens on the block's
  own edge and stops short of the column. Insetting it is a change to
  what the marking is, not to the colour this task derives, so it goes
  to the pool rather than into this commit.
- **10, second half: the mark is louder in dark than in light** (seam
  1.90:1 against the page in dark, 1.32:1 in light; ΔL\* +21.8 against
  −10.3). That is this task's own doing and it is deliberate. The dark
  scheme's container depth holds only 0.0650 of chroma at the reserved
  hue, which renders as an olive; the next depth holds 0.0850 and
  renders as a yellow, and it is one ramp step away because the ramp has
  no finer step to offer. Both fills stay inside the band the derivation
  gates — over the seed sweep the seam runs 1.317:1 at worst and 1.957:1
  at loudest, under the 2.5:1 at which a fill stops being a mark on
  content — so the asymmetry is inside the system's own tolerance rather
  than outside it. Equalizing the two would mean either the olive back
  or a depth the neutral ramp does not carry.
- **The reviewer's own measurement confirms the thing the task was for.**
  It read the light fill as "the only chroma-max colour in the light
  scheme" and the dark one as the same hue "heavily desaturated" — which
  is exactly what the gamut allows at each depth, and it found the text
  over both marks legible (12.49:1 and 8.04:1) without being told to
  look.

**For the pool, in the reviewer's order.** Findings 1 through 9 are the
window around the mark and none of them is the highlighter: the code
block wearing a third-party palette and failing text contrast on its
comments (1); the navigation chevrons' enabled and disabled colours (2);
no focus indicator on the arrival frame, and two panes drawing the same
selected fill (3); the reading column's scrollbar drawn at rest, in flow,
and louder than the code under it, plus the code line truncating with no
ellipsis (4); the window-level elevation ladder measuring 3–4x flatter in
dark than in light while the pane separator measures heavier, and the
light scheme collapsing two muted greys into one (5); the UI face not
being the platform's (6); a read-only code block and an editable field
being the same shape, border and radius (7); the sidebar card's corners
sitting on two different fills and the two side panels using two
container idioms (8); text-only buttons carrying no affordance and the
icon set carrying no weight rule (9).
