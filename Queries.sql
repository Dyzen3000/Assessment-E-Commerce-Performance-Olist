CREATE VIEW olist.order_sales AS
SELECT
    order_id,
    COUNT(*) AS item_count,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    SUM(price) AS product_value,
    SUM(freight_value) AS freight_value,
    SUM(price + freight_value) AS order_value
FROM olist.order_items
GROUP BY order_id;




SELECT *
FROM olist.order_sales
LIMIT 20;




CREATE VIEW olist.order_payment_summary AS
SELECT
    order_id,
    SUM(payment_value) AS total_payment,
    COUNT(*) AS payment_records,
    MAX(payment_installments) AS max_installments
FROM olist.order_payments
GROUP BY order_id;





CREATE VIEW olist.order_payment_methods AS
SELECT
    order_id,
    STRING_AGG(DISTINCT payment_type, ', ') AS payment_methods
FROM olist.order_payments
GROUP BY order_id;




CREATE VIEW olist.order_analytics AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,

    c.customer_city,
    c.customer_state,

    o.order_status,

    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    s.item_count,
    s.unique_products,
    s.unique_sellers,
    s.product_value,
    s.freight_value,
    s.order_value,

    p.total_payment,
    p.max_installments,

    pm.payment_methods

FROM olist.orders o

LEFT JOIN olist.customers c
    ON o.customer_id = c.customer_id

LEFT JOIN olist.order_sales s
    ON o.order_id = s.order_id

LEFT JOIN olist.order_payment_summary p
    ON o.order_id = p.order_id

LEFT JOIN olist.order_payment_methods pm
    ON o.order_id = pm.order_id;





SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    SUM(product_value) AS total_product_revenue,
    SUM(freight_value) AS total_freight,
    SUM(order_value) AS total_order_value,
    AVG(order_value) AS average_order_value
FROM olist.order_analytics
WHERE order_status = 'delivered';






SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS orders,
    SUM(product_value) AS revenue,
    SUM(order_value) AS gross_order_value,
    AVG(order_value) AS average_order_value
FROM olist.order_analytics
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1;





WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        SUM(product_value) AS revenue
    FROM olist.order_analytics
    WHERE order_status = 'delivered'
    GROUP BY 1
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,

    ROUND(
        100.0 *
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
        2
    ) AS mom_growth_pct

FROM monthly_sales
ORDER BY month;






WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM olist.order_analytics
    WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time Customer'
        WHEN order_count = 2 THEN '2 Orders'
        WHEN order_count = 3 THEN '3 Orders'
        ELSE '4+ Orders'
    END AS customer_segment,

    COUNT(*) AS customers

FROM customer_orders
GROUP BY 1
ORDER BY 1;





WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS orders
    FROM olist.order_analytics
    WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (WHERE orders > 1) AS repeat_customers,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE orders > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_rate

FROM customer_orders;





SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS orders,
    SUM(order_value) AS total_spend,
    AVG(order_value) AS average_order_value
FROM olist.order_analytics
WHERE order_status = 'delivered'
GROUP BY customer_unique_id
ORDER BY total_spend DESC
LIMIT 20;





CREATE TABLE olist.products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);





SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items,
    SUM(oi.price) AS revenue,
    AVG(oi.price) AS average_price

FROM olist.order_items oi

JOIN olist.products p
    ON oi.product_id = p.product_id

LEFT JOIN olist.category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY 1
ORDER BY revenue DESC;





WITH category_sales AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name
        ) AS category,
        SUM(oi.price) AS revenue

    FROM olist.order_items oi

    JOIN olist.products p
        ON oi.product_id = p.product_id

    LEFT JOIN olist.category_translation ct
        ON p.product_category_name = ct.product_category_name

    GROUP BY 1
)

SELECT
    category,
    revenue,

    ROUND(
        100.0 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_share_pct

FROM category_sales
ORDER BY revenue DESC;





SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(*) AS items_sold,
    SUM(price) AS revenue,
    SUM(freight_value) AS freight_revenue,
    AVG(price) AS average_item_price

FROM olist.order_items

GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 20;





SELECT
    s.seller_state,
    COUNT(DISTINCT oi.seller_id) AS sellers,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.price) AS revenue

