-- employee hierarchy to path: employees.json --> employees-path.json
use schema test.public;

/*
Desired Output:
[
  { "id": "Steven King" },
  { "id": "Steven King.Neena Kochhar" },
  { "id": "Steven King.Neena Kochhar.Hermann Baer" },
  ...
]
*/

-- manager-subordinates pairs, in tabular format
create or replace view managers_subordinates
as select distinct
    e.this:name as manager,
    s.value:name as subordinate
from employees_json h,
    table(flatten(h.v, recursive=>true)) e,
    table(flatten(e.this:employees)) s;
table manager_subordinates;

with recursive pairs as (
    select manager, subordinate,
        manager || '.' || subordinate as ms
    from managers_subordinates
    union all
    select m.manager, m.subordinate,
        pairs.ms || '.' || m.subordinate
    from managers_subordinates m
        inner join pairs on m.manager = pairs.subordinate),
objs as (
    select object_construct('id', ms)
    from pairs)
select array_agg(*) as output
from objs;
