/*
Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
(project_id, Employee_id)는 이 테이블의 기본 키입니다.
employee_id는 Employee 테이블의 외래 키입니다.


Table: Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
employee_id는 이 테이블의 기본 키입니다.


Write an SQL query that reports the most experienced employees in each project. 
In case of a tie, report all employees with the maximum number of experience years.
각 프로젝트에서 가장 경험이 풍부한 직원을 보고하는 SQL 쿼리를 작성합니다.
동점인 경우, 최대 경력 연수를 가진 모든 직원을 보고하십시오.


Example:
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output: 
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Explanation:
Both employees with id 1 and 3 have the most experience among the employees of the first project. 
For the second project, the employee with id 1 has the most experience.
설명:
ID 1과 3의 두 직원 모두 첫 번째 프로젝트의 직원 중 가장 많은 경험을 가지고 있습니다.
두 번째 프로젝트의 경우 ID가 1인 직원이 가장 많은 경험을 가지고 있습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE PROJECT;
CREATE TABLE PROJECT (PROJECT_ID INT, EMPLOYEE_ID INT);
INSERT INTO
	PROJECT (PROJECT_ID, EMPLOYEE_ID)
VALUES
('1', '1')
,('1', '2')
,('1', '3')
,('2', '1')
,('2', '4');
SELECT * FROM PROJECT;

# [SETTING]
USE PRACTICE;
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE (EMPLOYEE_ID INT, NAME VARCHAR(255), EXPERIENCE_YEARS INT);
INSERT INTO
	EMPLOYEE (EMPLOYEE_ID, NAME, EXPERIENCE_YEARS)
VALUES
('1', 'KHALED', '3')
,('2', 'ALI', '2')
,('3', 'JOHN', '3')
,('4', 'DOE', '2');
SELECT * FROM EMPLOYEE;

#[my practice]
select project_id, employee_id
from (select p.project_id, p.employee_id, 
rank() over(partition by project_id order by experience_years desc) as experience
from project p inner join employee e
on p.employee_id = e.employee_id) exp
where experience = 1;

# [PRACTICE]
SELECT P.PROJECT_ID,
P.EMPLOYEE_ID,
E.EXPERIENCE_YEARS,
RANK() OVER (PARTITION BY P.PROJECT_ID ORDER BY E.EXPERIENCE_YEARS DESC) RNK_YEARS
FROM PROJECT P
INNER JOIN EMPLOYEE E
ON P.EMPLOYEE_ID = E.EMPLOYEE_ID;
    
# [MYSQL]
SELECT PROJECT_ID,
EMPLOYEE_ID
FROM 
(
	SELECT P.PROJECT_ID,
	P.EMPLOYEE_ID,
	E.EXPERIENCE_YEARS,
	RANK() OVER (PARTITION BY P.PROJECT_ID ORDER BY E.EXPERIENCE_YEARS DESC) RNK_YEARS
	FROM PROJECT P
    INNER JOIN EMPLOYEE E
	ON P.EMPLOYEE_ID = E.EMPLOYEE_ID
) A
WHERE RNK_YEARS = 1; -- limit 사용 불가 (강의 3.5에서 다룰 예정), rank 사용 필요: 'In case of a tie, report all employees with the maximum number of experience years'