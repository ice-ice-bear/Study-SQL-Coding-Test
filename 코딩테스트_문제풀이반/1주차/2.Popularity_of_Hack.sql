select fe.location, avg(fhs.popularity)
from facebook_employees fe inner join facebook_hack_survey fhs
on fe.id = fhs.employee_id
group by fe.location;