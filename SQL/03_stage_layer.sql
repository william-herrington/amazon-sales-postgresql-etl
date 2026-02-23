-- ===========================================
-- Project: Amazon Sales Data Cleaning 
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: STAGE
-- File: 03_stage_Layer.sql
-- Purpose: Stage Layer Cleaning, type casting, and validation
-- ===========================================




-- --------------------------------------------------
-- 1. Create Stage Table (Do NOT modify raw table)
-- --------------------------------------------------
DROP TABLE IF EXISTS amazon.amazon_sales_stage;

CREATE TABLE amazon.amazon_sales_stage AS 
SELECT * 
FROM amazon.amazon_sales_raw;

ALTER TABLE amazon.amazon_sales_stage
ADD COLUMN stage_id BIGSERIAL PRIMARY KEY;




-- --------------------------------------------------
-- 2. Standardize Text Fields
-- --------------------------------------------------

UPDATE amazon.amazon_sales_stage
SET
	category = INITCAP(TRIM(category)),
	product_name = TRIM(product_name),
	review_title = COALESCE(TRIM(review_title), ''),
	review_content = COALESCE(TRIM(review_content), '');
-- Removes leading/trailing spaces, Normalizes capitalizaiton, Handles NULL review text cleanly




-- --------------------------------------------------
-- 3. Strip Non-Numeric Characters from Price Fields
-- --------------------------------------------------

UPDATE amazon.amazon_sales_stage
SET
	discounted_price = NULLIF(REGEXP_REPLACE(discounted_price, '[^0-9\.]', '', 'g'), ''),
	actual_price = NULLIF(REGEXP_REPLACE(actual_price, '[^0-9\.]', '', 'g'), ''), 
	discount_percentage = NULLIF(REGEXP_REPLACE(discount_percentage, '[^0-9\.]', '', 'g'), '');
-- Removes currnecy symbols, commas, extra characters, spaces, but if none existed, it won't hurt anything. 




-- --------------------------------------------------
-- 4. Add Properly Typed Numeric Columns
-- --------------------------------------------------

ALTER TABLE amazon.amazon_sales_stage
ADD COLUMN discounted_price_num NUMERIC, 
ADD COLUMN actual_price_num NUMERIC, 
ADD COLUMN discount_percentage_num NUMERIC, 
ADD COLUMN rating_num NUMERIC, 
ADD COLUMN rating_count_num INTEGER;




-- --------------------------------------------------
-- 5. Populate Numeric Columns
-- --------------------------------------------------

UPDATE amazon.amazon_sales_stage
SET 
	discounted_price_num = discounted_price::NUMERIC, 
	actual_price_num = actual_price::NUMERIC,
	discount_percentage_num = discount_percentage::NUMERIC,
	rating_num = NULLIF(REGEXP_REPLACE(rating, '[^0-9\.]', '', 'g'), '')::NUMERIC,
	rating_count_num = NULLIF(REGEXP_REPLACE(rating_count, '[^0-9]', '', 'g'), '')::INTEGER;




-- --------------------------------------------------
-- 6. Validate Business Rules
-- --------------------------------------------------

-- Remove invalid ratings
-- Ratings must be between 0 and 5
UPDATE amazon.amazon_sales_stage
SET rating_num = NULL
WHERE rating_num < 0 OR rating_num > 5;

-- Remove invalid prices
-- Prices must be greater than 0
UPDATE amazon.amazon_sales_stage
SET discounted_price_num = NULL
WHERE discounted_price_num <= 0;

UPDATE amazon.amazon_sales_stage
SET actual_price_num = NULL
WHERE actual_price_num <= 0;




-- --------------------------------------------------
-- 7. Discount Recalculation & Audit Flag
-- --------------------------------------------------


-- STEP 1
ALTER TABLE amazon.amazon_sales_stage
ADD COLUMN discount_pct_calc NUMERIC,
ADD COLUMN discount_pct_match BOOLEAN;


-- STEP 2
UPDATE amazon.amazon_sales_stage
SET discount_pct_calc = 
	ROUND(((actual_price_num - discounted_price_num)
		/ NULLIF(actual_price_num, 0)) * 100, 2)
WHERE actual_price_num > 0
	AND discounted_price_num > 0;


-- STEP 3
UPDATE amazon.amazon_sales_stage
SET discount_pct_match = 
	CASE 
		WHEN discount_percentage_num IS NULL OR discount_pct_calc IS NULL THEN NULL
		WHEN ABS(discount_percentage_num - discount_pct_calc) <= 0.50 THEN TRUE
		ELSE FALSE
	END;