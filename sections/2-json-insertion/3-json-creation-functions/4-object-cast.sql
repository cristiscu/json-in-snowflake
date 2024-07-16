
-- JSON nulls vs SQL NULL
select
    v:age null1, typeof(null1),
    strip_null_value(v:age) null2, typeof(null2)
from (select parse_json('{"id": 123, "age": null}') v);

-- TO/AS/IS_OBJECT
select
    to_variant('{"id": 123}') var, typeof(var), is_object(var),
    to_object(var) obj1, typeof(obj1), is_object(obj1),
    as_object(parse_json(var)) obj2, typeof(obj2), is_object(obj2);
