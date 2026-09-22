---
date: 2026-09-22
task: CG5.23
phase: CG
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CG5.23 — a sidebar's selection read cold beside the platform's own, focused and unfocused

Two reviewers, each having seen neither the plan nor the packet nor any
source, were given eight images at 1x and told which four are the platform:
vaultview's folder rail in both appearances and in both states — the keyboard
on it and the keyboard off it — beside `voicememos-sidebar-{light,dark}.png`,
which hold a sidebar that IS holding the keyboard, and
`finder-sidebar-unfocused-{light,dark}.png`, which hold one that is not. Both
were given the recorded misreads — a dark label reads grey at 1x; a still
shows no fade, no cursor and no hover; an alpha colour composites in encoded
sRGB; our window's three round buttons are harness stand-ins; a pointer target
is invisible in a still — and both were told they could read the pixels any
way they liked. Both were asked one question, with no checklist: "Does this
sidebar's selection read as the platform's, focused and unfocused, and what is
wrong with it?"

The first was handed renders of the rail COMPONENT alone, whose surround is
the golden harness's own backdrop rather than the chrome material the rail
stands on in the window — a mistake in the packet of images, not in the
reading, and the finding it turns on rests on it. The second was handed the
same four states cropped out of the whole composed window, so the rail stands
on its real fill, plus two more misreads: what stands beside the rail is the
note column, another round's work; and the platform captures carry wallpaper
tinting where our renders use the untinted material.

The second reviewer found the defect the first was reaching for, and gave the
reading that proves it. Both replies are recorded below, in the order they
were given.

## The first reply, verbatim

> ## Review record — sidebar selection, focused and unfocused
>
> **Focused reads right, and reads right to the pixel.** The focused fill in `vaultview-rail-focused-light.png` is `(23,139,251)` across the whole pill (x 10–229, y 254–285). Voice Memos' selected row in `voicememos-sidebar-light.png` is `(23,139,251)` (x 18–217, y 325–356). Identical, not approximate. Dark is the same story: ours `(25,148,252)`, Voice Memos `(25,148,252)`. Both fills are flat — no gradient, no inner highlight — which is what the platform does too.
>
> The focused foreground is right as well. Label and icon resolve to pure `(255,255,255)` over the accent, as Voice Memos' do. The label is not secretly re-weighted: the glyph run "Reading list" measures x 77→148 in all four of our renders, a constant 72 px, so the heavier look in the focused shots is polarity, not a bold face.
>
> **Unfocused colour is also right — the label and icon, at least.** Our unfocused selected label and icon carry `(0,114,247)` in light and `(20,143,255)` in dark, which are exactly the values Finder puts on "Documents" in `finder-sidebar-unfocused-light.png` and `-dark.png`. That accent-tinted-label convention is Finder's, and we have it.
>
> **Geometry is right.** Our pill is 32 px tall (y 254–285); Voice Memos' is 32 px (y 325–356) and Finder's is 32 px (y 212–243). Our inset is 10 px from each rail edge on a 240 px rail; Voice Memos insets 9 px on a 218 px sidebar interior (x 9–226, pill x 18–217) and Finder insets 9 px (pill x 18–307). Corner radius, measured from antialiasing coverage deficit summed over the top-left quarter, is ≈7.5–8.1 px for ours against ≈7.9–8.4 px for Voice Memos — inside a pixel. The pill is the same rectangle in all four of our states, which matches the platform: only the fill and the foreground change between focused and unfocused.
>
> ---
>
> **What is wrong: the unfocused fill is an absolute colour where the platform's is a step from the sidebar, and it breaks in opposite directions in the two appearances.**
>
> In light, our unfocused fill is `(239,239,238)` sitting on a rail of `(240,240,240)`. That is ΔL* 0.37 — under the threshold at which a flat patch separates from its surround at 1x. The pill is genuinely present in the pixels (x 10–229, y 254–285, measurably not the background) and it does nothing. Finder's equivalent is `(239,239,239)` on `(250,250,250)`, ΔL* 3.82 — ten times our step, and plainly visible as a plate. So in our light appearance the *only* thing saying "this row is selected" is the blue label; the selection surface has evaporated.
>
> The cause is visible in the numbers. Our fill `(239,239,238)` is Finder's `(239,239,239)` copied across as a literal value (the 238 blue channel is a 1-level cool cast from retyping, not a design). But it was copied without its background: Finder's sidebar is `(250,250,250)` and Voice Memos' is `(249,249,249)`, while our rail is `(240,240,240)`. The platform's unfocused grey is about 4.4% darker than its own sidebar; ours is 0.4% darker than ours. It was specified as a colour when the platform specifies it as a step.
>
> The same mistake shows up inverted in dark. Our fill is `(42,42,42)` — again exactly Finder's `(42,42,42)` — but our rail is `(20,20,20)` where Finder's is `(28,28,28)`. That makes our step ΔL* 10.74 against the platform's 6.79, roughly 1.6× too strong. The dark unfocused row reads as a raised plate with a clear edge; Finder's reads as a faint tint you have to look for. Wrong in the other direction, from the identical root cause.
>
> Taken together, our unfocused state is not even consistent with itself: ΔL* 0.37 in light against 10.74 in dark, a 29× swing between appearances, where the platform's own pair is 3.82 and 6.79 — dark a little stronger, same order. Whatever value is chosen, the two appearances should land near each other, and both should be derived from the rail rather than pasted in.
>
> **Contributing, and worth naming even though it is not the selection itself:** the rail fill is off from the platform in both appearances and in both reference apps — ours `(240,240,240)` against Finder's 250 and Voice Memos' 249; ours `(20,20,20)` against both apps' `(28,28,28)`. This is the upstream reason the copied selection greys misbehave, and correcting the selection grey alone would still leave the selection standing on a surface macOS does not have. It also costs the focused state a little: the accent pill against our light rail computes APCA 52.2 where Voice Memos' against its own sidebar is 57.6 (dark is unaffected, 43.2 against 42.3).

