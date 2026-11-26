
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select price_effective_date
from "warehouse"."silver"."item_pricing"
where price_effective_date is null



  
  
      
    ) dbt_internal_test