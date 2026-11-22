# ShopSphere E-commerce Analysis

## Objective
Analyze 2 years of e-commerce data to find what drives profit and what hurts it.

## Business Questions
1. Which product categories drive revenue and profit?
2. What caused the Q3 2025 cancellation spike in Indonesia?
3. Did Black Friday 2025 discounts increase profit?
4. Which acquisition channel brings the best customers?
5. How well are customers retained over time?

## Tools
Python (Colab), SQL (BigQuery), Looker Studio, GitHub

## Status
🚧 In progress

## Findings

### Indonesia Q3 2025 cancellation spike
> - **Finding:** Indonesia's cancel rate hit 28.5% in Q3 2025 (82 of 288 orders), versus a normal 1-5%. It recovered to 3.2% in Q4.
> - **Evidence:** The spike hit nearly all device and payment combinations. Other countries stayed at 1-4%.
> - **Impact:** $15,948 in cancelled revenue in one quarter.
> - **Interpretation:** Consistent with a country-wide logistics or fulfillment problem, not a device or payment bug.
> - **Recommendation:** Review Q3 2025 delivery partners and delivery times in Indonesia, and set a cancel-rate alert at about 8%.
