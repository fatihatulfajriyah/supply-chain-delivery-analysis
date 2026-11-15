/*
=========================================================
PROJECT: SUPPLY CHAIN & DELIVERY PERFORMANCE ANALYSIS
TOOLS: PostgreSQL, DBeaver, SQL
DATABASE: supply_chain
SCHEMA: public
TABLE: supply_chain

OBJECTIVE:
Analyze supply chain operations, evaluate delivery performance,
identify shipping delays, examine product profitability,
and understand sales distribution across customer segments
and geographic regions.
=========================================================
*/


/* =====================================================
   1. DATA OVERVIEW
   ===================================================== */


-- 1.1 Retrieve sample records
SELECT *
FROM supply_chain
LIMIT 10;


-- 1.2 Check total records and unique entities
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT order_item_id) AS unique_order_items,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_name) AS unique_products
FROM supply_chain;
-- Result:
-- The dataset contains 180,519 records, 65,752 unique orders,
-- 20,652 unique customers, and 118 unique products.


-- 1.3 Check transaction and shipping date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    
    MIN(shipping_date) AS first_shipping_date,
    MAX(shipping_date) AS last_shipping_date
FROM supply_chain;
-- Result:
-- Analyzed transaction and shipping dates, covering the period
-- from January 2015 to February 2018.



/* =====================================================
   2. DATA VALIDATION
   ===================================================== */


-- 2.1 Check missing values in key columns
SELECT
    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS missing_order_id,
    
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,
    
    COUNT(*) FILTER (
        WHERE product_name IS NULL
    ) AS missing_product_name,
    
    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS missing_order_date,
    
    COUNT(*) FILTER (
        WHERE shipping_date IS NULL
    ) AS missing_shipping_date,
    
    COUNT(*) FILTER (
        WHERE order_profit IS NULL
    ) AS missing_order_profit,
    
    COUNT(*) AS total_records
FROM supply_chain;
-- Result:
-- No missing values were found in the key columns.


-- 2.2 Check duplicate order item IDs
SELECT
    order_item_id,
    COUNT(*) AS duplicate_count
FROM supply_chain
GROUP BY order_item_id
HAVING COUNT(*) > 1;
-- Result:
-- No duplicate order item IDs were found in the dataset.


-- 2.3 Check potentially invalid numeric values
SELECT
    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity,
    
    COUNT(*) FILTER (
        WHERE sales_amount < 0
    ) AS negative_sales,
    
    COUNT(*) FILTER (
        WHERE item_price < 0
    ) AS negative_item_price,
    
    COUNT(*) FILTER (
        WHERE discount_rate < 0
           OR discount_rate > 1
    ) AS invalid_discount_rate,
    
    COUNT(*) FILTER (
        WHERE late_delivery_risk NOT IN (0, 1)
    ) AS invalid_delivery_risk
    
FROM supply_chain;
-- Result:
-- No invalid quantities, negative sales, negative prices,
-- or invalid discount rates were identified.


-- 2.4 Check date consistency
SELECT
    COUNT(*) FILTER (
        WHERE shipping_date < order_date
    ) AS invalid_shipping_dates,
    
    COUNT(*) FILTER (
        WHERE actual_shipping_days < 0
    ) AS negative_shipping_days,
    
    COUNT(*) FILTER (
        WHERE scheduled_shipping_days < 0
    ) AS negative_scheduled_days

FROM supply_chain;
-- Result:
-- No invalid shipping dates or negative shipping durations were found.


-- 2.5 Explore negative profit transactions
SELECT
    COUNT(*) FILTER (
        WHERE order_profit < 0
    ) AS negative_profit_records,
    
    COUNT(*) FILTER (
        WHERE order_profit >= 0
    ) AS non_negative_profit_records,
    
    COUNT(*) AS total_records,
    
    ROUND(
        COUNT(*) FILTER (
            WHERE order_profit < 0
        ) * 100.0 / COUNT(*),
        2
    ) AS negative_profit_pct
    
FROM supply_chain;
-- Result:
-- Identified 33,784 order items with negative profit,
-- representing 18.71% of total records.



/* =====================================================
   3. DELIVERY PERFORMANCE ANALYSIS
   ===================================================== */

-- 3.1 Overall delivery risk analysis
-- Business Question: What percentage of orders are at risk of late delivery?
SELECT
    COUNT(*) AS total_order_items,
    SUM(late_delivery_risk) AS late_delivery_items,
    
    COUNT(*) - SUM(late_delivery_risk)
        AS non_late_delivery_items,

    ROUND(
        SUM(late_delivery_risk) * 100.0
        / COUNT(*),
        2
    ) AS late_delivery_rate_pct
    
FROM supply_chain;
-- Result:
-- Identified 98,977 order items with late delivery risk,
-- representing 54.83% of total records.


-- 3.2 Delivery performance by shipping mode
-- Business Question: Which shipping modes have the highest late delivery rates?
SELECT
    shipping_mode,
    COUNT(*) AS total_order_items,
    
    ROUND(
        AVG(actual_shipping_days),
        2
    ) AS avg_actual_shipping_days,

    ROUND(
        AVG(scheduled_shipping_days),
        2
    ) AS avg_scheduled_shipping_days,

    SUM(late_delivery_risk) AS late_delivery_items,

    ROUND(
        SUM(late_delivery_risk) * 100.0
        / COUNT(*),
        2
    ) AS late_delivery_rate_pct
    
