/*
https://leetcode.com/problems/restaurant-growth/

Table: Customer
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
(customer_id, visited_on)은 이 테이블의 기본 키입니다.
이 테이블에는 레스토랑의 고객 거래에 대한 데이터가 포함되어 있습니다.
visited_on은 ID(customer_id)를 가진 고객이 레스토랑을 방문한 날짜입니다.
amount은 고객이 지불한 총액입니다.


You are the restaurant owner and you want to analyze a possible expansion. (there will be at least one customer every day)
Write an SQL query to compute the moving average of how much the customer paid in a seven days window. (i.e., current day + 6 days before)
average_amount should be rounded to two decimal places.
Return result table ordered by visited_on in ascending order.
당신은 식당 주인이고 가능한 확장을 분석하려고 합니다. (매일 적어도 한 명의 고객이 있을 것입니다)
고객이 7일 동안 지불한 금액의 이동 평균을 계산하는 SQL 쿼리를 작성하세요. (즉, 오늘 + 6일 전)
average_amount는 소수점 이하 두자리로 반올림되어야 합니다.
visited_on을 기준으로 오름차순으로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
Explanation: 
1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86
설명:
2019년 1월 1일부터 2019년 1월 7일까지의 첫 번째 이동 평균의 평균 금액은 (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86입니다.
2019년 1월 2일부터 2019년 1월 8일까지의 두 번째 이동 평균의 평균 금액은 (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120입니다.
2019년 1월 3일부터 2019년 1월 9일까지의 세 번째 이동 평균의 평균 금액은 (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120입니다.
2019년 1월 4일부터 2019년 1월 10일까지의 4차 이동평균의 평균 금액은 (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86입니다.
*/

# [SETTING]
-- USE PRACTICE;
-- DROP TABLE Customer;
-- CREATE TABLE Customer (customer_id int, name varchar(20), visited_on date, amount int);
-- INSERT INTO
-- 	Customer (customer_id, name, visited_on, amount)
-- VALUES
-- ('1', 'Jhon', '2019-01-01', '100')
-- ,('2', 'Daniel', '2019-01-02', '110')
-- ,('3', 'Jade', '2019-01-03', '120')
-- ,('4', 'Khaled', '2019-01-04', '130')
-- ,('5', 'Winston', '2019-01-05', '110')
-- ,('6', 'Elvis', '2019-01-06', '140')
-- ,('7', 'Anna', '2019-01-07', '150')
-- ,('8', 'Maria', '2019-01-08', '80')
-- ,('9', 'Jaze', '2019-01-09', '110')
-- ,('1', 'Jhon', '2019-01-10', '130')
-- ,('3', 'Jade', '2019-01-10', '150');
-- SELECT * FROM Customer;

USE PRACTICE;
DROP TABLE Customer;
CREATE TABLE Customer (customer_id int, name varchar(20), visited_on date, amount int);
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES
(44, 'Ashley', '2019-01-04', 160),
(23, 'Sabo', '2019-01-04', 70),
(38, 'Moustafa', '2019-01-05', 90),
(30, 'Halley', '2019-01-06', 140),
(5, 'Elvis', '2019-01-07', 160),
(12, 'Leslie', '2019-01-08', 100),
(23, 'Sabo', '2019-01-08', 90),
(13, 'Will', '2019-01-09', 170),
(20, 'Brock', '2019-01-10', 160),
(29, 'Leo', '2019-01-10', 90),
(33, 'Isaac', '2019-01-11', 60),
(46, 'Selena', '2019-01-12', 100),
(4, 'Winston', '2019-01-13', 150),
(15, 'Marti', '2019-01-13', 160);
SELECT * FROM Customer;

# [my practice]
select b.visited_on, sum(amount) as amount , round(sum(a.amount) /7, 2) as average_amount
from customer a
inner join
(select distinct date_sub(visited_on, interval 6 day) as week_before, visited_on 
from customer) b
on a.visited_on between b.week_before and b.visited_on
group by b.visited_on
having count(amount) >= 7
order by b.visited_on;

select distinct date_sub(visited_on, interval 6 day) as week_before, visited_on 
from customer;

#[PRACTICE]
SELECT a.visited_on,
a.amount,
DATEDIFF(a.visited_on, (select MIN(visited_on) from Customer)) min_diff -- datediff argument 순서 중요
FROM Customer AS a
ORDER BY a.visited_on;
    
#[PRACTICE]
SELECT a.visited_on,
a.amount,
DATEDIFF(a.visited_on, (select MIN(visited_on) from Customer)) min_diff,
(
	SELECT SUM(b.amount) sum_amount
	FROM Customer AS b
	WHERE DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
) AS sum_amount
FROM Customer AS a
ORDER BY a.visited_on;

#[MYSQL]
SELECT DISTINCT a.visited_on, -- DISTINCT: 2019-01-10 중복 제거를 위해
(
	SELECT SUM(b.amount) sum_amount
	FROM Customer AS b
	WHERE DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
) AS amount, -- =sum_amount
round(
(
	SELECT SUM(b.amount)/7 as average_amount -- 중간에 이빨이 빠진 날짜가 있어도, 7일동안의 average이므로 분모=7
	FROM Customer AS b
	WHERE DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
), 2 ) AS average_amount
FROM Customer AS a
WHERE DATEDIFF(a.visited_on, (select MIN(visited_on) from Customer)) >= 6
ORDER BY a.visited_on;