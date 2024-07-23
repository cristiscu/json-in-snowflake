-- employee hierarchy to pairs: employees.json --> employees-array.json
use schema test.public;

/*
Desired Output:
[
    {"manager":"Steven King","subordinates":["Neena Kochhar","Lex De Haan","Den Raphaely","Adam Fripp"]},
    {"manager":"Neena Kochhar","subordinates":["Hermann Baer","Shelley Higgins","Nancy Greenberg"]},
    {"manager":"Alexander Hunold","subordinates":["Valli Pataballa","Bruce Ernst"]},
    {"manager":"Den Raphaely","subordinates":["Alexander Khoo","Shelli Baida"]},
    {"manager":"Adam Fripp","subordinates":["Laura Bissot"]},
    {"manager":"Nancy Greenberg","subordinates":["Ismael Sciarra","Jose Manuel Urman","Luis Popp"]},
    {"manager":"Lex De Haan","subordinates":["Alexander Hunold"]}
]
*/

-- manager-subordinates pairs, in tabular format
select distinct
    e.this:name as manager,
    s.value:name as subordinate
from employees_json h,
    table(flatten(h.v, recursive=>true)) e,
    table(flatten(e.this:employees)) s;

-- visual hierarchy links --> paste to http://magjac.com/graphviz-visual-editor/
select distinct
    '"' || e.this:name || '" -> "' || s.value:name || '"'
from employees_json h,
    table(flatten(h.v, recursive=>true)) e,
    table(flatten(e.this:employees)) s;

-- final query
with pairs as (
    select distinct
        e.this:name as manager,
        s.value:name as subordinate
    from employees_json h,
        table(flatten(h.v, recursive=>true)) e,
        table(flatten(e.this:employees)) s),
objs as (
    select distinct object_construct(
        'manager', manager,
        'subordinates', array_agg(subordinate) over (partition by manager))
    from pairs)
select array_agg(*) as output
from objs;
