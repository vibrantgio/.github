---
date: 2026-09-05
task: BR1.4
phase: BR
reviewer-model: claude-opus-5[1m]
reviewer-effort: unrecorded
---

# BR1.4 fresh-eyes review — the status specimens and the arrival highlight

Two reviewers, neither of which had seen the packet or the plan, each
given no checklist and one question: what would a developer building a
desktop application on this toolkit complain about? No model override
was passed, so both inherited the dispatching session's model. Both were
told to sample pixels rather than judge fills by eye, and both were
handed the three recorded misreads — dark foreground reads grey at 1x,
the quietest step of a tinted surface is a designed whisper, and chrome
regions sharing one fill are doing so by design.

All images are offscreen renders at 1 px per dp, no application
launched; they are the stored goldens as BR1.4 left them.

The first reviewer was shown six: the badge section on all three levels
in each scheme, cut from the components board; a band cut from the
patterns board in each scheme; and vaultview's whole window, 1100x800,
the size it opens at, captured on arrival so one block of the note
carries the highlight. **The band cut from the patterns board missed the
alert and toast sections** — the crop landed on the navigator, pane and
table specimens instead — so the alerts and toasts went to a second
reviewer, on the same question, with the band cut correctly.

## Reviewer one, verbatim — badges, and vaultview's arrival highlight

I opened all six at full size and sampled pixels. Here is what I would file.

---

## 1. The disabled foreground token is the same value as real surface fills. Disabled controls vanish.

`window-arrival-light.png`: the disabled forward arrow at (306, 61) is **`#D4D4D4` on paper `#F6F6F6` — 1.37:1**. Dark: **`#2E2E2E` on `#181818` — 1.31:1**. Already borderline invisible on the flattest surface in the system.

Now look where else those exact bytes appear:

- `#D4D4D4` is the pane fill in `alerts-light.png` (sampled at 500,300), the neutral badge fill, and the pressed-chip fill.
- `#2E2E2E` is the dialog-level surface in `badges-dark.png` (row background at 130,366), the dialog toolbar strip, and the pressed-chip fill.

So a disabled label on a pane in light mode, or in a dialog in dark mode, is **`#D4D4D4` on `#D4D4D4` / `#2E2E2E` on `#2E2E2E` — 1.00:1. Gone.** That is not a hypothetical; the pane specimen and the dialog specimen in these very boards are painted in the disabled-foreground colour. A developer will hit this the first time they put a disabled button in a dialog, and there is nothing in the picture that would let them predict it.

Related, same screenshot: the enabled back arrow is `#7A7A7A` on `#F6F6F6` = **3.97:1**, and its disabled twin is 1.37:1. Both are too weak, and the pair reads as "one faint arrow and empty space" rather than "enabled and disabled".

## 2. Elevation is a dark-mode-only feature. The "three storeys" board demonstrates one storey in light.

`badges-light.png` row backgrounds: paper `#F6F6F6`, card `#F8F8F8`, dialog `#FBFBFB`. Adjacent steps are **1.02:1 and 1.03:1; the full ladder end-to-end is 1.04:1**. That is not a "quiet step" — that is the entire ladder inside four 8-bit units.

`badges-dark.png`: `#181818` → `#222222` → `#2E2E2E`, **1.12 and 1.17, 1.31 end-to-end**. Roughly eight times the separation of light.

Worse, the badges themselves:

| | paper | card | dialog |
|---|---|---|---|
| light Success fill | `#BDDDBD` | `#BDDDBD` | `#BDDDBD` |
| dark Success fill | `#19341C` | `#314D33` | `#314D33` |

Byte-identical across all three rows in light. In dark it steps once (paper→card) and then stops. Same for all five variants and for the label colours (`#5C5C5C` on every light row; `#9B9B9B` on paper but `#CCCCCC` on card *and* dialog in dark).

The board's own caption promises five variants on three storeys. It delivers **one storey in light and two in dark**. I would file this as: elevation does not exist in the light scheme, and the component's response to elevation differs between schemes, so I cannot write one layout and trust it in both.

## 3. Contrast is not stable — light is pinned at the legal floor, dark decays as you nest.

Every light badge lands on the same number:

```
Neutral #5C5C5C on #D4D4D4 = 4.51
Success #006B1F on #BDDDBD = 4.56
Warning #894D00 on #F0CEB1 = 4.53
Error   #B12322 on #F9C9C3 = 4.52
Info    #025EA5 on #BAD7F8 = 4.50
```

