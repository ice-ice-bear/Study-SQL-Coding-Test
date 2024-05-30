/*
https://leetcode.com/problems/average-time-of-process-per-machine/ 

Table: Activity
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
표에는 공장 웹사이트에 대한 사용자 활동이 나와 있습니다.
(machine_id, process_id, activity_type)은 이 테이블의 기본 키입니다.
machine_id는 머신의 ID입니다.
process_id는 ID가 machine_id인 머신에서 실행 중인 프로세스의 ID입니다.
activity_type은 ('start', 'end') 유형의 ENUM입니다.
timestamp는 현재 시간을 초 단위로 나타내는 부동소수점입니다.
'start'는 기계가 주어진 타임스탬프에서 프로세스를 시작한다는 것을 의미하고 'end'는 기계가 주어진 타임스탬프에서 프로세스를 종료한다는 것을 의미합니다.
'start' 타임스탬프는 모든 (machine_id, process_id)쌍에 대한 'end' 이전 타임스탬프입니다.


There is a factory website that has several machines each running the same number of processes.
Write an SQL query to find the average time each machine takes to complete a process.
The time to complete a process is the 'end' timestamp minus the 'start' timestamp.
The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.
Return the result table in any order.
각각 동일한 수의 프로세스를 실행하는 여러 컴퓨터가 있는 공장 웹사이트가 있습니다.
각 기계가 프로세스를 완료하는 데 걸리는 평균 시간을 알아보려면 SQL 쿼리를 작성하세요.
프로세스를 완료하는 데 걸리는 시간은 'end' 타임스탬프에서 'start' 타임스탬프를 뺀 시간입니다.
평균 시간은 컴퓨터의 모든 프로세스를 완료하는 데 걸린 총 시간을 실행된 프로세스 수로 나누어 계산합니다.
결과 테이블에는 machine_id와 함께 평균 시간인 processing_time이 있어야 하며 소수점 이하 3자리에서 반올림되어야 합니다.
어떤 순서로든 결과 테이블을 반환합니다.


Example:
Input: 
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
Output: 
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
Explanation: 
There are 3 machines running 2 processes each.
Machine 0's average time is ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
Machine 1's average time is ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
Machine 2's average time is ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456
설명:
각각 2개의 프로세스를 실행하는 3개의 머신이 있습니다.
머신 0의 평균 시간은 ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894입니다.
머신 1의 평균 시간은 ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995입니다.
머신 2의 평균 시간은 ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456입니다.
*/

# [SETTING]
USE PRACTICE;
DROP TABLE Activity;
CREATE TABLE Activity (machine_id int, process_id int, activity_type ENUM('start', 'end'), timestamp float);
INSERT INTO
	Activity (machine_id, process_id, activity_type, timestamp)
VALUES
('0', '0', 'start', '0.712')
,('0', '0', 'end', '1.52')
,('0', '1', 'start', '3.14')
,('0', '1', 'end', '4.12')
,('1', '0', 'start', '0.55')
,('1', '0', 'end', '1.55')
,('1', '1', 'start', '0.43')
,('1', '1', 'end', '1.42')
,('2', '0', 'start', '4.1')
,('2', '0', 'end', '4.512')
,('2', '1', 'start', '2.5')
,('2', '1', 'end', '5');
SELECT * FROM Activity;

# [my practice]
select machine_id,
round((sum(case when activity_type = 'end' then timestamp end) -sum(case when activity_type = 'start' then timestamp end))/count(distinct process_id),3)  as processing_time
from activity
group by machine_id;

# [MYSQL]
select machine_id,
round((sum(case when activity_type='end' then timestamp end)-sum(case when activity_type='start' then timestamp end))/count(distinct process_id), 3) processing_time 
from Activity
group by machine_id;