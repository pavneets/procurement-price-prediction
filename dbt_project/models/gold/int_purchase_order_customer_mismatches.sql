
-- Identify purchase order lines where header and line customer IDs disagree
with lines as (
    select * from {{ ref('itemized_purchase_orders') }}
),
pos as (
    select * from {{ ref('purchase_orders') }}
),
reconciled as (
    select
        lines.po_number,
        lines.customer_id as customer_id_line,
        pos.customer_id as customer_id_header,
        pos.vendor_id,
        lines.item_id,
        pos.order_date,
        pos.status,
        lines.quantity_ordered,
        lines.unit_price_paid
    from lines
    inner join pos
        on lines.po_number = pos.po_number
)
select *
from reconciled
where customer_id_line != customer_id_header