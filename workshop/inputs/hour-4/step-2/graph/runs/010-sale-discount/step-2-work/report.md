## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`: 0 FAIL lines; the last lines:
    ok money shows money taken off with a minus
    ok a line costs its price times its quantity
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
The new page has six checks, one per ACCEPTANCE line (two for line 4), first seen red, then green.
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing. Note: DOMAIN.md says a discount goes per line, rounded to the penny on each line; the code does that and adds the lines' discounts into the one `Discount` line, which gives the ticket's examples.
