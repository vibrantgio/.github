---
date: 2026-08-29
task: BA2.1
phase: BA
reviewer-model: opus-5
reviewer-effort: unrecorded
retrofitted: true
---

# BA2.1 — fresh eyes on the MindChat window, both pane states

Captured by `TestWholeWindowRender` at the window's own opening size,
1024×768, four frames: light and dark, pane standing and pane away. Handed
to a subagent that had not seen the task packet, with one question — what
would a developer on this platform complain about? — and the two recorded
misreads briefed first (dark ink reads grey at 1×; a few pixels of margin
are as easy to miss as to hallucinate; sample before claiming either).

The reply is below verbatim. The triage follows it.

---

Sampled all four at pixel level. Report below; every number is from `PIL.Image.getpixel` on the named file.

## 1. The traffic lights are hand-drawn fakes, and the geometry is wrong

`mindchat-light-pane.png`, row y=25: red disc spans x=19–32, yellow x=42–55, green x=65–78. That is **14px diameter on a 23px pitch**, first disc's left edge at x=19, centre at (25.5, 25.5). The platform's are 12px on a 20px pitch. Worse, the fill is *perfectly flat* — every pixel of column x=26, y=20..31 is exactly `(255,95,87)`, and x=71 is uniformly `(41,200,64)`. Real window buttons carry a vertical gradient and a darker rim. Someone eyedropper'd the standard colours (`#FF5F57`/`#FEBC2F`/`#28C840` — those are correct) and drew circles.

Consequence a developer will state immediately: these are not `NSWindow` buttons, so they don't dim when the window deactivates, don't show the ×/−/+ glyphs on hover-over-the-group, don't offer option-click zoom or the full-screen behaviour, and the surrounding area is probably not a drag region. Also: they're painted *on top of the sidebar card* (background under them is `(232,232,232)`, the sidebar fill) in pane mode and on `(246,246,246)` in hidden mode — so they sit on two different surfaces depending on a UI toggle.

## 2. The scrollbar is a permanently-visible opaque bar, parked in the middle of the window

Not an overlay scroller. It's a 6px-wide solid bar with no track, present in all four captures with no pointer nearby.

- pane: x=1016–1021, thumb y=54–676
- hidden: x=901–906, thumb y=54–698

In the hidden shots the window is 1024 wide and the scrollbar sits at **x=901, with 117px of empty background (x=907–1023) to the right of it**. A scroller floating 117px inboard of the view edge is not something this platform ever does. Contrast against background is 3.03 (light) / 4.94 (dark) — this thing is *louder* in dark mode than light, and it never goes away.

## 3. Dark mode inverts the accent, and inverts it in two opposite directions in the same window

| element | light | dark |
|---|---|---|
| user message band | fill `(114,58,212)`, text `(255,255,255)` | fill `(208,196,255)`, text `(34,0,78)` |
| selected sidebar row | fill `(216,206,255)`, text `(19,19,19)` | fill `(63,0,133)`, text `(238,238,238)` |

Light mode: the user message is the *dark saturated* purple and the selected row is the *pale* purple. Dark mode: exactly the reverse. Two components using the same accent token swap polarity in opposite directions between themes. In dark mode the loudest, brightest thing on screen is a pale lavender slab, which is precisely backwards for a dark theme.

