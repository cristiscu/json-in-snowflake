-- SNOWSQL -c my_conn -f 5-query-stage.sql
-- see https://stackoverflow.com/questions/70623021/faltten-command-takes-one-variable-how-to-use-it-for-multiple-rows

use schema test.public;

CREATE OR REPLACE FILE FORMAT tests_file_format TYPE = JSON;

CREATE OR REPLACE STAGE tests_stage FILE_FORMAT = tests_file_format;

PUT file://..\..\..\data\\test11.json @tests_stage;
PUT file://..\..\..\data\\test12.json @tests_stage;
PUT file://..\..\..\data\\test13.json @tests_stage;
PUT file://..\..\..\data\\test14.json @tests_stage;

-- ====================================================================
-- see https://docs.snowflake.com/en/user-guide/querying-metadata
SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, content.*
FROM @tests_stage content
ORDER BY METADATA$FILE_LAST_MODIFIED;

SELECT METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, content.*, test.*
FROM @tests_stage content, TABLE(FLATTEN(content.$1:test)) test
ORDER BY METADATA$FILE_LAST_MODIFIED;

SELECT METADATA$FILENAME, parse_json($1):"Date", parse_json($1):test[1]
FROM @tests_stage;

SELECT parse_json($1) FROM @tests_stage;

SELECT $1:"Date", $1:test[1]
FROM (SELECT parse_json(*) FROM @tests_stage);
