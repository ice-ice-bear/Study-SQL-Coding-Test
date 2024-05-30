/*
https://leetcode.com/problems/group-sold-products-by-the-date/ 

Table Activities:
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table contains the product name and the date it was sold in a market.
이 테이블에는 기본 키가 없으며 중복된 내용이 포함될 수 있습니다.
이 테이블의 각 행에는 제품 이름과 시장에서 판매된 날짜가 포함됩니다.


Write an SQL query to find for each date the number of different products sold and their names.
The sold products names for each date should be sorted lexicographically.
Return the result table ordered by sell_date.
각 날짜에 대해 판매된 다양한 제품 수와 해당 이름을 찾는 SQL 쿼리를 작성하세요.
각 날짜에 판매된 제품 이름은 사전순으로 정렬되어야 합니다.
sell_date를 기준으로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Activities table:
+------------+------------+
| sell_date  | product     |
+------------+------------+
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |
+------------+------------+
Output: 
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
Explanation: 
For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by a comma.
For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by a comma.
For 2020-06-02, the Sold item is (Mask), we just return it.
설명:
2020-05-30의 경우 판매 품목은 (헤드폰, 농구, 티셔츠)였으며 사전순으로 정렬하고 쉼표로 구분합니다.
2020-06-01의 경우 판매 품목은 (연필, 성경)이며 사전순으로 정렬하고 쉼표로 구분합니다.
2020-06-02의 경우 판매 품목은 (마스크)이므로 그냥 반품해 드립니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Activities;
CREATE TABLE Activities (sell_date date, product varchar(20));
INSERT INTO
	Activities (sell_date, product)
VALUES
('2020-05-30', 'Headphone')
,('2020-06-01', 'Pencil')
,('2020-06-02', 'Mask')
,('2020-05-30', 'Basketball')
,('2020-06-01', 'Bible')
,('2020-06-02', 'Mask')
,('2020-05-30', 'T-Shirt');
SELECT * FROM Activities;

#[my practice]
select sell_date, 
count(distinct product) as num_sell,
group_concat(distinct product order by product asc) as products
from activities
group by sell_date; 

# [KEY]
# group_concat: group by 컬럼 기준으로 값들을 이어준다. 값들은 자동으로 쉼표(,)로 구분한다.

# [MYSQL]
select sell_date,
count(distinct product) as num_sold,
GROUP_CONCAT(distinct product ORDER BY product ASC) products
from Activities
group by sell_date;