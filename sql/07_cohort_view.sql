CREATE OR REPLACE VIEW `shopsphere-515504.shopsphere.cohort_retention` AS
WITH cohort AS (
  SELECT customer_id, DATE_TRUNC(DATE(signup_date), MONTH) AS cohort_month
  FROM `shopsphere-515504.shopsphere.customers`
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
  c.cohort_month,
  COUNT(DISTINCT c.customer_id) AS cohort_size,
  ROUND(COUNT(DISTINCT IF(a.month_n = 1, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_1,
  ROUND(COUNT(DISTINCT IF(a.month_n = 2, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_2,
  ROUND(COUNT(DISTINCT IF(a.month_n = 3, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_3,
  ROUND(COUNT(DISTINCT IF(a.month_n = 4, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_4,
  ROUND(COUNT(DISTINCT IF(a.month_n = 5, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_5,
  ROUND(COUNT(DISTINCT IF(a.month_n = 6, a.customer_id, NULL)) / COUNT(DISTINCT c.customer_id), 3) AS month_6
FROM cohort c
LEFT JOIN activity a USING (customer_id)
WHERE c.cohort_month <= '2025-06-01'
GROUP BY c.cohort_month
ORDER BY c.cohort_month;
