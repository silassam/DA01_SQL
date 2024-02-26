-- ex 1
SELECT COUNTRY.CONTINENT
, FLOOR(AVG(CITY.POPULATION))
FROM CITY
JOIN COUNTRY
ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT


-- ex 2
SELECT ROUND(AVG(CASE WHEN signup_action = 'Confirmed' THEN 1 ELSE 0 END), 2) AS activation_rate
FROM emails
JOIN texts
ON texts.email_id	= emails.email_id

-- ex 3
SELECT age_bucket
, ROUND(100.0 * SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END)/SUM(time_spent), 2) AS send_perc
, ROUND(100.0 * SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END)/SUM(time_spent), 2) AS open_perc
FROM activities
JOIN age_breakdown
USING (user_id)
WHERE activity_type IN ('send', 'open')
GROUP BY age_bucket

-- ex 4
SELECT customer_id
FROM customer_contracts
JOIN products
USING (product_id)
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) = 3

-- ex 5
SELECT em1.employee_id
, em1.name
, COUNT(em2.reports_to) AS reports_count
, ROUND(AVG(em2.age)) AS average_age
FROM Employees AS em1 
JOIN Employees AS em2 
ON em1.employee_id = em2.reports_to
GROUP BY em1.employee_id
, em1.name
ORDER BY em1.employee_id

-- ex 6
SELECT product_name
, SUM(unit) AS unit
FROM Products
LEFT JOIN Orders
USING (product_id)
WHERE EXTRACT(MONTH FROM order_date) = 02
AND EXTRACT(YEAR FROM order_date) = 2020
GROUP BY product_name
HAVING SUM(unit) >= 100

-- ex 7
SELECT page_id
FROM pages
LEFT JOIN page_likes
USING (page_id)
WHERE liked_date IS NULL
ORDER BY page_id
