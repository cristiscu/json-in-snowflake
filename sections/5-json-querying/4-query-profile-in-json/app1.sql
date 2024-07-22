-- see https://docs.snowflake.com/en/user-guide/sample-data-tpch
use schema SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;

-- change nameX alias to something unique, to avoid the query cache!
select c_name as name12, c_custkey, o_orderkey, o_orderdate, o_totalprice, sum(l_quantity)
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

-- see https://docs.snowflake.com/en/sql-reference/functions/get_query_operator_stats
select * from table(GET_QUERY_OPERATOR_STATS(last_query_id()));
