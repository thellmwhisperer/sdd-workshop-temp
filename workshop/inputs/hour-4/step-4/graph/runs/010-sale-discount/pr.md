The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

**Changed** (step-2-work)
- app/sale.js
- app/test/discount.test.html

**Checked**
```
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
```

**Reviewer** (step-4-review): pass. - Comment only: a non-integer percentage such as 10.5 is accepted; the ticket does not mention it.

Run `010-sale-discount`: never went back to the worker; journal in `graph/runs/010-sale-discount/journal.jsonl`.
