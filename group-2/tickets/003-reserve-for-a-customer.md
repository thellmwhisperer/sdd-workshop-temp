# 003 · Reserve for a customer, never more than is free

## GOAL

Any member of staff can hold units of a variant, in any of the four shops, for a named
customer, so the customer leaves with a reservation instead of walking out; and a
reservation never promises a unit the shop does not have: more than free, or zero units,
is refused and changes nothing.

## SCOPE

May write: `app/reservations.js` (new) and `app/test/reserve.test.html` (new).
May not write: any other file, `app/stock.js` included.

## CONTEXT

Requirements "Any staff member can reserve for a customer" and "A reservation never takes
stock below zero" in `openspec/changes/stock-across-shops/specs/reservations/spec.md`.
`DOMAIN.md`, decision 3: any staff member can reserve, no manager. The reservation shape
and `freeUnits` are in `app/stock.js` (ticket 002).
In `app/reservations.js`, a plain browser file: `reserve(stock, reservations, request, now)`,
where request is `{ shop, product, size, colour, units, customer }`. It returns a new
list with the reservation added (a new unique `id`, `madeAt: now`, `status: "active"`),
or throws an Error whose message says what is wrong, and the list is left unchanged.
Nothing in the request names a role.
Proof it is missing: `ls app/` does not list `reservations.js`. Depends on: ticket 002.

## ACCEPTANCE

- 4.1 · Graslin has 2 free jacket black M; reserving 1 there for "Claire Martin" adds a reservation for Claire Martin, and freeUnits in Graslin gives 1.
- 4.2 · A request with no manager or role in it is reserved, and nothing asks for one.
- 4.3 · A request with an empty customer name throws an Error saying the name is missing, and the list is unchanged.
- 5.1 · Graslin has 2 free jacket black M; reserving 3 throws an Error whose message says only 2 are free, and freeUnits still gives 2.
- 5.2 · Graslin has 2 free; reserving 2 is accepted, and freeUnits gives 0.
- 5.3 · Reserving 0 units throws, and the list is unchanged.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/reserve.test.html` loads `check.js`, `../stock.js` and
`../reservations.js` and prints one `ok` line per scenario 4.1 to 4.3 and 5.1 to 5.3; it
fails before the change and passes after it, with every other test.

## FORBIDDEN

- Collect and cancel (ticket 004), saving, the page.
- Logins, roles or manager codes.
- Changing what tickets 001 and 002 already pass.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
