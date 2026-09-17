---
date: 2026-09-17
task: CG3.1
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG3.1 — sitedocs' tab strip read cold

One reviewer, having seen neither the plan nor the packet, was given twelve
renders of the Site Docs window at 1x — 1200×800, the size the window opens
at — one per tab in each appearance, so that between them the whole strip and
the contents of every cell could be seen. One question: does this tab strip
tell a reader what each tab holds, and what is wrong with it?

The recorded-misreads brief it was given: a dark label reads grey at 1x; the
light sidebar material is the content's white told apart by a seam; still
captures show no fade or cursor; alpha composites in sRGB; the window controls
are harness stand-ins and are absent from these renders.

The renders it read were taken after the Theme tab was cut into Colours and
Typography and before anything below was acted on. They are the same
composition the review captures and the stored goldens draw.

## The reply, verbatim

> I read all twelve renders. Here is the answer.
>
> ## Partly, and mostly by accident
>
> Four of the six words do carry their contents. **Colours** opens onto the platform colour table, **Typography** onto the type scale specimen, **Components** onto the component gallery, **Patterns** onto the pattern gallery. A reader who knows the system will land where they expect. The other two do not, and the failures they cause are structural rather than cosmetic.
>
> **Docs is a superset of the strip, not a sibling of it.** Its sidebar contains "Colour: the platform's set", "Typography", "Markdown documents", "Density", "Level", "Icons" — the subjects of four other tabs, sitting inside the first one. So the six names do not divide the app into six parts; one of them covers all of it and the other five re-cut pieces already inside it. A reader who wants to know about typography has two plausible destinations and no way to choose between them, and no way to know whether they differ in subject or only in treatment (prose versus specimen). That is the single largest fault in the strip: the labels do not partition, and nothing in them says what the rule of division is.
>
> **Markdown sits at a different level than everything beside it.** Colours, Typography, Components and Patterns name subjects of the design system. Markdown names a file format. Its own page header reveals the actual subject — "headings, links, chips, lists, tasks, a table, a quote and a code fence", i.e. how running prose renders under the theme — but the tab word points at a syntax, not at that. A reader will reasonably expect the app's documentation source, or a Markdown editor. It is the only tab whose word misdirects.
>
> **Components versus Patterns is undecidable from the strip.** The distinction is real and the app holds to it, but nothing in two bare nouns tells a newcomer that a card and a toast are patterns while a chip and a badge are components. Inside the system's vocabulary it is obvious; from the strip it is a coin toss.
>
> ## The strip is not where the answer lives
>
> Five of the six tabs open onto a header band that states the contents properly — "The platform's colour set", "Button — the three emphases at rest, and the icon-only face", "Notifications — the column, one toast at every status role". That band is doing the work the strip is being credited with. The reader learns what a tab holds only after paying the cost of opening it, and then only on five tabs: **Docs has no band at all**, so the one tab whose scope is genuinely unclear is also the one tab that never explains itself.
>
> Where the band exists, its explanatory half is stranded. On Colours the title sits at x≈25 and its caption at x≈505 and running to the window edge; on Typography the title is "Typography", a bare repeat of the tab word already two rows above it, and its one piece of new information, "every role a surface reads in", is parked 1000px away at the right margin in low-emphasis grey. Nothing pairs them for the eye. At a narrower window the Colours caption has nowhere to go.
>
> ## The strip is the wrong control for this platform
>
> An unenclosed row of left-aligned text labels marked by a 2px underline is the Material tab bar. macOS switches top-level sections of a reference browser like this with a source list, or with a segmented control centred in the toolbar; it does not use an underline indicator. The app already contains a source list — inside the Docs tab — so two navigation idioms are stacked one above the other, the platform-native one nested under the foreign one.
>
> The row also costs a full 55px band across 1200px to carry 480px of labels; the remaining 720px is empty. On the platform that band would be the toolbar, and it would hold the controls this window currently has nowhere to put. This is a themer, and the strip offers no tab for a theme, no appearance switch, no theme file, no density control — six tabs that are all passive exhibits, and the app opens on the documentation rather than on its own subject.
>
> ## Smaller things
>
> The six labels are grammatically mixed in one short row: three plurals, one mass noun, one abbreviation (**Docs** is the only shortened word — Colours was not cut to Colors, Components not to Comps), one format name. The ordering is sound in the middle — tokens, then type, then elements, then compositions — with Docs and Markdown as bookends of an unrelated kind; Markdown, being a type specimen for running prose, would sit better next to Typography than at the far end.

## What was done with it

The reply reports nothing wrong with the cut this task made: both new words
were read as carrying their contents, and the middle of the strip — tokens,
then type, then elements, then compositions — was read as sound. Everything
it raises is either a label this task's own result fixes by name, a section
title the inventory owns, or the strip control itself. So nothing was changed
in answer to it and every finding was pooled.

- The strip does not partition the app, and nothing in it says what the rule
  of division is: Docs is prose about the subjects of the four tabs after it,
  Components and Patterns cannot be told apart from two bare nouns, and Docs
  is the one tab with no header band to explain itself. Pooled, 459.
- "Markdown" names a file format where its neighbours name subjects of the
  design system. Pooled, 460 — the word is the catalogue's group name and
  moving it moves every consumer of that group.
- The Typography tab opens on a section band whose label repeats the strip
  cell two rows above it, with its one new phrase parked at the far margin.
  Pooled, 461. The label is the inventory's own section title, split at its
  separator; this window is guarded against rewording it.
- The strip is an underline-marked row of text labels where the platform
  switches a window's top-level sections with a source list or a segmented
  control, and it spends a full band to carry half a window of labels.
  Pooled, 462 — that is `patterns/tabs` and every window standing on it.
- The six labels are grammatically mixed and only one is shortened; Markdown
  would read better beside Typography than at the far end. Pooled, 463.

One misread to record for later reviewers: the reply calls this window a
themer and faults it for offering no appearance switch, no theme file and no
density control. Site Docs is the documentation window; the themer is a
separate app with those controls. The platform-control finding under that
paragraph stands on its own and was pooled on its own terms.
