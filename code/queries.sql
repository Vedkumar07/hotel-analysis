USE hotel_analysis;
--  Top revenue property per city using RANK()
WITH property_revenue AS (
    -- revenue per property
    SELECT
        p.property_id,
        p.property_name,
        p.property_city,
        SUM(b.total_amount) AS total_revenue
    FROM bookings b
    JOIN properties p
        ON b.property_id = p.property_id
    WHERE b.booking_status = 'Completed'    -- Footnote 8
    GROUP BY p.property_id, p.property_name, p.property_city
),

ranked AS (
    --  Rank properties within each city by revenue
    SELECT
        property_id,
        property_name,
        property_city,
        total_revenue,
        RANK() OVER (
            PARTITION BY property_city
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM property_revenue
)
-- top ranked property per city
SELECT
    property_city,
    property_id,
    property_name,
    total_revenue
FROM ranked
WHERE revenue_rank = 1
ORDER BY property_city;
-- Query 2: Frequent customers using LAG()
WITH ordered_bookings AS (
    -- bookings ordered by customer + date
    SELECT
        customer_id,
        checkin_date,
        LAG(checkin_date) OVER (
            PARTITION BY customer_id
            ORDER BY checkin_date
        ) AS previous_checkin
    FROM bookings
    WHERE booking_status = 'Completed'
),

gaps AS (
    -- Calculate gap in days between consecutive bookings
    SELECT
        customer_id,
        DATEDIFF(checkin_date, previous_checkin) AS gap_days
    FROM ordered_bookings
    WHERE previous_checkin IS NOT NULL  -- skip first booking (no previous)
),

customer_avg_gaps AS (
    -- Average gap per customer
    SELECT
        customer_id,
        AVG(gap_days) AS avg_gap_days,
        COUNT(*) AS num_gaps
    FROM gaps
    GROUP BY customer_id
)
-- customers with average gap under 30 days
SELECT
    COUNT(*) AS frequent_customers,
    ROUND(AVG(avg_gap_days), 1) AS avg_gap_among_frequent
FROM customer_avg_gaps
WHERE avg_gap_days < 30;