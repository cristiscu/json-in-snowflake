-- SNOWSQL -c my_conn -f 5-query-stage.sql
-- see https://stackoverflow.com/questions/70623021/faltten-command-takes-one-variable-how-to-use-it-for-multiple-rows

use schema test.public;

CREATE OR REPLACE FILE FORMAT tests_file_format TYPE = JSON;
CREATE OR REPLACE STAGE tests_stage FILE_FORMAT = tests_file_format;
PUT file://..\..\data\test11.json @tests_stage AUTO_COMPRESS=TRUE;
PUT file://..\..\data\test12.json @tests_stage AUTO_COMPRESS=TRUE;
PUT file://..\..\data\test13.json @tests_stage AUTO_COMPRESS=TRUE;
PUT file://..\..\data\test14.json @tests_stage AUTO_COMPRESS=TRUE;

SELECT s.*, f.*
FROM @tests_stage s, TABLE(FLATTEN(s.$1:test)) f;