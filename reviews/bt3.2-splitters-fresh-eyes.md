---
date: 2026-09-06
task: BT3.2
phase: BT
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# BT3.2 fresh-eyes review — the window's two splitters

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer who uses macOS every
day complain about? It was briefed on the two recorded misreads — dark
grey on a dark ground reading as washed out in a 1x capture, and static
renders holding nothing that only appears while scrolling or hovering —
told that both boundaries are meant to be draggable, and told it could
measure pixels rather than judge by eye.

## How the captures were taken

**No window was opened.** The screen is locked on this machine, so a live
window cannot be shown, let alone captured. The images were rendered
through the same path the goldens use: `renderWindow` from `frame.go`
composed with `windowScene`, drawn headlessly by
`components/golden.Capture` at one pixel per dp, `DeterministicShaper`,
`tokens.Comfortable`, `goldenLeading` for the window-button metric, at
the 1100×800 window the application opens at.

The state under a hand was not faked. The window widget `renderWindow`
returns was laid out twice through a live `gioinput.Router`, a
`pointer.Move` was queued at the boundary's own line, the widget was laid
out a third time so the splitter took the `pointer.Enter`, and the
capture was taken after that — so what the images hold is the same frame
a pointer resting on the boundary produces.

| capture | what is under the pointer |
| --- | --- |
| `window-rest-{light,dark}` | nothing |
| `window-rail-hand-{light,dark}` | the pane's trailing edge, x 247, y 400 |
| `window-aside-hand-{light,dark}` | the aside's seam, x 780, y 402 |

Eight close-ups went with them, cropped 28 px wide around each boundary
and blown up six times with no interpolation, plus two of the top end of
the pane's edge where its corner rounds away. The captures are not
goldens and were not committed; the recipe above reproduces them.

## The reviewer's reply, verbatim

I measured the pixels rather than eyeballing. Everything below is from the PNGs at 1:1 (source coordinates; window is 1100×800, origin top-left).

---

## What I measured first — the two boundaries

**Left boundary (sidebar | document)** — x=247, light `186`, dark `54`. It runs y=8…791 with rounded ends (arc pixels at y=13…17 and y=782…786), because it is not a divider at all: it is the right-hand stroke of the sidebar's rounded card, which is inset 8 px from the window's left, top and bottom edges.

**Right boundary (document | aside)** — x=780, light `212`, dark `46`. Uniform for the full window height, y=0…799, square ends, no inset.

**Hover** (diffed rest vs hand, whole image): the left hover changes exactly 1528 pixels — columns 247 and 248, rows 18…781. The right hover changes exactly 1600 pixels — columns 780 and 781, rows 0…799. Both go to light `152` / dark `109`.

---

## 1. The two draggable boundaries are drawn from two different tokens, and it shows

| | light | vs document | vs side panel |
|---|---|---|---|
| left boundary `186` | strong hairline | **1.72:1** | 1.51:1 |
| right boundary `212` | faint | 1.31:1 | **1.155:1** |
| hover `152` | — | 2.55:1 | 2.25:1 |

`212`/`46` is the same value used for the sidebar's footer rule (y=743) and the aside's Outline/Backlinks rule (y=683). `186`/`54` is the container-stroke value. So one resize boundary is painted with the container stroke and the other with the decorative separator — the same value as two rules in the same window that are *not* draggable and cannot be dragged.

The consequence a developer will feel: the left edge looks like something, and the right edge looks like a section rule. At rest, in light mode, the right boundary is 15 levels from the aside behind it (1.155:1). It is not invisible — I can see it in the 6× crop, and it reads because the document side of it is 29 levels away — but it is unmistakably the weaker of a matched pair. And the hover jump is correspondingly uneven: the left steps `186→152` (Δ34), the right steps `212→152` (Δ60). The same gesture produces almost twice the visual change on one edge as the other.

Pick one value for "this is a grab edge" and use it on both. Right now nothing in the window tells you these two things are the same kind of control.

## 2. The left hover highlight doesn't follow the corner it lives on

This is the clearest defect and it's plainly visible in `zoom-rail-corner-hand-light.png`.

The sidebar card's right stroke is 1 px wide and turns a corner at y=13…17 (values `239, 221, 205, 189` fading into `186`). The hover state paints columns 247–248 at `152` starting at **y=18** — one row past the end of the arc — and stopping at **y=781**, one row before the bottom arc begins.

So under the pointer you get a 2 px, `152` bar that starts and stops with a hard step, leaving a 5 px pale `186` stub of arc at the top and another at the bottom, still at rest colour. Two discontinuities land on the same row: the colour changes `186→152` *and* the width changes 1 px→2 px, at y=18 exactly. It reads as a bar that has been laid on top of the card rather than as the card's own edge lighting up.

