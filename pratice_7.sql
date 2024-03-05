-- EX 1
WITH table_1 AS (
SELECT EXTRACT(year FROM transaction_date) as year
, product_id
, SUM(spend) OVER(PARTITION BY product_id, EXTRACT(year FROM transaction_date) ORDER BY product_id) AS curr_year_spend	
FROM user_transactions 
)
SELECT * 
, lag(curr_year_spend) over (PARTITION BY product_id ORDER BY product_id, year) as prev_year_spend
, ROUND((curr_year_spend - lag(curr_year_spend) over (PARTITION BY product_id ORDER BY product_id, year)) / 
  lag(curr_year_spend) over (PARTITION BY product_id ORDER BY product_id, year)*100.0, 2) AS yoy_rate
FROM table_1

-- EX 2
SELECT DISTINCT card_name
, FIRST_VALUE (issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC

-- EX 3
SELECT *
FROM (SELECT user_id
, LEAD(spend, 2) OVER(PARTITION BY user_id ORDER BY transaction_date) AS spend
, LEAD(transaction_date, 2) OVER(PARTITION BY user_id ORDER BY transaction_date) AS transaction_date
FROM transactions) AS total
WHERE transaction_date IS NOT NULL;


SELECT user_id
, spend
, transaction_date 
FROM (SELECT user_id
, spend
, transaction_date
, ROW_NUMBER () OVER(PARTITION BY user_id ORDER BY transaction_date) AS row_number
FROM transactions) as total
WHERE row_number = 3

-- EX 4
SELECT transaction_date
, user_id
, purchase_count
FROM (
SELECT *
, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS row_number
, COUNT(product_id) OVER(PARTITION BY user_id, transaction_date ORDER BY transaction_date DESC) AS purchase_count
FROM user_transactions
) AS total
WHERE row_number = 1
ORDER BY transaction_date

-- EX 5
WITH table_1 AS (
SELECT *
, LAG(tweet_count, 1) OVER (PARTITION BY user_id ORDER BY tweet_date) AS lag_1
, LAG(tweet_count, 2) OVER (PARTITION BY user_id ORDER BY tweet_date) AS lag_2
FROM tweets
)
SELECT user_id
, tweet_date	
, CASE
WHEN lag_1 IS NULL AND lag_2 IS NULL THEN ROUND(tweet_count, 2)
WHEN lag_1 IS NOT NULL AND lag_2 IS NULL THEN ROUND((lag_1 + tweet_count) / 2.0, 2)
ELSE ROUND((lag_1 + lag_2 + tweet_count) / 3.0, 2)
END AS rolling_avg_3d
FROM table_1


-- EX 6
SELECT COUNT(merchant_id) AS payment_count
FROM
(
SELECT * 
, LEAD(transaction_timestamp) OVER
(PARTITION BY merchant_id, credit_card_id, amount  ORDER BY transaction_timestamp) AS post_time
, LEAD(transaction_timestamp) OVER
(PARTITION BY merchant_id, credit_card_id, amount  ORDER BY transaction_timestamp) - transaction_timestamp AS mins
FROM transactions) AS total
WHERE EXTRACT(minute FROM mins) <= 10
AND EXTRACT(hour FROM mins) = 0

-- EX 7
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

-- EX 8
WITH table_1 AS (
SELECT artist_id
, artist_name
, COUNT(song_id) AS num_song
FROM artists
JOIN songs
USING (artist_id)
JOIN global_song_rank
USING (song_id)
WHERE rank <= 10
GROUP BY artist_id
, artist_name
)
, rank_table AS (
SELECT artist_name
, DENSE_RANK () OVER (ORDER BY num_song DESC) AS artist_rank
FROM table_1
)
SELECT *
FROM rank_table
WHERE artist_rank < 6


