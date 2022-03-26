{% docs __global_superstore__ %}
# Global SuperStore Project

**Summary About the Global Superstore Project**
1. What is the Global Superstore Project is about?
- Generic Sales Data Mart which is built for e-commerce seller of office supplies and equipment to get meaningfull decisions from the data and consists of below data

2. Source for this Data Products?
- Traditional Order Management System

3. How is the data processed?
- Working on dbt cloud, we will perform all the required transformations and process the data

4. How is the data delivered?
- Data is delivered by Snowflake tables and views

5. Consumption of the data?
- Global Reporting Team: The data from the summary tables will be consumed by business people and dashboards build for them either through Tableau or Power BI




## DBT Processing Details:
| **DB Name**| **Schema Name** | **DBT Model / Tag Name** | **Usage** | **Avg Execution Time**|
|---|---|---|---|---|
|<ENV>_ANALYTICS | MASTER_DATA | calendar_dim | Calendar Dimension table for Global Superstore |  3 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_product_dim | Global Product Dimension table for Global Superstore | 6 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_customer_dim | Global Customer Dimension table for Global Superstore | 7 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_sales_person_dim | Glboal Sales Person Dimension table for Global Superstore | 6 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_sales_returns | Global Sales Returns table | 5 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_superstore_sales_fact | Global Superstore sales fact table | 6 Secs|
|<ENV>_ANALYTICS | MASTER_DATA | global_superstore_summary_fact | Global Superstore Summary Table | 4 Secs|

  
### Open Issues:
1. 
2. 
3.   
 
{% enddocs %}