Related: the top 10 px and bottom 10 px of that boundary (y=8…17, y=782…791) never highlight at all, and the 8 px above and below the card (y=0…7, y=792…799) aren't part of the boundary in any state.

## 3. The hover thickening grows one-directionally, and it grows the wrong way on the left

Both boundaries widen from 1 px to 2 px by claiming the column to their **right**:

- left: rest x=247 → hover x=247,248, where 248 was document (`241`)
- right: rest x=780 → hover x=780,781, where 781 was aside (`227`)

Two problems. First, the visual centre of each line shifts 0.5 px right when you touch it — a small twitch under the pointer where there should be none. Second, on the left boundary this means the sidebar card's stroke thickens *outward past its own outline*: on hover the card has a 2 px right edge and a 1 px edge everywhere else, including the arc it joins. Grow symmetrically (or grow into the boundary's own inset) and both problems go away.

## 4. The resize boundary is 8 px from a permanently drawn scrollbar

The document's vertical scroller thumb occupies x=766…771 (6 px wide), light `137` on `241`, dark `135` on `24`. Its right edge is at x=771; the resize line starts at x=780. **8 px of clearance.**

That thumb is 3.10:1 against the document. The boundary next to it is 1.31:1. The decoration is more than twice the contrast of the control, sitting 8 px away from it. And a macOS overlay scroller expands on hover to roughly 15 pt, which from the pane's right edge (x=779) would put its expanded body directly against x=780. Whatever the actual hit rectangle is, that is a crowded 8 px.

While I'm on the scroller: its thumb spans y=198…744, and the document body region is y=198…744 — the thumb fills its track exactly, with antialiased caps at both ends. There is no ink anywhere in the pane between y=745 and y=782, and the last content pixel is the code block's bottom border at y=738. So the body has nothing to scroll and a full-length scroller is drawn over it anyway. macOS removes the scroller when content fits; this one is drawn at rest, at full length, on a pane that doesn't scroll.

## 5. The window has three different colours along its top edge, in 8 px

At y=0: x=0…247 is backdrop `207`/`17`; x=248…779 is document `241`/`24`; x=780 is the divider; x=781…1099 is aside `227`/`21`.

The 8 px inset that makes the sidebar a floating card is applied to the sidebar and nowhere else. The document and the aside both run flush to y=0, y=799 and x=1099. The result is a `207` strip that wraps the sidebar in an L (x=0…7 full height, plus y=0…7 and y=792…799 for x≤247) and then just stops dead at x=247. In light mode `207` is the darkest surface in the window, so this stripe is the first thing your eye lands on at the top-left, and it terminates at an arbitrary vertical seam.

There's also a wedge of document colour tucked inside the sidebar's margin: x=247, y=8…12 reads `241` — the card's corner curling away exposes the document's grey inside the inset column, one pixel wide.

Either float all three panes or float none. Right now the sidebar is a card and the aside is a wall, and the two resize boundaries inherit that: one is a 784 px rounded-ended card stroke, the other is an 800 px square rule.

## 6. Four hairline greys, two of them 4 levels apart

Light mode strokes: `121` (search field border, code block border), `182` (Properties box border), `186` (sidebar card / left boundary), `212` (separators / right boundary). Dark: `109`, `71`, `54`, `46`.

`182` and `186` are 4 levels apart in light and 17 apart in dark. Nobody can see the difference between the Properties box outline and the sidebar card outline in light mode, but they are two different values being maintained. Also note dark `109` is simultaneously the input/code border *and* the boundary hover colour, while in light those are `121` and `152` — the two schemes aren't derived the same way.

## 7. Code comments are illegible

`// A wikilink inside code is a code sample, not navigation` — the darkest core pixel of that text is `(156,160,176)` on a code block fill of `(239,241,245)`. That is **2.30:1**. Dark mode is `(108,112,134)` on `(30,30,46)` = **3.36:1**. Both fail 4.5:1 for body text, and light mode fails badly. Everything else in the window is fine (secondary text is 5.92:1 light / 11.06:1 dark, body text 16.45:1 / 15.30:1) — the code comment is the single outlier.

Separately: the code block is the only tinted surface in an otherwise strictly neutral window — `(239,241,245)` light, `(30,30,46)` dark. The dark one is visibly blue-purple against a neutral `24` document.

## 8. Selection in light mode is carried by hue alone