4.50 on the nose. That is small text with **zero headroom** — any subpixel rendering, any non-sRGB display, any 0.5px stroke and it is under. The selected chip at rest is the same story (`#605583` on `#D7CFF7` = 4.53), as is the pressed unselected chip (4.51).

Dark starts generous and then loses it with depth: the same badges are **8.42 on paper and 5.80 on a card or dialog** — a third of the contrast gone by moving a component one level up. Secondary text does the same: `#9B9B9B` is fixed while the surface climbs, so it goes **6.39 on paper → 4.89 in a dialog**. Extrapolate one more level and dark mode is under AA. Light never decays but never has margin either.

So the two schemes disagree about which direction legibility moves when you nest, and neither gives a developer a number they can plan against.

## 4. The code surface is a hardcoded third-party palette that ignores the theme, and its comments are unreadable.

`window-arrival-light.png`, code panel at (600,600): fill `#EFF1F5`, text `#4C4F69`, comments `#9CA0B0`, keyword `#D2163B`. Dark: `#1E1E2E` / `#CDD6F4` / `#6C7086` / `#F38BA8`. That is Catppuccin Latte and Mocha, verbatim. Every other surface in this window is strictly neutral (`#F6F6F6`, `#E8E8E8`, `#D4D4D4` / `#181818`, `#151515`, `#111111`, R=G=B). The code panel is the only blue-violet thing on the page — in dark it is a visibly purple `#1E1E2E` block sitting on a neutral `#181818` page, which reads as a rendering bug, not a design.

It leaks: the **text input** at (273,500)–(748,540) — the field containing "code" — is painted from the same foreign base. So inputs will not match the chrome the app was built from.

And the comments are the worst text in the window: **`#9CA0B0` on `#EFF1F5` = 2.30:1 in light, `#6C7086` on `#1E1E2E` = 3.36:1 in dark.** Both fail. In a notes app the comment line is the content — `// A wikilink inside code is a code sample, not navigat…` is the sentence explaining the feature, and it is the least legible thing on screen.

## 5. The horizontal scrollbar is the loudest element in the document.

Same window, thumb bbox **(287,643)–(705,648)**: a 419×6px opaque slab, `#5C5C5C` light / `#CCCCCC` dark. Those are the *muted text* token values — **5.91:1 against the code panel in light, 10.21:1 in dark**. It is higher contrast than the code it is scrolling and it spans 93% of the track, which means the content overflows by about 7% and the toolkit responds with a full-weight black bar. It sits 1px off the panel fill's bottom edge, eating the panel's bottom padding, so it reads as a rule or a progress bar rather than a scrollbar. Meanwhile the clipped text just stops mid-word ("not navigat") with no fade or ellipsis.

## 6. The badge close mark's hover and press states are below the threshold of perception.

`badges-light.png`, dismissible row: chip fill `#BAD7F8`, close-mark hover fill `#9DB9D9` — **1.37:1**. Press `#7F9BBA` — 1.94:1. Dark: hover `#304A64` on `#173049` = **1.47:1**, press 2.63:1. A user cannot tell the × is a target.

The shape is wrong too: the hover fill bbox is **(331,428)–(348,443)** with dead-square corners at the top-left (x=331 is full fill, no antialias ramp) while the chip it lives in is a pill. It is a rectangle stuffed into a rounded end.

## 7. "Selected" has three different answers.

- Chip, selected at rest: `#D7CFF7` light / `#312948` dark (`badges-*.png`)
- Navigator row, specimen: `#BDAAFF` / `#5C15B7`, drawn **full-bleed with square corners**, bbox (24,31)–(215,66), panel edge to panel edge (`alerts-*.png`)
- Navigator row, real app: `#D8CEFF` / `#3F0085`, drawn as an **inset rounded pill**, bbox (16,246)–(239,277) (`window-arrival-*.png`)

Three fills, two shapes, for the same idea. The specimen board and the shipping app disagree about both the colour and the geometry of a selected sidebar row. Whichever is right, a developer reading the gallery will build the wrong one.

Separately, the light selection is a pale wash (`#D8CEFF`) while the dark selection is a saturated brand slab (`#3F0085`). Same component, two completely different levels of assertiveness between schemes.

## 8. Two category dots are the same colour in dark mode, in the one place the dot is all you have.

`alerts-dark.png`: Everything dot `#D0C4FF`, Components dot `#D0C5FA`. **1.00:1 between them.** In light they are clearly distinct — `#723AD4` (vivid) vs `#625886` (grey-purple). The dark palette normalises all four dots to the same luminance (11.32, 11.35, 11.36, 11.34 against the panel), and since two of them are in the purple family, they collapse. The collapsed rail at x=240–288 shows *only* the dots — no labels — so in dark mode two of four categories become indistinguishable exactly where the dot is the sole identifier.

