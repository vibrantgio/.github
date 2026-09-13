---
date: 2026-09-13
task: CE3.2
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
instrument-note: a first pass was run against frames whose radius scale was
  pinned to zero by the golden harness, and its reply is kept below the second
  for the findings it holds; the reply recorded first is the one read from
  frames drawn at the shipped radius.
---

# CE3.2 — the marketing page, read cold

Two whole-window renders — the landing page in both appearances, drawn
offscreen at 1200×1040, the size its window opens at, with the hero, the three
features, the three pricing tiers and the three testimonials — handed with
four macOS captures (`finder-window-untinted-{light,dark}.png`,
`system-settings-grouped-box-{light,dark}.png`) to an agent that had seen
neither the packet nor the plan, with no checklist and one question: put
beside these macOS windows, what would a developer who uses macOS every day
say this app gets wrong?

**The first pass was run against a faulty instrument.** This module's stored
goldens are recorded with the radius scale pinned to zero so a pixel diff can
survive corner antialiasing, and the first frames handed over were those
goldens. The reviewer duly reported that "corner radius is exactly zero on
every single surface" — true of the frames, false of the application. The
frames were redrawn at the shipped radius and a second reviewer, which had
seen neither the packet nor the first reply, was asked the same question. That
second reply is recorded first; the first pass follows it, because most of
what it found does not depend on the radius.

The reviewers were briefed on the instrument: the renders are the window's own
content layers with no title bar, no rounded window corner and no shadow; a
still shows no hover, fade or cursor; dark foreground reads grey at 1x and
contrast is to be measured; alpha names composite in encoded sRGB; every value
was measured off a macOS capture; the typeface is deliberately not the
system's and the accent does not change between appearances. The second
reviewer was additionally told that two of the three tiers are drawn as a
group and the recommended one as a card, deliberately, and that the raised
surface's dark value is the platform's grouped box as measured.

## The reviewer's reply, verbatim

