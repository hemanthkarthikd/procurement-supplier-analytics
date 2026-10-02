-- ============================================================
-- PROCUREMENT & SUPPLIER PERFORMANCE ANALYTICS
-- 02 - PROCUREMENT SPEND ANALYSIS
-- ============================================================

-- Overall procurement spend
SELECT
    ROUND(SUM(order_value), 2)
        AS total_procurement_spend,

    COUNT(*) AS total_purchase_orders,

    COUNT(DISTINCT supplier_id)
        AS total_suppliers
FROM procurement_transactions;


-- Spend by supplier
SELECT
    supplier_id,
    supplier_name,

    COUNT(*) AS purchase_orders,

    ROUND(
        SUM(order_value),
        2
    ) AS total_spend,

    ROUND(
        AVG(order_value),
        2
    ) AS average_po_value

FROM procurement_transactions

GROUP BY
    supplier_id,
    supplier_name

ORDER BY
    total_spend DESC;


-- Spend by material category
SELECT
    category,

    COUNT(*) AS purchase_orders,

    ROUND(
        SUM(order_value),
        2
    ) AS total_spend,

    ROUND(
        AVG(order_value),
        2
    ) AS average_po_value

FROM procurement_transactions

GROUP BY category

ORDER BY
    total_spend DESC;


-- Supplier share of total company spend
WITH supplier_spend AS (

    SELECT
        supplier_id,
        supplier_name,
        SUM(order_value) AS total_spend

    FROM procurement_transactions

    GROUP BY
        supplier_id,
        supplier_name
),

company_spend AS (

    SELECT
        SUM(order_value) AS total_company_spend

    FROM procurement_transactions
)

SELECT
    s.supplier_id,
    s.supplier_name,

    ROUND(
        s.total_spend,
        2
    ) AS total_spend,

    ROUND(
        s.total_spend
        / c.total_company_spend
        * 100,
        2
    ) AS spend_share_pct

FROM supplier_spend s

CROSS JOIN company_spend c

ORDER BY
    total_spend DESC;
