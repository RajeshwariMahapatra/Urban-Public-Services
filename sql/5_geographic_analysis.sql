
USE urban_services;

-- 1. Top ZIP codes by request volume
-- Identifies the ZIP codes with the highest number of service requests
SELECT
    incident_zip,
    COUNT(*) AS request_count
FROM service_requests
WHERE incident_zip IS NOT NULL
GROUP BY incident_zip
ORDER BY request_count DESC
LIMIT 15;

-- 2. Top 3 complaint types within each borough
-- ROW_NUMBER ranks complaint types separately for every borough
-- PARTITION BY borough restarts the ranking for each borough
WITH borough_complaints AS (
    SELECT
        borough,
        complaint_type,
        COUNT(*) AS request_count
    FROM service_requests
    WHERE borough <> 'Unspecified'
    GROUP BY borough, complaint_type
),
ranked_complaints AS (
    SELECT
        borough,
        complaint_type,
        request_count,
        ROW_NUMBER() OVER (
            PARTITION BY borough
            ORDER BY request_count DESC
        ) AS complaint_rank
    FROM borough_complaints
)
SELECT
    borough,
    complaint_type,
    request_count
FROM ranked_complaints
WHERE complaint_rank <= 3
ORDER BY borough, complaint_rank;

-- 3. Resolution performance by borough
-- Compares average resolution time and the percentage resolved within 24 hours
-- Only requests with valid resolution durations are included
SELECT
    borough,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours,
    ROUND(
        100 * SUM(resolution_time <= 24) / COUNT(resolution_time),
        2
    ) AS pct_within_24h
FROM service_requests
WHERE resolution_time IS NOT NULL
  AND borough <> 'Unspecified'
GROUP BY borough
ORDER BY avg_resolution_hours DESC;

-- 4. ZIP codes with highest average resolution time
-- Require at least 500 resolved requests to reduce small-sample distortion
-- Shows the 15 ZIP codes with the longest average resolution durations
SELECT
    incident_zip,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL
  AND incident_zip IS NOT NULL
GROUP BY incident_zip
HAVING COUNT(resolution_time) >= 500
ORDER BY avg_resolution_hours DESC
LIMIT 15;

-- 5. Inspect complaint types in ZIP code 10466.0
-- Investigates why this ZIP code has unusually high request volume
-- Helps determine whether the high volume is driven by specific complaints
SELECT
    borough,
    complaint_type,
    COUNT(*) AS request_count
FROM service_requests
WHERE incident_zip = '10466.0'
GROUP BY borough, complaint_type
ORDER BY request_count DESC
LIMIT 15;

-- 6. Agency distribution in ZIP code 10466.0
-- Identifies which agencies receive the most requests in this ZIP code
SELECT
    agency,
    COUNT(*) AS request_count
FROM service_requests
WHERE incident_zip = '10466.0'
GROUP BY agency
ORDER BY request_count DESC;

-- 7. Geographic data quality check
-- Counts missing ZIP codes and coordinates, plus unspecified boroughs
SELECT
    COUNT(*) AS total_requests,
    SUM(incident_zip IS NULL) AS missing_zip,
    SUM(latitude IS NULL) AS missing_latitude,
    SUM(longitude IS NULL) AS missing_longitude,
    SUM(borough = 'Unspecified') AS unspecified_borough
FROM service_requests;
