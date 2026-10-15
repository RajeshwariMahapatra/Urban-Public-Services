
-- ============================================================
-- FILE: 01_setup.sql
-- PROJECT: Urban Public Services Intelligence Platform
-- PURPOSE:
--   1. Create the database and target table.
--   2. Enable local CSV import (requires suitable privileges).
--   3. Import the cleaned NYC 311 CSV.
--
-- IMPORTANT:
--   - Run the import only once on an empty table.
--   - Do not drop the table if it already contains your data.
--   - Update the CSV path if your project folder is elsewhere.
-- ============================================================

-- STEP 1: Create and select the project database
CREATE DATABASE IF NOT EXISTS urban_services;
USE urban_services;

-- STEP 2: Allow CSV imports from the MySQL client.
-- This setting may require administrator privileges.
-- If LOCAL INFILE is disabled, run this separately in MySQL:
-- SET GLOBAL local_infile = 1;
--
-- Then exit and reconnect from Windows Command Prompt:
-- mysql --local-infile=1 -u root -p
--
-- STEP 3: Create the table matching the cleaned CSV.
-- ZIP codes are VARCHAR because they are identifiers, not measurements.
-- DECIMAL is used for coordinates and resolution time to control precision.

CREATE TABLE IF NOT EXISTS service_requests (
    unique_key BIGINT PRIMARY KEY,
    created_date DATETIME,
    closed_date DATETIME,
    agency VARCHAR(20),
    complaint_type VARCHAR(150),
    descriptor VARCHAR(255),
    location_type VARCHAR(150),
    status VARCHAR(30),
    borough VARCHAR(30),
    incident_zip VARCHAR(10),
    community_board VARCHAR(50),
    open_data_channel_type VARCHAR(30),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    resolution_time DECIMAL(12,2)
);

-- STEP 4: Import the cleaned CSV.
-- LOAD DATA LOCAL INFILE reads the file from your computer.
-- Temporary variables allow empty CSV fields to be converted to SQL NULL.
--
-- Run this section ONCE. A second import may fail because unique_key
-- is a primary key and must be unique.

LOAD DATA LOCAL INFILE
'C:/Users/ranji/Downloads/Urban-Public-Services/data/processed/nyc_311_2025_clean.csv'
INTO TABLE service_requests
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    unique_key,
    @created_date,
    @closed_date,
    agency,
    @complaint_type,
    @descriptor,
    @location_type,
    status,
    borough,
    @incident_zip,
    community_board,
    open_data_channel_type,
    @latitude,
    @longitude,
    @resolution_time
)
SET
    created_date = NULLIF(@created_date, ''),
    closed_date = NULLIF(@closed_date, ''),
    complaint_type = NULLIF(@complaint_type, ''),
    descriptor = NULLIF(@descriptor, ''),
    location_type = NULLIF(@location_type, ''),
    incident_zip = NULLIF(@incident_zip, ''),
    latitude = NULLIF(@latitude, ''),
    longitude = NULLIF(@longitude, ''),
    resolution_time = NULLIF(@resolution_time, '');

-- STEP 5: Basic import confirmation
SELECT
    COUNT(*) AS imported_records,
    COUNT(DISTINCT unique_key) AS unique_request_ids
FROM service_requests;

-- Expected after a successful first import:
-- imported_records = 500000
-- unique_request_ids = 500000
