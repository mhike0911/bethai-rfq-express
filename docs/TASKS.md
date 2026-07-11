# Tasks & Sprints

## Sprint 1 — DB + Core RFQ Engine 🏁 *v1 functional milestone*
**Goal:** A new RFQ can be created, saved, and viewed — app renders with seed data without any login.

- [ ] Run migration SQL; verify 4 seed RFQs visible at `/rfqs`
- [ ] Build `/rfqs` list page: RFQ number, vendor, department, total, status badge
- [ ] Handle list loading / empty ("No RFQs yet — create one") / error states
- [ ] Build `/rfqs/new` form: vendor, department, delivery date, notes, dynamic line items (add/remove rows)
- [ ] Server action: validate inputs, calculate totals server-side, insert `rfqs` + `rfq_line_items`, write audit log
- [ ] Build `/rfqs/[id]` detail page: all fields, line items table, totals breakdown, status badge, timeline
- [ ] Handle detail loading / not-found / error states

**Definition of Done:** Submit a new RFQ with 2 line items → appears in list with correct totals, status = `pending_approval`; refresh shows same data.

---

## Sprint 2 — Approval Workflow
**Goal:** Ops reviewer can approve or reject an RFQ with a note; status updates immediately.

- [ ] Add Approve / Reject action panel on detail page (visible when status = `pending_approval`)
- [ ] Note field required; button disabled until note entered
- [ ] Server action: insert `approvals`, update `rfqs.status` atomically, write audit log
- [ ] Show approver name, timestamp, note on detail page after decision
- [ ] Rejected RFQ shows "Resubmit" button → status back to `draft`
- [ ] Empty state: no pending RFQs message on a filtered view

**Definition of Done:** Approve an RFQ → status = `approved`, approval record in DB, audit log entry present; reject → status = `rejected`, resubmit returns to `draft`.

---

## Sprint 3 — Payment & Deposit Validation
**Goal:** Admin records payment; system auto-flags deposit mismatches.

- [ ] Payment entry form on approved RFQ detail: reference, amount paid, deposit paid, payment date
- [ ] Server action: insert `payments`, compare `deposit_paid` vs `expected_deposit` (±1%), set `mismatch_flag` and `mismatch_note`
- [ ] Advance `rfqs.status` to `paid` (full) or `mismatch`; write audit log
- [ ] Payment status badge on list and detail pages
- [ ] `/rfqs?filter=mismatch` view: lists all mismatched RFQs
- [ ] Error state: payment form validation (amount must be > 0, reference required)

**Definition of Done:** Enter a deposit 15% below expected → `mismatch_flag = true`, RFQ status = `mismatch`, visible in mismatch filter view.

---

## Sprint 4 — Lock It Down (Auth + RLS)
**Goal:** Per-user data isolation; no anonymous writes; role-gated approvals.

- [ ] Add Supabase Auth: `/login`, `/signup` pages
- [ ] Replace all v1 open RLS policies with `auth.uid() = user_id` policies
- [ ] Populate `user_id` on all new inserts
- [ ] Add `role` column to user profiles; seed roles: admin, sales, operations
- [ ] Approval action gated: only operations/admin role can approve
- [ ] Unauthenticated users redirected to `/login` for write actions

**Definition of Done:** Logged-out POST to `rfqs` returns 403; logged-in sales user cannot see another user's RFQs; wrong-role user cannot approve.

---

## Sprint 5 — PDF Export & Notifications
**Goal:** Approved RFQ downloadable as PDF; approver notified by email.

- [ ] PDF generation server route: renders RFQ header, line items, totals, approval block
- [ ] Download button on approved RFQ detail
- [ ] Email notification (Resend or Supabase Edge Function) when status → `pending_approval`
- [ ] Email contains RFQ number, vendor, total, and link to detail page

**Definition of Done:** Click Download → PDF file opens with correct data; submit RFQ → approver email received within 60 seconds.

---

## Gantt (sprint timeline)
```
Week 1:  [Sprint 1 ████████████]
         [Sprint 2      ████████]
Week 2:  [Sprint 3 ████████████]
         [Sprint 4      ████████]
Week 3:  [Sprint 5 ████████████]
```
