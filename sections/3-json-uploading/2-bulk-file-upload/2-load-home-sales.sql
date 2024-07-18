-- SNOWSQL -c test_conn -f 2-load-home-sales.sql
-- see https://docs.snowflake.com/en/user-guide/script-data-load-transform-json

USE SCHEMA test.public;

CREATE OR REPLACE FILE FORMAT json_format TYPE=JSON;
CREATE OR REPLACE STAGE stage FILE_FORMAT=json_format;
PUT file://../../../data/home_sales.json @stage AUTO_COMPRESS=TRUE;

/*
{"location": {"state_city": "MA-Lexington","zip": "40503"},"sale_date": "2017-3-5","price": "275836"}
{"location": {"state_city": "MA-Belmont","zip": "02478"},"sale_date": "2017-3-17","price": "392567"}
{"location": {"state_city": "MA-Winchester","zip": "01890"},"sale_date": "2017-3-21","price": "389921"}
*/

CREATE OR REPLACE TABLE home_sales(
    city STRING,
    zip STRING,
    state STRING,
    type STRING DEFAULT 'Residential',
    sale_date timestamp_ntz,
    price STRING);

SELECT SUBSTR($1:location.state_city, 4),
    SUBSTR($1:location.state_city, 1, 2),
    $1:location.zip,
    to_timestamp_ntz($1:sale_date),
    $1:price
FROM @stage/home_sales.json.gz;

COPY INTO home_sales(city, state, zip, sale_date, price)
FROM (
    SELECT SUBSTR($1:location.state_city, 4),
        SUBSTR($1:location.state_city, 1, 2),
        $1:location.zip,
        to_timestamp_ntz($1:sale_date),
        $1:price
    FROM @stage/home_sales.json.gz)
ON_ERROR = 'continue';
SELECT * FROM home_sales;

LIST @stage;

REMOVE @stage/home_sales.json.gz;
