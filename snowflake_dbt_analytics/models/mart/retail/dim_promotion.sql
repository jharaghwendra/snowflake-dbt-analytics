{{
  config(
    materialized='table'
  )
}}

select distinct
    row_number() over (order by promo_type) as promo_sk,
    promo_type,
    promo_description
from (
    select 'none' as promo_type, 'No promotion active' as promo_description
    union all
    select 'standard' as promo_type, 'Standard promotion active' as promo_description
    union all
    select 'promo2' as promo_type, 'Recurring promo2 active' as promo_description
) promo_lookup
