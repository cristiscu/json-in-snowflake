-- FLATTEN
-- see https://docs.snowflake.com/en/sql-reference/functions/flatten

select t.arr, elem.value, elem.index
from (select ['a', 'b', 'c'] arr) t, lateral flatten(t.arr) elem;

select t.obj, kv.value, kv.key
from (select {'name':'John', 'age':32} obj) t, lateral flatten(t.obj) kv;

select *
    from test.public.store_json,
    lateral flatten(v:store.book);

-- INDEX/VALUE for ARRAY
select index, value
from test.public.store_json,
    lateral flatten(v:store.book);

select index, value
from test.public.employee_details,
    lateral flatten(v:empDetails[0].children);

-- PATH
select index, value, path
from test.public.store_json,
    lateral flatten(input=>v, path=>'store.book');

select index, value, path
from test.public.store_json,
    lateral flatten(input=>v:store, path=>'book');

select index, value, path
from test.public.employee_details,
    lateral flatten(input=>v, path=>'empDetails[0].children');

select index, value, path
from test.public.employee_details,
    lateral flatten(input=>v:empDetails[0], path=>'children');

-- OUTER (~LEFT OUTER LATERAL join)
select parent.value:name, child.value
from (select [{'name':'Mark', 'children':['Joe','Mary']}, {'name':'Jane'}] v) v,
    lateral flatten(v) parent,
    lateral flatten(parent.value:children) child;

select parent.value:name, child.value
from (select [{'name':'Mark', 'children':['Joe','Mary']}, {'name':'Jane'}] v) v,
    lateral flatten(input=>v) parent,
    lateral flatten(input=>parent.value:children, outer=>true) child;

-- SEQ (=parent's index, from 1)
select parent.value:name as parent, child.value as parent,
    parent.seq as parent_seq, child.seq as child_seq
from (select [{'name':'Mark', 'children':['Joe','Mary']}, {'name':'Jane'}] v) v,
    lateral flatten(input=>v) parent,
    lateral flatten(input=>parent.value:children, outer=>true) child;

-- RECURSIVE
select value:name
from test.public.employees_json,
    lateral flatten(v:employees);

select value, this
from test.public.employees_json,
    lateral flatten(v, path=>'employees', recursive=>true);

-- MODE
select value, key, index
from test.public.employee_details,
    lateral flatten(v:empDetails, recursive=>true);

select value, key, index
from test.public.employee_details,
    lateral flatten(v:empDetails, recursive=>true, mode=>'ARRAY');

select value, key, index
from test.public.employee_details,
    lateral flatten(v:empDetails[0], recursive=>true);

select value, key, index
from test.public.employee_details,
    lateral flatten(v:empDetails[0], recursive=>true, mode=>'OBJECT');
