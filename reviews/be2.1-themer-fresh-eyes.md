# BE2.1 — fresh-eyes review of the tabbed themer window

2026-08-30. The reviewer was handed six 1x captures (one per tab per
scheme plus the code specimen) of the themer after BE2.1's tab
adoption, briefed on five recorded misreads, and asked what a
developer on this platform would complain about. Captures were at
/tmp/themer-be21/ (session-local). The worker relayed the reply
verbatim and fixed nothing — nothing was cheap and in scope.

## Verbatim reply

> Read all six at 1x and pixel-probed with PIL. Here is what a macOS developer would actually file, strongest first.
>
> ## 1. Half the window is a picker you use once
>
> The embedded preview starts at y=400. Everything above it — title row, the dropped-image card, the five seed candidate cards (y=166–306), the tab bar — is 400px of an 820px window that never scrolls and never changes, in all four tabs. The seed row is just as tall on the Markdown tab as on Theme, where it is irrelevant.
>
> What is left is a 425px viewport, and I measured the scroll thumbs at x=1012–1017 to size what is behind it:
>
> | tab | thumb height | implied content |
> |---|---|---|
> | Theme | 143px | ~1260px |
> | Markdown | 88px | ~2050px |
> | Components | 82px | ~2200px |
> | Code | 72px | ~2500px |
> | Patterns | 32px | ~5600px |
>
> Patterns is thirteen screenfuls read through a slot that is 52% of the window height. The complaint is not "add a scrollbar" — it is that the app spends its vertical budget on the step that is already finished and starves the step you came for. Collapsing the seed row after a pick would roughly double the preview.
>
> ## 2. The button state ladder never re-picks its ink
>
> Light Components, top row. Face darkens across states; the label stays pure black `#000000`:
>
> - Rest — face `#72A500`, ink `#000000`, **7.10:1**
> - Hover — face `#5A8300`, ink `#000000`, **4.68:1**
> - Press — face `#436300`, ink `#000000`, **3.02:1**
>
> Press fails AA for its size, and at 3.02:1 it is closer to the deliberately-muted Disabled chip (`#A9B2A0` on `#D1DCC7`, 1.54:1) than to Rest. The system clearly *can* re-pick: "Pinned" (`#B3261E`) gets white ink at 6.54:1, and in dark mode the red seed card's Aa bar flips to dark ink on pink. So on-primary is being resolved once against the base and then reused down the interaction ramp. A developer shipping this hits it the moment a user holds the mouse down.
>
> ## 3. The ghost register drops the brand entirely
>
> Same tab, row "the three emphasis registers at rest": Filled `#72A500`, Tonal `#B7FD3E`, then Ghost — label `#5C5C5C`, no fill, no border, no accent — next to a filled green icon square. Neutral grey text with no affordance in a row of green buttons reads as a caption or a disabled item, not the low-emphasis register.
>
> ## 4. The inline code chip's fill is a no-op
>
> Light Markdown: chip interior `#F8F8F8`, page `#F6F6F6`. Two values out of 255, 1.02:1. The only thing separating a code chip from prose is its 1px `#CACACA` outline and the mono face. Whatever surface token feeds that chip resolves to the page in light mode — a bug that will silently do nothing on every other component bound to the same token.
>
> ## 5. Two nested 6px scrollbars, 800px apart
>
> Dark Code tab: the "Syntax base" list says "42 dark bases", shows 8, and carries its own thumb at x=218–223 (39px of a ~208px track) inside a 205px-tall pane — which itself sits inside the page scroller whose thumb is at x=1014. Wheel position decides which one moves, and there is no filter field for 42 entries.
>
> ## 6. Dark mode has two contradictory error looks one scroll apart
>
> Dark Patterns: the four alerts are dark tinted plates with white ink (error `#48241E`, warning `#432710`, success `#1D3419`, info `#143048`). Scroll 100px and the toast is a near-white slab `#E8E8E8` with a `#8E1300` bar. An inverted snackbar is a defensible convention, but the same screen showing an error as dark-red-on-dark and as dark-on-white makes "what does an error look like" unanswerable.
>
> ## 7. The swatch you click is not the colour you get
>
> Seed card 2's large swatch is `#829F5E` (S≈41%); the theme it produces is `#72A500` (S=100%) — measured at the Primary base chip. Card 4 goes `#88B2C1` → `#00BAE5`. The small "Aa" bar under each swatch does show the derived colour, so it is disclosed, but the element you click and the element that dominates the card is the one that does not survive.
>
> Minor: the Focus button's ring is drawn 2px *inside* the face, `#304900` on `#72A500`, 3.41:1 — it passes, but at 1x the focus state is nearly indistinguishable from rest.

## Triage (the worker's, verified against its report)

Only finding 1 could have been caused by this task's shape, and it is
a fair reading of the new layout rather than a defect the tabs
introduced (the strip costs 52 dp). Findings 2, 3, 6 and the focus
note are the components/patterns modules' own inks, shown identically
in the documentation app; 4 is a markdown surface token; 5 predates
the task; 7 is the candidate card. Pooled as items 137–143.
