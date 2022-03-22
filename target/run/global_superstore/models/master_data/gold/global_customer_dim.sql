

      create or replace  table DEV_ANALYTICS.master_data.global_customer_dim copy grants as
      (

select 
    distinct
    md5(cast(coalesce(cast(customer_id as 
    varchar
), '') || '-' || coalesce(cast(city as 
    varchar
), '') || '-' || coalesce(cast(state as 
    varchar
), '') || '-' || coalesce(cast(postal_code as 
    varchar
), '') as 
    varchar
))  as customer_dim_key,
    customer_id,
    customer_name,
    nvl(postal_code,'') as postal_code,
    city,
    state,
    country,
    current_timestamp() as record_created_datetime
from DEV_ANALYTICS.STAGE_RAW.stage_superstore_orders
      );
    