While there: on the selected row in light, the dot is `#723AD4` on `#BDAAFF` — **3.17:1**, the indicator half-disappearing into its own selection.

## 9. The accent colour does triple duty with no differentiation.

Light: link text is `#723AD4`. The "Everything" category dot is `#723AD4`. Byte-identical. Selection tints are the same hue family. A coloured dot in a sidebar looks like a hyperlink, and nothing distinguishes "this is clickable" from "this is a category swatch".

## 10. The arrival highlight looks like a rendering artifact.

`window-arrival-light.png`, bbox **(272,388)–(576,411)**, fill `#D9D6AD` (dark: `#322F09`).

- **Square corners.** (272,388) is already full fill, no antialias. It is the only hard-cornered filled element in the entire window — the search field, both selection rows, the input, and the code panel are all rounded.
- **Zero horizontal padding.** The rectangle starts at x=272; the glyphs start at x=273–274. It butts directly against the first letter and stops on the final period.
- The khaki `#D9D6AD` is in no other token I sampled — the status palette is grey/green/orange/red/blue, the accent is purple. This is a sixth hue introduced for one feature, and it is desaturated enough to read as dirt rather than as a marker.

It also means this single screenshot contains **three different "you are here" signals in two visual vocabularies**: the sidebar pill (purple), the outline pill (purple, identical fill `#D8CEFF` but meaning something else — which heading, not which note), and the body slab (khaki, square). Nothing tells the user, or the developer, which is which.

---

Two notes on the material itself: `alerts-light.png` / `alerts-dark.png` do not contain alerts or toasts — the crop shows a navigator, a "Pane" specimen, and the top edge of a "Table" board. And the chrome sharing one fill (`#E8E8E8` / `#151515` across sidebar, footer, and right panel, with clean 1px `#BEBEBE` / `#363636` rules at x=247 and x=780) is consistent and I have no complaint about it.

## Reviewer two, verbatim — the alerts and the toasts

I sampled both boards extensively. Here is what I would file.

## 1. All four alerts use the identical icon — a play triangle

I extracted the icon glyph mask from each of the four alerts and compared them pixel for pixel. They are **identical**: an 11×21 solid right-pointing triangle, same coverage map in all four rows (light board, x 45–55). Only the fill colour differs (`#005EA5` / `#006B1F` / `#894D00` / `#B12322`).

So the four statuses are distinguished by colour alone in the icon slot. Worse, a right-pointing solid triangle is a *disclosure caret* — it reads "click to expand" or "play". Every alert on this board looks like a collapsed tree row. That is a false affordance in the one glyph that is supposed to say "error".

## 2. Status is encoded in hue and nothing else — by construction

Converting to OKLCh shows the palette is a mechanical hue rotation with lightness and chroma pinned:

| light alert fill | hex | L | C | H |
|---|---|---|---|---|
| info | `#BAD7F8` | 0.869 | 0.055 | 252 |
| success | `#BDDDBD` | 0.866 | 0.055 | 145 |
| warning | `#F0CEB1` | 0.873 | 0.055 | 62 |
| error | `#F9C9C3` | 0.876 | 0.056 | 27 |

Same locking in dark (L 0.296–0.308, C 0.054–0.056). Same for the icons (all pinned to exactly 4.50–4.56:1 in light, 4.85–4.88:1 in dark) and the toast bars (5.54–5.56:1 light, 7.61–7.63:1 dark).

Combined with the identical glyph, this means **there is no non-colour channel at all**. Consequences I can demonstrate:

- **Greyscale/print**: all four alerts become the same swatch. Contrast against the page is 1.37 / 1.36 / 1.37 / 1.37 — identical to two decimals.
- **Deuteranopia** (simulated): the light alert fills become `#CFCFF8` (info), `#D4D4BE`, `#D9D9B0`, `#D9D9C2`. Success, warning and error are three shades of the same khaki — error and success differ by 4 in one channel. The toast bars are worse: error `#A6A659` vs success `#989856`. "that image could not be read" and "the seed was saved" become the same colour bar with no other differentiator.

This is not a subtle accessibility nit. Roughly 1 in 12 men cannot tell your error toast from your success toast.

## 3. Warning renders as brown, not amber, wherever it's pushed dark

The lightness pinning forces the warm hues out of gamut and chroma collapses only for warning:

