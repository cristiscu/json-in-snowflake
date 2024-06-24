create database json;

create table emp (
  emp_id int,
  name string(10),
  dept_id int,
  projects variant
);
create table dept (
  dept_id int,
  name string(20)
);

insert into dept values (1, 'Engineering'), (2, 'Support'), (3, 'Finance');

insert into emp select 1, 'John', 1, ARRAY_CONSTRUCT('IT', 'Prod');
insert into emp select 2, 'Mary', 1, ARRAY_CONSTRUCT('PS', 'Prod Support');
insert into emp select 3, 'Bob', 2, null;
insert into emp select 4, 'Jack', null, null;
