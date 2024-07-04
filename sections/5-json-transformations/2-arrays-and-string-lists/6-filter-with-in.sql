-- filter table rows w/ IN from a list/array of values
-- see https://stackoverflow.com/questions/66803610/snowflake-sql-how-can-i-query-with-an-array-variable-for-an-in-clause
use schema test.public;

create or replace table names(name varchar, age int) as
select * from values
('John', 21), ('Mary', 26), ('Adam', 19), ('Eve', 33), ('Jack', 41);

-- (1) filter w/ IN using a JSON array
SELECT * FROM names
WHERE name IN (
    SELECT value::STRING
    FROM TABLE(FLATTEN(parse_json('["Jack","Bob","John","Adam"]')))
);

-- (2) filter w/ IN using a string list
SELECT * FROM names
WHERE name IN (
    SELECT TRIM(VALUE)
    FROM TABLE(SPLIT_TO_TABLE('Jack,Bob,John,Adam', ','))
);
