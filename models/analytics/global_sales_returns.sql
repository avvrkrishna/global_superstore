{{ config(
    materialized = "incremental",
    unique_key = "order_id",
    schema = "analytis"
)}}

select 
    returned,
    order_id,
    region
from {{ref('stage_sales_returns')}}