# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + API:** Supabase (Postgres, RLS, Auth later)
- **Styling:** Tailwind CSS
- **PDF (Sprint 5):** `@react-pdf/renderer` or Puppeteer edge function

## Key User Action — Flow (Create → Approve → Pay)
1. Admin fills the RFQ form and clicks **Submit**
2. Next.js server action validates inputs, calculates totals (subtotal, tax, deposit) and inserts into `rfqs` + `rfq_line_items`
3. Status set to `pending_approval`; audit log row written
4. Ops reviewer opens the RFQ detail page, reads line items and totals
5. Reviewer clicks **Approve** or **Reject**, submits a note → `approvals` row inserted, `rfqs.status` updated atomically
6. Admin opens approved RFQ, enters payment reference and deposit paid → `payments` row inserted; server compares `deposit_paid` vs `expected_deposit` and sets `mismatch_flag`
7. RFQ status advances to `paid` or `mismatch` accordingly; audit log updated

## Layer Plan
| Layer | Now (v1) | Later |
|---|---|---|
| Data | Tables, constraints, RLS open policies, seed rows | Owner-scoped RLS, role column |
| App Logic | CRUD forms, server-side totals, status machine | PDF export, email triggers |
| Smart Features | Rule-based mismatch detection | AI line-item suggestions, spend anomaly alerts |

## Core Without AI
All totals, validations, and status transitions are pure Postgres + server logic. The AI layer (suggestions, anomaly scoring) is additive — removing it leaves a fully functional tool.
