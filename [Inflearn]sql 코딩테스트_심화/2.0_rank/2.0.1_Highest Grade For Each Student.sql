/*
Table: Enrollments
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.
(student_id,course_id)는 이 테이블의 기본 키입니다.


Write a SQL query to find the highest grade with its corresponding course for each student. 
In case of a tie, you should find the course with the smallest course_id.
The output must be sorted by increasing student_id.
각 학생에 대해서, 최고 성적과 그 최고 성적의 과목을 찾는 SQL 쿼리를 작성하세요.
동점인 경우에는 course_id가 가장 작은 강좌를 찾으세요.
출력은 student_id 오름차순으로 정렬하세요.


Example:
Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+
Output: 
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE ENROLLMENTS;
CREATE TABLE ENROLLMENTS (STUDENT_ID INT, COURSE_ID INT, GRADE INT);
INSERT INTO
	ENROLLMENTS (STUDENT_ID, COURSE_ID, GRADE)
VALUES
('2','2','95')
,('2','3','95') -- 2번 학생의 동률 데이터: 'In case of a tie, you should find the course with the smallest course_id'
,('1','1','90')
,('1','2','99')
,('3','1','80')
,('3','2','75')
,('3','3','82'); 
SELECT * FROM ENROLLMENTS;

#[my practice - max/min]
select e.student_id, min(e.course_id) as course_id , e.grade #group by에 course_id가 들어가지 않아도 산술연산자로 위와 같이 묶을 수 있다
from enrollments e inner join
(select student_id, max(grade) as grade
from enrollments 
group by student_id) max_g
on e.student_id = max_g.student_id 
and e.grade = max_g.grade
group by e.student_id, e.grade
order by e.student_id;


# [my practice - rank]
select student_id, min(course_id) as course_id, grade
from(select student_id, 
course_id,
# rank조건에 grade에 더해 course_id를 같은 점수여도 더하면 두 값이 동률이 아니다  
rank() over(partition by student_id order by grade desc) as rank_grade, 
grade
from enrollments) rk
where rank_grade = 1
group by student_id, grade 
order by student_id;

select student_id, 
course_id,
rank() over(partition by student_id order by grade desc) as rank_grade,
grade
from enrollments;

# [PRACTICE1]
SELECT STUDENT_ID,
MAX(GRADE) MAX_GRADE
FROM ENROLLMENTS
GROUP BY STUDENT_ID
ORDER BY STUDENT_ID;
    
# [MYSQ1]
# max
SELECT E.STUDENT_ID,
MIN(E.COURSE_ID) AS COURSE_ID, -- 'In case of a tie, you should find the course with the smallest course_id'
E.GRADE
FROM ENROLLMENTS E
INNER JOIN
(
	SELECT STUDENT_ID,
	MAX(GRADE) MAX_GRADE -- 'find the highest grade'
	FROM ENROLLMENTS
	GROUP BY STUDENT_ID
) T
ON E.STUDENT_ID = T.STUDENT_ID
AND E.GRADE = T.MAX_GRADE
GROUP BY E.STUDENT_ID, E.GRADE
ORDER BY E.STUDENT_ID;

# [PRACTICE2]
SELECT STUDENT_ID,
GRADE,
COURSE_ID,
RANK() OVER (PARTITION BY STUDENT_ID ORDER BY GRADE DESC, COURSE_ID) RNK_GRADE
FROM ENROLLMENTS
ORDER BY STUDENT_ID, GRADE DESC, COURSE_ID;
    
# [MYSQ2]
# rank
SELECT STUDENT_ID,
COURSE_ID,
GRADE
FROM
(
	SELECT STUDENT_ID,
	COURSE_ID,
	GRADE,
	RANK() OVER (PARTITION BY STUDENT_ID ORDER BY GRADE DESC, COURSE_ID) RNK_GRADE
	FROM ENROLLMENTS
) E
WHERE RNK_GRADE =1
ORDER BY STUDENT_ID;
