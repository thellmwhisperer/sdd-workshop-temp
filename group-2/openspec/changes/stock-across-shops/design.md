# Design

## Context

`app/` today is one page, `index.html`, with the title and heading of `home-page`. The app
is HTML, CSS and JavaScript as the browser loads them: no Node, no build, no dependency
(`STANDING.md`, rule 5). Tests are pages under `app/test/` run by `sh app/check.sh test`.
See `proposal.md` for why; the specs say what.

## Goals / Non-Goals

**Goals:**
- Rules (free units, never below zero, 48-hour expiry) live in plain functions a test page
  can call with no screen, and with the time passed in, so 48 hours are tested without
  waiting.
- The page only shows what those functions return.

**Non-Goals:**
- Logins and roles: any staff member reserves (decision 3), so nobody signs in.

## Decisions

- **Variant key.** A variant is product, size and colour; stock is a count per shop per
  variant (decision 1).
- **One page.** Stock and reservations live on one page, `app/index.html`: staff pick a
  variant, see the four shops, reserve, and see the reservations below (decision 4).
- **Time is an argument.** Every rule that depends on time takes "now" as a parameter, so a
  test can say "48 hours later" (decision 2).
- **Where the data lives** (agreed by the group: "for the purpose of the module, we'll use
  browser storage"). The catalogue, the stock and the reservations live in
  the browser (`localStorage`), with a starting catalogue and stock in a JavaScript file in
  `app/`. Alternative: a small server shared by the four shops; it needs something
  installed, which the app does not allow today. With this choice, the four shops do not
  yet share one copy of the data.
- **The four shops** (agreed by the group). Named in the starting data: Old town, Graslin,
  Île de Nantes, Chantenay. Only "old town" is from the brief; the chief proposed the other
  three and the group kept them.
- **How stock is entered** (agreed by the group, with scenario 1.3: never below zero). Staff can set the count of a variant in their shop
  on the page; importing the old spreadsheets is out.

## Risks / Trade-offs

- [Data in each browser is not shared across shops] → said plainly in the proposal above;
  a shared store is a later change.
- [A reservation expires while nobody has the page open] → expiry is computed from the time
  it was made whenever the page reads it, not by a timer.
