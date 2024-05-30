/*
https://leetcode.com/problems/fix-names-in-a-table/ 

Table: Users
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key for this table.
This table contains the ID and the name of the user.
The name consists of only lowercase and uppercase characters.
user_id는 이 테이블의 기본 키입니다.
이 테이블에는 사용자의 ID와 이름이 포함되어 있습니다.
이름은 소문자와 대문자로만 구성됩니다.


Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id.
첫 번째 문자만 대문자이고 나머지는 소문자로 표시되도록 이름을 수정하는 SQL 쿼리를 작성하세요.
user_id순으로 정렬된 결과 테이블을 반환합니다.


Example:
Input: 
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
Output: 
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Users;
CREATE TABLE Users (user_id int, name varchar(40));
INSERT INTO
	Users (user_id, name)
VALUES
('1', 'aLice')
,('2', 'bOB');
SELECT * FROM Users;

#[my practice]
select user_id,
concat(upper(substr(name, 1, 1)), lower(substr(name, 2)))
from users;

# [KEY]
# substr(string, start_index, length)
# 조심: 첫번째 문자의 start_index=1
# length를 안쓰면, start_index부터 끝까지 가져온다.

# [MYSQL]
select user_id,
CONCAT(UPPER(SUBSTR(name,1,1)),LOWER(SUBSTR(name,2))) name
from Users
order by user_id;
