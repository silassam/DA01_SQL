-- ex 1
SELECT COUNT( DISTINCT company_id) as duplicate_companies
FROM job_listings
WHERE company_id IN (SELECT company_id
FROM job_listings
GROUP BY company_id
HAVING COUNT(company_id) > 1)

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
  
