{{ config(
    materialized = "incremental",
    unique_key = "row_id"
)}}

select * from {{ref('stage_global_superstore_orders')}}