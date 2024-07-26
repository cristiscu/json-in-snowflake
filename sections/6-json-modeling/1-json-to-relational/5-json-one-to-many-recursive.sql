-- JSON w/ recursive nested ARRAYs (unknown tree depth!)
use schema test.public;

-- get all parent-child relationships, w/ recursive CTE
with recursive cte as (
    select null as parent, v:name::string as child, v as path
    from employees_json
    union all
    select cte.child, child.value:name::string, child.value
    from cte, table(flatten(cte.path:employees)) child)
select * from cte;

-- create relational table from the same result
create or replace table employees_rel(parent string, child string) as
with recursive cte as (
    select null as parent, v:name::string as child, v as path
    from employees_json
    union all
    select cte.child, child.value:name::string, child.value
    from cte, table(flatten(cte.path:employees)) child)
select parent, child from cte;
select * from employees_rel;
