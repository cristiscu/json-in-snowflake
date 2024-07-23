-- PIVOT on JSON
-- see https://stackoverflow.com/questions/66299479/json-flattening-and-table-creation
use schema test.public;

create or replace table pivot_table(v variant)
as select parse_json('{
    "id": "1234-567-890",
    "parent_id": "00-123-safsf-3345",
    "data": [{
        "id": "sfsfd-234-fgf-55-4545",
        "values": [
            { "name": "one", "value": "132" },
            { "name": "Two", "value": "MMAD" },
            { "name": "three", "value": "three1" }]
    },{
        "id": "asdfsdfsdf-23423-fsff-3445435",
        "values": [
            { "name": "One", "value": "232" },
            { "name": "Two", "value": "MMDI" },
            { "name": "Three", "value": "three2" }]
    }]}');

/*
Desired Output:

id	                            one	    two	    three
------------------------------------------------------
sfsfd-234-fgf-55-4545	        132	    MMAD	three1
asdfsdfsdf-23423-fsff-3445435	232	    MMDI	three2
*/

-- (1) PIVOT on previous populated table
select * from (
    select st.v:id::varchar as main_id,
        st.v:parent_id::varchar as parent_id,
        data.value:id::varchar as id,
        upper(vals.value: name::varchar) as col_name,
        vals.value: value::varchar as col_value
    from pivot_table st,
        lateral flatten(input => v:data) data,
        lateral flatten(input => data.value:values) vals)
pivot (max(col_value) for col_name in ('ONE', 'TWO', 'THREE'));

-- (2) same, but all dynamic
with cte1 as (select parse_json('{
    "id": "1234-567-890",
    "parent_id": "00-123-safsf-3345",
    "data": [{
        "id": "sfsfd-234-fgf-55-4545",
        "values": [
            { "name": "one", "value": "132" },
            { "name": "Two", "value": "MMAD" },
            { "name": "three", "value": "three1" }]
    },{
        "id": "asdfsdfsdf-23423-fsff-3445435",
        "values": [
            { "name": "One", "value": "232" },
            { "name": "Two", "value": "MMDI" },
            { "name": "Three", "value": "three2" }]
    }]}') as v),
cte2 as (
    select st.v:id::varchar as main_id,
        st.v:parent_id::varchar as parent_id,
        data.value:id::varchar as id,
        upper(vals.value: name::varchar) as col_name,
        vals.value: value::varchar as col_value
    from cte1 st,
        lateral flatten(input => v:data) data,
        lateral flatten(input => data.value:values) vals)
select * from cte2
pivot (max(col_value) for col_name in ('ONE', 'TWO', 'THREE'));
