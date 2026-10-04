# Assessment of E-Commerce Performance in Olist, Brazil (2016-2018)

## Project Overview

This project analyzes the **Olist Brazilian E-Commerce Public Dataset**,
covering e-commerce activity in Brazil from **2016 to 2018**.

The analysis combines **PostgreSQL/SQL, Python, and Power BI** to
evaluate sales performance, customer behavior, payment methods, product
performance, seller geography, freight economics, delivery efficiency,
and customer satisfaction.

The objective is to translate transactional data into business insights
that can support decisions around **revenue growth, customer behavior,
marketplace operations, and logistics performance**.

------------------------------------------------------------------------

## Business Problem

Olist operates as a Brazilian e-commerce marketplace connecting
customers with sellers across the country. The marketplace generates
data across orders, products, sellers, payments, reviews, customers, and
delivery events.

The analysis addresses questions such as:

-   Which product categories generate the most revenue?
-   How has revenue changed over time?
-   Which payment methods are most commonly used?
-   How frequently do customers make repeat purchases?
-   Which states have the strongest seller activity?
-   How significant are freight costs relative to product value?
-   Does product weight influence freight cost?
-   Which regions experience longer delivery times?
-   How strongly are late deliveries associated with customer
    dissatisfaction?

### Goal

The goal is to evaluate:

1.  Sales and product performance
2.  Customer purchasing behavior
3.  Payment behavior
4.  Marketplace and seller structure
5.  Logistics and freight economics
6.  Delivery performance and customer satisfaction

------------------------------------------------------------------------

# Data Structure and Overview

The Olist dataset consists of multiple relational tables connected
primarily through `order_id`, `customer_id`, `customer_unique_id`,
`product_id`, and `seller_id`.

| Table | Description |
|---|---|
| `orders` | Order lifecycle, purchase, approval, delivery and estimated delivery dates |
| `order_items` | Products purchased within each order, seller, price and freight |
| `order_payments` | Payment method, payment value and installments |
| `order_reviews` | Customer review scores and review timestamps |
| `customers` | Customer location and customer identifiers |
| `sellers` | Seller location and seller identifiers |
| `products` | Product dimensions, weight and product category |

### Important Data Relationships

-   One `order_id` can contain multiple products/items.
-   One order can contain multiple payment records.
-   Multiple sellers can fulfill a single order.
-   `customer_unique_id` is used for repeat-customer analysis because it
    represents the persistent customer identity across orders.
-   `customer_id` should not be treated as the persistent customer key
    for retention analysis.

### Data Grain

The `orders` table is approximately one row per order, while
`order_items` is at the order-item level.

Therefore, order-level metrics use:

``` sql
COUNT(DISTINCT order_id)
```

where appropriate, rather than counting rows in `order_items`.

------------------------------------------------------------------------

# Tools and Technologies

### SQL / Database

-   PostgreSQL
-   SQL
-   CTEs
-   Window functions
-   Aggregations
-   Joins
-   Views
-   Data validation and transformation

### Python

-   Python
-   Pandas
-   NumPy
-   SciPy
-   Exploratory Data Analysis
-   Statistical testing
-   Correlation analysis
-   Outlier analysis

### Visualization

-   Microsoft Power BI
-   DAX
-   Interactive dashboards

### Analysis Workflow

``` text
Raw CSV Files
      ↓
PostgreSQL Data Loading
      ↓
Data Validation & Cleaning
      ↓
SQL Analytical Views
      ↓
Python EDA & Statistical Testing
      ↓
Power BI Data Model
      ↓
Interactive Business Dashboards
      ↓
Business Insights
```

------------------------------------------------------------------------

# Executive Summary

The analysis indicates that Olist experienced substantial growth in
marketplace activity during the observed period, with revenue increasing
through much of 2017 before becoming more volatile during 2018.

Several product categories contributed significantly to revenue,
particularly **Health & Beauty, Watches & Gifts, Bed/Bath/Table,
Sports/Leisure, and Computers/Accessories**.

Customer purchasing behavior was highly skewed toward one-time
purchases. Approximately **3% of identified customers placed two or more
orders** during the observed period.

Payment behavior was dominated by **credit cards**, followed by boleto,
with debit cards and vouchers contributing much smaller volumes.

Logistics emerged as an important operational factor. Freight
represented approximately **16.6% of product value** in the Power BI
analysis. Product weight also showed a moderate positive association
with freight cost.

