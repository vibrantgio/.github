---
date: 2026-09-02
task: BQ1.1
phase: BQ
reviewer-model: Opus 5
reviewer-effort: unrecorded
---

# BQ1.1 fresh-eyes review — the ghost wash after the floor

## What the reviewer was given

Three images, and nothing about the task:

1. `sitedocs`' whole window at the size it opens, 1200x800, on the Components
   tab — the component inventory, light scheme, captured from the running
   application.
2. A stitched pair of strips from the components gallery's `patterns` tiles,
   light above dark, cropped to the Popover and Tooltip specimens. Those two
   specimens draw their ghost icon trigger hovered, so they are where the
   floored wash actually appears.
3. The same window's Theme tab, the generated palette.

It was told only what each image was and asked one question: what would a
developer on this platform complain about. It was given no checklist, no task
text, and no hint that a colour derivation had changed.

## Why the window is not the one the change lives in

The change is a hover wash, and a hover is not in a resting screenshot. The
gallery inventory draws its ghost specimens at rest, so the running window
does not contain a single floored pixel; the two pattern strips do, and are
the reason they were included.

A live hover could not be captured in this session. Synthetic pointer moves
were posted through `CGEvent` and the cursor demonstrably arrived at the
target — clicks posted the same way switched tabs and focused windows — but
no Gio window redrew a hover from them, in `sitedocs` or in `vaultview`.
Clicks land; moves do not produce a hover repaint. That is worth knowing
before the next task plans a hover capture.

## What came back, verbatim

