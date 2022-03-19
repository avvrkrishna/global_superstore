


WITH CTE_MY_DATE AS (
    SELECT DATEADD(DAY, SEQ4(), '2012-01-01') AS MY_DATE
      FROM TABLE(GENERATOR(ROWCOUNT=>1461)))

  SELECT DATE(MY_DATE) AS CAL_DT
        ,YEAR(MY_DATE) AS FISCAL_YEAR
        ,CONCAT('F',FISCAL_YEAR,'-M',IFF(len(month(my_date)) = 1,'0',''),month(my_date)) AS FISCAL_MONTH
        ,TO_CHAR(MY_DATE,'MMMM') AS FISCAL_MONTH_FULL_NAME
        ,DAYOFWEEK(MY_DATE) AS DAY_OF_WEEK
        ,DAYOFYEAR(MY_DATE) AS DAY_OF_YEAR
        ,CASE WHEN year(current_date)-7 = fiscal_year then 0
              WHEN year(current_date)-8 = fiscal_year then -1
              WHEN year(current_date)-9 = fiscal_year then -2
              when year(current_date)-10 = fiscal_year then -3
              else -0000
         END as Current_year
         ,case when fiscal_year%4 = 0 and fiscal_year%100 != 0 then 1 else 0 end as is_leap_year
         ,date_trunc('MONTH',cal_dt) as fiscal_month_start_dt
         ,case when month(cal_dt) = 2 then
                case when is_leap_year = 1 then dateadd(day,28,fiscal_month_start_dt) else dateadd(day,27,fiscal_month_start_dt) end
          else case when month(cal_dt) in (1,3,5,7,8,10,12) then dateadd(day,30,fiscal_month_start_dt)
              else dateadd(day,29,fiscal_month_start_dt) end end as fiscal_month_end_dt
    FROM CTE_MY_DATE