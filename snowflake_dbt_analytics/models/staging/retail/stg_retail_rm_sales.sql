select
*
from {{ source('landing', 'retail_rm_sales') }}