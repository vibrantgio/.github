---
date: 2026-09-17
task: CG4.13
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG4.13 — vaultview's rail search field read cold beside System Settings' sidebar

One reviewer, having seen neither the plan nor the packet nor any source, was
given vaultview's rail at 1x in both appearances — the leading 240 px of the
stored window golden, its full height down to 420 px — beside the sidebar of
`system-settings-grouped-box-light.png` and
`system-settings-grouped-box-dark.png`, cropped from the window's rim to the
seam. One question: does this rail's search field read as the platform's
sidebar search field, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam; still
captures show no fade or cursor; alpha composites in sRGB; the window controls
of the reviewed rail are harness stand-ins; the prompt's type size is
typography and stays by ruling.

The renders it read were taken after this task's change landed: the looking
glass redrawn as the platform's round lens on a hairline band, 13.3 px across
in a 16 dp square, its first pixel 9 px in from the field's leading edge, its
lens centred on the field's centre row and the prompt five clear columns after
its last pixel.

## The reply, verbatim

> ## Answer
>
> **Yes — the pill itself is essentially a pixel-for-pixel match.** What's wrong is all in the contents and in one dark-appearance colour that was lifted from the capture with the environment baked in.
>
> ### What already matches (measured, 1x)
>
> | | platform | ours |
> |---|---|---|
> | pill height | 28.0 px (y61–88, hard edges) | 28.0 px (y62–89) |
> | corner | circular capsule r=14 | circular capsule r=14 |
> | fill, light | 232,232,232 | 232,232,232 |
> | fill, dark | 47,50,52 | 47,50,52 |
> | border / inner shadow | none, flat | none, flat |
> | magnifier inset from pill's leading edge | 9 px | 9 px |
> | magnifier ink mass | 41.2 px² | 42.0 px² |
> | handle | ~2.6 px past the ring, ~41° | ~2.6 px past the ring, ~41° |
> | placeholder ink, light | 116,116,116 (50% black on fill), Lc 58.9 | identical |
>
> Sub-pixel corner profile from the top row down — platform 11.9 / 8.1 / 6.1 / 4.8 / 3.7 / 2.7 / 2.0 / 1.5 / 1.2 / 0.7 / 0.5 / 0.3 / 0; ours 10.5 / 7.7 / 6.1 / 4.8 / 3.7 / 2.9 / 2.2 / 1.6 / 1.1 / 0.7 / 0.5 / 0.2 / 0; an ideal r=14 circle 10.3 / 7.7 / 6.0 / 4.7 / 3.7 / 2.9 / 2.2 / 1.6 / 1.1 / 0.7 / 0.4 / 0.2 / 0.1. Within 0.2 px everywhere but the tangent row. Field width 220 px inset 10/9, exactly matching our own row selection pill (both span x10–229), which is the platform's own practice.
>
> ### What is wrong
>
> **1. Dark: the search field is the only tinted thing in an otherwise strictly neutral rail.** Our rail is 28,28,28, our row labels 220,220,220, our chevrons 153,153,153 — all exactly neutral. The field's fill is 47,50,52 and its ink 161,163,163, both cool. Scanning the whole dark rail for pixels where max−min ≥ 2, every hit outside the blue selection pill's antialiasing falls in rows 62–89, i.e. inside the search field and nowhere else.
>
> The platform's field is the same 47,50,52 — but its sidebar is 28,33,36, so *both* surfaces carry the wallpaper's cast and the field is actually **less** blue than its surround (−3B relative). In our rail the sign flips: the field is **+4B** relative to the rail. The absolute sample was correct; it only meant what it meant against a tinted surround. Either the rail takes the same cast or the field's fill is re-derived neutral (~50,50,50 for the same step).
>
> **2. Dark: the placeholder and glyph ink are too bright.** Ours 161,163,163 against the platform's 151,152,153 on the identical 47,50,52 fill — Lc 46.7 vs 41.1. The platform's placeholder is a clean 50% blend in *both* appearances (116 on 232 light, 151 on 47 dark). Ours is 50% in light and 54.8% in dark. The light value was matched, the dark one was not.
>
> **3. The magnifier didn't grow with the placeholder.** Platform ring ~10.8 px mean against a 9.1 px cap height — the ring runs ~18% larger than the caps. Ours is ~10.5 px against a ~10.8 px cap — level with them. The glyph reads undersized beside its own text. Holding the platform's ratio at our type size wants a ring around 12.5 px.
>
> **4. The icon-to-text gap didn't grow either.** 5.7 px on the platform, 5.8 px in ours — with type 19% larger. Proportionally it wants ~6.8 px, so "Find a note…" crowds the glyph.
>
> **5. The placeholder sits 1 px high.** The platform centres the ascender box on the field: band y70.3–80.0, centre 75.15, field centre 75.0. Ours: band y69.0–81.0, centre 75.0, field centre 76.0 — 1 px above. Baseline should land on y82, not y81.
>
> **6. The string is not a macOS search placeholder.** The platform says `Search` — bare noun, sentence case, no terminal punctuation. Ours says `Find a note…`. On macOS a trailing ellipsis is the convention for a control that opens a further dialog, so it makes exactly the wrong promise inside a text field; the verb phrase is a web/Windows idiom. This is the one difference visible at 1x without measuring, and it is language, not typography.
>
> **7. Light, rail rather than field:** our rail is 247 where the platform's sidebar is 250 at that height, with the same 232 fill. The field's well is 15 levels instead of 18, so the pill separates slightly less from its rail. In dark our step is if anything larger than the platform's, so this is light-only.
>
> **8. Nit, possibly rasteriser:** the platform's ring measures ~11.7 wide × ~9.8 tall (wider than tall); ours is ~10.6 × ~10.4 (round). About 1 px, and I would not file it on its own.
>
> ### Typography (already ruled — noting only)
>
> Measured: platform x-height 7.0 px, ascender-to-baseline 9.7 px → 13 pt SF, the standard macOS sidebar size. Ours x-height 8.3 px, ascender 12.0 px → ~15.5 pt, about 19% larger. Items 3, 4 and 5 above are consequences of that size not being carried through to the glyph, the gap and the baseline — they are fixable without touching the ruled size.


