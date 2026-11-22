# ShopSphere E-commerce Analysis

End-to-end analysis of 2 years of simulated e-commerce data (2024-2025): data cleaning, SQL analysis, and an interactive dashboard.

🔗 **[View live dashboard](https://datastudio.google.com/s/vzcjbHvQq5c)**

![Overview](dashboard/dashboard_overview.png)
![Retention](dashboard/dashboard_retention.png)

## Objective
Find what drives profit and what hurts it, and turn the findings into clear recommendations.

## Key Findings
1. **Categories:** Electronics drives the most profit but has the lowest margin (20.3%). Beauty (45.9%) and Fashion (41.7%) are the most profitable per dollar.
2. **Indonesia Q3 2025:** cancel rate hit 28.5% versus a normal 1-5%, costing $15,948 in revenue.
3. **Black Friday 2025:** a 30.5% average discount lifted orders per day by only 11%, while profit per day fell 94%.
4. **Channels:** Referral customers are the most valuable ($82 profit per customer vs $74 for Organic).
5. **Retention:** about 11-12% of customers order in any given month, with no decline over the first 6 months.

## Dataset
Synthetic data generated with `data/generate_data.py`:
- `customers` (5,000), `products` (120), `orders` (8,803), `order_items` (15,136)
- Dirty data was injected on purpose to practice cleaning.

## Data Cleaning Decisions
- 60 duplicate customers removed by `customer_id`.
- Country names standardized to 6 values (e.g. "usa", "US" became "United States").
- Invalid ages (0, -1, 150) set to missing, not guessed.
- Missing discounts assumed 0, with a flag column added.
- Missing shipping costs filled with the median.
- 25 rows with negative quantities dropped.

## Metrics
- **Revenue** = quantity × unit_price × (1 − discount_pct/100)
- **Profit** = revenue − (quantity × unit_cost)
- **Cancel rate** = cancelled orders ÷ total orders
- Revenue and profit use **Delivered** orders only.

## Findings in Detail### Category performance
> - **Finding:** Electronics drives the most profit ($120K, 40% of revenue) but has the lowest margin (20.3%). Beauty (45.9%) and Fashion (41.7%) are the most profitable per dollar sold.
> - **Evidence:** Delivered orders only, 2024-2025. Revenue is net of discounts.
> - **Interpretation:** Growth in Electronics adds profit but is vulnerable to discounting. High-margin categories have headroom to scale.
> - **Recommendation:** Protect Electronics margin (limit discounts), and grow Beauty and Fashion through promotion and cross-selling.

### Indonesia Q3 2025 cancellation spike
> - **Finding:** Indonesia's cancel rate hit 28.5% in Q3 2025 (82 of 288 orders), versus a normal 1-5%. It recovered to 3.2% in Q4.
> - **Evidence:** The spike hit nearly all device and payment combinations. Other countries stayed at 1-4%.
> - **Impact:** $15,948 in cancelled revenue in one quarter.
> - **Interpretation:** Consistent with a country-wide logistics or fulfillment problem, not a device or payment bug.
> - **Recommendation:** Review Q3 2025 delivery partners and delivery times in Indonesia, and set a cancel-rate alert at about 8%.

### Black Friday 2025 discounts
> - **Finding:** Black Friday week (Nov 24-30) cut profit per day by 94% versus the prior 4 weeks ($70 vs $1,157), while revenue per day fell 18%.
> - **Evidence:** Average discount rose from 5.7% to 30.5%, but orders per day grew only 11%. Margin dropped from 28.2% to 2.1%.
> - **Interpretation:** The volume lift did not cover the margin given away.
> - **Recommendation:** Cap discounts at about 15-20%, target them at high-margin categories, and test with a control group before the next sale.

### Acquisition channel quality
> - **Finding:** Referral customers are the most valuable ($82 profit per customer vs $74 for Organic) and repeat at 62.5%.
> - **Evidence:** Buyer conversion (70-72%) and repeat rate (60-63%) are similar across all 5 channels. Differences are mainly in order value (Referral and Email about $182 vs about $171).
> - **Caveat:** No acquisition cost data, so ROI can't be calculated. The gaps are small and directional.
> - **Recommendation:** Invest in the referral program, and add cost data to compare channels on ROI.

### Customer retention
> - **Finding:** About 11-12% of customers order in any given month during their first 6 months, with no decline after month 1.
> - **Evidence:** Cohort analysis of customers who signed up before July 2025 (month 0 is lower at 6.3% because signup falls mid-month).
> - **Interpretation:** Customers return steadily rather than churning early. Monthly active share is a sign of steady engagement, not total retention.
> - **Recommendation:** Track retention beyond 6 months, and test re-engagement campaigns in the months when customers are least active.

## Limitations
- Data is simulated, so patterns (e.g. flat retention) may not match real businesses.
- No acquisition cost data, so channel ROI could not be calculated.
- Black Friday was compared with the 4 weeks before it, with no control group.
- Causes (e.g. logistics in Indonesia) are inferred, not proven.

## Tools
Python (pandas, Google Colab), SQL (BigQuery), Looker Studio, GitHub

## Project Structure
- `data/`: raw and cleaned CSVs, data generator
- `notebooks/`: cleaning notebook
- `sql/`: analysis queries (01-07)
- `dashboard/`: dashboard screenshots

## How to Reproduce
1. Run `data/generate_data.py` (or use the CSVs).
2. Clean the data with `notebooks/01_data_cleaning.ipynb`.
3. Upload cleaned tables to BigQuery.
4. Run the SQL files in `sql/` in order.
5. Connect `fact_sales` and `cohort_retention` to Looker Studio.