FROM supply_chain
GROUP BY shipping_mode
ORDER BY late_delivery_rate_pct DESC;
-- Result:
-- First Class recorded the highest late delivery rate
-- at 95.32%, followed by Second Class at 76.63%.


-- 3.3 Delivery status distribution
-- Business Question: How are orders distributed across different delivery statuses?
SELECT
    delivery_status,
    COUNT(*) AS total_order_items,
    
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS delivery_status_pct
    
FROM supply_chain
GROUP BY delivery_status
ORDER BY total_order_items DESC;
-- Result:
-- Late Delivery was the most common delivery status,
-- accounting for 98,977 order items (54.83%).



/* =====================================================
   4. SALES & PRODUCT PERFORMANCE
   ===================================================== */

-- 4.1 Product category performance
-- Business Question: Which product categories generate the highest sales and profit?
SELECT
    product_category,
    COUNT(*) AS total_order_items,
    SUM(quantity) AS total_quantity,
    
    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit,

    ROUND(
        AVG(order_profit)::NUMERIC,
        2
    ) AS avg_profit

FROM supply_chain
GROUP BY product_category
ORDER BY total_sales DESC
LIMIT 10;
-- Result:
-- Fishing recorded the highest category sales of 6929653.50,
-- generating a total profit of 756220.76.


-- 4.2 Top 10 best-selling products
-- Business Question: Which products generate the highest sales revenue?
SELECT
    product_name,
    SUM(quantity) AS total_quantity,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit

FROM supply_chain
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
-- Result:
-- Field & Stream Sportsman 16 Gun Fire Safe ranked first,
-- generating total sales of 6929653.50.


-- 4.3 Identify loss-making products
-- Business Question: Which products generate negative total profit?
SELECT
    product_name,
    COUNT(*) AS total_order_items,

    SUM(quantity) AS total_quantity,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit

FROM supply_chain
GROUP BY product_name
HAVING SUM(order_profit) < 0
ORDER BY total_profit ASC;
-- Result:
-- Identified three products with negative cumulative profit,
-- with SOLE E35 Elliptical recording the largest loss of 965.12.



/* =====================================================
   5. ORDER & CUSTOMER BEHAVIOR
   ===================================================== */


-- 5.1 Sales performance by customer segment
-- Business Question: Which customer segments contribute the most to total sales and profit?
SELECT
    customer_segment,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit,

    ROUND(
        AVG(order_profit)::NUMERIC,
        2
    ) AS avg_profit

FROM supply_chain
GROUP BY customer_segment
ORDER BY total_sales DESC;
-- Result:
-- Consumer recorded the highest sales contribution
-- at 19095789.79, with a total profit of 2073487.67.


-- 5.2 Order status distribution
-- Business Question: How are orders distributed across different order statuses?
SELECT
    order_status,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS order_status_pct

FROM supply_chain
GROUP BY order_status
ORDER BY total_order_items DESC;
-- Result:
-- COMPLETE was the most common order status,
-- representing 21,716 unique orders.


-- 5.3 Sales performance by payment type
-- Business Question: Which payment methods are most frequently used and generate the highest sales?
SELECT
    payment_type,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS payment_contribution_pct

FROM supply_chain
GROUP BY payment_type
ORDER BY total_order_items DESC;
-- Result:
-- DEBIT was the most frequently used payment method,
-- generating the highest sales of 14076857.39.



/* =====================================================
   6. GEOGRAPHIC & TIME ANALYSIS
   ===================================================== */


-- 6.1 Annual sales and profit performance
-- Business Question: How do sales and profit change over different years?
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit,

    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS late_delivery_rate_pct

FROM supply_chain
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;
-- Result:
-- 2015 recorded the highest annual sales of 12340831.19,
-- while 2017 had the highest number of unique orders.


-- 6.2 Sales performance by shipping region
-- Business Question: Which shipping regions contribute the highest sales and profit?
SELECT
    shipping_region,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit,

    ROUND(
        AVG(late_delivery_risk) * 100,
        2
    ) AS late_delivery_rate_pct

FROM supply_chain
GROUP BY shipping_region
ORDER BY total_sales DESC
LIMIT 10;
-- Result:
-- Western Europe generated the highest regional sales
-- of 5894380.66, with a total profit of 625446.08.


-- 6.3 Monthly sales trend
-- Business Question: How does monthly sales performance change over time?
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS unique_orders,

    ROUND(
        SUM(sales_amount)::NUMERIC,
        2
    ) AS total_sales,

    ROUND(
        SUM(order_profit)::NUMERIC,
        2
    ) AS total_profit

FROM supply_chain
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY total_sales DESC
LIMIT 10;
-- Result:
-- September 2017 recorded the highest monthly sales
-- of 1143775.09.


/* =====================================================
   END OF ANALYSIS
   ===================================================== */