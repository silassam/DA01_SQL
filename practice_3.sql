-- EX 1
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID

-- EX 2
SELECT user_id
, CONCAT(UPPER(LEFT(name, 1)),LOWER(RIGHT(name, LENGTH(name) - 1))) as name
FROM Users

-- EX 3
SELECT manufacturer
, CONCAT('$', ROUND(SUM(total_sales)/1000000, 0), ' million') AS total
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC
, manufacturer

-- EX 4
SELECT EXTRACT(MONTH FROM submit_date) AS mth
, product_id AS product
, ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date)
, product_id
ORDER BY EXTRACT(MONTH FROM submit_date)
, product_id ASC

-- EX 5
SELECT sender_id
, COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = 8
AND EXTRACT(YEAR FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

-- EX 6
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15

-- EX 7
SELECT activity_date AS DAY
, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE (activity_date > '2019-06-27' AND activity_date <= '2019-07-27')
GROUP BY activity_date

-- EX 8
select COUNT(id) AS num_em
from employees
WHERE (EXTRACT(MONTH FROM joining_date) BETWEEN 01 AND 07)
AND EXTRACT(YEAR FROM joining_date) = 2022

-- EX 9
select POSITION ('a' IN first_name)
from worker
where first_name = 'Amitah'

-- EX 10 
select winery
, substring(title, length(winery) + 2, 4) as year
from winemag_p2
where country = 'Macedonia'
