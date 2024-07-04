-- INSERT JSON data w/ array/object_construct
-- see https://stackoverflow.com/questions/65025121/insert-into-snowflake-table-from-multiple-values-with-arrays-and-objects
use schema test.public;

create or replace temporary table insert_json2(
    "ID" STRING NOT NULL,
    "TS" TIMESTAMP NOT NULL,
    "TEXT" STRING,
    "DATEONLY" DATE,
    "ARRAY" ARRAY,
    "OBJ" OBJECT,
    "BOOL" BOOLEAN,
    "DOUBLE" DOUBLE,
    "INT" BIGINT,
    "DEC_18_9" NUMBER (18, 9));

-- this will fail (functions in VALUES)
INSERT INTO insert_json2 values
    ('id1', '2020-11-26 14:01:27.868', '19', '2020-11-26',
    ARRAY_CONSTRUCT(0, 1, 2), OBJECT_CONSTRUCT('this', 'is', 'my', 'object', 'query',
    OBJECT_CONSTRUCT('field1', 'one', 'field2', ARRAY_CONSTRUCT('field2a', 'two')),
    'field3', ARRAY_CONSTRUCT(3, 4, 5)), FALSE, 178482300.96318725, 9, 12345619.876543190),
    ('id2', '2020-11-26 14:01:27.868', '19', '2020-11-26',
    ARRAY_CONSTRUCT(0, 1, 2), OBJECT_CONSTRUCT('this', 'is', 'my', 'object', 'query',
    OBJECT_CONSTRUCT('field1', 'one', 'field2', ARRAY_CONSTRUCT('field2a', 'two')),
    'field3', ARRAY_CONSTRUCT(3, 4, 5)), FALSE, 178482300.96318725, 9, 12345619.876543190);

-- this will work (w/ SELECT)
INSERT INTO insert_json2
    SELECT 'id1', '2020-11-26 14:01:27.868', '19', '2020-11-26',
    ARRAY_CONSTRUCT(0, 1, 2), OBJECT_CONSTRUCT('this', 'is', 'my', 'object', 'query',
    OBJECT_CONSTRUCT('field1', 'one', 'field2', ARRAY_CONSTRUCT('field2a', 'two')),
    'field3', ARRAY_CONSTRUCT(3, 4, 5)), FALSE, 178482300.96318725, 9, 12345619.876543190;

-- this will work (w/ SELECT + VALUES)
INSERT INTO insert_json2
    SELECT $1, $2, $3, $4, PARSE_JSON($5), PARSE_JSON($6), $7, $8, $9, $10
    FROM VALUES
    ('id1', '2020-11-26 14:01:27.868', '19', '2020-11-26', '[0, 1, 2]',
    '{"this": "is", "my": "object",
    "query": {"field1": "one", "field2": ["field2a", "two"], "field3": [3, 4, 5]}}',
    FALSE, 178482300.96318725, 9, 12345619.876543190),
    ('id2', '2020-11-26 14:01:27.868', '19', '2020-11-26', '[0, 1, 2]',
    '{"this": "is", "my": "object",
    "query": {"field1": "one", "field2": ["field2a", "two"], "field3": [3, 4, 5]}}',
    FALSE, 178482300.96318725, 9, 12345619.876543190);
