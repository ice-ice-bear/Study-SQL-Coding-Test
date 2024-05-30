/*
Several friends at a cinema ticket office would like to reserve consecutive available seats.
Can you help to query all the consecutive available seats order by the seat_id using the following seats table?
영화관 매표소에 있는 여러 친구가 연속된 좌석을 예약하고 싶어합니다.
다음 seats 테이블을 사용하여, 연속 사용 가능한 모든 좌석을 seat_id 순서대로 쿼리를 작성하세요.


Example:
Input: 
seats table:
+---------+------+
| seat_id | free |
|---------|------|
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output: 
+---------+
| seat_id |
|---------|
| 3       |
| 4       |
| 5       |
+---------+
Note: 
The seat_id is an auto increment integer, and free is bool (1 means free, and 0 means occupied.).
Consecutive available seats are more than 2(inclusive) seats consecutively available.
메모:
seat_id는 자동 증가 integer이고 free는 bool입니다(1은 비어 있음을 의미하고 0은 점유를 의미함).
연속 이용 가능 좌석은 2석 이상 연속 이용 가능 좌석입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE SEATS;
CREATE TABLE SEATS (SEAT_ID INT, FREE INT);
INSERT INTO
	SEATS (SEAT_ID, FREE)
VALUES
	('1', '1')
	,('2', '0')
	,('3', '1')
	,('4', '1')
	,('5', '1');
SELECT * FROM SEATS;

# [my practice]
select seat_id
from (select seat_id, free,
lag(free) over(order by seat_id) as pre_free,
lead(free) over(order by seat_id) as post_free
from seats
order by seat_id) pre_post
where (free =1 and pre_free = 1) or (free =1 and post_free = 1) 
order by seat_id;

# [KEY]
# 'consecutive': (1) 이전 좌석과 지금 좌석 비교, (2) 지금 좌석과 이후 좌석 비교

# [PRACTICE]
SELECT SEAT_ID,
LAG(FREE) OVER (ORDER BY SEAT_ID) PREV_FREE,
FREE,
LEAD(FREE) OVER (ORDER BY SEAT_ID) POST_FREE
FROM SEATS
ORDER BY SEAT_ID;

# [MYSQL]
SELECT SEAT_ID
FROM
(
	SELECT SEAT_ID,
	LAG(FREE) OVER (ORDER BY SEAT_ID) PREV_FREE,
    FREE,
    LEAD(FREE) OVER (ORDER BY SEAT_ID) POST_FREE
	FROM SEATS
) S
WHERE (PREV_FREE=1 AND FREE=1) OR (FREE=1 AND POST_FREE=1);