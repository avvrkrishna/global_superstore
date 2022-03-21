{{ config(
    materialized = "incremental",
    unique_key = "product_id",
    schema = "master_data"
)}}

select 
    distinct 
    product_id,
    product_name,
    category as product_category,
    sub_category as product_sub_category,
    record_created_datetime
from {{ref('global_superstore_sales_fact')}}
{% if is_incremental() %}
where record_created_datetime >
(select max(record_created_datetime) from {{this}})
{% endif %}