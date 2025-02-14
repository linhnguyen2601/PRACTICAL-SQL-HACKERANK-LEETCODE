# 1757. Recyclable and Low Fat Products

select product_id from Products
  where low_fats='Y' and recyclable ='Y'

# 584. Find Customer Referee

select name from customer
  where referee_id is null or referee_id <> 2

# 595. Big Countries

select name, population, area from world
where area >= 3000000 or population >= 25000000

# 1148. Article Views I
  
select distinct(author_id) as id from views
  where author_id  = viewer_id

#  1683. Invalid Tweets I
select tweet_id from tweets
  where length(content) > 15

# 1378. Replace Employee ID With The Unique Identifier
  
select b.unique_id,a.name from employees as a
  left join employeeUNI as b
  on a.id=b.id
  
#  1068. Product Sales Analysis I

select product_name,year, price from sales as a
  join product as b
  on a.product_id=b.product_id

1581. Customer Who Visited but Did Not Make Any Transactions

select customer_id, count(visit_id) as count_no_trans from visits  
  where visit_id not in (Select visit_id from transactions)
  group by customer_id

select customer_id, count(a.visit_id) as count_no_trans from visits as a
  left join transactions as b
  on a.visit_id=b.visit_id
  where transaction_id is null
  group by customer_id

# 197. Rising Temperature

select id from 
(
select id, temperature,
  lag(temperature) over(order by recorddate) as tem_next_day 
  from weather) as a
  where temperature > tem_next_day
=> không pass được test case nếu ngày recordDate không liền nhau

with cte as 
  (
select *, recordDate -1 as previous_recordDate 
  from weather)
select a.id from cte as a
  join weather as b
  on a.previous_recordDate = b.recordDate
  where a.temperature > b.temperature

# 1661. Average Time of Process per Machine

select machine_id, 
  round(avg(end_time - start_time)::numeric,3) as processing_time
  from
(
select a.machine_id, a.process_id, a.activity_type, a.timestamp as start_time, b.timestamp as end_time from activity as a
  join activity as b
  on (a.machine_id = b.machine_id) and (a.process_id = b.process_id)
  where a.activity_type = 'start' and b.activity_type = 'end') as c
  group by machine_id

# 577. Employee Bonus

select name, bonus from employee as a
  left join bonus as b
  on a.empID= b.empID
  where bonus < 1000 or bonus is null

# 1280. Students and Examinations  #cross join
  
with cte as
  (
select a.*, b.*, c.student_id as student_exam from students as a
  cross join subjects as b
  left join examinations as c
  on a.student_id = c.student_id 
    and b.subject_name = c.subject_name
  order by a.student_id, b.subject_name
  ),
cte2 as
  (
select student_id, student_name, subject_name, 
  case 
    when student_exam is null 
    then 0 
    else 1 end as exam
  from cte
  )
select student_id, student_name, subject_name, sum(exam) as attended_exams 
  from cte2
  group by student_id, student_name, subject_name

# 570. Managers with at Least 5 Direct Reports

select name from employee 
  where id in 
    (select managerid from employee
      group by managerid
      having count(*) >= 5
    ) 

# 1934. Confirmation Rate

with cte as 
  (
select a.user_id, b.action from signups as a
  left join confirmations as b
  on a.user_id = b.user_id 
  )

select user_id, 
round
  (sum
    (case   
        when action = 'confirmed' 
        then 1 
        else 0 end)*1.0/count(*),2) as confirmation_rate 
  from cte
  group by user_id

# 620. Not boring movie

select * from cinema
  where id % 2 = 1 and description <> 'boring'
  order by rating desc  

# 1251. Average Selling Prices

with cte as
  (
select a.product_id, a.price, b.units from prices as a
  join unitssold as b
  on a.product_id = b.product_id
  where b.purchase_date between a.start_date and a.end_date
  )
select product_id, 
    round(sum(price*units)/sum(units) :: numeric, 2) as average_price from cte
  group by product_id

# không qua được test case trong trường hợp bảng products có những sản phẩm không được bán và không có trong unitsSold

