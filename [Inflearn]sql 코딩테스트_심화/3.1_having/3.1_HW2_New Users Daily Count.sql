/*
Table: Traffic
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| activity      | enum    |
| activity_date | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
이 테이블에는 기본 키가 없습니다. 중복된 행이 있을 수 있습니다.
활동 열은 ('login', 'logout', 'jobs', 'groups', 'homepage')의 ENUM 유형입니다.


Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. 
Assume today is 2019-06-30.
오늘부터 최대 90일 이내의 모든 날짜에 대해, 해당 날짜에 처음으로 로그인한 사용자 수를 보고하는 SQL 쿼리를 작성하세요.
오늘이 2019-06-30이라고 가정합니다.


Example:
Traffic table:
+---------+----------+---------------+
| user_id | activity | activity_date | 
+---------+----------+---------------+
| 1       | login    | 2019-05-01    |
| 1       | homepage | 2019-05-01    |
| 1       | logout   | 2019-05-01    |
| 2       | login    | 2019-06-21    |
| 2       | logout   | 2019-06-21    |
| 3       | login    | 2019-01-01    |
| 3       | jobs     | 2019-01-01    |
| 3       | logout   | 2019-01-01    |
| 4       | login    | 2019-06-21    |
| 4       | groups   | 2019-06-21    |
| 4       | logout   | 2019-06-21    |
| 5       | login    | 2019-03-01    |
| 5       | logout   | 2019-03-01    |
| 5       | login    | 2019-06-21    |
| 5       | logout   | 2019-06-21    |
+---------+----------+---------------+
Output: 
+------------+-------------+
| login_date | user_count  |
+------------+-------------+
| 2019-05-01 | 1           |
| 2019-06-21 | 2           |
+------------+-------------+
Note that we only care about dates with non zero user count.
The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.
사용자 수가 0이 아닌 날짜에만 관심이 있습니다.
ID 5를 가진 사용자는 2019-03-01에 처음 로그인했으므로 2019-06-21에는 포함되지 않습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE TRAFFIC;
CREATE TABLE TRAFFIC (USER_ID INT, ACTIVITY VARCHAR(255), ACTIVITY_DATE DATE);
INSERT INTO
	TRAFFIC (USER_ID, ACTIVITY, ACTIVITY_DATE)
VALUES
('1', 'LOGIN', '2019-05-01')
,('1', 'HOMEPAGE', '2019-05-01')
,('1', 'LOGOUT', '2019-05-01')
,('2', 'LOGIN', '2019-06-21')
,('2', 'LOGOUT', '2019-06-21')
,('3', 'LOGIN', '2019-01-01')
,('3', 'JOBS', '2019-01-01')
,('3', 'LOGOUT', '2019-01-01')
,('4', 'LOGIN', '2019-06-21')
,('4', 'GROUPS', '2019-06-21')
,('4', 'LOGOUT', '2019-06-21')
,('5', 'LOGIN', '2019-03-01')
,('5', 'LOGOUT', '2019-03-01')
,('5', 'LOGIN', '2019-06-21')
,('5', 'LOGOUT', '2019-06-21');
SELECT * FROM TRAFFIC;

# [my practice] - 잘못된 예
select activity_date, count(activity_date) as user_count
from traffic
where activity = 'login'
and activity_date between date_sub('2019-06-30', interval 90 day) and '2019-06-30'
group by activity_date;

# [my practice] - 정답
select activity_date, count(activity_date) as user_count
from
(select *
from traffic
where activity = 'login'
and activity_date between date_sub('2019-06-30', interval 90 day) and '2019-06-30') between_date
left outer join
(select user_id , min(activity_date) as first_login
from traffic
where activity = 'login'
group by user_id) first_date
on between_date.user_id = first_date.user_id
where activity_date = first_login
group by between_date.activity_date;

# [PRACTICE]
SELECT USER_ID,
MIN(ACTIVITY_DATE) -- 'logged in for the first time on that date.'
FROM TRAFFIC
WHERE ACTIVITY = 'LOGIN' -- 'users that logged in'
GROUP BY USER_ID
HAVING MIN(ACTIVITY_DATE) > DATE_SUB('2019-06-30', INTERVAL 90 DAY); -- 'date within at most 90 days from today'

# [MYSQL]
SELECT ACTIVITY_DATE AS LOGIN_DATE, 
COUNT(USER_ID) AS USER_COUNT -- 'the number of users that logged in for the first time on that date'
FROM 
(
	SELECT USER_ID,
	MIN(ACTIVITY_DATE) ACTIVITY_DATE
	FROM TRAFFIC
	WHERE ACTIVITY = 'LOGIN'
	GROUP BY USER_ID
	HAVING MIN(ACTIVITY_DATE) > DATE_SUB('2019-06-30', INTERVAL 90 DAY)
) T
GROUP BY ACTIVITY_DATE;
