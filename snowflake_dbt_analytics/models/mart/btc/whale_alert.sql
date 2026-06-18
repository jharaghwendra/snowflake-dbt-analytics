with whale as (
    select     
        output_address,
        sum(output_value) as whale_alert_value,
        count(*) as whale_alert_count
    from {{ ref('btc_non_coinbase_transactions') }}
    where output_value > 10
    group by output_address
)
select
    '{{ invocation_id }}' as invocation_id,
    output_address,
    whale_alert_value,
    whale_alert_count,
    {{ convert_to_usd('whale_alert_value') }} as btc_price_usd
from whale
