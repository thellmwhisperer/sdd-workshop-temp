# Proposal

## Why

Sabot's four shops in Nantes each keep stock in their own spreadsheet. When a customer asks
for a size a shop does not have, staff phone the other shops one by one: about 9 calls a
day per shop, 4 minutes each, and 23 sales lost last month waiting for an answer. Units put
aside live on sticky notes, and 3 in 10 are never collected. Hélène wants one page, open in
all four shops before the spring collection arrives in March, so that a customer asking for
a size in another shop leaves with a reservation instead of walking out.

## What Changes

- Stock is kept per product, size and colour (a variant), per shop, for the four shops
  (decision 1).
- One page shows, for a variant, how many units each of the four shops has free.
- Any staff member can reserve units of a variant in any shop for a customer (decision 3).
- A reservation lasts 48 hours; when it runs out uncollected, its units are free again
  (decision 2).
- Stock never goes below zero: a reservation for more units than a shop has free is refused.
- A reservation can be marked collected, which takes its units out of the shop's
  stock, or cancelled, which frees them.

Out: online customers, payments and the tills, moving stock between shops, importing the old
spreadsheets.

## Capabilities

### New Capabilities
- `shop-stock`: the stock of every shop, counted per product, size and colour, and the page
  that shows it across the four shops.
- `reservations`: reserving units of a variant in a shop for a customer, the 48-hour expiry,
  and the rule that stock never goes below zero.

### Modified Capabilities

None. `home-page` keeps its title and heading.

## Impact

- `app/index.html` and new files under `app/` (HTML, CSS and JavaScript for the browser).
- New test pages under `app/test/`, run by `sh app/check.sh test`.
- No dependency, no server, no build step.
