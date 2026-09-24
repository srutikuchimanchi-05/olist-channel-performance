with leads as (
    select * from {{ ref('stg_leads') }}
),

deals as (
    select * from {{ ref('stg_closed_deals') }}
),

joined as (
    select
        d.seller_id,
        d.mql_id,
        l.origin,
        case
            when l.origin in ('organic_search', 'paid_search', 'unknown',
                              'direct_traffic', 'social') then l.origin
            else 'other'
        end                                          as channel_group,
        l.first_contact_date,
        d.won_date,
        datediff(d.won_date, l.first_contact_date)   as days_to_close,
        d.business_segment,
        d.lead_type,
        d.business_type,
        d.sdr_id,
        d.sr_id,
        d.won_date <= date_sub(
            cast('{{ var("data_end_date") }}' as date),
            {{ var('performance_window_days') }}
        )                                            as is_in_analysis_window
    from deals d
    inner join leads l
        on d.mql_id = l.mql_id
)

select * from joined