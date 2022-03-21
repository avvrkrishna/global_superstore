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
    country,
    record_created_datetime
from {{ref('global_superstore_sales_fact')}}
{% if is_incremental() %}
where record_created_datetime >
(select max(record_created_datetime) from {{this}})
{% endif %}