with cte as(
select a.product_id, a.price, b.units from prices as a
  left join unitssold as b
  on a.product_id = b.product_id
  where b.purchase_date is null or b.purchase_date between a.start_date and a.end_date)
select product_id, 
case 
  when sum(units) is not null 
  then (round(sum(price*units)/sum(units) :: numeric, 2)) 
  else 0 end as average_price 
  from cte
group by product_id

# 2356. Number of Unique Subjects Taught by Each Teacher

#Pandas:

import pandas as pd

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:

#PostgresSQL:

# 1075. Project Employees I

select project_id, round(avg(experience_years), 2) as average_years from
(
select a.*, experience_years from project as a
join employee as b
on a.employee_id = b.employee_id) as c
group by project_id

# 1633. Percentage of Users Attended a Contest

select contest_id, 
round(
    count(user_id)*100.00/(select count(Distinct(user_Id)) from users)
    ,2) as percentage 
  from register
group by contest_id
order by percentage desc, contest_id

# 1211. Queries Quality and Percentage

select query_name,
round(avg(rating*1.0/position),2) as quality,
round(
    sum(case when rating < 3 then 1 else 0 end)*100.00/count(rating)
    ,2) as poor_query_percentage 
from queries
where query_name is not null
group by query_name

# 1193. Monthly Transactions I

SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country, 
    COUNT(id) AS trans_count,
    SUM(case when state = 'approved' then 1 else 0 end) as approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(case when state = 'approved' then amount else 0 end) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;

# 1174. Immediate Food Delivery II

## Tỷ lệ đơn hàng giao ngay trong ngày:

select 
round(
sum(case when 
order_date = customer_pref_delivery_date 
then 1 else 0 end
    )*100.0
    /count(*) 
    ,2)as immediate_percentage from Delivery

## Tỷ lệ khách hàng nhận được đơn hàng đầu tiên giao ngay trong ngày

select round(sum(immediate)*100.0/count(*),2) as immediate_percentage from 
  (
  select 
    customer_id, 
    case 
      when order_date = (min(order_date) over(partition by customer_id)) 
      then 1 
      else 0 end as first_order,
    case 
      when order_date = customer_pref_delivery_date
      then 1 
      else 0 end as immediate
  from delivery
  ) as a
where first_order =1

# 550. Game Play Analysis IV

with cte as 
    (
select player_id, event_date, 
row_number() over (partition by player_id order by event_date) as first_day,
lead(event_date) over(partition by player_id order by event_date) as next_day 
from activity
    ),
cte2 as
    (
select player_id, first_day,
case when next_day - event_date = 1 then 1 else 0 end as login_next_day
from cte)
select 
round(
sum
(case when first_day = 1 and login_next_day =1 then 1 else 0 end)*1.0
/count(distinct(player_id))
,2) as fraction from cte2

# 2356. Number of Unique Subjects Taught by Each Teacher

select teacher_id, count(Distinct(Subject_id)) as cnt 
from teacher
group by teacher_id

# 1141. User Activity for the Past 30 Days I

select activity_date as day, 
      count(distinct(user_id)) as active_users
from activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date

# 1070. Product Sales Analysis III

select product_id, year as first_year, quantity, price 
  from
  (
    select product_id, year,
    rank() over(partition by product_Id order by year) as stt,
    quantity, price 
    from sales
  ) as a
where stt =1

# 596. Classes More Than 5 Students
  
select class 
from courses 
group by class
having count(student) >= 5

# 1729. Find Followers Count

select user_id, count(follower_id) as followers_count 
  from followers
group by user_id
order by user_id

# 619. Biggest Single Number

select max(num) as num 
from (
  select num, count(num) as cnt 
  from mynumbers
  group by num) as a
where cnt =1 

# 1045. Customers Who Bought All Products

select customer_id 
from (
    select customer_id, count(distinct(product_key)) as cnt 
    from customer 
    group by customer_id) as a
where cnt = (select count(distinct(product_key)) from product)

