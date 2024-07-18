-- unload as JSON ARRAY
-- SNOWSQL -c test_conn -f 4-unload-as-array.sql
-- see https://stackoverflow.com/questions/52853048/nesting-an-object-construct-result-inside-an-json-array-when-unloading-data-from
use schema test.public;

/*
[
{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"},
{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"},
{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"},
]
*/

SELECT '['
UNION ALL
SELECT TO_JSON(OBJECT_CONSTRUCT('id', id,
    'first_name', first_name, 'last_name', last_name,
    'city', city, 'state', state)) || ',' as objs
FROM unloading
UNION ALL
SELECT ']';

COPY INTO @json_stage/unloading3.json
FROM (
    SELECT '[' UNION ALL
    SELECT TO_JSON(OBJECT_CONSTRUCT('id', id,
        'first_name', first_name, 'last_name', last_name,
        'city', city, 'state', state)) || ',' as objs
    FROM unloading
    UNION ALL SELECT ']')
FILE_FORMAT=(TYPE=CSV COMPRESSION=NONE FIELD_DELIMITER='|')
OVERWRITE=TRUE;
LIST @json_stage;

GET @json_stage/unloading3.json file://../../../data/;
