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




-- MID_TEST
-- Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film
-- Chi phí thay thế thấp nhất là bao nhiêu?

SELECT DISTINCT replacement_cost
FROM public.film
ORDER BY replacement_cost
LIMIT 1;

/* số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
*/
SELECT 
CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'LOW'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
ELSE 'HIGH'
END AS category
, COUNT(film_id) AS num_film
FROM public.film
GROUP BY category
ORDER BY num_film;


/* danh sách bao gồm tiêu đề (title), (length), (category_name)
sắp xếp theo độ dài giảm dần
Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
*/
SELECT name AS cate_name
, title
, length
FROM public.film AS film
JOIN public.film_category AS fi_cate
ON film.film_id = fi_cate.film_id
JOIN public.category AS cate
ON fi_cate.category_id = cate.category_id
WHERE name IN ('Drama', 'Sports')
ORDER BY length DESC
LIMIT 1;

/* số lượng phim (tilte) trong mỗi danh mục (category)
danh mục nào là phổ biến nhất trong số các bộ phim
*/

SELECT name AS cate_name
, COUNT(title) AS num_title
FROM public.film AS film
JOIN public.film_category AS fi_cate
ON film.film_id = fi_cate.film_id
JOIN public.category AS cate
ON fi_cate.category_id = cate.category_id
GROUP BY name
ORDER by num_title DESC
LIMIT 1;


/* họ và tên của các diễn viên & số lượng phim họ tham gia
*/
SELECT CONCAT(first_name, ' ', last_name)
, COUNT(film_id) AS num_film_actor
FROM public.film_actor
JOIN public.actor 
USING (actor_id)
GROUP BY CONCAT(first_name, ' ', last_name)
ORDER BY num_film_actor DESC
LIMIT 1;

/* Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào
Có bao nhiêu địa chỉ như vậy?
*/
SELECT COUNT(address)
FROM public.address AS add
LEFT JOIN public.customer AS cus
ON cus.address_id = add.address_id
WHERE cus.customer_id IS NULL;

/*Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
*/
SELECT city
, SUM(amount) AS total
FROM public.city
JOIN public.address
USING (city_id)
JOIN public.customer
USING (address_id)
JOIN public.payment
USING (customer_id)
GROUP BY city
ORDER BY total DESC
LIMIT 1;


/*
cột 1: thông tin thành phố và đất nước ( format: “city, country")
cột 2: doanh thu tương ứng với cột 1
*/

SELECT city ||', '|| country AS city_country
, SUM(amount) AS total
FROM public.city
JOIN public.country
USING (country_id)
JOIN public.address
USING (city_id)
JOIN public.customer
USING (address_id)
JOIN public.payment
USING (customer_id)
GROUP BY city ||', '|| country
ORDER BY total DESC
LIMIT 1;
