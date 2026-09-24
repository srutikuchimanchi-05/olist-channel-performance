-- =====================================================================
-- 01_setup.sql
-- Creates the schemas and the file volume for the project.
--
-- Why load raw data as strings into a separate schema?
-- 1. The raw layer is an exact copy of the source, so if a cleaning step
--    has a bug, I can fix it and rebuild without re-downloading anything.
-- 2. Loading as strings never fails or silently changes data (for example,
--    zip code "01310" losing its leading zero, or a bad date becoming null).
-- 3. All type conversion and cleaning happens in dbt, where it is
--    version-controlled, documented, and tested.
-- =====================================================================

-- Schemas: one per layer of the pipeline
CREATE SCHEMA IF NOT EXISTS workspace.raw
  COMMENT 'Exact copies of the source CSVs, all columns as strings';

CREATE SCHEMA IF NOT EXISTS workspace.staging
  COMMENT 'dbt staging and intermediate models: cleaned, typed, renamed';

CREATE SCHEMA IF NOT EXISTS workspace.marts
  COMMENT 'Final tables for statistics, ML, and the dashboard';

-- Volume: a managed folder for uploading the CSV files
CREATE VOLUME IF NOT EXISTS workspace.raw.landing
  COMMENT 'Landing zone for the 11 Olist CSV files downloaded from Kaggle';