---
date: 2026-09-02
task: BQ1.5
phase: BQ
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BQ1.5 fresh-eyes review — does focus survive with the colour removed

Eight images, all offscreen renders at 1 px per dp, no application launched:
the focused-specimens sheets `components/gallery/testdata/golden/focus-{light,dark}.png`
(760 × 204 px, every focusable family focused on the paper, on a card and in a
dialog) and the full gallery sheets `components/gallery/testdata/golden/components-{light,dark}.png`
(900 × 2659 px, most controls at rest with a few focused, so a focused control
can be compared with the unfocused ones beside it) — each of the four in its
committed form and again converted to greyscale by WCAG relative luminance,
which is what macOS Differentiate Without Color, Windows forced-colors and a
greyscale display leave standing.

The reviewer was a fresh agent that had not seen the task packet, the plan or
any source. It was asked exactly two questions — whether a focused control is
findable with colour removed, and whether the indicator still reads as focus
rather than selection, a checked state or an error — and told to review nothing
else. It was briefed that these are 1 px-per-dp offscreen renders in which dark
ink routinely reads grey to the eye, a recorded false positive in earlier
reviews of these images; that antialiased 2 px bands must be sampled at their
interior pixel and the sampled coordinate named; and that no claim about a
colour, a lightness or a contrast ratio was admissible without decoded pixel
values behind it.

## The reply, verbatim

