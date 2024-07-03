-- force key order in JSON object
-- see https://stackoverflow.com/questions/73151658/generate-the-json-file-from-snowflake-table

select
    object_construct('a', a, 'b', b) auto1,
    parse_json('{ "b": ' || b || ', "a": ' || a || '}') auto2,
    to_variant('{ "b": ' || b || ', "a": ' || a || '}') manual1,
    '{ "b": ' || b || ', "a": ' || a || '}' manual2 
from values (1, 2) t(a, b);

