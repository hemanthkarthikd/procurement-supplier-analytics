-- ============================================================
-- PROCUREMENT & SUPPLIER PERFORMANCE ANALYTICS
-- 04 - ABC / PARETO SUPPLIER ANALYSIS
-- ============================================================

WITH supplier_spend AS (

    SELECT
        supplier_id,
        supplier_name,

        SUM(order_value)
            AS total_spend

    FROM procurement_transactions

    GROUP BY
        supplier_id,
        supplier_name
),

ranked_spend AS (

    SELECT
        supplier_id,
        supplier_name,
        total_spend,

        SUM(total_spend) OVER (
            ORDER BY total_spend DESC
        ) AS cumulative_spend,

        SUM(total_spend) OVER ()
            AS company_spend

    FROM supplier_spend
),

classified AS (

    SELECT
        supplier_id,
        supplier_name,
        total_spend,

        total_spend
        / company_spend
        * 100
            AS spend_share_pct,

        cumulative_spend
        / company_spend
        * 100
            AS cumulative_spend_pct

    FROM ranked_spend
)

SELECT
    supplier_id,
    supplier_name,

    ROUND(
        total_spend,
        2
    ) AS total_spend,

    ROUND(
        spend_share_pct,
        2
    ) AS spend_share_pct,

    ROUND(
        cumulative_spend_pct,
        2
    ) AS cumulative_spend_pct,

    CASE

        WHEN cumulative_spend_pct <= 80
            THEN 'A'

        WHEN cumulative_spend_pct <= 95
            THEN 'B'

        ELSE 'C'

    END AS abc_class

FROM classified

ORDER BY
    total_spend DESC;
