{{ config(
    materialized = "incremental",
    incremental_strategy = "delete+insert",
    unique_key = "concat(customer_id,city,state,nvl(postal_code,''))",
    schema = "master_data"
)}}

select 
    distinct 
    customer_id,
    customer_name,
    nvl(postal_code,'') as postal_code,
    city,
    state,
    country,
    current_timestamp() as record_created_datetime
from {{ref('stage_superstore_orders')}}