---
name: worker
description: For a worker of group 2 (Stock across shops). How to turn one ticket into working, tested code in app/, the business rules the ticket may not repeat, and the report to write. Load it when your prompt hands you a ticket to build.
---

# Worker: build one ticket

You build one ticket, nothing else. The ticket is your brief: SCOPE and FORBIDDEN are the
fence, ACCEPTANCE and VERIFY say when you are done.

## How to do it here

1. Read the ticket whole. Read the files its CONTEXT names, and only those.
2. If `last` points to a previous step, read its `report.md` first: it says what was red
   (a failing test, a lint line, or the reviewer's `Verdict: block` and why). Fix that,
   and only that.
3. Test first. Write the test page the ticket names, `app/test/<name>.test.html`: it loads
   `check.js` and the scripts under test, and prints one `ok` or `FAIL` line per scenario
   of ACCEPTANCE, named with the scenario number (`1.1 sizes are counted apart`). Run
   `sh app/check.sh test` and see it red.
4. Write the code until the test is green. Do not change the test to make it pass.
5. Run the three checks of VERIFY: `sh app/check.sh test`, `sh app/check.sh lint`,
   `sh app/check.sh typecheck`. All green, every other test too.
6. Write the report.

## The app

- Plain browser JavaScript: functions in a file loaded with `<script src>`. No `import`,
  `export`, `require`, no Node, no npm, no build. The app prints with `printf` in shell,
  never `echo` outside `app/test/`.
- Rules are plain functions with no screen; the page only shows what they return.
- Functions return a new value; they do not change the one they were given.

## Business rules you cannot guess

From `DOMAIN.md` and the group's decisions. Follow them even when the ticket does not
repeat them; if one contradicts the ticket, report blocked.

- The unit of stock is a **variant**: product, size and colour. Stock is a count per shop
  per variant. "3 jackets" is wrong; "2 black M, 1 black L" is right.
- **Stock never goes below zero.** A count below zero is refused (throw an Error) and the
  stock stays as it was. Hélène's auditor counts it twice a year.
- **Free units = stock minus what is reserved.** Nobody can reserve more than is free.
  Exactly what is free is accepted; 0 units is refused.
- **A reservation lasts 48 hours** from when it was made. At 48 hours it has ended; before,
  it is held. Time is always an argument (`now`), never read from the clock inside a rule,
  so a test can say "48 hours later".
- **Any staff member can reserve**: no login, no manager role. A customer name is needed.
- A reservation is **collected** (its units leave stock) or **cancelled** (its units are
  free again). An ended reservation cannot be collected.
- The four shops: Old town, Graslin, Île de Nantes, Chantenay.
- Only the sizes and colours a product comes in can be picked.
- Data lives in the browser (`localStorage`), with a starting catalogue in a JS file in
  `app/`. No server.

## Stop and report blocked when

- the ticket needs a file outside its SCOPE;
- a rule the ticket needs is in no spec, no ticket and not above;
- a check stays red for a reason outside your SCOPE.

## The report

Four headings, exactly as `graph/REPORT.md`: `## Ticket`, `## Changed`, `## Checked`,
`## Not done`. Under Checked, the commands and the last lines they printed.
