/*
https://leetcode.com/problems/rising-temperature/ 

Table: Weather
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.
id는 이 테이블의 기본 키입니다.
이 표에는 특정 날짜의 기온에 대한 정보가 포함되어 있습니다.


Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.
이전 날짜(어제)에 비해 기온이 더 높은 모든 날짜의 ID를 찾는 SQL 쿼리를 작성하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
설명:
2015-01-02에는 전날보다 기온이 높아졌습니다(10->25).
2015-01-04년에는 전날보다 기온이 높아졌습니다(20->30).
*/

# [SETTING]
USE PRACTICE;
DROP TABLE WEATHER;
CREATE TABLE WEATHER (ID INT, RECORDDATE DATE, TEMPERATURE INT);
INSERT INTO
	WEATHER (ID, RECORDDATE, TEMPERATURE)
VALUES
('1', '2015-01-01', '10')
,('2', '2015-01-02', '25')
,('3', '2015-01-03', '20')
,('4', '2015-01-04', '30')
,('5', '2015-01-14', '5') # 데이터 추가함
,('6', '2015-01-16', '7'); # 데이터 추가함
SELECT * FROM WEATHER;

# [my practice] 
select id
 from (select id, temperature as temp,
lag(temperature) over(order by recorddate asc) as pre_temp
from weather) fk
where temp > pre_temp;

select id, recorddate as date, 
lag(recorddate) over(order by recorddate asc) as pre_date,
temperature as temp,
lag(temperature) over(order by recorddate asc) as pre_temp
from weather;

# [KEY]
# 'previous'

# [PRACTICE]
SELECT ID,
RECORDDATE RD,
TEMPERATURE T,
LAG(RECORDDATE) OVER (ORDER BY RECORDDATE) PRE_RD, # 1개 row 이전
LAG(TEMPERATURE) OVER (ORDER BY RECORDDATE) PRE_T # 1개 row 이전
FROM WEATHER;
        
# [MYSQL1]
SELECT ID
FROM
(
	SELECT ID,
	RECORDDATE RD,
	TEMPERATURE T,
	LAG(RECORDDATE) OVER (ORDER BY RECORDDATE) PRE_RD, # 1개 row 이전
	LAG(TEMPERATURE) OVER (ORDER BY RECORDDATE) PRE_T # 1개 row 이전
	FROM WEATHER
) A
 WHERE DATE_ADD(PRE_RD, INTERVAL 1 DAY) = RD # 안쓸경우, '2015-01-14', '2015-01-16'에서 예외 상황 발생
 AND PRE_T < T;


# 만약 LAG, LEAD 함수를 지원하지 않는 경우 (ex. 낮은 버전의 SQLLite DB 엔진)
# 참고: https://stackoverflow.com/questions/53630542/alternatives-to-lead-and-lag-in-sqlite

# [PRACTICE]
SELECT ID,
RECORDDATE RD,
TEMPERATURE T,
(
	SELECT T1.RECORDDATE
	FROM WEATHER T1
	WHERE T1.RECORDDATE < A.RECORDDATE # 이전 날짜들 중에서
	ORDER BY T1.RECORDDATE DESC 
	LIMIT 1
) PRE_RD,
(
	SELECT T1.TEMPERATURE
	FROM WEATHER T1
	WHERE T1.RECORDDATE < A.RECORDDATE  # 이전 날짜들 중에서
	ORDER BY T1.RECORDDATE DESC 
	LIMIT 1
) PRE_T
FROM WEATHER A;

# [MYSQL2]
SELECT ID
from
(
	SELECT ID,
	RECORDDATE RD,
	TEMPERATURE T,
	(
		SELECT T1.RECORDDATE
		FROM WEATHER T1
		WHERE T1.RECORDDATE < A.RECORDDATE # 이전 날짜들 중에서
		ORDER BY T1.RECORDDATE DESC 
		LIMIT 1
	) PRE_RD,
	(
		SELECT T1.TEMPERATURE
		FROM WEATHER T1
		WHERE T1.RECORDDATE < A.RECORDDATE # 이전 날짜들 중에서
		ORDER BY T1.RECORDDATE DESC 
		LIMIT 1
	) PRE_T
	FROM WEATHER A
) T
WHERE DATE_ADD(PRE_RD, INTERVAL 1 DAY) = RD # 안쓸경우, '2015-01-14', '2015-01-16'에서 예외 상황 발생
AND PRE_T < T;