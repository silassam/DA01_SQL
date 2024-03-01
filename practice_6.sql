-- ex 1
SELECT COUNT( DISTINCT company_id) as duplicate_companies
FROM job_listings
WHERE company_id IN (
  SELECT company_id
FROM job_listings
GROUP BY company_id
HAVING COUNT(company_id) > 1
  )

-- ex 2
WITH table_1 AS (
SELECT category
, product
, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category
, product
)
, table_2 AS (
SELECT *
, RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rank
FROM table_1
)
SELECT category
, product
, total_spend
FROM table_2 WHERE rank < 3

-- ex 3
SELECT COUNT(policy_holder_id)
FROM (SELECT policy_holder_id
  , COUNT(case_id)
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3

-- ex 4
SELECT page_id
FROM pages
LEFT JOIN page_likes
USING (page_id)
WHERE liked_date IS NULL
ORDER BY page_id


-- ex 5
WITH table_mth AS (
SELECT user_id
, EXTRACT(month FROM event_date) AS month
FROM user_actions
WHERE EXTRACT(month FROM event_date) = 07
AND EXTRACT(year FROM event_date) = 2022
GROUP BY user_id
, EXTRACT(month FROM event_date)
)
, table_pre_mth AS (
SELECT user_id
, EXTRACT(month FROM event_date) AS pre_month
FROM user_actions
WHERE EXTRACT(month FROM event_date) = 06
AND EXTRACT(year FROM event_date) = 2022
GROUP BY user_id
, EXTRACT(month FROM event_date)
)
SELECT month
, COUNT(user_id) AS monthly_active_users
FROM table_mth
LEFT JOIN table_pre_mth
USING (user_id)
WHERE pre_month IS NOT NULL
GROUP BY month

-- ex 6
select left(cast(trans_date as varchar), 7) as month
, country
, count(id) as trans_count
, sum(case when state = 'approved' then 1 else 0 end) as approved_count
, sum(amount) as trans_total_amount
, sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from Transactions t1
group by left(cast(trans_date as varchar), 7)
, country

  -- ex 7 
  With rank_table as (
    select *
, rank() over (partition by product_id order by year) as rank
from Sales
)
select product_id
, year as first_year
, quantity
, price
from rank_table
where rank = 1


-- ex 8
select customer_id
from Customer
group by customer_id
having count(distinct product_key) = (
    select count(distinct product_key)
    from Product
)

-- ex 9
select employee_id
from Employees
where salary < 30000
and manager_id not in (
    select employee_id
    from Employees )
order by employee_id

-- ex 10 (trùng bài ex 1)


-- ex 11
(select Users.name as results
from Users
join MovieRating
using (user_id)
group by Users.name
order by count(user_id) desc
, name
limit 1
)
union all
(select title as results
from Movies
join MovieRating
using (movie_id)
where extract (month from created_at) = 02
and extract (year from created_at) = 2020
group by title
order by avg(rating) desc
, title
limit 1)



-- ex 12
with table_1 as (
select requester_id as id
from RequestAccepted
union all
select accepter_id
from RequestAccepted
) 
select *
, count(*) as num
from table_1
group by id
order by num DESC
limit 1
  

  
