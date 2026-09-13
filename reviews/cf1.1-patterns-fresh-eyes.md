---
date: 2026-09-13
task: CF1.1
phase: CF
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CF1.1 — the patterns, read cold

## The reply, verbatim

I read all 16 patterns in both appearances and all 12 macOS captures, and sampled pixels off both sets. Here is what I found.

---

## First, what is actually right — so the rest is calibrated

Three things match the real captures to the digit, and I want them on the record before I start complaining.

**The sidebar material.** The expanded sidebar is `(247,247,247)` against a `(255,255,255)` page in light, and `(28,28,28)` against `(30,30,30)` in dark. Finder untinted is `(247,247,247)`/`(255,255,255)` and `(28,28,28)`/`(30,30,30)`. That is not close, that is the same numbers.

**The selection pill.** Render `(24,139,251)` light, `(25,148,252)` dark. Voice Memos' selected "Cura Informalis" row: `(23,139,251)` light, `(25,148,252)` dark. Exact, including the fact that it gets *lighter* in dark mode the way the platform's does.

**The table's alternating rows.** Render `(255,255,255)`/`(244,245,245)` light and `(30,30,30)`/`(41,41,41)` dark. Finder's list view: identical pairs — `(244,245,245)` is 25.9% of the whole light Finder capture and `(41,41,41)` is 23.4% of the dark one.

So the palette work is real. The problems are all in what was *built out of* it.

---

## Redundant

**Card, Group and the recommended pricing tier are one control.** I measured the Card's fill at `(247,247,247)` light / `(42,48,52)` dark. The Testimonial's box: same two values. The middle pricing tier's box: same two values. The Group is the same rounded rectangle with the fill omitted and a `(230,230,230)`/`(52,52,52)` hairline instead. That is one box with a fill switch, presented as four patterns.

**Navbar and Tabs are the same control drawn twice, badly.** Both are a horizontal row of words with a blue underline under the selected one. Both use the same blue — `(0,100,225)` light, `(0,89,209)` dark. The only difference I could measure is the thickness: the Tabs underline is 2 px (rows y=74 and y=75), the Navbar's is 1 px (row y=78 only). Two patterns, one idea, and they disagree on a detail nobody chose.

**Hero, Feature grid, Pricing and Testimonial are a marketing web page, not an application.** Four of sixteen patterns are landing-page sections. Nothing in Finder, Mail, Notes or Voice Memos has an eyebrow, a headline with a pair of calls to action, a three-column icon-and-blurb grid, a price table, or a pull quote with an avatar. They are redundant with each other (all four are "a centred block of marketing copy") and redundant with the browser, which is where a Mac user meets them.

**The Notifications column duplicates what the OS owns.** A stack of four toasts is Notification Center's job. A Mac app posts a `UNNotification` and the system draws it, top-right, over every app, with the app's icon and the system's own material. An in-window toast column competes with that and loses.

**The collapsed rail duplicates the sidebar.** The Sidebar pattern shows an expanded list beside a 48-px rail of unlabelled dots. Every real window here — Finder, Mail, Notes, Voice Memos — has exactly one sidebar affordance: a toggle in the toolbar that hides the sidebar outright (Mail's is at x=309, Voice Memos' at x=261, Notes has two at x=162 and x=205). There is no icon-only rail state on this platform. The rail is a second sidebar that says less.

---

## Missing

**A toolbar.** This is the big one. Not one of the sixteen patterns is a toolbar, and every single real window is organised around one. In Finder untinted light the toolbar band runs from the window top to the column-header rule at y=105, and — this is the part the Shell gets structurally wrong — the sidebar material continues *up into it*: I sampled `(200,52)` in the toolbar over the sidebar and got `(247,247,247)`, while `(700,52)` over the content is `(255,255,255)`. The Mac window is columns that run top to bottom. The Shell instead lays a full-width `(247,247,247)` navbar band across y=52..78 with a `(223,223,223)` rule at y=79 and starts its three columns *below* it. That is a web page header, and it is the one arrangement AppKit does not make.

