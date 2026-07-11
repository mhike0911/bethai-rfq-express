# Intelligence Layer

## Messy Inputs (what the user actually gives us)
- Free-text vendor names (inconsistent capitalisation, abbreviations)
- Line item descriptions with no standard taxonomy
- Deposit amounts typed by memory, not calculated
- Tax rates sometimes omitted

## Auto-Structure (v1 — rule-based only)
```json
{
  "rfq_number": "RFQ-2024-005",
  "totals": {
    "subtotal": 4200.00,
    "tax_rate": 0.08,
    "tax_amount": 336.00,
    "deposit_rate": 0.30,
    "expected_deposit": 1360.80,
    "total_amount": 4536.00
  },
  "mismatch_flag": true,
  "mismatch_note": "Deposit paid (1200.00) < expected deposit (1360.80)"
}
```

## Events to Track
- RFQ created (with line item count and total value)
- Approval decision (time from submission to decision)
- Payment recorded (mismatch Y/N, delta amount)
- Status transitions (timestamps for SLA measurement)

## Scoring Rules (v1 — deterministic)
| Rule | Output |
|---|---|
| `deposit_paid < expected_deposit × 0.99` | mismatch_flag = true |
| `total_amount > 10,000` | tag = high_value (for future alerting) |
| `requested_delivery_date < now() + 3 days` | tag = urgent |

## AI Fields (Later — stored with provenance)
Any AI-generated field stores: `value`, `source` (model + prompt version), `confidence` (0–1), `review_status` (unreviewed / accepted / overridden).

## v1 vs Later
- **v1:** All scoring is rule-based server logic — no LLM calls
- **Next:** AI suggests line items from past RFQ history; confidence stored
- **Later:** Anomaly detection on spend patterns; vendor risk scoring
