---
date: 2026-09-11
task: CE2.4b
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE2.4b fresh-eyes review — the gallery's controls and signals

One reviewer, which had seen neither the packet nor the plan, given no
checklist and one question: what would a developer who uses macOS every day
complain about, looking at these controls and signals as macOS controls? It
was handed sixteen offscreen captures at 1 px per point — the gallery's
button, button-emphasis, badge, alert, toast, text-field, search-field and
checkbox sections, each in both appearances — and told only the recorded
misreads: that a dark foreground reads grey at 1x because glyph stems are
about a pixel wide and antialias; that the chrome regions deliberately share
one fill with the content in the light appearance on macOS 26 and are told
apart by their seams; that a still capture cannot show a fade, a cursor or a
pointer; and that the platform composites a translucent colour in encoded
sRGB and the values were measured off captures of the real system.

## The reply, verbatim

Read all sixteen, and sampled pixels where a claim depended on an exact value. Complaints in order.

## 1. The toast has no surface at all
`components-toast-light.png` / `components-toast-dark.png`, the four rows from y≈55 to y≈215. A toast is an overlay that floats above whatever the user was looking at. Here it is a 4px coloured stripe at x≈23–30 plus bare text — nothing else. I scanned the full column at x=400 through all four rows: every pixel is the page fill (`#FFFFFF` light, `#1E1E1E` dark). No fill, no border, no shadow, no inset. Drop that over a list or an editor and the message is unreadable and the stripe looks like a drawing artifact. Note that the alert sheet *does* give its cards a hairline (`#E5E5E5` / `#353535`), so the toast is also the only container in the set with nothing at all. On macOS transient feedback is a HUD — a rounded, distinctly-shaded panel, usually inverse of the appearance, with a shadow. This one is a Bootstrap left-border alert with the box deleted.

## 2. The alert severity glyph is a play button
`components-alert-light.png` / `-dark.png`, the glyph at x≈44–56 in each of the four rows. It is a solid right-pointing triangle, four times over, in blue / green / orange / red. On macOS a right-pointing solid triangle means *play*, or a collapsed disclosure group. Four stacked rows each with one reads as an outline that hasn't been expanded — my first instinct is to click it. The native vocabulary here is four *different* shapes: `info.circle.fill`, `checkmark.circle.fill`, `exclamationmark.triangle.fill` (pointing **up**), `xmark.octagon.fill`. As drawn, severity is carried by hue alone at 12px, which also means the four rows are identical to a colour-blind user. The badge sheet gets this right on the disc rows — a check and a cross — so the alert sheet is the odd one out.

## 3. The resting outline is invisible, and disabled is more visible than enabled
Worst single instance: `components-checkbox-light.png`. The enabled unchecked checkbox border (x≈28–29 and 42–43, y=64) is `#F3F3F3` on a `#FFFFFF` page — 1.04:1, essentially nothing. The enabled unselected radio at x≈394 is the same `#F3F3F3`. But the **disabled** radio at x≈658 is `#BFBFBF` — roughly four times the contrast of the enabled control next to it. Same inversion in `components-checkbox-dark.png`: enabled `#2C3338` on `#1E1E1E`, disabled `#565656`. The state that should recede is the most prominent thing in the row.

The same near-invisible stroke is the resting border of the text field (`components-textfield-light.png`, x=24, y=86, `#F3F3F3`) and the search field. In `components-textfield-dark.png` and `components-searchfield-dark.png` the field interior is exactly `#1E1E1E`, identical to the page, with a `#2C3338` hairline — so a macOS user sees no well. Text fields on macOS are the one control that always reads as recessed and filled; here "Rest" and "Disabled" are separated only by how faint their nearly-invisible outline is.

## 4. You cannot see which control has keyboard focus, and focus works three different ways
`components-button-light.png`, the "Focus" button at x≈288–408. The focus indicator is a 2px stroke **inside** the fill at x=290–291: `#0070F9` painted on `#007AFF`. That is a 1.05:1 difference — invisible. Dark is the same construction (`#0D92FF` inside `#007AFF`). Tab through a dialog and you have no idea where you are.

