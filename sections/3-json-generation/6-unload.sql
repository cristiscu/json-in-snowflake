-- see https://stackoverflow.com/questions/52853048/nesting-an-object-construct-result-inside-an-json-array-when-unloading-data-from
use schema test.public;

create or replace table unloading(
    id int, first_name string, last_name string,
    city string, state string)
as select * from values
(1, 'Ryan', 'Dalton', 'Salt Lake City', 'UT'),
(2, 'Upton', 'Conway', 'Birmingham', 'AL'),
(3, 'Kibo', 'Horton', 'Columbus', 'GA');

COPY INTO @json_stage/file1 FROM (
    SELECT ARRAY_CONSTRUCT(objs)
    FROM (
        SELECT OBJECT_CONSTRUCT(
            'id', id, 'first_name', first_name,
            'last_name', last_name, 'city', city,
            'state', state) as objs
        FROM unloading))
FILE_FORMAT = (TYPE = JSON);
LIST @json_stage;

/*
[{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"}]
[{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"}]
[{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"}]
*/

COPY INTO @json_stage/file2 FROM (
    SELECT '[' UNION ALL
    SELECT TO_JSON(OBJECT_CONSTRUCT(
        'id', id, 'first_name', first_name,
        'last_name', last_name, 'city', city,
        'state', state)) || ',' as objs
    FROM unloading
    UNION ALL SELECT ']')
FILE_FORMAT = (TYPE = CSV);
LIST @json_stage;

/*
[
{"city":"Salt Lake City"\,"first_name":"Ryan"\,"id":1\,"last_name":"Dalton"\,"state":"UT"}\,
{"city":"Birmingham"\,"first_name":"Upton"\,"id":2\,"last_name":"Conway"\,"state":"AL"}\,
{"city":"Columbus"\,"first_name":"Kibo"\,"id":3\,"last_name":"Horton"\,"state":"GA"}\,
]
*/