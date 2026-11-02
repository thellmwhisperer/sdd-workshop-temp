# 002 · Free units, and reservations that end after 48 hours

## GOAL

For a variant in a shop, staff see how many units are really free: what is in stock minus
what active reservations hold. A reservation stops holding units 48 hours after it was made.

## SCOPE

May write: `app/stock.js` and `app/test/free.test.html` (new).
May not write: any other file.

## CONTEXT

Requirement "Free units are stock minus what is reserved" in `openspec/changes/stock-across-shops/specs/shop-stock/spec.md`,
and requirement "A reservation lasts 48 hours" (scenarios 6.1, 6.2) in
`openspec/changes/stock-across-shops/specs/reservations/spec.md`. `DOMAIN.md`, decision 2: 48 hours. `openspec/changes/stock-across-shops/design.md`:
time is an argument, "now", so a test says "48 hours later" without waiting.
A reservation is `{ id, shop, product, size, colour, units, customer, madeAt, status }`,
`madeAt` and `now` in milliseconds, `status` one of `"active"`, `"collected"`,
`"cancelled"`. Add to `app/stock.js`: `isActive(reservation, now)`: status is
`"active"` and less than 48 hours have passed since `madeAt`;
`freeUnits(stock, reservations, shop, variant, now)`: `countOf` minus the units of the
active reservations of that shop and variant. Proof it is missing: `freeUnits` is not in
`app/stock.js`. Depends on: ticket 001.

## ACCEPTANCE

- 2.1 · Old town has 3 jacket black M and an active reservation of 1: freeUnits gives 2.
- 2.2 · Old town has 3 jacket black M and no reservation: freeUnits gives 3.
- 6.1 · A reservation of 1 made 47 hours 59 minutes before now is still active: freeUnits gives 2 of 3.
- 6.2 · A reservation of 1 made 48 hours before now, not collected, is no longer active: freeUnits gives 3 of 3.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/free.test.html` prints one `ok` line per scenario above; it
fails before the change and passes after it, with every other test.

## FORBIDDEN

- Making reservations, collecting, cancelling, saving, or the page: tickets 003 to 008.
- Reading the clock inside a rule: `now` is always passed in.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
