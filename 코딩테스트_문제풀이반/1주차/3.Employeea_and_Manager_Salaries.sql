select a.first_name as employee_name, a.salary as employee_salary 
from employee a inner join employee b
on a.manager_id = b.id
where a.salary > b.salary;