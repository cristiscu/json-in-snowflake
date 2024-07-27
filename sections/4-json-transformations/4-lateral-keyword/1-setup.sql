-- create TEST.EMPS2 schema
create schema if not exists test.emps2;
use schema test.emps2;

create or replace table dept (dept_id int, name string) as
select * from values (1, 'Engineering'), (2, 'Support'), (3, 'Finance'), (4, 'HR');

create or replace table emp (
  emp_id int,
  name string,
  dept_id int,
  projects variant);

insert into emp
select 1, 'John', 1, ['IT', 'Prod']
union select 2, 'Mary', 1, ['PS', 'Prod Support']
union select 3, 'Bob', 2, null
union select 4, 'Jack', null, null;

select * from emp;