The strongest customer-experience finding was the relationship between
delivery performance and review scores. **Late orders received
substantially lower customer ratings than on-time or early orders**,
indicating that delivery reliability is closely associated with customer
satisfaction.

Delivery performance also varied considerably by Brazilian state,
suggesting that geographic factors and logistics network characteristics
are important areas for further investigation.

------------------------------------------------------------------------

# Key Performance Indicators

The current Power BI dashboard provides the following headline metrics:

| KPI | Result |
|---|---:|
| Product Revenue | **R\$11.76M** |
| Product Revenue per Order | **R\$120.96** |
| Unique Customers | **~94K** |
| Repeat Customer Rate | **3.01%** |
| Customers with 2+ Orders | **~3K** |
| Total Freight | **R\$1.95M** |
| Freight / Product Value | **16.56%** |
| Median Delivery Time | **10 days** |
| Average Review Score | **4.09** |

> **Metric note:** Product revenue and order-level KPIs are calculated
> from the current Power BI model. Because the analytical `main` table
> is based on order-item-level data, distinct order counting is required
> for order-level metrics.

------------------------------------------------------------------------

# Insights Deep Dive

## 1. Revenue Growth and Product Mix

Revenue increased substantially during 2017, reaching high monthly
levels before experiencing greater volatility during 2018.

<img width="1189" height="490" alt="Monthly revenue trend" src="https://github.com/user-attachments/assets/fc30b0ce-6053-469c-be7a-1b844e078021" />


The largest product categories by revenue included:

| Product Category | Approx. Revenue |
|---|---:|
| Health & Beauty | **R\$1.10M** |
| Watches & Gifts | **R\$1.07M** |
| Bed/Bath/Table | **R\$0.91M** |
| Sports & Leisure | **R\$0.86M** |
| Computers & Accessories | **R\$0.79M** |

The top five categories contributed approximately **40% of product
revenue** in the analysis, indicating that revenue was distributed
across several major categories rather than being dominated by a single
category.

------------------------------------------------------------------------

## 2. Customer Repeat Behavior

Approximately **3.01% of identified customers placed two or more
orders** during the observed period.

| Customer Metric | Result |
|---|---:|
| Unique Customers | **~94K** |
| Customers with 2+ Orders | **~3K** |
| Repeat Customer Rate | **3.01%** |

The customer base is dominated by one-time purchasers. Among repeat
customers, customers making two purchases are substantially more common
than customers making three or more purchases.

This should be interpreted as **limited observed repeat purchasing
within the dataset period**, rather than automatically being classified
as a customer-retention failure.

------------------------------------------------------------------------

## 3. Payment Behavior

Credit cards were the dominant payment method, followed by boleto.

Payment activity increased alongside overall order volume during the
marketplace's growth period.

Installment count also showed a positive relationship with order value.

### Statistical Result

**Spearman correlation between installment count and order value:**

-   ρ ≈ **0.382**
-   p \< **0.001**

This indicates a **moderate positive association** between installment
count and order value.

> Correlation does not establish that installments cause higher order
> values; it indicates that the two variables move together in the
> observed data.

------------------------------------------------------------------------

## 4. Delivery Performance

Delivery time is strongly right-skewed, with most orders concentrated
around shorter delivery periods and a smaller number of highly delayed
orders.

<img width="989" height="590" alt="delivery time" src="https://github.com/user-attachments/assets/71d5fade-88f3-4347-9c19-70b752b28ccf" />


| Delivery Metric | Result |
|---|---:|
| Median Delivery Time | **~10 days** |
| Average Delivery Time | **~12.6 days** |
| Late Delivery Rate | **~7–8% depending on dashboard definition** |

Most orders were delivered within **5--14 days**, while a long tail of
orders took more than 20 days.

Approximately **1.1K orders** were in the 45+ day delivery bucket in the
analyzed dashboard.

### Geographic Variation

<img width="997" height="557" alt="Delivery Region" src="https://github.com/user-attachments/assets/e6f13fb0-a4c3-432b-b222-c5a1d611d86e" />


States such as **Amazonas, Amapá, Roraima, Alagoas, and Pará** showed
some of the longest median delivery times.

Median delivery time reached approximately **25--26 days** in Amazonas,
Amapá, and Roraima.

Several Northern states have large geographic distances, lower
population density, and more complex transportation networks. These
factors may contribute to longer delivery times.

