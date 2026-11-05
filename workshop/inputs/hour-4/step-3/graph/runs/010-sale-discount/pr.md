The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

**Changed** (step-2-work)
- app/sale.js
- app/test/discount.test.html

**Checked**
```
`sh app/check.sh test`:
    ok 10% off one line shows the discount under the subtotal
    ok 10% off two lines
    ok no percentage means no discount line
    ok 0% means no discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0
```

**Reviewer** (step-4-review): pass. Nothing

Run `010-sale-discount`: never went back to the worker; journal in `graph/runs/010-sale-discount/journal.jsonl`.
