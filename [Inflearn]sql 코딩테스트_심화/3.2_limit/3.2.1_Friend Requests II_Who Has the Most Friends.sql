/*
https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/

Table: RequestAccepted
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
(requester_id, accepter_id)는 이 테이블의 기본 키입니다.
이 테이블에는 요청을 보낸 사용자의 ID, 요청을 받은 사용자의 ID, 요청이 수락된 날짜가 포함되어 있습니다.


Write an SQL query to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.
친구 수가 가장 많은 사람과 그 친구 수를 찾는 SQL 쿼리를 작성하세요.
테스트 케이스는 한 사람만이 가장 많은 친구를 갖도록 생성됩니다.

Example:
Input: 
RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
+--------------+-------------+-------------+
Output: 
+----+-----+
| id | num |
+----+-----+
| 3  | 3   |
+----+-----+
Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.
설명: ID가 3인 사람은 1, 2, 4의 친구이므로 친구가 총 3명으로 가장 많은 친구를 가지고 있습니다.

Follow up: In the real world, multiple people could have the same most number of friends.
Could you find all these people in this case?
후속 조치: 현실 세계에서는 여러 사람이 동일한 수의 친구를 가질 수 있습니다.
이 경우에 이 사람들을 모두 찾을 수 있나요?
*/

# [SETTING]
USE PRACTICE;
DROP TABLE RequestAccepted;
CREATE TABLE RequestAccepted (REQUESTER_ID INT, ACCEPTER_ID INT, ACCEPT_DATE DATE);
INSERT INTO
	RequestAccepted (REQUESTER_ID, ACCEPTER_ID, ACCEPT_DATE)
VALUES
('1', '2', '2016-06-03')
,('1', '3', '2016-06-08')
,('2', '3', '2016-06-08')
,('3', '4', '2016-06-09');
SELECT * FROM RequestAccepted;

select id, f_count as num
from
(select *,
rank() over(order by f_count desc) as many_f
from
(select id, sum(count) as f_count
from ((select requester_id as id, count(requester_id) as count
from requestaccepted
group by requester_id)
union all
(select accepter_id as id, count(accepter_id) as count 
from requestaccepted
group by accepter_id)) friends
group by id) count_friends) celeb
where many_f = 1;

# [my practice] - use limit
select id, sum(count) as num
from ((select requester_id as id, count(requester_id) as count
from requestaccepted
group by requester_id)
union all
(select accepter_id as id, count(accepter_id) as count 
from requestaccepted
group by accepter_id)) friends
group by id
order by num desc
limit 1;

# [PRACTICE1]
SELECT REQUESTER_ID AS ID -- union all/union 사용할 경우 컬럼명 같아야 된다.
FROM RequestAccepted

UNION ALL -- 중복 row 모두 포함 (참고: union은 unique row만 포함)

SELECT ACCEPTER_ID AS ID -- union all/union 사용할 경우 컬럼명 같아야 된다.
FROM RequestAccepted;
    
# [MYSQL1]
# order by, limit 1: 'The test cases are generated so that only one person has the most friends'
SELECT ID,
COUNT(ID) NUM
FROM
(
	SELECT REQUESTER_ID AS ID
	FROM RequestAccepted
	UNION ALL
	SELECT ACCEPTER_ID AS ID
	FROM RequestAccepted
) A
GROUP BY ID
ORDER BY NUM DESC
LIMIT 1;

# [FOLLOW-UP]
# rank: 'multiple people could have the same most number of friends'

# [PRACTICE2]
SELECT ID,
COUNT(ID) NUM,
RANK() OVER (ORDER BY COUNT(ID) DESC) RNK # GROUP BY ID를 썼기 때문에, COUNT(ID) 사용 가능
FROM
(
	SELECT REQUESTER_ID AS ID
	FROM RequestAccepted
	UNION ALL
	SELECT ACCEPTER_ID AS ID
	FROM RequestAccepted
) A
GROUP BY ID;

# [MYSQL2]
# rank
SELECT ID,
NUM
FROM
(
	SELECT ID,
	COUNT(ID) NUM,
	RANK() OVER (ORDER BY COUNT(ID) DESC) RNK # GROUP BY ID를 썼기 때문에, COUNT(ID) 사용 가능
	FROM
	(
		SELECT REQUESTER_ID AS ID
		FROM RequestAccepted
		UNION ALL
		SELECT ACCEPTER_ID AS ID
		FROM RequestAccepted
	) A
	GROUP BY ID
) B
WHERE RNK=1;