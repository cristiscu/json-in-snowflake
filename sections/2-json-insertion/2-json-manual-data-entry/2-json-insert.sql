-- INSERT JSON data w/ parse_json
-- see https://stackoverflow.com/questions/57972555/how-to-insert-json-data-into-a-column-of-a-snowflake-datawarehouse-table

create database if not exists test;
use schema test.public;

create or replace table insert_json(id int, v variant);

-- this will fail (no { } value as such in Snowflake)
insert into insert_json(id, v)
values (1, { "key": "value" });

-- this will fail (no { } value as such in Snowflake)
insert into insert_json(id, v)
select *
from values (1, { "key": "value" });

-- this will fail (cannot insert string in variant)
insert into insert_json(id, v)
values (1, '{ "key": "value" }');

-- this will fail (cannot call function in VALUES)
insert into insert_json(id, v)
values (1, parse_json('{ "key": "value" }'));

-- this will work (w/ SELECT)
insert into insert_json(id, v)
select 1, parse_json('{ "key": "value" }');

select * from insert_json;
