/*
survey table columns: uid, action, question_id, answer_id, q_num, timestamp
- uid means user id.
- action has these kind of values: how, answer, skip.
- answer_id is not null when action column is answer, while is null for how and skip.
- q_num is the numeral order of the question in current session.
survey 테이블 열: uid, action, question_id, answer_id, q_num, timestamp
- uid는 사용자 ID를 의미합니다.
- action에는 다음과 같은 값이 있습니다: how, answer, skip;
- answer_id는 action 열이 answer인 경우 null이 아니며, how 및 skip인 경우 null입니다.
- q_num은 현재 세션의 문제 번호 순서입니다.


Write a sql query to identify the question which has the highest answer rate.
응답률이 가장 높은 질문을 식별하는 SQL 쿼리를 작성하세요.

Example:
Input:
+------+-----------+--------------+------------+-----------+------------+
| uid  | action    | question_id  | answer_id  | q_num     | timestamp  |
+------+-----------+--------------+------------+-----------+------------+
| 5    | show      | 285          | null       | 1         | 123        |
| 5    | answer    | 285          | 124124     | 1         | 124        |
| 5    | show      | 369          | null       | 2         | 125        |
| 5    | skip      | 369          | null       | 2         | 126        |
+------+-----------+--------------+------------+-----------+------------+
Output:
+-------------+
| survey_log  |
+-------------+
|    285      |
+-------------+
Explanation: question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
Note: The highest answer rate meaning is: answer number's ratio in show number in the same question.
설명: 질문 285의 답변률은 1/1이고 질문 369의 답변률은 0/1이므로 285가 출력됩니다.
참고: 가장 높은 답변률 의미는 동일한 질문에 표시되는 답변 번호의 비율입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE SURVEY;
CREATE TABLE SURVEY (U_ID INT, ACTION VARCHAR(255), QUESTION_ID INT, ANSWER_ID INT, Q_NUM INT, TIMESTAMPS INT);
INSERT INTO
	SURVEY (U_ID, ACTION, QUESTION_ID, ANSWER_ID, Q_NUM, TIMESTAMPS)
VALUES
('5', 'SHOW', '285', NULL, '1', '123')
,('5', 'ANSWER', '285', '124124', '1', '124')
,('5', 'SHOW', '369', NULL, '2', '125')
,('5', 'SKIP', '369', NULL, '2', '126');
SELECT * FROM SURVEY;

# [my pracice]
select q_id as survey_log
from
	(select question.question_id as q_id, count(question.question_id) as a_count
	from
		(select action, question_id, answer_id, q_num
		from survey
		where action = 'show') question
		inner join
		(select action, question_id, answer_id, q_num
		from survey
		where action = 'answer') answer
	on question.question_id = answer.question_id
	group by question.question_id) q_rate
order by a_count desc
limit 1;    

# [PRACTICE]
SELECT QUESTION_ID,
COUNT(CASE WHEN ACTION = 'ANSWER' THEN 1 END)/COUNT(CASE WHEN ACTION = 'SHOW' THEN 1 END) RATIO
FROM SURVEY
GROUP BY QUESTION_ID;
        
#[MYSQL1]
# rank
SELECT QUESTION_ID
FROM
(
	SELECT QUESTION_ID,
	RATIO,
	RANK() OVER (ORDER BY RATIO DESC) RNK_RATIO
	FROM
	(
		SELECT QUESTION_ID,
		COUNT(CASE WHEN ACTION = 'ANSWER' THEN 1 END)/COUNT(CASE WHEN ACTION = 'SHOW' THEN 1 END) RATIO
		FROM SURVEY
		GROUP BY QUESTION_ID
	) A
) B
WHERE RNK_RATIO=1;


#[MYSQL2]
# order by, limit 1
SELECT QUESTION_ID
FROM
(
	SELECT QUESTION_ID,
	COUNT(CASE WHEN ACTION = 'ANSWER' THEN 1 END)/COUNT(CASE WHEN ACTION = 'SHOW' THEN 1 END) RATIO
	FROM SURVEY
	GROUP BY QUESTION_ID
) A
ORDER BY RATIO DESC
LIMIT 1;
