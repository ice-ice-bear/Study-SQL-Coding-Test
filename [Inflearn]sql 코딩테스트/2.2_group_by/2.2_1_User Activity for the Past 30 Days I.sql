/*
https://leetcode.com/problems/user-activity-for-the-past-30-days-i/ 

Table: Activity
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The activity_type column is an ENUM of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
이 테이블에는 기본 키가 없습니다. 중복된 행이 있을 수 있습니다.
activity_type 열은 ('open_session', 'end_session', 'scroll_down', 'send_message') 유형의 ENUM입니다.
표에는 소셜 미디어 웹사이트의 사용자 활동이 나와 있습니다.
각 세션은 정확히 한 명의 사용자에게 속합니다.


Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively.
A user was active on someday if they made at least one activity on that day.
Return the result table in any order.
2019년 7월 27일까지 30일 동안의 일일 활성 사용자 수를 찾는 SQL 쿼리를 작성하세요.
사용자가 해당 날짜에 하나 이상의 활동을 수행한 경우 해당 날짜에 활성 상태 입니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+
Output: 
+------------+--------------+ 
| day        | active_users |
+------------+--------------+ 
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
+------------+--------------+ 
Explanation: Note that we do not care about days with zero active users.
설명: 활성 사용자가 없는 날짜는 고려하지 않습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE ACTIVITY;
CREATE TABLE ACTIVITY (USER_ID INT, SESSION_ID INT, ACTIVITY_DATE DATE, ACTIVITY_TYPE VARCHAR(255));
INSERT INTO
	ACTIVITY (USER_ID, SESSION_ID, ACTIVITY_DATE, ACTIVITY_TYPE)
VALUES
	('1', '1', '2019-07-20', 'OPEN_SESSION')
	,('1', '1', '2019-07-20', 'SCROLL_DOWN')
	,('1', '1', '2019-07-20', 'END_SESSION')
	,('2', '4', '2019-07-20', 'OPEN_SESSION')
	,('2', '4', '2019-07-21', 'SEND_MESSAGE')
	,('2', '4', '2019-07-21', 'END_SESSION')
	,('3', '2', '2019-07-21', 'OPEN_SESSION')
	,('3', '2', '2019-07-21', 'SEND_MESSAGE')
	,('3', '2', '2019-07-21', 'END_SESSION')
	,('4', '3', '2019-06-25', 'OPEN_SESSION')
	,('4', '3', '2019-06-25', 'END_SESSION');
SELECT * FROM ACTIVITY;	

#[my practice]
select activity_date as day, count(distinct user_id) as active_users
from activity
group by activity_date
having activity_date 
between date_sub('2019-07-27', interval 29 day) and '2019-07-27'; # 이전 일자의 경우 date_sub를 이후 일자의 경우에는 date add를 사용하면 된다


# [KEY]
# DATE_SUB 함수, DATE_ADD 함수
# 'period of 30 days': 한 쪽은 등호 있고, 한 쪽은 등호가 없어야지 기간이 30일이 된다.

# [WRONG DATE]
SELECT '2019-07-27' - 30 AS col1,
'2019-07-27' AS col2;

# [RIGHT DATE]
SELECT DATE_SUB('2019-07-27', INTERVAL 30 DAY) AS col1,
'2019-07-27' AS col2;

# [MYSQL]
SELECT ACTIVITY_DATE AS DAY,
COUNT(DISTINCT USER_ID) AS ACTIVE_USERS
FROM ACTIVITY
WHERE DATE_SUB('2019-07-27', INTERVAL 30 DAY) < ACTIVITY_DATE
AND ACTIVITY_DATE <= '2019-07-27'
GROUP BY ACTIVITY_DATE;