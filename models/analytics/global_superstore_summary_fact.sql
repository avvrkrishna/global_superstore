{{ config(
    materialized = "table"
)}}

with sales_data as
(
    select 
        cal.fiscal_year,
        cal.fiscal_month,
        cal.fiscal_month_end_dt,
        cal.current_year,
        fact.order_id,
        fact.product_id,
        fact.product_category,
        fact.product_sub_category,
        fact.state,
        fact.region,
        fact.country,
        fact.market,
        case when country = 'Canada' then 'Canada' else sp.sales_person_name end as sales_person_name,
        case when returns.returned = 'Yes' then 1 else 0 end as returned_flag,
        fact.sales as sales,
        fact.discount,
        fact.profit,
        case when returned_flag = 1 then -fact.quantity else fact.quantity end as quantity,
        fact.shipping_cost
    from {{ref('global_superstore_sales_fact')}} fact
    left join {{ref('global_sales_returns')}} returns on fact.order_id = returns.order_id and fact.region = returns.region
    left join {{ref('global_sales_person_dim')}} sp on sp.sales_person_region = fact.region
    inner join {{ref('calendar_dim')}} cal on fact.order_date = cal.cal_dt
),

rate_of_return_cte as
(
    select fiscal_year,state,sum(case when quantity < 0 then 1 else 0 end)/count(*)*100 as rate_of_return
    from sales_data group by 1,2
),

monthly_metrics as 
(select fiscal_year, fiscal_month,
sum(sales) as sales
from sales_data group by 1,2
),

month_to_month_difference as
(
    select fiscal_year,fiscal_month,
    lag(sales) over(order by fiscal_year,fiscal_month) as sales_previous_month,
    sales - sales_previous_month as month_to_month_change,
    round(div0(month_to_month_change,sales_previous_month)*100,2) as month_to_month_change_pct
    from monthly_metrics
),

category_wise_sales as
(
    select fiscal_year,product_category,sum(sales) as sales
    from sales_data group by 1,2
),

category_wise_sales_growth as 
(
    select fiscal_year,product_category,
    lag(sales) over (partition by product_category order by fiscal_year) as previous_year_sales,
    sales - previous_year_sales as sales_growth,
    round(div0(sales_growth,previous_year_sales) * 100,2) as category_wise_sales_growth_pct
    from category_wise_sales
),

sales_person_sales as 
(select fiscal_year,
sales_person_name,
sum(sales) as sales from sales_data group by 1,2),

sales_person_yearly_objective as
(
    select fiscal_year,
    sales_person_name,sales,
    lag(sales) over(partition by sales_person_name order by fiscal_year) * 1.10 as yearly_objective_sales
    from sales_person_sales
)

select
    {{dbt_utils.surrogate_key(['product_id','sd.state','country','sd.fiscal_month'])}}  as global_summary_fact_key,
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
    mtm.month_to_month_change,
    mtm.month_to_month_change_pct,
    cws.sales_growth as category_wise_sales_growth,
    cws.category_wise_sales_growth_pct,
    spy.sales as sales_person_yearly_sales,
    spy.yearly_objective_sales as sales_person_yearly_objective_sales,
    sum(case when sd.returned_flag = 1 then 0 else sd.sales end) as sales_value,
    sum(case when sd.returned_flag = 1 then sd.sales else 0 end) as sales_returns,
    sum(discount) as discount,
    sum(case when sd.returned_flag = 1 then 0 else sd.profit end) as profit,
    sum(sd.quantity) as quantity,
    sum(sd.shipping_cost) as shipping_cost,
    sum(case when sd.returned_flag = 1 then 0 else sd.sales end)/count(product_id) as revenue_per_sale,
    current_timestamp() last_refresh_datetime
from sales_data sd
left join rate_of_return_cte ror on ror.fiscal_year = sd.fiscal_year and ror.state = sd.state
left join month_to_month_difference mtm on sd.fiscal_year = mtm.fiscal_year and sd.fiscal_month = mtm.fiscal_month
left join category_wise_sales_growth cws on sd.fiscal_year = cws.fiscal_year and sd.product_category = cws.product_category
left join sales_person_yearly_objective spy on sd.fiscal_year = spy.fiscal_year and sd.sales_person_name = spy.sales_person_name
{{dbt_utils.group_by(20)}}