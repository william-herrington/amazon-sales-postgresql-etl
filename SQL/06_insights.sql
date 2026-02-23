-- =====================================================
-- Project: Amazon Sales Data Cleaning
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: INSIGHTS
-- File: 06_insights.sql
-- Purpose: Example insight queries using the cleaned dataset
-- =====================================================



-- 1) Top categories by demand proxy
SELECT 
	category,
	ROUND(SUM(demand_proxy), 2) AS total_demand_proxy,
	COUNT(*) AS product_rows
FROM amazon.amazon_sales_clean
GROUP BY category
ORDER BY total_demand_proxy DESC
LIMIT 10;


-- 2) Top products by raing_count
SELECT
  product_name,
  category,
  rating,
  rating_count,
  discounted_price,
  demand_proxy
FROM amazon.amazon_sales_clean
ORDER BY rating_count DESC
LIMIT 10;


-- 3) Highest average margin categories
SELECT
  category,
  ROUND(AVG(margin), 2) AS avg_margin,
  ROUND(MIN(margin), 2) AS min_margin,
  ROUND(MAX(margin), 2) AS max_margin,
  COUNT(*) AS product_rows
FROM amazon.amazon_sales_clean
GROUP BY category
ORDER BY avg_margin DESC
LIMIT 10;