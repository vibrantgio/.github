# BB1.1 — fresh eyes on the MindChat window after the chip's fill stepped down

Captured by `TestWholeWindowRender` at the window's own opening size,
1024×768, both colour schemes with the pane standing. Handed to a subagent
that had not seen the task packet, with one question — what would a
developer on this platform complain about? — and the recorded misread
briefed first (dark ink reads grey at 1×; sample before calling something
low-contrast).

**What the task was watching for, and did not get.** The chip's resting
fill dropped from a whole storey over its ground to a measured 1.28 L\* in
the dark scheme — `#1B1B1B` over the `#181818` paper, +3.0 luminance
against the platform's own +2.65 between a unified toolbar's band and the
pop-up capsules on it. The review that prompted BB1.1 opened on the chip
being too loud for a mac window. This one does not mention the chip's fill
at all: it reads the picker as a control with a border, and its complaint
about the picker is a shape complaint, not a loudness one. That is the
result the task was after.

The reply is below verbatim. The triage follows it.

---

I read both renders and sampled pixels rather than eyeballing. Findings, most serious first.

**1. The accent polarity is inverted between the two color schemes.** Sampled fills:

| surface | dark render | light render |
|---|---|---|
| user message band | `#D0C4FF` (pale lavender, dark ink) | `#723AD4` (saturated purple, white ink) |
| sidebar selected row | `#3F0085` (deep purple, white ink) | `#D8CEFF` (pale lavender, dark ink) |

Two bugs in one. Across schemes, each surface flips to the wrong end: dark mode gets the near-white band, light mode gets the deep one. In dark mode those two full-width lavender bands (y≈54–100 and y≈285–328) are by far the brightest thing in an otherwise `#181818` window — they glare. And *within* one scheme, the two "selected/accent" surfaces disagree: dark mode uses deep purple in the sidebar and pale lavender in the transcript; light mode does the reverse. There is no single accent story.

**2. The user messages are full-bleed horizontal bands, not messages.** They run from x=248 (butting straight into the sidebar divider with zero gutter) to the window's right edge, passing *under* the scrollbar. No bubble, no rounded corner, no right alignment, no max width. This is the ChatGPT-web layout dropped into an NSWindow; a macOS chat app right-aligns the user's turn in an inset bubble. Also, the user text is indented to x=310 to line up with the assistant's text column, which leaves a ~60px empty gutter inside every purple band where the assistant's avatar would be.

**3. The scrollbar is always on and never themed.** A 1px-ish bar at x=1019, `#878787` — the *identical* grey in both renders, so it neither dims for dark nor darkens for light. macOS overlay scrollbars fade out when not scrolling. Worse, its geometry is wrong: the thumb runs y=54→676, i.e. ~93% of the track pinned at the top, implying ~40px of hidden content — but the transcript is visibly cut off right after "Sources:" (y≈680) with the sources list still to come. It is also flush against the window's right edge rather than inset.

**4. One un-themed hairline token is used for every border, and it's wrong in both schemes.** The code block outline, the inline `MessageOp` / `Update` code chips, and the divider above the composer (y=720) all sample `#9E9E9E` in dark and `#797979` in light. In dark that is a bright silver cage drawn around a `#222` block on a `#181818` pane; in light it's a heavy charcoal outline. Compounding it, the code block fill is `#F8F8F8` on a `#F6F6F6` pane — a 2-level difference, so in light mode the block has no fill distinction at all and is held together entirely by that harsh border. Native would be the reverse: a visible fill, and a border at ~10% opacity or none.

**5. The composer is not a macOS composer.** Single fixed-height 40px field (y=720–759), placeholder "Send a message", and that's it — no send button, no attachment affordance, no visible multiline growth. Nothing anywhere in the window shows keyboard focus: no focus ring on the text field, no first-responder indication, so there's no way to tell what a keystroke would hit. Margins around it are 8px on left, right and bottom — cramped and inconsistent with the ~24px rhythm the transcript uses.

**6. Sidebar selection and row actions.** The selected row is a full-bleed rectangle spanning x=14→244 with a left edge stripe. Modern macOS sidebars use an inset rounded capsule with side margins. The pencil and ✕ buttons sit permanently visible inside the selected row — a destructive delete parked one icon-width from rename, with no hover-reveal and no apparent confirmation. Unselected rows expose no affordance at all, so discovery depends on selecting first.

**7. No material anywhere, and dark mode inverts the depth convention.** The sidebar, the titlebar strip and the content pane are flat opaque fills — no vibrancy, no translucency, and the titlebar is the same flat color as the body it sits over. In dark, the sidebar is `#151515` against a `#181818` content pane: the sidebar is *darker* than the content, the opposite of the platform convention, and only 3 levels apart, so the two panes are separated purely by the divider line at x=247.

**8. Toolbar is custom-drawn, and the title is duplicated.** "Reactive layouts" appears twice — as the toolbar label at x=257 and as the selected sidebar row. The model picker is a hand-rolled full-radius pill with a hard 1px border and a single down-chevron; a native pop-up is a rounded-rect with the paired up/down chevrons. There is also no separator or material change under the toolbar in the content pane, so the first purple band butts directly into it at y=54 and reads as part of the chrome.

**9. "Settings" as a sidebar footer row.** On macOS, Settings belongs in the app menu under ⌘, — not as a gear row pinned at the bottom of the sidebar (that's the Electron/web convention).

**10. Third-party mark as UI chrome.** The OpenAI logo is used as the assistant avatar, repeated per turn, and the vendor string "Default · OpenAI · gpt-5.5" is the only control in the toolbar.

Two things I checked and am *not* flagging: the body text contrast is fine in both schemes (dark ink on the lavender band reads correctly at 3x, it only looks grey at 1x), and the composer is not clipped by the window edge — it has a real, if tight, 8px bottom margin.

---

## Triage

Nothing here is in BB1.1's scope, and nothing here is the loudness this
task was cutting. Recorded rather than discarded:

- **7, "the sidebar is darker than the content"** is a FALSE POSITIVE
  against this system's own ruling and joins the briefing list for future
  reviews. Chrome furniture is the window's floor in both schemes; a
  sidebar is the desk the document lies on. The reviewer is describing
  the platform convention it expected, not a defect.
- **8, the picker's shape** — a full-radius pill with one chevron where a
  native pop-up is a rounded rect with a paired chevron — is the one item
  that touches the chip, and it is a shape question rather than a colour
  one. The pill is deliberate and documented (it is what separates a chip
  at a glance from a button's 6 dp corner) and the paired chevron is the
  app's glyph, not the component's. Neither is BB1.1's; both belong to
  whatever ruling takes up the chip's platform shape.
- **1 (accent polarity), 2 (full-bleed user bands), 3 (scrollbar),
  4 (one hairline token for every border), 5 (composer), 6 (sidebar row
  actions), 9 (Settings row), 10 (third-party mark)** are the app's and
  the wider system's, untouched by this task and unchanged by it.
