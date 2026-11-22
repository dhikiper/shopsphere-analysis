CREATE OR REPLACE VIEW `shopsphere-515504.shopsphere.fact_sales` AS
SELECT
  o.order_id,
  o.order_date,
  o.status,
  o.device,
  o.payment_method,
  o.discount_pct,
  o.shipping_cost,
  c.customer_id,
  c.country,
  c.acquisition_channel,
  c.signup_date,
  p.product_id,
  p.category,
  oi.quantity,
  oi.quantity * p.unit_price * (1 - o.discount_pct / 100) AS revenue,
  oi.quantity * p.unit_price * (1 - o.discount_pct / 100)
    - oi.quantity * p.unit_cost AS profit
FROM `shopsphere-515504.shopsphere.order_items` oi
JOIN `shopsphere-515504.shopsphere.orders` o USING (order_id)
JOIN `shopsphere-515504.shopsphere.customers` c USING (customer_id)
JOIN `shopsphere-515504.shopsphere.products` p USING (product_id);
