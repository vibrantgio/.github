---
date: 2026-09-23
task: CG6.2
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG6.2 — the sk150's readout panel read cold beside two bench supplies' own displays

One reviewer, having seen neither the plan nor the packet nor any source and
told not to go looking for one, was given four images: the sk150 window's
readout panel at 1x in both appearances as this task first left it, the
photograph of the SK150's own display (`reference/sk150-display.png`), and
the photograph of an OWON SPE6103's display rotated upright
(`reference/sk150-display-2026-09-23.jpeg`), the second named as a different
manufacturer's device shown for its layout only. It was given the recorded
misreads — a still shows no fade, no cursor and no hover; both photographs
are camera captures of lit displays whose colours the exposure saturates; the
OWON's colours, its blue ground and its box borders are that device's own and
not a target; the readings' face, size and digit padding are settled by a
prior ruling — and it was told it could read the pixels any way it liked. It
was asked one question, with no checklist: "Does this panel read as a bench
supply's display with its readings and its set values, and what is wrong with
it?"

## The reply, verbatim

> Yes, it reads as a bench supply's display. Three stacked, colour-coded readings with their units in a right-hand column, a CV mode flag on the voltage row, and a small two-row set/limit footer under them — at a glance it is unmistakably an instrument readout, and it is close in structure and hue to the SK150 photograph (green volts, yellow amps, magenta watts, CV block over the V). What is wrong, worst first:
>
> **1. There is no output state anywhere on the panel.** Nothing says whether the output is on or off. The SK150 carries a large yellow ON badge in its left margin beside the current row; the Owon puts OFF at top-left of its status strip. The app's left margin is empty — the only thing that ever enters the region left of x≈150 is the leading "1" of 147.000. So the panel shows 21.00 V, 7.000 A and 147.000 W with no way to tell a live supply from a dead one, and 147 W of "flowing" power with no indication that anything is actually flowing. On a bench supply that is the single piece of state that decides whether the terminals are dangerous, and it is the one thing the panel omits.
>
> **2. The "Set" and "Limit" labels are painted in the power colour.** They are #F928FA, pixel-identical to the magenta of the 147.000 W reading and its W unit. The panel spends its top two-thirds teaching a three-hue code — green is volts, yellow is amps, magenta is watts — and then uses the watts hue for two words that have nothing to do with watts. A reader scanning for magenta finds the power reading and also finds the row headings.
>
> **3. The set/limit block is not separated from the readings at all.** The gap from the bottom of 147.000 to the top of the Set row is 35 px; the gaps between the three big readings are 36 px each. There is no divider, no box, no extra space, no change in saturation — the footer values are the same full-strength #2BF42F green and #FEFB43 yellow as the live readings, just smaller. So the layout says the footer is a fourth sibling of the three readings, when in fact it is the other kind of number entirely. The Owon separates the same information into two bordered boxes with header bars and dims the values inside them. Here, four numbers sit in a bare 2×2 grid and the entire distinction between what the supply is measuring and what it has been told to do rests on the words "Set" and "Limit" — and the distinction between a regulation target (7.000 A) and a protection trip (7.200 A) rests on nothing but those same two words.
>
> **4. Power is shown to three decimals, and that inverts the hierarchy.** 147.000 W claims milliwatt resolution from the product of a 10 mV reading and a 1 mA reading; the reference device shows 147.0 W. The cost is not only the false precision: the extra digits make power the widest line on the panel (x 97–324 against the voltage's 162–324), the only one that breaks out to the left of the shared digit column, and therefore the loudest, most eye-catching thing in the readout. The derived, least important quantity dominates the two measured ones.
>
> **5. The reading contradicts its own mode badge.** Measured current is 7.000 A and the set current is 7.000 A — exactly equal, to the milliamp — while the CV badge is lit. That is the CV/CC crossover point; a supply sitting precisely there is not a state you would choose as a fixed demo value, and it means nothing on the panel lets you check that the badge is telling the truth. Voltage is also exactly at its 21.00 V set point, so both regulation loops appear clamped at once.
>
> **6. Light and dark are the same picture.** The interior of the panel is pixel-identical between the two captures — zero differing pixels inside the frame; only the surrounding page changes, from white to #1E1E1E. If an always-dark instrument screen is intended, that is defensible, but the consequence is visible in both: the panel is #090905 with no bezel and no border stroke at all, so in light it is a hard-cut black slab dropped on white, and in dark it is #090905 against #1E1E1E, which is so near a match that the screen's edge nearly disappears into the window and only the corner rounding marks where it ends.
>
> **7. Small alignment misses.** The footer block's right edge lands at x=328 while the big digit column's right edge is x=324 — four pixels apart, close enough to read as a failed alignment rather than a deliberate one. The content also hangs low in the panel: 30 px of space above the first reading against 17 px below the last footer line. And the CV badge overhangs the unit column by 15 px (badge ends x=366, the V, A and W units all end at 350–351), so the right edge of the readout is ragged with one element sticking out.
>
> **8. The footer's label gap is ragged.** "Set" leaves 34 px before the value column; "Limit" leaves 15 px, about a character and a half, so the second row's label nearly runs into its first value while the first row's has a wide hole after it.

## What was done with it

**Fixed, 2.** The captions were in the watt magenta, which was this task's own
choice and the reviewer is right about it: the readings spend the top of the
panel teaching that green is volts, yellow is amps and magenta is watts, and
a heading in the watt hue breaks that code. The captions now carry no hue at
all. `displayCaption` is the panel's own black lifted two fifths of the way
to white — a brightness rather than a colour — so the three-hue code stands
and the display still holds no fourth lit colour. The rule below uses the
same value.

**Fixed, 3.** The two areas are now two areas. A one-pixel rule in that same
`displayCaption` spans the panel's lit width between them — what the OWON
draws as a border around its Set and Limit boxes — with 36 px of black above
it and 36 below, against the 36 the readings keep between themselves. The
values keep the full-strength green and yellow deliberately: they are the
device's own values for volts and amps, and a value on these lines is the
same colour as the reading it governs. What separates them from the readings
is the rule, the size and the captions, not a dimmer green.

**Fixed, 5.** The demo state was incoherent and this task put it on screen
for the first time. The reading is the photograph's — 21.00 V, 7.000 A,
147.000 W, CV lit — and that part does not move; what moved is the live group
behind it, which this task added. The current setpoint is now 7.100 A, above
the 7.000 A measured, which is what regulating on voltage means, and each
protection stands above the setpoint it guards (OVP 24.00 V over VSet 21.00 V,
OCP 7.200 A over ISet 7.100 A), which is what the app's own write path
requires. The voltage sitting exactly at its setpoint is correct and stays.

**Fixed, 7, the part this task owns.** The second area now hangs on the
readouts' column's right edge — where the unit letters end — rather than
being centred on its own width, so the two areas share one right margin
instead of missing it by four pixels. The vertical hang is gone too: 30 px of
black above the first reading against 30 below the last line, measured off
the regenerated frame.

**Fixed, 8, as far as a label column goes.** The gap between the caption
column and the first value went from 12 to 18 dp, so "Limit" no longer runs
within a character and a half of its value. The captions stay left-aligned in
a column as wide as the longer of the two: right-aligning them would even the
gap at the cost of a ragged left edge on a two-line block, which is the worse
trade.

**Filed, not fixed — 1.** The reviewer was given the panel alone. The window
does carry the output state, in the header's bolt and ON/OFF cluster beside
the power toggle, which is where an earlier round deliberately put it and
where the panel's own comment records the decision. But the reviewer's point
stands on its own terms: the SK150 itself puts ON on the display, and whether
this app's panel should is a decision, not this task's.

**Filed, not fixed — 4.** The watt line's three decimals are the readings'
format, which this task is told to leave alone. The observation that the
false precision also makes the derived quantity the widest and loudest line
on the panel is worth the decision it asks for.

**Filed, not fixed — 6.** That the panel is the same picture in both schemes
is the ruling this task works under and the reviewer allowed for it. That
`#090905` against the dark scheme's `#1E1E1E` leaves the display's edge
almost invisible, with no bezel and no border stroke, is a separate reading
and a real one.

**Filed, not fixed — 7, the CV badge's overhang.** The badge sits above the
unit letter and is wider than it, so it stands 15 px proud of the readout's
right edge. That is the badge's own geometry from an earlier round, not the
second area's.
