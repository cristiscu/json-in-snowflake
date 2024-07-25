-- external tables w/ STRIP_OUTER_ARRAY
-- input staged file: [{'k': 'calendar#event'}, {'k': 'calendar#event'}]
-- see https://stackoverflow.com/questions/68804571/snowflake-external-table-from-a-list-of-jsons
use schema test.public;

-- (1) w/ one single auto-variant JSON field
create or replace external table exttable1
with location = @stage
auto_refresh = true
file_format = (type=json, STRIP_OUTER_ARRAY=TRUE);

-- (2) w/ known keys
create or replace external table exttable2(
    filename TEXT metadata$filename, k TEXT AS (value:"k"::TEXT))
with location = @stage
auto_refresh = true
file_format = (type=json, STRIP_OUTER_ARRAY=TRUE);
