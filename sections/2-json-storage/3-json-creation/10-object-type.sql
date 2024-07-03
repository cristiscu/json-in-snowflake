-- What is the appropriate query to return `{ "id": 123 }` as a Snowflake OBJECT?

-- returns a string, not an OBJECT. We need OBJECT_CONSTRUCT for this.
select '{ "id": 123 )'

-- returns an OBJECT, but as { "123": "id" }, not { "id": 123 }.
select object_construct(src:id::string, 'id')
from (select parse_json('{ "id": 123 }') as src)

-- returns a string (from concatenation with correctly parsed JSON), not an OBJECT
select '{ "id": ' || id || ' )'
from (
    select src:"id" as id
    from (
        select parse_json(column1) as src
        from values ('{ "id": 123 }')));

-- the ony query that returns the required Snowflake OBJECT, properly generated with OBJECT_CONSTRUCT.
select object_construct('id', id)
from (
    select src:"id" as id
    from (
        select parse_json(column1) as src
        from values ('{ "id": 123 }')));
