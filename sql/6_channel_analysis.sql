
USE urban_services;

-- 1. Resolution performance by submission channel
-- Compares average resolution time and the percentage resolved within 24 hours
-- Requests without a valid resolution duration are excluded
SELECT
    open_data_channel_type,
    COUNT(*) AS request_count,
    COUNT(resolution_time) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours,
    ROUND(
        100 * SUM(resolution_time <= 24) /
        NULLIF(COUNT(resolution_time), 0),
        2
    ) AS pct_within_24h
FROM service_requests
GROUP BY open_data_channel_type
ORDER BY request_count DESC;

-- 2. Top complaint types within each submission channel
-- Helps investigate whether different channels are used for different complaints
-- ROW_NUMBER ranks complaints separately within each channel
WITH complaint_counts AS (
    SELECT
        open_data_channel_type,
        complaint_type,
        COUNT(*) AS request_count
    FROM service_requests
    GROUP BY open_data_channel_type, complaint_type
),
ranked_complaints AS (
    SELECT
        open_data_channel_type,
        complaint_type,
        request_count,
        ROW_NUMBER() OVER (
            PARTITION BY open_data_channel_type
            ORDER BY request_count DESC
        ) AS complaint_rank
    FROM complaint_counts
)
SELECT
    open_data_channel_type,
    complaint_type,
    request_count
FROM ranked_complaints
WHERE complaint_rank <= 5
ORDER BY open_data_channel_type, complaint_rank;

-- 3. Top 5 agencies within each submission channel
-- Shows which agencies receive the most requests through each channel
WITH agency_counts AS (
    SELECT
        open_data_channel_type,
        agency,
        COUNT(*) AS request_count
    FROM service_requests
    GROUP BY open_data_channel_type, agency
),
ranked_agencies AS (
    SELECT
        open_data_channel_type,
        agency,
        request_count,
        ROW_NUMBER() OVER (
            PARTITION BY open_data_channel_type
            ORDER BY request_count DESC
        ) AS agency_rank
    FROM agency_counts
)
SELECT
    open_data_channel_type,
    agency,
    request_count
FROM ranked_agencies
WHERE agency_rank <= 5
ORDER BY open_data_channel_type, agency_rank;

-- 4. Resolution performance by channel within each agency
-- Helps investigate whether agency differences may explain channel results
-- Require at least 100 valid resolution durations per agency-channel group
-- This is a descriptive comparison, not proof of causation
SELECT
    agency,
    open_data_channel_type,
    COUNT(*) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours,
    ROUND(
        100 * SUM(resolution_time <= 24) / COUNT(*),
        2
    ) AS pct_within_24h
FROM service_requests
WHERE resolution_time IS NOT NULL
GROUP BY agency, open_data_channel_type
HAVING COUNT(*) >= 100
ORDER BY agency, avg_resolution_hours;

-- 5. Resolution performance by channel and complaint type
-- Helps compare channels for the same complaint categories
-- Require at least 100 valid resolution durations per group
SELECT
    open_data_channel_type,
    complaint_type,
    COUNT(*) AS resolved_requests,
    ROUND(AVG(resolution_time), 2) AS avg_resolution_hours,
    ROUND(
        100 * SUM(resolution_time <= 24) / COUNT(*),
        2
    ) AS pct_within_24h
FROM service_requests
WHERE resolution_time IS NOT NULL
  AND complaint_type IS NOT NULL
GROUP BY open_data_channel_type, complaint_type
HAVING COUNT(*) >= 100
ORDER BY complaint_type, avg_resolution_hours;

-- 6. Check submission channel values
-- Shows the number of requests in each channel
-- Keeps UNKNOWN as a separate category because it is a recorded value
SELECT
    open_data_channel_type,
    COUNT(*) AS request_count
FROM service_requests
GROUP BY open_data_channel_type
ORDER BY request_count DESC;
