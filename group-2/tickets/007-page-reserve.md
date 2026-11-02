# 007 · The page: reserve for a customer

## GOAL

From the shop list on the page, staff reserve units in any shop for a named customer, and
the page says plainly why when it refuses.

## SCOPE

May write: `app/page.js` and `app/test/page-reserve.test.html` (new).
May not write: any other file.

## CONTEXT

Requirements "Any staff member can reserve for a customer" and "A reservation never takes
stock below zero" in `openspec/changes/stock-across-shops/specs/reservations/spec.md`. `DOMAIN.md`, decisions 3 and 4.
`reserve` is in `app/reservations.js`; the page calls it, shows its Error message when it
throws, and saves with `saveState` when it succeeds. `startPage` is in `app/page.js`
(ticket 006); the test page calls it with a fake storage and a fixed `now`.
Proof it is missing: the page has no way to reserve. Depends on: ticket 006.

## ACCEPTANCE

- 4.1 · With 2 free jacket black M in Graslin, reserving 1 for "Claire Martin" shows Graslin with 1 free.
- 4.2 · Nothing on the page asks for a manager or a login.
- 4.3 · Reserving with no customer name shows a message that the name is missing, and Graslin still shows 2 free.
- 5.1 · Reserving 3 where 2 are free shows a message that only 2 are free, and Graslin still shows 2.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/page-reserve.test.html` prints one `ok` line per scenario
above; it fails before the change and passes after it, with every other test.

## FORBIDDEN

- The reservations list, collect and cancel (ticket 008).
- Business rules inside `page.js`. Logins, roles or manager codes.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
