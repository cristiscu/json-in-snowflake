import json
import streamlit as st
from io import StringIO
from json_classes import JsonManager

st.set_page_config(layout="wide")
st.title("JSON Data Profiler")
st.caption("Upload a JSON data file and get its inferred schema.")

uploaded_file = st.sidebar.file_uploader(
    "Upload a JSON file", type=["json"], accept_multiple_files=False)

if uploaded_file is not None:
    bytes = uploaded_file.getvalue()
    raw = StringIO(bytes.decode("utf-8")).read()
else:
    with open("../../../data/test.json") as f:
        raw = f.read()

tabSource, tabSchemaSingle, tabSchemaMulti \
    = st.tabs(["JSON Source File", "Inferred with Single", "Inferred with Multi"])
tabSource.code(raw, language="json", line_numbers=True)

data = json.loads(raw)
schema = JsonManager.inferSchema(data, True).dump()
tabSchemaSingle.code(schema, language="json", line_numbers=True)

schema = JsonManager.inferSchema(data, False).dump()
tabSchemaMulti.code(schema, language="json", line_numbers=True)
