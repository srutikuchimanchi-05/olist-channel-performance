-- =====================================================================
-- 02_load_raw.sql
-- Loads the 11 CSVs from the landing volume into tables in workspace.raw.
-- Every column stays a string; typing and cleaning happen in dbt.
-- =====================================================================

-- ---------- E-commerce tables ----------

CREATE OR REPLACE TABLE workspace.raw.orders AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_orders_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.order_items AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_order_items_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.order_payments AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_order_payments_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

-- Reviews contain comments with line breaks and quotes inside them,
-- so this table needs two extra options.
CREATE OR REPLACE TABLE workspace.raw.order_reviews AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_order_reviews_dataset.csv',
  format => 'csv', header => true, inferSchema => false,
  multiLine => true,
  escape => '"'
);

CREATE OR REPLACE TABLE workspace.raw.products AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_products_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.sellers AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_sellers_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.customers AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_customers_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.geolocation AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_geolocation_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.product_category_translation AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/product_category_name_translation.csv',
  format => 'csv', header => true, inferSchema => false
);

-- ---------- Marketing funnel tables ----------

CREATE OR REPLACE TABLE workspace.raw.marketing_qualified_leads AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_marketing_qualified_leads_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

CREATE OR REPLACE TABLE workspace.raw.closed_deals AS
SELECT *, current_timestamp() AS _loaded_at
FROM read_files(
  '/Volumes/workspace/raw/landing/olist_closed_deals_dataset.csv',
  format => 'csv', header => true, inferSchema => false
);

-- ---------- Check: row count per table ----------

SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM workspace.raw.orders
UNION ALL SELECT 'order_items',                  COUNT(*) FROM workspace.raw.order_items
UNION ALL SELECT 'order_payments',               COUNT(*) FROM workspace.raw.order_payments
UNION ALL SELECT 'order_reviews',                COUNT(*) FROM workspace.raw.order_reviews
UNION ALL SELECT 'products',                     COUNT(*) FROM workspace.raw.products
UNION ALL SELECT 'sellers',                      COUNT(*) FROM workspace.raw.sellers
UNION ALL SELECT 'customers',                    COUNT(*) FROM workspace.raw.customers
UNION ALL SELECT 'geolocation',                  COUNT(*) FROM workspace.raw.geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM workspace.raw.product_category_translation
UNION ALL SELECT 'marketing_qualified_leads',    COUNT(*) FROM workspace.raw.marketing_qualified_leads
UNION ALL SELECT 'closed_deals',                 COUNT(*) FROM workspace.raw.closed_deals;