
-- ============================================================
-- FILE: 02_validation.sql
-- PROJECT: Urban Public Services Intelligence Platform
-- PURPOSE:
--   1. Normalize blank CSV values to SQL NULL.
--   2. Remove invalid geographic coordinates for NYC records.
--   3. Exclude invalid resolution durations from duration analysis.
--   4. Validate record counts, IDs, missingness and date ranges.
--
-- NOTE:
--   This script updates existing records. Run it after importing
--   the CSV and before running the analysis scripts.
-- ============================================================

USE urban_services;

-- STEP 1: Convert empty text fields to NULL.
-- NULL means the value is missing; an empty string is still a value.

UPDATE service_requests
SET descriptor = NULL
WHERE TRIM(descriptor) = '';

UPDATE service_requests
SET location_type = NULL
WHERE TRIM(location_type) = '';

UPDATE service_requests
SET incident_zip = NULL
WHERE TRIM(incident_zip) = '';

-- STEP 2: Normalize zero coordinates to NULL.
-- Zero latitude/longitude is not a valid location for NYC service requests.
-- Do not apply this rule to resolution_time: zero-hour resolutions can be valid.

UPDATE service_requests
SET latitude = NULL
WHERE latitude = 0;

UPDATE service_requests
SET longitude = NULL
WHERE longitude = 0;

-- STEP 3: Normalize zero dates, if any were imported.
-- Zero dates can appear when empty CSV dates are imported incorrectly.
-- Strict SQL modes may reject zero dates; the preferred prevention is
-- to import empty dates as NULL in 01_setup.sql.

UPDATE service_requests
SET closed_date = NULL
WHERE CAST(closed_date AS CHAR) LIKE '0000-00-00%';

-- STEP 4: Exclude invalid resolution durations.
-- A request cannot have a valid negative elapsed resolution time.
-- Keep the request record but set its derived duration to NULL.
-- Missing close dates also mean the resolution duration is unavailable.

UPDATE service_requests
SET resolution_time = NULL
WHERE closed_date IS NULL
   OR closed_date < created_date;

-- STEP 5: Validate total records and unique identifiers.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT unique_key) AS unique_ids,
    COUNT(*) - COUNT(DISTINCT unique_key) AS duplicate_id_count
FROM service_requests;

-- Expected for the imported sample:
-- total_records = 500000
-- unique_ids = 500000
-- duplicate_id_count = 0

-- STEP 6: Check missing values in important columns.
SELECT
    SUM(created_date IS NULL) AS missing_created_date,
    SUM(closed_date IS NULL) AS missing_closed_date,
    SUM(descriptor IS NULL) AS missing_descriptor,
    SUM(location_type IS NULL) AS missing_location_type,
    SUM(incident_zip IS NULL) AS missing_zip,
    SUM(latitude IS NULL) AS missing_latitude,
    SUM(longitude IS NULL) AS missing_longitude,
    SUM(resolution_time IS NULL) AS missing_resolution_time
FROM service_requests;

-- Expected missing counts based on the cleaned dataset:
-- missing_closed_date      = 4502
-- missing_descriptor       = 8312
-- missing_location_type    = 53557
-- missing_zip              = 3820
-- missing_latitude         = 5189
-- missing_longitude        = 5189
-- missing_resolution_time  = 4684
--
-- Missing created_date should be 0.
-- Counts can differ if the import or data has changed.

-- STEP 7: Check for negative resolution durations.
SELECT
    COUNT(*) AS negative_resolution_count
FROM service_requests
WHERE resolution_time < 0;

-- Expected: 0

-- STEP 8: Check date ranges and confirm sample coverage.
SELECT
    MIN(created_date) AS earliest_created_date,
    MAX(created_date) AS latest_created_date,
    MIN(closed_date) AS earliest_closed_date,
    MAX(closed_date) AS latest_closed_date
FROM service_requests;

-- The 500,000-row sample was ordered by creation date.
-- Its creation-date coverage is approximately 1 Jan–18 Feb 2025.
-- Closed dates can extend beyond that period because requests may
-- be resolved long after they were created.

-- STEP 9: Confirm the final table structure.
DESCRIBE service_requests;
