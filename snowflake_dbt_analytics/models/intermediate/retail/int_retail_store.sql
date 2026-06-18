{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='store_id'
  )
}}

with source_data as (
    select *
    from {{ ref('stg_retail_rm_store') }}
)

select
    store as store_id,
    storetype as store_type,
    assortment,
    competitiondistance as competition_distance_m,
    competitionopensincemonth as competition_open_since_month,
    competitionopensinceyear as competition_open_since_year,
    promo2 as has_promo2,
    promo2sinceweek as promo2_since_week,
    promo2sinceyear as promo2_since_year,
    promointerval as promo_interval,
    current_timestamp() as last_updated_at
from source_data
