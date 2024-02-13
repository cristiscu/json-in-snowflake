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

-- updates
-- see https://docs.snowflake.com/en/sql-reference/data-types-semistructured#label-data-type-object
UPDATE insert_json
SET v = { 'Alberta': 'Edmonton' , 'Manitoba': 'Winnipeg' }
WHERE id = 1;

UPDATE insert_json
SET v = OBJECT_CONSTRUCT('Alberta', 'Edmonton', 'Manitoba', 'Winnipeg')
WHERE id = 1;

-- this will also work (auto-cast string to OBJECT!)
UPDATE insert_json
SET v = '{ "Alberta": "Edmonton" , "Manitoba": "Winnipeg" }'
WHERE id = 1;

-- returns OBJECT, Edmonton, Edmonton, null
SELECT typeof(v), v:Alberta, v:"Alberta", v:alberta
FROM insert_json
WHERE id = 1;