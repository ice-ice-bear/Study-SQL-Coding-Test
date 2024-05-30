/*
https://leetcode.com/problems/calculate-special-bonus/ 

Table: Employees
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the employee ID, employee name, and salary.
employee_id는 이 테이블의 기본 키입니다.
이 테이블의 각 행은 직원 ID, 직원 이름 및 급여를 나타냅니다.


Write an SQL query to calculate the bonus of each employee.
The bonus of an employee is 100% of their salary if the ID of the employee is an odd number and the employee name does not start with the character 'M'.
The bonus of an employee is 0 otherwise.
Return the result table ordered by employee_id.
각 직원의 보너스를 계산하는 SQL 쿼리를 작성하세요.
직원의 보너스는 직원 ID가 홀수이고 직원 이름이 'M' 문자로 시작하지 않는 경우 급여의 100%입니다.
그렇지 않으면 직원의 보너스는 0입니다.
employee_id별로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Employees table:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3800   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7700   |
+-------------+---------+--------+
Output: 
+-------------+-------+
| employee_id | bonus |
+-------------+-------+
| 2           | 0     |
| 3           | 0     |
| 7           | 7400  |
| 8           | 0     |
| 9           | 7700  |
+-------------+-------+
Explanation: 
The employees with IDs 2 and 8 get 0 bonus because they have an even employee_id.
The employee with ID 3 gets 0 bonus because their name starts with 'M'.
The rest of the employees get a 100% bonus.
설명:
ID 2와 8을 가진 직원은 employee_id가 짝수이므로 보너스가 0입니다.
ID 3을 가진 직원은 이름이 'M'으로 시작하므로 보너스가 0입니다.
나머지 직원들은 100% 보너스를 받습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Employees;
CREATE TABLE Employees (employee_id int, name varchar(30), salary int);
INSERT INTO
	Employees (employee_id, name, salary)
VALUES
('2', 'Meir', '3000')
,('3', 'Michael', '3800')
,('7', 'Addilyn', '7400')
,('8', 'Juan', '6100')
,('9', 'Kannon', '7700');
SELECT * FROM Employees;

#[my practice]

select employee_id,
(case when mod(employee_id, 2) =1 and name not like "m%" then salary else 0 end) as bonus
from employees
order by employee_id;

# [MYSQL]
select employee_id,
case
when substr(name,1,1)!='M' and MOD(employee_id,2)=1 then salary
else 0
end bonus
from Employees
order by employee_id;
