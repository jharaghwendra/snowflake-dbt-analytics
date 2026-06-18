{{
  config(
    materialized='incremental',
    incremental_strategy='merge',    
    unique_key='hash_key'
  )
}}

select
*
from {{ source('landing', 'btc') }}

{% if is_incremental() %}
where block_timestamp >= (select coalesce(max(block_timestamp), '1970-01-01') from {{ this }})
{% endif %}