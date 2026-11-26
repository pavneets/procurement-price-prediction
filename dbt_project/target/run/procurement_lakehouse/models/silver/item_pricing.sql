
    

    create  table
      "warehouse"."silver"."item_pricing__dbt_tmp"
  
    
    as (
      with source as (

    select * from read_csv('/data/bronze/item_pricing.csv', header=true, all_varchar=true)

),

cleaned as (

    select
        upper(trim(item_id))                  as item_id,
        upper(trim(vendor_id))                as vendor_id,
        coalesce(
        try_strptime(trim(price_effective_date), '%Y-%m-%d'),
        try_strptime(trim(price_effective_date), '%m/%d/%Y')
    )::date   as price_effective_date,
        try_cast(replace(replace(trim(vendor_price), '$', ''), ',', '') as decimal(12, 2))         as vendor_price

    from source

)

select * from cleaned
    );
    
  