
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select po_number
from "warehouse"."gold"."fct_purchase_order_line"
where po_number is null



  
  
      
    ) dbt_internal_test