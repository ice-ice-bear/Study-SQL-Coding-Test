/*
 Table: Views
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
이 테이블에는 기본 키가 없습니다. 중복된 행이 있을 수 있습니다.
이 표의 각 행은 일부 시청자가 특정 날짜에 기사(일부 작성자가 쓴)를 봤음을 나타냅니다.
동일한 작성자_ID와 뷰어_ID는 동일한 사람을 나타냅니다.


Write an SQL query to find all the people who viewed more than one article on the same date,
sorted in ascending order by their id.
같은 날짜에 두 개 이상의 기사를 본 모든 사람을 찾는 SQL 쿼리를 작성하세요.
ID별로 오름차순으로 정렬됩니다.

Example:
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 3          | 4         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+
Output: 
+------+
| id   |
+------+
| 4    |
| 5    |
| 6    |
+------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE VIEWS;
CREATE TABLE VIEWS (ARTICLE_ID INT, AUTHOR_ID INT, VIEWER_ID INT, VIEW_DATE DATE);
INSERT INTO
	VIEWS (ARTICLE_ID, AUTHOR_ID, VIEWER_ID, VIEW_DATE)
VALUES
('1', '3', '5', '2019-08-01')
,('3', '4', '5', '2019-08-01')
,('1', '3', '6', '2019-08-02')
,('2', '7', '7', '2019-08-01')
,('2', '7', '6', '2019-08-02')
,('4', '7', '1', '2019-07-22')
,('3', '4', '4', '2019-07-21')
,('3', '4', '4', '2019-07-21');
-- ,('7', '7', '4', '2019-07-21'); -- DENSE_RANK VS RANK 위해 데이터 추가
SELECT * FROM VIEWS;

#[my practice]

SELECT DISTINCT ARTICLE_ID, -- 'it may have duplicate rows': 중복 row 제거
	VIEWER_ID, 
	VIEW_DATE
	FROM VIEWS;
    
select distinct
author_id,
viewer_id,
view_date
from views;

select viewer_id
from (select  viewer_id, count(viewer_id) as count_view
from (select distinct # distinct는 전체 컬럶에 대해서만 적용된다
article_id,
viewer_id,
view_date
from views) dv
group by view_date, viewer_id) cv
where count_view >= 2
order by viewer_id;



# [MYSQL1] 
# VIEWER_ID=4는 VIEWS 테이블에서 중복 row 존재 (같은 날, 같은 article_id에 대해서 중복)
SELECT VIEWER_ID
FROM (
	SELECT DISTINCT ARTICLE_ID, -- 'it may have duplicate rows': 중복 row 제거
	VIEWER_ID, 
	VIEW_DATE
	FROM VIEWS
) A
GROUP BY VIEWER_ID, VIEW_DATE
HAVING COUNT(ARTICLE_ID) >=2
ORDER BY VIEWER_ID;

# [PRACTICE2]
SELECT VIEWER_ID,
VIEW_DATE,
ARTICLE_ID,
ROW_NUMBER() OVER (PARTITION BY VIEWER_ID, VIEW_DATE ORDER BY ARTICLE_ID) RN_ID, -- 서로 다른 숫자를 갖는다.
RANK() OVER (PARTITION BY VIEWER_ID, VIEW_DATE ORDER BY ARTICLE_ID) RK_ID, -- 중복된 row는 같은 RK_ID를 갖는다.
DENSE_RANK() OVER (PARTITION BY VIEWER_ID, VIEW_DATE ORDER BY ARTICLE_ID) DNRK_ID -- 중복된 row는 같은 DNRK_ID를 갖는다.
FROM VIEWS
ORDER BY VIEWER_ID;
    
# [MYSQL2]
# rank도 가능
SELECT DISTINCT VIEWER_ID
FROM
(
	SELECT ARTICLE_ID,
	VIEWER_ID,
	VIEW_DATE,
	DENSE_RANK() OVER (PARTITION BY VIEWER_ID, VIEW_DATE ORDER BY ARTICLE_ID) DNRK_ID -- 중복된 row는 같은 DNRK_ID를 갖는다.
	FROM VIEWS
	ORDER BY VIEWER_ID
) A
WHERE DNRK_ID > 1; -- 같은 날, 같은 view_id에 대해서, article_id 2개 이상