# 1731. The Number of Employees Which Report to Each Employee

with cte as (
select reports_to as employee_id, count(employee_id) as reports_count, 
round(avg(age)) as average_age from employees
group by reports_to 
having count(employee_id) >= 1)
select a.employee_id, b.name, reports_count, average_age from cte as a
join employees as b
on a.employee_id = b.employee_id
order by a.employee_id

# 1789. Primary Department for Each Employee

select employee_id, department_id from employee 
where
primary_flag = 'Y'
or employee_id in (
    select employee_id from employee 
    group by employee_id
    having count(department_id) =1
)

# 610. Triangle Judgement

select *,
case when
x + y > z and y+ z > x and x + z > y then 'Yes' else 'No' end as triangle 
from triangle

# 180. Consecutive Numbers

select distinct(num) as ConsecutiveNums 
  from 
  (
select id, num, 
  lead(id) over(order by id) next_id, 
  lead(id, 2) over(order by id) as third_id,
  lead(num) over(order by id) as next_num,
  lead(num,2) over(order by id) as third_num
from logs
  ) as a
 where num = next_num and num = third_num 
  and
 id + 1 = next_id and id + 2 = third_id

# 1164. Product Price at a Given Date

with cte as (
  
select Product_id, new_price, change_date, 
case when change_date <= '2019-08-16' 
  then
    row_number() over(partition by product_id order by change_date) 
  end as change_times,
min(change_date) over(partition by product_id) as first_change
from products)

, cte2 as (

select product_id,
case 
when 
  first_change > '2019-08-16' then 10
when
  change_date = '2019-08-16' then new_price
when 
  change_times = max(change_times) over(partition by product_id) then new_price
 end as price
from cte)

select distinct(product_id), price from cte2
where price is not null

# 1204. Last Person to Fit in the Bus

with cte as
(
select person_name,
sum(weight) over(order by turn) as total_weight from queue
)
select person_name from cte
where total_weight = (select max(total_weight) from cte where total_weight <= 1000)

# 1907. Count Salary Categories

select 'Low Salary' as category, count(*) as accounts_count from accounts
where income < 20000
union
select 'Average Salary' as category, count(*) as accounts_count from accounts
where income between 20000 and 50000
union
select 'High Salary' as category, count(*) as accounts_count from accounts
where income > 50000

# 1978. Employees Whose Manager Left the Company

select employee_id from employees 
where salary < 30000 and
manager_id is not null and manager_id not in 
(select employee_id from employees) 
order by employee_id

# 626. Exchange Seats

select
case 
when id%2 = 1 and id = (Select count(*) from seat) then id 
when id%2=0 then id - 1
else id + 1 
end as id,
student from seat
order by id

# 1341. Movie Rating  
(SELECT name AS results
FROM users AS a
JOIN movieRating AS b ON a.user_id = b.user_id
GROUP BY name
ORDER BY COUNT(*) DESC, name
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM movies AS c
JOIN movieRating AS d ON c.movie_id = d.movie_id
WHERE d.created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY title
ORDER BY AVG(d.rating) DESC, title

LIMIT 1);

# 1321. Restaurant Growth

with cte as
(select visited_on, sum(amount) as amount from customer
group by visited_on),
cte2 as (
select visited_on,
sum(amount) over(order by visited_on rows between 6 preceding and current row) as amount from cte
)
select visited_on, amount, 
round(amount/7,2) as average_amount
from cte2 
offset 6

# 602. Friend Requests II: Who Has the Most Friends

with cte as (
select requester_id as id, count(requester_id) as num from RequestAccepted
group by requester_id
UNION ALL
select accepter_id as id, count(accepter_id) as num from RequestAccepted
group by accepter_id
)
select id, sum(num) as num
from cte
group by id
order by num desc
limit 1

# 585. Investments in 2016

with cte as (
select tiv_2015, tiv_2016, lat, lon, 
row_number() over(partition by lat, lon) as num,
count(*) over(partition by tiv_2015) as same_tiv_2015 from insurance)