**A search field.** Finder, Mail, Notes and Voice Memos all have one, in the toolbar, always. Voice Memos' is a capsule of `(232,232,232)` spanning y=46..81 — about 36 pt tall in a ~48 pt band. Nothing in the pattern set puts search anywhere.

**Sidebar section headers and counts.** Finder's source list has "Favourites", "Locations", "Tags". Voice Memos has "My Folders" plus a trailing count on every row — 108, 8, 40, 16, 35, 1, 1, 3, 1. The render's sidebar is four flat items, no grouping, no counts. A source list with more than a handful of entries is unreadable without them.

**Title bar and window controls.** No pattern includes them. Every capture has them, and on macOS they are not decoration — the traffic lights, the title, the proxy icon and the toolbar are one unified band, and the Shell has to be designed around that band or it cannot be a window.

**A sheet.** See below; the Modal is standing in for one and is the wrong shape.

**Any not-key state.** Every render shows a focused window. Finder's unfocused sidebar selection is `(239,239,239)` light / `(42,42,42)` dark — the blue drains out entirely when the window loses key. A Mac app spends a lot of its life in that state and the pattern set has no picture of it.

---

## Wrong for the platform

**The Pane's backdrop, `(161,161,161)`.** I histogrammed all five light captures. The six most common colours in each are all between 239 and 255 — the *darkest* large flat field the platform paints in a light window is Finder's unfocused selection at `(239,239,239)`. The Pane surrounds its chrome with a field 78 levels below that and sets body text `(39,39,39)` directly on it. And the direction reverses between appearances: light backdrop `(161,161,161)` is 94 levels *below* the content, dark backdrop `(40,40,40)` is 10 levels *above* it. Whatever rule produced those two numbers, it isn't one rule.

**The Modal's scrim, `(205,205,205)`.** Same argument — 34 levels below anything the platform paints — but the deeper problem is the gesture. A document-scoped decision on macOS is a sheet: it slides down from the title bar, stays attached to the window, and dims nothing. A centred floating dialog over a dimmed page is the web's `<dialog>` and iOS's alert. The second panel is worse: "Theme settings", closed by an ✕ glyph at its top-right corner. Mac panels are closed by the red traffic light in their own title bar. An ✕ inside the content area is a web modal tell.

**The dark Card's blue cast — applied to the wrong surface.** The Card is `(42,48,52)` in dark, a 10-level blue spread, while its light twin is dead neutral `(247,247,247)`. Now, the platform genuinely does tint: Mail's dark sidebar is `(35,42,46)` (40.9% of that capture) and Notes' is `(28,33,35)` with its note list at `(35,42,45)`. But look at what gets tinted — the *chrome columns*. Notes' actual content area is neutral `(30,30,30)`, 37.9% of the capture. The renders do it backwards: sidebar neutral `(28,28,28)`, content card tinted `(42,48,52)`. The tint is on the one surface the platform leaves alone.

**Four different blues doing one job.** Primary buttons `(0,122,255)`, sidebar selection `(24,139,251)`/`(25,148,252)`, tab and navbar underline `(0,100,225)`/`(0,89,209)`, info toast `(0,136,255)`/`(0,145,255)`. Worse, they don't agree on which way to move between appearances: the selection pill lightens the way Voice Memos' does, the primary button is frozen at `(0,122,255)` in both, and the tab underline gets *darker* in dark mode. On the platform there is one accent, it is user-set, and it moves one way.

**Underline tabs.** macOS has no underlined tab. It has the segmented control — a capsule of joined segments with the selected one filled. An underlined word row is Material Design and web nav, and it appears here twice (Tabs, Navbar).

**The rainbow source-list icons.** I counted saturated pixels (max−min channel > 40) in the sidebar icon columns. Finder light: **zero**. Finder dark: **zero** — the icons are pure monochrome. Voice Memos light: 514 pixels, all one hue, `(23,139,251)`, the accent. The render's sidebar uses four hues in four rows — `(97,85,245)` purple, `(0,195,208)` cyan, `(52,199,89)` green, plus blue — and repeats the same four as the Feature grid's dots. Multi-hue colour-coded list icons are a web-app convention; a Mac source list is monochrome or accent-tinted, full stop.

