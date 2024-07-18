-- SNOWSQL -c test_conn -f 1-load-store-json5.sql

CREATE TEMP FILE FORMAT test.public.temp_format TYPE=JSON; 

CREATE TEMP STAGE test.public.temp_stage FILE_FORMAT=test.public.temp_format;

PUT file://../../../data/store-json5.json @test.public.temp_stage AUTO_COMPRESS=FALSE;

CREATE OR REPLACE TABLE test.public.store_json5(v VARIANT);

COPY INTO test.public.store_json5 FROM @test.public.temp_stage;

TABLE test.public.store_json5;
