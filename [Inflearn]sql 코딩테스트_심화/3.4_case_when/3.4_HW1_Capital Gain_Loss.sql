/*
https://leetcode.com/problems/capital-gainloss/

Table: Stocks
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| stock_name    | varchar |
| operation     | enum    |
| operation_day | int     |
| price         | int     |
+---------------+---------+
(stock_name, operation_day) is the primary key for this table.
The operation column is an ENUM of type ('Sell', 'Buy')
Each row of this table indicates that the stock which has stock_name had an operation on the day operation_day with the price.
It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation in a previous day.
It is also guaranteed that each 'Buy' operation for a stock has a corresponding 'Sell' operation in an upcoming day.
(stock_name, Operation_day)는 이 테이블의 기본 키입니다.
operation 열은 ('Sell', 'Buy') 유형의 ENUM입니다.
이 테이블의 각 행은 stock_name을 갖는 주식이 operation_day에 가격과 함께 거래되었음을 나타냅니다.
주식에 대한 각 'Sell' 작업에는 전날의 해당 'Buy' 작업이 있다는 것이 보장됩니다.
또한 주식에 대한 각 'Buy' 작업에는 다음 날 해당 'Sell' 작업이 포함된다는 것도 보장됩니다.


Write an SQL query to report the Capital gain/loss for each stock.
The Capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times.
Return the result table in any order.
각 주식에 대한 자본 이득/손실을 보고하는 SQL 쿼리를 작성합니다.
주식의 자본 이득/손실은 주식을 한 번 이상 매매한 후의 총 이익 또는 손실입니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Stocks table:
+---------------+-----------+---------------+--------+
| stock_name    | operation | operation_day | price  |
+---------------+-----------+---------------+--------+
| Leetcode      | Buy       | 1             | 1000   |
| Corona Masks  | Buy       | 2             | 10     |
| Leetcode      | Sell      | 5             | 9000   |
| Handbags      | Buy       | 17            | 30000  |
| Corona Masks  | Sell      | 3             | 1010   |
| Corona Masks  | Buy       | 4             | 1000   |
| Corona Masks  | Sell      | 5             | 500    |
| Corona Masks  | Buy       | 6             | 1000   |
| Handbags      | Sell      | 29            | 7000   |
| Corona Masks  | Sell      | 10            | 10000  |
+---------------+-----------+---------------+--------+
Output: 
+---------------+-------------------+
| stock_name    | capital_gain_loss |
+---------------+-------------------+
| Corona Masks  | 9500              |
| Leetcode      | 8000              |
| Handbags      | -23000            |
+---------------+-------------------+
Explanation: 
Leetcode stock was bought at day 1 for 1000$ and was sold at day 5 for 9000$. Capital gain = 9000 - 1000 = 8000$.
Handbags stock was bought at day 17 for 30000$ and was sold at day 29 for 7000$. Capital loss = 7000 - 30000 = -23000$.
Corona Masks stock was bought at day 1 for 10$ and was sold at day 3 for 1010$. It was bought again at day 4 for 1000$ and was sold at day 5 for 500$. 
At last, it was bought at day 6 for 1000$ and was sold at day 10 for 10000$. 
Capital gain/loss is the sum of capital gains/losses for each ('Buy' --> 'Sell') operation = (1010 - 10) + (500 - 1000) + (10000 - 1000) = 1000 - 500 + 9000 = 9500$.
설명:
Leetcode 주식은 1일차에 1000$에 매수되었고 5일차에 9000$에 매도되었습니다. 자본 이득 = 9000 - 1000 = 8000$.
Handbags 주식은 17일에 30000$에 구매되었고 29일에 7000$에 매도되었습니다. 자본 손실 = 7000 - 30000 = -23000$.
Corona Masks 주식은 1일차에 10$에 매수되었고 3일차에 1010$에 매도되었습니다. 4일차에 1000$에 다시 구입했고 5일차에 500$에 판매되었습니다.
마침내 6일차에 1000$에 구매되었고 10일차에 10000$에 판매되었습니다.
자본 이득/손실은 각 ('매수' --> '판매') 작업에 대한 자본 이득/손실의 합계입니다. = (1010 - 10) + (500 - 1000) + (10000 - 1000) = 1000 - 500 + 9000 = 9500$.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Stocks;
CREATE TABLE Stocks (stock_name varchar(15), operation ENUM('Sell', 'Buy'), operation_day int, price int);
INSERT INTO
	Stocks (stock_name, operation, operation_day, price)
VALUES
('Leetcode', 'Buy', '1', '1000')
,('Corona Masks', 'Buy', '2', '10')
,('Leetcode', 'Sell', '5', '9000')
,('Handbags', 'Buy', '17', '30000')
,('Corona Masks', 'Sell', '3', '1010')
,('Corona Masks', 'Buy', '4', '1000')
,('Corona Masks', 'Sell', '5', '500')
,('Corona Masks', 'Buy', '6', '1000')
,('Handbags', 'Sell', '29', '7000')
,('Corona Masks', 'Sell', '10', '10000');
SELECT * FROM Stocks;

select stock_name, sum(sell_price) - sum(buy_price) as capital_gain_loss
from(
	select stock_name,
	case when operation = 'buy' then sum(price) end as buy_price,
	case when operation = 'sell' then sum(price) end as sell_price
	from stocks
	group by stock_name, operation
	order by stock_name) total_price
group by stock_name;

# [MYSQL]
select stock_name,
sum(
	case when operation='Buy' then -price
	when operation='Sell' then price
	end
) as capital_gain_loss
from Stocks
group by stock_name;