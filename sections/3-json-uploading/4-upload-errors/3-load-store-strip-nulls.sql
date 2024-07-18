-- strip JSON nulls from the relaxed version
-- SNOWSQL -c test_conn -f 3-load-store-strip-nulls.sql

CREATE TEMP FILE FORMAT test.public.temp_format TYPE=JSON; 

CREATE TEMP STAGE test.public.temp_stage FILE_FORMAT=test.public.temp_format;

PUT file://../../../data/store-relaxed.json @test.public.temp_stage
    AUTO_COMPRESS=FALSE
    SOURCE_COMPRESSION=NONE
    OVERWRITE=TRUE
    PARALLEL=10;

CREATE OR REPLACE TABLE test.public.store_strip_nulls(v VARIANT);

COPY INTO test.public.store_strip_nulls
FROM @test.public.temp_stage

FILE_FORMAT=(
    TYPE=JSON
    STRIP_NULL_VALUES=TRUE
    NULL_IF=('null', 'json_null'))

FILES=('store-relaxed.json')
PATTERN='*\.json'
VALIDATION_MODE=RETURN_ALL_ERRORS   -- comment-out to load data when ok
ON_ERROR=CONTINUE
FORCE=TRUE
PURGE=TRUE;

TABLE test.public.store_strip_nulls;
