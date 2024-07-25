-- external tables over JSON staged files
-- see https://snowflake.discourse.group/t/how-to-create-an-external-table-from-json-files-with-similar-fields/1413/2
use schema test.public;

/*
Input staged files:

File1.json: { "name": "Jhon", "last_name": "Miller", "age": 31, "birthplace": "San Francisco" }
File2.json: { "name": "Claire", "last_name": "Williams", "birthplace": "New York" }
*/

-- (1) manually
create or replace external table ext_table1(
    v variant as (value::variant))
with location = @stage/my_data_folder/
file_format = (type=json);

select v:name, v:last_name, v:age::int,
from ext_table1;

-- (2) from inferred schema
create or replace external table ext_table2
using template (
    select array_agg(object_construct(*))
    from table(
        infer_schema(location=>'@stage', file_format=>'my_parquet_format')))
    location=@mystage
    file_format=my_parquet_format
    auto_refresh=false;
