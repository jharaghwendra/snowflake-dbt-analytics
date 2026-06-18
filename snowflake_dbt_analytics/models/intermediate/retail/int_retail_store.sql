{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='store_id'
  )
}}

select *
from {{ ref('stg_retail_rm_store') }}
