-- Create table from inferred schema
USE SCHEMA test.public;

SELECT *
FROM TABLE(INFER_SCHEMA(LOCATION=>'@stage', FILE_FORMAT=>'json_format'));

SELECT OBJECT_CONSTRUCT(*)s
FROM TABLE(INFER_SCHEMA(LOCATION=>'@stage', FILE_FORMAT=>'json_format'));

SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
FROM TABLE(INFER_SCHEMA(LOCATION=>'@stage', FILE_FORMAT=>'json_format'));

CREATE OR REPLACE TABLE home_sales_inferred
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(INFER_SCHEMA(LOCATION=>'@stage', FILE_FORMAT=>'json_format')));

SELECT GET_DDL('table', 'test.public.home_sales_inferred');
