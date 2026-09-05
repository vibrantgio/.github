---
date: 2026-09-05
task: BR1.7
phase: BR
reviewer-model: unrecorded
reviewer-effort: unrecorded
---

# BR1.7 fresh-eyes review — the card, the group and pricing, both schemes

One reviewer, which had not seen the packet or the plan, given no
checklist and one question: what would a developer on this platform
complain about? No model was named in the dispatch, so the reviewer ran
on whatever this session's default subagent model is; neither that nor
its effort setting is observable from here, and both are recorded as
unrecorded.

What it was handed: six images. Two specimen strips cut out of the
components gallery's patterns tile, one per scheme, carrying the card
specimen over the group specimen; two more carrying the pricing row;
and the launcher's whole window in each scheme, at the size the window
opens at. It was told to sample pixels before making any claim about a
colour, and briefed on four recorded misreads — dark foreground
reading grey at 1x, a whisper step reading as none, chrome regions
sharing one fill by design, and a light card being white on off-white
by ruling. It reported none of the four.

Two things in the strips were the harness's fault rather than the
system's, and are answered under the triage rather than corrected in
the record. The pricing strips were cut with a hand-picked offset, so
finding 9 reads a caption the crop sliced rather than one the gallery
draws. And the gallery caps its pricing specimen at 640 dp inside a
900 px tile, which is what finding 8 measures as trailing dead space —
the specimen's cap, not the pattern's width.

## The reply, verbatim

I looked at all six images and sampled pixels for every colour claim. Here's what a developer would file.

---

**1. The "muted" foreground role is roughly half as contrasty in light as in dark — while the primary foreground matches.** Measured on the page fill: primary fg is `#131313` on `#f1f1f1` = **16.45:1** light, `#eeeeee` on `#181818` = **15.30:1** dark (well matched). But the secondary/muted fg is `#5c5c5c` on `#f1f1f1` = **5.92:1** light vs `#cccccc` on `#181818` = **11.06:1** dark. That single token carries the `VIBRANTGIO` eyebrow, the lede ("Complete example apps built on mvu…"), every one of the nine card descriptions in both window shots, and "forever"/"per month" in the pricing strips. Both pass AA, so this isn't a failure — it's that the two schemes do not say the same thing. A developer who tunes body copy in dark and flips to light finds it visibly washed out, and there is no token to fix without also moving the primary.

**2. The same ~2x split runs through the accent, and it is not a one-off.** Accent on page: `#723ad4`/`#f1f1f1` = **5.68:1** light vs `#d0c4ff`/`#181818` = **11.01:1** dark. Button label: white on `#723ad4` = **6.42:1** vs `#22004e` on `#d0c4ff` = **11.05:1**. Chip label: **4.51:1** vs **5.79:1**. Four independent measurements, all landing at light ≈ half of dark, with only the primary foreground exempt. That reads as a palette generated for dark and mechanically inverted, and it's the single most defensible complaint in the set.

**3. The chip label in the light scheme lands at 4.51:1 — 0.01 over AA.** `#5c5c5c` on the chip fill `#d4d4d4`, in both `cardgroup-light.png` (the "Popular" chip at y182–197) and `pricing-light.png` (the "Popular" chip beside "Studio"). That 4.51 is the *darkest core pixel* of the glyph; every antialiased stroke on this small label is below AA. The dark equivalent has real headroom at 5.79:1. No margin at all for a label rendered at chip size.

**4. In `light-window.png` and `dark-window.png` the app tiles have no fill whatsoever — the entire card boundary is a 1.51:1 hairline.** Card interiors sample to exactly the page fill (`#f1f1f1` / `#181818`); the border is `#c6c6c6` / `#383838`, both **1.51:1**. That is half the 3:1 usually asked of a meaningful non-text boundary, and it is the *only* thing defining nine containers. To be clear this is not the excluded white-on-off-white ruling: the whole 1.29M-pixel light window contains **477 white pixels** (they are the "Launch" glyphs) and only three fills above 5000px — page, accent, hairline. There is no raised surface anywhere in the flagship screen.

**5. Every launcher tile has 17px of top padding and 54px of bottom padding.** Measured ink bands inside the tiles: card 1 (`Todos`) top pad 17 / bottom pad 54; card 5 (`Vault View`) 18/54; card 9 (`SK150 Control`) 19/54. Identical in both schemes. The row-3 tile is alone on its row with nothing to equalise against and still carries the 54px dead band, so this is not row-height equalisation — the tile height is fixed and the slack all pools under the button. A 3.2x top/bottom asymmetry reads as a layout bug in every tile simultaneously.

**6. The same bottom-heavy slack appears in the Group specimen.** In `cardgroup-light.png` / `cardgroup-dark.png` the Card box and the Group box are *exactly* the same geometry (both x24–283, y65–214 and y287–436, i.e. 260x150). The Card's content sits at 18 top / 17 bottom — balanced. The Group's sits at 20 top / **44 bottom**. Two specimens presented as peers, one balanced and one not, in a strip whose entire job is to let a developer compare the two containers.

