/* Get the number of unique users, number of orders, and total sale price per status and month */
SELECT DATE_TRUNC(DATE(created_at) ) as order_time,
       status,
       COUNT(DISTINCT user_id) as total_unique_users,
       COUNT(DISTINCT order_id) as total_orders,
       SUM(sale_price) as total_sales_price
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE created_at between '2019-01-01' and '2022-09-01'
GROUP BY 1, 2
ORDER BY 2, 1