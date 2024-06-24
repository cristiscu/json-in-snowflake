select d.*, e.*
  from dept d inner join emp e ON e.dept_id = d.dept_id
  order by e.emp_id;

select *
  from dept d, lateral (select * from emp e where e.dept_id = d.dept_id) 
  order by emp_id;
