import os
import streamlit as st
from snowflake.snowpark import Session

def getSession():
    pars = {
        "account": 'FHB91278',
        "user": 'cristiscu',
        "password": os.environ['SNOWSQL_PWD'] }
    return Session.builder.configs(pars).create()


def getGraph(rows):
    s = ""
    for row in rows:
        source = str(row[0]) if row[0] is not None and len(str(row[0])) > 0 else ' '
        target = str(row[1]) if row[1] is not None and len(str(row[1])) > 0 else ' '
        if source != ' ' or target != ' ':
            s += f'\t"{source}" -> "{target}";\n'
    graph = f'digraph {{graph [rankdir=LR] node [shape=rect] " " [shape="ellipse"]; {s}}}'
    return graph;


database, schema = "LINEAGE_DB", "TEST_SCHEMA"
#database, schema = "EMPLOYEES", "PUBLIC"
st.set_page_config(layout="wide")
st.title(f"Data Lineage in {database}.{schema}")

query = f"select * from table(data_deps.public.get_lineage('{database}.{schema}'))"
rows = getSession().sql(query).collect()
st.graphviz_chart(getGraph(rows))
