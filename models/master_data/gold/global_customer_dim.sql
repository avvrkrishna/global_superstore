{{ config(
    materialized = "incremental",
    unique_key = "customer_id",
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
from {{ref('stage_global_superstore_orders')}}