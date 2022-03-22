

      create or replace  table DEV_ANALYTICS.analytics.global_sales_returns copy grants as
      (

select
    md5(cast(coalesce(cast(order_id as 
    varchar
), '') as 
    varchar
)) as global_sales_returns_key,
    returned,
    order_id,
    region,
    current_timestamp() as record_created_datetime
from DEV_ANALYTICS.STAGE_RAW.stage_sales_returns
      );
    