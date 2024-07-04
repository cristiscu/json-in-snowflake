-- SNOWSQL -c my_conn -f 2-employee-details.sql
-- see https://stackoverflow.com/questions/65535086/loading-json-in-snowflake

use schema test.public;

create or replace file format json_file_format
    TYPE = 'JSON'
    COMPRESSION = 'AUTO' 
    ENABLE_OCTAL = FALSE 
    ALLOW_DUPLICATE = FALSE 
    STRIP_OUTER_ARRAY = TRUE 
    STRIP_NULL_VALUES = FALSE 
    IGNORE_UTF8_ERRORS = FALSE;

create or replace stage json_stage file_format = json_file_format;

PUT file://..\..\data\employee-details.json @json_stage;
PUT file://..\..\data\employee-details-array.json @json_stage;
PUT file://..\..\data\employee-details-array.ndjson @json_stage;

create or replace table employee_details(v variant);
create or replace table employee_details_array(v variant);
create or replace table employee_details_array_ndjson(v variant);

COPY INTO employee_details FROM @json_stage/employee-details.json;
COPY INTO employee_details_array FROM @json_stage/employee-details-array.json;
COPY INTO employee_details_array_ndjson FROM @json_stage/employee-details-array.ndjson;

REMOVE @json_stage/employee-details.json;
REMOVE @json_stage/employee-details-array.json;
REMOVE @json_stage/employee-details-array.ndjson;

select * from employee_details;
select * from employee_details_array;
select * from employee_details_array_ndjson;
