/*
https://leetcode.com/problems/department-highest-salary/

Table: Employee
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key column for this table.
departmentId is a foreign key of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee.
It also contains the ID of their department.
id는 이 테이블의 기본 키 열입니다.
departmentId는 Department 테이블 ID의 외래 키입니다.
이 테이블의 각 행은 직원의 ID, 이름, 급여를 나타냅니다.
해당 부서의 ID도 포함되어 있습니다.


Table: Department
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
id는 이 테이블의 기본 키 열입니다.
부서 이름이 NULL이 아닌 것이 보장됩니다.
이 테이블의 각 행은 부서의 ID와 이름을 나타냅니다.

Find employees who have the highest salary in each of the departments.
Return the result table in any order.
각 부서에서 급여가 가장 높은 직원을 찾아보세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
설명: Max와 Jim은 둘 다 IT 부서에서 가장 높은 급여를 받고 있으며 Henry는 영업 부서에서 가장 높은 급여를 받습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE (ID INT, NAME VARCHAR(255), SALARY INT, DEPARTMENTID INT);
INSERT INTO
	EMPLOYEE (ID, NAME, SALARY, DEPARTMENTID)
VALUES
('1', 'JOE', '70000', '1')
,('2', 'JIM', '90000', '1')
,('3', 'HENRY', '80000', '2')
,('4', 'SAM', '60000', '2')
,('5', 'MAX', '90000', '1');
SELECT * FROM EMPLOYEE;

# [SETTING]
USE PRACTICE;
DROP TABLE DEPARTMENT;
CREATE TABLE DEPARTMENT (ID INT, NAME VARCHAR(255));
INSERT INTO
	DEPARTMENT (ID, NAME)
VALUES
('1', 'IT')
,('2', 'SALES');
SELECT * FROM DEPARTMENT;

#[my practice] - rank
select department, employee, salary
from (
select d.name as department , e.name as employee, salary,
rank() over(partition by departmentid order by salary desc) as earning
from department d 
inner join
employee e
on e.departmentid = d.id) f
where earning = 1;

# [my practice] - min/max
select *
from (select e.name as employee, e.salary, d.name as department
from
(select departmentid, salary, name
from employee) e
inner join
(select *
from department) d
where e.departmentid = d.id) ed;

(select departmentid, max(salary) as salary
from employee
group by departmentid);

select departmentid, max(salary) as salary
from employee
group by departmentid;


# [MYSQL1]
# rank
SELECT D.NAME AS DEPARTMENT,
E.NAME AS EMPLOYEE,
E.SALARY
FROM DEPARTMENT D
INNER JOIN
(
	SELECT DEPARTMENTID,
	NAME,
	SALARY,
	RANK() OVER (PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) SAL_RANK
	FROM EMPLOYEE
) E
ON E.DEPARTMENTID = D.ID
WHERE E.SAL_RANK = 1;

# [PRACTICE2]
SELECT DEPARTMENTID,
MAX(SALARY) MAX_SALARY -- 'highest salary in each of the departments'
FROM EMPLOYEE
GROUP BY DEPARTMENTID;

# [MYSQL2]
# max
SELECT D.NAME AS DEPARTMENT,
E.NAME AS EMPLOYEE,
E.SALARY
FROM EMPLOYEE E
INNER JOIN
DEPARTMENT D
ON E.DEPARTMENTID=D.ID
INNER JOIN
(
    SELECT DEPARTMENTID,
    MAX(SALARY) MAX_SALARY -- 'highest salary in each of the departments'
    FROM EMPLOYEE
    GROUP BY DEPARTMENTID
) M
ON E.SALARY= M.MAX_SALARY
AND E.DEPARTMENTID=M.DEPARTMENTID; -- 조심! 다른 부서에서 똑같은 최대 연봉의 값을 갖을 수 있으므로, 부서에 대한 조건 추가 필수!