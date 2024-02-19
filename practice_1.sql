-- baitap 1
SELECT NAME
FROM CITY
WHERE POPULATION > 120000
AND COUNTRYCODE = 'USA';

-- baitap 2
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';

-- baitap 3
SELECT CITY
, STATE
FROM STATION;

-- baitap 4
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%'
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%';

-- baitap 5
SELECT DISTINCT CITY 
FROM STATION
WHERE CITY LIKE '%A'
OR CITY LIKE '%E'
OR CITY LIKE '%I'
OR CITY LIKE '%O'
OR CITY LIKE '%U';

-- baitap 6
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE 'A%'
AND CITY NOT LIKE 'E%'
AND CITY NOT LIKE 'I%'
AND CITY NOT LIKE 'O%'
AND CITY NOT LIKE 'U%';

-- baitap 7
select name 
from Employee
order by name asc;

-- baitap 8
select name
from Employee
where salary > 2000
and months < 10
order by employee_id asc;

-- baitap 9
select product_id
from Products
where low_fats = 'Y'
and recyclable = 'Y';

-- baitap 10
select name
from Customer
where referee_id <> 2 
or referee_id is null;

-- baitap 11
select name
, population
, area
from World
where area >= 3000000
or population >= 25000000;

-- baitap 12
select distinct author_id as id
from Views
where author_id = viewer_id
order by author_id asc;

-- baitap 13
SELECT part
, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

-- baitap 14
select *
from lyft_drivers
where yearly_salary <= 30000
or yearly_salary >= 70000;

-- baitap 15
select advertising_channel 
from uber_advertising
where year = 2019
and money_spent > 100000;











