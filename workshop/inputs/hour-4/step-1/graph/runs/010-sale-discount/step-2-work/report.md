## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test` (last lines):
    ok a percentage below 0 is refused
    ok a percentage above 100 is refused
    ok money shows pence as pounds
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing. Note: neither the ticket nor DOMAIN.md says how to round a discount that is not a whole number of pence; `receipt` rounds it to the nearest penny. No example needs it, but Northbank may want to confirm the rule.
