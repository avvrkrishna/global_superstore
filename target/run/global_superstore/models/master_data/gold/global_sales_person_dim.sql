

      create or replace  table DEV_ANALYTICS.master_data.global_sales_person_dim copy grants as
      (

select
    md5(cast(coalesce(cast(sales_person_name as 
    varchar
), '') as 
    varchar
)) as sales_person_dim_key,
    sales_person_name,
    sales_person_region,
    current_timestamp() as record_created_datetime
from DEV_ANALYTICS.STAGE_RAW.stage_sales_person_dim
      );
    