-- INSERT JSON data w/ parse_json
-- see https://stackoverflow.com/questions/57972555/how-to-insert-json-data-into-a-column-of-a-snowflake-datawarehouse-table
use schema test.public;

create or replace table insert_json(id int, v variant);

-- this will fail (cannot insert string in variant)
insert into insert_json(id, v)
values (1, '{ "key": "value" }');

-- this will fail (cannot call function in VALUES)
insert into insert_json(id, v)
values (1, parse_json('{ "key": "value" }'));

-- this will work (w/ SELECT)
insert into insert_json(id, v)
select 1, parse_json('{ "key": "value" }');

-- this will work (w/ SELECT + VALUES)
insert into insert_json(id, v)
select $1, parse_json($2)
from values (1, '{ "key": "value" }');

-- this will work (w/ CTAS)
create or replace table insert_json(id int, v variant)
as select 1, parse_json('{ "key": "value" }');

-- this will work (w/ CTAS + VALUES)
create or replace table insert_json(id int, v variant)
as select $1, parse_json($2)
from values (1, '{ "key": "value" }');

