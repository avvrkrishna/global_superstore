{{ config(
    materialized = 'incremental'
    unique_key = 'product_id'
)}}

select 
    distinct 
    country,
    product_id,
    product_name,
    category as product_category,
    sub_category as product_sub_category
from {{ref('stage_global_superstore_orders')}}