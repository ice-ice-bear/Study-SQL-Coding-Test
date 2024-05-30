/*
https://leetcode.com/problems/second-highest-salary/

Table: Employee
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
id는 이 테이블의 기본 키 열입니다.
이 테이블의 각 행에는 직원의 급여에 대한 정보가 포함되어 있습니다.


Find the second highest salary from the Employee table.
If there is no second highest salary, return null.
Employee 테이블에서 두 번째로 높은 급여를 찾습니다.
두 번째로 높은 급여가 없으면 null을 반환합니다.


Example 1:
Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

Example 2:
Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE (ID INT, SALARY INT);
INSERT INTO
	EMPLOYEE (ID, SALARY)
VALUES
	('1', '100')
	,('2', '100')
	,('3', '200')
	,('4', '300')
	,('5', '300');
    
-- output: null case
INSERT INTO
	EMPLOYEE (ID, SALARY)
VALUES
	('1', '100');
SELECT * FROM EMPLOYEE;

#[my practice]
select max(salary) as SecondHighestSalary 
#집계함수를 활용하여 null 값을 출력한다 ifnull이나 nullif를 활용할 경우 아에 값이 없어서 처리가 안된다
from
(select *,
dense_rank() over(order by salary desc) as salary_rank
from employee) sr
where salary_rank = 2;

# [MYSQL1]
# not in
# 'second largest': 이기 때문에 가능
SELECT MAX(SALARY) AS SECONDHIGHESTSALARY -- output null case도 해결	
FROM EMPLOYEE
WHERE SALARY NOT IN
(	
	SELECT MAX(SALAY)			
	FROM EMPLOYEE
);

# [PRACTICE2]
SELECT ID,
SALARY,
RANK() OVER (ORDER BY SALARY DESC) RK, -- rank 사용 불가
DENSE_RANK() OVER (ORDER BY SALARY DESC) DRK
FROM EMPLOYEE;

# [PRACTICE2]
SELECT SALARY SecondHighestSalary -- output null case: 결과가 없음
FROM
(
	SELECT ID,
	SALARY,
	DENSE_RANK() OVER (ORDER BY SALARY DESC) DRK
	FROM EMPLOYEE
) A
WHERE DRK = 2;

# [MYSQL2]
# dense_rank
SELECT MAX(SALARY) AS SecondHighestSalary -- output null case 해결 (max, min, avg 등 어떠한 집계함수든 상관 없음)
FROM
(
	SELECT ID,
	SALARY,
	DENSE_RANK() OVER (ORDER BY SALARY DESC) DRK
	FROM EMPLOYEE
) A
WHERE DRK = 2; -- second highest