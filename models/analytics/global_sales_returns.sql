{{ config(
    materialized = "incremental",
    unique_key = "order_id",
    schema = "analytics"
)}}

select 
    returned,
    order_id,
    region,
    current_timestamp() as record_created_datetime
from {{ref('stage_sales_returns')}}