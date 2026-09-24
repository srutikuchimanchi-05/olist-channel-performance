with source as (
    select * from {{ source('raw', 'sellers') }}
),

cleaned as (
    select
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        upper(seller_state) as seller_state
    from source
)

select * from cleaned