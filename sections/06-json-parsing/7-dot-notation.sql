-- parse irregular JSON object (multi-line)
-- see https://stackoverflow.com/questions/52046003/parse-json-using-snowflake-sql

select
    v:custom[0].valueNum::integer,
    v:custom[1].valueAt::timestamp
from (select parse_json('{ "custom": [
        { "name": "addressIdNum",    "valueNum": 12345678},
        { "name": "cancelledDateAt", "valueAt": "2013-04-05 01:02:03" }
    ]}') v);