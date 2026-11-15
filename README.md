# **Supply Chain & Delivery Performance Analysis**

## **Project Overview**

This project analyzes supply chain data to evaluate delivery performance, shipping efficiency, sales trends, and product profitability. The analysis aims to identify delivery issues, compare shipping performance, and evaluate product profitability to support better operational and business decisions.

## **Project Details**

- **Tools:** PostgreSQL, DBeaver, SQL, Google Looker Studio
- **Database:** `supply_chain`
- **Schema:** `public`
- **Table:** `supply_chain`
- **Dataset:** Supply Chain Dataset
- **Total Records:** 180,519
- **Unique Orders:** 65,752
- **Unique Customers:** 20,652
- **Unique Products:** 118
- **Analysis Period:** January 2015 – January 2018 (Order Date)

## **Objectives**

- Evaluate delivery performance and identify late delivery risks.
- Compare shipping efficiency across different shipping modes.
- Analyze sales and profitability by product and category.
- Identify products with negative cumulative profit.
- Examine sales performance across customer segments and geographic regions.
- Generate data-driven recommendations to improve supply chain operations.

## **Analysis Process**

### **1. Data Overview & Validation**

Performed initial data exploration and validation to assess dataset completeness, consistency, and reliability.

**Key Findings:**

- 180,519 records representing 65,752 unique orders, 20,652 unique customers, and 118 unique products.
- No missing values were found in the selected key columns.
- No duplicate order item IDs were identified.
- No invalid quantities, negative sales values, negative item prices, or invalid discount rates were found.
- No invalid shipping dates or negative shipping durations were identified.
- Identified 33,784 order items with negative profit, representing 18.71% of total records.

### **2. Delivery Performance Analysis**

Evaluated overall late delivery risks and delivery status distribution to understand supply chain delivery performance.

**Business Questions:**

- What percentage of order items are at risk of late delivery?
- How are order items distributed across different delivery statuses?

**Key Findings:**

- Identified 98,977 order items with late delivery risk, representing 54.83% of total records.
- Late Delivery was the most common delivery status, accounting for 54.83% of order items.
- Advance Shipping accounted for 23.04%, while Shipping on Time represented 17.84%.

### **3. Shipping Mode Performance Analysis**

Compared shipping performance across different shipping modes based on actual shipping days, scheduled shipping days, and late delivery rates.

**Business Question:**

- Which shipping modes have the highest late delivery rates?

**Key Findings:**

- First Class recorded the highest late delivery rate at 95.32%.
- Second Class ranked second with a late delivery rate of 76.63%.
- Same Day and Standard Class recorded lower late delivery rates of 45.74% and 38.07%, respectively.

### **4. Sales & Product Performance**

Analyzed sales and profit contributions across product categories and individual products to identify top-performing and loss-making products.

**Business Questions:**

- Which product categories generate the highest sales and profit?
- Which products generate the highest sales revenue?
- Which products have negative cumulative profit?

**Key Findings:**

- Fishing recorded the highest category sales of approximately 6,929,653.50, generating a total profit of approximately 756,220.76.
- Field & Stream Sportsman 16 Gun Fire Safe ranked first in product sales, generating approximately 6,929,653.50.
- Identified three products with negative cumulative profit.
- SOLE E35 Elliptical recorded the largest loss of 965.12.

### **5. Order & Customer Behavior**

Analyzed sales contributions across customer segments, order statuses, and payment methods to understand order and purchasing patterns.

**Business Questions:**

- Which customer segments contribute the most to total sales and profit?
- How are orders distributed across different order statuses?
- Which payment methods are most frequently used and generate the highest sales?

**Key Findings:**

- Consumer recorded the highest sales contribution at approximately 19,095,789.79, with a total profit of approximately 2,073,487.67.
- COMPLETE was the most common order status, representing 21,716 unique orders.
- DEBIT was the most frequently used payment method, generating the highest sales of approximately 14,076,857.39.

### **6. Geographic & Time Analysis**

Analyzed annual sales performance, regional contributions, and monthly sales trends to identify changes in business performance over time and across geographic regions.

**Business Questions:**

- How do sales and profit change across different years?
- Which shipping regions contribute the highest sales and profit?
- How does monthly sales performance change over time?

**Key Findings:**

- 2015 recorded the highest annual sales of approximately 12,340,831.19.
- Western Europe generated the highest regional sales of approximately 5,894,380.66, with a total profit of approximately 625,446.08.
- September 2017 recorded the highest monthly sales of approximately 1,143,775.09.

## **Key Business Recommendations**

- Review delivery processes and investigate factors contributing to the high late delivery risk.
- Evaluate First Class and Second Class shipping performance to identify opportunities for improving delivery efficiency.
- Monitor products with negative cumulative profit and review their pricing, costs, and profitability.
- Prioritize high-performing product categories, particularly Fishing, when evaluating sales opportunities.
- Use customer segment and regional sales performance to support more focused business strategies.
- Monitor monthly sales and delivery trends to support operational planning and performance evaluation.

## **Dashboard**

An interactive Google Looker Studio dashboard was developed to visualize supply chain performance, delivery risks, shipping efficiency, and product profitability.

**Dashboard Features:**

- Total order items, late delivery rate, average shipping days, total sales, and total profit KPIs.
- Monthly late delivery rate trend.
- Delivery status distribution.
- Late delivery rate comparison by shipping mode.
- Top 3 products by profit.
- Loss-making product analysis.
- Order performance table by product, shipping mode, delivery status, and total profit.
- Interactive filters for Customer Segment, Order Status, Product Category, and Shipping State.

**Interactive Dashboard:**

[**View Live Dashboard – Google Looker Studio**](https://datastudio.google.com/reporting/37f49ee0-961f-4d7c-93ce-c96412c59315)

## **SQL Skills Applied**

- Data Exploration
- Data Validation
- Aggregate Functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
- Conditional Aggregation (`FILTER`)
- Data Grouping and Sorting (`GROUP BY`, `ORDER BY`)
- `HAVING` Clause
- Window Functions
- Date Functions (`EXTRACT`, `TO_CHAR`)
- Percentage Calculations
- Data Segmentation
- Delivery Performance Analysis
- Sales & Profitability Analysis

## **Project Files**

- `supply_chain_dataset.csv` – Original dataset used for supply chain analysis.
- `supply_chain_analysis.sql` – SQL queries used for data exploration, validation, and business analysis.
- `supply_chain_dashboard.jpg` – Dashboard preview.
- `README.md` – Project documentation.

## **Conclusion**

This project demonstrates the use of SQL to explore supply chain data, validate data quality, evaluate delivery performance, and analyze sales and product profitability. The findings highlight late delivery risks, differences in shipping performance, and variations in product profitability. These insights can support better operational planning and data-driven business decisions.
