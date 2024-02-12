-- Rows to JSON Aggregation

/*
Expected Output: per Market Segment  Customer Name : Phone
{
  "Market Segment": "AUTOMOBILE",
  "Customers": {
    "Customer#000000002": "23-768-687-3665",
    "Customer#000000003": "11-719-748-3364",
    "Customer#000000006": "30-114-968-4951",
    "Customer#000000007": "28-190-982-9759",
    "Customer#000000017": "12-970-682-3487",
    ...
    "Customer#000149999": "11-401-828-7411",
    "Customer#000150000": "20-354-401-2016"
  }
}
*/

-- Query:
select object_construct(
  'Market Segment', c_mktsegment,
  'Customers', object_agg(c_name, to_variant(c_phone)))
  from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
  group by c_mktsegment
  order by c_mktsegment;

