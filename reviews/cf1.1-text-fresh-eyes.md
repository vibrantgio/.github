---
date: 2026-09-13
task: CF1.1
phase: CF
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CF1.1 — the text surfaces, read cold

## The reply, verbatim

All twelve read and sampled. Here is what I found, grouped as asked.

---

## Redundant — with the platform, or with each other

**The two scrollbars in the vaultview window.** The note pane carries a permanent thumb 4 px wide (x 767–770, grey 122) running y 268–383; the outline pane carries one 6 px wide (x 1086–1091, grey 106) running y 186–674. In `notes-window.png`, captured on a note far longer than one screen, I scanned all 25 columns from x 1075 to 1099 over y 100–800 and got a single value, (30,30,30) — no scrollbar at all. The platform's scrollers are overlay and absent from a still. Beyond being redundant, the app's two disagree with each other: different width, different grey, in the same window.

**The window's own 1 px outline.** vaultview paints a (161,161,161) hairline around its rounded corners. Neither `notes-window.png` nor `textedit-window.png` has an inner frame line — the system draws the frame and shadow.

**"Second Brain" set as text at the top-left of the content pane** (x 272, y 25). That is the window title, drawn into the document area. TextEdit puts "short.txt ⌄" in the titlebar with a proxy chevron; Notes puts the document date there.

**"Rescan" and "Switch Vault" in the sidebar footer** — two bare word-labels in ink (38,38,38) on the sidebar's own (247,247,247), below a (223,223,223) hairline at y 743, with no button chrome of any kind. These are file-level commands, and the platform supplies a menu bar for exactly them. Notes' sidebar has no footer; its only in-window commands are the two toolbar icons.

**Minor:** back/forward chevrons *and* a breadcrumb both drive the same navigation inside the content pane. Notes keeps back/forward up in the toolbar. Their states are handled correctly, though — back is (129,129,129), forward (189,189,189), i.e. properly disabled.

---

## Missing for an ordinary Mac application

**The whole titlebar and toolbar.** The topmost app pixel row in `window-find-*.png` is content; the sidebar toggle is at y 26 and the breadcrumb at y 61. `notes-window.png` gives, in that same space, three coloured traffic lights — (252,94,99), (249,199,45), (61,197,94), so the window is genuinely active — six toolbar controls, and a 250 × 36 search field (x 841–1090, y 8–43, fill (35,35,35), 1 px (58,58,58) border) sitting on a toolbar band (35,35,35) that is five levels off the content (30,30,30).

**Next/previous match, and a way out of find.** I scanned x 500–770 across y 86–118 in the find row: the only ink is the counter glyphs at x 504–538. The bar says "2 of 3" and then offers no mouse route to match 3, and no Done/close. The X at x 467–480 clears the query, it does not dismiss the bar.

**A find bar.** Rows y 86 and y 118 are pure (255,255,255) across the full pane width — no band, no separator. The field floats on the page. The platform's convention, visible in Notes' toolbar, is a band with its own fill and a hairline.

**Any sign of which list has the keyboard.** The sidebar pill on "Reading room" and the outline pill on "Section 7" are the *same* value, (23,139,251) light / (25,148,252) dark, both at full strength, simultaneously. In the active Notes window the selected list row is grey (70,70,70) on (35,42,45) — the accent is being withheld because focus is elsewhere. vaultview has no such second state.

---

## Wrong for the platform

**The dimmed non-current find marks.** Current match: (250,239,189) light, (110,110,77) dark. Those are exact matches for Mail — I checked every yellow row in `mail-find-light.png` and all three occurrences of "Search" are (250,239,189), and the dark capture's single highlight colour is (110,110,77). The invention is the *other* matches: (252,247,222) light and (70,70,54) dark. The light one measures 1.08:1 against the page — at 1 px per point it is all but gone. Mail does not pale down its non-current hits at all.

