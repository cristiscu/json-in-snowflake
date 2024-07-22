-- Reformatting a JSON Object

/*
Expected Output:
{
  "OrderId":123456,
  "Custom Attributes": {
     "kount_CountersTriggered": "1",
     "MonerisCreditCardNumber":" "************6945",
     "backorder": null
}
*/

-- Query
select object_construct(
  'OrderId', order_id,
  'Custom Attributes', object_construct_keep_null(name0, value0, name1, value1, name2, value2))
  from (
select order_id,
  to_char(attribs[0]."Name") as name0, to_char(attribs[0]."Value") as value0,
  to_char(attribs[1]."Name") as name1, to_char(attribs[1]."Value") as value1,
  to_char(attribs[2]."Name") as name2, to_char(attribs[2]."Value") as value2
  from (
select src:"OrderId" as order_id,
  src:"CustomAttributes"."CustomAttribute" as attribs
  from (
select parse_json(column1) as src
  from values ('{
  "OrderId": 123456,
  "CustomAttributes": {
    "CustomAttribute": [
      {
        "Name": "kount_CountersTriggered",
        "Value": "1"
      },
      {
        "Name": "MonerisCreditCardNumber",
        "Value": "************6945"
      },
      {
        "Name": "backorder",
        "Value": null
      }
    ]
  }
}'))));

/*
Output:
{
  "Custom Attributes": {
    "MonerisCreditCardNumber": "************6945",
    "backorder": null,
    "kount_CountersTriggered": "1"
  },
  "OrderId": 123456
}
*/

-- Query (for variable number of attributes)
select object_construct(
  'OrderId', order_id,
  'Custom Attributes', object_agg(name, value))
  from (
select src:"OrderId" as order_id,
  rs.value['Name'] as name,
  rs.value['Value'] as value
  from (
select parse_json(column1) as src
  from values ('{
  "OrderId": 123456,
  "CustomAttributes": {
    "CustomAttribute": [
      {
        "Name": "kount_CountersTriggered",
        "Value": "1"
      },
      {
        "Name": "MonerisCreditCardNumber",
        "Value": "************6945"
      },
      {
        "Name": "backorder",
        "Value": null
      }
    ]
  }
}')) src,
  lateral flatten(input => src:"CustomAttributes"."CustomAttribute") rs)
  group by order_id;

/*
Returns:
{
  "Custom Attributes": {
    "MonerisCreditCardNumber": "************6945",
    "backorder": null,
    "kount_CountersTriggered": "1"
  },
  "OrderId": 123456
}
*/