-- Active sellers must have positive revenue; inactive sellers must have zero.
select *
from {{ ref('fact_seller_channel_performance') }}
where (is_active_90d and revenue_90d <= 0)
   or (not is_active_90d and revenue_90d <> 0)