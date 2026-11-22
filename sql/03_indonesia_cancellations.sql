SELECT
  country,
  DATE_TRUNC(DATE(order_date), QUARTER) AS quarter,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(DISTINCT IF(status = 'Cancelled', order_id, NULL)) AS cancelled,
  ROUND(SAFE_DIVIDE(
    COUNT(DISTINCT IF(status = 'Cancelled', order_id, NULL)),
    COUNT(DISTINCT order_id)) * 100, 1) AS cancel_rate_pct
FROM `shopsphere-515504.shopsphere.fact_sales`
GROUP BY country, quarter
ORDER BY country, quarter;
SELECT
  device,
  payment_method,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SAFE_DIVIDE(
    COUNT(DISTINCT IF(status = 'Cancelled', order_id, NULL)),
    COUNT(DISTINCT order_id)) * 100, 1) AS cancel_rate_pct
FROM `shopsphere-515504.shopsphere.fact_sales`
WHERE country = 'Indonesia'
  AND DATE(order_date) BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY device, payment_method
ORDER BY cancel_rate_pct DESC;
SELECT ROUND(SUM(revenue)) AS cancelled_revenue
FROM `shopsphere-515504.shopsphere.fact_sales`
WHERE country = 'Indonesia'
  AND status = 'Cancelled'
  AND DATE(order_date) BETWEEN '2025-07-01' AND '2025-09-30';
