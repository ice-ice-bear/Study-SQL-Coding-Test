/*
https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/ 

Table: Employees
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the primary key for this table.
This table contains information about the employees and the id of the manager they report to.
Some employees do not report to anyone (reports_to is null). 
employee_id는 이 테이블의 기본 키입니다.
이 테이블에는 직원에 대한 정보와 그들이 보고하는 관리자의 ID가 포함되어 있습니다.
일부 직원은 누구에게도 보고하지 않습니다. (reports_to는 null임)


Write an SQL query to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.
관리자의 ID와 이름, 그들에게 직접 보고하는 직원 수, 보고하는 직원들의 평균 연령(가장 가까운 정수로 반올림)을 SQL 쿼리를 작성하세요.
employee_id별로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Employees table:
+-------------+---------+------------+-----+
| employee_id | name    | reports_to | age |
+-------------+---------+------------+-----+
| 9           | Hercy   | null       | 43  |
| 6           | Alice   | 9          | 41  |
| 4           | Bob     | 9          | 36  |
| 2           | Winston | null       | 37  |
+-------------+---------+------------+-----+
Output: 
+-------------+-------+---------------+-------------+
| employee_id | name  | reports_count | average_age |
+-------------+-------+---------------+-------------+
| 9           | Hercy | 2             | 39          |
+-------------+-------+---------------+-------------+
Explanation:
Hercy has 2 people report directly to him, Alice and Bob.
Their average age is (41+36)/2 = 38.5, which is 39 after rounding it to the nearest integer.
설명:
Alice와 Bob이라는 2명의 사람은 Hercy에게 직접 보고합니다.
이들의 평균 연령은 (41+36)/2 = 38.5세로, 가장 가까운 정수로 반올림하면 39세입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Employees;
CREATE TABLE Employees(employee_id int, name varchar(20), reports_to int, age int);
INSERT INTO
	Employees (employee_id, name, reports_to, age)
VALUES
('9', 'Hercy', null , '43')
,('6', 'Alice', '9', '41')
,('4', 'Bob', '9', '36')
,('2', 'Winston', null , '37');
SELECT * FROM Employees;

# [my practice]
select *
from employees
where employee_id in (
	select reports_to
    from employees);

select a.employee_id, a.name, b.reports_count, b.average_age
from employees a inner join 
(	select reports_to as employee_id, count(reports_to) as reports_count , round(avg(age), 0) as average_age
	from employees	
	where reports_to is not null
	group by reports_to) b
on a.employee_id = b.employee_id
order by employee_id;

# [MYSQL]
select e.employee_id,
e.name,
count(ee.employee_id) reports_count,
round(avg(ee.age), 0) average_age
from Employees e
inner join Employees ee
on e.employee_id=ee.reports_to
group by e.employee_id, e.name
order by e.employee_id;
