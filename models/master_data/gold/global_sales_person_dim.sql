{{ config(
    materialized = "incremental",
    unique_key = "sales_person_name",
    schema = "master_data"
)}}

select 
    sales_person_name,
    sales_person_region,
    current_timestamp() as record_created_datetime
from {{ref('stage_sales_person_dim')}}