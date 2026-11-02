# 005 · The four shops, the catalogue, and saving

## GOAL

The app knows Sabot's four shops and which sizes and colours each product comes in, and
keeps stock and reservations in the browser so they are still there when the page opens again.

## SCOPE

May write: `app/data.js` (new) and `app/test/data.test.html` (new).
May not write: any other file.

## CONTEXT

`openspec/changes/stock-across-shops/design.md`, agreed by the group: data in the browser (`localStorage`), starting data
in a JavaScript file; the four shops are Old town, Graslin, Île de Nantes, Chantenay;
staff set counts, so every count starts at 0. Scenario 3.3 in
`openspec/changes/stock-across-shops/specs/shop-stock/spec.md`. The starting catalogue: jacket in black and navy, sizes M
and L (from scenarios 1.1, 1.2); sandal in tan and black (from 3.3), sizes 38 and 39
(agreed). In `app/data.js`, a plain browser file: `SHOPS`, `CATALOGUE`,
`optionsFor(product)` returning `{ sizes, colours }`, `loadState(storage)` returning
`{ stock, reservations }` and `saveState(storage, state)`, where storage is anything with
`getItem` and `setItem` (`localStorage`, or a fake in the test), under one key.
Proof it is missing: `ls app/` does not list `data.js`. Depends on: ticket 004.

## ACCEPTANCE

- 3.3 · optionsFor("sandal") gives colours tan and black, never navy; optionsFor("jacket") gives black and navy, M and L.
- design · SHOPS lists Old town, Graslin, Île de Nantes and Chantenay, in that order.
- design · With nothing saved, loadState gives every count 0 and no reservations.
- design · After saveState with jacket black M at 2 in Graslin and one reservation, loadState from the same storage gives them back.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green. The new `app/test/data.test.html` prints one `ok` line per line above; it fails
before the change and passes after it, with every other test.

## FORBIDDEN

- The page: tickets 006 to 008.
- A server, a network call, or importing the old spreadsheets.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
