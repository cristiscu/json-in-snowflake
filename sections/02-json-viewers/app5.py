import streamlit as st
import json, os
from snowflake.snowpark import Session

st.title("Simple JSON Viewer")

pars = {
    "account": 'FHB91278',
    "user": 'cristiscu',
    "password": os.environ['SNOWSQL_PWD']}
session = Session.builder.configs(pars).create()

query = 'select top 1 products from test.public.store'
query = st.sidebar.text_area('Query:', value=query)

rows = session.sql(query).collect()
data = json.loads(str(rows[0][0]))
data = json.dumps(data, indent=2)

tabCode, tabJson = st.tabs(["Code", "JSON"])
tabCode.code(data, language='json')
tabJson.json(data)