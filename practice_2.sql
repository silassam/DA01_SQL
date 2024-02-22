-- ex 1
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0

-- ex 2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY)
FROM STATION

-- ex 3
SELECT CEIL(AVG(Salary) - AVG(REPLACE(Salary, '0', '')))
FROM EMPLOYEES

-- ex 4
SELECT ROUND(CAST(SUM(order_occurrences * item_count) / SUM(order_occurrences) AS NUMERIC), 1)
FROM items_per_order;

-- ex 5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3

-- ex 6
SELECT user_id
, MAX(DATE(post_date)) - MIN(DATE(post_date)) as days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(user_id) >= 2

-- ex 7
SELECT card_name
, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

-- ex 8
SELECT manufacturer	
, COUNT(drug) AS drug_count
, ABS(SUM(total_sales - cogs)) as total_loss
FROM pharmacy_sales
WHERE total_sales - cogs < 0
GROUP BY manufacturer	
ORDER BY total_loss desc

-- ex 9
select *
from Cinema
where id % 2 <> 0 
and description not like  ('%boring%')
order by rating desc

-- ex 10
select teacher_id
, count(distinct subject_id) as cnt
from Teacher
group by teacher_id

-- ex 11
select user_id
, count(follower_id) as followers_count
from Followers
group by user_id
order by user_id

-- ex 12
select class
from Courses
group by class
having count(student) >= 5


