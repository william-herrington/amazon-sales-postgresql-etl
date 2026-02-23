-- ===========================================
-- Project: Amazon Sales Data Cleaning
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: FEATURES
-- File: 05_business_Logic.sql
-- Purpose: Add business Logic columns (margin, rating buckets, demand proxy)
-- ===========================================




-- 1) Margin
ALTER TABLE amazon.amazon_sales_clean
ADD COLUMN margin NUMERIC;

UPDATE amazon.amazon_sales_clean
SET margin = actual_price - discounted_price;



-- 2) Rating Bucket
ALTER TABLE amazon.amazon_sales_clean
ADD COLUMN rating_bucket TEXT;

UPDATE amazon.amazon_sales_clean
SET rating_bucket = CASE
	WHEN rating IS NULL THEN 'Unrated'
	WHEN rating >= 4.5 THEN 'Excellent'
	WHEN rating >= 4.0 THEN 'Good'
	WHEN rating >= 3.0 THEN 'Average'
	ELSE 'Poor'
END;



-- 3) Demand Proxy (simple interest metric)
ALTER TABLE amazon.amazon_sales_clean
ADD COLUMN demand_proxy NUMERIC;

UPDATE amazon.amazon_sales_clean
SET demand_proxy = discounted_price * COALESCE(rating_count, 0);