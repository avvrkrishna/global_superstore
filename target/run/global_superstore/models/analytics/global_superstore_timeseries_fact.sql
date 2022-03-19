

      create or replace  table DEV_ANALYTICS.ANALYTICS.global_superstore_timeseries_fact copy grants as
      (

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
        sp.sales_person_name,
        case when returns.returned = 'Yes' then 1 else 0 end as returned_flag,
        fact.sales as sales,
        fact.discount,
        fact.profit,
        case when returned_flag = 1 then -fact.quantity else fact.quantity end as quantity,
        fact.shipping_cost
    from DEV_ANALYTICS.ANALYTICS.global_superstore_sales_fact fact
    left join DEV_ANALYTICS.STAGE_RAW.stage_sales_returns returns on fact.order_id = returns.order_id and fact.region = returns.region
    left join DEV_ANALYTICS.STAGE_RAW.stage_sales_person_dim sp on sp.sales_person_region = fact.region
    inner join DEV_ANALYTICS.master_data.calendar_dim cal on fact.order_date = cal.cal_dt
)

select * from sales_data
      );
    