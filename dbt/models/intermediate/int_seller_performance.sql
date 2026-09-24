with deals as (
    select seller_id, won_date from {{ ref('stg_closed_deals') }}
),

items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
    where order_status not in ('canceled', 'unavailable')
),

reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

-- How many different sellers are on each order
order_seller_counts as (
    select order_id, count(distinct seller_id) as sellers_on_order
    from items
    group by order_id
),

-- Every item each seller sold within 90 days of signing
seller_items_in_window as (
    select
        i.seller_id,
        i.order_id,
        i.product_id,
        i.price,
        o.purchased_at,
        o.delivered_to_customer_at,
        o.estimated_delivery_date,
        osc.sellers_on_order
    from deals d
    inner join items i                on d.seller_id = i.seller_id
    inner join orders o               on i.order_id = o.order_id
    inner join order_seller_counts osc on i.order_id = osc.order_id
    where cast(o.purchased_at as date) >= d.won_date
      and cast(o.purchased_at as date) <  date_add(d.won_date, {{ var('performance_window_days') }})
),

-- Collapse items to one row per seller per order
seller_orders as (
    select
        seller_id,
        order_id,
        min(purchased_at)             as purchased_at,
        max(delivered_to_customer_at) as delivered_at,
        max(estimated_delivery_date)  as estimated_delivery_date,
        max(sellers_on_order)         as sellers_on_order,
        sum(price)                    as order_revenue
    from seller_items_in_window
    group by seller_id, order_id
),

-- Add review score and delivery delay to each order
order_metrics as (
    select
        so.*,
        r.review_score,
        datediff(cast(so.delivered_at as date), so.estimated_delivery_date) as delivery_delay_days
    from seller_orders so
    left join reviews r on so.order_id = r.order_id
),

-- Each seller's most common product category
seller_categories as (
    select
        s.seller_id,
        p.product_category,
        row_number() over (
            partition by s.seller_id
            order by count(*) desc, p.product_category
        ) as category_rank
    from seller_items_in_window s
    inner join products p on s.product_id = p.product_id
    group by s.seller_id, p.product_category
),

-- Roll everything up to one row per seller
aggregated as (
    select
        seller_id,
        count(*)                        as orders_90d,
        sum(order_revenue)              as revenue_90d,
        min(purchased_at)               as first_sale_at,
        avg(case when sellers_on_order = 1 then review_score end)        as avg_review_score_90d,
        count(case when sellers_on_order = 1
                    and review_score is not null then 1 end)             as reviewed_orders_90d,
        avg(case when sellers_on_order = 1 then delivery_delay_days end) as avg_delivery_delay_days_90d,
        avg(case when sellers_on_order = 1 and delivered_at is not null
                 then case when delivery_delay_days > 0 then 1.0 else 0.0 end
            end)                                                         as late_delivery_rate_90d
    from order_metrics
    group by seller_id
)

select
    d.seller_id,
    a.orders_90d is not null                           as is_active_90d,
    coalesce(a.orders_90d, 0)                          as orders_90d,
    coalesce(a.revenue_90d, 0)                         as revenue_90d,
    a.first_sale_at,
    datediff(cast(a.first_sale_at as date), d.won_date) as days_to_first_sale,
    a.avg_review_score_90d,
    a.reviewed_orders_90d,
    a.avg_delivery_delay_days_90d,
    a.late_delivery_rate_90d,
    c.product_category                                 as primary_product_category
from deals d
left join aggregated a       on d.seller_id = a.seller_id
left join seller_categories c on d.seller_id = c.seller_id and c.category_rank = 1