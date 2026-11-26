
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select item_id
from "warehouse"."silver"."itemized_purchase_orders"
where item_id is null



  
  
      
    ) dbt_internal_test