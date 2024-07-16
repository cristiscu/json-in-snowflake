-- bad OBJECT instantiations

-- not such a data type value (OBJECT, not ARRAY!)
select { "id": 123 };
select [{ "id": 123 }, 456];
select [123, 456];

-- returns a string, not an OBJECT (we need OBJECT_CONSTRUCT for this)
select '{ "id": 123 }' obj, typeof(obj);

-- returns an OBJECT, but as { "123": "id" }, not { "id": 123 }
select object_construct(src:id::string, 'id')
from (select parse_json('{ "id": 123 }') as src);

-- returns a string (from concatenation with correctly parsed JSON), not an OBJECT
select '{ "id": ' || id || ' }'
from (
    select src:"id" as id
    from (
        select parse_json(column1) as src
        from values ('{ "id": 123 }')));
