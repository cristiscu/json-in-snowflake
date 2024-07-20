-- Dynamic UNPIVOT (or MELT)
-- see https://stackoverflow.com/questions/68553105/is-there-a-melt-command-in-snowflake
-- see https://stackoverflow.com/questions/77330373/dynamically-unpivoting-table
-- see https://stackoverflow.com/questions/66425756/snowflake-how-can-we-run-an-unpivot-query-over-an-array-of-fields-instead-of-exp/75987369#75987369
use schema test.public;

-- one single row w/ multiple columns
create or replace view employee_details_view
as select v:empDetails c01,
    v:empDetails[0] c02,

    v:empDetails[0].fullName c03,
    v:empDetails[0]['fullName'] c04,
    v:empDetails[0].age c05,
    v:empDetails[0].gender c06,

    v:empDetails[0].phoneNumber c07,
    v:empDetails[0].phoneNumber.areaCode c08, 
    v:empDetails[0].phoneNumber.number c09,
    
    v:empDetails[0].children c10, 
    v:empDetails[0].children[0].name c11,
    v:empDetails[0].children[0].gender c12,
    v:empDetails[0].children[0].age c13,
    
    v:empDetails[0].citiesLived[1].place c14,
    v:empDetails[0].citiesLived[1].yearsLived c15,
    v:empDetails[0].citiesLived[1].yearsLived[0] c16

from employee_details;
select *
from employee_details_view;

-- single OBJECT w/ all view columns
select OBJECT_CONSTRUCT_KEEP_NULL(*) obj
from employee_details_view;

-- multiple rows w/ one prop per row (~melt)
with cte as (
    select OBJECT_CONSTRUCT_KEEP_NULL(*) obj
    from employee_details_view)
select key, value
from cte, table(flatten(obj))
order by key;

-- equivalent more specific query
with cte as (
    select OBJECT_CONSTRUCT_KEEP_NULL(*) obj
    from employee_details_view)
select f.key, f.value
from cte, table(flatten(input => cte.obj)) f
order by f.key;
