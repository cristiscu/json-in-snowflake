-- LATERAL with JOIN
use schema test.emps2;

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