create table if not exists rfqs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  rfq_number text not null,
  vendor_name text not null,
  vendor_email text,
  department text not null,
  requested_delivery_date date,
  notes text,
  subtotal numeric not null default 0,
  tax_rate numeric not null default 0,
  tax_amount numeric not null default 0,
  deposit_rate numeric not null default 0,
  expected_deposit numeric not null default 0,
  total_amount numeric not null default 0,
  status text not null default 'draft',
  created_at timestamptz not null default now()
);

alter table rfqs enable row level security;
drop policy if exists "rfqs_v1_read" on rfqs;
create policy "rfqs_v1_read" on rfqs for select using (true);
drop policy if exists "rfqs_v1_write" on rfqs;
create policy "rfqs_v1_write" on rfqs for all using (true) with check (true);

create table if not exists rfq_line_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  rfq_id uuid not null references rfqs(id) on delete cascade,
  description text not null,
  quantity numeric not null default 1,
  unit_price numeric not null default 0,
  line_total numeric not null default 0,
  unit text,
  created_at timestamptz not null default now()
);

alter table rfq_line_items enable row level security;
drop policy if exists "rfq_line_items_v1_read" on rfq_line_items;
create policy "rfq_line_items_v1_read" on rfq_line_items for select using (true);
drop policy if exists "rfq_line_items_v1_write" on rfq_line_items;
create policy "rfq_line_items_v1_write" on rfq_line_items for all using (true) with check (true);

create table if not exists approvals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  rfq_id uuid not null references rfqs(id) on delete cascade,
  decision text not null,
  note text,
  approver_name text,
  approver_email text,
  decided_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table approvals enable row level security;
drop policy if exists "approvals_v1_read" on approvals;
create policy "approvals_v1_read" on approvals for select using (true);
drop policy if exists "approvals_v1_write" on approvals;
create policy "approvals_v1_write" on approvals for all using (true) with check (true);

create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  rfq_id uuid not null references rfqs(id) on delete cascade,
  payment_reference text,
  amount_paid numeric not null default 0,
  deposit_paid numeric not null default 0,
  payment_date date,
  mismatch_flag boolean not null default false,
  mismatch_note text,
  payment_status text not null default 'awaiting_payment',
  created_at timestamptz not null default now()
);

alter table payments enable row level security;
drop policy if exists "payments_v1_read" on payments;
create policy "payments_v1_read" on payments for select using (true);
drop policy if exists "payments_v1_write" on payments;
create policy "payments_v1_write" on payments for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  entity_type text not null,
  entity_id uuid not null,
  action text not null,
  old_value jsonb,
  new_value jsonb,
  actor_name text,
  created_at timestamptz not null default now()
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into rfqs (id, rfq_number, vendor_name, vendor_email, department, requested_delivery_date, notes, subtotal, tax_rate, tax_amount, deposit_rate, expected_deposit, total_amount, status) values
  ('a1000000-0000-0000-0000-000000000001', 'RFQ-2024-001', 'Acme Supplies Co.', 'orders@acmesupplies.com', 'Operations', '2024-08-15', 'Urgent — needed for Q3 audit prep', 4200.00, 0.08, 336.00, 0.30, 1360.80, 4536.00, 'approved'),
  ('a1000000-0000-0000-0000-000000000002', 'RFQ-2024-002', 'Delta Office Solutions', 'sales@deltaoffice.com', 'Admin', '2024-08-22', 'Recurring weekly stationery order', 850.00, 0.08, 68.00, 0.30, 275.40, 918.00, 'pending_approval'),
  ('a1000000-0000-0000-0000-000000000003', 'RFQ-2024-003', 'Prime Tech Vendors', 'procurement@primetech.com', 'Sales', '2024-09-01', 'Laptop accessories for new hires', 6500.00, 0.08, 520.00, 0.50, 3510.00, 7020.00, 'draft'),
  ('a1000000-0000-0000-0000-000000000004', 'RFQ-2024-004', 'Global Freight Ltd.', 'billing@globalfreight.com', 'Operations', '2024-08-10', 'Logistics for corporate shipment', 2100.00, 0.08, 168.00, 0.30, 680.40, 2268.00, 'paid');

insert into rfq_line_items (rfq_id, description, quantity, unit_price, line_total, unit) values
  ('a1000000-0000-0000-0000-000000000001', 'Audit binder sets', 50, 24.00, 1200.00, 'pcs'),
  ('a1000000-0000-0000-0000-000000000001', 'Filing cabinet labels (bulk)', 200, 1.50, 300.00, 'packs'),
  ('a1000000-0000-0000-0000-000000000001', 'Archival storage boxes', 30, 90.00, 2700.00, 'units'),
  ('a1000000-0000-0000-0000-000000000002', 'A4 paper reams', 40, 8.50, 340.00, 'reams'),
  ('a1000000-0000-0000-0000-000000000002', 'Ballpoint pens (box)', 10, 15.00, 150.00, 'boxes'),
  ('a1000000-0000-0000-0000-000000000002', 'Printer ink cartridges', 4, 90.00, 360.00, 'units'),
  ('a1000000-0000-0000-0000-000000000003', 'USB-C docking stations', 5, 850.00, 4250.00, 'units'),
  ('a1000000-0000-0000-0000-000000000003', 'Laptop stands', 10, 125.00, 1250.00, 'units'),
  ('a1000000-0000-0000-0000-000000000003', 'Wireless keyboards', 10, 100.00, 1000.00, 'units'),
  ('a1000000-0000-0000-0000-000000000004', 'Domestic freight — Sydney to Melbourne', 1, 1400.00, 1400.00, 'shipment'),
  ('a1000000-0000-0000-0000-000000000004', 'Packaging & handling surcharge', 1, 700.00, 700.00, 'flat');

insert into approvals (rfq_id, decision, note, approver_name, approver_email, decided_at) values
  ('a1000000-0000-0000-0000-000000000001', 'approved', 'Verified against Q3 budget — within allocation.', 'Maria Santos', 'maria.santos@company.com', now() - interval '2 days'),
  ('a1000000-0000-0000-0000-000000000004', 'approved', 'Logistics confirmed with ops team.', 'James Okafor', 'james.okafor@company.com', now() - interval '5 days');

insert into payments (rfq_id, payment_reference, amount_paid, deposit_paid, payment_date, mismatch_flag, payment_status) values
  ('a1000000-0000-0000-0000-000000000004', 'PAY-88421', 2268.00, 680.40, '2024-08-10', false, 'paid'),
  ('a1000000-0000-0000-0000-000000000001', 'PAY-88455', 0, 1200.00, '2024-08-03', true, 'deposit_received');

insert into audit_logs (entity_type, entity_id, action, old_value, new_value, actor_name) values
  ('rfq', 'a1000000-0000-0000-0000-000000000001', 'status_change', '{"status":"pending_approval"}', '{"status":"approved"}', 'Maria Santos'),
  ('rfq', 'a1000000-0000-0000-0000-000000000004', 'status_change', '{"status":"approved"}', '{"status":"paid"}', 'James Okafor'),
  ('payment', 'a1000000-0000-0000-0000-000000000001', 'mismatch_flagged', '{"deposit_paid":1200.00}', '{"expected_deposit":1360.80,"mismatch_flag":true}', 'System');