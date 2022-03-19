{{ config(
    materialized = "table",
)}}

with sales_data as
(
    select 
        cal.fiscal_year,
        cal.fiscal_month,
        cal.fiscal_month_end_dt,
        cal.current_year,
        fact.product_id,
        fact.product_category,
        fact.product_sub_category,
        fact.state,
        fact.region,
        fact.country,
        fact.market,
        coalesce(sp.sales_person_name,'Canada') as sales_person_name,
        case when returns.returned = 'Yes' then 1 else 0 end as returned_flag,
        fact.sales as sales,
        fact.discount,
        fact.profit,
        case when returned_flag = 1 then -fact.quantity else fact.quantity end as quantity,
        fact.shipping_cost
    from {{ref('global_superstore_sales_fact')}} fact
    left join {{ref('stage_sales_returns')}} returns on fact.order_id = returns.order_id and fact.region = returns.region
    left join {{ref('stage_sales_person_dim')}} sp on sp.sales_person_region = fact.region
    inner join {{ref('calendar_dim')}} cal on fact.order_date = cal.cal_dt
),

rate_of_return_cte as
(
    select fiscal_year,state,sum(case when quantity < 0 then 1 else 0 end)/count(*)*100 as rate_of_return
    from sales_data group by 1,2
)

select 
    sd.fiscal_year,
    sd.fiscal_month,
    sd.fiscal_month_end_dt,
    sd.current_year,
    sd.product_id,
    sd.product_category,
    sd.product_sub_category,
    sd.state,
    sd.region,
    sd.country,
    sd.market,
    sd.sales_person_name,
    ror.rate_of_return,
    sum(sd.sales) as sales_value,
    sum(case when sd.returned_flag = 1 then sd.sales else 0 end) as sales_returns,
    sum(discount) as discount,
    sum(case when sd.returned_flag = 1 then 0 else sd.profit end) as profit,
    sum(sd.quantity) as quantity,
    sum(sd.shipping_cost) as shipping_cost,
    sales_value-sales_returns as revenue
from sales_data sd
left join rate_of_return_cte ror on ror.fiscal_year = sd.fiscal_year and ror.state = sd.state
{{dbt_utils.group_by(13)}}