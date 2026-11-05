## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok the page exists and has a title
    ok ten percent off one line
    ok ten percent off two lines
    ok no percentage means no discount line
    ok zero percent means no discount line
    ok a percentage below 0 is refused
    ok a percentage above 100 is refused
    ok the discount is rounded per line, to the penny
    ok money shows pence as pounds
    ok a line costs its price times its quantity
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing. The discount is taken per line and rounded to the penny per line, as Priya's rule in the ticket says; halves round up.