select round(sum(tiv_2016)::numeric,2) as tiv_2016 from cte
where (lat, lon) not in (select lat, lon from cte where num = 2)
and same_tiv_2015 > 1

# 185. Department Top Three Salaries

with cte as (
Select b.name as department, a.name as employee, salary,
dense_rank()  over(partition by b.name order by salary desc) as ranking from employee as a
join department as b
on a.departmentId = b.id
)
select department, employee, salary from cte
where ranking <= 3

# 1667. Fix Names in a Table

SELECT user_id, 
       INITCAP(name) AS name
FROM users
ORDER BY user_id

# 1527. Patients With a Condition

select patient_id, patient_name, conditions from patients
where conditions like 'DIAB1%' or conditions like '% DIAB1%'

# 196. Delete Duplicate Emails

with cte as (
select id, email, 
row_number() over(partition by email order by id) as stt from person)
delete from person
where id in (select id from cte where stt > 1) 

# 176. Second Highest Salary
  
WITH cte AS (
    SELECT id, 
           salary, 
            DENSE_RANK() OVER (ORDER BY salary DESC) AS stt 
    FROM employee
)
SELECT 
    CASE 
        WHEN MAX(stt) = 1 THEN NULL 
        ELSE (SELECT salary FROM cte WHERE stt = 2 limit 1)
    END AS SecondHighestSalary
FROM cte;

# 570. Managers with at Least 5 Direct Reports
  
select name from employee where id in (
            select managerId from employee 
            group by managerID
            having count(managerId) >=5)

# 1934. Confirmation Rate

with cte as(    
select a.user_id, 
count(*) as total_cnt,
sum(case when action = 'confirmed' then 1 else 0 end) as confirmed_cnt
from signups as a
left join confirmations as b
on a.user_id =  b.user_id
group by user_id
)
select user_id, 
case when confirmed_cnt is null then 0
else
round(confirmed_cnt/(total_cnt),2) end as confirmation_rate 
from cte

# 620. Not Boring Movies

select * from cinema 
where id%2=1 and description not like '%boring%'
order by rating desc

# 1251. Average Selling Price
  
with cte as(
select a.product_id, a.price, b.units from prices as a
left join unitssold as b
on a.product_id = b.product_id
where b.purchase_date is null or b.purchase_date between a.start_date and a.end_date)
select product_id, 
case 
when sum(units) is not null 
then (round(sum(price*units)/sum(units) :: numeric, 2)) 
else 0 end as average_price from cte
group by product_id

# 1075. Project Employees I

select project_id, 
round(avg(experience_years),2) as average_years  from project as a
join employee as b
on a.employee_id = b.employee_id
group by project_id

# 1667. Fix Names in a Table
  
SELECT user_id, 
concat(upper(left(name, 1)), lower(substring(name, 2))) as name
FROM users
ORDER BY user_id;

# 1484. Group Sold Products By The Date

select sell_date, count(distinct(product)) as num_sold, 
string_agg(distinct(product),',' order by product)  as products
from activities
group by sell_date
order by sell_date 

# 1484. Group Sold Products By The Date
  
select product_name, sum(unit) as unit from products as a 
join orders as b
on a.product_id = b.product_id
where order_date between '2020-02-01' and '2020-02-29'
group by product_name
having sum(unit) >= 100

# 1517. Find Users With Valid E-Mails

SELECT *
FROM Users
WHERE mail ~ '^[a-zA-Z]+[a-zA-Z0-9_.-]*@leetcode\.com$'

Explanation of the Regular Expression
^: Asserts the position at the start of the string.
[a-zA-Z]+: Matches one or more alphabetic characters (both lowercase a-z and uppercase A-Z).
[a-zA-Z0-9_.-]*: Matches zero or more characters that can be alphabetic (a-zA-Z), digits (0-9), underscores (_), dots (.), or hyphens (-).
@leetcode\.com: Matches the literal string @leetcode.com. The backslash (\) is used to escape the dot (.), making it a literal dot rather than the regex metacharacter for any character.
$: Asserts the position at the end of the string.
