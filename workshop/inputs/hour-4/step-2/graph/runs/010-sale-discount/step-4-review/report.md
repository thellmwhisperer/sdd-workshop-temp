## Ticket
tickets/010-sale-discount.md: reviewed, the change meets it

## Changed
nothing

## Checked
- app/sale.js works the discount out per line, rounded to the penny on each line, as the business rule says (not a percentage of the subtotal).
- Each ACCEPTANCE line has a check in app/test/discount.test.html: the two receipts, no percentage and 0, below 0 and above 100.
`sh app/check.sh test`:
    ok 10% off one scarf shows the discount and the total
    ok 10% off two lines ends with the subtotal, the discount and the total
    ok no percentage gives the receipt without a discount line
    ok 0 percent gives the receipt without a discount line
    ok a percentage below 0 is refused
    ok a percentage above 100 is refused
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh lint`: no output, exit 0
`sh app/check.sh typecheck`: no output

## Not done
nothing

Verdict: pass
