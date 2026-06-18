{{
  config(
    materialized='table'
  )
}}

with sales_data as (
    select *
    from {{ ref('int_retail_sales') }}
),
store_lookup as (
    select store_sk, store_id
    from {{ ref('dim_store') }}
),
date_lookup as (
    select date_sk, full_date
    from {{ ref('dim_date') }}
),
promotion_lookup as (
    select promo_sk, promo_type
    from {{ ref('dim_promotion') }}
)

select
    row_number() over (order by s.store_id, s.sale_date) as sales_sk,
    st.store_sk,
    d.date_sk,
    p.promo_sk,
    s.sales as sales_amount,
    s.customers,
    s.is_open,
    case
        when s.customers = 0 then null
        else s.sales / s.customers
    end as sales_per_customer,
    convert_timezone('UTC', 'Europe/Paris', current_timestamp()) as last_updated_at
from sales_data s
left join store_lookup st
    on s.store_id = st.store_id
left join date_lookup d
    on s.sale_date = d.full_date
left join promotion_lookup p
    on case
        when s.is_holiday then 'promo2'
        when s.is_promo = 1 then 'standard'
        else 'none'
    end = p.promo_type
