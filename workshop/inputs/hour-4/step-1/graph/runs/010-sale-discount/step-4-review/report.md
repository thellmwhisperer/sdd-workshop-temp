## Ticket
tickets/010-sale-discount.md: reviewed, blocked on a business rule

## Changed
nothing

## Checked
`sh app/check.sh test`: all checks green (last lines):
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
Worked by hand: three lines of 17p with 10% off. `receipt` in app/sale.js computes `Math.round(sub * percent / 100)` on the subtotal: 51p gives 5p off, total 46p. The rule says each line is rounded on its own (17p - 2p = 15p, three lines, 45p).
Only app/sale.js and app/test/discount.test.html were touched; ACCEPTANCE 1 to 4 each have a check.

## Not done
The discount is taken on the subtotal instead of per line. The tests pass only because the ticket's examples come out the same either way.

Verdict: block
app/sale.js takes the percentage of the subtotal, breaking the rule that a discount goes per line, each line rounded to the penny (three lines of 17p at 10% must total 45p, not 46p).
