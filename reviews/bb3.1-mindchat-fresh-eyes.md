---
date: 2026-08-30
task: BB3.1
phase: BB
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BB3.1 — fresh eyes on the MindChat window after the picker took the anchor face

Captured by `TestWholeWindowRender` at the window's own opening size,
1024×768, both colour schemes with the pane standing. Handed to a subagent
that had not seen the task packet, with one question — what would a
developer on this platform complain about? — and three recorded misreads
briefed first: dark ink reads grey at 1× and must be sampled; chrome
furniture darker than the content pane is this system's ruling, not a
platform-convention violation; and the anchor's paired chevrons not
changing when its menu opens is the platform's own behaviour, not a
missing state.

**What the task was watching for, and got.** BB1.1's review named the
picker's shape as its one chip complaint: "a hand-rolled full-radius pill
with a hard 1px border and a single down-chevron; a native pop-up is a
rounded-rect with the paired up/down chevrons." This review, given the
same window at the same size with the same question, does not mention the
picker's shape, its corner, its mark or its fill anywhere in six findings.
It cites the picker twice, both times as a measurement of something else —
its bounds in the edge-alignment tally and its height in the title-bar
tally. The complaint that opened this goal is closed.

Two other things it did NOT say are worth recording, because they were
live questions going in. It did not read the anchor as detached from its
label — pool item 95's complaint about a mark reserved its whole line box,
which the anchor face sidesteps by reserving the platform's own ratio of
the control height instead. And it did not confuse the anchor with the
composer's text field, though pool item 106 records that the two wear the
same hairline; the anchor's corner is now the button's rather than the
field's neighbour.

The reply is below verbatim. The triage follows it.

---

## What a macOS developer would complain about

Everything below is sampled from the two PNGs; the macOS comparisons are measured against the stored reference in `/Users/rene/code/w/vibrantgio/.github/reference/macos/`, not from memory.

---

### 1. The dark scheme runs systematically hotter than the light scheme, and it costs the composer its placeholder

