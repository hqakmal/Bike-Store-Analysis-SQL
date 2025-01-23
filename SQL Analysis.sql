SELECT b.brand_name , COUNT(p.product_id) as product_per_brand
FROM brands as b
JOIN products as p
ON p.brand_id = b.brand_id 
GROUP BY b.brand_name
ORDER BY product_per_brand DESC;

SELECT a.product_id, SUM(a.quantity) as quantity, b.product_name 
FROM order_items as a 
JOIN products as b 
ON a.product_id = b.product_id 
GROUP BY a.product_id, b.product_name
ORDER BY quantity DESC 
LIMIT 10;

WITH price AS (SELECT product_id, quantity, list_price, discount, list_price*quantity*(1 - discount) AS final 
FROM order_items) 
	SELECT a.product_id, a.product_name, ROUND(SUM(b.final)) AS sales_revenue 
	FROM price b 
	JOIN products a 
	ON a.product_id = b.product_id 
	GROUP BY a.product_id, a.product_name
	ORDER BY sales_revenue DESC LIMIT 10;

WITH price AS (SELECT product_id, quantity, list_price,list_price*quantity AS final 
FROM order_items) 
    SELECT c.category_id, c.category_name, ROUND(SUM(b.final)) AS prod_revenue, SUM(b.quantity) as quantity_sold 
	FROM price b 
    JOIN products a 
    ON a.product_id = b.product_id 
    JOIN categories c 
    ON c.category_id = a.category_id 
    GROUP BY c.category_id, c.category_name
    ORDER BY quantity_sold DESC;

SELECT stores.store_name, stocks.product_id, products.product_name 
FROM stocks 
        JOIN products ON stocks.product_id = products.product_id 
        JOIN stores ON stocks.store_id = stores.store_id 
        WHERE quantity = 0;

SELECT model_year, ROUND(AVG(list_price)) AS avg_price 
FROM products 
GROUP BY model_year;

SELECT state, COUNT (customer_id) as nb_customer 
FROM customers 
GROUP BY state 
ORDER BY nb_customer DESC;

WITH customer_order AS(SELECT a.customer_id, a.first_name, a.last_name, COUNT(b.order_id) as nb_orders, b.store_id
        FROM customers a 
        JOIN orders b 
        ON a.customer_id = b.customer_id 
        GROUP BY a.customer_id,  a.first_name, a.last_name, b.store_id)
        SELECT * FROM customer_order 
        WHERE nb_orders = (SELECT MAX(nb_orders) FROM customer_order) 
        ORDER BY store_id;

SELECT COUNT(*), EXTRACT(YEAR FROM TO_DATE(order_date, 'YYYY-MM-DD')) AS year
FROM order_items AS oi
JOIN orders AS o
ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year