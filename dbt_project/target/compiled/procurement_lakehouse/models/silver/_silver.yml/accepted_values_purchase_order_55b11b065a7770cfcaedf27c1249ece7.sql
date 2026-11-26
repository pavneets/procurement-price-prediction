
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "warehouse"."silver"."purchase_orders"
    group by status

)

select *
from all_values
where value_field not in (
    'Open','Received','Closed','Cancelled'
)


