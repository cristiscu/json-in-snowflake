-- external tables over JSON staged files
-- see https://docs.snowflake.com/en/sql-reference/sql/create-external-table
-- see https://snowflake.discourse.group/t/how-to-create-an-external-table-from-json-files-with-similar-fields/1413/2
use schema test.public;

create or replace external table ext_table1(v variant as (value::variant))
with location = @stage_ext/test/
    file_format = 'format1';

select v:test[0].a::boolean, v:test[0].b, v:Date
from ext_table1;
