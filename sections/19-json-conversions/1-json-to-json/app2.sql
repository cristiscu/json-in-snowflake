-- Reformatting a Dynamic Array of Properties

/*
Expected Output - plus Tabular!
{
  "Properties": {
    "CardId": 1,
    "CardNumber": "************6945",
    "OrderId": null
  }
}
*/

-- Query (tabular)
select rs.value['Name'] as "Name", rs.value['Value'] as "Value" from (
select parse_json(column1) as src
  from values ('{
     "Properties": [{
        "Name": "CardId",
        "Value": "1"
      },{
        "Name": "CardNumber",
        "Value": "************6945"
      },{
        "Name": "OrderId",
        "Value": null
      }]
  }')) src, lateral flatten(input => src:"Properties") rs;

/*
Output:

Name            Value
"CardId"        "1"
"CardNumber"    "*******6945"
"OrderId"       null
*/

-- Query (static)
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
  from values ('{
     "Properties": [{
        "Name": "CardId",
        "Value": 1
      },{
        "Name": "CardNumber",
        "Value": "************6945"
      },{
        "Name": "OrderId",
        "Value": null
      }]
}'))));

/*
Output:
{
  "Properties": {
    "CardId": 1,
    "CardNumber": "************6945",
    "OrderId": null
  }
}
*/

-- Query (dynamic)
select object_construct('Properties', object_agg("Name", "Value")) as json
  from (
select rs.value['Name'] as "Name", rs.value['Value'] as "Value"
  from (
select parse_json(column1) as src
  from values ('{
     "Properties": [
      {
        "Name": "CardId",
        "Value": 1
      },{
        "Name": "CardNumber",
        "Value": "************6945"
      },{
        "Name": "OrderId",
        "Value": null
      }
    ]
  }')) src, lateral flatten(input => src:"Properties") rs);

/*
Output:
{
  "Properties": {
    "CardId": 1,
    "CardNumber": "************6945",
    "OrderId": null
  }
}
*/

-- Query (dynamic, added property)
select object_construct('Properties', object_agg("Name", "Value")) as json
  from (
select rs.value['Name'] as "Name", rs.value['Value'] as "Value"
  from (
select parse_json(column1) as src
  from values ('{
     "Properties": [
      {
        "Name": "CardId",
        "Value": 1
      },{
        "Name": "CardNumber",
        "Value": "************6945"
      },{
        "Name": "OrderId",
        "Value": null
      },{
        "Name": "Balance",
        "Value": 222
      }
    ]
  }')) src, lateral flatten(input => src:"Properties") rs);

/*
Output (sorted!):
{
  "Properties": {
    "Balance": 222,
    "CardId": 1,
    "CardNumber": "************6945",
    "OrderId": null
  }
}
*/

-- Query (with combined top 2 steps) – still TODO
select object_construct(
  'Properties', object_agg(rs.value['Name'], rs.value['Value'])) as json
  from (
select parse_json(column1) as src
  from values ('{
     "Properties": [
      {
        "Name": "CardId",
        "Value": 1
      },{
        "Name": "CardNumber",
        "Value": "************6945"
      },{
        "Name": "OrderId",
        "Value": null
      }
    ]
  }')) src,
  lateral flatten(input => src:"CustomAttributes"."CustomAttribute") rs
  group by src:"OrderId";
