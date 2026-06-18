{{
  config(
    materialized='table'
  )
}}

select
    row_number() over (order by store_id, sale_date) as forecast_sk,
    store_id,
    sale_date,
    convert_timezone('UTC', 'Europe/Berlin', current_timestamp()) as forecast_date,
    -- These measures are populated by a downstream forecasting model.
    cast(null as number(18,2)) as predicted_sales,
    cast(null as number(18,2)) as actual_sales,
    cast(null as number(18,2)) as forecast_error,
    cast(null as number(18,2)) as forecast_error_pct,
    convert_timezone('UTC', 'Europe/Berlin', current_timestamp()) as last_updated_at
from {{ ref('int_retail_sales') }}
