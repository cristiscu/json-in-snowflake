-- unload as NDJSON
-- SNOWSQL -c test_conn -f 2-unload-ndjson.sql
-- see https://stackoverflow.com/questions/52853048/nesting-an-object-construct-result-inside-an-json-array-when-unloading-data-from
use schema test.public;

/*
{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"}
{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"}
{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"}
*/

SELECT OBJECT_CONSTRUCT('id', id,
    'first_name', first_name, 'last_name', last_name,
    'city', city, 'state', state) objs
FROM unloading;

COPY INTO @json_stage/unloading1.json
FROM (
    SELECT OBJECT_CONSTRUCT('id', id,
        'first_name', first_name, 'last_name', last_name,
        'city', city, 'state', state) objs
    FROM unloading)
FILE_FORMAT=(TYPE=JSON COMPRESSION=NONE)
OVERWRITE=TRUE;

LIST @json_stage;

GET @json_stage/unloading1.json file://../../../data/;
