
with lines as (

    select * 
    from {{ ref('itemized_purchase_orders') }}

),

pos as (

    select * 
    from {{ ref('purchase_orders') }}

),

reconciled as (

    select
        lines.po_number,
        lines.customer_id as customer_id_line,
        pos.customer_id as customer_id_header,
        pos.vendor_id,
        pos.order_date,
        pos.status,
        lines.item_id,
        lines.quantity_ordered,
        lines.unit_price_paid

    from lines
    inner join pos
        on lines.po_number = pos.po_number

),

validated_lines as (

    select
        po_number,
        customer_id_line as customer_id,
        vendor_id,
        order_date,
        status,
        item_id,
        quantity_ordered,
        unit_price_paid,
        quantity_ordered * unit_price_paid as extended_amount

    from reconciled
    where customer_id_line = customer_id_header

)

select * 
from validated_lines