The selected pill (`Reading list`, both in the sidebar at y=246…277 and in the aside at y=74…105) is `(216,206,255)` on a `227` panel. That is **1.15:1** in luminance — the same figure as the weakest divider. The label ink is `19`, identical to unselected items (`Sources` is also `19`); there's no weight change and no leading bar. So in light mode "which note am I on" is signalled by a lavender tint with essentially zero lightness difference. Desaturate the render and the selection disappears.

Dark mode is the opposite problem: `(63,0,133)`, a fully saturated deep purple on a `21` panel. It's the loudest thing on screen. The two schemes don't have matched selection prominence.

## 9. The bottoms of the panes don't line up

- Sidebar footer: rule at y=743, `Rescan` / `Switch Vault` ink y=761…772, card bottom border y=791.
- Document footer: `29 lines` ink y=783…791, no rule anywhere between y=745 and y=782.

The two footer texts are ~20 px apart vertically along the bottom edge of the same window, and one sits in a bounded 48 px band while the other floats bottom-aligned 8 px off the window edge with nothing separating it from the body. The aside has a rule at y=683 and the sidebar has one at y=743, so the document's missing footer rule is the odd one out, not a deliberate minimalism.

Top edges have the same issue, less severely: the sidebar toggle glyph centres at y≈25.5, `Second Brain` at y≈24.5 — those agree — but the aside's `Outline` centres at y≈52, 27 px lower, aligning with the breadcrumb row instead. Defensible if `Outline` is meant as a section header rather than a pane title, but it currently makes the right third of the window start late.

## 10. Aside content is off-centre in its pane

Aside spans x=781…1099. The Outline pill spans x=796…1077: 15 px of left inset, 22 px of right. The sidebar's equivalent pill is x=16…239 inside a card interior of x=9…246 — 7 px each side, correct. If the 22 px on the right is a reserved scroller gutter, it isn't reserved on the left, and no scroller is drawn there.

---

## Things I checked and found fine

- **Nothing reflows on hover.** The diff is exactly 2 columns in each case; no text moves, no pane resizes. Good.
- **The dark-mode boundaries are real lines, not washouts.** `54` on `21`/`24` and `46` on `24`/`21` are visible in the 6× crops. The dark right boundary (1.31:1 / 1.35:1) is actually slightly *better balanced* than its light counterpart (1.31:1 / 1.155:1).
- **The hover colour itself is unified** — `152` light, `109` dark on both boundaries. It's only the rest state that diverges.
- **No grip dots or grab handles on the dividers.** Correct for macOS; NSSplitView thin dividers have no ornament.
- **Text contrast everywhere except code comments** — 5.2:1 to 16.5:1. No complaints.
- **Sidebar card geometry is clean** — 8 px inset, symmetric 7 px item insets, corner arc antialiases properly (`239, 221, 205, 189`).

---

## One thing I can't judge from a static render

There is no title bar and no window controls anywhere in the image, and I found zero saturated pixels in the top-left 260×60 region. The sidebar card's top strip (x=9…217, y=9…51) is completely empty — 43 px tall and 209 px wide, which is exactly where traffic lights and their inset would land. So this is either a correctly reserved full-size-content layout with the OS drawing the controls on top, or a window with no controls and no drag region at all. I'd want to see it running before calling it either way, but if it's the latter it's the most serious thing in the window.

---

## If I could only fix three

1. **Give both boundaries the same rest value** (§1) — the right one currently reads as a decorative rule, and it's the same token as two rules that aren't draggable.
2. **Make the left hover follow the corner arc** (§2) — the hard step at y=18, with a colour change and a width change on the same row, is the one thing in these renders that looks broken rather than merely uneven.
3. **Drop the document scroller when the content fits, and move it further from x=780** (§4) — 8 px between a 3.10:1 permanent decoration and a 1.31:1 control is backwards on both counts.

## What the task did with it

Nothing was patched here. §2 is this task's own doing and the fix is not in
this window: the thickening stops at the pane's corner arcs because a
splitter paints a rectangle and the pane's edge turns, so an edge that
lights up along its whole rounded run has to be drawn by the pane
pattern. §1 and §3 are the two boundaries' inherited colours and the
splitter pattern's own thickening, both of which reach the shell as well
as this window. Everything else was already in the window before this
task. All of it is pooled.

The reviewer's last section is a known limit of the render and not a
defect: the window controls are the platform's, drawn over a
full-size-content window, and a headless capture has none. The window
does declare its drag over the row's empty space and over the pane's top
strip, which `TestToolbarDeclaresWindowDrag` and
`TestPaneStripClaimsInsideTheInsetPane` assert.