The same semantic role lands at roughly double the contrast in dark. Paired measurements (WCAG contrast ratio, against each scheme's own backdrop):

| role | light | dark | ratio |
|---|---|---|---|
| primary text (`#131313` / `#EEEEEE`) | 17.05 | 15.04 | 0.9× |
| secondary text (`#5C5C5C` / `#CCCCCC`) | 5.46 | 11.37 | **2.1×** |
| composer placeholder | 6.30 | 9.91 | 1.6× |
| user message band vs page | 5.94 | 11.01 | 1.9× |
| control hairline (`#797979` / `#9E9E9E`) | 4.04 | 5.94 | 1.5× |
| scrollbar thumb vs page | 3.03 | 4.94 | 1.6× |

The consequence is concrete, not academic. The primary→secondary step is 17.05 → 5.46 in light (a 3.1× drop) but 15.04 → 11.37 in dark (1.3×). Secondary text barely recedes in dark mode: "Cassowary layout", "Simplex noise", "Popover dismissal", "Settings" and the composer placeholder are all one token, `#CCCCCC`, and at 9.91:1 on the composer's `#222222` fill **"Send a message" reads as a message already typed into the box**, not as a prompt. In light the same placeholder sits at 6.30:1 against 17.05:1 body copy and correctly reads as empty.

This is not the pale-band false positive — the dark band's own ink samples at `#22004E` on `#D0C4FF` = 11.05:1, which is fine. The problem is one level up: the two palettes were tuned by eye per scheme with no shared contrast target.

### 2. Nothing in the content pane shares a left or right edge

Sampled edges, in a pane that spans x=248–1023:

| element | left | right |
|---|---|---|
| user message band | 248 | 1013 |
| composer box | 256 | 1015 |
| composer separator hairline | 260 | 1011 |
| title text / model picker | 261 | 1011 |
| body text, list markers, code block | 310 | 1001 |
| scrollbar thumb | 1016 | 1021 |

Five distinct left edges and five distinct right edges. The worst pair is functional: you type at x=273 (placeholder ink), inside a box starting at x=256, and the message renders at x=310 inside a band starting at x=248 — three left positions for the same sentence. The composer's own separator hairline is inset 12px/12px while the box it separates is inset 8px/8px, so the line is visibly narrower than the field 9px beneath it.

Verified as *not* a defect while measuring: list indentation is clean — paragraph, bullet marker and ordinal marker all start at x=310, text at 334–335, nested bullets at 335.

### 3. Two purple blocks sit side by side across the divider and start 8px apart

The sidebar's selected row spans y=44–85 (42px tall). The first message band spans y=52–99 (48px tall). Both are the accent colour, they are 1px apart horizontally across the divider at x=247, and their top edges disagree by 8px while their bottoms disagree by 14px. It reads as a stair-step, and it is the first thing in the window.

The root cause is that the two halves of the title bar end at different heights: the sidebar's toolbar bottoms out at y=43, the content pane's at y=51, even though both hold the same-size controls (traffic lights y=19–32, model picker y=8–43).

### 4. The scrollbar is half-width, has no groove, and permanently eats a gutter

Measured against `textedit-scrollbar.png` and `textedit-scrollbar-min-thumb.png`:

| | macOS reference | this app |
|---|---|---|
| thumb width | 11px | **6px** |
| gutter | 16px | 10px |
| groove behind thumb | yes, filled capsule `#252525` | **none** |
| at rest | absent entirely (`textedit-scrollbar-absent.png` is uniform `#1E1E1E`) | present |

Both are rounded capsules, so the shape is right; the size is not. And because the app reserves the gutter rather than overlaying, the thumb's 623px of travel (y=54–676) is followed by 35px of bare page colour with nothing drawn in it — a floating grey stick above an unexplained gap.

### 5. The reserved gutter breaks the user band's full bleed on one side only

Direct consequence of #4, but it deserves its own line because it is the loudest element on the page. At y=60 the band runs `#723AD4` from x=248 to x=1013, then `#F6F6F6` at 1014–1015, the thumb at 1016–1021, then `#F6F6F6` again to 1023. So the band touches the sidebar divider flush on the left and stops 10px short on the right. Every question in the transcript has a bite taken out of its right edge.

### 6. Code block and composer surfaces are invisible; only the stroke holds them together

Code block fill is `#F8F8F8` on a `#F6F6F6` page — contrast ratio **1.02**. Dark is `#222222` on `#181818` — **1.12**. The entire read comes from a 1px stroke at `#797979` (4.04:1) / `#9E9E9E` (5.94:1). That is a heavy outline by macOS standards — the reference sidebar gutter stroke in Notes is `#364148` on `#212B2B`, barely visible — and it means these surfaces are drawn as wireframes rather than as material. The dark stroke at `#9E9E9E` is lighter than any other piece of dark chrome in the window.

---

### Checked and cleared — do not re-review

- **Traffic lights are pixel-exact.** Red x19–32, yellow x42–55, green x65–78, all y19–32, centres at cy 25.5, pitch 23px, diameter 14px — identical to `notes-window.png`, `finder-window.png`, `reminders-window.png`, `mail-window.png` and `voicememos-window.png`.
- **The sidebar's inset panel is correct.** 8px gutter, 1px stroke at x=8, panel from x=9 — the same structure as the reference, and the gutter is lighter than the panel in both schemes, matching macOS's direction (`#212B2B` gutter over `#1B2023` panel in Notes).
- **Selected-row fill contrast is in spec.** App light 1.21, dark 1.35; Notes' selected row is `#2A2F31` on `#1B2023` = 1.21. Selection is carried by the 2px leading accent bar in both, same as macOS.
- **Syntax colours are scheme-specific and all pass.** Keywords `#D03A42`→`#FF7B72`, identifiers `#6639BA`→`#D2A8FF`; lowest measured is 4.53:1.
- **Dark ink on the pale band is fine** (11.05:1), as flagged.

### Unresolvable from these files

Both PNGs are RGB with no alpha channel, and every corner pixel is that scheme's page colour (`#F6F6F6` / `#181818`) with no curve — while all five reference windows have alpha-0 corners at a radius of roughly 26px. This is most likely the Gio framebuffer captured before the window server's corner mask, not a square-cornered window. It cannot be settled without a capture that preserves alpha, so I am not calling it a defect.

---

## Triage

Nothing here is in BB3.1's scope and nothing here is the shape this task
was cutting. Checked against pool items 89–121 before anything was
recorded:

- **1, the two schemes' contrast asymmetry**, is NEW and is pooled as
  item 122. It is not item 89 (that is ink bloom — how much ink one label
  lays, a rasterisation property) and it is not item 107 (that is one ink
  spent on three roles inside the light scheme). This is the two schemes
  measuring differently for the same role, with a named consequence: the
  composer's placeholder reads as typed text in the dark scheme and as a
  prompt in the light one.
- **3, the stair-step across the divider and the split strip heights**,
  is NEW and is pooled as item 123. Item 108 has the transcript welded to
  the chrome and item 115 has the window's foot answering itself at two
  heights; neither has the window's HEAD ending at two heights, which is
  the measurement under this one.
- **2 (edges), 5 (the band's bitten trailing edge)** are item 103, which
  BA2.1 already sharpened with these same coordinates. One detail is
  added to it: the composer's separator hairline is inset 12 px where the
  box it separates is inset 8 px.
- **4, the scrollbar**, is item 101, sharpened with the reference
  comparison this review made — 6 px thumb against the platform's 11,
  10 px gutter against 16, no groove where the platform fills one, and
  the gutter reserved rather than overlaid.
- **6, the invisible surfaces held by a heavy stroke**, is item 106,
  already sharpened by BA2.1 with these same numbers.
- The **unresolvable corner-radius note** is the harness, not the app:
  `TestWholeWindowRender` draws into a headless canvas that never meets
  the window server. It joins the misread briefing for the next review.
