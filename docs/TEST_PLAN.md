# Test Plan

## Success Scenario (manual, end-to-end)

1. **Open `/rfqs`** → list renders with 4 seed RFQs and correct status badges. ✓ if no blank page or spinner stuck.
2. **Click "New RFQ"** → form loads with empty fields and one blank line item row.
3. **Fill form:** vendor = "Test Vendor", department = Sales, delivery date = 2 weeks out, add 2 line items (e.g. 5 × $100, 10 × $50).
4. **Submit** → redirected to detail page. Verify: subtotal = $1000, tax = $80 (8%), deposit = $324 (30% of total), total = $1080, status = `pending_approval`.
5. **Open detail page in new tab** → same data, no stale cache.
6. **Click Approve** without entering a note → button stays disabled. Enter note → submit. Verify: status = `approved`, approval block shows approver name + note + timestamp.
7. **Click Reject** on a different RFQ → enter note → submit. Verify: status = `rejected`. Click Resubmit → status = `draft`.
8. **On approved RFQ, open Payment form** → enter reference, full amount, but deposit = $200 (below expected). Submit. Verify: `mismatch_flag = true`, status = `mismatch`, mismatch note visible.
9. **Open `/rfqs?filter=mismatch`** → RFQ appears in list.
10. **Check audit log** on detail page → all transitions (created → pending → approved → mismatch) listed with timestamps.

## Empty States
- Delete all seed rows → `/rfqs` shows "No RFQs yet — create your first one" with a New RFQ button.
- Open `/rfqs/nonexistent-id` → 404 page with "RFQ not found" and a Back button.

## Error States
- Submit RFQ form with no line items → inline validation error: "Add at least one line item".
- Submit payment form with amount = 0 → validation error: "Amount must be greater than zero".
- Simulate DB timeout → error banner: "Something went wrong. Your data was not saved — please try again."

## Regression Checks (after Sprint 4 lock-down)
- Unauthenticated POST to `/api/rfqs` → 403.
- Logged-in user A cannot read user B's RFQs via direct URL.
- Sales-role user clicking Approve → server returns 403 with "Insufficient permissions".
