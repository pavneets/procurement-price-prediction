
    

    create  table
      "warehouse"."gold"."dim_item__dbt_tmp"
  
    
    as (
      select
    item_id,
    description,
    category,
    unit_of_measure,
    manufacturer_id,
    manufacturer_name
from "warehouse"."silver"."items"
    );
    
  