/*
Table: Books
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| book_id        | int     |
| name           | varchar |
| available_from | date    |
+----------------+---------+
book_id is the primary key of this table.
book_id는 이 테이블의 기본 키입니다.


Table: Orders
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
+----------------+---------+
order_id is the primary key of this table.
book_id is a foreign key to the Books table.
order_id는 이 테이블의 기본 키입니다.
book_id는 Books 테이블에 대한 외래 키입니다.


Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today.
Assume today is 2019-06-23.
오늘부터 판매된 지 1개월 미만인 도서를 제외하고, 작년에 10권 미만으로 판매된 도서를 보고하는 SQL 쿼리를 작성하세요.
오늘이 2019-06-23이라고 가정합니다.

Example:
Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | "Kalila And Demna" | 2010-01-01     |
| 2       | "28 Letters"       | 2012-05-12     |
| 3       | "The Hobbit"       | 2019-06-10     |
| 4       | "13 Reasons Why"   | 2019-06-01     |
| 5       | "The Hunger Games" | 2008-09-21     |
+---------+--------------------+----------------+
Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+
Orders table: (modified)
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 100      | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 3       | 8        | 2019-06-11    |
| 4        | 4       | 6        | 2019-06-05    |
| 5        | 4       | 5        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+
Output:
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 1         | "Kalila And Demna" |
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+
Output:: (modified)
+-----------+--------------------+
| book_id   | name               |
+-----------+--------------------+
| 2         | "28 Letters"       |
| 5         | "The Hunger Games" |
+-----------+--------------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE BOOKS;
CREATE TABLE BOOKS (BOOK_ID INT, NAME VARCHAR(255), AVAILABLE_FROM DATE);
INSERT INTO
	BOOKS (BOOK_ID, NAME, AVAILABLE_FROM)
VALUES
('1', 'KALILA AND DEMNA', '2010-01-01')
,('2', '28 LETTERS', '2012-05-12')
,('3', 'THE HOBBIT', '2019-06-10')
,('4', '13 REASONS WHY', '2019-06-01')
,('5', 'THE HUNGER GAMES', '2008-09-21');
SELECT * FROM BOOKS;

# [SETTING]
USE PRACTICE;
DROP TABLE ORDERS;
CREATE TABLE ORDERS (ORDER_ID INT, BOOK_ID INT, QUANTITY INT, DISPATCH_DATE DATE);
INSERT INTO
	ORDERS (ORDER_ID, BOOK_ID, QUANTITY, DISPATCH_DATE)
VALUES
('1', '1', '100', '2018-07-26')
,('2', '1', '1', '2018-11-05')
,('3', '3', '8', '2019-06-11')
,('4', '4', '6', '2019-06-05')
,('5', '4', '5', '2019-06-20')
,('6', '5', '9', '2009-02-02')
,('7', '5', '8', '2010-04-13');
SELECT * FROM ORDERS;

#[my practice]
select *
from 
books b
left outer join 
orders o
on b. book_id = o.book_id 
where o.book_id not in(
	select book_id
    from books
    where quantity > 10 
    and available_from between date_sub('2019-06-23', interval 29 day) and '2019-06-23');


select *
from books
where book_id not in(
select *
from
(select book_id
from books
where available_from between date_sub('2019-06-23', interval 29 day) and '2019-06-23') month_1

union

select *
from
(select book_id
from orders
where quantity > 10) less_10
order by book_id);

# [PRACTICE]
# 결과: 없음
# book_id=1은 2018년 총 110개 판매해서 제외되었지만, 
# book_id=2,3,4,5는 하나도 판매가 안되었으므로, 후보에는 포함이 되어야 한다.
SELECT BOOK_ID
FROM ORDERS
WHERE DISPATCH_DATE >= '2018-01-01'
AND DISPATCH_DATE <= '2018-12-31'
GROUP BY BOOK_ID
HAVING SUM(QUANTITY) <= 10;

# [PRACTCE]
SELECT BOOK_ID
FROM ORDERS
WHERE DISPATCH_DATE >= '2018-01-01'
AND DISPATCH_DATE <= '2018-12-31'
GROUP BY BOOK_ID
HAVING SUM(QUANTITY) > 10

UNION -- union은 unique row만 포함

SELECT BOOK_ID
FROM BOOKS
WHERE DATE_SUB('2019-06-23', INTERVAL 30 DAY) <= AVAILABLE_FROM
AND AVAILABLE_FROM <= '2019-06-23'; -- today
    
# [MYSQL]
SELECT BOOK_ID, 
NAME
FROM BOOKS
-- 'have sold less than 10 copies in the last year' 반댓말
-- 'excluding books that have been available for less than 1 month from today' 반댓말
WHERE BOOK_ID NOT IN
(
	SELECT BOOK_ID
	FROM ORDERS
	WHERE DISPATCH_DATE >= '2018-01-01'
	AND DISPATCH_DATE <= '2018-12-31'
	GROUP BY BOOK_ID
	HAVING SUM(QUANTITY) > 10

	UNION -- union은 unique row만 포함

	SELECT BOOK_ID
	FROM BOOKS
	WHERE DATE_SUB('2019-06-23', INTERVAL 30 DAY) <= AVAILABLE_FROM
	AND AVAILABLE_FROM <= '2019-06-23' -- today
);