(Sampled before claiming: this is not a washed-out-at-1x artefact. Contrast is fine everywhere — user text 6.42 light / 11.05 dark, body 17.19/15.30, placeholder 6.30/9.91, sidebar secondary 5.46/11.37, link `(114,58,212)`/`(208,196,255)` at 5.94/11.01, syntax colours are properly re-toned per theme. **There is no contrast finding here.** Don't let anyone report one.)

## 4. Every surface uses one border colour, so an editable field is indistinguishable from a code span

`(121,121,121)` light / `(158,158,158)` dark on fill `(248,248,248)` / `(34,34,34)` — verified identical at all four of:

- the composer text field (256,740)
- the model-picker button (787,26) and (1005,26)
- the inline `MessageOp` code chip (463,124)
- the fenced code block (600,188)

Border-to-fill contrast 4.10 / 5.94 — heavy. Meanwhile the actual *structural* borders whisper: sidebar card border `(190,190,190)`/`(54,54,54)` at 1.52/1.51 against its own fill. So the chrome that defines the window's layout is nearly invisible while a non-interactive code snippet gets a 4:1 outline identical to the only text input on screen. And nothing in any of the four shots shows a focus ring, so there is no way to tell what the first responder is at launch.

Related: the code block fill is `(248,248,248)` on a `(246,246,246)` page — **1.02** contrast. The fill does literally nothing; the block exists only because of that heavy border.

## 5. Toggling the sidebar teleports the button you just clicked

Sidebar-toggle icon at x=184–203 in pane mode (it lives *inside* the sidebar card, which ends at x=247); at x=95–114 in hidden mode. The "+" moves x=220–231 → x=131–142. **Both jump 89px left.** The window title jumps too: "Reactive layouts" starts at x=258 in pane mode, x=164 in hidden. Click the toggle and the control is no longer under your cursor — click twice in the same spot and the second click lands on nothing.

## 6. Four different edge margins, none of them agreeing

In `light-pane`:

| element | left edge | right edge | right margin |
|---|---|---|---|
| message band (y=52–99) | 248 (flush) | 1013 | 10 |
| composer field | 256 | 1015 | 8 |
| divider above composer (y=711) | 260 | 1011 | 12 |
| code block (y=188) | ~310 | 1001 | 22 |
| model-picker button | 787 | 1005 | 18 |
| sidebar card | 8 (8px inset) | 247 (flush) | — |

The message band is **full-bleed on the left (x=248, zero gap from the sidebar divider) but stops 10px short on the right** to clear the scrollbar. So the purple slab is visibly off-centre in its own column. Same in hidden mode: band x=115–898, composer x=123–900 — left edges differ by 8px, right edges by 2px. Nothing lines up with anything.

## 7. Two separator lines that should be one line are 2px apart

Chat-side divider above the composer: **y=711**, x=260–1011.
Sidebar-side divider above the "Settings" row: **y=713**, x=20–235.

They meet at the x=247 seam with a 2px step. The bottom bars are staggered too — sidebar footer starts y=714, composer starts y=720 — though both bottom out at y=759 correctly, 8px above the window edge.

## 8. The sidebar is a rounded floating card butted flush against a full-bleed content area

Card occupies x=8–247, y=8–759: inset 8px on left, top and bottom, **flush on the right**, with rounded corners (at y=8 the card spans only x=13–242, reaching full width at y=13). The chat area has no card at all — its background *is* the window background (`(246,246,246)`/`(24,24,24)`, identical). So one half of the window is an inset rounded panel and the other half is bare window. The card's top-right rounding also means the sidebar/chat divider (x=247) only runs y=17–750 — it doesn't reach the title bar or the bottom, leaving unexplained wedges at both ends of the seam.

Worst part: the card's top border is a hairline at **y=8 running x=8→247**, cutting horizontally across the title bar 11px above the traffic lights, while the right half of the title bar is plain background. The title bar is visually split into two different surfaces.

## 9. Content abuts the title bar with nothing between them

Column x=600: background down to y=51, purple band starts at **y=52**. No divider, no separator, no material. Scrollable content runs straight into the title bar edge. There's a divider above the composer but none below the toolbar, so the top of the scroll view is a hard clip.

## 10. Dark mode loses the sidebar/content separation almost entirely

Sidebar fill `(21,21,21)` vs chat background `(24,24,24)` — **1.03** contrast, i.e. nothing. Light mode is `(232,232,232)` vs `(246,246,246)` = 1.13, weak but visible. In dark the only thing dividing the two panes is the `(54,54,54)` hairline at x=247, which itself stops short at both ends (see #8).

## 11. Square-cornered full-bleed slabs called "messages"

Verified: band rows at y=52, 53, 54, 98, 99 all span exactly x=248–1013 — zero corner rounding, no inset, no bubble. Meanwhile the composer is rounded (x=258→256 over y=720–722) and so is the code block and the sidebar card. The message rows are the only rectilinear full-bleed element in a design that rounds everything else. And the user text is indented to x=310 to line up with the assistant's text column even though user rows have no avatar, so the slab has 62px of dead space on its left and 12px on its right.

---

Nothing else worth listing. Type colours, syntax highlighting, and every foreground/background pair I sampled are theme-adapted and well above threshold — the problems here are all structural and platform-fidelity, not colour.

---

## Triage

**Misreads, for the next reviewer's briefing.** Two of the eleven are
artefacts of how the frame is captured or of a ruled design read as a
defect, and both are worth briefing in future because they will recur.

- **#1, the traffic lights.** They are the HARNESS's, not the
  application's. `window_render_test.go` draws three flat discs at the
  stored reference's measured geometry over the composed frame, and says
  so in its own comment, because a headless render has no window and
  therefore no `NSWindow` buttons — and a composition has to be judged
  with the things that will be standing in it. The live window shows the
  platform's own controls, with their glyphs, their dimming and their
  behaviours. The reviewer's 12-on-20 figure is also not this display's:
  the reference measures 14 across on a 23 pitch. Nothing here is an
  application defect, but every future capture will invite the same
  finding, so brief it.
- **#8's headline and #10's conclusion.** "Flush on the right" and "the
  hairline stops short at both ends" describe the floating pane as ruled:
  it floats off the window's LEADING, top and bottom edges, and the
  content begins where it ends. Above and below it there is a full margin
  of window ground between pane and content, so nothing merges there. The
  1.03 dark step between floor and paper is ADR-022's measured whisper
  with the pane's own outline carrying the boundary — which is the
  pattern's stated reason for drawing that outline at all.

**Already pooled, sharpened with this run's numbers** — 101 (the
scrollbar), 100 (the accent inversion), 103 (the column's disagreeing
edges), 106 (inline code drawn as a hollow box), 102 and 108's welded
half. Each carries the new measurement rather than a new number.

**Fixed by this task, marked inline in section J** — 107's fourth ink and
108's stacked headers.

**Newly recorded as 113–116** — the recall convention's horizontal jump,
the pane's outline splitting the title strip, the two hairlines two pixels
apart across the seam at the window's foot, and the absent focus ring.
