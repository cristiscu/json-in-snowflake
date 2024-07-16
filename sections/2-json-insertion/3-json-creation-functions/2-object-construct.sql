-- OBJECT_CONSTRUCT

select
    parse_json('{ "id": 123 }') json1, typeof(json1),
    object_construct('id', 123) json2, typeof(json2);

-- SQL NULLs are removed (not JSON nulls!)
select
    parse_json('{"id": 123, "age": null}'),
    arrays_to_object(['id', 'age'], [123, null]),
    object_construct('id', 123, 'age', null),
    object_construct_keep_null('id', 123, 'age', null);

select object_construct_keep_null(*)
from (select 123 as "id", null as "age");

select object_construct('id', id)
from (
    select src:"id" as id
    from (
        select parse_json(column1) as src
        from values ('{ "id": 123 }')));
