import streamlit as st

st.title("Simple JSON Data Viewer")

with open("../../data/store.json") as fin:
    st.code(fin.read(), language='json')