However, the dashboard establishes geographic differences in delivery
performance; additional infrastructure and route-level data would be
required to establish specific causes.

------------------------------------------------------------------------

## 5. Delivery Performance and Customer Satisfaction

This is the strongest finding from the analysis.

| Delivery Status | Average Review Score |
|---|---:|
| On Time / Early | **~4.3** |
| Late | **~2.3** |

Median review scores were approximately:

| Delivery Status | Median Review |
|---|---:|
| On Time / Early | **5** |
| Late | **2** |

### Statistical Test

A **Mann--Whitney U test** was used to compare review-score
distributions between late and on-time/early deliveries.

Results:

-   U ≈ **150.7M**
-   p \< **0.001**
-   Rank-biserial correlation ≈ **0.554**

Late deliveries were associated with substantially lower customer
satisfaction. The effect size indicates that the difference is not only
statistically significant but also materially large in the observed
data.

------------------------------------------------------------------------

## 6. Geographic Variation in Delivery

A **Kruskal--Wallis test** was used to compare delivery-time
distributions across Brazilian states.

### Result

-   H ≈ **23,956.48**
-   p \< **0.001**

Delivery times differ significantly across states, supporting the Power
BI finding that logistics performance is geographically heterogeneous.

<img width="989" height="590" alt="delivery status" src="https://github.com/user-attachments/assets/baf69c19-78a2-4bee-80fc-652ce87349f7" />

------------------------------------------------------------------------

## 7. Freight Economics

Total freight in the current Power BI model is approximately:

> **R\$1.95M**

Relative to product value:

> **Freight / Product Value ≈ 16.56%**

### Product Weight vs Freight

Product weight showed a moderate positive relationship with freight
cost.

<img width="850" height="545" alt="Weight vs Freight cost" src="https://github.com/user-attachments/assets/8973754e-39ae-4072-a30b-9d38501f918f" />


**Spearman correlation:**

> ρ ≈ **0.447**

This suggests that heavier products generally incur higher freight
costs, although there is substantial variation between individual
products.

### Additional Correlations

| Variables | Spearman ρ |
|---|---:|
| Weight ↔ Freight | **0.447** |
| Price ↔ Freight | **0.434** |
| Volume ↔ Freight | **0.369** |
| Weight ↔ Volume | **0.768** |

Freight economics are influenced by multiple product characteristics
rather than weight alone.

------------------------------------------------------------------------

## 8. Freight Burden by Product Category

Several categories showed relatively high average
freight-to-product-value ratios.

| Product Category | Approx. Avg. Freight / Product Value |
|---|---:|
| Home Comfort 2 | **~91%** |
| DVDs & Blu-ray | **~82%** |
| Electronics | **~69%** |
| Christmas Supplies | **~63%** |
| Flowers | **~54%** |
| Furniture Mattress & Upholstery | **~50%** |

For some categories, freight represents a very large proportion of
product value. This can be particularly important for lower-value
products, where shipping costs can materially affect order economics.

> These figures represent average freight-to-product ratios by category
> and should not be interpreted as each category's share of total
> freight expenditure.

------------------------------------------------------------------------

## 9. Seller Geography

Seller revenue was concentrated in Brazil's major South--Southeast
commercial corridor.

| Seller State | Approx. Product Revenue |
|---|---:|
| São Paulo | **R\$4.9M** |
| Rio de Janeiro | **R\$1.5M** |
| Minas Gerais | **R\$1.4M** |
| Rio Grande do Sul | **R\$0.6M** |
| Paraná | **R\$0.6M** |

São Paulo generated substantially more seller-side revenue than other
states in the Power BI dashboard.

The leading states are geographically concentrated in Brazil's
economically developed South--Southeast corridor, which contains major
metropolitan markets and transportation infrastructure.

------------------------------------------------------------------------

# Statistical Methods

### Mann--Whitney U Test

Used to compare review-score distributions between late and
on-time/early deliveries.

### Kruskal--Wallis Test

Used to test whether delivery-time distributions differ across Brazilian
states.

### Spearman Rank Correlation

Used to examine monotonic relationships between:

-   Product weight and freight
-   Product price and freight
-   Product volume and freight
-   Installment count and order value

### Effect Size

Rank-biserial correlation was used to quantify the magnitude of the
difference between review scores for late versus on-time/early
deliveries.

------------------------------------------------------------------------

# Power BI Dashboard

The project is organized into four analytical pages.

### Page 1 --- Dataset Overview

