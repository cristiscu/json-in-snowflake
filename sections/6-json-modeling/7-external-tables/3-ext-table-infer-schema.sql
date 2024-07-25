-- external tables over JSON staged files
-- see https://docs.snowflake.com/en/sql-reference/sql/create-external-table
-- see https://snowflake.discourse.group/t/how-to-create-an-external-table-from-json-files-with-similar-fields/1413/2
use schema test.public;

create or replace external table ext_table2
using template (
    select array_agg(object_construct(*))
    from table(infer_schema(location=>'@stage_ext/test/', file_format=>'format1')))
    location = @stage_ext/test/
    auto_refresh = false
    file_format = 'format1';

select get_ddl('table', 'ext_table2');
/*
create or replace external table EXT_TABLE2(
	"Date" VARCHAR(16777216) AS (CAST(GET($1, 'Date') AS VARCHAR(16777216))),
	"test" ARRAY AS (CAST(GET($1, 'test') AS ARRAY)))
location=@STAGE_EXT/test/
auto_refresh=false
file_format=format1;
*/

select * from ext_table2;