> I sampled every claim below from the PNGs with a stdlib-only Python decoder (`scratchpad/tools/png.py`), reading interior pixels of each band, never edge pixels. All hex values quoted are from the `-greyscale.png` files unless a colour value is given alongside; contrast ratios are WCAG relative luminance computed on the sampled greys.
>
> Reference values, sampled once and reused:
>
> | | light | dark |
> |---|---|---|
> | paper / card / dialog surface | `#f6f6f6` / `#f8f8f8` / `#fbfbfb` | `#181818` / `#222222` / `#2e2e2e` |
> | focus ring (field, checkbox, radio, chip, picker, link) | `#5c5c5c` (colour `#6f36d1`), 2 px | `#d7d7d7` (colour `#dad2ff`), 2 px |
> | rest border on outlined controls | `#797979`, 1 px | `#6d6d6d`, 1 px |
> | filled button, focused | outer 2 px `#5f5f5f` → 2 px `#b6b6b6` → fill `#5f5f5f` | outer 2 px `#cccccc` → 2 px `#6d6d6d` → fill `#cccccc` |
>
> (Surface samples: `focus-*-greyscale.png` at x=100, y=33/101/169. Ring samples: `focus-light-greyscale.png` x=244,412,458,533 at y=33; `focus-dark-greyscale.png` same. Button bands: `components-*-greyscale.png` x=288/290/292 at y=113, confirmed vertically at x=350, y=96–131.)
>
> ## 1. Is a focused control findable with colour removed?
>
> **Light scheme.** Yes, for every family, but by two different mechanisms and with one family much weaker than the rest.
>
> - *Text field* — rest 1 px `#797979` (x=24, y=1094), focused 2 px `#5c5c5c` (x=240–241, y=1094). Focus is both twice as thick and darker; the ring is 6.19:1 against the paper. Findable cold.
> - *Picker* — identical treatment: closed 1 px `#797979` (x=24, y=1353), focused 2 px `#5c5c5c` (x=200–201). Findable cold.
> - *Chip* — unselected rest 1 px `#797979` (x=148, y=650), focused 2 px `#5c5c5c` (x=383–384) with no fill. Selected+focused keeps the fill `#d4d4d4` and adds the same 2 px `#5c5c5c` ring (x=437–438, y=698), ring-to-fill 4.51:1. Findable cold in both rows.
> - *Checkbox / radio* — the box itself is unchanged (border stays `#797979`); focus adds a **detached** second outline 2 px outside it: `#5c5c5c` at y=1192–1193 and y=1218–1219, sampled at x=218, with a 2 px gap of surface at y=1194–1195. It is the only checkbox in the row carrying two concentric outlines. Findable cold.
> - *Link* — 2 px box `#5c5c5c` at y=2302–2303 / y=2325–2326 (x=120), plus a fill wash at `#f2f2f2`. The wash is 1.04:1 against the `#f6f6f6` paper, i.e. effectively gone in greyscale; the box alone carries it, and it does so adequately.
> - *Filled button* — **this is the weak one.** The outer 2 px ring is `#5f5f5f`, exactly the same value as the button fill `#5f5f5f` (x=288–289 vs x=292+, y=113). The whole focus signal in greyscale reduces to the 2 px halo band `#b6b6b6` sitting 2 px inside the button's edge, at **3.15:1** against the fill. The focused button's silhouette is identical to the rest button's — both span y=96–131, 36 px tall (sampled x=60 rest, x=350 focus). So focus adds no outward ink at all here; it adds an internal hairline. It *is* findable — the band is continuous, 2 px, and no other button state in the row has anything like it (hover fill `#454545`, press fill `#181818`, both plain) — but it is the only family whose focus is an inset detail rather than an outline, and it is the one I would be least confident picking out on an unfamiliar screen with a single focused button and no siblings to compare against.
>
> **Dark scheme.** Yes, and comfortably, for every family.
>
> - Ring `#d7d7d7` against paper `#181818` = **12.34:1**, against card `#222222` = 11.05:1, against dialog `#2e2e2e` = 9.44:1. Against the rest border `#6d6d6d` it is **3.60:1** on top of the 1 px → 2 px weight change. Field, picker, chip, checkbox, radio and link all read immediately.
> - *Filled button* — same structural weakness as light: outer 2 px `#cccccc` equals the fill `#cccccc`, and the signal is the inset halo `#6d6d6d` at **3.22:1** against the fill (x=290–291, y=113). Symmetric with light, and equally the weakest member of the set.
>
> ## 2. Does it still read as focus rather than selection, checked/on, or error?
>
> **Light.** Yes, but the separation is now entirely geometric, not tonal.
>
> - Against *checked/on*: the checked checkbox is a solid `#5f5f5f` fill (x=130, y=1196–1215) and the selected radio is a `#5f5f5f` ring with a `#5f5f5f` dot (x=482). The focus ring is `#5c5c5c` — **1.05:1** against that on-state ink, i.e. the same grey. Nothing but shape tells them apart: focus is an unfilled outline standing 2 px clear of the control, "on" is fill. That reads correctly here because the sheet shows them side by side and because focus never fills, but it means the light scheme has spent its entire focus/selection distinction on geometry and has no tonal margin left.
> - Against *selection*: the selected chip is a `#d4d4d4` fill with no border (y=698); focus is a border with no fill (y=650). Focused-and-selected correctly shows both. No confusion.
> - Against *press*: this is the closest call. The pressed unselected chip border is `#5c5c5c` (x=303, y=650) — byte-identical to the focus ring. They are separated only by width (1 px pressed vs 2 px focused) and by the pressed chip's `#d4d4d4` fill versus the focused chip's bare `#f6f6f6`. It holds, but only just.
> - Against *error*: no control in these sheets renders an error state, so there is nothing to collide with. The library's error signal is a filled pill badge (`#84` grey, colour `#c56a69`, x=405 y=804), not an outline, so the 2 px outline is not carrying a second meaning anywhere in these images.
>
> **Dark.** Yes, and with more headroom.
>
> - Against *checked/on*: checked checkbox fill `#cccccc` (x=130, y=1196–1215), selected radio `#cccccc`, focus ring `#d7d7d7` — 1.12:1, again essentially the same ink, again separated only by outline-versus-fill geometry.
> - Against *press*: pressed chip border `#9b9b9b` (x=303, y=650) versus focus ring `#d7d7d7` = **1.93:1**, a *narrower* tonal gap than the light scheme manages between the analogous pair, though the 1 px/2 px weight difference and the pressed `#2e2e2e` fill still resolve it.
> - Against *selection* and *error*: same reasoning as light, no collision.
>
> ## Concrete defects
>
> 1. **Filled button focus is inset-only, in both schemes.** The outer 2 px ring is byte-identical to the fill (`#5f5f5f`/`#5f5f5f` light at x=288 vs x=292, y=113; `#cccccc`/`#cccccc` dark), so the entire greyscale signal is a 2 px internal band at 3.15:1 (light, `#b6b6b6` on `#5f5f5f`) / 3.22:1 (dark, `#6d6d6d` on `#cccccc`). Every other family gets a 2 px *outline* at 6.19:1 (light) to 12.34:1 (dark). The button is the odd one out and the least findable in isolation.
> 2. **Light ring earns almost nothing from luminance against the rest border.** `#5c5c5c` versus `#797979` is **1.54:1**. On field, picker, chip and picker-closed comparisons the light scheme's focus is distinguished almost entirely by 2 px versus 1 px stroke weight. Dark gets 3.60:1 on the same comparison. If the greyscale rendering is ever softened (scaling, low-contrast display), light degrades first.
> 3. **Focus ring and on-state ink are the same grey.** 1.05:1 in light (`#5c5c5c` ring vs `#5f5f5f` checked fill), 1.12:1 in dark (`#d7d7d7` vs `#cccccc`). Correctness rests wholly on outline-vs-fill geometry with zero tonal margin.
> 4. **Dark pressed chip border and dark focus ring are only 1.93:1 apart** (`#9b9b9b` at x=303 vs `#d7d7d7` at x=383, y=650). Tightest state-versus-focus pair in the set.
> 5. **The focused link's fill wash is invisible in light greyscale** — `#f2f2f2` on `#f6f6f6` paper is 1.04:1 (x=120, y=2312). Not a failure, since the 2 px box carries the state on its own, but that wash contributes nothing once colour is removed.

## What the task did with it

The two questions came back answered yes. Focus is findable with the colour
removed in both schemes and on every family, and the ring reads as focus rather
than as selection, a checked state or an error. That is the exit this task was
asking for, and it is the state pooled item 202 said the light scheme did not
have: the reviewer's own sample of the light pairing, 1.54:1 ring against
resting border, is the floor this task placed, measured independently off the
pixels.

Defect 2 is not a defect but the floor's own value, reported as the reviewer
found it: 1.53:1 is the worst the light scheme reaches over the seed sweep, and
the empty stretch the threshold sits in runs from 1.01 to 1.53, so no primary
step exists between the collision and this. Nothing to fix; recorded here so the
number is not rediscovered as news.

Defect 4 the reviewer resolves itself — the 1 px/2 px weight and the pressed
chip's own fill part them — and it is a pairing the ring does not owe anything
to, so it is not pooled.

Defects 1, 3 and 5 are real and out of this task's scope. Pooled as 247, 248 and
249.
