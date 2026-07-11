# Security

## Secret Handling
- Supabase service role key: server-side only (Next.js server actions / API routes), never in client bundle
- Supabase anon key: client-safe, used only for reads under open v1 RLS policies
- All env vars in Vercel environment settings; `.env.local` git-ignored

## Permission Model (v1 → lock-down)
| Sprint | Read | Write |
|---|---|---|
| v1 (open) | Anyone | Anyone (demo mode) |
| Lock-down | `auth.uid() = user_id` | `auth.uid() = user_id` |
| Role enforcement | Approval actions: operations/admin roles only | Enforced via server action role check |

## Approved Tools Rule
Agent tools are named, scoped functions (`calculate_rfq_totals`, `validate_payment`, `write_audit_log`, `update_rfq_status`). No `run_any`, `exec_sql`, or `send_any` tools exist. Every tool call is logged.

## Audit Principle
Every state-changing action writes an `audit_logs` row before returning success. If the audit write fails, the parent transaction rolls back. Audit rows are insert-only — no update or delete policy on `audit_logs`, even after lock-down.

## Lock-Down Checklist (Sprint 4)
- [ ] Replace all v1 open RLS policies with `auth.uid() = user_id`
- [ ] Add role column; enforce approval gating server-side
- [ ] Confirm service role key is absent from all client-side code (grep check)
- [ ] Penetration check: unauthenticated POST to any table returns 403

> If payment processing or legally binding document signing is added, stop and bring in a qualified security reviewer before proceeding.
