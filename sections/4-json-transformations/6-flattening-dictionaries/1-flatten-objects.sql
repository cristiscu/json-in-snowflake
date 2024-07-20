-- FLATTEN
-- see https://docs.snowflake.com/en/sql-reference/functions/flatten

-- KEY/VALUE for OBJECT
select key, value
from test.public.store_json,
    lateral flatten(v:store.bicycle);

select key, value
from test.public.employee_details emp,
    lateral flatten(v:empDetails[0].phoneNumber);

-- PATH
select key, value
from test.public.employee_details emp,
    lateral flatten(input=>v, path=>'empDetails[0].phoneNumber');

select key, value
from test.public.employee_details emp,
    lateral flatten(input=>v:empDetails[0], path=>'phoneNumber');
