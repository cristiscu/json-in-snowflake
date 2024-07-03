-- manually upload employees.csv, projects.csv and employee_projects.csv into new test.emps schema
use schema test.emps;

-- show many-to-many relationship w/ one row per each pair
select m.employee_name, e.employee_name
from employees e
    join employees m on e.manager_id = m.employee_id;

-- show employee w/ list of subordinates
with cte as (
    select m.employee_name manager, e.employee_name subordinate
    from employees e join employees m on e.manager_id = m.employee_id)
select distinct manager,
    array_agg(subordinate) over (partition by manager) as subordinates
from cte
group by manager, subordinate;

-- add additional column for a VARIANT ARRAY
alter table employees
    add column subordinates variant;

-- update the new column with the list of subordinates per employee
update employees e2
set subordinates = mans.subordinates
from (
    select distinct m.employee_name man_name,
        array_agg(e.employee_name) over (partition by man_name) as subordinates
    from employees e join employees m on e.manager_id = m.employee_id
    group by man_name, e.employee_name) mans
where e2.employee_name = mans.man_name;

select employee_name, subordinates
from employees;
