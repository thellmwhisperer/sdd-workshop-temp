# 008 · The page: reservations, collect and cancel

## GOAL

Below the shops, staff see every active reservation and when it ends, and can mark it
collected or cancel it, so no reservation is forgotten on a sticky note.

## SCOPE

May write: `app/page.js` and `app/test/page-reservations.test.html` (new).
May not write: any other file.

## CONTEXT

Requirements "A reservation lasts 48 hours" (scenario 6.3) and "A reservation can be
collected or cancelled" in `openspec/changes/stock-across-shops/specs/reservations/spec.md`. `DOMAIN.md`, decisions 2 and
4: 48 hours, one page. `isActive` is in `app/stock.js`; `collect` and `cancel` in
`app/reservations.js`; `saveState` in `app/data.js`; `startPage` in `app/page.js`
(tickets 006, 007). The end time is `madeAt` plus 48 hours. Proof it is missing: the page
lists no reservations. Depends on: ticket 007.

## ACCEPTANCE

- 6.3 · An active reservation shows the customer's name, the variant, the shop, the units and when it ends.
- 7.1 · Marking a reservation of 1 collected, in a shop with 2 in stock, removes it from the list and the shop has 1 in stock.
- 7.2 · Cancelling a reservation of 1 in a shop showing 1 free removes it from the list, and the shop shows 2 free.
- 6.2 · A reservation made 48 hours before now is not in the list, and offers no collect button.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/page-reservations.test.html` prints one `ok` line per
scenario above; it fails before the change and passes after it, with every other test.

## FORBIDDEN

- Anything out of the change: online customers, tills, moving stock between shops, importing spreadsheets.
- Business rules inside `page.js`.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
