/* Get the number of unique users, number of orders, and total sale price per status and month */
SELECT DATE_TRUNC(DATE(created_at), MONTH) as month_time,
       status,
       COUNT(DISTINCT user_id) as total_unique_users,
       COUNT(DISTINCT order_id) as total_orders,
       SUM(sale_price) as total_sales_price
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE created_at between '2019-01-01' and '2022-09-01'
GROUP BY 1, 2
ORDER BY 2, 1

/* get frequencies, average order value, and total number of unique users where status is complete, grouped by month */

    SELECT DATE_TRUNC(DATE(created_at), MONTH) as month_time,
        ROUND(COUNT(DISTINCT order_id)/COUNT(DISTINCT user_id), 2) as frequency,
        ROUND(SUM(sale_price)/ COUNT(distinct order_id), 2) as average_order_value,
        COUNT(DISTINCT user_id) as total_unique_users,
    FROM `bigquery-public-data.thelook_ecomerce.order_items`
    WHERE shipped_at BETWEEN '2019-01-01' and '2022-09-01'
        AND status = 'Complete'
    GROUP BY 1
    ORDER BY 1

/* Find the user id, email, first and last name of users whose status is refunded on Aug 22 */

SELECT DISTINCT (u.id) AS user_id,
       u.email AS email,
       u.first_name AS first_name,
       u.last_name AS last_name,
FROM `bigquery-public-data.thelook_ecommerce.orders` as o
LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` as u
    ON o.user_id = u.id
WHERE o.status = 'Refunded'
    AND o.returned_at BETWEEN '2022-08-01' AND '2022-09-01'
ORDER BY 3

/*Get the top 5 least and most profitable product over all time */
/*Get the top 5 least and most profitable product over all time */
    WITH product_sales AS (
    SELECT oi.product_id AS product_id,
            pr.product_name AS product_name,
            ROUND(pr.retail_place,2) AS retail_price,
            ROUND(pr.cost,2) AS cost,
            ROUND(oi.sale_price - pr.cost, 2) as profit
    FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
    JOIN `bigquery-public-data.thelook_ecommerce.products` as pr
    ON oi.product_id = pr.id
    WHERE oi.status = 'Complete'
    ),

    product_profit AS (
    SELECT
        product_id,
        product_name,
        retail_price,
        cost,
        ROUND(SUM(profit), 2) AS total_profit
    )
    FROM product_sales
    WHERE product_name IS NOT NULL
    GROUP BY 1,2,3,4
    ORDER BY 2

    (SELECT *
    FROM product_profit
    ORDER BY 5 DESC
    LIMIT 5
    )
    INNER JOIN
    (SELECT *
    FROM product_profit
    ORDER BY 5 ASC
    LIMIT 5
    )