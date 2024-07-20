-- LATERAL FLATTEN(...) vs TABLE(FLATTEN(...))
-- see https://stackoverflow.com/questions/65117654/difference-between-lateral-flatten-and-tableflatten-in-snowflake
use schema test.emps2;

-- (1) w/ TABLE(FLATTEN(...))
select name, projects
from emp;

select name, value
from emp, table(flatten(projects));

select name, value
from emp, table(flatten(input => projects, outer => true));

-- (2) w/ LATERAL FLATTEN(...) <-- equivalent!
select name, value
from emp, lateral flatten(projects);

select name, value
from emp, lateral flatten(input => projects, outer => true);
