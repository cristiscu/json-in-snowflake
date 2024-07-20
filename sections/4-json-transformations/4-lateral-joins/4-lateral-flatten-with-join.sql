-- LATERAL FLATTEN(...) vs TABLE(FLATTEN(...))
-- see https://stackoverflow.com/questions/65117654/difference-between-lateral-flatten-and-tableflatten-in-snowflake
use schema test.emps2;

-- (1) w/ TABLE(FLATTEN(...))
select d.*, e.*, p.value
from dept d
    inner join emp e on e.dept_id = d.dept_id,
    table(flatten(input => e.projects)) p
order by e.emp_id;

-- (2) w/ LATERAL FLATTEN(...) <-- equivalent!
select d.*, e.*, p.value
from dept d
    inner join emp e on e.dept_id = d.dept_id,
    lateral flatten(input => e.projects) p
order by e.emp_id;

