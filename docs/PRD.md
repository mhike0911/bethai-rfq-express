# BethAI RFQ Express — Product Requirements

## Problem
The team manually creates RFQs, routes them for approval, and validates payments every week. Each cycle takes hours of copy-paste, email chasing, and reconciliation across spreadsheets.

## Target Users
- **Admin** — creates and submits RFQs
- **Sales** — initiates RFQs for client or internal procurement
- **Operations (tax, audit, accounting, corporate)** — approves RFQs and validates payments/deposits

## Core Objects
| Object | Purpose |
|---|---|
| RFQ | A request for quote with vendor, line items, totals, and status |
| RFQ Line Item | Individual product/service rows on an RFQ |
| Approval | Approve/reject decision with note and timestamp |
| Payment | Payment reference, deposit paid, mismatch flag |
| Audit Log | Immutable record of every status change and action |

## MVP Must-Haves (v1)
- [ ] Create an RFQ with vendor, department, delivery date, and line items in one form
- [ ] Auto-calculate subtotal, tax, deposit, and total on save (server-side)
- [ ] List all RFQs with status badges — viewable without login
- [ ] Approve or Reject an RFQ with a required note
- [ ] Enter payment and deposit; system auto-flags mismatches
- [ ] Audit log entry on every status transition
- [ ] Seed demo data so the app renders live on first load

## Non-Goals (v1)
- No login/auth wall (deferred to lock-down sprint)
- No PDF export, email notifications, or vendor master list
- No multi-level approval chains
- No ERP integrations
- No recurring templates or AI suggestions

## Success Criteria
**Scenario:** Admin enters a new RFQ with 3 line items → totals auto-calculate → Operations approves it with a note → Admin records a deposit payment with a wrong amount → system flags a mismatch → all steps visible in the audit log.

**Pass:** The entire scenario completes in under 5 minutes with zero spreadsheet or email involvement, and every action is reflected in the database on refresh.
