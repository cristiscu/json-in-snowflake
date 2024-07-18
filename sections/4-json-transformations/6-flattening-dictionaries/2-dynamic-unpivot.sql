-- Dynamic UNPIVOT (or MELT)
-- see https://stackoverflow.com/questions/68553105/is-there-a-melt-command-in-snowflake
-- see https://stackoverflow.com/questions/77330373/dynamically-unpivoting-table
-- see https://stackoverflow.com/questions/66425756/snowflake-how-can-we-run-an-unpivot-query-over-an-array-of-fields-instead-of-exp/75987369#75987369

-- one single row w/ multiple columns
select v:empDetails,
    v:empDetails[0],

    v:empDetails[0].fullName,
    v:empDetails[0]['fullName'],
    v:empDetails[0].age,
    v:empDetails[0].gender,

    v:empDetails[0].phoneNumber,
    v:empDetails[0].phoneNumber.areaCode, 
    v:empDetails[0].phoneNumber.number,
    
    v:empDetails[0].children, 
    v:empDetails[0].children[0].name,
    v:empDetails[0].children[0].gender,
    v:empDetails[0].children[0].age,
    
    v:empDetails[0].citiesLived[1].place,
    v:empDetails[0].citiesLived[1].yearsLived,
    v:empDetails[0].citiesLived[1].yearsLived[0],

from test.public.employee_details;

-- multiple rows w/ one prop per row
with cte as (
    select v:empDetails,
    v:empDetails[0],

    v:empDetails[0].fullName,
    v:empDetails[0]['fullName'],
    v:empDetails[0].age,
    v:empDetails[0].gender,

    v:empDetails[0].phoneNumber,
    v:empDetails[0].phoneNumber.areaCode, 
    v:empDetails[0].phoneNumber.number,
    
    v:empDetails[0].children, 
    v:empDetails[0].children[0].name,
    v:empDetails[0].children[0].gender,
    v:empDetails[0].children[0].age,
    
    v:empDetails[0].citiesLived[1].place,
    v:empDetails[0].citiesLived[1].yearsLived,
    v:empDetails[0].citiesLived[1].yearsLived[0]

from test.public.employee_details)

select key, value
from (select OBJECT_CONSTRUCT_KEEP_NULL(*) obj from cte), table(flatten(obj))
order by key;
