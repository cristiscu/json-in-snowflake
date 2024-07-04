-- LATERAL JOIN
-- see https://stackoverflow.com/questions/65117654/difference-between-lateral-flatten-and-tableflatten-in-snowflake
use schema test.public;

create or replace table dept (dept_id int, name string) as
select * from values (1, 'Engineering'), (2, 'Support'), (3, 'Finance'), (4, 'HR');

create or replace table emp (
  emp_id int,
  name string,
  dept_id int,
  projects variant);

insert into emp
select 1, 'John', 1, ARRAY_CONSTRUCT('IT', 'Prod')
union
select 2, 'Mary', 1, ARRAY_CONSTRUCT('PS', 'Prod Support')
union
select 3, 'Bob', 2, null
union
select 4, 'Jack', null, null;

-- =================================================================

-- ok, w/ LATERAL join
select *
  from dept d, lateral (select * from emp e where e.dept_id = d.dept_id) 
  order by emp_id;

-- equivalent w/ INNER JOIN LATERAL join
select *
  from dept d inner join lateral (select * from emp e where e.dept_id = d.dept_id) 
  order by emp_id;

-- LEFT join ignored!
select *
  from dept d left join lateral (select * from emp e where e.dept_id = d.dept_id) 
  order by emp_id;

-- this fails
select *
  from dept d, (select * from emp e where e.dept_id = d.dept_id) ee
  order by emp_id;

-- equivalent w/ INNER JOIN
select d.*, e.*
  from dept d inner join emp e ON e.dept_id = d.dept_id
  order by e.emp_id;

-- correct LEFT join (better!)
select d.*, e.*
  from dept d left join emp e ON e.dept_id = d.dept_id
  order by e.emp_id;

