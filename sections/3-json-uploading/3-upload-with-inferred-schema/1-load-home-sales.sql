-- SNOWSQL -c test_conn -f 1-load-home-sales.sql
-- see https://docs.snowflake.com/en/user-guide/script-data-load-transform-json
USE SCHEMA test.public;

/*
{"location": {"state_city": "MA-Lexington","zip": "40503"},"sale_date": "2017-3-5","price": "275836"}
{"location": {"state_city": "MA-Belmont","zip": "02478"},"sale_date": "2017-3-17","price": "392567"}
{"location": {"state_city": "MA-Winchester","zip": "01890"},"sale_date": "2017-3-21","price": "389921"}
*/

CREATE OR REPLACE FILE FORMAT json_format TYPE=JSON;
CREATE OR REPLACE STAGE stage FILE_FORMAT=json_format;
PUT file://../../../data/home_sales.json @stage;

SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
FROM TABLE(INFER_SCHEMA(
    LOCATION=>'@stage',
    FILE_FORMAT=>'json_format'));

CREATE OR REPLACE TABLE home_sales_inferred
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(INFER_SCHEMA(
        LOCATION=>'@stage',
        FILE_FORMAT=>'json_format')));

SELECT GET_DDL('table', 'test.public.home_sales_inferred');

SELECT $1:location, $1:price::text, $1:sale_date::date,
FROM @stage;

COPY INTO home_sales_inferred
FROM (
    SELECT $1:location, $1:price::text, $1:sale_date::date,
    FROM @stage)
ON_ERROR = 'continue';

TABLE home_sales_inferred;
