/*
https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/ 

Table: Orders
+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key for this table.
This table contains information about the order ID and the customer ID.
order_number는 이 테이블의 기본 키입니다.
이 테이블에는 주문 ID 및 고객 ID에 대한 정보가 포함되어 있습니다.


Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.
The test cases are generated so that exactly one customer will have placed more orders than any other customer.
가장 많은 주문을 한 고객의 customer_number를 찾는 SQL 쿼리를 작성하세요.
테스트 사례는 정확히 한 명의 고객이 다른 고객보다 더 많은 주문을 하도록 생성됩니다.


Example:
Input: 
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
Explanation: 
The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
So the result is customer_number 3.
설명:
3번 고객은 2개의 주문을 가지고 있는데, 이는 각각 하나의 주문만 갖고 있기 때문에 고객 1이나 2보다 더 많습니다.
따라서 결과는 customer_number 3입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Orders;
CREATE TABLE Orders (ORDER_NUMBER INT, CUSTOMER_NUMBER INT);
INSERT INTO
	 Orders (ORDER_NUMBER, CUSTOMER_NUMBER)
VALUES
	('1', '1')
	,('2', '2')
	,('3', '3')
	,('4', '3');
SELECT * FROM Orders;

# [my practice]
select customer_number
from (select customer_number, 
rank() over(order by o_count desc) as c_rank 
from 
(select customer_number, count(order_number) as o_count
from orders
group by customer_number) rk) ck
where c_rank = 1;

# [my_practice] -another solution
SELECT customer_number FROM Orders
GROUP BY customer_number
ORDER BY COUNT(customer_number) DESC LIMIT 1; #desc limit 1로 1개의 값만 출력

# [my paractice] - min, max를 활용하는 경우
SELECT customer_number
FROM (
    SELECT customer_number, COUNT(order_number) AS o_count
    FROM orders
    GROUP BY customer_number
) AS rk
WHERE o_count = (
SELECT MAX(o_count) 
FROM (SELECT COUNT(order_number) AS o_count 
FROM orders GROUP BY customer_number) AS max_count);




# [PRACTICE]
SELECT CUSTOMER_NUMBER, 
ORDER_COUNTS,
RANK() OVER(ORDER BY ORDER_COUNTS DESC) AS RNK
FROM (
	SELECT CUSTOMER_NUMBER, 
	COUNT(CUSTOMER_NUMBER) AS ORDER_COUNTS
	FROM Orders
	GROUP BY CUSTOMER_NUMBER
) A;
    
# [MYSQL]
SELECT CUSTOMER_NUMBER
FROM (
	SELECT CUSTOMER_NUMBER, 
	RANK() OVER(ORDER BY ORDER_COUNTS DESC) AS RNK
	FROM (
		SELECT CUSTOMER_NUMBER, 
		COUNT(CUSTOMER_NUMBER) AS ORDER_COUNTS
		FROM Orders
		GROUP BY CUSTOMER_NUMBER
	) A
) B
 WHERE RNK  = 1;