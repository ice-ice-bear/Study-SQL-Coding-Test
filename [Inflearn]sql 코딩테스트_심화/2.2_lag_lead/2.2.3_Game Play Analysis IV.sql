/*
https://leetcode.com/problems/game-play-analysis-iv/

Table: Activity
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
(player_id, event_date)는 이 테이블의 기본 키입니다.
이 표는 일부 게임의 플레이어 활동을 보여줍니다.
각 행은 특정 장치를 통해 로그인 한 후에, 로그아웃하기 전까지 플레이한 게임 횟수(0도 가능)의 기록입니다.


Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.
In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
처음 로그인한 날 다음 날 다시 로그인한 플레이어의 비율을 소수점 이하 2자리로 반올림하여 보고하는 SQL 쿼리를 작성하세요.
즉, 첫 번째 로그인 날짜부터 최소 2일 연속으로 로그인한 플레이어 수를 계산한 다음 해당 숫자를 전체 플레이어 수로 나누어야 합니다.


Example:
Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
설명:
ID가 1인 플레이어만 로그인한 첫날 이후에 다시 로그인했으므로 답은 1/3 = 0.33입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE ACTIVITY;
CREATE TABLE ACTIVITY (PLAYER_ID INT, DEVICE_ID INT, EVENT_DATE DATE, GAMES_PLAYED INT);
INSERT INTO
	ACTIVITY (PLAYER_ID, DEVICE_ID, EVENT_DATE, GAMES_PLAYED)
VALUES
('1', '2', '2016-03-01', '5')
,('1', '2', '2016-03-02', '6')
,('2', '3', '2017-06-25', '1')
,('3', '1', '2016-03-02', '0')
,('3', '4', '2018-07-03', '5')
,('1', '2', '2023-01-01', '5') -- rank 필요한 이유
,('1', '2', '2023-01-02', '6') -- rank 필요한 이유
,('2', '2', '2023-05-01', '5') -- rank 필요한 이유
,('2', '2', '2023-05-02', '6') -- rank 필요한 이유
;
SELECT * FROM ACTIVITY;

-- DATE_SUB(EVENT_DATE, INTERVAL 1 DAY) = PREV_DATE

# [my practice] - error case 최초 로그인 일자 반영 안됨
select round(count(distinct player_id) / (select count(distinct player_id) from activity), 2) as fraction 
from (select player_id, event_date,
date_sub(event_date, interval 1 day) as pre_date,
lag(event_date) over(partition by player_id order by event_date) as pre_log_date
from activity) play_date
where pre_date = pre_log_date;

# [my practice] - 최초 로그인 일자 반영
select round(count(distinct player_id) / (select count(distinct player_id) from activity),2) as fraction
from (
	select player_id, event_date,
    rank() over (partition by player_id order by event_date) as login_num,
	date_add(event_date, interval 1 day) as post_date,
	lead(event_date, 1) over (partition by player_id order by event_date) as post_log_date
	from activity
    ) first_login
    where login_num = 1
    and post_date = post_log_date;
    
# [PRACTICE]
SELECT PLAYER_ID,
LAG(PLAYER_ID) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_ID,
EVENT_DATE,
LAG(EVENT_DATE) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_DATE,
RANK() OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) RNK_DATE
FROM ACTIVITY
ORDER BY PLAYER_ID, EVENT_DATE;

# [WRONG]
# rank 포함 안한 쿼리
SELECT *
FROM
(
	SELECT PLAYER_ID,
	LAG(PLAYER_ID) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_ID,
	EVENT_DATE,
	LAG(EVENT_DATE) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_DATE,
	RANK() OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) RNK_DATE
	FROM ACTIVITY
) A
WHERE DATE_SUB(EVENT_DATE, INTERVAL 1 DAY) = PREV_DATE
AND PLAYER_ID = PREV_ID;

# [PRACTICE]
SELECT *
FROM
(
	SELECT PLAYER_ID,
	LAG(PLAYER_ID) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_ID,
	EVENT_DATE,
	LAG(EVENT_DATE) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_DATE,
	RANK() OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) RNK_DATE
	FROM ACTIVITY
) A
WHERE RNK_DATE=2
AND DATE_SUB(EVENT_DATE, INTERVAL 1 DAY) = PREV_DATE
AND PLAYER_ID = PREV_ID;

# [MYSQL]
SELECT ROUND(
COUNT(PLAYER_ID)/(SELECT COUNT(DISTINCT PLAYER_ID) TOT_CNT FROM ACTIVITY),
2) FRACTION
FROM
(
	SELECT PLAYER_ID,
	EVENT_DATE,
    RANK() OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) RNK_DATE,
	LAG(PLAYER_ID) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_ID,
	LAG(EVENT_DATE) OVER (ORDER BY PLAYER_ID, EVENT_DATE) PREV_DATE
	FROM ACTIVITY
) A
WHERE RNK_DATE=2
AND DATE_SUB(EVENT_DATE, INTERVAL 1 DAY) = PREV_DATE
AND PLAYER_ID = PREV_ID;