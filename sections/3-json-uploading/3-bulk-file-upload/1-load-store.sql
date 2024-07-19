-- SNOWSQL -c test_conn -f 1-load-store.sql

-- (1) local file --> internal named stage
CREATE TEMP FILE FORMAT test.public.temp_format TYPE=JSON; 

CREATE TEMP STAGE test.public.temp_stage FILE_FORMAT=test.public.temp_format;

PUT file://../../../data/store.json @test.public.temp_stage;

-- (2) staged file --> database table
CREATE OR REPLACE TABLE test.public.store3(v VARIANT);

COPY INTO test.public.store3 FROM @test.public.temp_stage;

TABLE test.public.store3;