## The second reply, verbatim

> ## Review record — sidebar selection, focused and unfocused
>
> **It reads as the platform's.** On every axis I could measure it is either pixel-exact or inside a level, with one exception, described at the end.
>
> **Geometry.** Our pill is 32 px tall, y 262–293 in all four crops, sitting inside a rail whose material runs x 9–246; the pill spans x 18–237, so 9 px of material either side. Finder's is 32 px tall (y 212–243) with the same 9 px insets, and Voice Memos' is 32 px tall (light y 325–356) likewise. Row pitch is 32 px in all three, so the pill fills its row edge to edge with no vertical gutter, exactly as the platform does. The corner is the same continuous rounded rect: integrating sub-pixel coverage over the top-left 10×10, ours removes 15.44 px² focused and 13.56 px² unfocused, against 15.76 px² for Voice Memos and 16.97 px² for Finder — a radius of about 6, matched. The per-row inset ladder is the same shape too (row 0 inset 7, then 4, 3, 2, 1 on ours and on Finder).
>
> **Focused fill.** Ours is (23,139,251) in light and (25,148,252) in dark. Voice Memos, frontmost with its sidebar holding the keyboard, is (23,139,251) light and (25,148,252) dark. Both appearances are pixel-exact, including the fact that the dark accent is lifted (+9 in green) rather than reused from light — a thing that is easy to get wrong and that we got right.
>
> **Focused content.** Label and icon both go to pure white (255,255,255) on the accent fill, matching Voice Memos' white label and white icon in both appearances.
>
> **Unfocused content.** Label and icon both go to the accent blue, and the values are exact: (0,114,247) in light and (20,143,255) in dark, identical to Finder's "Documents" label and its blue document icon in the same state (frontmost window, sidebar not holding the keyboard). Keeping the icon tinted along with the label, rather than dropping it to secondary grey, is what Finder does and what we do.
>
> **Unfocused fill, dark.** (42,42,42) on a (28,28,28) material — a 14-level step. Finder dark: (42,42,42) on (28,28,28), the same 14-level step. Exact.
>
> **The one thing wrong: the unfocused fill in light appearance is about 3/255 short of separation.**
>
> Our light pill interior is a flat (239,239,238) on a (247,247,247) rail — an 8-level step. Finder's light pill interior is (239,239,238)/(239,239,239) on a (250,250,249)/(250,250,250) rail — an 11-level step. The pill value is *identical* to Finder's, but Finder's pill value is a composite over the tinted material, and ours sits on the untinted one, so we inherit the platform's flattened pixel without the material it was flattened against. Tinting does not explain this away: if the platform overlay is an alpha over the material, then removing a few levels of tint from the material removes them from the composite too and the step survives — solving for a black overlay at Finder's numbers gives alpha ≈ 0.044, which on a 247 material still yields a step of about 11, not 8. We are giving roughly three quarters of the platform's already-faint light-mode separation.
>
> Two details corroborate that this is a baked flat value rather than an overlay. First, Finder's pill interior is not one colour: it alternates (239,239,238) and (239,239,239) in roughly 2:1, which is the material's own dither surviving through a translucent fill. Ours is a single uniform value across all 1500 sampled interior pixels — opaque paint. Second, our light value carries a 1-level warm cast (B one below R and G) that a genuinely neutral overlay would not produce, but that a pixel lifted from a wallpaper-tinted capture would.
>
> The asymmetry is the tell: dark is exact and light is 3 short, which is what you would expect if both were sampled off captures and only the light one had enough tint in it to matter. The fix is to express the light unfocused fill as the overlay alpha over whatever material the rail is painting, not as a fixed sRGB triple, so the step stays at 11 regardless of the material underneath.
>
> Nothing else is wrong. Text centring, icon placement, row height, corner radius, insets, both focused fills, both unfocused label and icon colours, and the dark unfocused fill all read as the platform's.

