-- 1. convert datatype
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer);
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (trim(quantityordered)::numeric);
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (trim(orderdate)::date);
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

--2. CHECK NULL OR '' OF ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE
SELECT ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE
FROM public.sales_dataset_rfm_prj
WHERE (ORDERNUMBER IS NULL)
OR (QUANTITYORDERED IS NULL)
OR (PRICEEACH IS NULL)
OR (ORDERLINENUMBER IS NULL OR ORDERLINENUMBER LIKE '')
OR (SALES IS NULL)
OR (ORDERDATE IS NULL)

-- 3. ADD CONTACTLASTNAME, CONTACTFIRSTNAME
ALTER TABLE public.sales_dataset_rfm_prj 
ADD COLUMN contactfirstname varchar(50);
ALTER TABLE public.sales_dataset_rfm_prj 
ADD COLUMN contactlastname varchar(50);
-- UPDATE TEN & VIET HOA
UPDATE public.sales_dataset_rfm_prj
SET contactfirstname = INITCAP(RIGHT(contactfullname, LENGTH(contactfullname)-POSITION('-' IN contactfullname)));
UPDATE public.sales_dataset_rfm_prj
SET contactlastname = INITCAP(LEFT(contactfullname, POSITION('-' IN contactfullname)-1));

-- 4. ADD QTR_ID, MONTH_ID, YEAR_ID 
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN year_id int;
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN month_id int;
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN qtr_id int;

UPDATE public.sales_dataset_rfm_prj
SET qtr_id = EXTRACT(QUARTER FROM orderdate)
, month_id = EXTRACT(MONTH FROM orderdate)
, year_id = EXTRACT(YEAR FROM orderdate)


-- 5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED theo 2 cach
-- cach 1: iqr
with min_max_table as (
select q1-1.5*iqr as min_value
, q3+1.5*iqr as max_value
from (
select percentile_cont(0.25) within group (order by quantityordered) as q1
, percentile_cont(0.75) within group (order by quantityordered) as q3
, percentile_cont(0.75) within group (order by quantityordered) - percentile_cont(0.25) within group (order by quantityordered) as iqr
from public.sales_dataset_rfm_prj
) as table_iqr
)
select quantityordered
from public.sales_dataset_rfm_prj
where quantityordered < (select min_value from min_max_table)
or quantityordered > (select max_value from min_max_table)

  
-- cach 2: z-score
-- z= (giá trị quan sát - trùng bình) / độ lệch chuẩn = (users - avg) / stddev
with table_1 as (
select quantityordered
, (select avg(quantityordered) from public.sales_dataset_rfm_prj) as avg_quantityordered
, (select stddev(quantityordered) from public.sales_dataset_rfm_prj) as stddev
from public.sales_dataset_rfm_prj
)
, outlier_table as (
select quantityordered
, (quantityordered - avg_quantityordered) / stddev as z_score
where abs ((quantityordered - avg_quantityordered)/stddev > 3)
)
UPDATE public.sales_dataset_rfm_prj
SET quantityordered = (
SELECT AVG(quantityordered)
FROM public.sales_dataset_rfm_prj
WHERE quantityordered IN (SELECT quantityordered FROM outlier_table)
)
