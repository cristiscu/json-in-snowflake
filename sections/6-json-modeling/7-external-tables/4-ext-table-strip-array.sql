-- external tables w/ STRIP_OUTER_ARRAY
-- see https://docs.snowflake.com/en/sql-reference/sql/create-external-table
-- see https://stackoverflow.com/questions/68804571/snowflake-external-table-from-a-list-of-jsons
use schema test.public;

-- (1) w/ one single auto-variant JSON field
create or replace external table exttable1
with location = @stage_ext/employees/
    auto_refresh = true
    file_format = 'format1';
table exttable1;

-- (2) w/ one single auto-variant JSON field
create or replace external table exttable2
with location = @stage_ext/employees/
    auto_refresh = true
    file_format = (type=json, STRIP_OUTER_ARRAY=TRUE);
table exttable2;

-- (3) w/ known keys
create or replace external table exttable3(
    filename TEXT AS metadata$filename,
    manager TEXT AS (value:manager::TEXT))
with location = @stage_ext/employees/
    auto_refresh = true
    file_format = (type=json, STRIP_OUTER_ARRAY=TRUE);
table exttable3;