Worse, the three controls disagree on the mechanism:
- Button (`components-button-light.png` x≈290): darker-blue stroke *inside* the fill, no gap.
- Text field (`components-textfield-light.png` x=240–241): the field's own border is *replaced*, `#F3F3F3` 1px → `#7FB3F9` 2px, in place.
- Checkbox (`components-checkbox-light.png` x=200–201): a genuine ring outside, with a 2px gap before the box at x=204. This one is structurally right, and is the only one.

macOS has exactly one focus ring, a ~3pt accent halo outside the control with a gap, identical on every control. And `#7FB3F9` is a washed-out tint of the accent rather than the accent itself — where it *is* drawn it's fainter than the system's.

## 5. Hover is a no-op, and press barely registers
`components-button-light.png` and `-dark.png`: "Rest" (x=85) and "Hover" (x=217) are pixel-identical, `#007AFF`, in both appearances. `components-badge-light.png`/`-dark.png`, the Dismissible row at y≈292: the "Filtered by owner", "Hover" and "Press" badges all have fill `#0088FF` (light) / `#0091FF` (dark) — three labelled states, one rendering. Press on the button is `#007AFF`→`#006EE6` in light, about 5%, and in dark it goes the *other* way, `#007AFF`→`#1987FF`. Both are below what you'd notice on a real click, and the direction reversal between appearances isn't a macOS behaviour.

## 6. The badges belong to a web admin dashboard
`components-badge-light.png` / `-dark.png`, the five pills at y≈63–78. Solid, fully saturated fills — `#34C759`, `#FF8D28`, `#FF383C`, `#0088FF`, `#8E8E93` — with bold white text. White on that green is roughly 2:1 and on that orange roughly 2.3:1, at ~11px bold; "Success" and "Warning" are the hardest text to read anywhere in the sixteen sheets. macOS renders a status label as a *tinted* capsule — pale fill, saturated text — precisely to avoid this.

Two more things in the same sheet:
- The three rows are labelled "On the content", "On a card", "In the chrome", but the badges are byte-identical in all three. The sheet promises an adaptation that isn't there. (The bands themselves do differ: `#F7F7F7` for the card row in light, `#2A3034` / `#232A2E` in dark.)
- Light and dark differ by 1–2 points per channel (`#34C759`→`#30D158`, etc.). A fully opaque `#FF383C` glares on a `#1E1E1E` page in a way it doesn't on white; macOS system colours separate much further between appearances.
- "Disc, a cross" at y≈269: there is a green ✕ and a blue ✕. A cross means *removed / failed*; colouring one green is incoherent, and you will never see it on macOS.

## 7. The search field is shaped like a text field, and the clear mark is naked
`components-searchfield-light.png` / `-dark.png`. The field at x≈24–222 has the same modest corner radius as the plain text field — only the magnifier tells you it's a search field. On macOS a search field is visibly rounder than a text field, and on macOS 26 it's a capsule. Then the clear control at x≈410–425 in the "Typed" and "Focused" specimens is a bare thin ✕ stroke, oversized relative to the magnifier. macOS's is a small *filled grey disc* with a knocked-out x; the naked glyph is the iOS/web form. It also reads as decoration rather than a hit target, with no visible bounds.

## 8. The emphasis row doesn't hold together as one family
`components-button-emphasis-light.png` / `-dark.png`, y≈52–78.
- The icon-only face at x≈418–444 is a small rounded **square**, while every text button on both button sheets is a full capsule. Same component, two different corner languages, side by side in one row.
- "Ghost" at x≈325–370 is plain foreground-coloured text with no chrome and no accent tint. It is indistinguishable from a static label — on macOS a borderless button's label is accent-coloured so you know it's pressable.
- "Tonal" in light is a flat grey capsule with no border and no shadow; in dark it carries a visible lighter outline. A macOS push button has a faint border *and* a subtle drop shadow that lifts it off the surface, in both appearances.

