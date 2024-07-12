-- CTAS JSON data w/ parse_json
-- see https://stackoverflow.com/questions/57972555/how-to-insert-json-data-into-a-column-of-a-snowflake-datawarehouse-table
use schema test.public;

-- this will fail (no { } such a value type in Snowflake)
create or replace table insert_json(id int, v variant)
as select 1, { "key": "value" };

-- this will work (w/ CTAS)
create or replace table insert_json(id int, v variant)
as select 1, parse_json('{ "key": "value" }');

-- this will work (w/ CTAS + auto-cast to VARIANT)
create or replace table insert_json(id int, v variant)
as select 1, '{ "key": "value" }';

-- this will work (w/ CTAS, for large copied JSON content)
create or replace table insert_json(id int, v variant)
as select 1, parse_json($$
{
    "key": "value"
}
$$);

-- this will work (w/ CTAS + VALUES)
create or replace table insert_json(id int, v variant)
as select $1, parse_json($2)
from values (1, '{ "key": "value" }');

select *
from insert_json;

select *, typeof(v)
from insert_json;
