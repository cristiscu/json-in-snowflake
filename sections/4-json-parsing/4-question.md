## Question

**What is the appropriate query to return `{ "id": 123 }` as a Snowflake OBJECT?**

A)
```
select '{ "id": 123 )'
```
B)
```
select '{ "id": ' || id || ' )'
from (select src:"id" as id
from (select parse_json(column1) as src
from values ('{ "id": 123 }')));
```
C)
```
select object_construct(src:id::string, 'id')
from (select parse_json('{ "id": 123 }') as src)
```
*D)
```
select object_construct('id', id)
from (select src:"id" as id
from (select parse_json(column1) as src
from values ('{ "id": 123 }')));
```

**Answer:**
A) returns a string, not an OBJECT. We need OBJECT_CONTRUCT for this.
B) also returns a string (from concatenation with correctly parsed JSON), not an OBJECT
C) returns an OBJECT, but as { "123": "id" }, not { "id": 123 }.
D) is the ony query that returns the required Snowflake OBJECT, properly generated with OBJECT_CONSTRUCT.
