-- force key order in JSON object
-- see https://stackoverflow.com/questions/73151658/generate-the-json-file-from-snowflake-table

-- ok (but no forced order!)
select
    object_construct('a', a, 'b', b) json1, typeof(json1),
    parse_json('{ "b": ' || b || ', "a": ' || a || '}') json2, typeof(json2)
from values (1, 2) t(a, b);

-- not OK (strings!)
select
    '{ "b": ' || b || ', "a": ' || a || '}' str1, typeof(str1),
    to_variant('{ "b": ' || b || ', "a": ' || a || '}') str2, typeof(str2)
from values (1, 2) t(a, b);