> I measured every claim against pixels rather than eyeballing. Findings, most serious first.
>
> ---
>
> **1. Button labels lose contrast as the fill darkens — the press state fails outright.**
> The primary button keeps a pure black `#000000` label through every state while the fill darkens: rest `#DB771E` = 6.67:1, hover `#AE5D16` = 4.38:1, press `#844509` = **2.84:1**. Press is the state a user is looking at while acting on it, and it is the least legible one. This is a foreground that is picked once and never re-measured. Proof it's a bug and not a policy: chips *do* re-derive their label per state (`#7C5235` → `#5F391B` → `#230E01`, staying ≥4.5:1), and the "Pinned" button re-picks white over its dark red. Only the palette-derived button path skips the step.
>
> **2. The three elevation levels are invisible.** Page `#F6F6F6`, "On a card" `#F8F8F8`, "In a dialog" `#FBFBFB` — 1.018:1 and 1.026:1. The one specimen whose entire job is to demonstrate three levels demonstrates nothing; the three chip rows are pixel-indistinguishable at arm's length. Worse, the Theme tab three sections up declares `Surface = Neutral 200 = #E8E8E8`, which these panels don't use — the section header bands do. So the levels are computed off-palette and the app contradicts its own documentation on the same screen.
>
> **3. Warning is a duplicate of Primary.** Hue at steps 500–900: Primary 28/28/28/28/23°, Warning 24/25/25/25/18°. RGB distance is 13.5 at 500, 10.0 at 600, **7.3 at 700, 6.4 at 800, 2.8 at 900**. Warning's base `#934610` vs Primary 700 `#8D4A0F` is a distance of 7. A warning badge next to a primary button is the same colour. Separately, the Warning ramp doesn't hold its own hue — it slides 37° → 38° → 30° → 24° across the row, so the light end is amber and the dark end is the accent. The caption's boast that the seed "only tints the status hues" is exactly the failure: the tint swallowed the role.
>
> **4. No floating surface casts a shadow, and the light popover is effectively invisible.** Light: popover `#FFFFFF` on page `#F6F6F6` = **1.081:1**, held apart by a single `#C5C5C5` hairline (1.42:1 against the page). I scanned the rows below the panel and the tooltip — background returns to `#F6F6F6` in one pixel, so there is no shadow, no blur, no vibrancy anywhere. On macOS, `NSPopover`, menus and help tags all carry a shadow; this is the single loudest "this is not a Mac app" tell in the three images.
>
> **5. Light and dark are derived differently, not mirrored.** Popover lift is 1.081:1 in light but **1.911:1** in dark (`#474747` on `#181818`) — a ~7x difference in perceived elevation for the same component. Section header bands: 1.134:1 in light (`#E8E8E8` on `#F6F6F6`) but **1.06:1** in dark (`#151515` on `#181818`), where they essentially disappear and the gallery loses its structure. Also, neither scheme's page is a ramp step — light page is `#F6F6F6` (Neutral 100, fine) but dark page is `#181818` while Neutral 900 is `#131313`, and the dark popover `#474747` sits between Neutral 800 and 700. Dark mode is hand-tuned off-palette.
>
> **6. The focus ring is wrong for the platform.** It is a 2px `#673508` ring drawn *inside* the button, inset 2px, in the same hue as the fill. Rest and Focus therefore differ only by a dark line within an orange rectangle. macOS draws the focus ring in the user's system accent colour, outside the control, with an offset. Chips do the same thing with a border-colour swap. Nothing in these screenshots would look focused to a Mac user.
>
> **7. Secondary is Primary with a different name.** `#FFF5ED` (100), `#FEE3D0` (200) and `#230E01` (900) are byte-identical between the two ramps, and the hue matches across the rest (25–27° vs 25–28°). Three of nine steps are literally the same colour. With Warning also collapsed onto Primary, over a third of the palette is one hue wearing three labels.
>
> **8. The disabled button is at 1.55:1** (`#BFA9A1` on `#ECD2C8`). That is below even the 3:1 non-text floor. It isn't de-emphasised, it's unreadable — and it sits next to a Ghost button that has no box at all, so the row's two weakest items are also its two most ambiguous.
>
> **9. The Ghost button has zero affordance.** It occupies a full 120×36 box (measured: it is centred in the same slot the other buttons use), but has no fill, no border, no outline, and a `#5C5C5C` label — *lighter* than the Filled and Tonal labels (`#000000`, `#230E01`). Between two boxed siblings it reads as a caption someone forgot to style, not a control.
>
> **10. The window chrome is not AppKit's.** Traffic lights measure 14×14px on a 23px pitch, inset 9px from the left and 9px from the top. AppKit's are 12pt on a 20pt pitch at a 20pt inset. There is no window title anywhere. And the left margin changes three times going down one window: 9px (controls), 13px (tab strip), 24px (all content). Finally there is no separator under the toolbar — chrome `#F8F8F8` against content `#F6F6F6` is 1.008:1, so the tab strip and the content are one undifferentiated field.
>
> **11. Specimen row labels are the only text below AA.** "On the paper", "On a card", "Unselected", "Selected" are `#7F7F7F` on `#F6F6F6` = **3.71:1** at ~11px. Every other secondary label in the app is `#5C5C5C` at 6.19:1. One style was set by hand and missed.
>
> **12. Selected chips are less legible than unselected ones, and their state ladders don't match.** Unselected walks `#F6F6F6` → `#E8E8E8` → `#D4D4D4` (a 14-unit step per state). Selected walks `#F2CEB5` → `#D3B198` → `#B4937B` — roughly a 12 L\* point drop per state, four times the swing. Selected/Press looks like a different component rather than the same chip being pressed. And selected labels land at 4.58:1 versus unselected's 6.19:1: the *chosen* item is the harder one to read.
>
> **13. Tab selection is one 2px underline, in the wrong accent.** All five tab labels are `#131313` at identical weight; the only cue is a 2px rule in `#B76318` (Primary 600). Every button on the same screen uses `#DB771E` (the base). Two different accent values in one window, and the weaker of them is carrying the entire "you are here" signal.
>
> **14. The "pinned from outside the palette" demo is the error colour.** The Pinned button is `#B12824`; Error 700 is `#AE2719` — a distance of 9. The specimen teaching "you can pin a brand colour" shows a button that reads as destructive.
>
> **15. Nothing is width-constrained or centred.** In the 1200px window every specimen row lives in the left ~800px with ~380px of dead space to its right, at every single row. In the pattern tiles it's worse: content occupies x≈100–270 of a 900px strip, so ~70% of each tile is empty. And the Popover tile is badly off-centre vertically — ~105px of empty space above the trigger, ~22px below the panel — as if space was reserved for a flip that never happened.
>
> **16. The copy is broken in places and jargon everywhere.** The seed caption reads "the colour this palette grew from and the colour picked and its Primary base" — a run-on that looks like two template fragments joined by a stray "and". It also asserts the seed *is* the Primary base, while the seed is `#DD7700` and the sampled Primary base is `#DB771E`. "the tonal axis's light end, an ink here" appears twice, ungrammatical both times. "nine steps a role." Then the invented vocabulary shipped to users: *Ink ends, the palette's own dial, pinned base, held at the container chroma, Mark, storeys, utterances, registers, face, On the paper.* And the same screen is inconsistent with itself — the Button section says "the three emphasis **registers**", the Badge section says "the five **variants**", for the same concept.
>
> **17. The ramp legend contradicts the ramps.** "a dot marks where each pick lives", yet the Primary row carries no dot in any of its nine steps — only in the base swatch — while Neutral carries four. Read literally, the accent role that drives the entire UI uses none of its own ramp. Either the legend is wrong or the marking is.
>
> **18. The Palette Picks columns are unbalanced and clipped.** Column 3 ("Ink ends") holds two entries and then ~600px of white space; column 2 ("Status") overflows past the window bottom mid-entry ("Success 300, held at the container chroma" is sliced horizontally); column 1's "Inverse" subsection is cut through its first line. Content is simply truncated at the fold with no scroll affordance visible at rest.
>
> **19. Chips draw their glyphs from three different vocabularies.** The `+` and `✓` are body-font text glyphs — wrong weight against the label, and the `✓` sits high on the line. The avatar is a heavy filled icon that visually out-weights every other element in the row, including the accented chips. The `✕` is a thin geometric cross. One component, three icon sources, none matching.
>
> **20. The two overlays anchor by different rules and use three radii.** Measured at the trigger's centre column: the popover's caret tip sits at 0px from the button (its stroke lands on the button's own fill), while the tooltip floats 4px away with no tail at all. Corner radii are roughly 10 (popover), 4 (tooltip), 8 (icon button) — three radii among three adjacent surfaces in one gallery.
>
> **21. The stacked strips are stitched at arbitrary offsets.** The light strip ends on a "Hero" header band with no content under it; the dark strip's first header has the tops of its glyphs sliced off ("floating", "tied", "its" are visibly cut); the separator between them is `#808080`, a value belonging to neither scheme. If this composite is what gets reviewed or published, it looks unfinished — though this one may be a capture artifact rather than the app.

## What this says about the change under review

Nothing. Twenty-one findings and not one of them is the hovered ghost trigger
in the two pattern strips — the only place in the three images where BQ1.1's
pixels appear. Before the floor those triggers washed at 1.13:1 in light and
1.12:1 in dark; the reviewer, hunting for anything invisible and measuring in
pixels, called the popover panel invisible, the elevation levels invisible and
the dark header bands invisible, and passed over the wash. That is the
outcome the task was aiming at, and it is the only claim this review supports
about it.

## Judgement of the findings

None was caused by this task and none was cheap and in scope for it, so
nothing was fixed here. The three that touch this round's subject — a fill
that must be seen against the surface under it — are pooled: **2** and **5**
(the level fills' own separation, which is `SurfaceAt` and not the state walk)
as item 235, and **9** (the Ghost variant at rest) as item 236.

Two are artifacts of the review material rather than the system, and are
recorded so a later reader does not chase them:

- **21** is the reviewer's own doubt, and correct. The stitched strip, its
  slicing and its `#808080` separator were made for this review by cropping
  two golden tiles; no application draws it.
- **18** reports content clipped at the window bottom. The window is 800 tall
  and the Theme tab is a scrolling page; what the reviewer saw is the fold,
  not truncation.

The rest — the palette collapses (3, 7, 14), the platform chrome and focus
ring (6, 10, 13), the button and chip state ladders (1, 8, 12), the missing
shadow (4), the layout width (15), the copy and vocabulary (16, 17), the
glyph sources (19), the overlay geometry (20) and the specimen label
contrast (11) — belong to families the pool already carries. They stand
recorded here verbatim rather than being re-pooled one by one.