## What was done with it

**The first reply's central finding does not survive its images.** It measures
our rail's fill as `(240,240,240)` light and `(20,20,20)` dark and concludes
the unfocused grey is a step wrong by 10× in light and 1.6× in dark. Those
are not the rail: the rail component does not paint its own fill — the
window's pane does — so in a render of the component alone what shows around
the rows is the golden harness's backdrop. Read off the composed window
instead, the rail is `#f7f7f7` light and `#1c1c1c` dark, flat over 36,000
sampled pixels in each, which is `SidebarMaterial`, the same chrome material
Finder's sidebar is. Against that the dark step was already the platform's to
the byte, not 1.6× it.

**The second reply's finding is right, and it is fixed.** In light the pill
stood 8 of 255 under the rail where the platform's stands 11, because the
grey was recorded as the pixel it reads on a capture whose rail carries
wallpaper tinting, and the library paints it on the untinted material. The
reviewer's own arithmetic — a black overlay at α ≈ 0.044 keeps the step at 11
on any rail — is the answer, and its other observation is the proof: Finder's
pill interior is not one colour but the rail's own dither carried through a
translucent fill.

That reading was taken column by column across the pill's middle row, and it
is decisive in both appearances:

| capture | rail | pill | columns |
| --- | --- | --- | --- |
| light | `#fafaf9` | `#efefee` | 123 |
| light | `#fafafa` | `#efefef` | 108 |
| dark | `#1c1c1c` | `#2a2a2a` | 164 |
| dark | `#1b1b1b` | `#292929` | 59 |

A fill that carries the rail's dither is translucent; an opaque paint would
flatten it. Black at 11/255 lands both light pairs and white at 16/255 both
dark ones, and 12/255 and 15/255 each miss one. So
`SidebarSelectionUnemphasized` is recorded as that coverage rather than as a
value, `patterns/sidebar` flattens it onto `SidebarMaterial` in encoded sRGB
(Gio would blend a translucent fill in linear light), and the pill lands
`#ececec` light and `#2a2a2a` dark — an 11 of 255 step in light and 14 in
dark, the steps the captures hold, on any rail. `reference/macos/controls.md`
carries the dither reading and the section's remaining open question, which
is the LABEL: it is opaque, it was read on a pill at `#efefee`, and it is now
drawn on one at `#ececec`.

**Everything both reviewers found right is unaffected**, and the second
confirms the first on all of it: the accent pill is `(23,139,251)` light and
`(25,148,252)` dark, bit-identical to Voice Memos' in both appearances; its
label and symbol are pure white as Voice Memos' are; the grey pill's label and
symbol are `(0,114,247)` and `(20,143,255)`, Finder's own values to the byte,
with the symbol tinted along with the label as Finder tints it; and the pill
is one rectangle in all four states — 32 tall, inset 10, cornered at 8, at the
32 dp row pitch — with only the fill and the foreground moving between them.

Pool items 733 to 737 carry what is left: that every other measured fill in
the reference recorded as a flat value over a tinted capture is open to the
same dither test, that the label was read on a pill the library no longer
paints, that mindchat's and feeds' rails take the keyboard by Tab alone, and
that vaultview's aside moved with the shared pill.
