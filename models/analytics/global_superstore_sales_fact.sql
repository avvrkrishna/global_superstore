{{ config(
    materialized = "incremental",
    unique_key = "row_id",
    schema = "analytics"
)}}

select 
{{dbt_utils.surrogate_key(['row_id'])}} as global_sales_fact_key,
cast(row_id as number(10,0)) as row_id,
order_id,
cast(order_date as date) as order_date,
cast(ship_date as date) as ship_date,
ship_mode,
customer_id,
customer_name,
segment,
cast(postal_code as number(10,0)) as postal_code,
city,
state,
country,
region,
market,
product_id,
category as product_category,
sub_category as product_sub_category,
product_name,
cast(regexp_replace(sales,'[^-0-9\\.]+','') as number(20,3)) as sales,
cast(regexp_replace(quantity,'[^-0-9\\.]+','') as number(20,3)) as quantity,
cast(regexp_replace(discount,'[^-0-9\\.]+','') as number(20,3)) as discount,
cast(regexp_replace(profit,'[^-0-9\\.]+','') as number(20,3)) as profit,
cast(regexp_replace(shipping_cost,'[^-0-9\\.]+','') as number(20,3)) as shipping_cost,
order_priority,
current_timestamp() as record_created_datetime
from {{ref('stage_superstore_orders')}}