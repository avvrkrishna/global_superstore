{{ config(
    materialized = "incremental",
    schema = "master_data"
)}}

select 
    distinct 
    customer_id,
    customer_name,
    postal_code,
    city,
    state,
    country 
from {{ref('stage_superstore_orders')}}
{% if is_incremental() %}
where record_created_datetime in
(select max(record_created_datetime) from {{ref('stage_superstore_orders')}})
{% endif %}