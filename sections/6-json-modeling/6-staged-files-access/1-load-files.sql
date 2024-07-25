-- upload JSON file as staged file
-- SNOWSQL -c test_conn -f 6-staged-file-load.sql

CREATE STAGE test.public.stage1 FILE_FORMAT=(TYPE=JSON);
PUT file://../../../data/store.json @test.public.stage1;
LIST @test.public.stage1;