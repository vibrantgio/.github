# AU2.2 fresh-eyes review — the feeds window, both schemes

Captured live with `screencapture -l` off the real decorated window
(1200x800 at the window's own origin), a feed chosen in the sidebar and
an article open in the reading pane, dark from the machine's own
appearance and light after flipping the system appearance and restoring
it. Images: `/tmp/workbench-run/feeds-light.png`,
`/tmp/workbench-run/feeds-dark.png`.

Handed to a fresh subagent that had not seen the packet, with no
checklist and one question: *what would a developer on this platform
complain about?*

## The reply, verbatim

I read both. Here's the honest version of what a macOS developer would say, and nearly every item is a variant of one root complaint: this was designed once and then themed twice, rather than built against AppKit.

**The dark appearance is an inversion, not a second design.** The tell is the depth order. In light mode the sidebar is a grey step *darker* than the white content — correct. In dark mode the same rule was applied, so the sidebar is near-black and *darker* than the content panes. On macOS the sidebar is a translucent material that sits *lighter* than the window body in dark mode; it never recedes below it. The same mechanical flip breaks everything defined as "dark ink at low alpha": the divider between the list and the detail pane is crisp in light and nearly gone in dark, the row separators dissolve, and the search field — a white well with a grey border in light — becomes a black rectangle on a black pane, so it stops reading as a well at all. Dark mode needs light-at-low-alpha for those, not the same token.

The selection makes the same mistake in the other direction. Light selection is a pale accent tint; dark selection is a deep, saturated purple. That's the signature of blending a fixed accent against the background at fixed alpha. macOS scales its highlight the opposite way — the dark-mode highlight is *lighter* and less saturated than you'd get from a naive blend, precisely so it doesn't sink into the window. Right now the dark selected row reads as a hole rather than a highlight.

**The accent is hardcoded purple.** macOS users pick an accent and a highlight colour in System Settings, and native apps follow `controlAccentColor`. Someone running Graphite, or blue, sees purple anyway. A developer will notice this within about four seconds, because it's the cheapest possible native-ness check.

**Nothing indicates keyboard focus.** Two things are drawn as selected simultaneously — "Go Blog" in the sidebar and the first table row — with equal visual weight, so you cannot tell which pane owns the keyboard. macOS solves this with a focused/unfocused selection pair: the active list keeps the accent fill, the inactive one drops to grey. There's also no focus ring anywhere, which raises the follow-on question of whether Tab traversal and Full Keyboard Access work at all.

**Several controls simply don't exist on this platform.** Pagination is the loudest: a list of ten rows with roughly 250 points of empty space beneath it, followed by prev/1/2/next buttons. No Mac app paginates a list — Mail, NetNewsWire, and Reeder all scroll, and here there's literally room on screen for the rest of the items. Right behind it: the underline tab bar (Reader/Raw/Comments) should be an `NSSegmentedControl`, usually centred in the toolbar; "Add feed" and "Share" as bare accent-coloured text links should be toolbar icon buttons, with Share being the system share button that raises `NSSharingServicePicker`; and "Filter articles" should be an `NSSearchField` with a magnifying glass, a clear button, and the placeholder "Search" — probably living in that conspicuously empty middle stretch of the toolbar.

**The table gives up everything `NSTableView` provides for free.** Columns look fixed-width and non-resizable, non-reorderable, with no header context menu to toggle them — and the consequence is visible: Author is wide enough for a much longer string while every value is the identical "The Go Team", and Title, the only column carrying information, is the one truncating with an ellipsis. The sort indicator next to "Published" is a large filled caret floating well away from its label; the native one is a small triangle tight to the right edge of the sorted column's cell, with the column itself subtly highlighted. The unlabelled fourth column of tiny dots has no header, no hover state, and a hit target of a few points. And a developer will immediately clock that those dots land on rows 1, 4, 7, and 10 — that's `i % 3 == 0`, not data.

**The metrics and typeface read cross-platform.** That isn't San Francisco, body text is running large for macOS, and the table rows are noticeably taller than native. Combined with the total absence of vibrancy — nothing here is translucent, the sidebar and toolbar show no desktop through them — the overall impression a Mac developer forms is "Electron or a game-style toolkit," even if it isn't.

**Then the small stuff that signals nobody did a pass.** The table says "May 13 2026" and the body of the same article says "May 13, 2026" — inconsistent within a single screenshot, and neither is locale-formatted or relative, where macOS convention is a time for today, "Yesterday", then a date, all through the user's Date &amp; Time settings. Contrast on secondary text in dark mode — column headers, the byline, the placeholder — is dim enough to be worth measuring. And the detail pane is displaying internal fixture prose that names a phase number and describes what would constitute a defect; if this screenshot ever goes near a README, that's the first thing someone will point at.

The fair counterpoint is that most of this is convention rather than correctness, and a cross-platform app is entitled to its own identity. The two changes with no defence are the dark-mode depth inversion and the vanishing dividers, because those aren't stylistic choices — they're a light design run through a transform that doesn't hold. Fix those, honour the system accent, and give the focused pane a distinct selection, and the remaining complaints drop from "this is wrong" to "this isn't native, and that's fine."
