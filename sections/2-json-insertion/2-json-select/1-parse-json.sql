-- dynamic JSON data --> PARSE_JSON built-in function
-- see https://docs.snowflake.com/en/sql-reference/functions/parse_json

-- this will fail
select { "key": "value" };

select [1, 2, 3] arr, typeof(arr);
select [{ "key1": "value1" }, { "key2": "value2" }] arr, typeof(arr);

-- this is ok
select parse_json('{ "key": "value" }');

-- this will fail (parse_json in FROM not a table function)
select *
from parse_json('{ "key": "value" }');

-- this will fail (parse_json not a table function)
select *
from table(parse_json('{ "key": "value" }'));

-- this will work
select *
from (select parse_json('{ "key": "value" }'));

-- this will fail (no { } value as such in Snowflake)
select *
from values ({ "key": "value" });

-- this will work, but it returns a STRING
select $1
from values ('{ "key": "value" }');

-- this will work (w/ SELECT + VALUES)
select parse_json($1) json, typeof(json)
from values ('{ "key": "value" }');

-- this will work (w/ SELECT)
select parse_json('{ "key": "value" }') json,
    typeof(json),
    system$typeof(json),
    is_object(json);

-- this will work (for multi-line JSON)
select parse_json($$
{
    "key": "value"
}
$$);

-- ==========================================================
-- ok JSON --> JSON + NULL + JSON
select parse_json('{ "key": "value" }'),
    check_json('{ "key": "value" }'),
    try_parse_json('{ "key": "value" }');

-- bad JSON --> error + err msg + NULL
select parse_json('{ "key" "value" }');
select check_json('{ "key" "value" }'),
    try_parse_json('{ "key" "value" }');

-- ================================================================
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