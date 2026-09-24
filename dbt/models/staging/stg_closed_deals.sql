with source as (
    select * from {{ source('raw', 'closed_deals') }}
),

cleaned as (
    select
        mql_id,
        seller_id,
        sdr_id,
        sr_id,
        cast(won_date as timestamp)                     as won_at,
        cast(won_date as date)                          as won_date,
        nullif(trim(business_segment), '')              as business_segment,
        nullif(trim(lead_type), '')                     as lead_type,
        nullif(trim(business_type), '')                 as business_type,
        cast(nullif(declared_monthly_revenue, '') as double) as declared_monthly_revenue
    from source
)

select * from cleaned