- light icon: warning `#894D00` C=0.111 vs error `#B12322` C=0.178
- dark bar: warning `#6B3B02` C=0.092 vs error `#93000C` C=0.170

So the light-scheme warning bar is a clean amber `#E08100` (C=0.159) but the dark-scheme warning bar is mud `#6B3B02`. Same component, same status, and in dark it reads as "disabled" or "stale", not "caution". The system holds contrast constant and lets the semantics rot.

## 4. Alerts have no dismiss, no action, no title/body

I scanned the right 240px of every alert in both schemes: 0 non-fill pixels (2 antialias pixels on the light corners). There is no ×, no "Retry", no "View log", no secondary line.

An alert that says **"The build could not start"** and offers the user literally nothing to do about it, and no way to close it, is a coloured `<p>`. Same for the toasts — no dismiss, no dwell indicator, nothing that says this thing will leave.

That's the complaint I would open first, because it's the one that blocks shipping.

## 5. Alerts are a fixed 520px in a 900px window

Every alert spans x 24→543 regardless of content. "Deploy finished" ends at x=180, leaving ~360px of dead tinted fill, and the board's right half is empty while the section header band spans the full 900. Either the alert has a hardcoded width or an undocumented max-width; either way at desktop widths these look like a layout bug.

## 6. Toasts invert the scheme, and that costs them their status fill

Toast surface is `#222222` in the light board and `#E8E8E8` in the dark board — 14.72:1 and 14.49:1 against the page. In a dark app the toast is the single brightest object on screen, brighter than anything else in the frame.

I understand the inverse-surface intent, but note the practical cost: because the toast surface is scheme-inverted, it cannot carry the status tint the way the alert does. Status is demoted to an 8px bar at x 24–31. And the board's own copy admits it doesn't work — every toast string starts with the status word: *"Error — that image could not be read."*, *"Warning — contrast is below target."* If the bar were sufficient, the caller wouldn't have to type the status into the message. That pushes semantics into the string, where it can't be localised, styled, or read by a screen reader as a role.

## 7. The toast stack merges into one slab

Toast bodies are 36px with 8px gaps, but the drop shadow reaches ~9px. Scanning down x=255 in the light board: toast ends at y=451, then `#D2D2D2` (452) → `#D6D6D6` → `#DCDCDC` → `#E0E0E0` (459), then the next toast at 460. **The gap never returns to the page background `#F6F6F6`.** Four separate transient messages read as one continuous dark column with faint grey seams.

In dark the opposite failure: the shadow under the chip is `#131313` against a `#181818` page — 1.09:1, no lift whatsoever, and the ambient edge above the chip is `#171717`. The elevation you paid for in light does nothing in dark.

## 8. Toast type is the smallest on the board

Toast text measures 12px tall including descenders (y 429–440); the alert text is 16px (y 117–132). The transient message that flashes in a screen corner and must be read at a glance is set smaller than the persistent banner sitting in the page that the user can read at leisure. That's backwards.

## 9. Smaller things I'd still file

- **Ordering is inconsistent on the same board.** Alerts run info → success → warning → error, top to bottom. Toasts run error → warning → success → info. Pick one.
- **Alert boundary is 1.31–1.37:1 with no border and no shadow.** I scanned x=520 vertically: fill goes straight to page background, no stroke, no ramp. The tinted fill is simultaneously the container edge *and* the primary status signal, at a ratio below the 3:1 non-text boundary threshold. The hue difference carries it visually, which is exactly the problem — see item 2.
- **No long-content specimen anywhere.** Every alert and toast is one short line. Toast width is fixed at 241px and the longest string already reaches x=240 of a 264 box. Nothing on this board shows what happens to `dial tcp 10.0.0.4:5432: connect: connection refused`. That is the message developers actually put in error alerts.
- **"Outlined" and "Filled" cards have the same fill.** Both `#F8F8F8` in light (1.02:1 against the `#F6F6F6` page), both `#222222` in dark. The only difference between the two named variants is that one has a `#8B8B8B` border. "Filled" doesn't fill anything.
- **Dark-scheme title bar is a glare band.** `#D0C4FF` at 11.01:1 against a `#181818` page, 44px tall, full width. Also the brand colour changes character completely between schemes — saturated `#723AD4` in light, pastel `#D0C4FF` in dark — so an app's brand identity doesn't survive the theme switch.

## The one-line version

The status system has exactly one channel — hue — and it is spent on a glyph that means "expand", a fill at 1.3:1, and an 8px bar; and the alerts themselves are inert banners with no dismiss and no action, so I couldn't ship a single real error state with them.

## Triage

