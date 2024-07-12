-- PARSE_JSON
-- see https://docs.snowflake.com/en/sql-reference/functions/parse_json

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

-- this will work (w/ SELECT + VALUES)
select parse_json($1)
from values ('{ "key": "value" }');

-- this will work (w/ SELECT)
select parse_json('{ "key": "value" }');

-- this will work (for multi-line JSON)
select parse_json($$
{
    "key": "value"
}
$$);
