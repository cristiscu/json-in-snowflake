import json
import streamlit as st
from io import StringIO
import json2xml, json2yaml

st.title("Simple Semi-Structured Data Viewer")

filename = "../../data/store.json"
with open(filename) as fin:
    data = json.load(fin)

uploaded_file = st.sidebar.file_uploader(
    "Upload a JSON file", type=["json"], accept_multiple_files=False)
if uploaded_file is not None:
    content = StringIO(uploaded_file.getvalue().decode("utf-8"))
    data = json.load(content)

tabJson, tabXml, tabYaml = st.tabs(["JSON", "XML", "YAML"])
jsn = json.dumps(data, indent=2)
tabJson.code(jsn, language='json')

xml = json2xml.getXml(data)
tabXml.code(xml, language='xml')

yaml = json2yaml.getYaml(data)
tabYaml.code(yaml, language='yaml')
