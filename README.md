# Assessment of E-Commerce Performance in Olist, Brazil (2016–2018)

## 📌 Project Overview

Analyzed Brazilian e-commerce data from Olist (2016–2018) using SQL, Python, and Power BI to evaluate sales performance, customer behavior, payment patterns, product performance, and delivery efficiency.

The project aims to generate data-driven insights that support business decision-making and identify opportunities to improve customer experience and operational performance.

---

## 🎯 Business Problem

E-commerce businesses need to understand customer purchasing behavior, sales performance, delivery efficiency, and payment preferences to improve operations and increase revenue.

This project analyzes Olist's e-commerce data to answer key business questions:

- How have sales and order volumes changed over time?
- Which product categories and regions generate the most revenue?
- What are the most common customer payment methods?
- How does delivery performance affect customer satisfaction?
- Which factors influence customer reviews and purchasing behavior?
- What opportunities exist to improve business performance?

---

## 📊 Dataset Overview

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Time Period:** 2016–2018

**Geography:** Brazil

**Source:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains information about orders, customers, sellers, products, payments, and customer reviews.

### Data Tables

| Table | Description |
|-------|-------------|
| olist_customers_dataset | Customer information and location |
| olist_orders_dataset | Order status and timestamps |
| olist_order_items_dataset | Products and seller information per order |
| olist_order_payments_dataset | Payment methods and transaction values |
| olist_order_reviews_dataset | Customer reviews and ratings |
| olist_products_dataset | Product details and categories |
| olist_sellers_dataset | Seller information and location |
| product_category_name_translation | Portuguese-to-English category translation |

---

## 🛠️ Tools & Technologies

- **SQL (PostgreSQL):** Data cleaning, transformation, and business analysis
- **Python (Pandas, NumPy, Matplotlib):** Exploratory Data Analysis and statistical analysis
- **Power BI:** Interactive dashboards and data visualization
- **Excel:** Data validation and supplementary analysis

---

## 📋 Project Workflow

1. **Data Understanding**
   - Explore dataset structure and relationships.
   - Identify primary and foreign keys.
   - Understand data types and missing values.

2. **Data Cleaning & Preparation**
   - Handle missing values and duplicates.
   - Validate relationships between tables.
   - Prepare datasets for analysis.

3. **SQL Analysis**
   - Analyze sales, revenue, and order trends.
   - Evaluate customer and seller performance.
   - Investigate delivery and payment patterns.

4. **Python EDA**
   - Explore distributions and trends.
   - Identify patterns and anomalies.
   - Perform supplementary statistical analysis.

5. **Power BI Dashboard**
   - Build interactive visualizations.
   - Develop KPIs and performance metrics.
   - Present business insights.

6. **Business Insights & Recommendations**
   - Summarize key findings.
   - Identify operational improvement opportunities.
   - Provide data-driven recommendations.

---

## 📈 Key Performance Indicators (KPIs)

The following metrics will be evaluated during the project:

| KPI | Description |
|-----|-------------|
| Total Revenue | Total value of items sold |
| Total Orders | Number of orders placed |
| Average Order Value (AOV) | Average revenue per order |
| Customer Satisfaction | Average customer review score |
| Delivery Performance | On-time delivery and delays |
| Payment Distribution | Usage of different payment methods |
| Product Performance | Revenue and order volume by category |

*Final KPI definitions and values will be added after analysis.*

---

## 🔍 Executive Summary

*To be updated after completing the analysis.*

This section will summarize the most important findings for non-technical stakeholders, including sales performance, customer behavior, delivery efficiency, and business opportunities.

---

## 📊 Insights Deep Dive

### 1. Sales Performance
*To be updated.*

- Revenue trends over time
- Order volume and growth
- Average order value
- Top-performing product categories

### 2. Customer Analysis
*To be updated.*

- Customer distribution by region
- Purchasing behavior
- Repeat customer analysis
- Customer segmentation

### 3. Payment Analysis
*To be updated.*

- Payment method distribution
- Installment patterns
- Payment value analysis

### 4. Delivery Performance
*To be updated.*

- Average delivery time
- Late delivery percentage
- Delivery performance by region
- Relationship between delivery delays and review scores

### 5. Product & Seller Analysis
*To be updated.*

- Product category performance
- Seller revenue contribution
- Product demand patterns
- Seller geographic distribution

---

## 📌 Business Recommendations

*To be developed based on analytical findings.*

Potential areas of focus:

- Improving delivery performance
- Identifying high-value customer segments
- Optimizing product category performance
- Evaluating seller performance
- Improving customer satisfaction

---

## ⚠️ Limitations

*To be updated during the project.*

Potential limitations include:

- Dataset coverage is limited to the available historical period.
- The dataset represents Olist's marketplace activity, not the entire Brazilian e-commerce market.
- Customer-level purchasing behavior may be limited by the available customer identifiers.
- Correlation between delivery performance and customer satisfaction does not necessarily establish causation.

---

## 📂 Project Structure

```text
Olist-Ecommerce-Analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── sql/
│   └── analysis.sql
│
├── notebooks/
│   └── exploratory_analysis.ipynb
│
├── powerbi/
│   └── olist_dashboard.pbix
│
├── visuals/
│
└── README.md
