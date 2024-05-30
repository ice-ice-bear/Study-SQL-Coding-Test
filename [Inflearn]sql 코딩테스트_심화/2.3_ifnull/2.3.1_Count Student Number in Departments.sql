/*
Table: student
+--------------+-----------+
| Column Name  | Type      |
|--------------|-----------|
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |
+--------------+-----------+
student_id is the student ID number, 
student_name is the student name, 
gender is their gender, 
and dept_id is the department ID associated with their declared major.
student_id는 학생 ID 번호입니다.
student_name은 학생 이름입니다.
성별은 그들의 성별이고,
dept_id는 선언된 전공과 관련된 학과 ID입니다.


Table: department
+-------------+---------+
| Column Name | Type    |
|-------------|---------|
| dept_id     | Integer |
| dept_name   | String  |
+-------------+---------+
dept_id is the department ID number 
and dept_name is the department name.
dept_id는 부서 ID 번호입니다.
dept_name은 부서 이름입니다.


A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.
Write a query to print the respective department name and number of students majoring in each department for all departments in the department table 
(even ones with no current students).
Sort your results by descending number of students; 
if two or more departments have the same number of students, then sort those departments alphabetically by department name.
대학에서는 student과 department라는 2개의 테이블을 사용하여 학생과 각 전공과 관련된 학과에 대한 데이터를 저장합니다.
department 테이블에 있는 모든 학과명과 각 학과 전공 학생 수를 출력하는 쿼리를 작성하세요. (현재 학생이 없는 경우에도)
학생 수 내림차순으로 정렬합니다.
둘 이상의 학과에 동일한 수의 학생이 있는 경우, 학과 이름을 기준으로 알파벳순으로 정렬합니다.


Example:
Input: 
student table:
+------------+--------------+--------+---------+
| student_id | student_name | gender | dept_id |
|------------|--------------|--------|---------|
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
+------------+--------------+--------+---------+
department table:
+---------+-------------+
| dept_id | dept_name   |
|---------|-------------|
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
+---------+-------------+
Output: 
+-------------+----------------+
| dept_name   | student_number |
|-------------|----------------|
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |
+-------------+----------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE STUDENT;
CREATE TABLE STUDENT (STUDENT_ID INT, STUDENT_NAME VARCHAR(255), GENDER VARCHAR(255), DEPT_ID INT);
INSERT INTO
	STUDENT (STUDENT_ID, STUDENT_NAME, GENDER, DEPT_ID)
VALUES
('1', 'JACK', 'M', '1')
,('2', 'JANE', 'F', '1')
,('3', 'MARK', 'M', '2');
SELECT * FROM STUDENT;

# [SETTING]
USE PRACTICE;
DROP TABLE DEPARTMENT;
CREATE TABLE DEPARTMENT (DEPT_ID INT, DEPT_NAME VARCHAR(255));
INSERT INTO
	DEPARTMENT (DEPT_ID, DEPT_NAME)
VALUES
('1', 'ENGINEERING')
,('2', 'SCIENCE')
,('3', 'LAW');
SELECT * FROM DEPARTMENT;

# [my practice]
select dept_name, count(student_id) as student_number
from student s right outer join department d
on s.dept_id = d.dept_id
group by d.dept_name;

# [PRACTICE]
SELECT COUNT(STUDENT_ID) STUDENT_CNT,
DEPT_ID
FROM STUDENT
GROUP BY DEPT_ID;

# [PRACTICE]
SELECT D.DEPT_NAME,
S.STUDENT_CNT -- 전공하는 학생이 없다면, null로 존재
FROM DEPARTMENT D
LEFT OUTER JOIN
(
	SELECT COUNT(STUDENT_ID) STUDENT_CNT,
	DEPT_ID
	FROM STUDENT
	GROUP BY DEPT_ID
) S
ON D.DEPT_ID = S.DEPT_ID;

# [MYSQL]
SELECT D.DEPT_NAME,
IFNULL(S.STUDENT_CNT, 0) STUDENT_NUMBER -- '(even ones with no current students)'
FROM DEPARTMENT D
LEFT OUTER JOIN
(
	SELECT COUNT(STUDENT_ID) STUDENT_CNT,
	DEPT_ID
	FROM STUDENT
	GROUP BY DEPT_ID
) S
ON D.DEPT_ID = S.DEPT_ID;