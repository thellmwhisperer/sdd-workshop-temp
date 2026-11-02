# 001 · Stock per variant

## GOAL

Each shop keeps its stock per product, size and colour, so staff see "2 black M" rather
than "3 jackets", and a count can never be set below zero.

## SCOPE

May write: `app/stock.js` (new) and `app/test/stock.test.html` (new).
May not write: any other file; not `app/index.html`, `graph/`, `openspec/`, `tickets/`, `DOMAIN.md`.

## CONTEXT

Requirement "Stock is counted per variant and per shop" in `openspec/changes/stock-across-shops/specs/shop-stock/spec.md`.
`DOMAIN.md`, decision 1: the unit of stock is each product per size and colour.
`openspec/changes/stock-across-shops/design.md`: rules are plain functions with no screen; staff set counts (agreed).
A variant is `{ product, size, colour }`, a shop is its name. In `app/stock.js`, as plain
browser functions (no module): `emptyStock()` returns a stock with nothing set;
`setCount(stock, shop, variant, n)` returns a new stock with that count, or throws an
Error when n is below zero; `countOf(stock, shop, variant)` returns the count, 0 when
never set. Proof it is missing: `ls app/` does not list `stock.js`.
Depends on: none, it is the first ticket.

## ACCEPTANCE

- 1.1 · Old town has 2 jacket black M and 1 jacket black L: countOf gives 2 for black M and 1 for black L, not 3.
- 1.2 · Old town has 1 jacket black M and 0 jacket navy M: countOf gives 1 for black M and 0 for navy M.
- 1.3 · Setting jacket black M in Old town to -1 throws, and the count stays as it was.

## VERIFY

From `group-2`: `sh app/check.sh test`, then `sh app/check.sh lint` and
`sh app/check.sh typecheck`, all green. The new `app/test/stock.test.html` loads
`check.js` and `../stock.js` and prints one `ok` line per scenario 1.1 to 1.3; it fails
before the change and passes after it, with every other test.

## FORBIDDEN

- Reservations, free units, saving, or the page: tickets 002 to 008.
- No new dependency, no Node, no module, no build step.
- Weakening, skipping or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
