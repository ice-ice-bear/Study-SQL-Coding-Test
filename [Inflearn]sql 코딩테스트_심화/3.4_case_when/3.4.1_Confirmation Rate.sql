/*
https://leetcode.com/problems/confirmation-rate/

Table: Signups
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the primary key for this table.
Each row contains information about the signup time for the user with ID user_id.
user_id는 이 테이블의 기본 키입니다.
각 행에는 ID가 user_id인 사용자의 가입 시간에 대한 정보가 포함되어 있습니다.


Table: Confirmations
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key for this table.
user_id is a foreign key with a reference to the Signups table.
action is an ENUM of the type ('confirmed', 'timeout').
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
(user_id, time_stamp)는 이 테이블의 기본 키입니다.
user_id는 Signups 테이블을 참조하는 외래 키입니다.
action은 ('confirmed', 'timeout') 유형의 ENUM입니다.
이 테이블의 각 행은 ID가 user_id인 사용자가 time_stamp에 확인 메시지를 요청했으며, 해당 확인 메시지가 확인('confirmed')되었거나 확인 없이 만료('timeout')되었음을 나타냅니다.


The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. 
The confirmation rate of a user that did not request any confirmation messages is 0.
Round the confirmation rate to two decimal places.
사용자의 확인 비율은 'confirmed' 메시지 수를 요청한 전체 확인 메시지 수로 나눈 값입니다.
확인 메시지를 요청하지 않은 사용자의 확인 비율은 0입니다.
확인률을 소수점 이하 두 자리로 반올림합니다.


Write an SQL query to find the confirmation rate of each user.
Return the result table in any order.
각 사용자의 확인률을 알아보는 SQL 쿼리를 작성해 보세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Signups table:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |
+---------+---------------------+
Confirmations table:
+---------+---------------------+-----------+
| user_id | time_stamp          | action    |
+---------+---------------------+-----------+
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-07-14 14:00:00 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 12:58:28 | confirmed |
| 7       | 2021-06-14 13:59:27 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-02-28 23:59:59 | timeout   |
+---------+---------------------+-----------+
Output: 
+---------+-------------------+
| user_id | confirmation_rate |
+---------+-------------------+
| 6       | 0.00              |
| 3       | 0.00              |
| 7       | 1.00              |
| 2       | 0.50              |
+---------+-------------------+
Explanation: 
User 6 did not request any confirmation messages. The confirmation rate is 0.
User 3 made 2 requests and both timed out. The confirmation rate is 0.
User 7 made 3 requests and all were confirmed. The confirmation rate is 1.
User 2 made 2 requests where one was confirmed and the other timed out. The confirmation rate is 1 / 2 = 0.5.
설명:
사용자 6은 확인 메시지를 요청하지 않았습니다. 확인률은 0입니다.
사용자 3이 2개의 요청을 했으나 둘 다 시간 초과되었습니다. 확인률은 0입니다.
사용자 7이 3개의 요청을 했고 모두 확인되었습니다. 확인률은 1입니다.
사용자 2는 2개의 요청을 했는데 하나는 확인되었고 다른 하나는 시간 초과되었습니다. 확인률은 1/2 = 0.5입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Signups;
CREATE TABLE Signups (user_id int, time_stamp datetime);
INSERT INTO
	Signups (user_id, time_stamp)
VALUES
('3', '2020-03-21 10:16:13')
,('7', '2020-01-04 13:57:59')
,('2', '2020-07-29 23:09:44')
,('6', '2020-12-09 10:39:37');
SELECT * FROM Signups;

# [SETTING]
USE PRACTICE;
DROP TABLE Confirmations;
CREATE TABLE Confirmations (user_id int, time_stamp datetime, action ENUM('confirmed','timeout'));
INSERT INTO
	Confirmations (user_id, time_stamp, action)
VALUES
('3', '2021-01-06 03:30:46', 'timeout')
,('3', '2021-07-14 14:00:00', 'timeout')
,('7', '2021-06-12 11:57:29', 'confirmed')
,('7', '2021-06-13 12:58:28', 'confirmed')
,('7', '2021-06-14 13:59:27', 'confirmed')
,('2', '2021-01-22 00:00:00', 'confirmed')
,('2', '2021-02-28 23:59:59', 'timeout');
SELECT * FROM Confirmations;

select s.user_id, ifnull(count_ratio, 0.0) as confirmation_rate
from 
signups s
left outer join
(select user_id,
count(action) as total_count,
count(case when action = 'timeout' then 1 end) as timeout_count,
count(case when action = 'confirmed' then 1 end) as confirmed_count,
round(count(case when action = 'confirmed' then 1 end) / count(action),2) as count_ratio
from confirmations
group by user_id) counts
on s.user_id = counts.user_id;

# [PRACTICE]
select user_id,
count(*) tot_cnt,
count(case when action='confirmed' then 1 end) cnt, -- else: default null, count(null)=0
count(case when action='confirmed' then 1 else 0 end) wrong_cnt, -- else: 0, count(0)=1
round(count(case when action='confirmed' then 1 end)/count(*), 2) as confirmation_rate
from Confirmations
group by user_id;
  
# [MYSQL]
select s.user_id,
ifnull(confirmation_rate, 0) as confirmation_rate -- 'The confirmation rate of a user that did not request any confirmation messages is 0'
from Signups s
left outer join
(
  select user_id,
  round(count(case when action='confirmed' then 1 end)/count(*), 2) as confirmation_rate 
  from Confirmations
  group by user_id
) c
on s.user_id=c.user_id;