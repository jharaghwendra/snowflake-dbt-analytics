with source_data as (
	select
		store,
		"DayOfWeek" as day_of_week,
		cast("Date" as date) as sale_date,
		sales,
		customers,
		open as is_open,
		promo as is_promo,
		stateholiday as state_holiday,
		schoolholiday as is_school_holiday
	from {{ source('landing', 'retail_rm_sales') }}
)

select
	store as store_id,
	day_of_week,
	sale_date,
	sales,
	customers,
	is_open,
	is_promo,
	state_holiday,
	case
		when state_holiday in ('a', 'b', 'c') then true
		else false
	end as is_holiday,
	case
		when state_holiday = '0' then 'none'
		when state_holiday = 'a' then 'public'
		when state_holiday = 'b' then 'easter'
		when state_holiday = 'c' then 'christmas'
		else 'unknown'
	end as holiday_type,
	is_school_holiday,
	current_timestamp() as last_updated_at
from source_data