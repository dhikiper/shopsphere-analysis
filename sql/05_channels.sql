WITH cust AS (
  SELECT acquisition_channel, COUNT(*) AS customers
  FROM `shopsphere-515504.shopsphere.customers`
  GROUP BY acquisition_channel
),
sales AS (
  SELECT
    acquisition_channel,
    COUNT(DISTINCT customer_id) AS buyers,
    COUNT(DISTINCT order_id) AS orders,
    SUM(revenue) AS revenue,
    SUM(profit) AS profit
  FROM `shopsphere-515504.shopsphere.fact_sales`
  WHERE status = 'Delivered'
  GROUP BY acquisition_channel
)
SELECT
  c.acquisition_channel,
  c.customers,
  s.buyers,
  ROUND(s.buyers / c.customers * 100, 1) AS buyer_pct,
  s.orders,
  ROUND(s.revenue) AS revenue,
  ROUND(s.profit) AS profit,
  ROUND(s.revenue / c.customers, 1) AS revenue_per_customer,
  ROUND(s.profit / c.customers, 1) AS profit_per_customer,
  ROUND(s.revenue / s.orders, 1) AS aov
FROM cust c
JOIN sales s USING (acquisition_channel)
ORDER BY profit_per_customer DESC;