## What was done with it

Every number this task set is confirmed from outside, read back off the drawn
pixels by someone who did not know what they were meant to be: the glyph's
9 px inset, the five clear columns after it, the handle's angle and its reach
past the ring, and a glyph area of 42.0 px² against the capture's 41.2. The
recess's height, corner, both fills, the absence of an edge and the light
prompt's colour came back as the platform's again.

Finding 8 is this task's own measurement, found independently: the reviewer
read the sidebar's ring as 11.7 wide by 9.8 tall and ours as round. That is
the stretch `controls.md` now records under "The sidebar's magnifier is the
toolbar's glyph drawn wide" — the same glyph reads round in Mail's toolbar and
in Voice Memos' capsule, and a window button in the sidebar's own capture is
circular to three decimals, so the pixels are square and the ellipse is one
application's raster. The reviewer would not file it either. Closed, not
filed.

Finding 2 is the reading `controls.md` already answers under "What the sidebar
search field measures". The sidebar capture's prompt peaks at white 127/255
because that field stands behind the sidebar's vibrancy; Voice Memos' untinted
dark toolbar field reads white at 140/255 to the byte, which is what AppKit
answers with and what the library draws. Ours is the platform's own coverage,
and the capture's is the one carrying an environment. Closed, not filed. The
capture that would settle it is already named in `controls.md`.

Nothing else was fixed inside this task, and each is filed under section CD:

- **1** — the dark recess against an untinted rail, with the sign of the step
  now measured on both sides.
- **3, 4** — the leading cluster keeps the platform's absolute measures while
  the prompt is set in a role about a fifth larger, so the proportions between
  glyph, gap and text are not the platform's. It is pool 494's consequence
  read off the drawn pixels, and it is filed beside it rather than folded in,
  because it is fixable at either end.
- **5** — the prompt a pixel above the field's centre row. That is the text
  field's own vertical centring, which every field in the library shares, and
  not the search field's to move alone.
- **6** — the application's prompt string.
- **7** — the light rail's material against the platform's sidebar.

Two findings of this task's own, neither in its result, are filed there too:
the form variant's leading inset, which is still a spacing token where the
chrome variant now takes a measured number, and the clear mark, which has no
capture behind its size or its inset at all.

