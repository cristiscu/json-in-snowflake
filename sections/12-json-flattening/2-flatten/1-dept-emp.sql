-- LATERAL JOIN
-- see https://stackoverflow.com/questions/65117654/difference-between-lateral-flatten-and-tableflatten-in-snowflake
use schema test.public;

-- w/ LATERAL FLATTEN(...)
select d.*, e.*, value
    from dept d INNER JOIN emp e ON e.dept_id = d.dept_id,
    lateral flatten(input => e.projects)
    order by e.emp_id;

-- w/ TABLE(FLATTEN(...)) - similar!
select d.*, e.*, value
    from dept d INNER JOIN emp e ON e.dept_id = d.dept_id,
    table(flatten(input => e.projects))
    order by e.emp_id;
