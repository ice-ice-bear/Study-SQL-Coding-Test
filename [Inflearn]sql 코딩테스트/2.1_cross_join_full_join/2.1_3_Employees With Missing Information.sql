/*
https://leetcode.com/problems/employees-with-missing-information/ 

Table: Employees
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the name of the employee whose ID is employee_id.
employee_id는 이 테이블의 기본 키입니다.
이 테이블의 각 행은 ID가 employee_id인 직원의 이름을 나타냅니다.


Table: Salaries
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the salary of the employee whose ID is employee_id.
employee_id는 이 테이블의 기본 키입니다.
이 테이블의 각 행은 ID가 employee_id인 직원의 급여를 나타냅니다.


Write an SQL query to report the IDs of all the employees with missing information.
The information of an employee is missing if:
- The employee's name is missing, or
- The employee's salary is missing.
Return the result table ordered by employee_id in ascending order.
정보가 누락된 모든 직원의 ID를 보고하는 SQL 쿼리를 작성하세요.
직원 정보가 누락된 경우는 다음과 같습니다:
- 직원의 이름이 누락
- 직원의 급여가 누락
employee_id를 기준으로 오름차순으로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
Explanation: 
Employees 1, 2, 4, and 5 are working at this company.
The name of employee 1 is missing.
The salary of employee 2 is missing.
설명:
직원 1, 2, 4, 5는 이 회사에서 근무하고 있습니다.
직원 1의 이름이 누락되었습니다.
직원 2의 급여가 누락되었습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Employees;
CREATE TABLE Employees (employee_id int, name varchar(30));
INSERT INTO
	Employees (employee_id, name)
VALUES
('2', 'Crew')
,('4', 'Haven')
,('5', 'Kristian');
SELECT * FROM Employees;

# [SETTING]
USE PRACTICE;
DROP TABLE Salaries;
CREATE TABLE Salaries (employee_id int, salary int);
INSERT INTO
	Salaries (employee_id, salary)
VALUES
('5', '76071')
,('1', '22517')
,('4', '63539');
SELECT * FROM Salaries;

#[my practice]
select *
from(select s.employee_id
from salaries s
where s.employee_id not in(
select e.employee_id
from employees e)

union

select e.employee_id
from employees e
where e.employee_id not in(
select s.employee_id
from salaries s)) t
order by t.employee_id
;



# [MYSQL]
# MYSQL에서는 full outer join을 지원하지 않아서, 이렇게 대체로 full outer join 로직을 작성한다.
select a.employee_id
from Employees a
left outer join
Salaries b
on a.employee_id = b.employee_id
where b.employee_id is null

union

select a.employee_id
from Salaries a
left outer join
Employees b
on a.employee_id = b.employee_id
where b.employee_id is null
order by employee_id;