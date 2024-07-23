-- Reformatting a dynamic array of properties

-- (max 256 bytes!)
set json = '{
    "Properties": [
        { "Name": "CardId",     "Value": "1" },
        { "Name": "CardNumber", "Value": "************6945" },
        { "Name": "OrderId",    "Value": null }
    ]
}';

/*
Desired Output:
{
    "Properties": {
        "CardId": 1,
        "CardNumber": "************6945",
        "OrderId": null
    }
}
*/

-- tabular Name-Value pairs
select rs.value['Name'] as "Name", rs.value['Value'] as "Value"
from (
    select parse_json(column1) as src
    from values ($json)) src,
        lateral flatten(input => src:"Properties") rs;

-- for fixed number of properties
select object_construct(
  'Properties',
  object_construct_keep_null(name0, value0, name1, value1, name2, value2)) as json
  from (
select
  to_char(props[0]."Name") as name0, to_char(props[0]."Value") as value0,
  to_char(props[1]."Name") as name1, to_char(props[1]."Value") as value1,
  to_char(props[2]."Name") as name2, to_char(props[2]."Value") as value2
  from (
select src:"Properties" as props
  from (
select parse_json(column1) as src
  from values ($json))));

-- for variable number of properties
select object_construct('Properties', object_agg("Name", "Value")) as json
  from (
select rs.value['Name'] as "Name", rs.value['Value'] as "Value"
  from (
select parse_json(column1) as src
  from values ($json)) src, lateral flatten(input => src:"Properties") rs);