**7. The Group specimen renders its title in a role that no real Group in this system uses.** "Density" is `#5c5c5c` (muted, 5.92:1) while "Recommended" in the Card beside it is `#131313` (16.45:1). But every *actual* Group elsewhere in these images uses the full foreground for its title: "Sketch" and "Team" in the pricing strips are `#131313`/`#eeeeee`, and all nine launcher tiles (which are Groups — same `#c6c6c6`/`#383838` border, no fill) are `#131313`/`#eeeeee`. So the reference specimen contradicts every shipped usage, and a developer copying it gets a demoted title. Note also that the mute is much heavier in light than dark here (5.92 vs 11.06), so the specimen doesn't even misbehave consistently.

**8. The pricing row is left-aligned with 236px of trailing dead space.** In `pricing-light.png`, content ends at x=663 in a 900px strip; the three tiers are ~203px each with 16px gutters, inset 24px from the left. The `cardgroup` strip's content reaches x=899. So the pricing pattern is not stretching to or centring in its constraints — it looks like a hard-coded column width that a developer will discover the moment they drop it into a wider container.

**9. Both pricing strips are cropped through their own section caption.** In `pricing-light.png` and `pricing-dark.png` the header band is only 12 rows tall (y0–11) and there is glyph ink *at row 0* — the caption is sliced mid-letterform. The comparable band in `cardgroup-*.png` is 31 rows (y13–43) with the caption fully inside and 13px of page above it. Whether that's the capture harness or the strip layout, a gallery that ships images of its own components with the label cut in half is a filable defect.

**10. The pricing row mixes two container types with no stated rule.** Studio is a filled Card (`#ffffff` / `#222222`, no border); Sketch and Team are Groups (page fill + hairline, borders visible as ink bands at y32–34 and y295–297). Meanwhile the launcher makes *everything* a Group. A developer reading these four images gets: featured = Card, non-featured = Group, but also nine equal-weight app tiles = Group. Especially in `pricing-dark.png`, the two unfilled tiers read as dimmed or unavailable next to the lit middle one — plausibly the intent, but nothing here tells you which reading is correct.

---

Load-bearing things I checked and found clean, since they bound the complaints above: the primary foreground is well matched across schemes (16.45 vs 15.30); the launcher grid is symmetric (46px left and right margins, 16px gutters, uniform 190px row heights); the pricing tiers are dimensionally consistent (all three 268px tall, buttons all y243–278, ~161px wide, gutters exactly 16px both sides); the Card and Group specimen boxes are pixel-identical between light and dark; and the accent used for icons and pricing checkmarks is the same value as the button fill in each scheme. The `seen` in the lede is a real sibling repo, not a truncation.

## Triage

**Fixed in this task.**

- **6, the group specimen's bottom slack.** The reviewer is right that
  the two specimens are the comparison and one of them was not
  balanced. The cause was the specimen, not the pattern: both boxes are
  260×150 and the group held one paragraph where the card held three
  slots, so the slack pooled under it. The group specimen now holds
  two things rather than one — which is also truer to what a group is
  for — and the two boxes read as peers.

**Answered by the ruling, recorded rather than changed.**

- **4, the launcher's tiles have no fill and a 1.51:1 hairline.** Both
  halves are the ruling working. The hairline is a seam, and a seam is
  deliberately not the 3:1 a graphic carrying meaning owes: it is a
  measurement of the platform, which draws this line quietly — Voice
  Memos outlines its inset panel at 1.514:1. And the launcher's roster
  is nine peers with nothing singled out, so it divides the page and
  every app is a group; the task's packet ruled that explicitly. The
  observation worth keeping is the second sentence: the window that
  fronts this system now shows no raised surface at all. Whether the
  flagship screen should carry one is a composition question for the
  owner, not a defect in the conversion.
- **10, pricing mixes two container types.** It does, and the rule is
  stated in the Language rather than in the image: a row of tiers
  divides the page, so the tiers are groups, and the one tier that
  must stand apart is a card. That the two unfilled tiers can read as
  dimmed or unavailable beside the lit one is a real risk and is
  pooled below.

**Out of scope, for pooling.**

- **1 and 2, the light/dark contrast asymmetry** across the muted
  foreground, the accent on the page, the filled button's label and
  the badge's label — four measurements landing at light ≈ half of
  dark, with the primary foreground exempt. This is the palette's own
  derivation and reaches nothing this task touched.
- **3, the badge label at 4.51:1 in the light scheme**, 0.01 over AA
  at the darkest core pixel of a small label. A components/badge
  finding with an accessibility floor behind it.
- **5, the launcher tile's 17/54 top-to-bottom slack.** Pre-existing
  and unchanged by the conversion: the cell is a fixed 190 dp and its
  content is shorter, which was as true of the card it replaced. The
  slack pools under the launch row in both.
- **7, the group label's colour.** The label is set in the ramp's
  low-contrast step deliberately — a section header should not carry
  the weight of the content it names, which is the platform's own
  idiom for a label over a bordered container. The reviewer's counter
  is that every group in these images shows a full-foreground title;
  those are content the group holds, not the group's own label, and no
  shipped group uses the label yet. That makes it a design question
  the owner should settle rather than a defect, and the specimen is
  the only place it is visible.
- **8, the pricing specimen's trailing space.** The gallery caps that
  specimen at 640 dp inside a 900 px tile. Whether the pattern should
  stretch or centre in a wider container is a real question, but it is
  not what this image measures.
- **9, the sliced caption.** The crop's offset, not the gallery's
  layout.
