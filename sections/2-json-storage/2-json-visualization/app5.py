# paste and run in a Streamit in Snowflake app
import json
import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("Simple JSON Viewer")

query = 'table test.public.store'
query = st.sidebar.text_area('Query:', value=query)

rows = get_active_session().sql(query).collect()
data = json.loads(str(rows[0][0]))
data = json.dumps(data, indent=2)

tabCode, tabJson = st.tabs(["Code", "JSON"])
tabCode.code(data, language='json')
tabJson.json(data)