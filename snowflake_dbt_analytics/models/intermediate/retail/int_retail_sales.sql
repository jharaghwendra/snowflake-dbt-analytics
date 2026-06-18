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
  store_id,
  day_of_week,
  sale_date,
  sales,
  customers,
  is_open,
  is_promo,
  state_holiday,
  is_holiday,
  holiday_type,
  is_school_holiday,
    current_timestamp() as last_updated_at
from source_data