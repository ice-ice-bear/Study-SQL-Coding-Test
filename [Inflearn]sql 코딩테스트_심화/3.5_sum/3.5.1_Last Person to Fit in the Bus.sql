/*
https://leetcode.com/problems/last-person-to-fit-in-the-bus/

Table: Queue
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
weight is the weight of the person in kilograms.
person_id는 이 테이블의 기본 키 열입니다.
이 테이블에는 버스를 기다리는 모든 사람들의 정보가 나와 있습니다.
person_id 및 turn 열에는 1부터 n까지의 모든 숫자가 포함됩니다. 여기서 n은 테이블의 행 수입니다.
turn은 사람들이 버스에 탑승할 순서를 결정합니다. 여기서 turn=1은 가장 먼저 탑승하는 사람을 나타내고 turn=n은 마지막에 탑승하는 사람을 나타냅니다.
weight은 사람의 체중을 킬로그램으로 나타낸 것입니다.


There is a queue of people waiting to board a bus.
However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit.
The test cases are generated such that the first person does not exceed the weight limit.
버스를 타기 위해 사람들이 줄을 서고 있습니다.
다만, 버스의 무게 제한은 1000kg이므로 탑승하지 못하는 분들도 있을 수 있습니다.
무게 제한을 초과하지 않고 버스에 탑승할 수 있는 마지막 사람의 person_name을 찾는 SQL 쿼리를 작성하세요.
첫 번째 사람이 무게 제한을 초과하지 않도록 테스트 케이스가 생성됩니다.


Example:
Input: 
Queue table:
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
Output: 
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
Explanation: The folowing table is ordered by the turn for simplicity.
설명: 다음 표는 단순화를 위해 차례대로 정렬되었습니다.
+------+----+-----------+--------+--------------+
| Turn | ID | Name      | Weight | Total Weight |
+------+----+-----------+--------+--------------+
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000         | (last person to board)
| 4    | 2  | Marie     | 200    | 1200         | (cannot board)
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |
+------+----+-----------+--------+--------------+
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Queue;
CREATE TABLE Queue (person_id int, person_name varchar(30), weight int, turn int);
INSERT INTO
	Queue (person_id, person_name, weight, turn)
VALUES
('5', 'Alice', '250', '1')
,('4', 'Bob', '175', '5')
,('3', 'Alex', '350', '2')
,('6', 'John Cena', '400', '3')
,('1', 'Winston', '500', '6')
,('2', 'Marie', '200', '4');
SELECT * FROM Queue;

# [my practice]
select person_name
from(
	select turn, person_name, weight,
	sum(weight) over(order by turn) as total_weight #누적 합 구하기 좋은 쿼리문!!!
	from queue
	order by turn) w
where total_weight <= 1000
order by total_weight desc
limit 1;


# [PRACTICE]
select turn,
person_name,
weight,
sum(weight) over (order by turn) acc_weight
from Queue
order by turn;

# [MYSQL]
select person_name
from
(
	select person_name,
	sum(weight) over (order by turn) acc_weight
	from Queue
) A
where acc_weight <= 1000
order by acc_weight desc
limit 1;