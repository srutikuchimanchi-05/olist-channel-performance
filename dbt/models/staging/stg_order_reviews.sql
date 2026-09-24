with source as (
    select * from {{ source('raw', 'order_reviews') }}
),

cleaned as (
    select
        review_id,
        order_id,
        cast(review_score as int)                  as review_score,
        cast(review_creation_date as timestamp)    as review_created_at,
        cast(review_answer_timestamp as timestamp) as review_answered_at
    from source
),

deduplicated as (
    select
        *,
        row_number() over (
            partition by order_id
            order by review_answered_at desc
        ) as review_rank
    from cleaned
)

select
    review_id,
    order_id,
    review_score,
    review_created_at,
    review_answered_at
from deduplicated
where review_rank = 1