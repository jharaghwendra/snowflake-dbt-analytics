{{config(
    materialized='ephemeral'
)}}

select
*
from {{ ref('btc_output') }}
where is_coinbase = false
