-- manually upload employees.csv, projects.csv and employee_projects.csv into new test.emps schema
use schema test.emps;

-- show many-to-many relationship w/ one row per each pair
select distinct employee_name, project_name
from employees e
    join employee_projects ep on e.employee_id = ep.employee_id
    join projects p on p.project_id = ep.project_id;

-- show employee w/ list of projects
select distinct employee_name,
    array_agg(project_name) over (partition by employee_name) as projects
from employees e
    join employee_projects ep on e.employee_id = ep.employee_id
    join projects p on p.project_id = ep.project_id
group by employee_name, project_name;

-- add additional column for a VARIANT ARRAY
alter table employees
    add column projects variant;

-- update the new column with the list of projects per employee
update employees e2
set projects = eproj.projects
from (
    select distinct employee_name,
        array_agg(project_name) over (partition by employee_name) as projects
    from employees e
        join employee_projects ep on e.employee_id = ep.employee_id
        join projects p on p.project_id = ep.project_id
    group by employee_name, project_name) eproj
where e2.employee_name = eproj.employee_name;
select * from employees;