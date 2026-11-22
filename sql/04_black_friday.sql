WITH daily AS (
  SELECT
    DATE(order_date) AS d,
    CASE
      WHEN DATE(order_date) BETWEEN '2025-11-24' AND '2025-11-30' THEN 'Black Friday week'
      WHEN DATE(order_date) BETWEEN '2025-10-27' AND '2025-11-23' THEN 'Baseline (4 weeks before)'
    END AS period,
    order_id, revenue, profit, discount_pct
  FROM `shopsphere-515504.shopsphere.fact_sales`
  WHERE status = 'Delivered'
)
SELECT
  period,
  COUNT(DISTINCT d) AS days,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(revenue)) AS revenue,
  ROUND(SUM(profit)) AS profit,
  ROUND(SUM(profit) / SUM(revenue) * 100, 1) AS margin_pct,
  ROUND(SUM(revenue) / COUNT(DISTINCT d)) AS revenue_per_day,
  ROUND(SUM(profit) / COUNT(DISTINCT d)) AS profit_per_day,
  ROUND(AVG(discount_pct), 1) AS avg_discount_pct
FROM daily
WHERE period IS NOT NULL
GROUP BY period;
