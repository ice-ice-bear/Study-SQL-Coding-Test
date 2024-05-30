/*
https://leetcode.com/problems/biggest-single-number/ 

Table: MyNumbers
+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
There is no primary key for this table. It may contain duplicates.
Each row of this table contains an integer.
A single number is a number that appeared only once in the MyNumbers table.
이 테이블에는 기본 키가 없습니다. 중복된 내용이 포함되어 있을 수 있습니다.
이 테이블의 각 행에는 정수가 포함되어 있습니다.
단일 숫자는 MyNumbers 테이블에 한 번만 나타나는 숫자입니다.


Write an SQL query to report the largest single number.
If there is no single number, report null.
The query result format is in the following example.
가장 큰 단일 숫자를 보고하는 SQL 쿼리를 작성하세요.
단일 숫자가 없으면 null을 보고합니다.
쿼리 결과 형식은 다음 예와 같습니다.


Example 1:
Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
+-----+
Output: 
+-----+
| num |
+-----+
| 6   |
+-----+
Explanation:
The single numbers are 1, 4, 5, and 6.
Since 6 is the largest single number, we return it.
설명:
단일 숫자는 1, 4, 5, 6입니다.
6은 가장 큰 단일 숫자이므로 이를 반환합니다.


Example 2:
Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 7   |
| 7   |
| 3   |
| 3   |
| 3   |
+-----+
Output: 
+------+
| num  |
+------+
| null |
+------+
Explanation:
There are no single numbers in the input table so we return null.
설명:
입력 테이블에 단일 숫자가 없으므로 null을 반환합니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE MyNumbers;
CREATE TABLE MyNumbers (NUM INT);
INSERT INTO
	MyNumbers (NUM)
VALUES
	('8')
	,('8')
	,('3')
	,('3')
	,('1')
	,('4')
	,('5')
	,('6');
SELECT * FROM MyNumbers;

#[my prectice]
select max(num) as num
from (select *
from mynumbers
group by num
having count(*) = 1) s;

# [WRONG]
SELECT NUM,
MAX(NUM)
FROM MyNumbers
GROUP BY NUM
HAVING COUNT(NUM) = 1;

# [MYSQL]
SELECT MAX(NUM) AS NUM
FROM
(
	SELECT NUM
	FROM MyNumbers
	GROUP BY NUM
	HAVING COUNT(NUM) = 1
) A;
