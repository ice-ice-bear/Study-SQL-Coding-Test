/*
https://leetcode.com/problems/count-salary-categories/

Table: Accounts
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key for this table.
Each row contains information about the monthly income for one bank account.
account_id는 이 테이블의 기본 키입니다.
각 행에는 한 은행 계좌의 월별 수입에 대한 정보가 포함되어 있습니다.


Calculate the number of bank accounts of each salary category.
The salary categories are:
- "Low Salary": All the salaries strictly less than $20000.
- "Average Salary": All the salaries in the inclusive range [$20000, $50000].
- "High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories.
If there are no accounts in a category, then report 0.
Return the result table in any order.
각 급여 항목의 은행 계좌 수를 계산합니다.
급여 카테고리는 다음과 같습니다.
- "Low Salary": 모든 급여가 $20000 미만입니다.
- "Average Salary": 포함 범위 [$20000, $50000]의 모든 급여입니다.
- "High Salary": 모든 급여가 $50000보다 엄격합니다.
결과 테이블에는 세 가지 범주가 모두 포함되어야 합니다.
카테고리에 계정이 없으면 0을 보고합니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
Output: 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
Explanation: 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.
설명:
낮은 급여: 계정 2.
평균 급여: 계정이 없습니다.
높은 급여: 계정 3, 6, 8.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Accounts;
CREATE TABLE Accounts (account_id int, income int);
INSERT INTO
	Accounts (account_id, income)
VALUES
('3', '108939')
,('2', '12747')
,('8', '87709')
,('6', '91796');
SELECT * FROM Accounts;

# [my practice]
select 'Low Salary' as category,
count(case when income < 20000 then 1 end) as accounts_count
from accounts

union

select 'Average Salary' as category,
count(case when income between 20000 and 50000 then 1 end) as accounts_count
from accounts

union

select 'High Salary' as category,
count(case when income > 50000 then 1 end) as accounts_count
from accounts;

# [MYSQL]
# 'If there are no accounts in a category, then report 0'
select 'Low Salary' as category,
count(case when income < 20000 then 1 end) as accounts_count -- else: default null, count(null)=0
from Accounts

union

select 'Average Salary' as category,
count(case when 20000 <= income and income <= 50000 then 1 end) as accounts_count -- else: default null, count(null)=0
from Accounts

union

select 'High Salary' as category,
count(case when income > 50000 then 1 end) as accounts_count -- else: default null, count(null)=0
from Accounts;