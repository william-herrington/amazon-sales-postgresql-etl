-- =========================================================================
-- Project: Amazon Sales Data Cleaning
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: PROFILING
-- 02_profiling.sql
-- Purpose: Perform data profiling and quality checks
-- =========================================================================




-- -------------------------------------------------------------------------
-- 1. Basic Volume Check
-- -------------------------------------------------------------------------

-- STARTED PROFILING QUERIES HERE. 
-- 6.1 Row count (confirm)
SELECT 
    COUNT(*) AS total_rows
FROM amazon.amazon_sales_raw;




-- -------------------------------------------------------------------------
-- 2. Category Distribution (Spot inconsistencies / fragmentation)
-- -------------------------------------------------------------------------

-- 6.2 Category Distribution (find inconsistent naming)
SELECT 
    category, 
    COUNT(*) AS cnt
FROM amazon.amazon_sales_raw
GROUP BY category
ORDER BY cnt DESC;




-- -------------------------------------------------------------------------
-- 3. Missingness Checks (Blank / NULL fields)
-- -------------------------------------------------------------------------

SELECT
	SUM(CASE WHEN NULLIF(TRIM(discounted_price),'') IS NULL THEN 1 ELSE 0 END) AS blank_discounted_price,
	SUM(CASE WHEN NULLIF(TRIM(actual_price),'') IS NULL THEN 1 ELSE 0 END) AS blank_actual_price,
	SUM(CASE WHEN NULLIF(TRIM(discount_percentage),'') IS NULL THEN 1 ELSE 0 END) AS blank_discounted_percentage,
	SUM(CASE WHEN NULLIF(TRIM(rating),'') IS NULL THEN 1 ELSE 0 END) AS blank_rating,
	SUM(CASE WHEN NULLIF(TRIM(rating_count),'') IS NULL THEN 1 ELSE 0 END) AS blank_rating_count,
	SUM(CASE WHEN NULLIF(TRIM(review_content),'') IS NULL THEN 1 ELSE 0 END) AS blank_review_content
FROM amazon.amazon_sales_raw;




-- -------------------------------------------------------------------------
-- 4. Weird Characters in Prices (Currency symbols, commas, etc.)
-- -------------------------------------------------------------------------

SELECT 
    discounted_price, 
    actual_price
FROM amazon.amazon_sales_raw
WHERE discounted_price ~ '[^0-9\.\s]' 
    OR actual_price ~ '[^0-9\.\s]'
LIMIT 25;




-- -------------------------------------------------------------------------
-- 5. Weird Characters in Rating / Discount %
-- -------------------------------------------------------------------------

SELECT 
    discount_percentage, 
    rating
FROM amazon.amazon_sales_raw
WHERE discount_percentage ~'[^0-9\.\s]' 
    OR rating ~ '[^0-9\.\s]'
LIMIT 25;




-- -------------------------------------------------------------------------
-- 6. Duplicate Check (Product ID)
-- -------------------------------------------------------------------------

SELECT 
    product_id, 
    COUNT(*) AS dup_count
FROM amazon.amazon_sales_raw
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY dup_count DESC
LIMIT 25;