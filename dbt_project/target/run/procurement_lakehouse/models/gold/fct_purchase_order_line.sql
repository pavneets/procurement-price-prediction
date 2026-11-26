
    

    create  table
      "warehouse"."gold"."fct_purchase_order_line__dbt_tmp"
  
    
    as (
      with lines as (

    select * from "warehouse"."silver"."itemized_purchase_orders"

),

pos as (

    select * from "warehouse"."silver"."purchase_orders"

),

joined as (

    select
        lines.po_number,
        lines.customer_id,
        pos.vendor_id,
        pos.order_date,
        pos.status,
        lines.item_id,
        lines.quantity_ordered,
        lines.unit_price_paid,
        lines.quantity_ordered * lines.unit_price_paid as extended_amount
    from lines
    inner join pos on lines.po_number = pos.po_number

)

select * from joined
    );
    
  