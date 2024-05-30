/*
https://leetcode.com/problems/the-latest-login-in-2020 

Table: Logins
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
(user_id, time_stamp) is the primary key for this table.
Each row contains information about the login time for the user with ID user_id.
(user_id, time_stamp)는 이 테이블의 기본 키입니다.
각 행에는 ID가 user_id인 사용자의 로그인 시간에 대한 정보가 포함되어 있습니다.


Write an SQL query to report the latest login for all users in the year 2020.
Do not include the users who did not login in 2020.
Return the result table in any order.
2020년 모든 사용자의 최신 로그인을 보고하는 SQL 쿼리를 작성합니다.
2020년에 로그인하지 않은 사용자는 포함하지 않습니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Logins table:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 6       | 2020-06-30 15:06:07 |
| 6       | 2021-04-21 14:06:06 |
| 6       | 2019-03-07 00:18:15 |
| 8       | 2020-02-01 05:10:53 |
| 8       | 2020-12-30 00:46:50 |
| 2       | 2020-01-16 02:49:50 |
| 2       | 2019-08-25 07:59:08 |
| 14      | 2019-07-14 09:00:00 |
| 14      | 2021-01-06 11:59:59 |
+---------+---------------------+
Output: 
+---------+---------------------+
| user_id | last_stamp          |
+---------+---------------------+
| 6       | 2020-06-30 15:06:07 |
| 8       | 2020-12-30 00:46:50 |
| 2       | 2020-01-16 02:49:50 |
+---------+---------------------+
Explanation: 
User 6 logged into their account 3 times but only once in 2020, so we include this login in the result table.
User 8 logged into their account 2 times in 2020, once in February and once in December. We include only the latest one (December) in the result table.
User 2 logged into their account 2 times but only once in 2020, so we include this login in the result table.
User 14 did not login in 2020, so we do not include them in the result table.
설명:
사용자 6은 자신의 계정에 3번 로그인했지만 2020년에는 한 번만 로그인했기 때문에 이 로그인을 결과 테이블에 포함합니다.
사용자 8은 2020년에 2번, 2월에 한 번, 12월에 한 번 자신의 계정에 로그인했습니다. 결과 테이블에는 최신 항목(12월)만 포함됩니다.
사용자 2는 자신의 계정에 2번 로그인했지만 2020년에는 한 번만 로그인했기 때문에 이 로그인을 결과 테이블에 포함합니다.
사용자 14는 2020년에는 로그인하지 않았으므로 결과표에 포함하지 않습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Logins;
CREATE TABLE Logins (user_id int, time_stamp datetime);
INSERT INTO
	Logins (user_id, time_stamp)
VALUES
('6', '2020-06-30 15:06:07')
,('6', '2021-04-21 14:06:06')
,('6', '2019-03-07 00:18:15')
,('8', '2020-02-01 05:10:53')
,('8', '2020-12-30 00:46:50')
,('2', '2020-01-16 02:49:50')
,('2', '2019-08-25 07:59:08')
,('14', '2019-07-14 09:00:00')
,('14', '2021-01-06 11:59:59');
SELECT * FROM Logins;

# [KEY]
# 등호 조심하기

#[my practice]
select user_id, max(time_stamp) as last_stamp
from logins
where time_stamp between '2020-01-01 00:00:00' and '2020-12-31 23:59:59'
group by user_id;

#[anoter solution]
select user_id, max(time_stamp) 'last_stamp'
from logins
where time_stamp like '2020%'
group by user_id ;

# [PRACTICE]
select timestamp('2020-12-31');

# [WRONG - 2020/12/31 7:00 같은 케이스는 미포함]
select *
from Logins
where '2020-01-01' <= time_stamp
and time_stamp <= '2020-12-31';


# [MYSQL1]
select user_id,
max(time_stamp) as last_stamp
from Logins
where '2020-01-01' <= time_stamp
and time_stamp < '2021-01-01'
group by user_id;

# [MYSQL2]
select user_id,
max(time_stamp) as last_stamp
from Logins
where time_stamp between '2020-01-01 00:00:00' and '2020-12-31 23:59:59'
group by user_id;

# [MYSQL3]
# 하지만 권장하지는 않음
# 인프런 질문란 참고: https://www.inflearn.com/questions/1212290
select user_id,
max(time_stamp) as last_stamp
from Logins
where year(time_stamp) = 2020
group by user_id;