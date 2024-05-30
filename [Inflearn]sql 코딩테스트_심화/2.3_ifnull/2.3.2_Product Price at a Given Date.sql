/*
https://leetcode.com/problems/product-price-at-a-given-date/

Table: Products
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
(product_id,change_date)는 이 테이블의 기본 키입니다.
이 테이블의 각 행은 일부 제품의 가격이 특정 날짜에 새 가격으로 변경되었음을 나타냅니다.


Write an SQL query to find the prices of all products on 2019-08-16.
Assume the price of all products before any change is 10.
Return the result table in any order.
2019-08-16의 제품 가격을 찾는 SQL 쿼리를 작성하세요.
변경 전 모든 제품의 가격이 10이라고 가정합니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE PRODUCTS;
CREATE TABLE PRODUCTS (PRODUCT_ID INT, NEW_PRICE INT, CHANGE_DATE DATE);
INSERT INTO
	PRODUCTS (PRODUCT_ID, NEW_PRICE, CHANGE_DATE)
VALUES
('1', '20', '2019-08-14')
,('2', '50', '2019-08-14')
,('1', '30', '2019-08-15')
,('1', '35', '2019-08-16')
,('2', '65', '2019-08-17')
,('3', '20', '2019-08-18');
SELECT * FROM PRODUCTS;

# group by를 사용할 경우 group by한 쿼리 이외의 쿼리를 사용하기 복잡하다
# 그러므로 max를 사용하기보단 rank를 활용하는 것이 더 융요할 수 있다.
# [my practice]
select p.product_id, ifnull(new_price, 10) as price 
from
(select distinct product_id
from products) p
left outer join
(select product_id, new_price
from 
(select *,
rank() over(partition by product_id order by change_date desc) as rk_id
from products
where change_date <= '2019-08-16') rank_product
where rk_id = 1) rank_1 
on p.product_id = rank_1.product_id;

# [PRACTICE]
SELECT PRODUCT_ID,
NEW_PRICE,
CHANGE_DATE,
RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) RK_DATE
FROM PRODUCTS
WHERE CHANGE_DATE <= '2019-08-16';

# [PRACTICE]
SELECT P.PRODUCT_ID,
PP.NEW_PRICE AS price
FROM 
(
	SELECT DISTINCT PRODUCT_ID
	FROM PRODUCTS
) P -- 전체 PRODUCT_ID를 선택하기 위해서
LEFT OUTER JOIN
(
	SELECT PRODUCT_ID,
    NEW_PRICE
	FROM
	(
		SELECT PRODUCT_ID,
		NEW_PRICE,
		RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) RK_DATE
		FROM PRODUCTS
		WHERE CHANGE_DATE <= '2019-08-16'
	) A
	WHERE RK_DATE =1
) PP
ON P.PRODUCT_ID = PP.PRODUCT_ID;

# [MYSQL]
# row_number, rank, dense_rank 모두 가능
# 조심: IFNULL(PP.NEW_PRICE, '10')으로 쓸 경우, data type이 일치하지 않아서 leetcode에서 정답으로 인정 X
SELECT P.PRODUCT_ID,
IFNULL(PP.NEW_PRICE, 10) price -- 'Assume the price of all products before any change is 10'
FROM 
(
	SELECT DISTINCT PRODUCT_ID
	FROM PRODUCTS
) P -- 전체 PRODUCT_ID를 선택하기 위해서
LEFT OUTER JOIN
(
	SELECT PRODUCT_ID,
    NEW_PRICE
	FROM
	(
		SELECT PRODUCT_ID,
		NEW_PRICE,
		RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) RK_DATE
		FROM PRODUCTS
		WHERE CHANGE_DATE <= '2019-08-16'
	) A
	WHERE RK_DATE =1
) PP
ON P.PRODUCT_ID = PP.PRODUCT_ID;
