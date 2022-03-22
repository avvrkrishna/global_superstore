

      create or replace  table DEV_ANALYTICS.master_data.global_product_dim copy grants as
      (

select 
    distinct
    md5(cast(coalesce(cast(product_id as 
    varchar
), '') as 
    varchar
)) as product_dim_key, 
    product_id,
    product_name,
    category as product_category,
    sub_category as product_sub_category,
    current_timestamp() as record_created_datetime
from DEV_ANALYTICS.STAGE_RAW.stage_superstore_orders
      );
    