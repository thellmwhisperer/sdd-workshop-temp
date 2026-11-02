# 006 · The page: one variant in every shop

## GOAL

On one page, staff pick a product, a size and a colour, and see the four shops with their
free units, so nobody phones another shop to ask. Staff can set the count for a shop there.

## SCOPE

May write: `app/index.html`, `app/page.js` (new) and `app/test/page-shops.test.html` (new).
May not write: `app/stock.js`, `app/reservations.js`, `app/data.js`, or any other file.

## CONTEXT

Requirement "One page shows a variant in every shop" in `openspec/changes/stock-across-shops/specs/shop-stock/spec.md`,
and scenario 1.3. `DOMAIN.md`, decision 4: one page. `openspec/changes/stock-across-shops/design.md`: the page only shows
what the rules return. Rules in `app/stock.js` and `app/reservations.js`, data in
`app/data.js`. `app/page.js`, a plain browser file, has `startPage(root, storage, now)`
that builds the page inside `root`; `app/index.html` keeps its title and heading, loads
the four scripts and calls it with its element, `localStorage` and `Date.now`. The test
page loads the same scripts and calls `startPage` on an element of its own, with a fake
storage (a file:// page cannot read another one in an iframe). Proof it is missing:
`app/index.html` has only its title and heading. Depends on: ticket 005.

## ACCEPTANCE

- 3.1 · Picking jacket, black, M lists the four shops, each with its free units of jacket black M.
- 3.2 · A shop with 0 free is listed with 0, and offers no way to reserve from it.
- 3.3 · After picking sandal, the colour choice offers tan and black only.
- 1.3 · Setting a count of -1 for a shop shows a message, and the shop's number does not change.

## VERIFY

From `group-2`: `sh app/check.sh test`, `sh app/check.sh lint`, `sh app/check.sh typecheck`,
all green, `app/test/page.test.sh` included. The new `app/test/page-shops.test.html`
prints one `ok` line per scenario above; it fails before the change and passes after it.

## FORBIDDEN

- The reserve form (ticket 007) and the reservations list (ticket 008).
- Business rules inside `page.js`: it calls the rules, it does not repeat them.
- No new dependency, no Node, no module, no build step. Weakening or deleting a test.

## REPORT

done or blocked; the files you changed; the names of the tests that ran; the
`sh app/check.sh test` output.
