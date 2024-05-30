/*
https://leetcode.com/problems/find-total-time-spent-by-each-employee/ 

Table: Employees
+-------------+------+
| Column Name | Type |
+-------------+------+
| emp_id      | int  |
| event_day   | date |
| in_time     | int  |
| out_time    | int  |
+-------------+------+
(emp_id, event_day, in_time) is the primary key of this table.
The table shows the employees' entries and exits in an office.
event_day is the day at which this event happened, in_time is the minute at which the employee entered the office, and out_time is the minute at which they left the office.
in_time and out_time are between 1 and 1440.
It is guaranteed that no two events on the same day intersect in time, and in_time < out_time.
(emp_id, event_day, in_time)은 이 테이블의 기본 키입니다.
테이블에는 직원의 사무실 출입이 표시됩니다.
event_day는 해당 이벤트가 발생한 날, in_time은 직원이 사무실에 들어온 시간(분), out_time은 사무실을 떠난 시간(분)입니다.
in_time 및 out_time은 1에서 1440 사이입니다.
같은 날의 두 이벤트가 시간적으로 교차하지 않고 in_time < out_time이 보장됩니다.


Write an SQL query to calculate the total time in minutes spent by each employee on each day at the office.
Note that within one day, an employee can enter and leave more than once.
The time spent in the office for a single entry is out_time - in_time.
Return the result table in any order.
각 직원이 매일 사무실에서 보낸 총 시간을 분 단위로 계산하는 SQL 쿼리를 작성하세요.
직원은 하루 동안 두 번 이상 출입할 수 있습니다.
단일 항목에 대해 사무실에서 보낸 시간은 out_time - in_time입니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Employees table:
+--------+------------+---------+----------+
| emp_id | event_day  | in_time | out_time |
+--------+------------+---------+----------+
| 1      | 2020-11-28 | 4       | 32       |
| 1      | 2020-11-28 | 55      | 200      |
| 1      | 2020-12-03 | 1       | 42       |
| 2      | 2020-11-28 | 3       | 33       |
| 2      | 2020-12-09 | 47      | 74       |
+--------+------------+---------+----------+
Output: 
+------------+--------+------------+
| day        | emp_id | total_time |
+------------+--------+------------+
| 2020-11-28 | 1      | 173        |
| 2020-11-28 | 2      | 30         |
| 2020-12-03 | 1      | 41         |
| 2020-12-09 | 2      | 27         |
+------------+--------+------------+
Explanation: 
Employee 1 has three events: two on day 2020-11-28 with a total of (32 - 4) + (200 - 55) = 173, and one on day 2020-12-03 with a total of (42 - 1) = 41.
Employee 2 has two events: one on day 2020-11-28 with a total of (33 - 3) = 30, and one on day 2020-12-09 with a total of (74 - 47) = 27.
설명:
직원 1에는 3개의 이벤트가 있습니다. 2020-11-28일에 2개(총 (32 - 4) + (200 - 55) = 173), 2020-12-03에 1개(총 (42 - 1)) = 41.
직원 2에는 두 개의 이벤트가 있습니다. 하나는 2020-11-28일에 총 (33 - 3) = 30이고 다른 하나는 2020-12-09에 총 (74 - 47) = 27입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Employees;
CREATE TABLE Employees(emp_id int, event_day date, in_time int, out_time int);
INSERT INTO
	Employees (emp_id, event_day, in_time, out_time)
VALUES
('1', '2020-11-28', '4', '32')
,('1', '2020-11-28', '55', '200')
,('1', '2020-12-3', '1', '42')
,('2', '2020-11-28', '3', '33')
,('2', '2020-12-9', '47', '74');
SELECT * FROM Employees;

#[my practice]
select event_day as day, emp_id, sum(out_time - in_time) as total_time
from employees
group by event_day, emp_id;


# [MYSQL]
select event_day as day,
emp_id,
sum(out_time)-sum(in_time) as total_time
from Employees
group by event_day, emp_id;