-- see https://docs.snowflake.com/en/user-guide/sample-data-tpch
use schema SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;

-- change nameX alias to something unique, to avoid the query cache!
select c_name as name12345, c_custkey, o_orderkey, o_orderdate, o_totalprice, sum(l_quantity)
from customer
    inner join orders on c_custkey = o_custkey
    inner join lineitem on o_orderkey = l_orderkey
where o_orderdate >= dateadd(year, -45, current_date) and o_orderkey in (
    select l_orderkey
    from lineitem
    group by l_orderkey
    having sum(l_quantity) > 200)
group by c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice 
order by o_totalprice desc, o_orderdate;

-- replace with the returned value the string constant in the next two queries
select last_query_id();

-- see https://docs.snowflake.com/en/sql-reference/functions/system_explain_plan_json
-- format result at https://jsonviewer.stack.hu/
SELECT SYSTEM$EXPLAIN_PLAN_JSON('01b5d7ca-0002-a40c-006d-5a870004257e');

SELECT oper.value:id id, oper.value:operation::string op, expr.value::string ex
FROM (SELECT SYSTEM$EXPLAIN_PLAN_JSON('01b5d7ca-0002-a40c-006d-5a870004257e') plan),
    table(flatten(parse_json(plan):"Operations"[0])) oper,
    table(flatten(oper.value:"expressions")) expr;
