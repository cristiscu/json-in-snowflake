-- create internal stage and upload JSON file
-- SNOWSQL -c test_conn -f 1-setup-script.sql

CREATE OR REPLACE STAGE test.public.stage1 FILE_FORMAT=(TYPE=JSON);

PUT file://../../../data/store.json @test.public.stage1;

LIST @test.public.stage1;
