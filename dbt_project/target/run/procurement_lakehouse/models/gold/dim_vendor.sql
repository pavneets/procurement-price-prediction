
    

    create  table
      "warehouse"."gold"."dim_vendor__dbt_tmp"
  
    
    as (
      select
    vendor_id,
    max(vendor_name)  as vendor_name,
    min(order_date)   as first_order_date,
    max(order_date)   as last_order_date,
    count(*)          as po_count
from "warehouse"."silver"."purchase_orders"
group by vendor_id
    );
    
  