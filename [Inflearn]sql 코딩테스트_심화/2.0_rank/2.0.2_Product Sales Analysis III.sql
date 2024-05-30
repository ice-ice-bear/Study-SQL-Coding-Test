/*
https://leetcode.com/problems/product-sales-analysis-iii/

Table: Sales
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key of this table.
product_id is a foreign key to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.
(sale_id, year)는 이 테이블의 기본 키입니다.
product_id는 Product 테이블의 외래 키입니다.
이 테이블의 각 행에는 특정 연도의 product_id 제품 판매가 표시됩니다.
가격은 개당 가격입니다.


Table: Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key of this table.
Each row of this table indicates the product name of each product.
product_id는 이 테이블의 기본 키입니다.
이 표의 각 행은 각 제품의 제품 이름을 나타냅니다.


Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.
Return the resulting table in any order.
판매된 모든 제품의 첫 해에 대한 제품 ID, 연도, 수량 및 가격을 선택하는 SQL 쿼리를 작성하세요.
결과 테이블을 어떤 순서로든 반환합니다.


Example:
Input: 
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Output: 
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE SALES;
CREATE TABLE SALES (SALE_ID INT, PRODUCT_ID INT, YEAR INT, QUANTITY INT, PRICE INT);
INSERT INTO
	SALES (SALE_ID, PRODUCT_ID, YEAR, QUANTITY, PRICE)
VALUES
('1', '100', '2008', '10', '5000')
,('2', '100', '2009', '12', '5000')
,('7', '200', '2011', '15', '9000');
SELECT * FROM SALES;

# [SETTING]
USE PRACTICE;
DROP TABLE PRODUCT;
CREATE TABLE PRODUCT (PRODUCT_ID INT, PRODUCT_NAME VARCHAR(255));
INSERT INTO
	PRODUCT (PRODUCT_ID, PRODUCT_NAME)
VALUES
('100', 'NOKIA')
,('200', 'APPLE')
,('300', 'SAMSUNG');
SELECT * FROM PRODUCT;

# [my practice]
select product_id, year as first_year, quantity, price
from (select *,
rank() over(partition by product_id order by year) as first
from sales) f
where first = 1;

# [MYSQL1]
# min
SELECT SS.PRODUCT_ID, 
SS.YEAR AS FIRST_YEAR, 
QUANTITY, 
PRICE
FROM SALES S
INNER JOIN
(
	SELECT PRODUCT_ID,
	MIN(YEAR) YEAR -- 'the first year of every product sold'
	FROM SALES
	GROUP BY PRODUCT_ID
) SS
ON S.PRODUCT_ID = SS.PRODUCT_ID
AND S.YEAR = SS.YEAR
ORDER BY SS.PRODUCT_ID; 

# [PRACTICE2]
SELECT PRODUCT_ID,
YEAR, 
QUANTITY,
PRICE,
RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY YEAR) RNK_YEAR
FROM SALES;
        
# [MYSQL2]
# rank
SELECT PRODUCT_ID,
YEAR AS FIRST_YEAR,
QUANTITY,
PRICE
FROM
(
	SELECT PRODUCT_ID,
	YEAR, 
	QUANTITY,
	PRICE,
	RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY YEAR) RNK_YEAR
	FROM SALES
) A
WHERE RNK_YEAR = 1
ORDER BY PRODUCT_ID;