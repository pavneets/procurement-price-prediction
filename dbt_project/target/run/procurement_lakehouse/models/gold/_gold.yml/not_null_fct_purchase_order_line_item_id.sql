
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select item_id
from "warehouse"."gold"."fct_purchase_order_line"
where item_id is null



  
  
      
    ) dbt_internal_test