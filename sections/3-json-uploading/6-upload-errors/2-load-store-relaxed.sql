-- relaxed JSON (no comments, no multi-line strings, no hexa number format) will load!
-- SNOWSQL -c test_conn -f 2-load-store-relaxed.sql

CREATE TEMP FILE FORMAT test.public.temp_format TYPE=JSON; 

CREATE TEMP STAGE test.public.temp_stage FILE_FORMAT=test.public.temp_format;

PUT file://../../../data/store-relaxed.json @test.public.temp_stage AUTO_COMPRESS=FALSE;

CREATE OR REPLACE TABLE test.public.store_relaxed(v VARIANT);

COPY INTO test.public.store_relaxed FROM @test.public.temp_stage;

TABLE test.public.store_relaxed;
