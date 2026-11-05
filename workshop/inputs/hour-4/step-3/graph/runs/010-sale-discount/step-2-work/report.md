## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok 10% off one line shows the discount under the subtotal
    ok 10% off two lines
    ok no percentage means no discount line
    ok 0% means no discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing
