/*
https://leetcode.com/problems/rank-scores/

Table: Scores
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
id is the primary key for this table.
Each row of this table contains the score of a game.
Score is a floating point value with two decimal places.
id는 이 테이블의 기본 키입니다.
이 테이블의 각 행에는 게임 점수가 포함되어 있습니다.
점수는 소수점 이하 두 자리의 부동 소수점 값입니다.


Find the rank of the scores.
Return the result table ordered by score in descending order.
점수의 순위를 찾아보세요.
점수 기준으로 내림차순으로 정렬된 결과 테이블을 반환합니다.


The ranking should be calculated according to the following rules:
- The scores should be ranked from the highest to the lowest.
- If there is a tie between two scores, both should have the same ranking.
- After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
순위는 다음 규칙에 따라 계산되어야 합니다.
- 점수는 가장 높은 것부터 가장 낮은 것까지 순위가 매겨져야 합니다.
- 두 점수가 동점인 경우 두 점수 모두 동일한 순위를 가져야 합니다.
- 동점 이후 다음 순위는 다음 연속 정수값이어야 합니다. 즉, 순위 사이에 구멍이 없어야 합니다.


Example:
Input: 
Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
Output: 
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE SCORES;
CREATE TABLE SCORES (ID INT, SCORE DECIMAL(3,2));
INSERT INTO
	SCORES (ID, SCORE)
VALUES
('1', '3.5')
,('2', '3.65')
,('3', '4.0')
,('4', '3.85')
,('5', '4.0')
,('6', '3.65');
SELECT * FROM SCORES;

#[my practice]
select SCORE,
dense_rank() over(order by score desc) as 'RANK'
from scores;

# [MYSQL]
-- rank, row_number 사용 불가, dense_rank 사용 필요: 'After a tie, the next ranking number should be the next consecutive integer value'
SELECT SCORE,
DENSE_RANK() OVER(ORDER BY SCORE DESC) AS `RANK` -- backtick(`)을 이용하여 컬럼 alias
FROM SCORES
ORDER BY SCORE DESC; -- 'The scores should be ranked from the highest to the lowest'