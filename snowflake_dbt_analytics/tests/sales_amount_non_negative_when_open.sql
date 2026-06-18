select *
from {{ ref('fact_daily_sales') }}
where is_open = true
  and sales_amount < 0