FROM olist.order_items oi

JOIN olist.sellers s
    ON oi.seller_id = s.seller_id

GROUP BY s.seller_state
ORDER BY revenue DESC;




SELECT
    unique_sellers,
    COUNT(*) AS orders
FROM olist.order_sales
GROUP BY unique_sellers
ORDER BY unique_sellers;




SELECT
    COUNT(*) FILTER (WHERE unique_sellers > 1) AS multi_seller_orders,
    COUNT(*) AS total_orders,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE unique_sellers > 1)
        / COUNT(*),
        2
    ) AS multi_seller_order_pct

FROM olist.order_sales;





CREATE VIEW olist.delivery_analysis AS
SELECT
    order_id,
    customer_id,
    customer_unique_id,
    customer_state,

    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    EXTRACT(
        EPOCH FROM
        (order_approved_at - order_purchase_timestamp)
    ) / 3600 AS approval_hours,

    EXTRACT(
        EPOCH FROM
        (order_delivered_customer_date - order_purchase_timestamp)
    ) / 86400 AS delivery_days,

    EXTRACT(
        EPOCH FROM
        (order_delivered_customer_date - order_estimated_delivery_date)
    ) / 86400 AS delivery_delay_days

FROM olist.order_analytics
WHERE order_delivered_customer_date IS NOT NULL;





SELECT
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY delivery_days),
        2
    ) AS median_delivery_days,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE delivery_delay_days > 0)
        / COUNT(*),
        2
    ) AS late_delivery_pct

FROM olist.delivery_analysis;





SELECT
    customer_state,
    COUNT(*) AS delivered_orders,

    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE delivery_delay_days > 0)
        / COUNT(*),
        2
    ) AS late_delivery_pct

FROM olist.delivery_analysis

GROUP BY customer_state
HAVING COUNT(*) >= 100

ORDER BY late_delivery_pct DESC;





CREATE VIEW olist.order_review_summary AS
SELECT
    order_id,
    AVG(review_score) AS review_score
FROM olist.order_reviews
GROUP BY order_id;





SELECT
    CASE
        WHEN d.delivery_delay_days <= 0
            THEN 'On Time / Early'
        ELSE 'Late'
    END AS delivery_status,

    COUNT(*) AS orders,

    ROUND(AVG(r.review_score), 2) AS avg_review_score

FROM olist.delivery_analysis d

JOIN olist.order_review_summary r
    ON d.order_id = r.order_id

GROUP BY 1;





SELECT
    review_score,
    COUNT(*) AS reviews,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS review_share_pct

FROM olist.order_reviews

GROUP BY review_score

ORDER BY review_score;






SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS orders,
    SUM(payment_value) AS payment_value,
    AVG(payment_value) AS avg_payment_value

FROM olist.order_payments

GROUP BY payment_type

ORDER BY payment_value DESC;





SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS orders,
    AVG(payment_value) AS avg_payment_value

FROM olist.order_payments

WHERE payment_type = 'credit_card'

GROUP BY payment_installments

ORDER BY payment_installments;





SELECT
    p.payment_installments,

    COUNT(DISTINCT p.order_id) AS orders,

    ROUND(AVG(s.order_value), 2) AS avg_order_value,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY s.order_value),
        2
    ) AS median_order_value

FROM olist.order_payments p

JOIN olist.order_sales s
    ON p.order_id = s.order_id

WHERE p.payment_type = 'credit_card'

GROUP BY p.payment_installments

ORDER BY p.payment_installments;





SELECT
    SUM(price) AS product_revenue,
    SUM(freight_value) AS freight_cost,

    ROUND(
        100.0 * SUM(freight_value) / SUM(price),
        2
    ) AS freight_to_product_pct

FROM olist.order_items;





SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    SUM(oi.price) AS product_revenue,
    SUM(oi.freight_value) AS freight_cost,

    ROUND(
        100.0 *
        SUM(oi.freight_value) /
        NULLIF(SUM(oi.price), 0),
        2
    ) AS freight_pct

FROM olist.order_items oi

JOIN olist.products p
    ON oi.product_id = p.product_id

LEFT JOIN olist.category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY 1

ORDER BY freight_pct DESC;




