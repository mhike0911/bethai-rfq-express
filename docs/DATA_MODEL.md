# Data Model

## rfqs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid nullable | owner (populated at lock-down) |
| rfq_number | text | e.g. RFQ-2024-001 |
| vendor_name | text | |
| vendor_email | text | |
| department | text | Admin / Sales / Operations |
| requested_delivery_date | date | |
| notes | text | |
| subtotal | numeric | sum of line totals |
| tax_rate | numeric | e.g. 0.08 |
| tax_amount | numeric | subtotal × tax_rate |
| deposit_rate | numeric | e.g. 0.30 |
| expected_deposit | numeric | total × deposit_rate |
| total_amount | numeric | subtotal + tax_amount |
| status | text | draft / pending_approval / approved / paid / rejected / mismatch |
| created_at | timestamptz | |

## rfq_line_items
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| rfq_id | uuid FK → rfqs | cascade delete |
| description | text | |
| quantity | numeric | |
| unit_price | numeric | |
| line_total | numeric | qty × unit_price |
| unit | text | pcs / kg / hours etc. |
| created_at | timestamptz | |

## approvals
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| rfq_id | uuid FK → rfqs | |
| decision | text | approved / rejected |
| note | text | required |
| approver_name | text | |
| approver_email | text | |
| decided_at | timestamptz | |
| created_at | timestamptz | |

## payments
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| rfq_id | uuid FK → rfqs | |
| payment_reference | text | |
| amount_paid | numeric | |
| deposit_paid | numeric | |
| payment_date | date | |
| mismatch_flag | boolean | server-set |
| mismatch_note | text | |
| payment_status | text | awaiting_payment / deposit_received / paid / mismatch |
| created_at | timestamptz | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| entity_type | text | rfq / approval / payment |
| entity_id | uuid | |
| action | text | status_change / created / mismatch_flagged |
| old_value | jsonb | |
| new_value | jsonb | |
| actor_name | text | |
| created_at | timestamptz | |

## RLS
All tables: v1 open policies (select/all using true). Lock-down sprint replaces with `auth.uid() = user_id`.
