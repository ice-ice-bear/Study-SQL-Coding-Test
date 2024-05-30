/*
https://leetcode.com/problems/percentage-of-users-attended-a-contest/ 

Table: Users
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key for this table.
Each row of this table contains the name and the id of a user.
user_id는 이 테이블의 기본 키입니다.
이 테이블의 각 행에는 사용자의 이름과 ID가 포함됩니다.

 
Table: Register
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key for this table.
Each row of this table contains the id of a user and the contest they registered into.
(contest_id, user_id)는 이 테이블의 기본 키입니다.
이 테이블의 각 행에는 사용자의 ID와 사용자가 등록한 콘테스트가 포함되어 있습니다.


Write an SQL query to find the percentage of the users registered in each contest rounded to two decimals.
Return the result table ordered by percentage in descending order.
In case of a tie, order it by contest_id in ascending order.
각 콘테스트에 등록된 사용자의 비율을 소수점 이하 두 자리까지 반올림하여 구하는 SQL 쿼리를 작성하세요.
백분율 기준으로 내림차순으로 정렬된 결과 테이블을 반환합니다.
동점인 경우에는 contest_id순으로 오름차순으로 정렬합니다.


Example:
Input: 
Users table:
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+
Register table:
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
Output: 
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
Explanation: 
All the users registered in contests 208, 209, and 210.
The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%
설명:
모든 사용자는 콘테스트 208, 209, 210에 등록하였습니다.
백분율은 100%이며 답안표에서 contest_id를 기준으로 오름차순으로 정렬됩니다.
Alice와 Alex는 콘테스트 215에 등록했으며 비율은 ((2/3) * 100) = 66.67%입니다.
Bob은 콘테스트 207에 등록했으며 비율은 ((1/3) * 100) = 33.33%입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Users;
CREATE TABLE Users (user_id int, user_name varchar(20));
INSERT INTO
	Users (user_id, user_name)
VALUES
('6', 'Alice')
,('2', 'Bob')
,('7', 'Alex');
SELECT * FROM Users;

# [SETTING]
USE PRACTICE;
DROP TABLE Register;
CREATE TABLE Register (contest_id int, user_id int);
INSERT INTO
	Register (contest_id, user_id)
VALUES
('215', '6')
,('209', '2')
,('208', '2')
,('210', '6')
,('208', '6')
,('209', '7')
,('209', '6')
,('215', '7')
,('208', '7')
,('210', '2')
,('207', '2')
,('210', '7');
SELECT * FROM Register;

#[my practice]
select contest_id, round(count(u.user_id)/ (select count(user_id)from users) *100 ,2) as percentage
from users u right outer join register r
on u.user_id = r.user_id
group by contest_id
order by percentage desc, contest_id asc;
 

# [PRACTICE]
select contest_id,
count(user_id) user_cnt
from Register
group by contest_id;

# [PRACTICE]
select count(user_id) tot_cnt
from Users;

# [PRACTICE]
SELECT *
FROM
(
    select contest_id,
    count(user_id) user_cnt
    from Register
    group by contest_id
) a,
(
select count(user_id) tot_cnt
from Users
) b;

# [MYSQL]
select contest_id,
round(user_cnt/tot_cnt*100, 2) percentage
from
(
    select contest_id,
    count(user_id) user_cnt
    from Register
    group by contest_id
) a,
(
select count(user_id) tot_cnt
from Users
) b
order by percentage desc, contest_id;