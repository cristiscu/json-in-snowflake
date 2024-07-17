-- dynamic JSON data --> PARSE_JSON built-in function
-- see https://docs.snowflake.com/en/sql-reference/functions/parse_json

-- explicitly parsed JSON (in SELECT)
select parse_json('{ "key": "value" }') json,
    typeof(json), system$typeof(json), is_object(json);

-- multi-line JSON
select parse_json($$
{
    "key": "value"
}
$$);

-- ====================================================
-- this will fail (no fct call in VALUES)
select *
from values (parse_json('{ "key": "value" }'));

-- but this will work
select parse_json($1)
from values ('{ "key": "value" }');

-- ====================================================
-- this will fail (parse_json in FROM not a table function)
select *
from parse_json('{ "key": "value" }');

-- but this will work (subquery)
select *
from (select parse_json('{ "key": "value" }'));

-- ====================================================
-- JSON from temp session variable
set json = $$
{
    "custom":
    [
        { "name": "addressIdNum",    "valueNum": 12345678},
        { "name": "cancelledDateAt", "valueAt": "2013-04-05 01:02:03" }
    ]
}
$$;

select parse_json($json);
select parse_json($json):custom[0].valueNum;
