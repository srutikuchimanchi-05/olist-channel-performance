-- =====================================================================
-- 03_overlap_audit.sql
-- How many sellers acquired through the marketing funnel actually sold
-- something, overall and per channel? Decides which channels are big
-- enough to analyze on their own.
-- =====================================================================

-- Query 1: overall activation
SELECT
  COUNT(DISTINCT cd.seller_id)                                          AS closed_deal_sellers,
  COUNT(DISTINCT oi.seller_id)                                          AS sellers_with_orders,
  ROUND(COUNT(DISTINCT oi.seller_id) / COUNT(DISTINCT cd.seller_id), 3) AS pct_active
FROM workspace.raw.closed_deals cd
LEFT JOIN workspace.raw.order_items oi
  ON cd.seller_id = oi.seller_id;

-- Query 2: activation by acquisition channel
SELECT
  COALESCE(NULLIF(mql.origin, ''), 'unknown') AS origin,
  COUNT(DISTINCT cd.seller_id)                AS closed_deal_sellers,
  COUNT(DISTINCT oi.seller_id)                AS sellers_with_orders
FROM workspace.raw.closed_deals cd
JOIN workspace.raw.marketing_qualified_leads mql
  ON cd.mql_id = mql.mql_id
LEFT JOIN workspace.raw.order_items oi
  ON cd.seller_id = oi.seller_id
GROUP BY 1
ORDER BY sellers_with_orders DESC;

-- Query 3: lead-to-close conversion rate by channel
SELECT
  COALESCE(NULLIF(mql.origin, ''), 'unknown') AS origin,
  COUNT(*)                                    AS leads,
  COUNT(cd.mql_id)                            AS closed_deals,
  ROUND(COUNT(cd.mql_id) / COUNT(*), 3)       AS conversion_rate
FROM workspace.raw.marketing_qualified_leads mql
LEFT JOIN workspace.raw.closed_deals cd
  ON mql.mql_id = cd.mql_id
GROUP BY 1
ORDER BY leads DESC;