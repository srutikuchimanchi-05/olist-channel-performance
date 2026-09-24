with products as (
    select * from {{ source('raw', 'products') }}
),

translations as (
    select * from {{ source('raw', 'product_category_translation') }}
),

joined as (
    select
        p.product_id,
        coalesce(
            t.product_category_name_english,
            nullif(p.product_category_name, ''),
            'unknown'
        ) as product_category
    from products p
    left join translations t
        on p.product_category_name = t.product_category_name
)

select * from joined