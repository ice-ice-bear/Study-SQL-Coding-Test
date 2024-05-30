/*
https://leetcode.com/problems/movie-rating/

Table: Movies
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key for this table.
title is the name of the movie.
movie_id는 이 테이블의 기본 키입니다.
제목은 영화 이름이에요.


Table: Users
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key for this table.
user_id는 이 테이블의 기본 키입니다.

 
Table: MovieRating
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
(movie_id, user_id)는 이 테이블의 기본 키입니다.
이 테이블에는 사용자가 평가한 영화에 대한 평점이 포함되어 있습니다.
created_at는 사용자의 평가 날짜입니다.


Write an SQL query to:
Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
다음에 대한 SQL 쿼리를 작성합니다.
가장 많은 영화를 평가한 사용자의 이름을 찾으십시오. 동점인 경우 사전순으로 더 작은 사용자 이름을 반환합니다.
2020년 2월 평균 평점이 가장 높은 영화명을 찾아보세요. 동점인 경우 사전순으로 더 작은 영화 이름을 반환합니다.


Example:
Input: 
Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
Explanation: 
Daniel and Monica have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.
설명:
다니엘과 모니카는 3개의 영화('Avengers', 'Frozen 2', 'Joker')의 등급을 매겼지만 사전순으로는 다니엘의 등급이 더 작습니다.
Frozen 2와 Joker의 2월 평균 시청률은 3.5이지만 사전순으로는 Frozen 2가 더 작습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Movies;
CREATE TABLE Movies (movie_id int, title varchar(30));
-- INSERT INTO
-- 	Movies (movie_id, title)
-- VALUES
-- ('1', 'Avengers')
-- ,('2', 'Frozen 2')
-- ,('3', 'Joker');
INSERT INTO Movies (movie_id, title)
VALUES
(1, 'Five feet apart'),
(2, 'Back to the Future'),
(3, 'Shrek');


# [SETTING]
USE PRACTICE;
DROP TABLE Users;
CREATE TABLE Users (user_id int, name varchar(30));
-- INSERT INTO
-- 	Users (user_id, name)
-- VALUES
-- ('1', 'Daniel')
-- ,('2', 'Monica')
-- ,('3', 'Maria')
-- ,('4', 'James');
INSERT INTO Users (user_id, name)
VALUES
(1, 'Maria'),
(2, 'Jade'),
(3, 'Claire'),
(4, 'Will');


# [SETTING]
USE PRACTICE;
DROP TABLE MovieRating;
CREATE TABLE MovieRating (movie_id int, user_id int, rating int, created_at date);
-- INSERT INTO
-- 	MovieRating (movie_id, user_id, rating, created_at)
-- VALUES
-- ('1', '1', '3', '2020-01-12')
-- ,('1', '2', '4', '2020-02-11')
-- ,('1', '3', '2', '2020-02-12')
-- ,('1', '4', '1', '2020-01-01')
-- ,('2', '1', '5', '2020-02-17')
-- ,('2', '2', '5', '2020-02-01')
-- ,('2', '3', '2', '2020-03-01')
-- ,('3', '1', '3', '2020-02-22')
-- ,('3', '2', '4', '2020-02-25');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES
(1, 1, 4, '2020-02-03'),
(1, 2, 5, '2020-02-05'),
(1, 3, 3, '2020-02-23'),
(1, 4, 1, '2020-02-29'),
(2, 1, 4, '2020-01-27'),
(2, 2, 3, '2020-02-27'),
(2, 3, 1, '2020-02-11'),
(2, 4, 3, '2020-02-22'),
(3, 1, 1, '2020-02-16'),
(3, 2, 3, '2020-02-08'),
(3, 3, 2, '2020-02-16'),
(3, 4, 1, '2020-02-07');



# [my practice] - step1 highest movie rating
select *
from 
(select name as results
from 
(select mr.user_id, name, count(mr.user_id) as rate_num
from movierating mr
inner join 
users u
where mr.user_id = u.user_id
group by mr.user_id, name
order by name
limit 1)m_rated) m_rated_name;

# movierating inner join user
select *
from
(select name as results
from 
(select mr.user_id, name, count(mr.user_id) as rate_num
from movierating mr
inner join 
users u
where mr.user_id = u.user_id
group by mr.user_id, name
order by name
limit 1)

union all

select *
from
(select title as results
from
	(select movie_id, title, round(avg(rating)) as avg_rating, max(rating) as max_rating
	from 
		(select mr.movie_id, title, user_id, rating, created_at
		from movierating mr
		inner join 
		movies m
		on mr.movie_id = m.movie_id) mrm
	where date_format(created_at, "%Y-%m") = '2020-02'
	group by movie_id, title
	order by avg_rating desc, title, max_rating
	limit 1) b_rated) ;





# [ERROR]
# order by, limit 1
select name as results -- union all/union 사용할 경우 컬럼명 같아야 된다.
from MovieRating m
inner join Users u
on m.user_id=u.user_id
group by name
order by count(rating) desc, name -- 'In case of a tie, return the lexicographically smaller user name'
limit 1

union all -- 중복 row 모두 포함 (참고: union은 unique row만 포함)

select title as results
from MovieRating m
inner join Movies mm
on m.movie_id=mm.movie_id
where date_format(created_at, '%Y-%m')='2020-02'
group by title
order by avg(rating) desc, title -- 'In case of a tie, return the lexicographically smaller movie name'
limit 1;

# [MYSQL]
# order by, limit 1
select results
from
(
	select name as results -- union all/union 사용할 경우 컬럼명 같아야 된다.
	from MovieRating m
	inner join Users u
	on m.user_id=u.user_id
	group by name
	order by count(rating) desc, name -- 'In case of a tie, return the lexicographically smaller user name'
	limit 1
) A

union all -- 중복 row 모두 포함 (참고: union은 unique row만 포함)

select *
from
(
	select title as results
	from MovieRating m
	inner join Movies mm
	on m.movie_id=mm.movie_id
	where date_format(created_at, '%Y-%m')='2020-02'
	group by title
	order by avg(rating) desc, title -- 'In case of a tie, return the lexicographically smaller movie name'
	limit 1
) B;
