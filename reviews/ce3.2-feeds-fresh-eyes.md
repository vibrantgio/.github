---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE3.2 — Feeds, read cold

Two whole-window renders — the feed reader in both appearances, drawn
offscreen at 1200×800, the size its window opens at, with a feed chosen in the
rail and one of its articles open in the reader — handed with three macOS
window captures (`mail-window-light.png`,
`finder-window-untinted-{light,dark}.png`) to an agent that had seen neither
the packet nor the plan, with no checklist and one question: put beside these
macOS windows, what would a developer who uses macOS every day say this app
gets wrong?

The reviewer was briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured, not judged by eye; the light chrome is very nearly
the content's white by measurement, told apart by a seam; alpha names
composite in encoded sRGB; every value was measured off a macOS capture; the
typeface is deliberately not the system's and the accent does not change
between appearances.

## The reviewer's reply, verbatim

> I read all five images and measured pixels rather than trusting impressions. Here is what a daily macOS user would say, worst first.
>
> ## 1. The sidebar isn't a sidebar — no material, no seam (both appearances)
>
> Left pane, x 0–192. I scanned every pixel across y=400 and y=600 from x=0 rightward: the first colour change in the whole left half of the window is at **x=796** (the list/detail divider). Light: sidebar `#ffffff`, content `#ffffff`, **no vertical hairline at all**. Dark: sidebar `#1e1e1e`, content `#1e1e1e`, same — nothing.
>
> macOS: Finder light is sidebar `#f7f7f7` against content `#ffffff` plus an edge; Mail is `#f9fafa` against `#ffffff` with a divider at x=332; Finder dark inverts the direction — sidebar `#1c1c1c` *darker* than content `#1e1e1e`, with a `#434343` hairline. The sidebar is always a distinct surface, in both appearances.
>
> The sting: the app's own toolbar strip is `#f7f7f7` light / `#1c1c1c` dark — the correct sidebar tones, exactly Finder's dark sidebar value. The material is in the palette; it just stops at y=27 instead of running down the left pane. Right now the only reason you can tell where the sidebar ends is that the table starts.
>
> ## 2. Pagination buttons at the bottom of the list
>
> Bottom of the middle pane, y≈771: `◀ [1] 2 ▶` with page 1 as a blue rounded chip. That is a web control. No Mac list view paginates — Finder, Mail, Music, Photos all scroll a single continuous list, and a 10-row-per-page feed list is the most jarring thing in the frame. It also implies the app can't show 11 items in a 800px-tall window.
>
> ## 3. Toolbar is half height, and its actions are text links
>
> The chrome strip is y 0–27, **28px**. Mail, captured at the identical 1200×800, has its toolbar hairline at y=51 — **52px**. Everything in the app's strip is consequently cramped against both edges.
>
> "Add feed" and "Share" at top right are bare `#007AFF` text. macOS toolbars use icon buttons — Mail's row of glyph buttons, Finder's share arrow and `•••`. A text-only blue action at the top right is an iOS navigation bar or a web app, not a Mac toolbar. "Share" specifically has a system glyph everyone recognises. The toolbar area over the sidebar (x 0–192) is also completely empty, where Mail puts the sidebar toggle.
>
> ## 4. Underlined tab strip in the detail pane
>
> "Reader | Raw | Comments" at y≈114, selected item marked by a 2px blue underline on a `#f7f7f7` strip with a bottom rule. That's Material Design / web tabs. macOS uses a segmented control — a rounded capsule where the selected segment is a raised pill — or a real tab view. Nothing in AppKit draws a coloured underline under a label.
>
> ## 5. The filter field
>
> x 208–780, y 44–71: a full-width `#f3f3f3` slab, no border, and the first non-background pixel inside it is the "F" of "Filter articles" at x=221 — **no magnifying-glass glyph**. macOS search fields always carry the magnifier at the leading edge and a clear (⊗) button once filled. Placement is wrong too: on macOS the filter field lives in the toolbar, trailing-aligned (Finder's "🔍 Search" at top right), not as a full-bleed bar wedged between the toolbar and the column headers.
>
> ## 6. Rows and stripes are inset 16px; macOS runs them edge to edge
>
> Stripe rows start at x=208 and stop at x=780, inside a pane spanning 192–796. The header hairline at y=103 has the same 208–780 span. So there are 16px white gutters down both sides of the table.
>
> Finder: the stripe at y=181 begins right at the content edge and runs to the window edge. Mail: the row separator at y=248 spans 334–839, the full pane. A Mac table bleeds into its scroll view; the inset makes this read as a web card dropped into a pane.
>
> ## 7. Column header shouts louder than the data
>
> "Title / Author / Published" measures `#272727` and is bold — identical darkness to the row text below it (`#272727`). Finder's "Name / Kind / Date Last Opened" measures `#808080`, regular weight. The header is supposed to recede.
>
> Two more in that row: there are **no vertical column dividers**, so the labels just float; and the sort indicator is a filled ▼ triangle sitting immediately after "Published" (x 660–670). Finder puts a small chevron at the column's *trailing* edge — I found its header glyphs at x 1182–1398, hard against the right edge of the sorted column.
>
> ## 8. Sidebar group sections are ruled off
>
> There are full-width horizontal hairlines at **y=75, y=219 and y=267**, spanning x 0–192 — separators under "Tech", "News" and "Personal". No macOS sidebar does this; Finder's "Favourites / Locations / Tags" are separated by whitespace alone. Compounding it, the group labels are rendered at body size in near-black with a permanently visible solid ▼/▶ at the far left. macOS section headers are small, secondary grey, and the disclosure control only fades in on hover.
>
> ## 9. Sidebar rows carry no icons
>
> "Go Blog", "Hacker News", "Lobste.rs" are bare text. Every row in Finder's and Mail's sidebar has a leading symbol. A Mac feed reader would show a favicon or an RSS glyph; without them the sidebar looks like an unstyled list.
>
> ## 10. The unread dot is grey and on the wrong side
>
> The dot at x=697 measures `#333333`, 3px, in a nameless trailing column. Mail's unread marker is a **blue** dot at the row's *leading* edge, where the eye scans for it. Dark grey on the right reads as a bullet, not a state.
>
> ## 11. Column widths waste the row
>
> Title is clipped to ~182px — every single title ends in "…" — while roughly 100px between the Published column and the row's right edge is empty. Finder gives Name the flexible width and lets Kind/Date take only what they need.
>
> ## 12. Three accent blues
>
> `#007AFF` (page chip, "Add feed"), `#0064E1` (table selection, tab underline), `#178BFB` (sidebar pill). Mail does legitimately use two — `#178BFB` in the sidebar, `#1274DE` in the message list — and the app's sidebar pill is that value *exactly*, so the pair is defensible. The `#007AFF` chip is a third, matching neither.
>
> ## 13. The pagination bar has no footer material
>
> Even granting the control, it floats on plain white with no top hairline and no chrome tone. Finder's path/status bar is a distinct strip with a separator.
>
> ---
>
> ## What it gets right
>
> More than the list suggests, and several values are exact matches rather than approximations:
>
> - **Alternating stripe `#f4f5f5`** — bit-identical to Finder's `#f4f5f5`.
> - **Row height 20px** — identical to Finder's list view (I measured its stripe pitch at 20px).
> - **List/detail divider `#e6e6e6`** — identical to Mail's divider at x=839.
> - **Body text `#272727`** — identical to Finder's row text.
> - **Dark content `#1e1e1e`** — identical to Finder dark; the dark stripe `#292929` is a correctly weighted companion.
> - **Sidebar selection `#178BFB`** — exactly Mail's sidebar selection blue.
> - The toolbar separator correctly **stops at x=192 and does not cross the sidebar**, which is the real macOS behaviour and an easy thing to get wrong.
> - Dark mode is a genuine repaint with its own selection blue (`#0059D1`) and its own chrome, not an inverted light theme.
> - The three-pane source/list/reader layout, the detail pane's title-plus-byline header, and the text measure in the reader are all sound.
>
> The pattern: the colour *values* are right, and the **surfaces and controls** are wrong. Painting the sidebar its own material with a seam, deleting the pagination bar, and swapping the underline tabs and text-link toolbar actions for a segmented control and icon buttons would close most of the gap.

## Disposition

**Fixed here.** The seam. The sidebar now draws the platform's separator,
flattened over the sidebar's own fill, down its trailing edge below the title
band — the hairline the Language says parts the sidebar from the content, and
the one thing in finding 1 that the sidebar itself owns. It reads `#dfdfdf`
light and `#323232` dark.

**Already pooled.**

- The other half of finding 1 — the rail painting the content's fill over the
  chrome material — is item 413: `patterns/accordion` fills
  `ControlBackground` with no way to state the surface it stands on. Until the
  accordion can be told what it stands on, the sidebar's material is
  overpainted between the band and the foot, and the reviewer is right that
  "the material is in the palette; it just stops at y=27".
- The sidebar pill's value and the never-drawn unemphasized state are items
  411 and 412.

**New for pooling.**

- Feeds paginates: "`◀ [1] 2 ▶` … That is a web control. No Mac list view
  paginates — Finder, Mail, Music, Photos all scroll a single continuous
  list", and "the pagination bar has no footer material".
- The top band is 28 px against Mail's 52: "Everything in the app's strip is
  consequently cramped against both edges."
- "Add feed" and "Share" are text links: "A text-only blue action at the top
  right is an iOS navigation bar or a web app, not a Mac toolbar."
- The reader's tab strip is an underline: "Nothing in AppKit draws a coloured
  underline under a label" — macOS uses a segmented control.
- The filter field: "no magnifying-glass glyph", and "on macOS the filter
  field lives in the toolbar, trailing-aligned … not as a full-bleed bar".
- The table is inset 16 px inside its pane: "A Mac table bleeds into its
  scroll view; the inset makes this read as a web card dropped into a pane."
- The column header is as dark and as heavy as its rows — "The header is
  supposed to recede" — with no column dividers, and the sort glyph sits
  beside the label rather than at the column's trailing edge.
- The rail's group sections are ruled off: "No macOS sidebar does this;
  Finder's 'Favourites / Locations / Tags' are separated by whitespace alone",
  and the group labels are body-sized with a permanently visible disclosure.
- Rail rows carry no icons: "without them the sidebar looks like an unstyled
  list."
- The unread dot is grey and trailing where Mail's is blue and leading.
- Column widths: every title ellipsizes while ~100 px of the row sits empty.

**Recorded misreads.**

- "Three accent blues" is one accent and two measured selection colours:
  `#0064e1` is `selectedContentBackgroundColor`, `#178bfb` the sidebar
  selection measured off Voice Memos and Mail, and `#007aff` the accent. The
  reviewer's own note that the pill "is that value *exactly*" is the tell.
- The dark seam's absence in finding 1 is the same defect as the light one,
  not a second: both were measured before this task's fix.
