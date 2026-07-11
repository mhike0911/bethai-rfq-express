# Agentic Layer

## Risk Classification

### Low — Auto-execute (no approval needed)
- Calculate and store totals on RFQ save
- Set `mismatch_flag` and `mismatch_note` on payment insert
- Write audit log entry on every state change
- Tag RFQ as `urgent` or `high_value` by rule

### Medium — Requires user confirmation before execution
- Advance RFQ status from `pending_approval` → `approved` or `rejected` (reviewer must submit the form)
- Advance RFQ status from `approved` → `paid` (requires payment record submission)

### High — Always requires explicit human approval action
- Send email notification to approver (v2 — user must enable and confirm recipient)
- Generate and attach PDF to an approved RFQ

### Critical — Human-only, no agent involvement
- Delete an RFQ or payment record
- Reverse an approved status back to draft after payment is recorded
- Any bulk data modification

## Named Tools (approved list)
- `calculate_rfq_totals` — input: line items + rates → output: subtotal, tax, deposit, total
- `validate_payment` — input: deposit_paid, expected_deposit → output: mismatch_flag, mismatch_note
- `write_audit_log` — input: entity, action, old/new values, actor → output: audit row
- `update_rfq_status` — input: rfq_id, new_status, actor → output: updated row + audit log

## Audit Log Fields
`entity_type`, `entity_id`, `action`, `old_value (jsonb)`, `new_value (jsonb)`, `actor_name`, `created_at`

## v1 vs Later
- **v1:** Low-risk tools run automatically; medium tools fire on form submit
- **Later:** Agent drafts approval recommendation; human one-clicks to execute
