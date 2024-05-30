/*
https://leetcode.com/problems/customers-who-bought-all-products/

Table: Customer
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.
이 테이블에는 중복된 행이 포함되어 있을 수 있습니다.
customer_id가 NULL이 아닙니다.
product_key는 Product 테이블에 대한 외래 키(참조 열)입니다.


Table: Product
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.
product_key는 이 테이블의 기본 키(고유 값이 있는 열)입니다.

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
Return the result table in any order.
Product 테이블의 모든 제품을 구매한 Customer 테이블의 고객 ID를 출력하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.
설명: 모든 상품(5, 6)을 구매한 고객은 ID 1, 3의 고객입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE CUSTOMER;
CREATE TABLE CUSTOMER (CUSTOMER_ID INT, PRODUCT_KEY INT);
INSERT INTO
	CUSTOMER (CUSTOMER_ID, PRODUCT_KEY)
VALUES
('1', '5')
,('2', '6')
,('3', '5')
,('3', '6')
,('1', '6');
SELECT * FROM CUSTOMER;

# [SETTING]
USE PRACTICE;
DROP TABLE PRODUCT;
CREATE TABLE PRODUCT (PRODUCT_KEY INT);
INSERT INTO
	PRODUCT (PRODUCT_KEY)
VALUES
('5')
,('6');
SELECT * FROM PRODUCT;

select * from customer;

# [my practice]
select c.customer_id
from customer c
group by c.customer_id
having count(distinct product_key) = (select count(product_key) from product);

# [MYSQL]
SELECT CUSTOMER_ID
FROM CUSTOMER
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT PRODUCT_KEY) = (SELECT COUNT(PRODUCT_KEY) FROM PRODUCT); -- 'Customer table may contain duplicates rows'