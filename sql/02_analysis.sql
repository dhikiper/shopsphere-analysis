SELECT
  category,
  ROUND(SUM(revenue)) AS revenue,
  ROUND(SUM(profit)) AS profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(revenue)) * 100, 1) AS margin_pct
FROM `shopsphere-515504.shopsphere.fact_sales`
WHERE status = 'Delivered'
GROUP BY category
ORDER BY profit DESC;
SELECT
  DATE_TRUNC(DATE(order_date), MONTH) AS month,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(revenue)) AS revenue,
  ROUND(SUM(profit)) AS profit
FROM `shopsphere-515504.shopsphere.fact_sales`
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;
