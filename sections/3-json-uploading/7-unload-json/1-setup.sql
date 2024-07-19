-- SNOWSQL -c test_conn -f 1-setup.sql
-- see https://stackoverflow.com/questions/52853048/nesting-an-object-construct-result-inside-an-json-array-when-unloading-data-from
use schema test.public;

create or replace table unloading(id int, 
    first_name string, last_name string,
    city string, state string)
as select * from values
    (1, 'Ryan', 'Dalton', 'Salt Lake City', 'UT'),
    (2, 'Upton', 'Conway', 'Birmingham', 'AL'),
    (3, 'Kibo', 'Horton', 'Columbus', 'GA');

REMOVE @json_stage;
LIST @json_stage;
