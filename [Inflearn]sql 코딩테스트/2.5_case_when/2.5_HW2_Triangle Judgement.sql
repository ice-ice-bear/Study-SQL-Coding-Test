/*
https://leetcode.com/problems/triangle-judgement/ 

Table: Triangle
+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
(x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
(x, y, z)는 이 테이블의 기본 키 열입니다.
이 테이블의 각 행에는 세 개의 선분 길이가 포함되어 있습니다.


Write an SQL query to report for every three line segments whether they can form a triangle.
Return the result table in any order.
세 개의 선분마다 삼각형을 형성할 수 있는지 보고하는 SQL 쿼리를 작성하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Output: 
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE TRIANGLE;
CREATE TABLE TRIANGLE (X INT, Y INT, Z INT);
INSERT INTO
	 TRIANGLE (X, Y, Z)
VALUES
('13', '15', '30')
,('10', '20', '15');
SELECT * FROM TRIANGLE;

# [my practice]
# 가장 큰 면보다 두면의 함이 커야함
# 정삼각형의 경우 모든 면의 길이가 같음
select x, y, z,
(
case when x >= y and x >= z and y + z > x then 'Yes'
when y >= x and y >= z and x + z > y then 'Yes'
when z >= x and z >= y and x + y > z then 'Yes'
else 'No' 
end
) as triangle
from triangle;


# [MYSQL]
SELECT x,
y,
z,
CASE WHEN x+y <= z THEN 'No'
    WHEN y+z <= x THEN 'No' 
    WHEN z+x <= y THEN 'No' 
    ELSE 'Yes' END AS triangle
FROM triangle;

