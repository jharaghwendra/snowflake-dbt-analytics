{{
  config(
    materialized='table'
  )
}}

with source_data as (
    select
        full_date,
        day_of_week,
        day_name,
        week_of_year,
        month_number,
        month_name,
        quarter,
        year,
        is_weekend
    from {{ ref('int_date_spine') }}
),

holiday_lookup as (
    select
        cast(date as date) as full_date,
        max(case when stateholiday in ('a', 'b', 'c') then true else false end) as is_holiday
    from {{ ref('stg_retail_rm_sales') }}
    group by 1
)

select
    row_number() over (order by s.full_date) as date_sk,
    s.full_date,
    s.day_of_week,
    s.day_name,
    s.week_of_year,
    s.month_number,
    s.month_name,
    s.quarter,
    s.year,
    s.is_weekend,
    coalesce(h.is_holiday, false) as is_holiday
from source_data s
left join holiday_lookup h
    on s.full_date = h.full_date