**The toast is invisible in dark mode.** The toast's fill is `(30,30,30)` — byte-identical to the page behind it. It's separated by a shadow only, and I measured that shadow: it dips to `(27,27,27)` at its darkest, a 3-level step. In light the same shadow dips 255→237, 18 levels. So the dark toast is a floating notification separated from its background by roughly one percent of the range. The Popover, meanwhile, draws a real 1-px border — `(234,234,234)` light, `(42,42,42)` dark — so two floating surfaces in the same system disagree about whether floating surfaces have edges.

**The Shell's two dividers disagree.** Sidebar-to-content is 1 px, `(223,223,223)` light / `(50,50,50)` dark. Content-to-aside is a **6 px** band of `(230,230,230)` — x=558 through 563, constant at y=100, 200 and 290. For reference, Finder light draws *no* divider at all (247 steps straight to 255 at x=352), and Finder dark draws exactly 1 px of `(67,67,67)`. A 6-pt grey band down the middle of a window is not a thing the platform does.

**The Table's stripe stops short.** The zebra colours are perfect, but the striped band ends at x≈425 — I sampled `(440,101)` and `(500,101)` and got `(255,255,255)`. Finder's stripe runs the full width of the list: I read `(244,245,245)` at x=370, 700, 1000 *and* 1340 on the same row. A stripe that stops where the last column's text happens to end reads as a ragged block of shading rather than a row.

**The Table's sort indicator is a filled triangle.** Finder's is a thin chevron at the trailing edge of the sorted column's header. The placement in the render is right; the glyph is a solid ▲, which is the pre-Yosemite shape.

**The open accordion section reserves a fixed slot.** Measured ink bands in the light accordion: header at y=70–82, its body text at y=103–115, then nothing until the next header's ink at y=214. That's 98 px of empty white inside the open section. The two closed rows are 48 px apart. The panel isn't hugging its content, it's holding a fixed height — so a one-line section leaves a hole the size of two more sections. Separately, the rule at y=99 sits between the open header and its *own* body, while the rule at y=243 sits between two *different* closed sections. Same line, two different meanings.

**The Hero headline is bigger than anything on the platform.** Its ink measures 34 px tall (ascender to descender). The largest type in any capture is Voice Memos' "No Recording Selected" empty state at 23 px, and that is a full-window placeholder. A 40-pt marketing headline inside an app window has no macOS precedent.

**The "v1" badge.** A `(142,142,147)` light / `(152,152,157)` dark grey capsule with white text, parked at the right end of the navbar. Voice Memos shows its counts as plain grey numerals with no capsule at all. The only filled capsule macOS uses in this position is an unread count. A version string is developer furniture that shipped into the chrome.

## How it was asked

Thirty-two offscreen renders at 1 px per point, one per gallery section in
each appearance: `patterns-accordion`, `patterns-card`, `patterns-group`,
`patterns-hero`, `patterns-feature`, `patterns-pricing`,
`patterns-testimonial`, `patterns-modal`, `patterns-popover`,
`patterns-navbar`, `patterns-tabs`, `patterns-sidebar`, `patterns-pane`,
`patterns-shell`, `patterns-table` and `patterns-notifications`, light and
dark, each drawn with its own heading above it on the appearance's window
plane.

Beside them, twelve stored captures of this machine's own system:
`finder-window-untinted-{light,dark}.png`, `finder-window-light.png`,
`finder-sidebar-unfocused-{light,dark}.png`, `mail-window-light.png`,
`mail-window.png`, `mail-toolbar-band.png`, `notes-window.png`,
`notes-toolbar.png` and `voicememos-sidebar-{light,dark}.png`.

The reviewer had seen neither the plan nor the packet, was given no
checklist, was told to compare against the captures and never against macOS
from memory, was handed the recorded misreads verbatim, and was asked the one
question of this task.
