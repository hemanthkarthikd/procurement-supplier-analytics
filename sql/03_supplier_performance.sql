-- ============================================================
-- PROCUREMENT & SUPPLIER PERFORMANCE ANALYTICS
-- 03 - SUPPLIER PERFORMANCE KPIs
-- ============================================================

SELECT
    supplier_id,
    supplier_name,

    COUNT(*) AS total_orders,

    ROUND(
        SUM(order_value),
        2
    ) AS total_spend,


    -- On-Time Delivery %
    ROUND(
        AVG(
            CASE
                WHEN julianday(actual_delivery_date)
                     <= julianday(promised_delivery_date)
                THEN 100.0
                ELSE 0.0
            END
        ),
        2
    ) AS on_time_delivery_pct,


    -- Quantity-weighted Fill Rate %
    ROUND(
        SUM(quantity_received) * 100.0
        / NULLIF(
            SUM(quantity_ordered),
            0
        ),
        2
    ) AS fill_rate_pct,


    -- On-Time In-Full %
    ROUND(
        AVG(
            CASE
                WHEN julianday(actual_delivery_date)
                     <= julianday(promised_delivery_date)
                 AND quantity_received
                     >= quantity_ordered
                THEN 100.0
                ELSE 0.0
            END
        ),
        2
    ) AS otif_pct,


    -- Defect Rate %
    ROUND(
        SUM(defective_units) * 100.0
        / NULLIF(
            SUM(quantity_received),
            0
        ),
        2
    ) AS defect_rate_pct,


    -- Average Purchase Price Variance %
    ROUND(
        AVG(
            (
                actual_unit_price
                - standard_unit_price
            )
            / NULLIF(
                standard_unit_price,
                0
            )
            * 100.0
        ),
        2
    ) AS avg_price_variance_pct,


    -- Average Actual Lead Time
    ROUND(
        AVG(
            julianday(actual_delivery_date)
            - julianday(order_date)
        ),
        2
    ) AS avg_lead_time_days

FROM procurement_transactions

GROUP BY
    supplier_id,
    supplier_name

ORDER BY
    total_spend DESC;
