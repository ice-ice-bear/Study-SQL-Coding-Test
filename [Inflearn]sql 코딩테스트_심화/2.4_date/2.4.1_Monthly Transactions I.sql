/*
https://leetcode.com/problems/monthly-transactions-i/

Table: Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
id는 이 테이블의 기본 키입니다.
테이블에는 들어오는 트랜잭션에 대한 정보가 있습니다.
state 열은 ["approved", "declined"] 유형의 열거형입니다.


Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
Return the result table in any order.
월별, 국가별로 거래 건수와 총액, 승인된 거래 건수와 총액을 찾는 SQL 쿼리를 작성하세요.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE TRANSACTIONS;
CREATE TABLE TRANSACTIONS (ID INT, COUNTRY VARCHAR(255), STATE VARCHAR(255), AMOUNT INT, TRANS_DATE DATE);
INSERT INTO
	TRANSACTIONS (ID, COUNTRY, STATE, AMOUNT, TRANS_DATE)
VALUES
('121', 'US', 'APPROVED', '1000', '2018-12-18')
,('122', 'US', 'DECLINED', '2000', '2018-12-19')
,('123', 'US', 'APPROVED', '2000', '2019-01-01')
,('124', 'DE', 'APPROVED', '2000', '2019-01-07');
SELECT * FROM TRANSACTIONS;

select trans_month as 'month', country,
count(id) as trans_count,
count(case when state  = 'approved' then 1 end) as approved_count,
sum(amount) as trans_total_amount,
ifnull(sum(case when state = 'approved' then amount end), 0) as approved_total_amount
from 
(select *,
date_format(trans_date, '%Y-%m') trans_month
from transactions) t_m
group by trans_month, country;

select *,
date_format(trans_date, '%Y-%m') trans_month
from transactions;


# [PRACTICE]
SELECT TRANS_DATE,
DATE_FORMAT(TRANS_DATE, '%Y-%m') TRANS_MONTH
FROM transactions;

# [MYSQL]
SELECT DATE_FORMAT(TRANS_DATE, '%Y-%m') AS MONTH,
COUNTRY, 
COUNT(ID) AS TRANS_COUNT,
COUNT(CASE WHEN STATE = 'APPROVED' THEN 1 END) APPROVED_COUNT,
SUM(AMOUNT) AS TRANS_TOTAL_AMOUNT, -- null 상황 불가능
IFNULL(SUM(CASE WHEN STATE = 'APPROVED' THEN AMOUNT END),0) AS APPROVED_TOTAL_AMOUNT -- null 상황 가능: IFNULL 필요!
FROM TRANSACTIONS
GROUP BY COUNTRY, DATE_FORMAT(TRANS_DATE, '%Y-%m')
ORDER BY MONTH;