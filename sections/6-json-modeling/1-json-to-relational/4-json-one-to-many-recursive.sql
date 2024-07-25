-- we have some JSON w/ recursive objects (unknown tree depth!)
using test.public;

select * from employees_json;

-- get all parent-child relationships, w/ recursive CTE
with recursive cte as (
    select v:name::string as parent, null as child, v as obj
    from employees_json
    union all
    select child.value:name::string, cte.parent, child.value
    from cte, table(flatten(cte.obj:employees)) child)
select * from cte;

-- create relational table from the same result
create or replace table employees_rel(parent string, child string) as
with recursive cte as (
    select v:name::string as parent, null as child, v as obj
    from employees_json
    union all
    select child.value:name::string, cte.parent, child.value
    from cte, table(flatten(cte.obj:employees)) child)
select parent, child from cte;
select * from employees_rel;
