---
date: 2026-09-22
task: CG5.17
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.17 — mindchat's settings dialog read cold beside the platform's own sheet

One reviewer, having seen neither the plan nor the packet nor any source, was
given four images at 1x and told which two are the platform: mindchat's
settings dialog in both appearances as this task left it (1024x768 each,
rendered through the app's own layers), and `save-dialog-light.png` and
`save-dialog-dark.png`. It was given the recorded misreads — a dark label
reads grey at 1x; a still shows no fade, no cursor and no pointer feedback;
alpha composites in sRGB; our window's three round buttons are harness
stand-ins; a pointer target is invisible in a still; the stored captures were
taken with the window shadow excluded, so the platform's own sheet shadow is
not in them; the dialog's position and shape are the owner's and stay — and it
was told it could read the pixels any way it liked. It was asked one question,
with no checklist: "Does this dialog read as a macOS sheet, and what is wrong
with it?"

The two application images it was handed were rendered at a 28 dp corner, the
first cut of the fit. The fit was then re-read — the corner's topmost row,
which the curve crosses almost horizontally, was carrying a six-pixel residual
on its own — and the task landed 27. The surface's corner is one pixel tighter
than what the reviewer saw and nothing else in either image moved. The
reviewer's own corner reading is recorded below and corroborates it: it read
the platform's sheet at 22 and ours at 23, one pixel apart in the same
direction, by whatever method it used.

## The reply, verbatim

> I read all four images and measured the pixels rather than eyeballing. Here is what I see.
>
> ## Does it read as a macOS sheet?
>
> **In light: about two-thirds yes.** The shell is right — white slab, 20px side margins, 23px corner radius (macOS: 22), 24px-tall buttons, Cancel-left/Save-right with an 8px gap, and the Save blue is `(21,126,251)`, identical to the reference's `(21,126,251)`. Someone clearly sampled the platform for the chrome.
>
> **In dark: no.** It fails at the first thing a sheet has to do.
>
> **In both: the inside of the sheet is a web form, not an AppKit sheet.** The reference's whole grammar — a right-aligned label column, hairline-separated groups, a distinct button band — is absent.
>
> ## Ranked
>
> **1. Dark mode: the sheet does not separate from what it covers.** Sheet fill is `(30,30,30)`. The assistant chat bubble it overlaps at the top-right — sample `(850,260)`, just right of the sheet's edge — is *also* `(30,30,30)`. Exactly equal. The only thing marking the boundary is the shadow, and at `x=792,y=260` that is `(27,27,27)`: a 3-level step, ~1%. Compare light, where the sheet is `(255,255,255)` against a `(195,196,196)` bubble — a 60-level step plus a 14-level shadow. Look at the dark capture's right edge between y≈230 and y≈290 and the sheet just stops existing. The light capture's shadow does the job; the dark one's does not, and dark needs *more* shadow, not a quarter as much.
>
> **2. Three of the four fields have no label at all.** Right pane, y=268, y=318, y=368: a name, a URL placeholder, and password dots, bare. The reference sheet's entire left column is "Save As:", "Tags:", "Where:" right-aligned at x≈256 with an 8px gap to the field. Here you cannot tell what field 1 is without guessing from its contents. This is the single biggest departure from the platform.
>
> **3. "DEFAULT MODEL" is orphaned from its control.** The label sits at x=252–332, the popup it labels sits at x=512–772 — about 180px of empty white between them, across a column boundary. It's also the *only* label in the dialog, and it's styled as an all-caps section header identical to "PROVIDERS" at the top of the left well, so it reads as a heading for an empty region rather than as a caption. And it's not centred on its control: label glyphs span y=510–517 (centre 513.5), popup spans y=495–517 (centre 506) — sitting 7px low, near the popup's bottom edge.
>
> **4. The four-pill row at the top has no selected segment.** OpenAI / xAI / OpenRouter / Groq at y=234–259 all have the identical fill — `(236,236,236)` in light, `(51,58,63)` in dark, measured at four points. Nothing is on. Meanwhile the left list *does* show OpenAI selected and the fields below show OpenAI's values, so the same state is expressed twice and one of the two expressions is blank. They're also 85px each with 6px gaps — a macOS segmented control is contiguous with hairline dividers and a tinted active segment; four detached equal pills is not a platform control.
>
> **5. Those pills are pixel-identical to the Cancel button.** Cancel is `(236,236,236)` light / `(51,58,63)` dark — the same two values. Four things that are not "press me now" look exactly like the one button that is.
>
> **6. No separators anywhere.** I scanned the full height at x=500 in both appearances: an uninterrupted slab from y=178 to y=589. The reference has full-width hairlines at y=324 and y=479 (`(230,230,230)` light, `(57,63,67)` dark) carving three bands, with the bottom one a 62px button footer. Here Cancel/Save float in open white with nothing marking the footer.
>
> **7. Dark mode mixes neutral and tinted greys on one surface.** The sheet and the field interiors are dead neutral `(30,30,30)`; everything sitting on them is blue-tinted — well `(42,48,52)`, pills and Cancel `(51,58,63)`, field borders `(44,51,56)`. The reference's dark sheet is uniformly `(35,42,47)`, tinted, field interiors included. The app's Cancel matches the reference's Cancel *exactly* (`51,58,63` both), so the tinted values were taken from the platform and the surfaces were not. You can see the pills read faintly blue against a neutral slab.
>
> **8. The providers well is nearly invisible in light and obvious in dark, in opposite directions.** Light: well `(247,247,247)` on a `(255,255,255)` sheet — an 8-level step with no border pixel at all (I checked y=234 at x=300: 255 straight to 247). Dark: `(42,48,52)` on `(30,30,30)` — a much stronger step, and now *lighter* than the sheet. So the same box reads as a faint recess in light and a raised panel in dark.
>
> **9. The password field breaks the right-hand alignment.** Fields 1 and 2 end at x=771. The password field ends at x=721 — 50px short — and the green disc (x≈731–746) plus the refresh glyph (x≈755–763) fill the gap. It's the one ragged row in an otherwise clean right edge.
>
> **10. The green validation disc is the loudest thing in the dialog.** `(52,199,89)` filled circle at (738,389) — the most saturated pixel anywhere on the sheet, including the Save button, for a passive status indicator. Next to it the refresh glyph is a bare grey outline at `(202,202,202)` with no button chrome. Two adjacent controls at wildly different weights, and neither has a label.
>
> **11. The buttons are oversized.** Cancel x=564–663 and Save x=672–772 — about 100px each. The reference renders the same two words at 74px each (x=359–433, x=441–515). Heights match at 24px, so it's a fixed minimum width being applied.
>
> **12. The popup's left edge aligns with nothing.** It starts at x=512. Every other control in the right column starts at 414/415. Its right edge at 772 is correct; its left edge just floats.
>
> **13. The +/− float above the well's bottom.** Glyphs at y≈471, well bottom at y=486 — 15px of empty fill underneath, and no bordered footer group around them.
>
> **14. No key focus ring anywhere.** The reference shows the "Save As" field ringed at y=205–233. A settings sheet that just opened has key focus somewhere; here nothing does. (Listing this low since it's arguably a state, not a style — but a focus ring is static, not animated.)
>
> **15. The bottom-left quadrant is empty.** The well ends at y=486, the right column's content ends at y=517, the sheet runs to y=589. Below the well there is nothing but the orphaned label, and the two columns terminate at different heights with nothing tying them.
>
> **16. Two different selection blues on screen.** The sheet's list row is `(0,100,225)` — which is correct, that's the platform's emphasized content selection. The parent window's sidebar row behind it is `(19,111,201)`, and it's the same solid value in both appearances, so it isn't alpha over the sidebar — it's a second, separately-chosen blue for the same job.
>
> Things I checked and am *not* reporting: shadow presence and softness (reference excludes it, and the light shadow's 14-level falloff over ~25px looks reasonable); bottom margin (20px, matches the 20px sides, reference uses 18 — fine); field heights (28px vs reference 27); corner radius; parent-window dimming (macOS sheets don't dim, and this doesn't either — correct).

## What was done with it

Nothing the reviewer found is inside this task's stated result, and nothing it
found contradicts it. It read the Cancel's fill as the platform's own value to
the byte in both appearances ("The app's Cancel matches the reference's Cancel
*exactly*, `51,58,63` both"), which is what the task changed, and it passed the
corner over as a thing it checked and had nothing to say about.

Every numbered finding is a defect of mindchat's settings dialog or of the
modal's dark separation, none of which this task touches, and each is pooled:
711 (the dark sheet against the content it covers, finding 1), 712 (the fields'
missing labels and the orphaned "DEFAULT MODEL", 2 and 3), 713 (the provider
pills as a segmented control with no chosen segment, 4 and 5), 714 (the footer
band and the sheet's own hairlines, 6), 715 (the dark sheet neutral under
tinted controls on it, 7 and 8), 716 (the well, its footer and the ragged
password row, 9, 10, 13, 15), 717 (the dialog's footer buttons at 100 against
the platform's measured 74, 11), 718 (the pop-up's leading column, 12), 719
(what holds key focus when a dialog opens, 14) and 720 (two selection blues,
16).