## 9. The dark greys are two different temperatures
`components-button-dark.png`, `components-badge-dark.png`, `components-alert-dark.png`. The page is a perfectly neutral `#1E1E1E` and the alert card border is neutral `#353535`, but the header band is `#232A2E`, the badge card band `#2A3034`, the disabled button fill `#333A3F`, and the control hairline `#2C3338` — all noticeably blue-tinted. Put them next to each other and the tinted greys read cool against the neutral ones. macOS dark greys are neutral throughout; the mix looks like two palettes were merged.

## 10. Disabled changes the shape of the button
`components-button-light.png`, x≈551–673. The disabled pill is `#ECECEC` with a distinct `#E1E1E1` edge — a border that none of the four enabled buttons has. So disabling a button doesn't just fade it, it adds an outline and changes its visual weight. macOS fades the whole control, accent and all, to a pale version of itself; it doesn't restyle it into a different thing. Dark has the same added edge (`#333A3F` fill, `#3E454A` edge).

## 11. The labels are bold
All four button sheets and the badge sheets. macOS control labels are regular-weight 13pt system; "Rest", "Hover", "Filled", and every badge label here are clearly semibold or heavier. It gives the whole set a heavier, more Material feel than anything in the system.

---

Things that look right, briefly: the accent is `#007AFF` in light and `#0091FF`-ish in dark, which is the system blue, correctly split between appearances. The capsule button shape is right for macOS 26. The checkbox's focus ring geometry — outside the control with a real gap — is correct, and is the model the other two controls should follow. Control heights (~26–28px) and the alert card metrics look sane. Nothing shifts position between rest and focus, so there's no reflow when tabbing.

## What was done about it

Two findings were the gallery's own and were fixed in this task.

**1, the toast with no surface.** Confirmed: `toast.Fill` is the window's
own plane, which is what every floating surface on this platform is filled
with, and the section laid the toasts straight on the content plane — the
same value in the light appearance and one step off it in the dark. The
specimen had no body in either. The toast column now stands on a band of the
platform's box fill, standing in for the content a toast floats over; the
shadow that does that job in a running window belongs to whatever places the
toast and stays in the notifications specimen.

**6, second bullet: three surfaces, one row drawn three times.** Confirmed
to the byte. With the platform's names a badge that carries a label wears
its status's own colour, which is one value whatever is beneath it, so the
three panels could not differ. The three panels are gone: the section is
five rows on the page — the statuses, the utterances, the two disc rows and
the close mark — and the title no longer promises an adaptation. The same
question was asked of the chip section and answered the other way: a chip's
rim, ring and press tint each carry a coverage, so its three panels do
differ and they stay.

Everything else belongs to a component this task does not own, or to the
recorded reference, and is reported rather than fixed:

- **2**, the alert's severity mark is one shape in four hues —
  `components/alert`.
- **3**, the resting field and toggle edge is `FieldEdge`, the measured
  hairline, and the disabled edge reads stronger than the enabled one —
  `components/input`, and a question about the measured value.
- **4**, the focus ring is drawn inside an accent fill where it cannot be
  seen, and the three controls build it three different ways —
  `components/button`, `components/input`, `components/internal/focus`.
- **5**, hover on a push button is a no-op BY MEASUREMENT (a Save dialog's
  push button does not tint under the pointer on macOS 26) and the press
  overlay reverses direction between appearances because the platform's own
  overlay is black in light and white in dark; the reviewer read both as
  defects. The badge's dismiss hover and press landing invisibly is real and
  belongs to `components/badge`.
- **6**, first and third bullets: the badge's solid saturated fill under
  white text, and a green cross — `components/badge`.
- **7**, the search field's corner and its clear mark — `components/input`.
- **8**, the icon button's square against the text button's capsule, the
  ghost that reads as a label, the tonal with no border in light —
  `components/button`.
- **9**, the dark greys carrying two temperatures — the chrome material and
  the box fill were measured on a desktop with wallpaper tinting on, which
  is what carries them off neutral; a question for the reference rather than
  for a consumer.
- **10**, disabled adding an edge the enabled button does not have —
  `components/button`.
- **11**, the control label's weight — typography, which this phase does not
  touch.
