{{ config(
    materialized = "incremental",
    unique_key = "order_id",
    schema = "analytics"
)}}

select
    {{dbt_utils.surrogate_key(['order_id'])}} as global_sales_returns_key,
    returned,
    order_id,
    region,
    current_timestamp() as record_created_datetime
from {{ref('stage_sales_returns')}}