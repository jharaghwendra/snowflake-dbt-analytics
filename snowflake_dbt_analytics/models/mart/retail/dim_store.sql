{{
  config(
    materialized='table'
  )
}}

select
    row_number() over (order by store_id) as store_sk,
    store_id,
    store_type,
    assortment,
    competition_distance_m,
    competition_open_since_year,
    competition_open_since_month,
    has_promo2,
    promo2_since_week,
    promo2_since_year,
    promo_interval,
    last_updated_at
from {{ ref('int_retail_store') }}
