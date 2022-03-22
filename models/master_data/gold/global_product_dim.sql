{{ config(
    materialized = "incremental",
    unique_key = "product_id",
    schema = "master_data"
)}}

select 
    distinct
    {{dbt_utils.surrogate_key(['product_id'])}} as product_dim_key, 
    product_id,
    product_name,
    category as product_category,
    sub_category as product_sub_category,
    current_timestamp() as record_created_datetime
from {{ref('stage_superstore_orders')}}
