{{
  config(
    materialized='table'
  )
}}

with date_bounds as (
    select
        min(cast(date as date)) as start_date,
        max(cast(date as date)) as end_date
    from {{ ref('stg_retail_rm_sales') }}
),

recursive_dates as (
    select start_date as date_day, end_date
    from date_bounds

    union all

    select dateadd(day, 1, date_day) as date_day, end_date
    from recursive_dates
    where date_day < end_date
)

select
    date_day as full_date,
    extract(dayofweek from date_day) as day_of_week,
    case extract(dayofweek from date_day)
        when 0 then 'Saturday'
        when 1 then 'Sunday'
        when 2 then 'Monday'
        when 3 then 'Tuesday'
        when 4 then 'Wednesday'
        when 5 then 'Thursday'
        when 6 then 'Friday'
    end as day_name,
    extract(week from date_day) as week_of_year,
    extract(month from date_day) as month_number,    
    to_char(date_day, 'Mon') as month_name,
    extract(quarter from date_day) as quarter,
    extract(year from date_day) as year,
    case when extract(dayofweek from date_day) in (0, 1) then true else false end as is_weekend
from recursive_dates
