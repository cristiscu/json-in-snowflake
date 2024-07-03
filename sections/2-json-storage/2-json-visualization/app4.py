import streamlit as st
import json
from snowflake.snowpark import Session
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

st.title("Simple JSON Viewer")

pars = SnowflakeLoginOptions("test_conn")
session = Session.builder.configs(pars).create()

query = 'table test.public.store'
query = st.sidebar.text_area('Query:', value=query)

rows = session.sql(query).collect()
data = json.loads(str(rows[0][0]))
data = json.dumps(data, indent=2)

tabCode, tabJson = st.tabs(["Code", "JSON"])
tabCode.code(data, language='json')
tabJson.json(data)