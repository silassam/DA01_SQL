-- ex 1
SELECT
SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_reviews
, SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS moblie_views
FROM viewership;

-- ex 2
SELECT *
, CASE WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
ELSE 'No'
END AS triangle
FROM Triangle;

-- ex 3
help me T.T 

-- ex 4
SELECT name
FROM Customer
WHERE referee_id <> 2 
OR referee_id IS NULL;

-- ex 5
SELECT survived
, SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class
, SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class
, SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
from titanic
GROUP BY survived;
