-- ============================================================
-- PROCUREMENT & SUPPLIER PERFORMANCE ANALYTICS
-- 01 - DATA QUALITY CHECKS
-- ============================================================

-- Dataset overview
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT po_number) AS unique_purchase_orders,
    COUNT(DISTINCT supplier_id) AS total_suppliers,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT plant) AS total_plants
FROM procurement_transactions;


-- Check for duplicate purchase orders
SELECT
    po_number,
    COUNT(*) AS occurrences
FROM procurement_transactions
GROUP BY po_number
HAVING COUNT(*) > 1;


-- Check critical fields for missing values
SELECT
    SUM(CASE WHEN po_number IS NULL THEN 1 ELSE 0 END)
        AS missing_po_number,

    SUM(CASE WHEN supplier_id IS NULL THEN 1 ELSE 0 END)
        AS missing_supplier,

    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)
        AS missing_order_date,

    SUM(CASE WHEN quantity_ordered IS NULL THEN 1 ELSE 0 END)
        AS missing_quantity,

    SUM(CASE WHEN actual_unit_price IS NULL THEN 1 ELSE 0 END)
        AS missing_actual_price,

    SUM(CASE WHEN promised_delivery_date IS NULL THEN 1 ELSE 0 END)
        AS missing_promised_delivery,

    SUM(CASE WHEN actual_delivery_date IS NULL THEN 1 ELSE 0 END)
        AS missing_actual_delivery
FROM procurement_transactions;


-- Validate quantities and prices
SELECT
    COUNT(*) AS invalid_records
FROM procurement_transactions
WHERE
    quantity_ordered <= 0
    OR quantity_received < 0
    OR standard_unit_price <= 0
    OR actual_unit_price <= 0;


-- Validate delivery dates
SELECT
    COUNT(*) AS impossible_delivery_dates
FROM procurement_transactions
WHERE
    julianday(actual_delivery_date)
    < julianday(order_date);
