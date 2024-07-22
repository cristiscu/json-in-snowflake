# paste and run in a Streamit in Snowflake app
# see https://medium.com/snowflake/how-to-make-your-own-snowflake-query-profile-8b93d58e4674
import json
import streamlit as st
from snowflake.snowpark.context import get_active_session

def getDot(results):

    nodes = ""; edges = ""
    for row in results:
        nodeId = str(row[2])
        parentId = str(row[3]).strip('[] \n\r')
        step = str(row[4])
        nodes += (f'  n{nodeId} [\n'
            + f'    style="filled" shape="record" color="SkyBlue"\n'
            + f'    fillcolor="#d3dcef:#ffffff" color="#716f64" penwidth="1"\n'
            + f'    label=<<table style="rounded" border="0" cellborder="0" cellspacing="0" cellpadding="1">\n'
            + f'      <tr><td bgcolor="transparent" align="center"><font color="#000000"><b>{step}</b></font></td></tr>\n')

        oper = json.loads(str(row[7]))
        if 'table_name' in oper:
            nodes += f'      <tr><td align="left"><font color="#000000">table_name: {oper["table_name"]}</font></td></tr>\n'
        if 'join_type' in oper:
            nodes += f'      <tr><td align="left"><font color="#000000">join_type: {oper["join_type"]}</font></td></tr>\n'
        if 'join_id' in oper:
            edges += f'  n{nodeId} -> n{oper["join_id"]} [  dir="forward" style="dashed" ];\n'

        execTime = json.loads(str(row[6]))
        if 'overall_percentage' in execTime:
            overall_percentage = float(execTime['overall_percentage'])
            if overall_percentage  > 0.0:
                nodes += f'      <tr><td align="left"><font color="#000000">overall_percentage: {"{0:.1%}".format(overall_percentage)}</font></td></tr>\n'
            if 'remote_disk_io' in execTime:
                nodes += f'      <tr><td align="left"><font color="#000000">remote_disk_io: {"{0:.0%}".format(execTime["remote_disk_io"])}</font></td></tr>\n'

        stats = json.loads(str(row[5]))
        if 'io' in stats:
            io = stats["io"]
            if 'bytes_scanned' in io:
                nodes += f'      <tr><td align="left"><font color="#000000">bytes_scanned: {io["bytes_scanned"]:,}</font></td></tr>\n'
            if 'percentage_scanned_from_cache' in io:
                nodes += f'      <tr><td align="left"><font color="#000000">percentage_scanned_from_cache: {"{0:.2%}".format(io["percentage_scanned_from_cache"])}</font></td></tr>\n'
            if 'bytes_written_to_result' in io:
                nodes += f'      <tr><td align="left"><font color="#000000">bytes_written_to_result: {io["bytes_written_to_result"]:,}</font></td></tr>\n'

        if 'pruning' in stats:
            nodes += f'      <tr><td align="left"><font color="#000000">partitions_scanned: {stats["pruning"]["partitions_scanned"]}</font></td></tr>\n'
            nodes += f'      <tr><td align="left"><font color="#000000">partitions_total: {stats["pruning"]["partitions_total"]}</font></td></tr>\n'

        nodes += f'    </table>>\n  ]\n'

        if 'input_rows' in stats:
            nodes += f'  i{nodeId} [ label="{stats["input_rows"]:,}" style="filled" shape="oval" fillcolor="#ffffff" ]\n'
            edges += f'  n{nodeId} -> i{nodeId};\n'

        if parentId != None:
            edges += f'  i{parentId} -> n{nodeId};\n'

    return ('digraph G {\n'
        + f'  graph [ rankdir="TB" bgcolor="#ffffff" ]\n'
        + f'  edge [ penwidth="1" color="#696969" dir="back" style="solid" ]\n\n'
        + f'{nodes}\n{edges}}}\n')


st.title("Custom Query Profile")

# change nameX alias to something unique, to avoid the query cache!
query = """select c_name as name1, c_custkey, o_orderkey, o_orderdate, o_totalprice, sum(l_quantity)
from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.customer
    inner join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.orders on c_custkey = o_custkey
    inner join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.lineitem on o_orderkey = l_orderkey
where o_orderdate >= dateadd(year, -45, current_date) and o_orderkey in (
    select l_orderkey
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.lineitem
    group by l_orderkey
    having sum(l_quantity) > 200)
group by c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice 
order by o_totalprice desc, o_orderdate"""
query = st.sidebar.text_area('Query:', value=query)
rows = get_active_session().sql(query).collect()

query = "select * from table(GET_QUERY_OPERATOR_STATS(last_query_id()))"
results = get_active_session().sql(query).collect()
code = getDot(results)

tabProfile, tabCode = st.tabs(["Profile", "Code"])
tabProfile.graphviz_chart(code)
tabCode.code(code, language="dot")
