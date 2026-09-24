with source as (
    select * from {{ source('raw', 'order_items') }}
),

cleaned as (
    select
        order_id,
        cast(order_item_id as int)               as order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp)   as shipping_limit_at,
        cast(price as decimal(10, 2))            as price,
        cast(freight_value as decimal(10, 2))    as freight_value
    from source
)

select * from cleaned