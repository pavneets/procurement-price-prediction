
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_date
from "warehouse"."gold"."fct_purchase_order_line"
where order_date is null



  
  
      
    ) dbt_internal_test