The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

**Changed** (step-2-work)
- app/sale.js
- app/test/discount.test.html

**Checked**
```
`sh app/check.sh test`: 0 FAIL lines; the last lines:
    ok money shows money taken off with a minus
    ok a line costs its price times its quantity
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
The new page has six checks, one per ACCEPTANCE line (two for line 4), first seen red, then green.
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0
```

**Reviewer** (step-4-review): pass. Nothing

Run `010-sale-discount`: never went back to the worker; journal in `graph/runs/010-sale-discount/journal.jsonl`.
