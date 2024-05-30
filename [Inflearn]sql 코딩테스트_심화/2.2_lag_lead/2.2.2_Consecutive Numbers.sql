/*
https://leetcode.com/problems/consecutive-numbers/

Table: Logs
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column.
id는 이 테이블의 기본 키입니다.
id는 자동 증가 열입니다.


Write an SQL query to find all numbers that appear at least three times consecutively.
Return the result table in any order.
적어도 세 번 이상 연속해서 나타나는 모든 숫자를 찾는 SQL 쿼리를 작성하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
설명: 1은 최소 3번 이상 연속해서 나타나는 유일한 숫자입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE LOGS;
CREATE TABLE LOGS (ID INT, NUM INT);
INSERT INTO
	LOGS (ID, NUM)
VALUES
('1', '1')
,('2', '1')
,('4', '1')
,('5', '1')
,('6', '2')
,('7', '1');
SELECT * FROM LOGS;

#[my practice]
select distinct num as ConsecutiveNums
from (select id, id +1 as id1, 
lead(id,1) over(order by id) as id1_step,
id +2 as id2,
lead(id,2) over(order by id) as id2_step,
num,
lead(num,1) over(order by id) as num1,
lead(num,2) over(order by id) as num2
from logs
order by id asc) steps
where id1 = id1_step and id2 = id2_step and num = num1 and num1 = num2;

# [my practice - clean code]
SELECT distinct 
    i1.num as ConsecutiveNums 
FROM 
    logs i1,
    logs i2,
    logs i3
WHERE 
    i1.id=i2.id+1 AND 
    i2.id=i3.id+1 AND 
    i1.num=i2.num AND 
    i2.num=i3.num;
    
# [PRACTICE]
SELECT NUM,
LAG(NUM) OVER (ORDER BY ID) AS PREV_NUM,
LEAD(NUM) OVER (ORDER BY ID) AS POST_NUM
FROM LOGS;
    
# [MYSQL]
SELECT DISTINCT(L.NUM) AS CONSECUTIVENUMS
FROM
(
	SELECT NUM,
    LAG(NUM) OVER (ORDER BY ID) AS PREV_NUM,
	LEAD(NUM) OVER (ORDER BY ID) AS POST_NUM
	FROM LOGS
) L
WHERE L.PREV_NUM=L.NUM
AND L.NUM=L.POST_NUM;
