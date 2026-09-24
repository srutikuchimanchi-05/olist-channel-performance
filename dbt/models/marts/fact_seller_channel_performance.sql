with acquisition as (
    select * from {{ ref('int_seller_acquisition') }}
),

performance as (
    select * from {{ ref('int_seller_performance') }}
),

final as (
    select
        -- identifiers
        a.seller_id,
        a.mql_id,

        -- how the seller was acquired
        a.origin,
        a.channel_group,
        a.first_contact_date,
        a.won_date,
        cast(date_trunc('month', a.won_date) as date) as won_month,
        a.days_to_close,

        -- seller characteristics (control variables)
        a.business_segment,
        a.lead_type,
        a.business_type,
        a.sr_id,
        p.primary_product_category,

        -- 90-day outcomes
        p.is_active_90d,
        p.orders_90d,
        p.revenue_90d,
        p.first_sale_at,
        p.days_to_first_sale,
        p.avg_review_score_90d,
        p.reviewed_orders_90d,
        p.avg_delivery_delay_days_90d,
        p.late_delivery_rate_90d

    from acquisition a
    inner join performance p
        on a.seller_id = p.seller_id
    where a.is_in_analysis_window
)

select * from final