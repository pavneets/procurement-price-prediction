select
    item_id,
    description,
    category,
    unit_of_measure,
    manufacturer_id,
    manufacturer_name
from {{ ref('items') }}
