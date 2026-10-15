
USE urban_services;

-- 1. Top complaint types by request volume
-- Identifies the most frequently reported public-service issues
SELECT
    complaint_type,
    COUNT(*) AS request_count
FROM service_requests
GROUP BY complaint_type
ORDER BY request_count DESC
LIMIT 10;

-- 2. Agencies handling the highest volume of requests
-- Identifies agencies receiving the most service requests
SELECT
    agency,
    COUNT(*) AS request_count
FROM service_requests
GROUP BY agency
ORDER BY request_count DESC
LIMIT 10;

-- 3. Service request volume by borough
-- Compares the number of requests across NYC boroughs
SELECT
    borough,
    COUNT(*) AS request_count
FROM service_requests
GROUP BY borough
ORDER BY request_count DESC;

-- 4. Service request volume by submission channel
-- Shows how people submit their service requests
SELECT
    open_data_channel_type,
    COUNT(*) AS request_count
FROM service_requests
GROUP BY open_data_channel_type
ORDER BY request_count DESC;

-- 5. Top 3 complaint types within each agency
-- ROW_NUMBER ranks complaint types separately for each agency
-- PARTITION BY agency restarts the ranking for every agency
WITH complaint_counts AS (
    SELECT
        agency,
        complaint_type,
        COUNT(*) AS request_count
    FROM service_requests
    GROUP BY agency, complaint_type
),
ranked_complaints AS (
    SELECT
        agency,
        complaint_type,
        request_count,
        ROW_NUMBER() OVER (
            PARTITION BY agency
            ORDER BY request_count DESC
        ) AS complaint_rank
    FROM complaint_counts
)
SELECT
    agency,
    complaint_type,
    request_count
FROM ranked_complaints
WHERE complaint_rank <= 3
ORDER BY agency, complaint_rank;
