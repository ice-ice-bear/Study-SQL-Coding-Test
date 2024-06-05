select c.first_name, c.last_name, c.city, o.order_details
from customers c left outer join orders o
on c.id = o.cust_id
order by c.first_name asc ,o.order_details asc;