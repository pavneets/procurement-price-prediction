
    

    create  table
      "warehouse"."silver"."itemized_purchase_orders__dbt_tmp"
  
    
    as (
      with source as (

    select * from read_csv('/data/bronze/itemized_purchase_orders.csv', header=true, all_varchar=true)

),

cleaned as (

    select
        upper(trim(po_number))             as po_number,
        upper(trim(customer_id))           as customer_id,
        upper(trim(item_id))               as item_id,
        try_cast(trim(quantity_ordered) as integer) as quantity_ordered,
        try_cast(replace(replace(trim(unit_price_paid), '$', ''), ',', '') as decimal(12, 2))   as unit_price_paid

    from source

)

select * from cleaned
    );
    
  