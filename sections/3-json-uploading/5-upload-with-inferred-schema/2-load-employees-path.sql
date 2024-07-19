-- SNOWSQL -c test_conn -f 2-load-employees-path.sql
use schema test.public;

/*
[
  { "id": "Steven King" },
  { "id": "Steven King.Neena Kochhar" },
  ...
]
*/

create or replace file format json_file_format
    TYPE='JSON'
    STRIP_OUTER_ARRAY=TRUE;

create or replace stage json_stage file_format=json_file_format;

PUT file://../../../data/employees-path.json @json_stage;

SELECT * 
FROM TABLE(INFER_SCHEMA(
    LOCATION=>'@json_stage',
    FILE_FORMAT=>'json_file_format'));

CREATE OR REPLACE TABLE employees_path_inferred
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(INFER_SCHEMA(
        LOCATION=>'@json_stage',
        FILE_FORMAT=>'json_file_format')));

SELECT GET_DDL('table', 'test.public.employees_path_inferred');

SELECT $1:id::text FROM @json_stage;

COPY INTO employees_path_inferred
FROM (SELECT $1:id::text FROM @json_stage);

TABLE employees_path_inferred;