**Document ink at full black and full white.** Body text in the markdown renders is (0,0,0) on (255,255,255) — 21.0:1. Mail's light body ink is (39,39,39), 14.9:1. Dark body is (255,255,255) on (30,30,30) — 16.7:1, against Notes' (220,220,220) and Mail's (221,222,223), both 12.2:1. (TextEdit is the one reference that does use 255, for plain-text document content.) The app contradicts itself here: its own chrome labels — "Reading room", "Rescan" — are (38–39,38–39,38–39), the platform value, while the document surface is heavier. The secondary greys, by contrast, are right on: blockquote (128,128,128) light equals Mail's secondary exactly, and (154,154,154) dark is within two levels of Mail's (156,159,159).

**Three different blues.** The task checkbox is (0,122,255) — system accent, exactly, at the correct 14 × 14 (x 24–37, y 535–548). The selection pill is (23,139,251). Links and the breadcrumb's "guide" segment are (0,104,218). Also, painting a path-bar segment in link blue makes a breadcrumb read as hypertext.

**Dark-mode pane order is inverted.** vaultview dark: sidebar (28,28,28) and outline (28,28,28), content (30,30,30) — the flanks are *darker* and flat neutral. Notes dark: sidebar (30,34,37), note list (35,42,45), content (30,30,30) — the flanks are *lighter* and carry a blue tint from what is behind the window. The seam itself is fine in dark, (61,61,61) against 28/30, about +31, next to Notes' (58,69,73) against (30,34,37). The light seam is the outlier: (145,145,145) against white, a 110-level step.

**The code fence brings its own night.** Dark fence ground is (30,30,46) inside a (30,30,30) window — 16 levels of blue that belong to the syntax palette, not the window. Its comment ink measures 3.36:1 dark, and 2.30:1 light — (156,160,176) on (239,241,245) — which is below the platform's own secondary label (128 grey on white is 3.95:1), and it is the comment line that runs off the edge. The fence also keeps a permanent horizontal scroller: y 1010–1015, 6 px tall, (104,105,105), a 297 px thumb.

**A sliced row in the outline.** The entry above "Section 6" survives only as its bottom six pixels, y 72–77 — letters cut through the middle, under an "Outline" header that has no band or material of its own to justify the cut.

**Both search fields are 28 px tall** — find field x 272–495, y 88–115; sidebar field x 16–239, y 52–79 — against the 36 px of the only system search field I can measure, Notes' toolbar one. The find field's focus is a single (128,179,250) hairline with no ring, the sidebar field has no border at all (white fill on 247), and the clear control is a bare 14 × 14 X stroked in grey 128 rather than a filled glyph.

**Small:** "122 lines" in (128,128,128) at the foot of the text column, flush with the prose and with no status bar around it. Neither reference window shows a document readout like this.

---

## Two caveats on my own numbers

Only one light system capture exists in the reference set — the Mail body crop — so every light-mode comparison above rests on that one file; `notes-window`, both `notes-reading` crops and `textedit-window` are all dark. And a typography note I cannot settle from images alone: the reading sample's ramp is clean (cap heights 18 / 16 / 14 / 13 over body 11), but in `heading-word-light.png` the second and third heading lines both measure a 16 px cap ('V' y 55–70, 'I' y 91–106), so two levels there are indistinguishable — whether that is a flattened ramp or simply two headings of the same level in the fixture, I can't tell without the source.

## How it was asked

Four offscreen renders at 1 px per point, the gallery's two markdown sections
in both appearances: `markdown-reading-{light,dark}.png` and
`markdown-code-{light,dark}.png`, each drawn with its own heading above it on
the appearance's window plane.

The gallery carries no find specimen and no heading-word specimen, so the
same renderer's stored images were handed over beside them:
`workbench/vaultview/testdata/golden/note-find-{light,dark}.png` and
`window-find-{light,dark}.png` — whole application windows, which is why the
reply also reports on that window's chrome — and
`markdown/testdata/golden/heading-word-{light,dark}.png`.

Beside those, six stored captures of this machine's own system:
`mail-find-light.png`, `mail-find-dark.png`, `notes-window.png`,
`notes-reading-top.png`, `notes-reading-bottom.png` and
`textedit-window.png`.

The reviewer had seen neither the plan nor the packet, was given no
checklist, was told to compare against the captures and never against macOS
from memory, was handed the recorded misreads verbatim, and was asked the one
question of this task.
