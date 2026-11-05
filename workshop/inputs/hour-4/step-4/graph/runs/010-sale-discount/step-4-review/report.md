## Ticket
tickets/010-sale-discount.md: reviewed, meets the ticket and the business rules

## Changed
nothing

## Checked
- app/sale.js: the discount is taken per line (`discountOf`, rounded with Math.round per line), never on the subtotal. Worked by hand: three lines of 17p at 10% give 15p each, so 45p, not 46p.
- Acceptance 1 and 2 (£2.00 off £20.00; £2.70 off £27.00), 3 (no or zero percent, no Discount line) and 4 (below 0 or above 100 throws "discount must be 0 to 100") each have a check in app/test/discount.test.html.
- app/test/sale.test.html still passes unchanged; no Node, module or dependency added.
`sh app/check.sh test`: every line ok, ending with
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh lint`: no output, exit 0

## Not done
- Comment only: a non-integer percentage such as 10.5 is accepted; the ticket does not mention it.

Verdict: pass