-   Revenue
-   Orders
-   Customers
-   Monthly revenue
-   Product category revenue
-   Payment methods

### Page 2 --- Delivery Analysis

-   Delivery time
-   Late delivery rate
-   Delivery performance by state
-   Delivery-time distribution
-   Review score by delivery status

### Page 3 --- Logistics

-   Product revenue
-   Freight costs
-   Freight-to-product ratio
-   Seller geography
-   Product weight vs freight
-   Freight burden by product category

### Page 4 --- Customer & Payment Behaviour

-   Customer spending
-   Repeat purchasing
-   Customer order frequency
-   Payment method trends
-   Payment behavior over time

------------------------------------------------------------------------

# Next Steps

## 1. Investigate High-Delay Regions

Identify operational reasons behind higher delivery times in states with
poor delivery performance.

Potential variables:

-   Seller-to-customer distance
-   Carrier performance
-   Shipping route
-   Regional fulfillment capacity
-   Order processing time
-   Last-mile delivery

## 2. Monitor Late Delivery as a Customer-Experience KPI

Track:

-   Late delivery %
-   Median delivery time
-   Delivery time by state
-   Delivery time by seller
-   Review score
-   Late-delivery rate by carrier

## 3. Optimize Freight Economics

Investigate categories with unusually high freight-to-product ratios
through:

-   Seller-level freight benchmarking
-   Packaging optimization
-   Product bundling
-   Regional fulfillment
-   Shipping-cost thresholds
-   Category-specific logistics strategies

## 4. Analyze Repeat-Purchase Behavior

Segment customers based on:

-   First purchase category
-   Order value
-   Geographic location
-   Review experience
-   Delivery performance
-   Time since first purchase

## 5. Develop Seller-Level Performance Metrics

Combine:

-   Revenue
-   Order volume
-   Average delivery time
-   Late-delivery rate
-   Review score
-   Freight ratio

to create a consistent seller-performance framework.

------------------------------------------------------------------------

# Limitations

### Historical Dataset

The dataset covers approximately **2016--2018** and does not represent
current Olist operations or the current Brazilian e-commerce market.

### Marketplace Data

Olist is a marketplace connecting customers and sellers. The dataset
does not provide the complete operational context behind every
transaction.

### Observational Analysis

Most findings describe associations rather than causal relationships.
For example, the analysis demonstrates a strong association between late
delivery and lower review scores, but cannot independently prove that
delivery delay is the sole cause of lower ratings.

### Limited Logistics Variables

The dataset does not provide complete information about carrier-level
performance, exact shipping routes, transportation mode,
fulfillment-center locations, or external disruptions such as weather.

### Customer Retention

The approximately 3% repeat-customer rate reflects repeat purchases
observed within the dataset period. It should not be interpreted as a
complete measure of long-term customer lifetime retention.

### Data Grain

The `order_items` data is at item level, so order-level metrics require
careful use of `DISTINCTCOUNT(order_id)` to avoid duplicate-order
counting.

### Payment Data

Payment records can contain multiple rows for an order. Payment analysis
therefore requires aggregation at the appropriate order/payment level to
avoid double counting.

------------------------------------------------------------------------

# Project Structure

``` text
olist-ecommerce-analysis/
│
├── data/
│   └── raw/
│
├── sql/
│   ├── 01_sales_analysis.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_seller_product_analysis.sql
│   ├── 04_delivery_customer_experience.sql
│   └── 05_payment_analysis.sql
│
├── notebooks/
│   └── olist_analysis.ipynb
│
├── powerbi/
│   └── olist_ecommerce_dashboard.pbix
│
├── README.md
└── requirements.txt
```

------------------------------------------------------------------------

# Conclusion

The analysis shows that Olist's e-commerce performance is influenced by
multiple interconnected factors.

Revenue is distributed across several major product categories, while
customer purchasing is heavily weighted toward one-time transactions.
Credit cards dominate payment activity, and installment usage is
positively associated with higher order values.

From an operational perspective, freight represents a significant share
of product value and varies considerably by product characteristics and
category.

The most important finding is the relationship between **delivery
performance and customer satisfaction**: late deliveries are associated
with substantially lower review scores. Delivery performance also varies
significantly across Brazilian states, highlighting geographic
differences in the marketplace's logistics network.

Overall, the project demonstrates how **SQL, Python, statistical
analysis, and Power BI** can be combined to move from raw transactional
data to actionable e-commerce and logistics insights.
