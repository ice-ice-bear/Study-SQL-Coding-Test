/*
Table: Events
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurences    | int     | 
+---------------+---------+
(business_id, event_type) is the primary key of this table.
Each row in the table logs the info that an event of some type occured at some business for a number of times.
(business_id, event_type)은 이 테이블의 기본 키입니다.
테이블의 각 행에는 특정 비즈니스에서 특정 유형의 이벤트가 여러 번 발생했다는 정보가 기록됩니다.


Write an SQL query to find all active businesses.
An active business is a business that:
has more than one event type with occurences greater than the average occurences of that event type among all businesses.
활성 비즈니스를 찾는 SQL 쿼리를 작성하세요.
활성 비즈니스는 다음과 같습니다:
해당 이벤트 유형의 평균 발생 횟수보다 더 많이 발생하는 이벤트 유형이 두 개 이상 있습니다.


Example:
Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          | *
| 3           | reviews    | 3          |
| 1           | ads        | 11         | *
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         | *
+-------------+------------+------------+
Output: 
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+ 
Explanation: 
Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.
설명:
'reviews', 'ads' 및 'page views'의 평균은 각각 (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5입니다.
ID가 1인 비즈니스에는 'reviews' 이벤트가 7개(5개 이상)와 'ads' 이벤트가 11개(8개 이상) 있으므로 활성 비즈니스입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE EVENTS;
CREATE TABLE EVENTS (BUSINESS_ID INT, EVENT_TYPE VARCHAR(255), OCCURENCES INT);
INSERT INTO
	EVENTS (BUSINESS_ID, EVENT_TYPE, OCCURENCES)
VALUES
('1', 'REVIEWS', '7')
,('3', 'REVIEWS', '3')
,('1', 'ADS', '11')
,('2', 'ADS', '7')
,('3', 'ADS', '6')
,('1', 'PAGE VIEWS', '3')
,('2', 'PAGE VIEWS', '12');
SELECT * FROM EVENTS;

# [my practice]
select e.business_id
from 
events e left outer join
(select event_type, round(avg(occurences), 0) as avg_event
from events
group by event_type) ae
on e.event_type = ae.event_type
where occurences > avg_event
group by e.business_id
having count(e.business_id) >= 2;

# [PRACTICE]
SELECT EVENT_TYPE,
AVG(OCCURENCES) AVG_OCC
FROM EVENTS
GROUP BY EVENT_TYPE;
    
# [PRACTICE]
SELECT *
FROM EVENTS E
INNER JOIN
(
	SELECT EVENT_TYPE,
	AVG(OCCURENCES) AVG_OCC
	FROM EVENTS
	GROUP BY EVENT_TYPE
) AVGE
ON E.EVENT_TYPE = AVGE.EVENT_TYPE
WHERE E.OCCURENCES > AVGE.AVG_OCC; -- 'occurences greater than the average occurences of that event type'

# [MYSQL]
SELECT E.BUSINESS_ID
FROM EVENTS E
INNER JOIN
(
	SELECT EVENT_TYPE,
	AVG(OCCURENCES) AVG_OCC
	FROM EVENTS
	GROUP BY EVENT_TYPE
) AVGE
ON E.EVENT_TYPE = AVGE.EVENT_TYPE
WHERE E.OCCURENCES > AVGE.AVG_OCC -- 'occurences greater than the average occurences of that event type'
GROUP BY E.BUSINESS_ID
HAVING COUNT(E.BUSINESS_ID) >= 2; -- 'has more than one event type'
