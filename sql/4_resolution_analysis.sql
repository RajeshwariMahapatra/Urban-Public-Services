
USE urban_services;

-- 1. Overall resolution time baseline
-- Shows the number of valid resolution durations, average, minimum and maximum
SELECT
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours,
    ROUND(MIN(resolution_time), 2) AS min_resolution_hours,
    ROUND(MAX(resolution_time), 2) AS max_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL;

-- 2. Median resolution time
-- The median helps us understand the typical resolution time
-- without being as affected by unusually long-running requests
SELECT
    ROUND(AVG(resolution_time), 2) AS median_resolution_hours
FROM (
    SELECT
        resolution_time,
        ROW_NUMBER() OVER (ORDER BY resolution_time) AS rn,
        COUNT(*) OVER () AS total_count
    FROM service_requests
    WHERE resolution_time IS NOT NULL
) ranked
WHERE rn IN (
    FLOOR((total_count + 1) / 2),
    CEIL((total_count + 1) / 2)
);

-- 3. Average resolution time by agency
-- Compares average resolution durations across agencies
SELECT
    agency,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY agency
ORDER BY avg_resolution_hours;

-- 4. Average resolution time by agency
-- Exclude agencies with very small resolved-request volumes
-- At least 1,000 valid resolution durations are required
SELECT
    agency,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY agency
HAVING COUNT(resolution_time) >= 1000
ORDER BY avg_resolution_hours;

-- 5. Average resolution time by complaint type
-- Exclude complaint types with very small resolved-request volumes
-- Show the 15 complaint types with the highest average resolution time
SELECT
    complaint_type,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY complaint_type
HAVING COUNT(resolution_time) >= 1000
ORDER BY avg_resolution_hours DESC
LIMIT 15;

-- 6. Average resolution time by borough
-- Compares average resolution durations across boroughs
SELECT
    borough,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY borough
ORDER BY avg_resolution_hours DESC;

-- 7. Percentage of resolved requests completed within 24 hours
-- Exclude agencies with very small resolved-request volumes
-- SUM(resolution_time <= 24) counts requests resolved within 24 hours
SELECT
    agency,
    COUNT(resolution_time) AS resolved_requests,
    SUM(resolution_time <= 24) AS resolved_within_24h,
    ROUND(
        100 * SUM(resolution_time <= 24) / COUNT(resolution_time),
        2
    ) AS pct_within_24h
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY agency
HAVING COUNT(resolution_time) >= 1000
ORDER BY pct_within_24h DESC;

-- 8. Monthly request volume and average resolution time
-- Groups requests by the month they were created
-- The dataset covers January 1 to February 18, 2025
-- February is therefore only a partial month
SELECT
    DATE_FORMAT(created_date, '%Y-%m') AS month,
    COUNT(*) AS request_count,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours
FROM service_requests
GROUP BY DATE_FORMAT(created_date, '%Y-%m')
ORDER BY month;

-- Findings from the current sample:
-- January: 238.66 hours average resolution time
-- February: 224.80 hours average resolution time
-- Difference: approximately 13.9 hours lower in February
-- This is descriptive only; February is a partial month.
