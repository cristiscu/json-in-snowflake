-- SNOWSQL -c my_conn -f 1-json-to-relational.sql
-- see https://docs.snowflake.com/en/user-guide/script-data-load-transform-json

use schema test.public;

CREATE OR REPLACE TABLE home_sales(
    city STRING,
    zip STRING,
    state STRING,
    type STRING DEFAULT 'Residential',
    sale_date timestamp_ntz,
    price STRING);

CREATE OR REPLACE FILE FORMAT sf_tut_json_format TYPE = JSON;
CREATE OR REPLACE STAGE sf_tut_stage FILE_FORMAT = sf_tut_json_format;
PUT file://..\..\data\sales.json @sf_tut_stage AUTO_COMPRESS=TRUE;

COPY INTO home_sales(city, state, zip, sale_date, price)
   FROM (SELECT SUBSTR($1:location.state_city,4),
                SUBSTR($1:location.state_city,1,2),
                $1:location.zip,
                to_timestamp_ntz($1:sale_date),
                $1:price
         FROM @sf_tut_stage/sales.json.gz t)
   ON_ERROR = 'continue';
SELECT * from home_sales;

REMOVE @sf_tut_stage/sales.json.gz;
