with source_data as (
	select
		store,
		storetype,
		assortment,
		competitiondistance,
		competitionopensincemonth,
		competitionopensinceyear,
		promo2,
		promo2sinceweek,
		promo2sinceyear,
		promointerval
	from {{ source('landing', 'retail_rm_store') }}
)

select
	store as store_id,
	storetype as store_type,
	assortment,
	competitiondistance as competition_distance_m,
	competitionopensincemonth as competition_open_since_month,
	competitionopensinceyear as competition_open_since_year,
	promo2 as has_promo2,
	promo2sinceweek as promo2_since_week,
	promo2sinceyear as promo2_since_year,
	promointerval as promo_interval,
	current_timestamp() as last_updated_at
from source_data