-- ex 1
with table_1 as (
select *
, rank () over (partition by customer_id order by order_date) as rank_column
, case when order_date = customer_pref_delivery_date then 1 else 0 end as immediate_order 
from Delivery
)
select round(avg(immediate_order), 4) * 100.0 as immediate_percentage
from table_1
where rank_column = 1

-- ex 2
  select sum(second_login) / count(distinct player_id) as fraction
  from (
  select player_id
  , datediff(event_date, min(event_date) over (partition by player_id)) = 1 as second_login
  from Activity
  ) as table_1


-- ex 3
select case when id % 2 = 0 then id - 1
when id = (select count(*) from Seat) then id
else id + 1
end as id, student 
from Seat
order by id 

-- ex 4 

-- ex 5

-- ex 6
select Department
, Employee
, Salary
from (
    select Department.name as Department
, Employee.name as Employee
, salary as Salary
, dense_rank() over (partition by departmentid order by salary desc) as rank
from Employee
left join Department
on Employee.departmentId = Department.id
) as table_1
where rank < 4

-- ex 7

