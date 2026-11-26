
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select item_id
from "warehouse"."silver"."item_pricing"
where item_id is null



  
  
      
    ) dbt_internal_test