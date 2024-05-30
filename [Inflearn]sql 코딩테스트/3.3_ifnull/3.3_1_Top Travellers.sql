/*
https://leetcode.com/problems/top-travellers/ 

Table: Users
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the user.
id는 이 테이블의 기본 키입니다.
이름은 사용자의 이름입니다.


Table: Rides
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| user_id       | int     |
| distance      | int     |
+---------------+---------+
id is the primary key for this table.
user_id is the id of the user who traveled the distance "distance".
id는 이 테이블의 기본 키입니다.
user_id는 "distance" 거리를 이동한 사용자의 ID입니다.
 
 
Write an SQL query to report the distance traveled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users traveled the same distance, order them by their name in ascending order.
각 사용자가 이동한 거리를 보고하는 SQL 쿼리를 작성합니다.
travelled_distance 기준으로 정렬된 결과 테이블을 내림차순으로 반환하고, 두 명 이상의 사용자가 동일한 거리를 이동한 경우 이름을 기준으로 오름차순으로 정렬합니다.


Example:
Input: 
Users table:
+------+-----------+
| id   | name      |
+------+-----------+
| 1    | Alice     |
| 2    | Bob       |
| 3    | Alex      |
| 4    | Donald    |
| 7    | Lee       |
| 13   | Jonathan  |
| 19   | Elvis     |
+------+-----------+
Rides table:
+------+----------+----------+
| id   | user_id  | distance |
+------+----------+----------+
| 1    | 1        | 120      |
| 2    | 2        | 317      |
| 3    | 3        | 222      |
| 4    | 7        | 100      |
| 5    | 13       | 312      |
| 6    | 19       | 50       |
| 7    | 7        | 120      |
| 8    | 19       | 400      |
| 9    | 7        | 230      |
+------+----------+----------+
Output: 
+----------+--------------------+
| name     | travelled_distance |
+----------+--------------------+
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |
+----------+--------------------+
Explanation: 
Elvis and Lee traveled 450 miles, Elvis is the top traveler as his name is alphabetically smaller than Lee.
Bob, Jonathan, Alex, and Alice have only one ride and we just order them by the total distances of the ride.
Donald did not have any rides, the distance traveled by him is 0.
설명:
Elvis와 Lee는 450마일을 여행했습니다. Elvis는 Lee보다 알파벳순으로 이름이 작기 때문에 최고의 여행자입니다.
Bob, Jonathan, Alex, Alice는 한 번만 이동했으며 총 탑승 거리를 기준으로 순서를 지정합니다.
Donald는 이동하지 않았으므로 그가 이동한 거리는 0입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Users;
CREATE TABLE Users (id int, name varchar(30));
INSERT INTO
	Users (id, name)
VALUES
('1', 'Alice')
,('2', 'Bob')
,('3', 'Alex')
,('4', 'Donald')
,('7', 'Lee')
,('13', 'Jonathan')
,('19', 'Elvis');
SELECT * FROM Users;

# [SETTING]
USE PRACTICE;
DROP TABLE Rides;
CREATE TABLE Rides (id int, user_id int, distance int);
INSERT INTO
	Rides (id, user_id, distance)
VALUES
('1', '1', '120')
,('2', '2', '317')
,('3', '3', '222')
,('4', '7', '100')
,('5', '13', '312')
,('6', '19', '50')
,('7', '7', '120')
,('8', '19', '400')
,('9', '7', '230');
SELECT * FROM Rides;

# [my practice]
select u.name, ifnull(sum(distance), 0) as travelled_distance
from users u left outer join rides r
on u.id = r.user_id
group by name, u.id  # id로도 group by를 해야 동명이인의 경우에도 구분할 수 있다
order by travelled_distance desc, name asc;


# [PRACTICE]
select *
from Users u
left outer join Rides r
on u.id=r.user_id;

# count: ifnull을 사용하지 않으면, count는 0으로 나온다 (말 그대로 개수가 0개 이기 때문에)
# 비교: https://leetcode.com/problems/students-and-examinations/
select max(u.name) name,
count(r.distance) as test1, # 결과: [Donald] count=0
count(u.id) as test2 # 결과: [Donald] count=1
from Users u
left outer join Rides r
on u.id=r.user_id
group by u.id;

# [MYSQL]
select u.name
, ifnull(sum(r.distance),0) as travelled_distance
#, sum(r.distance) as travelled_distance  # 결과: null -> 틀림!
from Users u
left outer join Rides r
on u.id=r.user_id
group by u.id, u.name # u.name만 쓰는 것은 비추천. 동명이인이 나올 수 있기 때문에
order by travelled_distance desc, name;