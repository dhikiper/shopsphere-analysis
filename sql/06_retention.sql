WITH cohort AS (
  SELECT customer_id, DATE_TRUNC(DATE(signup_date), MONTH) AS cohort_month
  FROM `shopsphere-515504.shopsphere.customers`
),
activity AS (
  SELECT
    o.customer_id,
    DATE_DIFF(DATE_TRUNC(DATE(o.order_date), MONTH), c.cohort_month, MONTH) AS month_n
  FROM `shopsphere-515504.shopsphere.orders` o
  JOIN cohort c USING (customer_id)
  WHERE o.status = 'Delivered'
)
SELECT
  c.cohort_month,
  COUNT(DISTINCT c.customer_id) AS cohort_size,
  ROUND(100 * COUNT(DISTINCT IF(a.month_n = 0, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 1) AS m0_pct,
  ROUND(100 * COUNT(DISTINCT IF(a.month_n = 1, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 1) AS m1_pct,
  ROUND(100 * COUNT(DISTINCT IF(a.month_n = 2, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 1) AS m2_pct,
  ROUND(100 * COUNT(DISTINCT IF(a.month_n = 3, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 1) AS m3_pct,
  ROUND(100 * COUNT(DISTINCT IF(a.month_n = 6, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 1) AS m6_pct
FROM cohort c
LEFT JOIN activity a USING (customer_id)
WHERE c.cohort_month <= '2025-06-01'
GROUP BY c.cohort_month
ORDER BY c.cohort_month;

WITH cohort AS (
  SELECT customer_id, DATE_TRUNC(DATE(signup_date), MONTH) AS cohort_month
  FROM `shopsphere-515504.shopsphere.customers`
  WHERE DATE_TRUNC(DATE(signup_date), MONTH) <= '2025-06-01'
),
activity AS (
  SELECT DISTINCT
    o.customer_id,
    DATE_DIFF(DATE_TRUNC(DATE(o.order_date), MONTH), c.cohort_month, MONTH) AS month_n
  FROM `shopsphere-515504.shopsphere.orders` o
  JOIN cohort c USING (customer_id)
  WHERE o.status = 'Delivered'
)
SELECT
  month_n,
  COUNT(*) AS active_customers,
  ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM cohort), 1) AS retention_pct
FROM activity
WHERE month_n BETWEEN 0 AND 6
GROUP BY month_n
ORDER BY month_n;
