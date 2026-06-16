{{
  config(
    materialized='incremental',
    incremental_strategy='append'
  )
}}

with flatened_btc as (
select
    b.hash_key,
    b.block_timestamp,
    b.block_number,
    b.is_coinbase,
    o.value:address::string as output_address,
    o.value:value::string as output_value
from {{ ref('btc') }} b,

lateral flatten(input => outputs) as o

where o.value:address is not null

{% if is_incremental() %}
and b.block_timestamp >= (select coalesce(max(block_timestamp), '1970-01-01') from {{ this }})
{% endif %}

)
select hash_key,
    block_timestamp,
    block_number,
    is_coinbase,
    output_address,
    output_value
from flatened_btc