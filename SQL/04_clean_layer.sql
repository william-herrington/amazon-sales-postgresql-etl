-- ===========================================
-- Project: Amazon Sales Data Cleaning
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: CLEAN
-- File: 04_clean_Layer.sql
-- Purpose: Create analytics-ready clean table from stage Layer
-- ===========================================




DROP TABLE IF EXISTS amazon.amazon_sales_clean;

CREATE TABLE amazon.amazon_sales_clean AS 
SELECT 
	product_id,
	INITCAP(TRIM(product_name)) AS product_name,
	INITCAP(TRIM(category)) AS category,
	discounted_price_num AS discounted_price,
	actual_price_num AS actual_price,
	discount_pct_calc AS discount_percentage,
	rating_num AS rating,
	rating_count_num AS rating_count,
	about_product,
	user_id,
	user_name,
	review_id,
	review_title,
	review_content,
	img_link,
	product_link,
	stage_id
FROM amazon.amazon_sales_stage
WHERE actual_price_num IS NOT NULL 
	AND discounted_price_num IS NOT NULL
	AND actual_price_num > 0
	AND discounted_price_num > 0;