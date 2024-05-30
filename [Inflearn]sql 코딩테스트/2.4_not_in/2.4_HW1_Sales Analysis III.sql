/*
https://leetcode.com/problems/sales-analysis-iii/description/

Table: Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the name and the price of each product.
product_id는 이 테이블의 기본 키(고유 값이 있는 열)입니다.
이 표의 각 행에는 각 제품의 이름과 가격이 표시됩니다.


Table: Sales
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+-------------+---------+
This table can have duplicate rows.
product_id is a foreign key (reference column) to the Product table.
Each row of this table contains some information about one sale.
이 테이블에는 중복된 행이 있을 수 있습니다.
product_id는 Product 테이블에 대한 외래 키(참조 열)입니다.
이 테이블의 각 행에는 하나의 판매에 대한 일부 정보가 포함되어 있습니다.


Write a solution to report the products that were only sold in the first quarter of 2019.
That is, between 2019-01-01 and 2019-03-31 inclusive.
Return the result table in any order.
2019년 1분기에만 판매된 제품을 보고하는 솔루션을 작성하세요.
즉, 2019-01-01부터 2019-03-31 사이입니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
Output: 
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+
Explanation: 
The product with id 1 was only sold in the spring of 2019.
The product with id 2 was sold in the spring of 2019 but was also sold after the spring of 2019.
The product with id 3 was sold after spring 2019.
We return only product 1 as it is the product that was only sold in the spring of 2019.
설명:
ID가 1인 제품은 2019년 봄에만 판매되었습니다.
ID가 2인 제품은 2019년 봄에 판매되었지만 2019년 봄 이후에도 판매되었습니다.
ID가 3인 제품은 2019년 봄 이후에 판매되었습니다.
2019년 봄에만 판매된 상품이라 1번 상품만 반품해 드립니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Product;
CREATE TABLE Product(product_id int, product_name varchar(10), unit_price int);
INSERT INTO
	Product (product_id, product_name, unit_price)
VALUES
('1', 'S8', '1000')
,('2', 'G4', '800')
,('3', 'iPhone', '1400');
SELECT * FROM Product;


# [SETTING]
USE PRACTICE;
DROP TABLE Sales;
CREATE TABLE Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int);
INSERT INTO
	Sales (seller_id, product_id, buyer_id, sale_date, quantity, price)
VALUES
('1', '1', '1', '2019-01-21', '2', '2000')
,('1', '2', '2', '2019-02-17', '1', '800')
,('2', '2', '3', '2019-06-02', '1', '800')
,('3', '3', '4', '2019-05-13', '2', '2800');
SELECT * FROM Sales;

# 질문란 참고: https://www.inflearn.com/questions/1222705

# [MYSQL1]
SELECT DISTINCT P.PRODUCT_ID,
P.PRODUCT_NAME
FROM PRODUCT P
INNER JOIN (
    SELECT *
    FROM SALES
    WHERE PRODUCT_ID NOT IN (
        SELECT PRODUCT_ID
        FROM SALES
        WHERE SALE_DATE < '2019-01-01'
        OR SALE_DATE > '2019-03-31'
    ) 
) N
ON P.PRODUCT_ID = N.PRODUCT_ID;

# [MYSQL2]
SELECT P.PRODUCT_ID,
P.PRODUCT_NAME
FROM PRODUCT P
INNER JOIN (
    SELECT DISTINCT PRODUCT_ID
    FROM SALES
    WHERE PRODUCT_ID NOT IN (
        SELECT PRODUCT_ID
        FROM SALES
        WHERE SALE_DATE < '2019-01-01'
        OR SALE_DATE > '2019-03-31'
    ) 
) N
ON P.PRODUCT_ID = N.PRODUCT_ID;