with whale as (
    select
        output_address,
        sum(output_value) as whale_alert_value,
        count(*) as whale_alert_count
    from {{ ref('btc_non_coinbase_transactions') }}
    where output_value > 10
    group by output_address
    order by whale_alert_value desc
)
select
    output_address,
    whale_alert_value,
    whale_alert_count,
    {{ convert_to_usd('whale_alert_value') }} as btc_price_usd
from whale
order by whale_alert_value desc