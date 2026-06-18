{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['store_id', 'sale_date']
  )
}}

with source_data as (
    select *
    from {{ ref('stg_retail_rm_sales') }}
)

select
    store as store_id,
    dayofweek as day_of_week,
    cast(date as date) as sale_date,
    sales,
    customers,
    open as is_open,
    promo as is_promo,
    stateholiday as state_holiday,
  case
    when stateholiday in ('a', 'b', 'c') then true
        else false
    end as is_holiday,
    case
    when stateholiday = '0' then 'none'
    when stateholiday = 'a' then 'public'
    when stateholiday = 'b' then 'easter'
    when stateholiday = 'c' then 'christmas'
        else 'unknown'
    end as holiday_type,
    schoolholiday as is_school_holiday,
    current_timestamp() as last_updated_at
from source_data