**What the task was watching for, and did not get.** Neither reviewer
said the warning and the error read as one family, and neither called
the four status fills fewer than four. Reviewer two listed all four
light fills and their hues side by side — error 27°, warning 62°,
success 145°, info 252° — and its complaint about them is that the set
carries no channel but hue, not that two members of the set have
collapsed. Reviewer one listed the four badge foregrounds and their
ratios without remarking on any pair. The narrowing this task performed
— the closest pair goes from 56.2° to 35.35° at the anchors, 30.18° and
0.0286 in OKLab as realized — did not cost the set its four-ness at the
sizes these boards draw.

**Nothing was cheap and in scope.** Every finding below is either older
than this task or a consequence of the ruling this task executes, and
none of them is a colour a line of BR1.4's own diff could put right.

Bearing on this task, for pooling:

- Warning's chroma at depth. Reviewer two, item 3: sRGB starves the
  orange where it holds the red, so the dark scheme's warning mark comes
  out `#6B3B02` at chroma 0.092 beside an error at 0.170, and reads as
  stale rather than as caution. The amber anchor had the same problem
  one step worse (0.0977 against the same error) and answered it with a
  hue-versus-depth rule this task removed as unnecessary for the orange;
  the removal is right for hue and does not address chroma, which no
  rotation of an orange can fix inside sRGB. What would is a rule about
  chroma at depth, and that is a derivation change, not a repin.
- The reserved highlighter reads as dirt. Reviewer one, item 10: the
  light fill `#D9D6AD` is "desaturated enough to read as dirt rather
  than as a marker". It is the container dial, 0.055, which is the
  construction the file insists on so that the highlight differs from
  the four status fills in hue and nothing else. sRGB holds 0.185 at the
  light depth and only 0.0650 at the dark one, so the light fill could
  be made more yellow and the dark one could not — the two schemes
  cannot move together, and moving one alone is a new derivation.
- The status set carries one channel. Reviewer two, item 2: identical
  glyph, pinned lightness, pinned chroma, so hue is the whole of the
  signal, and simulated deuteranopia collapses success, warning and
  error into three shades of one khaki. Moving warning from 56.2° to
  35.35° off the error narrows the margin this failure already had.
  Older than this task and unfixable inside it, but this task made it
  tighter and it should be recorded that way.

Not this task's, recorded rather than discarded:

- The disabled foreground is the same value as three real surface fills,
  so a disabled control in a dialog measures 1.00:1 (reviewer one, 1).
- Elevation separates by 1.04:1 end to end in light against 1.31:1 in
  dark, and the badge fills step with the level in dark and not at all
  in light (reviewer one, 2).
- Marks land at 4.50–4.56:1 in light with no headroom, while dark starts
  at 8.42:1 and decays to 5.80:1 one level up (reviewer one, 3).
- The code surface is a hardcoded third-party palette, its comments
  measure 2.30:1 light and 3.36:1 dark, and the text input is painted
  from the same foreign base (reviewer one, 4).
- The horizontal scrollbar thumb reads at 5.91:1 over the code it
  scrolls, wider than the panel's own padding (reviewer one, 5).
- The badge close mark's hover and press states measure 1.37:1 and
  1.94:1, and the hover fill is a square in a pill (reviewer one, 6).
- A selected row has three fills and two shapes across the specimen
  board and the application (reviewer one, 7).
- Two of the four category dots are byte-identical in dark, in the
  collapsed rail where the dot is the only identifier (reviewer one, 8).
- Link text and a category dot are the same byte (reviewer one, 9).
- The arrival highlight has square corners and no horizontal padding,
  which is how BP2.1 drew it; only its colour moved here (reviewer
  one, 10).
- All four alerts wear one glyph, and it is a disclosure caret
  (reviewer two, 1).
- Alerts and toasts offer no dismiss, no action and no second line
  (reviewer two, 4).
- Alerts are a fixed 520 wide whatever they hold (reviewer two, 5).
- The toast's inverted surface demotes status to an 8-wide bar, and the
  specimen copy compensates by typing the status word into every message
  (reviewer two, 6).
- Stacked toasts never return to the page between them in light, and
  their shadow lifts nothing in dark (reviewer two, 7).
- Toast type is set smaller than alert type (reviewer two, 8).
- Alerts and toasts order their four roles oppositely on one board; the
  alert's fill is both its edge and its signal at 1.31–1.37:1; no
  specimen shows long content; the outlined and filled cards share one
  fill; the dark title bar is a glare band and the brand changes
  character between schemes (reviewer two, 9).
