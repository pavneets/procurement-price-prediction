with source as (

    select * from read_csv('/data/bronze/purchase_orders.csv', header=true, all_varchar=true)

),

cleaned as (

    select
        upper(trim(po_number))        as po_number,
        upper(trim(customer_id))      as customer_id,
        upper(trim(vendor_id))        as vendor_id,
        nullif(trim(vendor_name), '')    as vendor_name,
        coalesce(
        try_strptime(trim(order_date), '%Y-%m-%d'),
        try_strptime(trim(order_date), '%m/%d/%Y')
    )::date     as order_date,
        upper(substr(trim(status), 1, 1)) || lower(substr(trim(status), 2))         as status,
        try_cast(replace(replace(trim(total_amount), '$', ''), ',', '') as decimal(12, 2)) as total_amount

    from source

)

select * from cleaned