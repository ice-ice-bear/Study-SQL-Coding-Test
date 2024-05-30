/*
https://leetcode.com/problems/exchange-seats/

Table: Seat
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name and the ID of a student.
id is a continuous increment.
id는 이 테이블의 기본 키 열입니다.
이 테이블의 각 행은 학생의 이름과 ID를 나타냅니다.
id는 연속적으로 증가합니다.


Write an SQL query to swap the seat id of every two consecutive students.
If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.
연속된 두 학생마다 좌석 ID를 바꾸는 SQL 쿼리를 작성하세요.
학생 수가 홀수인 경우 마지막 학생의 ID는 교환되지 않습니다.
id를 기준으로 오름차순으로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.
설명:
학생 수가 홀수인 경우 마지막 자리를 변경할 필요가 없습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE SEAT;
CREATE TABLE SEAT(ID INT, STUDENT VARCHAR(255));
INSERT INTO
	SEAT (ID, STUDENT)
VALUES
('1', 'ABBOT')
,('2', 'DORIS')
,('3', 'EMERSON')
,('4', 'GREEN')
,('5', 'JEAMES');
SELECT * FROM SEAT;

# [my practice case when + lag]
select new_s.id, 
case when new_s.student is null then s.student
	when new_s.student is not null then new_s.student 
    end as student
from seat s
inner join
(select id,
case when mod(id,2) =1 then lead(student) over(order by id) 
	when mod(id,2) = 0 then lag(student) over(order by id)
    end as student
from seat) new_s
on s.id = new_s.id;  

# [my practice, case when + lag + ifnull]
select new_s.id, ifnull(new_s.student, s.student) as student
from seat s
inner join
(select id,
case when mod(id,2) =1 then lead(student) over(order by id) 
	when mod(id,2) = 0 then lag(student) over(order by id)
    end as student
from seat) new_s
on s.id = new_s.id;

# [PRACTICE1]
SELECT COUNT(ID) AS CNT
FROM SEAT;

# [PRACTICE1]
SELECT ID AS ORIG_ID, -- ID와 비교해보기
(CASE 
	  WHEN MOD(ID,2)=0 -- 짝수
	  THEN ID-1
      WHEN MOD(ID,2)=1 AND ID != C.CNT -- 마지막 row가 아닌 홀수
	  THEN ID+1
      WHEN MOD(ID,2)=1 AND ID=C.CNT -- 홀수 and 마지막 row
      THEN ID
      END) AS ID,
STUDENT
FROM SEAT S
INNER JOIN
(
	SELECT COUNT(ID) AS CNT
	FROM SEAT
) C
ORDER BY ID;

# [MYSQL1]
# case when
# 홀수 and 마지막 row만 신경쓰면 된다 (짝수 and 마지막 row는 신경쓸 필요가 없음)
SELECT (CASE 
	  WHEN MOD(ID,2)=0 -- 짝수
	  THEN ID-1
      WHEN MOD(ID,2)=1 AND ID != C.CNT # 마지막 row가 아닌 홀수
	  THEN ID+1
      WHEN MOD(ID,2)=1 AND ID=C.CNT -- 홀수 and 마지막 row
      THEN ID
	  END) AS ID,
STUDENT
FROM SEAT S
INNER JOIN
(
	SELECT COUNT(ID) AS CNT
	FROM SEAT
) C
ORDER BY ID;

# [PRACTICE2]
SELECT ID, 
MOD(ID,2) M,
STUDENT,
LAG (STUDENT) OVER (ORDER BY ID) PRE_S,
LEAD(STUDENT) OVER (ORDER BY ID) POST_S
FROM SEAT
ORDER BY ID;

# [MYSQL2]
# lag, lead
# 홀수 and 마지막 row만 신경쓰면 된다 (짝수 and 마지막 row는 신경쓸 필요가 없음)
SELECT ID, 
IF(M=0, PRE_S, IFNULL(POST_S, STUDENT)) STUDENT
# If 짝수 row이면, 이전 값을 가져온다.
# Else 홀수 row이면, 다음 값을 가져온다. (ifnull: 마지막 홀수 row 처리를 위해)
FROM 
(
	SELECT ID, 
	MOD(ID,2) M,
	STUDENT,
	LAG (STUDENT) OVER (ORDER BY ID) PRE_S,
	LEAD(STUDENT) OVER (ORDER BY ID) POST_S
	FROM SEAT
) A;
