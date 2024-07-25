-- see https://docs.snowflake.com/en/user-guide/data-unload-considerations#unloading-a-relational-table-to-json

-- create a table
CREATE OR REPLACE TABLE mytable (
    id number(8) NOT NULL,
    first_name varchar(255) default NULL,
    last_name varchar(255) default NULL,
    city varchar(255),
    state varchar(255));

-- populate the table with data
INSERT INTO mytable VALUES
    (1,'Ryan','Dalton','Salt Lake City','UT'),
    (2,'Upton','Conway','Birmingham','AL'),
    (3,'Kibo','Horton','Columbus','GA');

-- unload the data to a file in a stage
COPY INTO @mystage
    FROM (SELECT OBJECT_CONSTRUCT(
        'id', id, 
        'first_name', first_name, 
        'last_name', last_name, 
        'city', city, 
        'state', state) FROM mytable)
    FILE_FORMAT = (TYPE = JSON);

/*
COPY INTO statement creates a file named data_0_0_0.json.gz in the stage, w/ following data:

{"city":"Salt Lake City","first_name":"Ryan","id":1,"last_name":"Dalton","state":"UT"}
{"city":"Birmingham","first_name":"Upton","id":2,"last_name":"Conway","state":"AL"}
{"city":"Columbus","first_name":"Kibo","id":3,"last_name":"Horton","state":"GA"}
*/
