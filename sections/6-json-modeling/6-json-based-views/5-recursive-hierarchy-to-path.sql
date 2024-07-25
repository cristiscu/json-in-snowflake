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

-- recursive view
create or replace recursive view managers_subordinates_path
as
    select manager, subordinate, manager || '.' || subordinate as path
    from managers_subordinates
    union all
    select m.manager, m.subordinate, p.path || '.' || m.subordinate
    from managers_subordinates m
        inner join managers_subordinates_path p
        on m.manager = p.subordinate;
table managers_subordinates_path;

-- ARRAY w/ path query
select array_agg(*) as output
from (
    select object_construct('id', path)
    from managers_subordinates_path);
