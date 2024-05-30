/*
https://leetcode.com/problems/managers-with-at-least-5-direct-reports/

Table: Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
id는 이 테이블의 기본 키 열입니다.
이 테이블의 각 행은 직원의 이름, 부서, 관리자의 ID를 나타냅니다.
ManagerId가 null이면 직원에게 관리자가 없는 것입니다.
어떤 직원도 자신의 관리자가 될 수 없습니다.


Find the managers with at least five direct reports.
Return the result table in any order.
직속 부하 직원이 5명 이상인 관리자를 찾습니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE (ID INT, NAME VARCHAR(255), DEPARTMENT VARCHAR(255), MANAGERID INT);
INSERT INTO
	EMPLOYEE (ID, NAME, DEPARTMENT, MANAGERID)
VALUES
('101', 'JOHN', 'A', NULL)
,('102', 'DAN', 'A', '101')
,('103', 'JAMES', 'A', '101')
,('104', 'AMY', 'A', '101')
,('105', 'ANNE', 'A', '101')
,('106', 'RON', 'B', '101');
SELECT * FROM EMPLOYEE;

# [my practice]
select name
from employee
where id in(
select managerid
from employee
group by managerid
having count(managerid) >= 5);

# [PRACTICE]
SELECT MANAGERID
FROM EMPLOYEE
GROUP BY MANAGERID
HAVING COUNT(MANAGERID) >= 5;

# [MYSQL]
SELECT E.NAME
FROM EMPLOYEE E
INNER JOIN
(
	SELECT MANAGERID
	FROM EMPLOYEE E
	GROUP BY MANAGERID
	HAVING COUNT(MANAGERID) >= 5
) T
ON T.MANAGERID = E.ID;

