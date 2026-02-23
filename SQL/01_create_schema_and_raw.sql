-- =========================================================================
-- Project: Amazon Sales Data Cleaning
-- Database: portfolio_projects
-- Schema: amazon
-- Layer: RAW
-- File: 01_create_schema_and_raw.sql
-- Purpose: Create schema and raw ingestion table
-- =========================================================================


DROP TABLE IF EXISTS amazon.amazon_sales_raw;

CREATE TABLE amazon.amazon_sales_raw (
	product_id TEXT,
	product_name TEXT,
	category TEXT, 
	discounted_price TEXT, 
	actual_price TEXT, 
	discount_percentage TEXT, 
	rating TEXT,
	rating_count TEXT, 
	about_product TEXT,
	user_id TEXT, 
	user_name TEXT,
	review_id TEXT,
	review_title TEXT,
	review_content TEXT,
	img_link TEXT,
	product_link TEXT
);