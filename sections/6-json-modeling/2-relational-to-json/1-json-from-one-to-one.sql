-- manually upload employees.csv, projects.csv and employee_projects.csv into new test.emps schema
use schema test.emps;

select e.*, m.*
from employees e join employees m on e.manager_id = m.employee_id;

-- add manager column
alter table employees
    add column manager object;

-- update manager w/ JSON OBJECT w/ additional props of the manager
update employees e2
set manager = object_construct(
    'phone_number', man.phone_number,
    'hire_date', man.hire_date,
    'salary', man.salary,
    'job', man.job,
    'department', man.department)
from (select e.employee_id, m.phone_number, m.hire_date, m.salary, m.job, m.department
    from employees e join employees m on e.manager_id = m.employee_id) man
where e2.employee_id = man.employee_id;
select * from employees;

-- show only employees whose managers have their manager(s) in the PRESIDENCE department
select * from employees
where manager:department = 'PRESIDENCE';
