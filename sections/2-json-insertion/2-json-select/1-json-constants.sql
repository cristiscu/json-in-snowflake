
-- this returns a STRING, not JSON OBJECT/ARRAY
select '{ "key": "value" }';

select *
from values ('{ "key": "value" }');

-- OBJECT/ARRAY constants (no need to parse!)
select { 'key': 'value' } obj, typeof(obj);
select [1, 2, 3] arr, typeof(arr);
select [{ 'key': ['text', 0, null] }, 1234] arr, typeof(arr);

-- not in VALUES
select *
from values ({ 'key': 'value' });
select *
from values ({ 'key': 'value' }), ([123, 456]);
