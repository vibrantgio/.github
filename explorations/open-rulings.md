# Open rulings — 2026-08-21, reordered 2026-08-30

Every distinct open issue found across the walkthrough phases, numbered
for ruling. Tags: **[bug]** = just needs fixing, no design choice;
**[decide]** = needs an owner ruling on direction; **[feature]** = new
capability. Comment per item in place; the orchestrator cuts phases
from what is ruled, in the order ruled.

Reordered 2026-08-30 into ruling order: every **[bug]** first, then
the rest in descending importance — judged by what a user pays for
the ruling being open, and by how much other work waits on it.
Item numbers are identities (reviews/, memory and commit messages
cite them), so items moved whole and none was renumbered; the
numbering is therefore not sequential, which is correct. Each item
carries the section it arrived under; the sections' own preambles
are kept verbatim under "Review provenance" at the foot.

Grooming rule (owner-ruled 2026-08-30): when a sharper later item
restates an older one, the older item retires even if the later one
does not cite it by number — verify the restatement is complete before
deleting, and name every removal in the commit body. Item numbers are
identities and are never reused or renumbered.

## Bugs

Fixes needing no design ruling, worst consequence first: a crash, then
the states and inks a reader cannot see, then the library defects a
consumer ships, then layout and copy.

117. **[bug]** Added 2026-08-29, from BA2.2's live verification: with
     the display asleep, any org app crashes on launch — Gio 0.10.2's
     window init gets a `newDisplayLink` failure, releases the view
     early, and dies with `runtime/cgo: misuse of an invalid Handle`
     (`os_macos.go:1076`). Pre-existing upstream behaviour, reproduced
     on a pre-change binary at HEAD. The workaround every live-launch
     task needs: `caffeinate -u -t 3` before launching. Candidate for
     a line in `reference/macos` and an upstream report.
     *(§L, from BA2.2's live verification)*

126. **[bug]** Focus and selected-state collide on checkbox and
     radio: the focus treatment replaces the fill, so a focused
     checkbox renders unchecked and a focused radio loses its dot —
     focused-and-checked cannot be drawn at all. The reviewer named
     this the first thing to escalate; keyboard focus is an
     accessibility requirement. Also under this item: focus is drawn
     three different ways across families (chip outlines outside the
     shape, text field recolours its border, checkbox/radio replace
     the fill) — the fix should pick one grammar.
     *(§N, BD1.1's fresh-eyes review of the gallery window)*

60. **[bug]** Light-scheme disabled states collapse to invisibility:
    disabled Button label 1.23:1, text-field placeholder 1.44:1,
    checkbox and radio outline 1.31:1 — against 5.5–17.7:1 for every
    enabled counterpart. At 1x the disabled radio reads as a solid
    pale disc, i.e. as *selected*. Dark's equivalent is 3.14:1, so
    this is a light-only collapse, not a global "disabled is quiet"
    choice.
    *(§I, AH1.1's five-tab review — contrast and state)*

63. **[bug]** Dark: the disabled dropdown and text field (#555555,
    2.38:1) are twice as visible as their enabled counterparts
    (#222222 on #181818, 1.12:1). The eye lands on the control that
    cannot be used.
    *(§I, AH1.1's five-tab review — contrast and state)*

62. **[bug]** The Divider token cannot divide: Neutral 300 is 1.37:1
    against Background, 1.21:1 against Surface, 1.31:1 in dark. Every
    rule drawn in it — the Palette Picks column groups, the Docs
    sidebar seam — is imperceptible at 1x.
    *(§I, AH1.1's five-tab review — contrast and state)*

94. **[bug]** Added 2026-08-29, from AZ1.2's fresh-eyes review: the
    gallery's own caption convention — neutral step 600 at 11 sp —
    measures roughly 3:1 on the light page, under the 4.5:1 text
    floor, and it is the least legible text in the capture. It is not
    one section's choice: every inventory section labels its
    specimens that way. The fix is one convention changed in one
    place, and it moves every stored group image.
    *(§I, from AZ1.2's fresh-eyes review of the gallery's chip section)*

138. **[bug]** The button's interaction ramp never re-picks its ink:
     the face darkens Rest→Hover→Press (#72A500→#5A8300→#436300)
     while the label stays #000000, so Press lands at 3.02:1 — an AA
     failure nearly as quiet as the disabled chip — where Rest is
     7.10:1. The system demonstrably can re-pick (the pinned red takes
     white ink; dark flips the seed card's Aa bar), so on-primary is
     resolved once against the base and reused down the ramp. Belongs
     to components/button. The focus ring rides along: drawn 2 px
     inside the face at 3.41:1, it passes but is nearly
     indistinguishable from rest at 1x.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

8. **[bug]** Text colours are checked against the page, then reused on
   darker card surfaces unchecked — card descriptions drop to 4.51:1.
   *(§A, colour generation)*

79. **[bug]** Reference content is set lighter than the chrome around
    it: the module table (~60 lines, the actual reference material) is
    #424242 at 8.2:1, while the heading and the throwaway lead-in
    above it are #131313 at 15.2:1.
    *(§I, AH1.1's five-tab review — docs tab)*

3. **[bug]** Light mode uses the dropped seed colour *unchanged* as
   Primary; dark mode re-tones it to fit. A light seed therefore
   breaks light mode's own lightness rules. This is also why the
   toggle looks different per scheme.
   *(§A, colour generation)*

4. **[bug]** In dark mode, Primary and Secondary are nearly the same
   colour — side by side you cannot tell them apart. Saturation isn't
   controlled in dark the way it is in light. (2026-08-21: the new
   palette grid shows it plainly — dark Primary 700 #b0cdff vs
   Secondary 700 #b2cdfd, steps 800/900 byte-identical, Info close
   behind.) SHARPENED 2026-09-02 by BQ1.2's review: the dark Primary
   and Secondary pick chips, 60 px apart in the same Accents list,
   measure ΔE 1.17 — under the just-noticeable difference for flat
   areas, so a primary button and a secondary button render as the
   same pixel — and dark 800 (#c2d8ff) and 900 (#e5eeff) are
   byte-identical between the two roles. The light scheme has the same
   defect at its pale end, which this item said it did not: light
   Primary and Secondary 100/200/300 are byte-identical (#f2f7ff,
   #dce9ff, #bdd6ff) and light Info 100/200 sits within ΔE 0.70/1.76
   of both, so three of nine steps in two accent ramps plus the
   nearest status are one blue under several names.
   *(§A, colour generation)*

67. **[bug]** All four alert levels draw the identical glyph, a small
    right-pointing solid triangle differing only in hue. Severity is
    carried by colour alone (WCAG 1.4.1), and the glyph reads as a
    disclosure or play control, so every alert looks expandable.
    *(§I, AH1.1's five-tab review — elevation and marks)*

65. **[bug]** The focused text field draws no caret in either scheme;
    focus is signalled only by a 2px border recolour. In a gallery
    whose job is showing states, the insertion point is absent.
    *(§I, AH1.1's five-tab review — contrast and state)*

61. **[bug]** Dark-scheme buttons have almost no interaction feedback:
    rest/hover/press are L* 81.9 → 88.0 → 94.1, ΔL* 6.1 per step,
    where light is 40.2 → 29.2 → 8.5 (ΔL* 11.0 then 20.7). Hover is
    half as strong and press a third as strong; press is also the
    *lightest* state, inverting the usual pressed-is-recessed reading.
    *(§I, AH1.1's five-tab review — contrast and state)*

16. **[bug]** Link hover changes the colour by almost nothing (1.05:1
    difference in dark) — hovering does nothing visible.
    *(§B, plain bugs, no design choice needed)*

64. **[bug]** Light: the open dropdown's popup surface is #B6B6B6 —
    darker than both the page and the control's own closed fill, a
    1.88:1 step *down*. It reads as disabled rather than as floating.
    *(§I, AH1.1's five-tab review — contrast and state)*

101. **[bug]** The transcript's scrollbar thumb fills its whole track
     and is drawn anyway: a 6 px bar at x 1012–1017 running the full
     viewport height in both schemes, at `#8D8D8D` light and `#878787`
     dark — the same hard mid grey either way, so it is not themed at
     all. A thumb that fills its track means nothing scrolls and
     nothing should be drawn; a bar parked 6 px off the window edge in
     both schemes is also not what this platform's overlay scrollbars
     look like. SHARPENED by BA2.1's review, which met it again in the
     new composition: with the pane away and the transcript centred in
     the window, the bar now stands at x 901 with 117 px of empty ground
     trailing it — a scroller floating that far inboard of the view's
     own edge is not something this platform does at all. Contrast to
     ground measured 3.03 light / 4.94 dark, so it is LOUDER in the dark
     scheme, and it never goes away. SHARPENED again by BB3.1's
     review, which measured it against the stored reference rather
     than against a remembered platform: the thumb is 6 px where
     `textedit-scrollbar.png` reads 11, the gutter 10 px where the
     reference reads 16, and there is no groove behind the thumb where
     the platform fills a capsule. The shape is right — both are
     rounded capsules — and every size is wrong. It also reserves its
     gutter rather than overlaying it, which is what puts the bite in
     the user band's trailing edge (item 103) and what leaves 35 px of
     bare page under a thumb that has run out of travel.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

103. **[bug]** One column, three right edges and two left edges: the
     message band ends at 1009, the composer's border at 1011, the
     scrollbar thumb occupies 1012–1017; the band starts at 226 and the
     composer at 234. Nothing in the transcript column agrees with
     anything else in it. SHARPENED by BA2.1's review after the column
     was centred: in the pane state the message band runs 248–1013, the
     composer 256–1015, the rule above the composer 260–1011, a code
     block 310–1001 and the picker 787–1005 — six elements, five
     different trailing margins (10, 8, 12, 22, 18). The band is flush
     against the pane on its leading side and stops 10 px short on its
     trailing side to clear the scrollbar, so the user's slab is visibly
     off-centre inside its own column. One more edge from BB3.1's
     review: the composer's separator hairline is inset 12 px on each
     side where the field it separates is inset 8 px, so the line is
     visibly narrower than the box 9 px beneath it.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

105. **[bug]** The menu lists the same model twice with nothing saying
     so: "Default (OpenAI · gpt-5.5)" at the top and "gpt-5.5" three
     rows down under the OpenAI caption resolve to one model, and only
     one of them carries the active dot.

     (Sharpened 2026-08-30 by BB2.1: the anchor now reads
     "provider · model", matching neither menu row verbatim, so the
     duplication lost the anchor's leading-word hint. Likely fixes:
     the Default row says "Default" alone with the dot doubling onto
     the real model row, or the standalone Default row goes.)
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

74. **[bug]** The Accents rules change their claim with the scheme:
    light says Primary is "the seed, lifted, just off Primary 700",
    dark says flatly "Primary 700". Toggling appearance changes what
    the documentation asserts about provenance. Bears directly on
    AH2.1, which has to caption the seed honestly. SHARPENED
    2026-09-02 by BQ1.2's review: the second half of the same sentence
    diverges too — light ends "measured over Primary" where dark ends
    "measured over the base" for the identical relationship — so on
    top of asserting different provenance, a diff of the two schemes'
    output is unreadable.
    *(§I, AH1.1's five-tab review — palette presentation)*

237. **[bug]** The palette board's dot points at a step whose colour
     the chip beside it plainly is not. The caption says "a dot marks
     where each pick lives", and for two container families that is
     false by a wide margin: light SuccessContainer #bbddbe against
     the marked Success 300 #7feb8f is ΔE 40.6 — a muted sage against
     a vivid mint — and WarningContainer #e4d3ac against Warning 300
     #ffce4b is ΔE 47.3, while ErrorContainer (3.3) and
     InfoContainer (3.9) are visually exact. Dark: Error 28.8,
     Success 13.3, Info 12.4, Warning 8.8. The derivation's clamp,
     which holds a container at the container chroma, bites hard on
     two families and not at all on two others, so one sentence is
     true four times and false four times on the same board. The fix
     is the claim or the dot, not the clamp. Bigger sibling of item
     54, where the same dot overstates by 2–3/255.
     *(§AG, BQ1.2's review)*

120. **[bug]** Added 2026-08-29, from BA3.1: `llms.txt`'s vaultview
     paragraph (~line 1560) says "panes raised one rung to Surface",
     which contradicts the anatomy bullet and `patterns/pane`'s own
     doc — a floating pane stays at the floor and never takes a
     lighter fill. Stale pre-linchpin prose; the fix is one sentence
     told the current truth.
     *(§L, from BA3.1)*

70. **[bug]** Inline code chips push adjacent punctuation away: the
    chip's horizontal padding is added outside its background box, so
    a trailing comma is visibly detached and a leading space doubles.
    Every chip in the sample shows it.
    *(§I, AH1.1's five-tab review — markdown)*

140. **[bug]** The inline code chip's fill is a no-op in light:
     #F8F8F8 on a #F6F6F6 page, 1.02:1 — the hairline and the mono
     face do all the work. The surface token feeding it resolves to
     the page, and will do nothing on every other component bound to
     the same token. Markdown module.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

71. **[bug]** The heading ladder collapses at the bottom: cap heights
    are H1 18px, H2 16px, H3 14px, H4 13px, body 11px, all at the same
    weight and colour. H3 and H4 differ by one pixel.
    *(§I, AH1.1's five-tab review — markdown)*

77. **[bug]** The Docs tab paints its page one tonal step off every
    other tab (#E8E8E8 vs #F6F6F6 light, #222222 vs #181818 dark), so
    switching tabs shifts the whole window. Its sidebar also shares
    the reading pane's fill, separated only by a 1.21:1 hairline, so
    nothing makes the sidebar read as a sidebar.
    *(§I, AH1.1's five-tab review — docs tab)*

69. **[bug]** The inventory's List section shows its overlay scrollbar
    thumb floating in open space: the list has no container, border or
    distinct surface, so the thumb reads as an unexplained grey
    capsule mid-window.
    *(§I, AH1.1's five-tab review — elevation and marks)*

133. **[bug]** The Background swatch and the Neutral ramp's first
     step are painted exactly the page ground (246 on 246 light, 24
     on 24 dark) with only a 1.3–1.9:1 hairline saying where they
     are. A gallery-page issue: a swatch whose job is showing a
     colour needs a boundary that survives 1x — likely a stronger
     border or a checker/contrast backing for ground-coloured cells.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

134. **[bug]** The role-swatch row breaks its grid at one cell: 64px
     pitch everywhere except after Background, which is 67px, because
     the "Background" caption (58px) outgrows its 56px swatch and the
     column is sized by its label. Fixed column width or a truncated
     caption; identical in both schemes, pure layout.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

33. **[bug]** Alert content is top-anchored when a caller hands it a
    taller box — can't be centred.
    *(§E, components and patterns)*

34. **[bug]** Light toast shadow reaches 9px but the stack gap is 8px,
    so stacked toasts never visually separate; in dark the black
    shadow is invisible entirely.
    *(§E, components and patterns)*

18. **[bug]** The `disclosure` and `forward` icons are
    pixel-identical.
    *(§B, plain bugs, no design choice needed)*

50. **[bug]** The dropdown's popover doesn't dress like its
    trigger: a rounded, outlined pill glued onto a square,
    borderless, zero-padding slab, with transparent nicks at the
    seam where the trigger's corners curve away. The chevron also
    dims asymmetrically (5.5:1 light vs 9.9:1 dark).
    *(§G, from the dropdown review, 2026-08-21)*

53. **[bug]** Base-list column cosmetics: the scroll thumb sits
    2px from the applied row's pill but 9px from its other edge;
    the header count right-aligns over the scrollbar gutter while
    rows and tags keep two other right edges; and the caption's
    descenders overlap the first row's band, so a marked row
    arriving at the top would collide. One tidy pass.
    *(§G, from the base-list review, 2026-08-21)*

40. **[bug]** Copy sweep: three casing conventions, three state
    vocabularies ("Focus"/"Focused"/"unset"), one "&" vs "and", a
    hardcoded "961 icons" count, and "OpenAI" named on a launcher
    tile.
    *(§F, copy and identity)*

144. **[bug]** The dark ramp's middle is a measured 35 L* canyon
     between steps 400 and 500: no dark step lands anywhere between
     1.9:1 and 6.6:1 against the page, so a 3:1 non-text tone or a
     4.5:1 text tone cannot be picked from the dark ramp at all, where
     light covers the same territory smoothly (2.65/3.99/6.16). The
     curve is not the light curve reflected — a dark-end shape spliced
     onto a light-end shape, the seam at 400→500. Names and sharpens
     item 132 with exact numbers a test in theme could pin.
     *(§Q, BF1.1's Palette Seed review)*

145. **[bug]** Four of nine dark ramp steps read as one colour:
     100→400 adjacent contrasts are 1.12/1.18/1.44, and step 200 is
     the same luminance as the section panel it is drawn on. Light
     crowds the same way at 100–300 but recovers by 400. The same
     ramp-curve fact as item 144, seen from the near end; names item
     132. SHARPENED 2026-09-02 by BQ1.2's review, which found the far
     end crowding too: the dark 700→800 gap is 4 L*, giving Neutral
     #cccccc/#d7d7d7 at ΔE 3.9, Success 3.9, Primary 7.4, Secondary
     6.4 and Info 7.1 — two more of the nine dark steps carrying
     almost no information. Full series measured, light
     97.0/92.0/85.0/74.0/63.0/51.0/39.0/28.0/6.0 (first gap 5, last
     22) against dark 8.2/13.1/18.9/30.0/46.0/64.0/82.0/86.0/94.0,
     which is item 144's splice read off the step numbers: the dark
     set is not the light set reversed, so one step index names a
     different lightness in each scheme.
     *(§Q, BF1.1's Palette Seed review)*

230. **[bug]** `theme/export/css.go`'s toast block (around lines
     1699–1714) calls the toast's status — info, success, warning,
     error — its "level": "the level's own mark on the inverse
     surface", "each level takes its own status ramp". The wording
     dates from T2.1, before LEVEL became the elevation word, and
     is emitted verbatim into `design/styles.css`. Found by BN3.4's
     worker, which left it: pre-existing, and not an elevation
     level. Fix: say status, the established family word, in the
     export and regenerate `design/` with the clean-diff check.
     *(§AG, BN3.4's worker)*

232. **[bug]** The arrival highlight's fade reads `tokens.Motion.DurSlow`
     off the package default scale rather than the theme's own, so a
     window running under the OS reduce-motion preference — which is what
     `MotionScale.Reduced` exists to serve — still tweens the wash out
     over 400 ms instead of dropping it. The note column's `themeTokens`
     snapshot carries colour, typography, spacing and density and no
     motion, and threading a fifth stream through it was out of BP2.1's
     scope. Fix: carry the motion scale in the snapshot the way the other
     four are carried, and read the stop from there.
     *(§AG, BP2.1)*

250. **[bug]** `workbench/feeds` and `workbench/sitedocs` each keep a
     function named `backdropLayer` that paints level 0, the content.
     Now that the backdrop is a level of its own the name says the
     wrong level; vaultview's twin was renamed in BR1.1, these two
     were left because the task had no other reason to open the
     files. *(from BR1.1's execution)*

251. **[bug]** The gallery's three-column frame specimen picks four
     sidebar item swatches that hold apart in light and converge in
     dark: the first two land 1 and 5 units apart in G and B, so two
     adjacent rows stop being tellable apart. A specimen defect, not
     a derivation one — the swatches are the specimen's own choice.
     *(§AH, BR1.1's review)*

257. **[bug]** The outlined card's stroke is centred on the fill's own
     rounded rectangle instead of being a shape of its own, and one
     cause makes four measured defects: the outlined card's footprint
     is 262×152 against the filled card's 260×150, so the two looks'
     top and bottom edges sit a pixel apart and their content insets
     differ (17 against 16); each edge is two partly covered columns
     that read as a two-device-pixel line at 1x where a hairline is
     one; the corners overdraw by about a quarter (arc peak 105
     against 82 on the straights); and a one-pixel seam of the surface
     beneath shows between arc and fill at every corner, harmless only
     while the two fills are 0.7 L* apart. The dark outline is derived
     to clear 3:1 (nominal 3.23:1) and rasterizes at 2.27:1. Replaces
     item 68, which carried the one-pixel offset alone.
     *(§AI, BR1.2's review)*

258. **[bug]** The gallery's own section band stands darker than the
     backdrop in the dark scheme — (21,21,21) under a (24,24,24)
     content, separated only by its divider row — the day after BR1.1
     settled that chrome stands a tint lighter than the backdrop. The
     band is the gallery's furniture and was not in that pass.
     *(§AI, BR1.2's review)*

## Tier 1 — Token and palette derivation

Rulings that live above every control, because each one is inherited by
everything the theme dresses. Nothing below this tier can be settled
durably while these are open.

124. **[decide]** The Filled and Tonal registers trade perceived
     loudness between schemes. Light: Filled is the saturated fill
     with on-colour ink, Tonal the pale wash — a clear ladder. Dark:
     the derivation hands Filled the light tone and Tonal the deep
     saturated container, so the same two call sites produce opposite
     visual hierarchies per appearance. The consequence with teeth is
     the modal footer: light makes Discard the unmistakable solid
     primary beside a pale Cancel; dark reverses which of the pair
     shouts. The semantics hold — this is the dark derivation working
     as derived — but the loudness ladder does not survive the flip.
     A token-derivation decision, above every control that inherits it.
     RE-MEASURED 2026-09-02, BQ1.3 having put Tonal on the badge's tint:
     the dark Tonal fill is no longer a saturated container but a
     low-chroma tint (#312a48, chroma 0.054 in Oklch), so the flip is
     milder than the item records. It is not gone — dark still hands
     Filled the light tone and Tonal a deep one — and the ruling stands
     as written.
     *(§N, BD1.1's fresh-eyes review of the gallery window)*

241. **[decide]** The neutral role's foreground stops at the floor
     where the four statuses overshoot it, and only in dark. Measured by
     BQ1.3's fresh reviewer off the gallery's own goldens: on their own
     container fills the dark badge labels sit at 8.40–8.48:1 for
     Success, Warning, Error and Info and at 4.89:1 for Neutral, so the
     word "Neutral" reads perceptibly dimmer than its four neighbours in
     a row whose whole point is that the five agree; in light all five
     land within 4.51–4.56:1 and nothing shows. The cause is in the
     derivation rather than the component: a status answers with its
     pinned base whenever that base clears the floor, and in dark the
     pins overshoot, while RoleNeutral has no pin and answers with the
     walk, which stops at the first step that clears. Since BQ1.3 the
     tinted button reads through the same derivation, so whatever is
     ruled here moves both. Decide whether a foreground that clears its
     floor by a wide margin should be pulled back toward the set, or
     whether the neutral walk should overshoot to match — the pinned
     bases are the palette's own guarantee and moving them is the larger
     change. *(§AG, BQ1.3's review)*

242. **[decide]** The tinted state walk has a floor and no ceiling, and
     the pressed label pays for it. BQ1.3 put the Tonal button on the
     container family, so hover and press walk the realized fill along
     the neutral ladder and the label is re-derived against wherever the
     walk landed — the best a re-derivation can do, because past a
     certain depth no step of the role's ramp reaches 4.5:1 over the
     walked fill. Measured over the seed sweep, both derivations, both
     schemes, all five levels: the resting pair clears its floors
     everywhere (worst fill-vs-surface 1.303:1 against the 1.25
     ContainerFloor, worst foreground-vs-fill 4.501:1 against the 4.5
     TextFloor), while the walked label bottoms out at 4.208:1 — and the
     DEFAULT seed's own pressed label sits at 4.261:1 light and 4.430:1
     dark, under the floor its resting state clears. Pinned as a fence
     rather than a floor in TestTonalsWalkedLabelIsTheOpenGap. Neighbours
     233 (the wash has a floor and no ceiling) and 234 (the tinted walk
     carries no floor); what is new is the measured cost in the shipping
     palette, and that the cure is a ceiling on the walk rather than
     another floor. *(§AG, BQ1.3)*

122. **[decide]** The two schemes do not measure the same. For one
     semantic role the dark scheme lands at roughly double the light
     scheme's contrast — secondary text 5.46:1 light against 11.37:1
     dark, the user band 5.94 against 11.01, the control hairline 4.04
     against 5.94, the scrollbar thumb 3.03 against 4.94 — while
     primary text is the one pair that agrees (17.05 against 15.04).
     So the primary-to-secondary STEP is a 3.1× drop in light and a
     1.3× drop in dark, and the consequence is legible rather than
     academic: the composer's placeholder sits at 9.91:1 on its own
     fill in dark, close enough to body copy that "Send a message"
     reads as a message already typed, where the same placeholder at
     6.30:1 in light correctly reads as empty. This is not item 89
     (ink bloom is how much ink one label lays) and not item 107 (one
     ink spent on three roles inside one scheme): it is the two
     schemes having been derived to a floor rather than to a shared
     ladder of steps. The answer lives in the token derivation, above
     every control that inherits it.
     *(§M, BB3.1's fresh-eyes review of the picker in its anchor face)*

1. **[decide]** Text-on-colour contrast targets differ per scheme:
   light lands ~6.4:1, dark ~10:1, everywhere. Pick one target for
   both. SHARPENED 2026-09-02 by BQ1.2's review, measured across all
   seven roles on the themer's palette board: light puts white
   foreground on the 700 fill and lands at 6.44–6.87:1, dark puts the
   role's own 100 on the 700 fill and lands at 11.02–11.14:1 — the
   same components at about 1.65x the contrast in dark. Light reaches
   its number by spending one colour seven times: OnPrimary,
   OnSecondary, OnTertiary, OnError, OnSuccess, OnWarning and OnInfo
   are all literally #ffffff, which the board's own "Ink ends" entry
   confirms.
   *(§A, colour generation)*

131. **[decide]** Light muted text fails WCAG AA while dark doubles
     it: the subtitle at 4.03:1 and the type-spec labels at 3.97:1 on
     ~12–14px text (the 4.5:1 floor applies), against 8.76:1 for the
     same roles in dark; the inactive toggle glyph and swatch "Aa"
     pairs show the same ~2x split. Four independent measurements —
     the default scheme is the failing one. New evidence under item
     122's schemes-derived-to-a-floor-not-a-ladder finding.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

6. **[decide]** Status colours: all four share one lightness, so in
   greyscale they're identical; and the seed's influence on them is
   now too small to see but still changes goldens on every seed
   change. Either make status colours fully seed-independent, or let
   lightness vary a bit per role. Pick one.
   *(§A, colour generation)*

238. **[decide]** A step index names a lightness and nothing else:
     chroma is not matched across roles at the same step. Light step
     200 runs Error C* 10.9 (reads white), Secondary 12.1, Warning
     32.4 and Success 59.5 (a vivid mint); step 400 runs Secondary
     26.5 against Warning 81.8. Secondary and Tertiary are flat in
     chroma the whole way (26 and 41) while Primary, Error, Success,
     Warning and Info carry a pronounced arc, so a caller reading
     "300" gets a promise about lightness that is no promise at all
     about intensity — two swatches one row apart at the same step
     differ wildly (#96ffa4 against #dce9ff). Decide whether the steps
     owe a chroma envelope across roles, or whether the index is
     lightness only and the board should say so. This is cross-role
     inside one scheme, where item 178 is cross-scheme inside one
     role; adjacent to items 6 and 147.
     *(§AG, BQ1.2's review)*

100. **[decide]** The accent's meaning inverts between the schemes. In
     light the user's turn is a solid `#723AD4` with white text while
     the selected conversation row is a pale `#D8CEFF` tint with dark
     text; in dark the two swap exactly — the turn becomes the pale
     `#D0C4FF` and the row a near-black `#3F0085`. So one accent token
     means "saturated fill" in one component and "faint tint" in the
     other, and which is which flips with the scheme. The dark row's
     purple is also DARKER than the light one's, which is backwards for
     a ladder that climbs toward the viewer, and on the floor it reads
     as a muddy smear under a bright lavender rail.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

89. **[decide]** Added 2026-08-29, from AZ1.1's fresh-eyes review: the
    dark scheme lays ~57% more ink than light for the same label at
    the same size (glyph coverage 409 vs 261, half-alpha pixels 438
    vs 252) — the classic light-on-dark bloom, well past subtle, and
    a token-set property (`c.Text` both schemes), not any control's.
    Side by side the dark label reads semibold against a regular.
    Compensate in the ink (a lighter grade or a dimmed dark ink) or
    accept and record; every text control inherits the answer.
    *(§I, from AZ1.1's fresh-eyes review)*

91. **[decide]** Added 2026-08-29, from AZ1.1: the dark state ladder
    is quiet and relative — `StateAt` hover in dark is a Δ12/255 step
    on a flat fill (about the floor of what registers), dark pressed
    at level 1 lands on the same mid grey other surfaces rest on, so
    no absolute colour means "pressed", and a light press moves a
    derived rim while a dark press cannot. Pre-existing system
    behaviour (mindchat's shipping hover value matches); if the dark
    walk should stride longer, the answer lives in `StateAt`, not in
    any one control.
    *(§I, from AZ1.1's fresh-eyes review)*

90. **[decide]** Added 2026-08-29, from AZ1.1's fresh-eyes review:
    `theme/typeset`'s line-box centring drifts against the cap band —
    a label with no descender sits visibly high in one control size
    and low in another (measured 11/14 and 9/7 above/below on the
    same control's two densities). Optical centring on the cap band
    would move goldens across every text control; a ruling picks the
    band and the blast radius.
    *(§I, from AZ1.1's fresh-eyes review)*

127. **[decide]** Two dark-scheme legibility soft spots in the
     component states: the disabled text field's placeholder is
     grey-on-grey to the point of illegibility, and the pressed chip
     carries near-white ink on a mid-grey fill far weaker than its
     light counterpart. Possibly the same root as item 122's
     schemes-measure-differently finding.
     *(§N, BD1.1's fresh-eyes review of the gallery window)*

244. **[decide]** Error and warning are the palette's least separated
     pair, in both schemes and in both channels. BQ1.4 took the wash's
     hue off the depth it is realized at, which carried the dark pair
     from ΔE00 8.8 to 18.1, level with light's 18.8, so the two schemes
     no longer disagree about it. What is left is that this one pair
     separates about half as far as every other: measured off the alert
     and badge specimens, error/warning is 18.1 dark and 18.8 light,
     warning/success 20.0 and 18.6, and the remaining four pairs run
     25.9–35.7. The marks repeat the weakness instead of covering it —
     #fd6d65 beside #f07b1e in dark is ΔE00 19.8, #b12226 beside
     #944600 in light 17.8 — so an alert that reports an error and one
     that reports a warning are told apart by the system's weakest
     distinction twice over, and item 67's identical glyph leaves
     nothing else carrying it. Decide whether this pair owes a
     separation floor above the set's, and where the room comes from:
     warning's bend already stops at 30° for exactly this reason and
     error's anchor is fixed, so the answer is a lightness or a chroma
     and not a hue. Replaces item 45, which asked whether to accept
     ΔE00 8.8 or make the exception; the exception is made and the
     number it quoted is stale.
     *(§AG, BQ1.4's review)*

46. **[decide]** Dark Tertiary and dark Error can converge on
    near-identical pale pinks (ΔE00 11.9 with a green seed —
    closer than any status pair). Tertiary is the seed hue +60°,
    so some seeds park it on error's doorstep. Should tertiary
    owe the error family a separation gate the way the accent
    already does?
    *(§C, from the warning-orange review, 2026-08-21)*

10. **[decide]** The palette has no container/outline roles, so
    controls borrow the Divider token for fills (e.g. the switch
    track). Add the two roles?
    *(§A, colour generation)*

130. **[decide]** The dark rail-to-content seam carries no edge at
     all: floor #151515 against background #181818 is 1.028:1 and the
     scan across the boundary finds no divider hairline — the bare
     21→24 step is the whole seam (light manages 1.134:1 plus the
     same absence). The storey relation is ADR-022's own; the open
     question is whether a floor-to-paper seam owes a hairline where
     the measured step is imperceptible. Sharpens item 125.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

92. **[decide]** Added 2026-08-29, from AZ1.2's fresh-eyes review of
    the gallery's chip section: in the LIGHT scheme the three storeys
    are visually one. Paper, card and dialog sit within a couple of
    percent of each other, so a chip filled one rung over any of them
    is white on white and only its rim says a pill is there — the
    reviewer's words were that the light capture demonstrates nothing
    the first row alone would not. The chip documents this as the
    reason it carries a rim at all; the open question is whether the
    light ladder should have more headroom above its paper, which is
    an ADR-022 answer and not a control's.
    *(§I, from AZ1.2's fresh-eyes review of the gallery's chip section)*

129. **[decide]** The pinned specimen's fixed red delivers two
     legibility outcomes: markedly weaker contrast against the dark
     ground than the light one. The pin is deliberate — that is the
     row's whole point — but whether a pinned fill owes a per-scheme
     ink gate is a standing question, not a gallery one.
     *(§N, BD1.1's fresh-eyes review of the gallery window)*

146. **[decide]** Light accents inherit the seed's own lightness while
     dark pins every accent to L*82: five seeds land at a guaranteed
     11.07–11.11:1 in dark but range 4.62–9.15:1 in light, with the
     on-accent label flipping polarity mid-row (white on one card,
     black on four). Everything passes AA, but the default scheme is
     the lottery and the red seed has no headroom. The seed row now
     shows this on screen, which is arguably the row doing its job —
     the ruling is whether light should take a floor like dark's.
     *(§Q, BF1.1's Palette Seed review)*

147. **[decide]** The dark accent pin collapses red's identity (C87 →
     C27 at L*82 — fire-engine red becomes blush pink) while boosting
     green and khaki at the same lightness, and five consecutive dark
     Error steps clip R at 255 so hue and chroma drift up the ramp
     (light Error clips four steps, Warning three). The chroma dial is
     disclosed by the app's own caption; the gamut clipping and the
     red-specific collapse are not the dial. *(§Q, BF1.1's Palette
     Seed review)*

231. **[decide]** The highlight wash and the accent's selection fill are
     the same hue family. Sampled off BP2.1's window captures: the wash
     is #E6CBEE light / #3B2641 dark, the sidebar's active row and the
     outline's active row #D8CEFF light / #3F0085 dark — violet beside
     violet, one saying "here is what you sought" and the other "this is
     where you are". The fresh reviewer read the pair as coherent rather
     than confusing (three violet marks, one destination) and named no
     defect. But the reservation the highlighter carries is measured
     against the four status hues and against nothing else, so its
     distance from the accent — which rotates with the seed, where the
     highlighter does not — is unmeasured and unruled. Decide whether the
     reservation owes the accent a distance too, or whether a marking and
     a selection sharing a hue is the right answer.
     *(§AG, BP2.1's review)*

233. **[decide]** The wash has a floor and no ceiling. BQ1.1 gave
     `tokens.ColorTokens.StateAt` a 1.25:1 perceptibility floor against
     the surface it walks from, which moved every wash the eye could not
     see; it left untouched the three that are already too loud for what
     is written on them. In the dark scheme, level 2 pressed and level 3
     hovered land on the neutral ramp's mid-value step and level 3
     pressed one past it, where no neutral shade reaches the 4.5:1 text
     floor over the wash from either side — the ghost label measures
     4.46:1, 4.46:1 and 2.40:1 there. Nothing regressed: those three
     predate the floor and the floor does not move them. But a wash is
     the quietest a state is spoken at, and one that has walked past the
     middle of the scale is no longer a wash. Decide whether the walk
     owes a ceiling as well — the tonal container's own band is floored
     at 1.25 and gated at 2.5, and the deep levels' press sits at 2.62
     and 3.34 — or whether the label should derive against the wash
     instead of riding a pinned step.
     *(§AG, BQ1.1)*

234. **[decide]** The tinted state walk carries no floor.
     `tokens.ColorTokens.StateColor` moves a component whose resting
     fill is a named ramp step by one index for hover and two for press,
     and one index of the light neutral ramp measures 1.21:1 — under the
     floor BQ1.1 placed on the surface walk, and inside the band that
     round measured as "a shade the eye reads as the same surface". The
     two walks answer the same question for two kinds of fill, so either
     the floor belongs on both or the difference wants stating. Not in
     BQ1.1's scope: that task was the ghost wash, and StateColor's
     consumers are the tonal fills BQ1.2 is about to rewrite.
     *(§AG, BQ1.1)*

235. **[decide]** The level fills separate from each other by less than
     the wash now separates from them. Measured by BQ1.1's fresh
     reviewer off a live 1200x800 sitedocs window: light's paper
     #F6F6F6, level-1 #F8F8F8 and level-2 #FBFBFB part at 1.018:1 and
     1.026:1, so the chip specimen whose whole job is to show three
     levels shows one; in dark the backdrop bands part from the paper at
     1.06:1 and the gallery's section headers disappear, while the same
     pairing measures 1.134:1 in light. BQ1.1 put a 1.25:1 floor on the
     state walk taken FROM a level; the levels' own ladder — `SurfaceAt`,
     not `StateAt` — carries no such floor, which is how a hover wash can
     now be more visible than the elevation it stands on. Decide whether
     the elevation ladder owes a separation floor of its own, and whether
     one number serves both schemes given the backdrop's measured step is
     a platform measurement in one and a ramp step in the other.
     SHARPENED 2026-09-02 by BQ1.2's review, which met the same defect
     on the themer's palette page: the "Palette Ramps" and "Palette
     Picks" header bands measure 1.016:1 in light (#f8f8f8 on a
     #f6f6f6 page) and 1.09:1 in dark (#222222 on #181818), and the
     two schemes do not take the same fill for that band — light takes
     the level-1 fill and sits LIGHTER than the page, dark takes
     Surface and sits darker, so one element steps up in one scheme
     and down in the other. That reviewer read the light band as "not
     any named palette colour"; it is the level-1 fill this item
     already measures, which is exactly why it cannot be seen.
     *(§AG, BQ1.1's review)*

246. **[decide]** One chroma dial does not make four equally present
     washes. Every status container is held at OKLCh chroma 0.055, which
     realizes at CIELAB C* 18.3–24.4 in dark and 19.2–21.6 in light:
     warning is the most chromatic wash of the four and info the least,
     so a row that is isoluminant by construction and evenly spaced in
     hue is not even in colourfulness, and warning reads slightly more
     present than its siblings. Measured off the badge and alert
     specimens. Decide whether the dial is the right quantity to hold
     across the set, or whether the washes owe a constant colourfulness
     and the dial should vary with the hue's own gamut.
     *(§AG, BQ1.4's review)*

## Tier 2 — Component and pattern contracts

Rulings that change a published library's shape or grammar, so a
consumer ships the answer whether or not it asked the question.

247. **[decide]** A filled button is the only family whose focus is an
     inset detail rather than an outline, and with the colour removed it
     is the hardest to find. Its ring is inset in its own background, so
     the button's outer 2 px is the fill itself and its silhouette does
     not change when it takes focus; the whole signal is one 2 px band
     two pixels in, measuring 3.15:1 against the fill in light and
     3.22:1 in dark. Every other focusable family answers with an
     outline the surface reads at 6.19:1 (light) to 12.34:1 (dark), so
     the button is between two and four times quieter than its
     neighbours on the same page. The placement is deliberate — a band
     flush with a boundary reads as that boundary — but the consequence
     was never measured against the other placement. Decide whether the
     inset band owes more than the graphic floor, given it is the only
     ink focus has there, or whether a filled button should ring outside
     its own edge like everything else.
     *(§AG, BQ1.5's review)*

248. **[decide]** The focus ring and the ink a control paints when it is
     ON are the same grey: 1.05:1 in light (ring #6f36d1 against the
     checked checkbox's #723ad4 fill) and 1.12:1 in dark (#dad2ff
     against #d0c4ff). Both come off the primary ramp by construction,
     and BQ1.5 moved the light ring one step nearer that fill — 1.48:1
     before, 1.05:1 after — buying the separation from the neutral
     resting border that focus needs more. What tells focus from checked
     today is geometry alone: focus is an unfilled outline standing
     clear of the control, on is a fill. That holds in the specimens and
     it has no margin. Decide whether the ring owes the accent fill a
     measured separation as well, and if it does, which of the two the
     ramp should yield to when a scheme cannot give both — BQ1.5's
     derivation excludes only the byte-identical case, which is the
     least it could do.
     *(§AG, BQ1.5's review)*

243. **[decide]** On a light-scheme Tonal button the focus ring and
     the label are one colour. Both are the accent step chosen against
     the same fill — the ring by `focus.RingOn` at the graphic floor,
     the label by the shared foreground derivation at the text floor —
     and since BQ1.3 put the button on the container fill they land
     byte-identical at #6f36d1 on the default seed. Nothing is
     unreadable and the two are spatially apart (the ring rides in the
     padding, the label is in the middle), but focus is then announced
     in the colour the control was already speaking, and a colour test
     can no longer tell a ring pixel from a glyph pixel — which
     TestFocusRingIsTheSameRingInEveryRegister now has to excuse
     explicitly. Decide whether the ring owes a measured separation
     from the foreground it circles, the way it already owes one from
     the fill. RE-MEASURED 2026-09-02 after BQ1.5 moved the light ring:
     the collision stands at #6f36d1 on levels 0 through 3, and its
     mechanism has changed. It was the walked band `focus.RingOn` takes
     when the scheme's ring cannot read on the tonal fill; the scheme's
     ring is now #6f36d1 itself, so the ring and the label meet as two
     derivations landing on one step rather than as a walk arriving
     where the label already was. Dark does not collide (ring #dad2ff,
     label #d0c4ff). *(§AG, BQ1.3)*

245. **[decide]** An alert carries its bounds and its status in one
     background wash and nothing else. `drawAlert` fills a rounded rect
     and strokes nothing — no border, no outline, no leading rule — and
     by item 67 the glyph is the same in all four. The wash measures
     correctly for a wash, 1.31:1 against the dark page and 1.37:1
     against the light one, but it is everything the alert has, so any
     environment that overrides background colours takes the bound and
     the status with it: Windows forced-colors, macOS Increase Contrast
     and the Linux high-contrast themes all do. A badge survives the
     same override because its label says the status in words; an
     alert's title does not ("Could not save", "Unsaved changes").
     Decide what an alert owes underneath the wash; a hairline in the
     status hue is the cheap answer.
     *(§AG, BQ1.4's review)*

249. **[decide]** A focused link's fill wash contributes nothing once
     the colour is removed: #f2f2f2 over the light scheme's #f6f6f6
     paper is 1.04:1, so in greyscale the wash is not there and the 2 px
     box around the words carries the state alone. The box does carry
     it, so nothing is lost, but the wash is then ornament that only
     some readers get — and by the house's own perceptibility floor
     (1.25:1, the number ContainerFloor and StateFloor both landed on) a
     fill at 1.04:1 is not a fill. Decide whether the link's focus wash
     should clear that floor like every other wash in the system, or be
     dropped so the box is the whole of the treatment.
     *(§AG, BQ1.5's review)*

96. **[decide]** Added 2026-08-29, from AZ2.1's fit check — the first
    real anchor use of `components/chip`. The live `chip.Chip` takes
    its Props by value, once per subscription, so a chip whose LABEL
    is data cannot be built once: mindchat's model picker now derives
    a deduplicated key from the Model and re-subscribes a whole chip
    whenever the label or its chevron changes. The deduplication is
    not optional — the Model emits on every streamed token, and a
    component subscription per token is not a rate anything here was
    built for — and it costs the app a third cold subscription on its
    model stream. `patterns/popover` shows the other shape in the
    same file: its one dynamic prop, Open, is an observable. Whether
    a live component should take its data as observables (or a props
    function) rather than as captured values is the ruling; every
    data-bearing component the system grows will meet it.

    (Confirmed 2026-08-30 by a second consumer: it chose the static
    render register over the live chip.Chip specifically because
    by-value Props resubscribe on model-driven labels. Two of two
    adopters have now worked around the same seam.)
    *(§I, from AZ2.1's fit check — the first real anchor use of components/chip)*

31. **[decide]** No destructive button variant — the modal's "Discard"
    wears the primary colour.
    *(§E, components and patterns)*

30. **[decide]** Ghost controls (the dialog's close X, dismissible tag
    marks) show no resting ground — a reader can't see they're
    clickable or where the target is. Give them hover/resting states?
    *(§E, components and patterns)*

51. **[decide]** The menu's selection carries no secondary cue —
    a full-width inverted row is also the standard hover/cursor
    rendering, so the moment menus gain hover, selection and
    cursor become indistinguishable. Add a checkmark, or reserve
    inversion for the cursor and quiet the selection?
    *(§G, from the dropdown review, 2026-08-21)*

142. **[decide]** Dark mode shows two contradictory error looks one
     scroll apart: alerts as dark tinted plates with white ink, the
     toast as a near-white inverted slab with a red bar. Either
     convention is defensible; both on one screen make "what does an
     error look like" unanswerable. An alert/toast convention ruling
     in patterns.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

139. **[decide]** The ghost register drops the brand entirely: a
     neutral #5C5C5C label with no fill, border or accent, beside its
     filled and tonal siblings, reads as a caption or a disabled item
     rather than the quiet register. Whether ghost's ink is the
     brand's or the neutral ladder's is a components/button register
     ruling.

     NARROWED by BN3.1's button doc repeal (2026-09-02), not closed.
     Selection has left the emphasis axis for the Filter chip, so
     Ghost no longer has to read as the unpicked half of a
     picked/unpicked pair standing beside a Tonal sibling — a reading
     that needed Ghost to be legible AS A STATE and not only as an
     action. What remains to rule is the narrower question the second
     sentence already asks: whether an incidental action's ink is the
     brand's or the neutral ladder's, with the state duty gone from
     both sides of the comparison. Vocabulary note for whoever closes
     it: the variants are Filled, Tonal and Ghost, and "register" is
     no longer the word.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

29. **[decide]** One pill shape serves four jobs (tag, card chip, hero
    eyebrow, pricing badge), rendered identically — and only tags are
    clickable. Split them visually, or accept it?
    *(§E, components and patterns)*

47. **[decide]** The scrollbar speaks at two volumes: the light
    thumb measures 1.47:1 against its ground (a whisper), the dark
    one 4.49:1 — loud enough that in dark it out-shouts the
    selection pill (whose own step from ground is ΔL* 5.8) right
    at the window's edge. Match dark down to light's whisper,
    lift light up, or meet in the middle? One thumb serves every
    app, so this is a components-wide call.
    *(§G, from the aside-edges review, 2026-08-21)*

55. **[feature]** Added 2026-08-24: extract a disclosure-tree pattern.
    Three apps hand-roll the same widget shape — `vaultview/tree.go`
    (634 lines, the vault file tree), `vaultview/outline.go` (the
    aside's heading outline), and `sitedocs/docs_outline.go` (344
    lines, new in AF2.1) — with no shared code; a fourth
    document-shaped app would make a fourth telling. Candidate:
    `patterns/tree` owning rows, disclosure triangles, selection
    geometry, and scroll plumbing, the three call sites becoming thin
    adapters. Real differences to design through: files vs headings,
    selection semantics, vaultview's floating-pane geometry vs the
    Docs rail. Related: ADR-014 S8's Docs-outline truncation item
    (a resize/tooltip story belongs in the shared pattern, not in one
    app).
    *(§H, patterns)*

84. **[feature]** Added 2026-08-24, from AH2.1: the seed is not
    observable from the theme stream — `theme.Theme` publishes only
    Color/Typography, and the palette precedence (OS accent > default)
    is internal, so an app cannot ask which colour its palette came
    from. sitedocs candidate-and-verifies via `FromSeed`, which works
    but cannot recover a brand seed it was never told. Durable fix:
    `theme` publishes its seed — a cross-repo change.
    *(§I, from AH2.1)*

57. **[decide]** The active-tab underline has no chromatic identity:
    byte-identical to Primary content below it in both schemes
    ((114,58,212) light, (208,196,255) dark), so separation rests
    entirely on distance. Two reviewers landed on it independently.
    Reserve exact Primary for one of the two, or give the indicator
    its own shade — a token-level call.
    *(§H, patterns)*

58. **[decide]** Active and inactive tab labels are pixel-identical
    ink — no weight, tint, or ground change; cover the underline and
    the strip carries no state. A `patterns/tabs` question, paired
    with 57.
    *(§H, patterns)*

56. **[decide]** Added 2026-08-24, from AG1.1's review: the tab strip
    draws no bottom rule while every content section band carries one;
    scrolled content in a Surface band slides flush against the strip's
    16 dp gap and the chrome/content boundary disappears (Surface
    cannot separate Surface from Surface). A rule is a new visual
    element and plausibly belongs in `patterns/tabs` — where it moves
    every consumer's goldens — not in one app's shell.
    *(§H, patterns)*

82. **[decide]** The tab strip's labels start at x=13 while every
    other element in the app — section band labels, buttons, field
    labels, alerts, cards, prose — starts at x=24–25, so the nav row
    hangs 11px left of everything below it. A `patterns/tabs`
    question; pairs with 56–59.
    *(§I, introduced or sharpened by AH1.1)*

59. **[decide]** Full-width text tabs with a Material underline are
    not a macOS idiom; a segmented control or source list would be.
    Platform-fidelity call, system-wide (pairs with the Roboto-vs-SF
    item in ADR-014 S8).
    *(§H, patterns)*

97. **[decide]** Added 2026-08-29, from AZ2.1: a chip anchoring a
    popover cannot say that the popover is open. The chip knows rest,
    hover, press and focus, and an anchor is none of those while its
    surface stands — the hand-rolled picker it replaced used its
    hover fill to say so, and that reading is gone. mindchat now says
    it with its own mark instead (the chevron it hands the chip as a
    Glyph flips), which works and is the caller's affordance, not the
    component's. If a chip should carry an expanded/active face of
    its own, that brushes the deliberate no-Emphasis ruling and is an
    owner's call rather than a control's.
    *(§I, from AZ2.1's fit check — the first real anchor use of components/chip)*

93. **[decide]** Added 2026-08-29, from AZ1.2's fresh-eyes review: the
    badge does not read as a badge. Same pill, same radius, same
    hairline, same fill and same height as a resting chip — the only
    difference in the specimen is the missing mark, so the reviewer
    read it as "a chip whose icon failed to load", not as a face that
    takes no input. "One geometry, two faces" is the ruling and this
    is its cost; if the badge should carry a property of its own — a
    weight, a scale, a mark set aside for it — that is a design
    ruling, not a gallery fix.

    (Witnessed 2026-08-30 on a consuming app's real surface: a
    clickable recall chip sits in one modal beside inert participant
    and status badges — same corner, rim and fill weight, nothing but
    the glyph and hover separating live from inert. The consumer holds
    captures in its own harness and recorded the question; this is no
    longer hypothetical.)
    *(§I, from AZ1.2's fresh-eyes review of the gallery's chip section)*

95. **[decide]** Added 2026-08-29, from AZ1.2's fresh-eyes review: the
    chip's trailing mark reads as detached — the gap before it looks
    wider than the pill's own leading padding, because the glyph is
    reserved the label's whole line box while a chevron's ink fills
    perhaps two thirds of it. Both numbers are derived and ruled in
    AZ1.1 (the S2 gap is patterns/tag's, the box is the line's), so
    the question is whether a mark should be reserved its ink extent
    rather than its line box — which would move every control that
    sets a glyph beside text. ONE DATA POINT, from BB3.1: the chip's
    new anchor face reserves its mark's INK EXTENT — the platform's
    own ratio of the control height, 9/29, about 11 dp against the
    20 dp line box — because the pair is the component's own mark and
    its width is therefore known. A fresh reviewer handed that window
    did not raise the detachment at all. That is one face answered by
    construction and says nothing about the general case, where the
    mark is a caller's Glyph whose ink extent the component cannot
    see.
    *(§I, from AZ1.2's fresh-eyes review of the gallery's chip section)*

106. **[decide]** Inline code is drawn as a hollow outlined box — a
     1 px rounded outline with the page's own fill inside it — so a
     code span in a sentence reads as a tiny text field or button, and
     the outline crowds the baseline. The convention everywhere else is
     a filled tint with no border; this is the inverse. SHARPENED by
     BA2.1's review, which sampled the border ink at four places and got
     ONE colour — `#797979` light, `#9E9E9E` dark — under the composer's
     text field, the model picker, an inline code chip and a fenced
     block alike, at 4.10:1 / 5.94:1 against their fill. So the window's
     only text input is outlined exactly like a non-interactive code
     span. The fenced block's own fill measures 1.02:1 against the page,
     which means the fill does nothing and the block exists entirely by
     that heavy border — while the pane's structural outline whispers at
     1.52:1 as the platform draws it. The chrome that defines the window
     is the quietest line in it and a code snippet is the loudest.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

110. **[decide]** The strip takes its controls but not the air between
     them. `Strip` places each control it is handed as a rigid child at
     the trailing corner, so a pane with two figures up there — a
     toggle and a primary action — must pass its own spacer between
     them, and two windows can drift apart on that gap without either
     of them being wrong. Either the pattern owns one gap (and then it
     owes a token to derive it from), or the vocabulary states the gap
     once somewhere both windows read it.
     *(§K, BA1.1's hoist of the floating pane)*

111. **[decide]** The floor fill is named twice. The pattern's
     `Surface` is the pane's fill; vaultview's `chromeSurface` is the
     same resolution — the floor storey — spent on three regions the
     pane knows nothing about (the pane, the flush trailing column, and
     the backdrop the two float on). They agree byte-for-byte because
     both are the floor, so nothing moved; but "the window's furniture
     fill" is a bigger idea than "the pane's fill" and it currently has
     no home above the application. If a second window repeats the
     three-region spend, the floor deserves naming in the theme rather
     than in each frame.
     *(§K, BA1.1's hoist of the floating pane)*

112. **[decide]** When the strip is DRAWN stayed app-side, and it is
     not obvious it should have. vaultview reserves the strip's depth
     in the pane's vertical flex and draws the band last, so that Tab
     out of the find field reaches the rows rather than the pane's own
     dismiss control — a focus-order fact about the pane's CONTENTS,
     which is why the pattern lays out a band and says nothing about
     when. But every pane wearing this pattern has a strip whose one
     control puts the pane away, so every one of them will want the
     same order. Either the pattern grows a reserve-then-draw pair, or
     the convention is written down once as the caller's duty. CONFIRMED
     by BA2.1: mindchat reserved the strip's depth in its pane's flex and
     drew the band last, copying vaultview's order because there was
     nowhere else to read it from. Two windows, one duplicated
     convention, which is what this item said would happen.
     *(§K, BA1.1's hoist of the floating pane)*

113. **[decide]** The recall convention holds the LINE and not the COLUMN,
     and the reviewer read the horizontal move as the same defect the
     phase was called to kill. Measured: the toggle's mark stands at
     x 184–203 while the pane is up (the pane's own trailing corner) and
     at x 95–114 once it is gone (the chrome row's leading end) — 89 px
     left, with the new-chat mark moving the same 89 and the title moving
     94. Vertically nothing moves at all, which is what the phase ruled
     and what BA2.1 measured: both marks occupy y 18–33 in both states
     and both schemes. So the rung defect is gone and a horizontal one is
     what a reviewer sees instead — click the toggle twice in one place
     and the second click lands on nothing. This is not mindchat's
     arrangement to change: it is the vocabulary's, vaultview wears it
     too, and the alternative (the recalling half standing where the
     dismissing half stood) puts a control in the middle of a window's
     top strip with nothing under it. An owner's call on whether the
     convention should pin the column as well as the line.
     *(§L, BA2.1's fresh-eyes review of the rebuilt MindChat window)*

114. **[decide]** The pane's outline cuts the window's top strip in two.
     The card's own hairline runs at y 8 from x 8 to x 247 — across the
     strip, eleven pixels above the control buttons — and then simply
     stops, with the rest of the strip bare window ground. The reviewer
     called the title bar "visually split into two different surfaces",
     and it is: on the leading side the strip is the top of an object,
     on the trailing side it is the window itself. That is what a
     floating pane under a full-size-content treatment necessarily looks
     like, so it is `patterns/pane`'s question rather than this window's,
     and vaultview has it too. Either the strip is allowed to read as two
     surfaces (it is, arguably, telling the truth) or the pattern owes
     the top of the pane something the platform does — which is worth
     measuring before it is designed.
     *(§L, BA2.1's fresh-eyes review of the rebuilt MindChat window)*

116. **[decide]** Nothing in any of the four frames says what has focus.
     The reviewer looked for a focus ring at launch and found none, which
     means a keyboard reader has no way to tell where Tab will go from.
     Every control in the window is one the components carry rings for,
     so this is about what the window focuses when it opens rather than
     about any control's ring — and the answer is presently nothing.
     *(§L, BA2.1's fresh-eyes review of the rebuilt MindChat window)*

229. **[decide]** At Compact density the input chip's avatar, capped
     to the body's inner height (22 in a 24 chip), now sits in a
     uniform 1 px well on all four sides, its round edge abutting the
     outline's inner boundary. The tightness pre-existed vertically;
     the cap-band round made it uniform. Whether Compact wants a
     smaller avatar or accepts the abutment is a number to rule; the
     gallery renders Comfortable only, so no reviewer has seen it.
     *(§AG, BN3.2)*

236. **[decide]** The Ghost variant reads as unstyled text at rest. The
     same reviewer, told nothing: it fills a full 120x36 slot beside two
     boxed siblings with no fill, no border and no outline, and its
     label is neutral 700 — lighter than the Filled and Tonal labels
     beside it — so it reads as a caption someone forgot to style rather
     than as a control. Painting nothing at rest is the variant's
     definition and BQ1.1 deliberately did not touch it; what is open is
     whether the least pronounced variant owes any resting affordance at
     all when it stands in a row of boxed ones, and whether its resting
     label should be the lightest of the three.
     SHARPENED 2026-09-02 by BQ1.3's review, which sampled the same row
     after the Tonal collapse: Ghost's label is zero chroma in both
     schemes (light #5c5c5c, dark #cccccc) and the light one is
     BYTE-IDENTICAL to the Neutral badge's label, while Filled and Tonal
     now both carry the accent hue. So the question has a second half —
     whether the third emphasis step may drop the brand hue its two
     neighbours carry, or whether a ghost's label owes the accent at the
     lowest strength that reads.
     *(§AG, BQ1.1's review)*

252. **[decide]** The three-column frame draws a divider only between
     the content and the aside; nothing separates the sidebar from the
     content, and neither seam offers a drag affordance or a collapse.
     With chrome and content now standing at different levels the
     missing leading divider is what a reviewer reads first. A Seam
     finding under the Language, not taste.
     *(§AH, BR1.1's review)*

253. **[bug]** The three-column frame's footer strip is not yet a
     status bar in the Language's sense: it has its own chrome fill
     since BR1.1 but no hairline above it, and its label sits 11 px
     from the top of a 48 px strip rather than centred in it. The
     missing hairline is a Seam finding under the Language.
     *(§AH, BR1.1's review)*

254. **[bug]** The navbar's foot has no hairline. Now that the content
     region beneath it is a lighter fill, the seam reads as a colour
     step across the middle third and as nothing at all where the
     sidebar and aside continue the chrome fill below it; the light
     scheme's derived hairlines are what carry that edge everywhere
     else. A Seam finding under the Language.
     *(§AH, BR1.1's review)*

259. **[decide]** The card specimen's footer badge measures 4.51:1 in
     light, on the small-text floor, and in dark reads as the disabled
     idiom (204 on 71, against 238 for every other label). A badge and
     gallery question: whether a badge on a raised surface owes a
     stronger foreground than the same badge on the content.
     *(§AI, BR1.2's review)*

## Tier 3 — Window and page composition

Rulings scoped to one window, page or app surface. Visible, but the
blast radius stops at the surface that raised them.

137. **[decide]** The themer spends 400 of 820 px on the step that is
     already finished: title, drop card, seed row and strip never
     scroll and never change, leaving a 425 px viewport on content the
     reviewer sized at ~1260–5600 px per tab (Patterns is thirteen
     screenfuls through a slot half the window tall). The proposed
     collapse of the seed row after a pick roughly doubles the preview
     but is a new behaviour with its own question — how the other
     candidates come back — not a tidy-up.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

102. **[decide]** The user's turn is a full-bleed banner rather than a
     message: square corners, no avatar, running from the sidebar
     divider (zero left gutter) to a 15 px right gutter, with its text
     starting at the same x as the assistant's body. It reads as a
     section header or a selected row spanning the pane. The assistant's
     turn, meanwhile, gets an avatar and no surface at all. The two
     speakers look like two unrelated components.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

104. **[decide]** The model menu reads as pasted on rather than
     floating: a flat 2 px `#C6C6C6` border with the underlying content
     unmodified immediately outside it — no shadow, no blur, no
     vibrancy — and its right edge lands 2 px from the window edge at
     the DEFAULT window size, so the anchoring has already run out of
     room. Rows are spaced far looser than this platform's menus and
     the current pick is marked with a purple bullet where a checkmark
     is the convention.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

107. **[decide]** PARTLY FIXED in BA2.1 — the CONVERSATIONS label was
     one of the four roles and it retired with the header it stood in,
     so the ink now covers three. The rest stands. The sidebar spends
     one ink on four roles: the
     "CONVERSATIONS" group label, the unselected conversation titles,
     the "Settings" footer and the composer's placeholder are all the
     same grey (`#5C5C5C` on paper, `#CCCCCC` on slate). The clickable
     list items are therefore set at exactly the weight of the label
     above them and the placeholder below them; nothing in the ink says
     which of the four is content.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

108. **[decide]** PARTLY FIXED in BA2.1 — the two stacked headers are
     gone: the wordmark row and the CONVERSATIONS row both retired, and
     the pane now carries one strip and nothing else above its list. The
     welding is not fixed: the transcript still begins immediately under
     the chrome row (the row's own hairline went with the header band,
     but the first message band still butts against it), and the avatar
     question is untouched. Original finding: two stacked headers in the
     left column — the window's
     own title row and the "CONVERSATIONS" row under it, two header
     bars in the first 100 px — and none at all on the right: the
     toolbar divider is at y 51 and the first message band starts at
     y 52, so the transcript is welded to the chrome and its first
     message reads as part of the toolbar. Also: the assistant avatar
     is a third party's mark recoloured to this app's accent, which is
     a trademark question before it is a design one.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

109. **[decide]** The composer is a bare one-line box: no send control,
     no attachment control, nothing but a placeholder set in the same
     grey as the sidebar's chrome.
     *(§J, AZ2.1's fresh-eyes review of the MindChat window)*

115. **[decide]** Two hairlines two pixels apart across the seam at the
     window's foot: the pane's own foot rule at y 713 (x 20–235, inside
     the pane) and the transcript's rule above the composer at y 711
     (x 260–1011). They do not touch — the pane's edge is between them —
     but they are near enough to read as one line that failed to meet
     itself, and the bands under them are staggered too (the pane's foot
     begins at y 714, the composer at y 720; both bottom out correctly at
     y 759). This is the rail's old complaint in a new form: a bottom
     rhythm on one side of the window that the other side answers at a
     different height. The cheap fixes both cost something real — dropping
     the pane's foot rule diverges from vaultview, and coupling the two
     heights ties two columns that are otherwise independent — so it is
     recorded rather than patched.
     *(§L, BA2.1's fresh-eyes review of the rebuilt MindChat window)*

123. **[decide]** The window's head ends at two different heights, and
     two accent blocks stair-step across the seam. The sidebar's
     toolbar bottoms out at y 43 and the content pane's at y 51,
     although both hold the same-size controls (the window buttons at
     y 19–32, the picker at y 8–43). The first thing in the window is
     therefore two purple blocks one pixel apart across the divider at
     x 247 — the sidebar's selected row at y 44–85 and the first
     message band at y 52–99 — whose tops disagree by 8 px and whose
     bottoms disagree by 14 px. Item 108 has the transcript welded to
     the chrome and item 115 has the window's FOOT answering itself at
     two heights; neither has the head doing it, which is the
     measurement under this one. Likely a `patterns/pane` question
     rather than this window's, since the strip's depth on the leading
     side is the pane's and on the trailing side is the frame's.
     *(§M, BB3.1's fresh-eyes review of the picker in its anchor face)*

20. **[decide]** Resizable sidebar: investigation says yes — ~190
    lines mirroring the existing note/aside divider drag, plus a
    minimum width for the note column (it currently has none). Go?
    *(§C, vaultview)*

22. **[decide]** The two side panels are built differently: left is an
    inset rounded card, right is a full-bleed slab. Pick one
    construction.
    *(§C, vaultview)*

35. **[decide]** Launcher cards: 54px of empty space at the bottom of
    every card (all three reviewers led with this), the button covers
    7% of a card that looks clickable, and running/starting state
    exists in the model but the card shows nothing until it changes.
    *(§E, components and patterns)*

135. **[decide]** The section bands are inset 25px on the leading
     edge and 0 on the trailing edge — full bleed that reads as
     clipped on this platform — while the content column they frame
     leaves 32–52% of a 1280-wide window empty. Whether the bands get
     a symmetric inset, the column breathes with the window, or both,
     is a gallery-page composition call.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

143. **[decide]** The candidate card's clickable swatch is not the
     colour the theme derives (#829F5E clicked → #72A500 produced;
     #88B2C1 → #00BAE5). The Aa bar under it does show the derived
     colour, so it is disclosed — but the element that dominates the
     card is the one that does not survive the pick. Themer card
     design.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

141. **[decide]** The syntax-base selector is a 205 px pane with its
     own scrollbar inside the page's scroller — two nested 6 px bars
     800 px apart, wheel position deciding which moves — showing 8 of
     42 bases with no filter field. Predates the tabs; the Markdown
     tab is merely where it now lives.
     *(§P, BE2.1's fresh-eyes review of the tabbed themer window)*

136. **[decide]** Two platform-fit complaints a Mac developer files
     first: the type ladder's visible labels say "57sp/45sp/…" —
     Android's unit, Material 3's exact scale — where this platform
     specifies points; and the theme control is a hard two-position
     sun/moon switch with no Auto/System position, where macOS apps
     are expected to follow the system appearance and its scheduled
     flip.
     *(§O, BD1.2's fresh-eyes review of the gallery window)*

75. **[decide]** No search, no anchors, and dead cross-references: the
    tab strip is empty from x≈400 to 1200 while the guide runs to ~20
    sections and many screens, and the body's "(§Nested modules)"
    style references render in plain body ink — not links, not
    coloured, not underlined — while the Markdown tab proves the app
    can draw real links.
    *(§I, AH1.1's five-tab review — docs tab)*

76. **[decide]** The sidebar is a fixed 300px that ellipsises three
    labels exactly where the informative part starts, while the
    reading pane leaves ~240px of the window empty. Pairs with 55
    (a shared tree pattern is where a resize story belongs).
    *(§I, AH1.1's five-tab review — docs tab)*

78. **[decide]** The outline tree signals depth with a 13px indent and
    one pixel of cap height at identical ink, and childless top-level
    rows carry no chevron — so parents, children and leaves all read
    at the same weight and the tree's shape is unreadable.
    *(§I, AH1.1's five-tab review — docs tab)*

239. **[decide]** The board whose stated job is showing where each
     colour came from prints no measured contrast anywhere. Every
     pick cell says "measured over X" and none gives the ratio it
     achieved, which is the one number a developer has to sign off.
     The highlight cell, which prints its measured hue separation, is
     the only cell on the board that prints a number at all. The cost
     is not theoretical: BQ1.2's reviewer measured the highlight wash
     at 1.21:1 light and 1.17:1 dark against the theme's Surface under
     a rule claiming a 1.25 floor, an ambiguity that task then settled
     in the wording — and it could only be found by sampling the page.
     Whether the cells carry their ratios, and what a cell whose pick
     clears the floor against one surface and not another should
     print, is a board-content ruling.
     *(§AG, BQ1.2's review)*

72. **[decide]** The ramp grid is drawn in a 2px line of the
    full-strength Text colour — the same ink weight as body copy — so
    the lattice out-shouts the colours it exists to show. It is also
    asymmetric: rows are separated by ~6px of chrome, columns by 2px.
    Swatches are 20px by ~111px letterboxes in a section with 500px of
    vertical room to spare, which makes cross-row hue comparison hard.
    SHARPENED 2026-09-02 by BQ1.2's review, with the weights counted:
    the rules measure 14.7:1 against the light page while every other
    rule on the same page — the Palette Picks underlines — is the
    Divider at 1.37:1, and one grid carries three weights (vertical
    2px, horizontal 1px doubled with a 2px gap, outer frame 1px). The
    ink is not an accident: this board draws its frame in the inverse
    surface deliberately, so what is open is the weight and the count,
    not whether the frame should have been a divider.
    *(§I, AH1.1's five-tab review — palette presentation)*

73. **[decide]** The Palette Picks board is unbalanced: the left and
    middle columns run to y≈855, the right ends at y≈445. In dark the
    right column ("Ink ends") holds exactly two swatches, both
    annotated "no ink here" — a section whose whole content is two
    colours it says are unused. Separately, the pick chips carry three
    different contents (an "Aa", a nested square, or nothing) with no
    key anywhere in the UI. SHARPENED 2026-09-02 by BQ1.2's review,
    which met the board at 1400x1120 and priced the imbalance:
    content bottoms out at y=950 left, y=850 middle and y=443 right,
    leaving a 169 px blank full-width tail under the page and roughly
    470x670 px empty under the right column — about a third of the
    page. Three columns because three families exist, not because the
    content balances. The dark "Ink ends" column re-verified at 3x:
    both entries still read "no ink here", because in dark the
    on-colours come from each role's own 100 and White and Black are
    unused.
    *(§I, AH1.1's five-tab review — palette presentation)*

43. **[decide]** In dark scheme the seed-candidate chips at the top
    of the window carry theme token values in the same chip-plus-Aa
    vocabulary as a palette pick cell (the blue chip is exactly dark
    Primary 700, the red Error 700, the grey Neutral 700) — the same
    visual sentence twice, ~250px apart. Removing the chips would
    gut the candidate row's promise of "what choosing this
    delivers", so: accept the echo, or restyle one of the two?
    *(§C, from the palette-display review (belongs with the themer))*

44. **[decide]** The picks board flows its four families in fixed
    order at every width, which keeps a family's neighbours stable
    but leaves narrow packing unbalanced (columns 482 vs 276).
    Free assignment (Page+Accents | Inverse+Status) measures
    392/366 — 90pt shorter and balanced — at the cost of the fixed
    order. Keep order, or pack better?
    *(§C, from the palette-display review (belongs with the themer))*

48. **[decide]** The ramps' base chip keeps the pick swatch's 44dp
    width while the cells grow to 132dp on wide windows —
    deliberate (one colour, one size, both sections) but the
    row's rhythm falls off a cliff at its end at 1440+. Let the
    chip take a share of the growth, or keep the one-size rule?
    *(§G, from the palette edges review, 2026-08-21)*

49. **[decide]** The ramps caption drops its last clause first —
    the one explaining the base column and Neutral's em dash,
    which stay on screen at narrow widths — while keeping "nine
    steps a role", which repeats what the headers already show.
    The drop order is ruled and recorded; re-rule it?
    *(§G, from the palette edges review, 2026-08-21)*

240. **[decide]** The ramps' base column is a copy of step 700 and its
     legend misnames it. Measured across all seven roles: dark base
     equals step 700 at ΔE 0.00, light at ΔE 0.00 for the four
     statuses and 1.1–1.4 for the three accents — invisible either
     way. The legend calls it "its role's pinned base", which reads as
     the seed, but light Primary base is #0050d0 and dark Primary base
     is #b0cdff, and the seed lands at no step of the dark ramp at all
     (it would fall between dark 400 #003ea6 and dark 500 #1463ed). So
     a tenth swatch a row carries no information and names something
     it does not show. Either the column shows the seed, or it goes,
     or the legend says step 700; pairs with item 48 (the base chip's
     width) and item 49 (the caption clause that explains the
     column).
     *(§AG, BQ1.2's review)*

54. **[decide]** Light Secondary/Tertiary say "pinned just off …
    700" while their dot sits on 700 — both true (the pins differ
    by 2–3/255, invisible; the dot marks where a pick lives), but
    read together one seems to lie. Drop "just off" on snapped
    rows, or keep the byte-level honesty? Also: the light Neutral
    em dash renders at 2.45:1 (thin-glyph coverage, not the
    token) while carrying "pins none" — worth a heavier dash?
    *(§G, from the chip-dot review, 2026-08-22)*

86. **[decide]** The dark matched cell is named
    `Lifted seed the light scheme pins` — honest, in the picks board's
    cross-scheme vocabulary, and it buys the disclosure ~150px of
    survival, but it reads as a run-on over a swatch. Owner's eye on
    the dark Theme golden.
    *(§I, the Theme tab's seed row, from AH2.2)*

87. **[decide]** The seed cells borrow the paired-cell grammar and
    misuse it: the ink slot every other paired cell paints stays
    empty, and a hex value sits in a rule line (the only hex on the
    tab). Separately the seed body is ~97% ground and costs 196px
    before the ramps band, pushing the picks body to y=510. A
    purpose-built seed cell shape would settle both; the size channel
    (the smaller pick swatch, 4dp handed inset) should survive any
    restyle.
    *(§I, the Theme tab's seed row, from AH2.2)*

23. **[feature]** No search, filter, or jump-to-letter in the 77-style
    grid. Every reviewer files this first.
    *(§D, themer)*

26. **[decide]** The sun/moon toggle silently changes *which styles
    are listed* (35 light vs 42 dark), not just the appearance.
    Should the polarity filter be its own visible control?
    *(§D, themer)*

27. **[decide]** The drop zone takes a quarter of the window to say
    drops work anywhere; there's no Browse button or paste path.
    *(§D, themer)*

28. **[feature]** Nothing is copyable: no hex values, no token names,
    no ramp indices, and "Keep this theme" never says where it
    writes.
    *(§D, themer)*

24. **[decide]** The card tag words (`faint`, `either`, `added`) have
    no legend anywhere. Add one?
    *(§D, themer)*

25. **[decide]** Each card shows the seed twice in two different
    colours: the swatch strip shows the raw seed, the "Aa" chip shows
    the derived fill. Reconcile or label?
    *(§D, themer)*

148. **[decide]** The palette heading's caption is set in the title's
     full-strength ink while every other hint in the themer is muted —
     a 70-character helper line competing with the heading beside it.
     Deliberate today: the caption is the grid dot's only legend, and
     muted ink reads faint in one scheme; if the hint-ink ladder
     changes it should change for all three heading bands at once, not
     per band. *(§Q, BF1.1's Palette Seed review)*

255. **[decide]** The three-column frame specimen frames a window
     with square corners, and its sidebar selection is a full-bleed
     square band running into the frame's leading edge at zero
     radius. Both read as a page rather than a window on this
     platform; whether the frame should imply a window's rounded
     corners at all, and what inset and radius the selection takes,
     are one ruling. *(§AH, BR1.1's review)*

## Tier 4 — Copy, documentation, release and process

Wording, guide prose, gates and the release ledger — real work, but
nothing downstream waits on the ruling.

41. **[decide]** Updated 2026-08-21: the wave ran (theme v0.8.0,
    markdown v0.5.1, patterns v0.8.0, components v0.9.3, gallery
    v0.8.1 — each tag on its repo's head; vaultview and themer
    re-pinned and building without the workspace). Three pieces
    remain, rule on each:
    - effects: its head is 10 commits past the released v0.2.0, so
      the published effects predates the status-colour rework.
    - the workbench root (launcher) go.mod still pins the old stack
      — theme v0.6.0, patterns v0.6.0, components v0.9.1, mvu
      v0.5.0 — so a launcher run from a release renders months-old
      chrome next to up-to-date apps. Needs a pin bump.
    - workbench has no tags: `go run …@latest` works for the
      launcher and both apps today but returns pseudo-versions
      until the root tag and per-app tags are cut.
    *(§G, release)*

118. **[decide]** Added 2026-08-29, from BA3.1: `design/go.mod` pins
     `patterns v1.0.1` — two rounds stale before that task started.
     The module is untagged and green in the 40/40 sweep, so nothing
     is broken; the ruling is whether design tracks the current
     family each release round or only when its own content moves.
     *(§L, from BA3.1)*

119. **[feature]** Added 2026-08-29, from BA3.1: `llms.txt` has no
     prose teaching menu declaration — the `mvu/desktop` menu API
     shipped with a roster line only. An app built from the guide
     alone cannot discover that its window's actions belong in the
     application menu, or how to put them there (`NewMenuBar` over
     `MenuItem`s, choices on `Messages`, chords as the in-window
     fallback).
     *(§L, from BA3.1)*

36. **[feature]** Inventory completeness gate: a cheap test that fails
    when a new component or pattern ships without a gallery section.
    Currently coverage is complete but only by hand.
    *(§E, components and patterns)*

85. **[feature]** Added 2026-08-24, from AH2.2's review: the seed
    row's truncation guards are width-only — room is measured in dp,
    text in sp, so a raised OS text scale cuts rules at wider windows
    than the tests assert (at 130% the dark rule cuts at ~560px). The
    no-seam invariant holds at every scale — every cut stays marked —
    so this is comfort, not honesty. A scale-swept truncation test is
    the fix. Related fragility: `SeedKeptRuleDark` clears the 560px
    budget with ~6% headroom, and that path is never photographed.
    *(§I, from AH2.2's review)*

37. **[feature]** Gallery depth: most components show one state;
    nothing shows empty/loading/error, wrapping, long text, or
    density. Big effort, worth scoping separately.
    *(§E, components and patterns)*

83. **[decide]** Two leftovers of the group-per-tab cut. The Markdown
    tab's strip cell reads "Markdown" and its single section band
    reads "Markdown — headings, links, chips…", separated by the
    shell's 16 dp of blank ground: dropping the group banner removed
    one repetition and left a quieter one at section level. And each
    group tab still closes with the inventory's own PageEnd row,
    which says "End of the inventory — N sections in the current
    theme" on a tab showing one group of four. Both are the
    inventory's words, so neither can be fixed in sitedocs without
    either editing the inventory (out of bounds for AH1.1) or
    restating its copy locally.
    *(§I, introduced or sharpened by AH1.1)*

80. **[decide]** The type scale names 16 roles across 9 distinct
    sizes: seven roles sit at 14 or 16sp, and the specimen renders
    them as visually identical lines of the same words — the opposite
    of what a specimen is for.
    *(§I, AH1.1's five-tab review — wording and scale)*

81. **[decide]** Section band captions read as compressed notes rather
    than UI copy: "Tag — filled, tonal and the three status levels,
    two of the five carrying the close mark every treatment can take"
    is a 24-word comma-spliced sentence used as a header, and
    "List — a virtual list with its scrollbar in the gutter" exposes
    an implementation detail as a heading.
    *(§I, AH1.1's five-tab review — wording and scale)*

38. **[decide]** Title rows say the app name ("Themer"); the platform
    convention (the stored captures) is the document/content name.
    *(§F, copy and identity)*

39. **[decide]** The "Vibrant Gio" wordmark is the quietest text in
    its own bar, and the launcher's VIBRANTGIO badge is set too small
    to rasterize cleanly at 9px.
    *(§F, copy and identity)*

## Review provenance

The section headers the items above arrived under, with their preambles
verbatim. Kept because the preambles carry context no single item
repeats — what a reviewer was handed, what was already fixed, and which
findings were misreads.

### A. Colour generation

Items 1–9 share one root cause: light and dark are generated by
different rules. One phase could cover all of them.

### B. Plain bugs, no design choice needed

### C. Vaultview

Added 2026-08-21 (numbered past the end so nothing above shifts):

From the palette-display review (these belong with group D, the
themer):

From the warning-orange review (2026-08-21; the bend itself landed
and passed — deep warning reads orange, never mistakable for
error on any fill or mark):

### D. Themer

### E. Components and patterns

### F. Copy and identity

### G. Release

From the aside-edges review (2026-08-21):

From the palette edges review (2026-08-21):

From the dropdown review (2026-08-21):

From the properties-panel review (2026-08-21; the panel itself is
now bounded, quiet, ranked and 14px shorter):

From the base-list review (2026-08-21):

From the chip-dot review (2026-08-22):

### H. Patterns

### I. From AH1.1's five-tab review

Subsections: Contrast and state; Elevation and marks; Markdown;
Palette presentation (the themer's copied section); Docs tab; Wording
and scale; Introduced or sharpened by AH1.1.

Added 2026-08-24. One fresh-eyes pass over all five sitedocs tabs in
both schemes returned 26 items; the reviewer pixel-measured every
colour and size claim. Two were fixed in AH1.1 itself (the Theme tab's
type band now matches its neighbours; the launcher blurb cut to two
lines). Four were already recorded and are not repeated here:
left-hugging layout and `sp` units and opposite-direction ramps
(ADR-014 S8), and the strip's missing bottom rule (56). The rest are
below. Most are owned by `components`, `patterns`, `theme` or
`markdown` rather than by sitedocs, which is only where they became
visible.

### J. From AZ2.1's fresh-eyes review of the MindChat window

Added 2026-08-29. The reviewer was handed the whole window in both
schemes plus the picker's menu open, and pixel-measured every colour
and metric claim. It raised NOTHING about the chip the task had just
put there — the complaints are all about the composition around it, and
most of them are older than this phase. Its first item was the dark ink
bloom already carried as 89 and is not repeated. The rest are below;
they belong to mindchat, `patterns/popover`, `components/scrollbar` and
`markdown` rather than to the chip.

BA2.1 rebuilt this window's composition on the floating pane and closed
some of them on the way; each is marked **FIXED in BA2.1** below rather
than recorded again under a new number.

### K. From BA1.1's hoist of the floating pane

Added 2026-08-29. `patterns/pane` was cut out of vaultview's frame and
vaultview converted to it in the same task, every golden byte-identical.
Four details did NOT hoist, three of them deliberately. They are recorded
because the second consumer will meet all four and should not re-decide
them one window at a time.

The one that is simply a window fact and needs no ruling: where the
platform's control buttons END is a measurement of a live window, and a
headless render has none — so the strip takes that number as a parameter
rather than deriving it, exactly as vaultview already had to pin it for
its goldens. Nothing to settle there.

### L. From BA2.1's fresh-eyes review of the rebuilt MindChat window

Added 2026-08-29. The reviewer was handed the whole window at its opening
size in both schemes AND both pane states — four frames — and pixel-sampled
every claim. Most of what it found was already pooled and is sharpened
above rather than repeated; two of its eleven items were misreads worth
briefing into the next review packet (the window control buttons in a
headless capture are the HARNESS's flat stand-ins, not the application's,
and "the pane is flush on its trailing side" describes the floating pane
exactly as ruled). The four below are new. The verbatim reply and the full
triage are in `reviews/ba2.1-mindchat-fresh-eyes.md`.

### M. From BB3.1's fresh-eyes review of the picker in its anchor face

Added 2026-08-30. The reviewer was handed the whole window at its opening
size in both schemes, briefed with three recorded misreads, and sampled
every claim. Four of its six findings were already pooled and are
sharpened above rather than repeated; the two below are new. The verbatim
reply and the full triage are in `reviews/bb3.1-mindchat-fresh-eyes.md`.

### N. From BD1.1's fresh-eyes review of the gallery window

Added 2026-08-30. The reviewer was handed four whole-window gallery
captures — the two sections BD1.1 added, both schemes — briefed on the
1x dark-ink misread, and asked one question. One of its findings (the
icon button's fill diverging between schemes) was disproved by pixel
probe and recorded as a misread rather than pooled; the verbatim reply
and the triage are in `reviews/bd1.1-gallery-fresh-eyes.md`.

### O. From BD1.2's fresh-eyes review of the gallery window

Added 2026-08-30, after the rail fix. The reviewer probed every claim
against the pixels and was verified against its own transcript; the
verbatim reply and the triage are in
`reviews/bd1.2-gallery-fresh-eyes.md`. Its chrome-darker-than-content
headline is the recorded ADR-022 linchpin, not pooled; the six items
below are what survives. Correction to item 128, from the same
review's probes and BD1.2's fix: the rail always filled the window
height — the defect was unselected nav entries painting an opaque
Background band over the floor, the block below the last entry was
darker (floor) rather than lighter, and the patterns page behaved
identically to the components page.

### P. From BE2.1's fresh-eyes review of the tabbed themer window

Added 2026-08-30. Six captures, one per tab per scheme plus the code
specimen, every claim pixel-probed by the reviewer; the verbatim reply
is in `reviews/be2.1-themer-fresh-eyes.md`. Only the first item is
about the layout this round built; the rest are what the tabs made
easier to see.

### Q. From BF1.1's fresh-eyes review of the Palette Seed row

Added 2026-08-30. The themer's Theme tab at its real 1040×820 in both
schemes, every claim probed with PIL/numpy; the verbatim reply and
triage are in `reviews/bf1.1-themer-seed-fresh-eyes.md`. One copy
regression was fixed in the task; the panel-clipping claim was a
misread of the window margin; the two-swatch size channel was
confirmed working untold. Items 144–148.

## R. From BI2.1's fresh-eyes review of mindchat on the picker

Added 2026-08-30. Verbatim reply and triage summarized in
`reviews/bi2.1-mindchat-fresh-eyes.md`; every claim was re-measured
by the worker. Finding 8 (traffic lights) was the harness — now the
sixth recorded misread. Items 150–159.

151. **[decide]** patterns/popover: the surface clips at the window
     edge (documented no-reflow — the header menu loses a whole side
     of chrome at 1040 wide), and its tail centres on the anchor's
     REPORTED box, which under PinTrailing is the full offered width
     — the arrow aims 38 px off the drawn control and floats 2 px
     above it. The Pin/popover seam wants one contract.
     *(§R, BI2.1's review)*

153. **[bug]** mindchat's settings footer draws Cancel and Save
     pixel-identical — two filled primary buttons, no register
     separating the dismissing action from the committing one and no
     default-button indication. The button's Tonal register exists
     for exactly this. *(§R, BI2.1's review)*

154. **[decide]** The header anchor shows the resolved model while
     the menu highlights the Default row that resolves to it, and
     the flat list lost the caption that separated Default from the
     concrete models — the same id now appears to be listed twice.
     anchorKeyOf's split is documented; the caption loss is BI2.1's.
     *(§R, BI2.1's review)*

155. **[bug]** mindchat's toolbar has no seam: its fill is exactly
     the content fill with no hairline, while the sidebar gets a
     proper one — content slides under the title with no boundary.
     *(§R, BI2.1's review)*

156. **[decide]** The user-message band is the one element ignoring
     the 8 px gutter — flush against the sidebar seam, ~10 px on the
     trailing side — reading as full-bleed section headings rather
     than messages. *(§R, BI2.1's review)*

157. **[decide]** The focus ring's purple is not the accent's
     (#8C59F4 vs #723AD4 side by side in one dialog) and the accent
     hue drifts 252°→268° across the ramp. Same derivation
     neighbourhood as items 146/147. *(§R, BI2.1's review)*

158. **[bug]** The scrollbar barely re-themes: thumb #8E8E8E light /
     #878787 dark while the ground swings 222 values — effectively
     one hardcoded grey, weakest exactly in light. components/
     scrollbar derivation. *(§R, BI2.1's review)*

159. **[decide]** Minors bundle from the same review: placeholder
     ink identical to secondary-label ink (an empty URL field reads
     filled); the provider-name row has no affordance or selected
     state; the DEFAULT MODEL label is styled as a section header
     and its control aligns with nothing; scrim alpha differs 27%
     light / 42% dark. *(§R, BI2.1's review)*

## S. From BI2.5's placement work

Added 2026-08-30. Three engineering smells surfaced while fixing the
popover clamp and tail; recorded by the worker, none blocking.

160. **[decide]** `Pin` — now `chip.Pin` and `picker.Pin`, the package
     it was named for having gone with the chip re-anatomy — has no
     production caller since the popover grew Align: public,
     documented, tested, dead. Whether dead public API retires (a
     contract change, minor) is a release-shape ruling; the
     re-anatomy has since collapsed the two Pin types down to these
     two packages, so nothing waits on it any more.
     *(§S, BI2.5; package name corrected 2026-09-02)*

161. **[decide]** `patterns/popover` measures its Content at half the
     canvas in both axes; now that the canvas means "the room", both
     real consumers override their incoming constraints to escape the
     rule and say so in comments. The measuring rule wants restating
     against the new canvas contract. *(§S, BI2.5)*

162. **[bug]** `patterns/tooltip` draws its own tail and was not
     remeasured: whether it shares the floating-tip and
     border-through-base seams the popover just fixed is unknown —
     measure once, fix if found, one tail grammar for both patterns.
     *(§S, BI2.5)*

## T. From the org-wide comment cleanup (comments session)

Added 2026-08-30. String literals surfaced during the comments-only
sweep, out of its scope by definition; parked here for ruling.

164. **[bug]** a residue of in-org consumer naming survives in
     support-library prose across effects, components and patterns —
     the no-consumer-mentions rule extended to all support-library
     text on 2026-08-18. *(§T)*

165. **[decide]** `markdown/internal/lint/nogofont_test.go:78` emits
     "ADR-003 violation" in test output. Test output is not a
     published artifact; whether the no-jargon rule reaches it is a
     ruling. *(§T)*

166. **[decide]** sitedocs test fixtures carry task/ADR IDs as
     strings (`guide_test.go:328` "AF1.1", `shell_test.go:80`
     "ADR-021 R2") — same reach question as 165. *(§T)*

## U. From BL1.1's fresh-eyes review of the gallery window

Added 2026-08-31; full verbatim reply in
`reviews/bl1.1-gallery-fresh-eyes.md`. Two of its findings — the
dark press walk blowing out on raised storeys and light mode showing
no elevation at all — are the strongest independent confirmation yet
of items 144/145 (Phase BJ's premise) and are recorded there, not
renumbered here. The anchor cell's 36px/chevron geometry was
rebutted as the picker's documented two-register split.

167. **[bug]** The light scheme's secondary/caption ink fails the
     4.5:1 text floor window-wide: every field caption peaks at
     #7A7A7A–#7F7F7F on #F6F6F6 — 3.97:1 at best — while the same
     token in dark measures 8.66:1. One token in theme/tokens, every
     caption in every app. *(§U, BL1.1's review)*

168. **[bug]** The picker menu's selected row is the least legible
     row in the menu: 4.58:1 (dark, #474747 on #BDAAFF) and 4.53:1
     (light) sitting AT the floor while unselected neighbours read
     8.01:1 / 18.58:1 — the current selection visibly recedes. The
     persistent-state accent voice needs headroom above the floor,
     not exactly the floor. *(§U, BL1.1's review)*

169. **[decide]** Disabled controls out-shout enabled ones and stop
     reading as the same component: light disabled field is a
     borderless #E1E1E1 slab — the loudest box in its row — with
     1.44:1 placeholder ink (dark: 2.38:1 fill, 2.40:1 text).
     Disabled is contrast-exempt, but the platform keeps disabled
     controls readable; how quiet is quiet is an owner call. *(§U,
     BL1.1's review)*

170. **[decide]** The picker's open menu is a square-cornered,
     shadowless rectangle that reserves layout space below a rounded
     field; native menus are rounded, shadowed overlays. Whether the
     inline menu adopts the overlay grammar (or the popover's
     surface) is a component-contract ruling. *(§U, BL1.1's review)*

171. **[decide]** Two focus geometries in one system: chips, fields
     and pickers swap their 1px border for a 2px accent ring in
     place; checkbox and radio grow 20→28px with the ring outside.
     The in-place swap is the documented rule; the toggles don't
     follow it. *(§U, BL1.1's review)*

172. **[bug]** The gallery sidebar's right edge vanishes wherever a
     section band lines up with it — the bands are exactly the
     sidebar colour on both sides of the seam in both schemes, and
     the band's 1px bottom rule stops dead at the sidebar edge.
     *(§U, BL1.1's review)*

173. **[bug]** The gallery sidebar truncates its own title
     ("Components Galle…") in a 1400px window — the measurement is a
     few pixels short. *(§U, BL1.1's review)*

174. **[decide]** After the chip cut, the gallery's only anchor
     specimen sits in the picker row whose four siblings share one
     height and one disclosure glyph, inviting a comparison the
     two-register split loses by presentation; whether the row
     re-presents the registers (caption, grouping, or a dedicated
     chrome-register row) is a gallery-composition call. *(§U,
     BL1.1's review)*

## V. From BL2.1's release

Added 2026-08-31. One doc-coverage question surfaced while removing
the chip's stale anchor prose from llms.txt.

175. **[decide]** llms.txt no longer carries any prose about the
     picker anchor's mark (the deleted chip paragraph was the only
     carrier, and it was wrong — it claimed paired chevrons where
     the shipped mark is a single down chevron). The single-chevron
     rule lives in components/picker's package doc; whether the
     llms.txt guide should also teach it is an owner call. *(§V,
     BL2.1)*

## W. From BM1.1's fresh-eyes review of the badge section

Added 2026-08-31; full verbatim reply in
`reviews/bm1.1-gallery-fresh-eyes.md`. The specimen-matrix and
utterance-count findings were fixed in the task; the invisible close
target was part-rebutted (24 dp exists by ruling, WCAG 2.5.8 AA
governs, a still frame cannot show it).

177. **[decide]** Dark's Neutral badge sits at 6.63:1 while the four
     statuses sit at 11.01–11.10:1 — a 40% deficit that makes
     Neutral read as the disabled member of its own set (light holds
     all five co-equal at 6.19–6.22:1). Structural: statuses realize
     pins at fixed depths, Neutral walks from the ground;
     harmonizing needs a new rule. The dark row labels (8.28–8.66:1)
     also outrank the Neutral specimens they label — probably the
     same neighbourhood as item 167. *(§W, BM1.1's review)*

178. **[decide]** Chroma and hue invert across schemes on the status
     roles: Error is the loudest variant in light (C* 65.9) and the
     quietest in dark (C* 27.0, pale pink); Warning swings 22.5° of
     hue between schemes and lands as brown in light — at one
     lightness and only 27° from Error, the pair whose confusion
     matters most. A palette/ramp property in theme's territory,
     adjacent to items 146/147 and Phase BJ. *(§W, BM1.1's review)*

179. ~~**[bug]** The close mark's press ramp is compressed in dark
     (L* steps 9 and 8, vs light's 11 and 21) — press is barely
     separable from hover on an 8px glyph. Same root as items
     144/145; re-measure after the dark-ramp phase lands before
     touching it.~~ RETIRED re-measured by BJ1.2's review: the
     premise does not reproduce. The old dark ramp was 11.8 then
     34.3 — press out-shouted the badge it sat in rather than
     hiding in hover — and the glyph inverted to 1.46:1 against its
     own plate at the click. The new curve gives 11.4 then 15.7
     with a monotone glyph. What survives is the glyph-against-plate
     floor, filed fresh as item 192. *(§W, BM1.1's review)*

## X. From BM1.2's fresh-eyes review of the converted surfaces

Added 2026-08-31; full verbatim reply in
`reviews/bm1.2-gallery-fresh-eyes.md`. The baseline defect and the
design-mirror separation loss went straight into BM1.3's spec; the
"v1" navbar badge conversion went unreviewed (out of frame) and rides
the next gallery review.

182. **[decide]** mindchat's settings key row now shows the verdict
     glyph and the refresh control as two bare strokes at one size —
     they rhyme as a two-icon toolbar whose first icon is dead. The
     hoist is right; the row composition wants a re-think (spacing,
     size, or a worded verdict). *(§X, BM1.2's review)*

## Y. From BM1.3's fresh-eyes review of the container anatomy

Added 2026-08-31; full verbatim reply in
`reviews/bm1.3-gallery-fresh-eyes.md`. Items 176, 180 and 181
retired resolved by the container (records in the commit body); the
reviewer's dark-collapse headline was a misread of a one-storey
specimen block, fixed in-task by drawing the badge vocabulary once
per storey.

183. **[decide]** The badge's close cap sits 3px off-centre in its
     fill cap and cannot be centred without overlapping the label —
     the geometry needs a ruling (wider cap, tighter mark, or the
     asymmetry accepted). *(§Y, BM1.3's review)*

184. **[decide]** A dismissible badge at rest shows no boundary
     around its close mark — the walked cap only appears under the
     pointer. Whether rest hints the region is the same trade item
     180 recorded, now at the fill level. *(§Y, BM1.3's review)*

185. **[bug]** The badge's close mark has no focus or disabled
     state: a keyboard user cannot reach or dismiss it. The no-focus
     ruling deserves re-opening — dismissal is an action and actions
     are reachable. *(§Y, BM1.3's review)*

186. **[decide]** The badge's state walk is a different magnitude
     from the chip's and is not scheme-symmetric where the chip's is
     (light 1.36/1.93 vs 1.15/1.40) — one feedback grammar or two is
     a system call. *(§Y, BM1.3's review)*

187. **[decide]** The light badge foreground sits ON the 4.5:1 AA
     floor (4.50–4.56:1) while dark sits at 8.40–8.48:1 — no
     headroom for a contrast preference, and the same
     floor-sitting shape as item 168. *(§Y, BM1.3's review)*

## Z. From BJ1.2's fresh-eyes review of the re-derived dark curve

Added 2026-08-31; full verbatim reply in
`reviews/bj1.2-dark-fresh-eyes.md`. The reviewer confirmed the new dark
reads better and named the old curve's two worst consequences without
being told what the phase was for — a pressed chip on a dialog that
inverted to dark ink on a fill its own rim could not be told apart from
(1.00:1), and a close mark whose glyph darkened while its plate leapt
34 L\*. Both are fixed. Item 179 retires re-measured: its premise (L\*
steps 9 and 8, press barely separable from hover) does not reproduce —
the old dark ramp was 11.8 then 34.3, the opposite defect — and the
glyph inversion it missed is gone. Items 167, 168 and 169 all moved in
the right direction and stay open at their new values, recorded in the
review.

190. **[decide]** The chip's rest rim is storey-dependent, so the
     pointer changes the outline on one storey and not on the others:
     paper walks 109 → 155 → 155 (steps at hover, then stops), card and
     dialog walk 155 → 155 → 204 (nothing at hover, steps at press).
     Light never moves the rim on hover, on any storey. A moved
     inconsistency rather than a new one, and probably the same rung
     lookup as item 189. *(§Z, BJ1.2's review)*

191. **[bug]** Dark's chip label contrast collapses across storeys where
     light's is flat: 14.85:1 down to **4.51:1** (pressed on a dialog,
     a 0.2% pass) against light's 12.53–18.27:1 band. Light holds the
     pressed fill at an absolute value and the ink with it; dark drives
     the pressed fill off the ground, so each storey eats ~11 L\* of the
     ink's headroom. A fourth storey — a menu over a dialog, a nested
     popover — puts the label under the floor. *(§Z, BJ1.2's review)*

192. **[bug]** The badge close mark's glyph fails 3:1 against its own
     plate in two of three states: rest 3.86:1, hover **2.83:1**, press
     **2.32:1**. The glyph is pinned at `#7292B6` for rest and hover
     while the plate rises 11 L\* underneath it. Better than the old
     curve (which inverted to 1.46:1 at press) but still under the
     non-text floor. This is the mark, not its cap — distinct from
     items 184 and 186. *(§Z, BJ1.2's review, replacing 179)*

193. **[decide]** The disabled checkbox's outline is now 1.40:1 against
     its own fill (rim `#676767` → `#474747`, 1.83:1 → 1.40:1; against
     the page 3.14:1 → 1.91:1). Disabled is contrast-exempt and the
     quieting was the point — the disabled field landed correctly at
     1.61:1 fill with a 3.24:1 placeholder — but a 1px rim at 1.40:1
     against what it encloses is where quiet stops reading as a
     control. The one place the darkening overshot. *(§Z, BJ1.2's
     review)*

194. **[decide]** The dark solid button's state walk is 39% of light's:
     a click moves 12.2 L\* in dark against 31.7 in light (rest:press
     1.391:1 vs 2.755:1), and hover alone is 1.127:1 — below the
     threshold at which the fill is an affordance at all. The new curve
     fixed the walk's *shape* (two steps now 1:1.85 against light's
     1:1.89) without enlarging it, because dark's primary is a light
     fill with ~18 L\* of headroom above it. Not a tone-scale fix.
     *(§Z, BJ1.2's review)*

195. **[decide]** Library floors vs correctness: effects v0.2.5 and
     markdown v0.7.2 floor components at v1.1.1, patterns v1.2.1 at
     v1.3.1, while all three floor theme at v1.3.2 — so a consumer
     resolving through one library alone pairs the new dark curve
     with a components whose focus ring and border still walk
     one-sided (the 2.62:1 failure the curve round fixed). Churn
     minimization left them (nothing forces the bumps, measured);
     whether library floors should track components tag-for-tag on
     correctness grounds is a policy ruling — a published tag cannot
     be re-cut. *(§Z, BJ2.1)*

## AA. From BK1.1's fresh-eyes review of the recomposed specimens

Added 2026-08-31; full verbatim reply in
`reviews/bk1.1-gallery-fresh-eyes.md`. The beak-seating acceptance
passed with pixel evidence; the "beside/below" prose slip was fixed
in-task; sentence-case tooltip text kept as house voice; shadow,
dark-rung and meta-prose complaints rebutted from package contracts.

196. **[decide]** The two specimen cells are the emptiest on the
     page and their content rags left (97px dead air, 33px rag) —
     the placement contract centres a 320px canvas in a 900px band;
     pre-existing ratio, not introduced. *(§AA, BK1.1's review)*

198. **[bug]** The sidebar mark does not survive 1x: horizontal
     rules render at alpha 19, verticals split 171/125, the rail
     ticks smear. The glyph needs pixel-snapping or a heavier
     stroke at small sizes. *(§AA, BK1.1's review)*

199. **[decide]** The popover anchor is drawn hovered because no
     open state exists: `RenderState` has rest/hover/focus/press/
     disabled and nothing for "the surface I opened is still up" —
     under the language that is a persistent state (active), and
     adding it is a contract change. *(§AA, BK1.1's review)*

200. **[decide]** Minors bundle from the same review: three radii in
     two stacked cells (tooltip ~2, button ~5-6, panel ~7-8); the
     beak's diagonals read heavier than its own panel border
     (133-168 vs 197); the specimen cells float on bare gallery
     ground while the modal above paints its own desktop ground;
     two different anchor gaps (4px above the tooltip, 8px below
     the popover). *(§AA, BK1.1's review)*

## AB. From BO1.1's fresh-eyes review of the unified ring

Added 2026-08-31; full verbatim reply in
`reviews/bo1.1-focus-fresh-eyes.md`. The single-colour property
holds for twelve of fifteen specimens; the button's second tint is
forced (the scheme's ring lands at 1.48:1/1.72:1 on the button's own
accent fill — invisible), and the reviewer accepts the colour while
rejecting the geometry. The export divergence it exposed is tasked
as BO1.2, not pooled.

201. **[decide]** The button draws its focus band inset on its own
     fill — "reads as a bevel or a gloss highlight, not as focus" —
     so one control row shows three ring constructions: outside
     (checkbox), on the silhouette (field, chip, trigger), inside
     (button). Reaching literally one ring per scheme means taking
     the band off the fill. Measured candidates: (a) ship as is and
     document the primary-fill ground; (b) ring outside with the
     fill inset; (c) two-tone ring with an OnFill separator hairline
     (white 4.32:1 against the light ring, dark 5.3:1). Neighbours
     item 171. *(§AB, BO1.1's review)*

203. **[decide]** Minors bundle: two type sizes and two baselines
     across one control row (LabelLarge button/chip vs BodyLarge
     field/trigger, heights 36/40/20); the focused text-field
     specimen shows no insertion point; the checkbox is the only
     control whose ring grows its footprint (first to clip in a
     dense list — item 171's geometry, remeasured). *(§AB, BO1.1's
     review)*

205. **[decide]** The gallery's button section shows a Filled
     specimen immediately before the Pinned one, and Pinned reads as
     a fourth emphasis rather than "Filled with a caller-supplied
     colour pair" (owner-observed 2026-09-01, relayed by the
     ontology session). Candidates: group the two under one Filled
     heading, or caption the Pinned specimen so the register/pin
     distinction is visible in the layout. Gallery-composition call.
     *(§AB, owner observation)*

## AC. From BN2.2's fresh-eyes review of the chip section

Added 2026-09-02; full verbatim reply in
`reviews/bn2.2-gallery-fresh-eyes.md`. The geometry acceptance passed
with pixel evidence (32 px height, 4 px radius, 16 px end insets, 12 px
gaps, 1 px edge, every leading glyph on one scanline); the dismiss
mark's "no pointer target" complaint was rebutted from the package
contract, the reviewer having said outright it could not be measured
from a still. Nothing was fixed in-task: every item below is either the
chip's colour model, the theme's ramps, or a number needing a ruling,
and the task was fenced to drawing specimens with the existing API.

207. **[bug]** In the dark scheme the chip's state walk and the
     elevation ladder are the same three values in the same order —
     surfaces #181818 / #222222 / #2E2E2E, walked fills rest /
     hover / press #181818 / #222222 / #2E2E2E. So a resting chip on
     a card is pixel-identical to a hovered chip on the paper (fill,
     border and label all three), a resting chip in a dialog is
     pixel-identical to a pressed one on the paper, and — the half
     that is an outright defect — a chip HOVERED on a card measures
     1.00:1 against the card it stands on and a chip PRESSED in a
     dialog measures 1.00:1 against the dialog, so the feedback is
     not drawn at all. The selected pair collides one step over
     (selected rest on a card #494263, selected hover on the paper
     #4A4263). Light cannot have the fault: there elevation goes up
     (#F6F6F6 → #F8F8F8 → #FBFBFB) while the walk goes down
     (#F6F6F6 → #E8E8E8 → #D4D4D4). The walk stops where no rung can
     hold a label, which is a different question from whether the
     depth it stopped at is the ladder's own. *(§AC, BN2.2's review)*

208. **[decide]** The light ladder is nearly flat where the dark one
     is not: a card measures 1.02:1 and a dialog 1.04:1 against the
     paper in light, against 1.12:1 and 1.31:1 in dark — the two
     schemes disagree about what a level is worth by roughly six
     times. In the gallery's own capture the light card and dialog
     bands are essentially invisible. *(§AC, BN2.2's review)*

209. **[decide]** Selecting a filter chip widens it by 26 px — the
     18 dp mark plus the S2 gap, added on selection rather than
     reserved — so every click shoves the rest of a filter bar
     sideways and can rewrap the line under the pointer. Reserving
     the slot or letting the fill carry selection instead is blocked
     by the other half: the selected container measures 1.37:1
     (light), 1.30:1 (dark paper), 1.70:1 (dark card), 1.45:1 (dark
     dialog) against the surface it stands on, so selection is
     load-bearing on the hairline check. Either the container earns a
     boundary floor or the geometry reserves the slot. *(§AC,
     BN2.2's review)*

210. **[decide]** The focus ring, from the platform's side: it is a
     fixed brand purple and ignores the accent chosen in System
     Settings, so on a Graphite machine every other control's ring
     turns grey and the chips stay purple; it is drawn inside the
     control bounds rather than as a halo outside them, which is the
     web convention and not AppKit's; it replaces the resting edge,
     so a focused outlined chip stops reading as outlined; and it
     measures 2.92:1 (light) against the selected fill on its inner
     side. It is also a third purple, related to the primary in
     opposite directions in the two schemes. Neighbours items 201 and
     202. *(§AC, BN2.2's review)*

211. **[decide]** The label strengths bundle. In one row of five
     chips the assist label is 17.19:1 (light) / 15.30:1 (dark) and
     the other four are 6.19:1 / 6.39:1 — nearly three times the
     contrast on one chip, which reads as "the other four are
     disabled", and the muted rung is already spent, so there is
     nowhere below it to put a real disabled state. Second half: the
     selected chip's label is WEAKEST at rest — 4.53:1 on its resting
     container, against 4.97:1 hovered and 6.42:1 pressed — because
     the ink is re-derived against the walked body, so the state a
     reader spends all day looking at is the least legible one.
     Third: the walk is not proportioned between the two rests —
     unselected hover ~6% and press ~14%, selected hover ~14% and
     press ~28%, so hovering a selected chip is as loud as pressing
     an unselected one (dark: 9.5% against ~30%). *(§AC, BN2.2's
     review)*

212. **[feature]** The chip has no disabled state at all — its
     RenderState carries rest, hover, press, focus and selection and
     nothing else — so the inventory cannot show one and a caller
     cannot draw one. Every other control on the ladder has it.
     *(§AC, BN2.2's review)*

214. **[decide]** "Tonal" names two different colours: in dark the
     tonal button is #2F0066, fully saturated violet, while the
     selected chip's container is #312948, 43% saturated and near
     grey; in light they swap which is louder. Side by side in one
     toolbar they read as a mistake. Neighbours item 206, which rules
     the Tonal button and the badge onto one tint recipe — the
     selected chip is the third member nobody has named. *(§AC,
     BN2.2's review)*

215. **[decide]** The gallery's chip section shows the four purposes
     across three levels and the states on the paper only, and never
     the cross — which is exactly why item 207 survived; the
     reviewer could prove the collision only from token equality
     because no hovered or pressed chip is drawn anywhere but the
     paper. Adding hover, press and focus on a card and in a dialog
     is the specimen the fix for 207 wants, along with the dismiss
     mark's own hover and press, which is an independent control
     inside another control and is undrawn. Roughly doubles the
     section's height, which is why it was pooled rather than taken
     mid-task. Minor from the same review, recorded so it is not
     rediscovered: chip labels are optically centred one pixel above
     the glyph centres. *(§AC, BN2.2's review)*

## AD. From BN3.1's doctrine repeal

216. **[decide]** The repealed selection doctrine survives as a CSS
     export contract: `theme/export/css.go` emits
     `.btn.tonal.selected { background: var(--color-primary-400); }`
     and its neighbour comment asserts a ghost carries no selected
     treatment, both pinned by `roundtrip_test.go`. The Go button has
     no selected state at all, so the class exists solely because of
     the repealed doctrine; `design/.design-sync/conventions.md`
     repeats it. Removing them is a CSS export contract change in
     `theme` — wants a deliberate task, and the round's release seam
     already includes `theme`. *(§AD, BN3.1)*

217. **[decide]** The doctrine applied as app behaviour: the feeds
     preferences page-size selector marks the selected size Tonal and
     the rest Ghost — buttons carrying a persistent selection, which
     is the Filter chip's purpose now. Converting the selector to
     Filter chips is a behavioural change in an app, a natural
     first consumer of the re-anatomied chip. *(§AD, BN3.1)*

## AE. From the menu ruling

218. **[task]** The MENU is ruled a component in its own right: a
     floating list of items at level 3, placed by the attachment
     rules; each item either performs an action or records a choice.
     One menu, many openers — the picker keeps its single-choice
     contract and opens this menu; a context menu or menu bar opens
     the same menu from other triggers. The implied task: extract
     `components/menu` out of `components/picker`'s menu.go, additive,
     with picker becoming its first consumer. Concept ruled in
     DOMAIN's Menu entry; awaiting a plan slot. *(§AE)*

## AF. From BN3.2's fresh-eyes review of the resized chip marks

219. **[decide]** In dark the chip's two parts climb the elevation on
     different steps: the selected fill moves once, between the paper
     and a card, then stops (49,41,72 → 73,66,99 → 73,66,99), while
     the outline moves once, between a card and a dialog, having done
     nothing before (109 → 109 → 155). One component, two ramps, two
     boundaries. The outline's single step reads as a spot fix rather
     than a system: 109 on a card measures 3.07:1, the non-text floor
     to two decimals, and would have measured 2.35:1 in a dialog, so
     155 was substituted at that one level. The consequence on the
     selected chip is that its label contrast falls as it climbs —
     8.47:1 on the paper, 5.82:1 above it — because the label does not
     move when the fill does. *(§AF, BN3.2's review)*

220. **[decide]** Three separate cases sit ON the 4.50:1 label floor
     with 0.01 to 0.04 of headroom, not near it: light selected at
     rest 4.53, light unselected pressed 4.51, dark selected pressed
     4.54. The worst of the three is the resting appearance of a
     selected filter chip in light, which is the state a filter chip
     spends most of its life in. The two schemes also disagree about
     the direction: selecting drops the light label from 6.19:1 to
     4.53:1 and lifts the dark one from 6.39:1 to 8.47:1. A floor met
     exactly is a floor that fails the next time anything moves.
     *(§AF, BN3.2's review)*

221. **[bug]** The light focus ring fails 3:1 against the surface it
     is actually drawn on. The ring replaces the outline rather than
     standing off it, so on a selected chip its inner edge abuts the
     chip's own fill: 140,89,244 against 215,207,247 is 2.92:1, under
     the 3:1 a focus indicator owes its adjacent colours. Against the
     page outside it the same ring measures 4.01:1 and passes, which
     is why it survived. Dark is fine at 4.90:1. Neighbours 210.
     *(§AF, BN3.2's review)*

222. **[decide]** Three of the four purposes are pixel-identical at
     rest — Filter unselected and Suggestion agree on border, fill,
     label, height and corner profile in every sampled property, and
     Input differs only by the two things hung on it. The purposes are
     distinguished by their attachments alone. That may be the right
     answer for a family whose whole point is one silhouette, but the
     section's own heading promises four purposes and the render
     delivers one appearance with three affixes, so the promise or the
     drawing wants deciding. *(§AF, BN3.2's review)*

223. **[decide]** Selecting a chip makes its boundary harder to see. A
     selected chip carries no outline at all, so the only thing
     separating it from what it stands on is the fill step: 1.37:1 on
     the light paper, 1.43:1 in a light dialog, 1.30:1 and 1.45:1 in
     dark — against the 4.03:1 edge the unselected chip has. The
     outline is dropped on selection by the M3 anatomy this family
     adopted; whether a filled chip owes its own boundary a floor is
     the ruling. *(§AF, BN3.2's review)*

224. **[decide]** A diagonal in this library reads lighter than an
     axis-aligned stroke of the same width, and lighter than the type
     it is set beside. BN3.2 put the chip's marks on the label's own
     stem width — the measured platform relation — and the marks still
     read thinner than the label's stems, because Gio composites in
     linear light where the platform composites in encoded sRGB, worth
     about 30 points of apparent ink at hairline scale (the measured
     macOS reference records the difference). Every derived diagonal
     in the library is affected: the chip's check and cross, the
     picker's chevron, the disclosure marks. Either the compositing
     difference is compensated once, somewhere central, or diagonals
     carry a stated weight premium over axis-aligned strokes. Not the
     chip's to answer alone. *(§AF, BN3.2's review)*

225. **[decide]** The gallery's level surfaces shrink-wrap their
     content while the section headers are full-bleed, so the page has
     a ragged right edge: the chip section's card runs to x=813 in a
     900 px window and the badge section's to x=503, both under
     headers that run the full width. Each surface stops wherever its
     longest row happens to end plus its padding, which reads as an
     accident rather than a composition. *(§AF, BN3.2's review)*

226. **[decide]** The gallery's row captions collapse onto the content
     tier in dark. They reach 155,155,155 at their darkest, which is
     exactly the chip label colour; in light they stop at 121,121,121
     against a label at 92,92,92 and stay a tier below. So the
     caption/content distinction exists in one scheme and not the
     other, with only the size difference left to carry it in dark.
     *(§AF, BN3.2's review)*

227. **[decide]** The chip is rounder than the button it is shorter
     than: a chip's corner measures about 6 px against a button's
     about 4. Both take their radius from the scale, so this is a
     question about which rung each component names rather than a
     defect in either — but a 32 dp control being visibly rounder than
     a 36 dp one is the sort of thing a developer reads as a mistake.
     *(§AF, BN3.2's review)*

## AH. From BR1.1's fresh-eyes review of the three-column frame

Added 2026-09-03. The regenerated patterns tiles in both schemes,
offscreen at 1x; the verbatim reply and triage are in
`reviews/br1.1-shell-frame-fresh-eyes.md`. Nothing was changed on its
strength. Recorded misreads: the frame's own divider read as a
permanent scrollbar, and the chrome-filled aside and footer read as
dead space because chrome is one fill. Items 251–255.

## AI. From BR1.2's fresh-eyes review of the card specimens

Added 2026-09-05. The gallery's card specimens at 900×222, one reviewer
per scheme, offscreen at 1x; the verbatim replies and triage are in
`reviews/br1.2-card-fresh-eyes.md`. Both reviewers independently found
the two looks to be one fill plus an optional hairline; that is a
ruling on the card entry, held with the orchestrator, not a pool item.
Recorded misreads: the card draws no text and no divider by
construction, and the specimen's hard-wrapped prose is deliberate.
Items 257–259.

## AG. Language seeds awaiting a plan slot

228. **[task]** HIGHLIGHT beyond the search field: the scrollbar tick
     marks that accompany every match, and the adoption wherever
     find-in-content exists outside the search field control, the
     marks dying with the query. (The token, the followed-link
     arrival and the search field control are in the plan; the
     Language entry is DOMAIN's.) *(§AG)*
