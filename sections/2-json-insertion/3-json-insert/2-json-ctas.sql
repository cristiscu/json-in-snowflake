-- CTAS JSON data w/ parse_json
-- see https://stackoverflow.com/questions/57972555/how-to-insert-json-data-into-a-column-of-a-snowflake-datawarehouse-table
use schema test.public;

-- auto OBJECT-to-VARIANT
create or replace table insert_json(id int, v variant)
as select 1, { 'key': 'value' };

-- this will work (w/ CTAS)
create or replace table insert_json(id int, v variant)
as select 1, parse_json('{ "key": "value" }');

-- this will work (w/ CTAS + auto-cast to OBJECT)
create or replace table insert_json(id int, v variant)
as select 1, '{ "key": "value" }';
select v, typeof(v) from insert_json;

-- this will work (w/ CTAS + auto-cast to ARRAY)
create or replace table insert_json(id int, v variant)
as select 1, '[{ "key1": "value1" }, { "key2": "value2" }]';
select v, typeof(v) from insert_json;

-- this will work (w/ CTAS, for large copied JSON content)
create or replace table insert_json(id int, v variant)
as select 1, parse_json($$
{
    "key": "value"
}
$$);

-- this will fail (no implicit conversion string-to-VARIANT)
create or replace table insert_json(id int, v variant)
as select $1, $2
from values (1, '{ "key": "value" }');

-- this will work (w/ CTAS + VALUES)
create or replace table insert_json(id int, v variant)
as select $1, parse_json($2)
from values (1, '{ "key": "value" }');

select *, typeof(v)
from insert_json;

-- no ARRAY into OBJECT, or OBJECT into ARRAY
create or replace table insert_json2(obj OBJECT)
as select [1, 2, 3];

create or replace table insert_json2(arr ARRAY)
as select { 'key': 'value' };
table insert_json2;
