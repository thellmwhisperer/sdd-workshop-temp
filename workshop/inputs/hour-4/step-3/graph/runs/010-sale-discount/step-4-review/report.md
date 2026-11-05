## Ticket
tickets/010-sale-discount.md: reviewed, done as asked

## Changed
nothing

## Checked
`sh app/check.sh test`: every check is ok, including the six new ones of app/test/discount.test.html
    ok 10% off one line shows the discount under the subtotal
    ok 10% off two lines
    ok no percentage means no discount line
    ok 0% means no discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
`sh app/check.sh lint` and `sh app/check.sh typecheck`: no output, exit 0
The discount is worked out per line and rounded to the penny in app/sale.js (lineDiscount), not on the subtotal. Prices stay whole pence. Every ACCEPTANCE line has a test.

## Not done
nothing

Verdict: pass
