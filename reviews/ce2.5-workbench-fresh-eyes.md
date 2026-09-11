---
date: 2026-09-11
task: CE2.5
phase: CE
reviewer-model: claude-opus-5
reviewer-effort: unrecorded
---

# CE2.5 — vaultview, mindchat and feeds, read cold

Six whole-window renders — each app in both appearances, drawn offscreen at
the size its window opens at — handed to an agent that had not seen the task,
with no checklist and one question: what would a developer on this platform
complain about?

## What came back, verbatim

> Six windows, read cold. Worst first.
>
> **1. Feeds is a web page.** Bottom-center pagination `◀ 1 2 ▶` (x≈220–320,
> y≈771) with a blue filled "1" chip is an HTML pager. No Mac list paginates —
> it scrolls. Above it, "Add feed" and "Share" (top-right, y≈15) are blue text
> links, not toolbar buttons; "Reader / Raw / Comments" (y≈114) is an
> underline-indicator tab bar, where AppKit would use a segmented control.
> Three web idioms in one window.
>
> **2. No window chrome on Feeds or VaultView.** Square corners, a hairline
> border, zero traffic lights, and a fake 28px title strip holding bare text
> ("Feeds", "Second Brain"). MindChat has traffic lights — so the suite is
> inconsistent with itself. Worse, mindchat-light has *no* title text while
> mindchat-dark shows "Reactive layouts" at x≈260. Same window, different
> title bar.
>
> **3. Always-on scrollbars.** VaultView's vertical bar at x≈768 is painted
> full-height, and the code block has a permanent horizontal bar under
> `func main()`. macOS overlay scrollbars are invisible until you scroll. This
> alone reads as GTK/Windows.
>
> **4. Selection is a full-bleed rectangle, everywhere, always.** Sidebar rows
> fill edge-to-edge in saturated blue with white bold text; macOS draws an
> inset rounded capsule. VaultView shows *two* blue selections simultaneously
> (sidebar "Reading list" and Outline "Reading list") — the platform allows one
> focused selection; the unfocused pane greys out. Nothing greys here: these
> windows are never key, yet every accent stays vivid. And the blue is
> identical in light and dark, ignoring both the dark systemBlue variant and
> the user's accent colour.
>
> **5. Dark mode is black, not Dark Aurora.** Feeds dark sits near #0d0d0d with
> sidebar, list and content all the same value — no material, no vibrancy, no
> sidebar/content separation. The light-mode zebra striping carries over as
> high-contrast grey bands on black, which macOS never does.
>
> **6. Light mode has the sidebar backwards.** VaultView's left sidebar is
> white and the right inspector is grey. macOS: grey vibrant sidebar, white
> content.
>
> **7. Controls are unstyled boxes.** "Filter articles", "Find a note…", "Send
> a message" are 1px-bordered rectangles with near-square corners; the filter
> field has no magnifier glyph. No focus ring appears on any of them.
> VaultView's "Rescan"/"Switch Vault" are bare text, not push buttons.
> MindChat's "OpenAI · gpt-5.5 ⌄" uses a single chevron in a plain bezel
> instead of a pop-up button's tinted double chevron.
>
> **8. VaultView's body is a rendered README** — heavy web headings, underlined
> inline hyperlinks, generous article leading. Typography reads Inter/Roboto,
> not SF.
>
> Right: MindChat's reading rhythm, the code-block treatment, and the
> three-pane proportions are all credible.

## What was acted on

Nothing in this round. Every complaint is either already carried by a later
task or a misread of the instrument, and none is cheap and in this task's
scope.

**5 and 6 are one finding, and it is the known one.** The chrome material is
still the tinted `#ffffff` / `#232a2e` recording, so the light chrome IS the
content's white and the dark chrome sits lighter than the content instead of
darker. The untinted readings — `#f7f7f7` over `#ffffff` light and `#1c1c1c`
over `#1e1e1e` dark, a shade darker than the content in both — are measured
and recorded in ADR-019 by this task; re-recording the token moves pixels in
components, patterns, effects, design and sitedocs at once, and CE2.7 carries
it. Until then the reviewer is right and the window is wrong.

**4 is half right.** A sidebar row IS an inset rounded pill here — the tree
rail and the conversation rail both draw it — and what the reviewer read as
full-bleed is the outline pane's and the article table's selected row, which
is a content list's row and full-bleed on the platform. The rest of the item
is a real gap and not this task's: nothing in these windows knows whether its
window is frontmost, so the unemphasized selection the pattern can draw is
never asked for. That the accent is the same blue in both appearances is not a
defect: `controlAccentColor` reports `#007aff` in aqua and darkAqua alike,
which the catalogue records.

**1, 2, 7 and 8 are CE3.2's**, "The workbench looks like a Mac": the pager,
the tab strip, the plain fields and the text actions are shapes rather than
colours, the title bars are the window chrome these offscreen renders do not
draw at all, and the typeface is settled and not this phase's to move.

**3 is the scrollbar's own** — the overlay bar's summoning, not its colour.

## Recorded misreads, for the next reviewer's packet

- These renders are the window's content layers alone. There is no title bar,
  no traffic lights and no rounded window corner in them, and their absence is
  the instrument, not the application.
- The accent does not change between appearances on this platform.
- A striped list is what Finder draws; the alternate row is measured.
- The typeface is deliberately not the system's.
