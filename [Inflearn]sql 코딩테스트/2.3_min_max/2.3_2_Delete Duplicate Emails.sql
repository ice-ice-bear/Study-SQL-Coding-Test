/*
https://leetcode.com/problems/delete-duplicate-emails/ 

Table: Person
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
id는 이 테이블의 기본 키 열입니다.
이 테이블의 각 행에는 이메일이 포함되어 있습니다. 이메일에는 대문자가 포함되지 않습니다.


Write an SQL query to delete all the duplicate emails, keeping only one unique email with the smallest id.
가장 작은 ID를 가진 하나의 고유 이메일만 유지하면서 모든 중복 이메일을 삭제하는 SQL 쿼리를 작성하세요.


Note that you are supposed to write a DELETE statement and not a SELECT one.
After running your script, the answer shown is the Person table.
The driver will first compile and run your piece of code and then show the Person table.
The final order of the Person table does not matter.
SELECT 문이 아닌 DELETE 문을 작성해야 한다는 점에 유의하세요.
스크립트를 실행한 후 표시되는 응답은 Person 테이블입니다.
드라이버는 먼저 코드를 컴파일하고 실행한 다음 Person 테이블을 표시합니다.
Person 테이블의 최종 순서는 중요하지 않습니다.


Example:
Input: 
Person table:
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Output: 
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.
설명: john@example.com이 두 번 반복됩니다. 가장 작은 Id = 1인 행을 유지합니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE PERSON;
CREATE TABLE PERSON (ID INT, EMAIL VARCHAR(255));
INSERT INTO
	PERSON (ID, EMAIL)
VALUES
	('1', 'JOHN@EXAMPLE.COM')
	,('2', 'BOB@EXAMPLE.COM')
	,('3', 'JOHN@EXAMPLE.COM');
SELECT * FROM PERSON;

#[my practice]
select min(ID), Email
from person
group by Email;

# [WRONG]
# 'Error Code: 1093. You can't specify target table 'PERSON' for update in FROM clause
# => 내 테이블을 직접적으로 참조함과 동시에 지우려고 하니까 에러가 남
# => 그래서 별도로 임시 테이블 만든 후에, 지워야 한다 (그래서 아래 정답 쿼리 중 A 테이블을 만들었다)
DELETE FROM PERSON
WHERE ID NOT IN
(
	SELECT MIN(ID) AS ID
	FROM PERSON
	GROUP BY EMAIL
);

# [MYSQL]
DELETE FROM PERSON
WHERE ID NOT IN
(
	SELECT ID
	FROM
    (
		SELECT MIN(P.ID) ID
		FROM PERSON P
		GROUP BY P.EMAIL
	) A
);