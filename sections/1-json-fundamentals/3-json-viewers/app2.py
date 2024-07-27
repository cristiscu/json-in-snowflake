# see https://docs.streamlit.io/develop/api-reference/data/st.json
import json
import streamlit as st
from io import StringIO

st.title("Simple JSON Data Viewer")

filename = "../../../data/store.json"
with open(filename) as fin:
    data = json.load(fin)

uploaded_file = st.sidebar.file_uploader(
    "Upload a JSON file", type=["json"], accept_multiple_files=False)
if uploaded_file is not None:
    content = StringIO(uploaded_file.getvalue().decode("utf-8"))
    data = json.load(content)

tabJson, tabJsonViewer = st.tabs(["JSON", "JSON Viewer"])
jsn = json.dumps(data, indent=2)
tabJson.code(jsn, language='json')
tabJsonViewer.json(jsn)