> I read all six images and measured pixels rather than trusting impressions. Findings, worst first.
>
> ## 1. There are two different content grids in one window
>
> Measured left edges: the hero and features band is inset **74pt** from the window edge (the "See plans" button's fill starts at exactly x=74; "SimpleApps", the subtitle and all three feature headings ink at x=75). The pricing group and the testimonial cards are inset **50pt** (group hairline at x=50, right hairline at x=1149).
>
> The column pitch differs too — features columns start at 74 / 430 / 789 (pitch ≈357.5), cards at 50 / 422 / 794 (pitch 372), with 20pt of padding inside the cards. Net effect, reading down the page:
>
> - "Authenticity" ink at x=431, "Pro" at x=444 — **13pt out**
> - "Custody" at x=790, "Studio" at x=815 — **25pt out**
> - feature body text wraps at x=1113; the cards run to x=1149 — **36pt out**
>
> So the whole middle band visibly steps inward and nothing in columns 2 and 3 lines up. macOS uses one content inset for the whole pane: in System Settings every grouped box starts at x=243 and ends at x=706, without exception, so every label in the window shares a leading edge. This is the first thing anyone sees with a ruler on the screen.
>
> ## 2. A decorative lattice is painted behind the content — including under body text
>
> The triangular wireframe covers the entire window, and because two of the three tiers have no fill, the lattice runs straight through the Free and Studio feature lists. Two tiers have their text on texture and one doesn't. No macOS window puts a texture behind anything — Finder's list and System Settings' pane are flat fills, and the only "material" in the system is vibrancy behind a sidebar, which is a blur of what's behind the window, not a drawn pattern.
>
> It is also not calibrated across appearances. Light: lines #EDEDED on #FFFFFF, ΔL\* = 6.2. Dark: #303030 on #1E1E1E, ΔL\* = 8.6 — 39% stronger, and it's plainly visible behind the hero in the dark frame while it's nearly invisible in the light one. The same decoration should not have a different weight in the two appearances.
>
> ## 3. In dark, the structural hairlines are indistinguishable from the decoration
>
> The pricing group's border and its two internal rules are #343434; the decorative lattice is #303030; the page is #1E1E1E. Against the page that is ΔL\* 12.1 for the border versus 8.6 for the wallpaper — a factor of 1.4. In the dark frame the box that is supposed to bound the pricing group reads as one more wallpaper line. (Light is better but still close: ΔL\* 8.7 border vs 6.2 lattice.) macOS separators are a semantic colour that always sits clearly above the background because nothing else is drawn at that weight.
>
> ## 4. The dark window background and the raised surfaces come from different colour families
>
> Measured: page **#1E1E1E** (perfectly neutral, R=G=B), raised cards **#2A3034**, secondary button **#333A3F** — both carrying a blue cast of +10 in B−R. On real macOS the cast is in *both*: System Settings dark is window **#232A2E** (B−R = +11) with grouped box **#2A3034** (+10), seven levels apart and the same hue. The app has taken the platform's box colour and dropped it on Finder's neutral sidebar grey, so the cards read faintly blue against a grey window and the step between them is roughly twice the platform's. The light scheme is exactly right (#FFFFFF page, #F7F7F7 box — identical to System Settings), which makes the dark mismatch more conspicuous.
>
> ## 5. Four accent-filled buttons in one window
>
> "See plans" in the hero, then "Start free", "Buy Pro" and "Contact us" — all #007AFF fills. On macOS the accent fill identifies *the* default action; a window has at most one. Finder's toolbar has none; System Settings' pane has none. Three identical blue bars side by side in the pricing row means the recommended tier gets no emphasis from its button at all, which is presumably the opposite of the intent.
>
> ## 6. Every button label is bold
>
> "See plans", "Learn more", "Start free", "Buy Pro", "Contact us", and the "Popular" chip are all set in a heavy weight. macOS control labels are the regular system weight at 13pt — including default buttons. There is not one bold control label anywhere in either reference window. Bold-on-button is the web CTA convention and it's a strong tell.
>
> ## 7. The "Popular" chip is under-contrast and doesn't change with appearance
>
> Measured: 58×16pt, fill **#8E8E93** light / **#98989D** dark (correct systemGray values), label pure white in both. That's **3.26:1** in light and **2.87:1** in dark for 11pt text — below the 4.5:1 the platform holds for small labels. The fill moves only 10 levels between appearances while everything around it inverts, so in the dark frame it is a bright light-grey blob and the most eye-catching thing in the top-right corner. macOS swaps both halves of a badge (see the red "Software Update Available ①" badge in the reference).
>
> ## 8. Avatar monograms are nearly invisible in light
>
> Each testimonial has a ~30pt circle drawn as a hairline outline with a grey initial inside: the "K" measures **#A9A9A9 on #F7F7F7 = 2.19:1**. The same element in dark is 3.99:1 — so the weaker appearance is the light one, by a factor of two. macOS draws these (Contacts, Mail, Messages) as a *filled* circle with a white monogram, which is legible at any size. Here the letter reads as a smudge.
>
> ## 9. The testimonial row has a ragged bottom
>
> Cards 1 and 2 run y=688–875 (188pt tall); card 3 runs y=688–851 (164pt), because its quote is two lines instead of three. The row's bottom edge steps up 24pt at the right. macOS equalises items laid out in a row — Finder's icon grid and System Settings' group rows share a common edge at both ends.
>
> ## 10. Section spacing is arbitrary
>
> Gaps between the four bands: **74pt** (hero buttons → feature headings), **66pt** (feature text → pricing group), **49pt** (pricing group → testimonials). System Settings puts exactly 20pt between every group, every time; the regularity is what makes a long pane scan as one document.
>
> ## 11. The pricing group draws a box inside a box
>
> There are full-height vertical rules at x=405 and x=794 dividing the group into cells of 355 / 389 / 355pt — the middle cell is 34pt wider than the outer two. The filled Pro box (x=422–777, 356pt) then floats inside that cell with a 17pt dead moat on each side, while Free's and Studio's content sits flush to the rules. macOS grouped boxes separate rows with *inset horizontal* hairlines and never draw vertical rules; a highlighted cell fills its cell edge to edge.
>
> ## 12. Smaller things
>
> - Decorative quote-mark ornaments at the top of each testimonial — a web magazine device; nothing in AppKit marks a block of text with a typographic ornament.
> - 165pt of empty patterned window below the last card (content ends at y=875, window is 1040 tall). Nothing anchors the bottom, so the window looks like it failed to finish loading.
>
> ---
>
> ## What it gets right
>
> Quite a lot, and the things it gets right are the hard ones.
>
> **The semantic label colours are exact.** Light primary text measures #272727 (black at 85% over white = macOS `labelColor`) and secondary #808080 (black at 50% = `secondaryLabelColor`). Dark measures #DDDDDD (white at 85% over #1E1E1E) and #9A9A9A (white at 55%). Those are the platform's own alpha values, not approximations, and the two-level hierarchy is applied consistently — headings and prices primary, supporting copy and the "once" suffix secondary.
>
> **The light surface pair is the platform's, measured.** #FFFFFF page with #F7F7F7 raised boxes is precisely System Settings' light window and grouped box. The accent is #007AFF exactly, and the chip fill uses the real systemGray values in both appearances.
>
> **Optical text size matches.** Body cap height measures 10px, identical to a System Settings row label; the app's text sits at the same size as 13pt system text, so it doesn't read as a web page zoomed into a window.
>
> **Internal padding is disciplined.** Every card and cell uses a 20pt inset — Free content at x=70 in a cell starting at 50, Pro content at 442 in a box starting at 422, testimonial text at 71 in a card starting at 50. The testimonial row's card widths (356/356/356) and gutters (17pt) are perfectly even, and the pricing boxes align to the same x positions as the cards below them.
>
> **Corner radii are close.** Cards and the tier boxes measure r≈8 against System Settings' r≈10 for a grouped box — near enough that it doesn't register.
>
> The colour work is clearly done from measurement. What lets it down is layout discipline — one grid, one margin, equal-height rows, consistent section gaps — plus the decorative lattice, which is the single element that most loudly announces this is not a Mac app.

## The first pass, verbatim, read against radius-pinned frames

Kept because eleven of its twelve findings do not depend on the radius, and
two of them — the lattice's weight and the dark raised surface's cast — the
second reviewer reached independently.

> I read all five images and measured pixels off the two app frames and the three macOS references.
>
> ## What a macOS developer would say this gets wrong
>
> **1. The tiled triangular lattice behind everything.** Worst offender by a mile. A decorative geometric wallpaper (#E6E6E6 lines on #FFFFFF light, #333333 on #1E1E1E dark) covers all 1200×1040 of the window, edge to edge. Finder and System Settings paint flat, unmodulated window backgrounds — the only texture macOS ever puts behind content is a vibrancy blur, and never a pattern. Here it runs directly behind the hero subtitle at y≈91 and behind all three feature paragraphs at y 250–280, so body copy is set on a moving ground. No native app does this anywhere.
>
> **2. Corner radius is exactly zero on every single surface.** I checked corner pixels: the Free card's fill begins at (50,352) with no arc at all; the "See plans" button goes from #FFFFFF to #007AFF in one pixel step at (74,116). Compare the System Settings grouped box, whose top-left corner sweeps ~10px of continuous curvature (the arc runs from x=251 at y=282 to x=243 at y=291), and the Finder sidebar's *selected row highlight*, which still gets ~5px. macOS rounds even a one-line list highlight. This app rounds nothing — six cards, five buttons, one badge, all hard 90° corners.
>
> **3. Two of the three pricing cards have no fill; the third does.** In the Free card's textless interior (x 300–403, y 355–590) I counted ~1,270 lattice pixels — the wallpaper is drawn straight through the card, behind the price and the bullets. Studio is the same. Pro is opaque #F7F7F7. So one row of three sibling plan cards is drawn as outline / solid / outline. macOS renders a row of peer grouped boxes identically and lets only selection or the accent colour distinguish one.
>
> **4. The card hairline is byte-identical to the decorative lattice line.** Card border at x=50 measures (230,230,230) light and (52,52,52) dark; the wallpaper lines measure (230,230,230) and (51–52,51–52). The structural edge of a container is drawn in the same ink as the noise crossing it, so at the corners you cannot tell card from wallpaper.
>
> **5. The buttons are web CTAs, not AppKit push buttons.** "Start free", "Buy Pro" and "Contact us" are full-bleed saturated blue slabs 316px wide × 24px tall, square-cornered, spanning the card's whole content width. A macOS push button is a ~6pt-radius capsule sized to its label. And the two hero buttons **don't match in height**: "See plans" occupies y 116–139 (24px), "Learn more" y 117–138 (22px). Two buttons side by side in one row, one 2px taller. AppKit would make them pixel-identical. "Learn more" is also a flat #ECECEC slab with no border and no bevel — against white that's 1.14:1, which on macOS is the *disabled* look, not the secondary-button look.
>
> **6. The feature columns and the card columns are on different grids, and the error grows across the frame.** Measured left rails: feature headings at x = 75 / 431 / 790; card content at x = 72 / 444 / 816; card frames at 50 / 422 / 794. So "Provenance" sits 3px left of "Free", "Authenticity" sits 13px left of "Pro", and "Custody" sits a full 26px left of "Studio". Three columns, three different offsets, worsening left to right — the third column visibly hangs. macOS layout would share one column origin down the pane.
>
> **7. The "Popular" badge.** 58×16px square grey rectangle at (700,381), white on #8E8E93 — that is **3.26:1 in light and 2.87:1 in dark** on roughly 10px bold text, well under 4.5:1. It also isn't centred on its heading: badge centre y=388.5, "Pro" centre y=385. macOS badges (the red "1" on Software Update in the System Settings shot) are full-radius capsules in a system colour at high contrast.
>
> **8. The testimonial row is ragged.** Cards 1 and 2 run y 688–875 (188px); card 3 runs 688–851 (164px). Three peer cards in one row, one 24px short, bottom-ragged. (The pricing row, to its credit, is equal — all three are y 352–639.)
>
> **9. Dark mode's elevated surface has a blue cast.** The Pro and testimonial cards in dark measure (42,48,52) — B exceeds R by 10. Finder's dark window is (30,30,30) and its dark sidebar (41,41,41), both perfectly neutral. The same surface in the app's light appearance is neutral (247,247,247). So the tint appears only in dark, and next to Finder it reads as a cool Material-style elevation overlay rather than a macOS raised surface.
>
> **10. 188px of empty patterned window below the content.** The last real content pixel is at y=852 in a 1040px window — 18% of the height the window opens at is wallpaper, against a 32px top margin. No scroller, so this isn't a scroll region that happens to be short; the layout simply doesn't fill the size it asked for.
>
> **11. Smaller things.** No shadow under any card — System Settings grouped boxes carry a faint one. The quote marks at the top of each testimonial are two heavy squared-off wedges that read as an icon, not type; macOS quoting (Mail, Notes) uses indentation and no glyph. The testimonial avatars are hollow circles with a near-invisible ~#E0E0E0 ring — Contacts and Messages fill theirs. And there are no group labels anywhere: System Settings names every box ("Theme", "Windows"), while this page runs hero → features → pricing → testimonials with no headings at all.
>
> ## What it gets right
>
> The colour work is genuinely good, and measures correct against the references. Light's page/card pair is #FFFFFF over #F7F7F7 — that is exactly System Settings' pane-and-grouped-box relationship (255 pane, 246–247 box). Dark's base #1E1E1E is precisely Finder's dark content colour. The accent is real systemBlue #007AFF, unchanged across appearances as specified. Secondary label is #808080 light, which is macOS's 50% black, and #9A9A9A dark; primary text hits 14.9:1 light and 12.3:1 dark. Geometry discipline is there where it exists: the page gutters are symmetric at 50px, the three pricing cards are each exactly 356px wide with matching 17px gutters and identical 352–639 vertical extents, and every in-card button is inset exactly 20px on both sides. The bones are right; it's the radius, the wallpaper, and the inconsistent surface treatment that make it read as a web page in a window.

## Disposition

**Fixed here.** Nothing in the application. The instrument was fixed: the
frames a reviewer is handed for this module are now drawn at the shipped
radius rather than taken from the radius-pinned goldens. No code changed —
the goldens keep their pin, which is what makes them a stable diff.

**Already pooled.** Nothing in this window has a standing item.

**New for pooling.**

- 1, two content grids in one window: the hero and features band is inset 74
  and the pricing and testimonials 50, so "'Custody' at x=790, 'Studio' at
  x=815 — 25pt out", and the error grows across the page.
- 2, a decorative lattice behind the content, "including under body text", and
  weighted 39% more strongly in the dark appearance than in the light.
- 3, in the dark appearance the group's structural hairline and the decorative
  line are within a factor of 1.4 of each other against the page: "the box
  that is supposed to bound the pricing group reads as one more wallpaper
  line."
- 5, four accent-filled buttons in one window, three of them side by side:
  "the recommended tier gets no emphasis from its button at all."
- 6, every button label bold: "There is not one bold control label anywhere in
  either reference window."
- 7, the recommended-tier badge at 3.26:1 light and 2.87:1 dark, and moving
  only ten levels between appearances while everything around it inverts.
- 8, the testimonial monograms drawn as a hairline circle with a grey letter —
  2.19:1 in light, where the platform fills the circle and sets the monogram
  white.
- 9, the testimonial row bottom-ragged by 24 pt.
- 10, section gaps of 74, 66 and 49 where System Settings uses one number
  throughout.
- 11, the pricing group drawing vertical rules and then floating the
  recommended tier's box inside its cell with a 17 pt moat: "macOS grouped
  boxes … never draw vertical rules; a highlighted cell fills its cell edge to
  edge."
- 12, the quote ornaments, and 165 pt of empty patterned window below the last
  card.
- From the first pass, and not restated by the second: the two hero buttons
  differ by 2 px in height; the secondary hero button is a flat fill at 1.14:1
  against the page, "which on macOS is the *disabled* look"; and the card
  hairline is byte-identical to the decorative line in the light appearance
  too.

**Recorded misreads.**

- The first pass's finding 2, "corner radius is exactly zero on every single
  surface", is the instrument. The stored goldens pin the radius scale to zero
  so a pixel diff survives corner antialiasing; the window draws the shipped
  radius, which the second pass measured at about 8. Carry this into the next
  packet: never hand a reviewer a golden recorded with a pinned scale.
- The first pass's finding 3, one tier filled and two not, is the Card and
  Group distinction: the recommended tier is a card, its peers are groups. The
  second reviewer was told so and did not file it.
- Finding 4 is the real cross-app item under a wrong suspect: the reviewer
  reads the dark raised surface as the platform's box dropped onto the wrong
  window colour, and it is the other way round — `CardFill` dark (`#2a3034`)
  and `PushButtonFill` dark (`#333a3f`) were measured over a `#232a2e` plane,
  which is a window carrying the reference desktop's wallpaper tint, while the
  untinted window background is `#1e1e1e`. The tint is in our token, not in
  the reviewer's eye. Reported to the owner; themer, sk150 and iconbrowser
  read the same thing.
