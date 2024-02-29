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
