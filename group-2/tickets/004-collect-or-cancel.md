# 004 · Collect or cancel a reservation

## GOAL

When the customer picks up, staff mark the reservation collected and the units leave the
stock; when the customer changes their mind, staff cancel it and the units are free again.

## SCOPE

May write: `app/reservations.js` and `app/test/collect.test.html` (new).
May not write: any other file.

## CONTEXT

Requirement "A reservation can be collected or cancelled" in
`openspec/changes/stock-across-shops/specs/reservations/spec.md`, agreed by the group. `isActive`, `setCount`,
`countOf` and `freeUnits` are in `app/stock.js`; `reserve` in `app/reservations.js`.
Add to `app/reservations.js`: `collect(stock, reservations, id, now)` returns
`{ stock, reservations }` with the reservation's units taken out of its shop's stock and
its status `"collected"`; `cancel(reservations, id, now)` returns the list with its status
`"cancelled"`. Both throw an Error when the reservation is not active. Proof it is
missing: `collect` is not in `app/reservations.js`. Depends on: ticket 003.

## ACCEPTANCE

- 7.1 · Graslin has 2 jacket black M and a reservation of 1; collecting it ends the reservation, countOf gives 1, and freeUnits stays 1.
- 7.2 · Graslin shows 1 free with a reservation of 1; cancelling it ends the reservation, and freeUnits gives 2.
- 7.3 · Collecting a reservation that expired (48 hours old) or was cancelled throws, and the stock does not change.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/collect.test.html` prints one `ok` line per scenario 7.1 to
7.3; it fails before the change and passes after it, with every other test.

## FORBIDDEN

- Saving and the page: tickets 005 to 008.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
