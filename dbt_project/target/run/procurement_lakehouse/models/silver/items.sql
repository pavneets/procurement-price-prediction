
    

    create  table
      "warehouse"."silver"."items__dbt_tmp"
  
    
    as (
      with source as (

    select * from read_csv('/data/bronze/items.csv', header=true, all_varchar=true)

),

cleaned as (

    select
        upper(trim(item_id))              as item_id,
        nullif(trim(description), '')        as description,
        nullif(trim(category), '')           as category,
        nullif(trim(unit_of_measure), '')    as unit_of_measure,
        nullif(trim(manufacturer_id), '')    as manufacturer_id,
        nullif(trim(manufacturer_name), '')  as manufacturer_name

    from source

)

select * from cleaned
    );
    
  