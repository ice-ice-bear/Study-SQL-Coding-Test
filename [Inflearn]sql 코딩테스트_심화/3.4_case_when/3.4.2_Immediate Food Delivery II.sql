/*
https://leetcode.com/problems/immediate-food-delivery-ii/

Table: Delivery
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
delivery_id는 이 테이블의 기본 키입니다.
테이블에는 특정 날짜에 주문한 고객의 음식 배달 정보와 원하는 배송 날짜(동일한 주문 날짜 또는 그 이후) 정보를 포함합니다.


If the customer's preferred delivery date is the same as the order date, then the order is called 'immediate'
otherwise, it is called 'scheduled'.
The first order of a customer is the order with the earliest order date that the customer made.
It is guaranteed that a customer has precisely one first order.
고객이 원하는 배송 날짜가 주문 날짜와 동일한 경우 주문을 'immediate'라고 합니다.
그렇지 않으면 'scheduled'이라고 합니다.
고객의 첫 번째 주문은 고객이 주문한 날짜가 가장 빠른 주문입니다.
고객이 한 번의 첫 번째 주문을 한다는 것이 보장됩니다.


Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
모든 고객의 첫 번째 주문에서 즉시 주문의 비율을 구하는 SQL 쿼리를 작성하고, 소수점 이하 2자리로 반올림되었습니다.


Example:
Input: 
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
Output: 
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.
설명:
고객 ID 1에는 배송 ID 1의 첫 번째 주문이 있으며 예약되어 있습니다.
고객 ID 2는 배송 ID 2의 첫 번째 주문이 있으며 즉시 이루어집니다.
고객 ID 3은 배송 ID 5의 첫 번째 주문을 갖고 있으며 해당 주문이 예정되어 있습니다.
고객 ID 4는 배송 ID 7의 첫 번째 주문을 갖고 있으며 즉시 이루어집니다.
따라서 고객의 절반이 즉시 첫 주문을 받습니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE DELIVERY;
CREATE TABLE DELIVERY (DELIVERY_ID INT, CUSTOMER_ID INT, ORDER_DATE DATE, CUSTOMER_PREF_DELIVERY_DATE DATE);
INSERT INTO
	DELIVERY (DELIVERY_ID, CUSTOMER_ID, ORDER_DATE, CUSTOMER_PREF_DELIVERY_DATE)
VALUES
('1', '1', '2019-08-01', '2019-08-02')
,('2', '2', '2019-08-02', '2019-08-02')
,('3', '1', '2019-08-11', '2019-08-12')
,('4', '3', '2019-08-24', '2019-08-24')
,('5', '3', '2019-08-21', '2019-08-22')
,('6', '2', '2019-08-11', '2019-08-13')
,('7', '4', '2019-08-09','2019-08-09');
SELECT * FROM DELIVERY;

select 
round((count(case when order_case = 'immediate' then 1 end) / count(order_count)) *100 ,2) as immediate_percentage
from
(
	select *,
	rank() over(partition by customer_id order by order_date) as order_count,
	case when order_date = customer_pref_delivery_date then 'immediate' else 'scheduled' end as order_case
	from delivery
    ) o
where o.order_count = 1;

select *,
rank() over(partition by customer_id order by order_date) as order_count,
case when order_date = customer_pref_delivery_date then 'immediate' else 'scheduled' end as order_case
from delivery;

# [PRACTICE]
SELECT *
FROM
(
	SELECT CUSTOMER_ID,
	ORDER_DATE,
	CUSTOMER_PREF_DELIVERY_DATE,
	RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) RNK_DATE
	FROM DELIVERY
) A
WHERE RNK_DATE=1; -- 'first orders of all customers'
    
# [MYSQL]
SELECT ROUND(COUNT(CASE WHEN ORDER_DATE = CUSTOMER_PREF_DELIVERY_DATE THEN 1 END)/COUNT(1)*100, 2) IMMEDIATE_PERCENTAGE
-- else: default null, count(null)=0
FROM
(
	SELECT ORDER_DATE,
    CUSTOMER_PREF_DELIVERY_DATE
	FROM
	(
		SELECT CUSTOMER_ID,
		ORDER_DATE,
		CUSTOMER_PREF_DELIVERY_DATE,
		RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) RNK_DATE
		FROM DELIVERY
	) A
	WHERE RNK_DATE=1 -- 'first orders of all customers'
) B;