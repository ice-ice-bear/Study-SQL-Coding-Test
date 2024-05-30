/*
https://leetcode.com/problems/market-analysis-i/

Table: Users
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items. 
user_id는 이 테이블의 기본 키입니다.
이 테이블에는 사용자가 상품을 판매하고 구매할 수 있는 온라인 쇼핑 웹사이트의 사용자 정보가 포함되어 있습니다.


Table: Orders
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.
order_id는 이 테이블의 기본 키입니다.
item_id는 Items 테이블에 대한 외래 키입니다.
buyer_id 및 seller_id는 Users 테이블의 외래 키입니다. 

Table: Items
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key of this table.
item_id는 이 테이블의 기본 키입니다.


Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.
Return the result table in any order.
각 사용자에 대해 가입 날짜와 2019년 구매한 주문 수를 찾는 SQL 쿼리를 작성하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2018-01-01 | Lenovo         |
| 2       | 2018-02-09 | Samsung        |
| 3       | 2018-01-19 | LG             |
| 4       | 2018-05-21 | HP             |
+---------+------------+----------------+
Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2018-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2018-08-04 | 1       | 4        | 2         |
| 5        | 2018-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+
Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
Output: 
+-----------+------------+----------------+
| buyer_id  | join_date  | orders_in_2019 |
+-----------+------------+----------------+
| 1         | 2018-01-01 | 1              |
| 2         | 2018-02-09 | 2              |
| 3         | 2018-01-19 | 0              |
| 4         | 2018-05-21 | 0              |
+-----------+------------+----------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Users;
CREATE TABLE Users (user_id int, join_date date, favorite_brand varchar(10));
INSERT INTO
	Users (user_id, join_date, favorite_brand)
VALUES
('1', '2018-01-01', 'Lenovo')
,('2', '2018-02-09', 'Samsung')
,('3', '2018-01-19', 'LG')
,('4', '2018-05-21', 'HP');
SELECT * FROM Users;

# [SETTING]
USE PRACTICE;
DROP TABLE Orders;
CREATE TABLE Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int);
INSERT INTO
	Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES
('1', '2019-08-01', '4', '1', '2')
,('2', '2018-08-02', '2', '1', '3')
,('3', '2019-08-03', '3', '2', '3')
,('4', '2018-08-04', '1', '4', '2')
,('5', '2018-08-04', '1', '3', '4')
,('6', '2019-08-05', '2', '2', '4');
SELECT * FROM Orders;

# [SETTING]
USE PRACTICE;
DROP TABLE Items;
CREATE TABLE Items (item_id int, item_brand varchar(10));
INSERT INTO
	Items (item_id, item_brand)
VALUES
('1', 'Samsung')
,('2', 'Lenovo')
,('3', 'LG')
,('4', 'HP');
SELECT * FROM Items;

select * from orders;

# group by를 뒤에 쓸 경우 복잡해 진다 서브쿼리에서 쓰는 것이 바람직하다
# 밖에서 group by를 쓸 경유, 컬럼을 마다마다 꺼내는 것이 어렵다
# [my practice]
select user_id, join_date, ifnull(orders_in_2019, 0) as orders_in_2019 
from
(select user_id, join_date 
from users) u
left outer join
(select buyer_id, count(buyer_id) as orders_in_2019
from orders
where date_format(order_date, '%Y') = '2019'
group by buyer_id) o
on u.user_id = o.buyer_id;

# [PRACTICE]
# date_format: 다음 섹션에서 배울 예정
select order_date,
date_format(order_date, '%Y') order_year,
date_format(order_date, '%Y-%m') order_month
from Orders;
    
# [PRACTICE]
select buyer_id,
count(*) orders_in_2019
from Orders
where date_format(order_date, '%Y')='2019'
group by buyer_id;
    
# [PRACTICE]
select a.user_id as buyer_id,
a.join_date,
aa.orders_in_2019
from
(
    select user_id,
    join_date
    from Users
) a
left outer join
(
    select buyer_id,
    count(*) orders_in_2019
    from Orders
    where date_format(order_date, '%Y')='2019'
    group by buyer_id
) aa
on a.user_id=aa.buyer_id;

# [MYSQL]
select a.user_id as buyer_id,
a.join_date,
ifnull(aa.orders_in_2019, 0) as orders_in_2019
from
(
    select user_id,
    join_date
    from Users
) a
left outer join
(
    select buyer_id,
    count(*) orders_in_2019
    from Orders
    where date_format(order_date, '%Y')='2019'
    group by buyer_id
) aa
on a.user_id=aa.buyer_id;
