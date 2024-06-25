import pandas as pd
import plotly.graph_objects as go

def getPairs(node, labels=[], parents=[]):
    if "employees" in node:
        for child in node["employees"]:
            labels.append(child["name"])
            parents.append(node["name"])
            labels, parents = getPairs(child, labels, parents)
    return labels, parents


import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)
labels, parents = getPairs(root, [root["name"]], [None])

# see https://plotly.com/python/treemaps/
data = go.Treemap(
    ids=labels,
    labels=labels,
    parents=parents,
    root_color="lightgrey")
fig = go.Figure(data)
fig.write_html(f'generated/treemap.html')

# see https://plotly.com/python/icicle-charts/
data = go.Icicle(
    ids=labels,
    labels=labels,
    parents=parents,
    root_color="lightgrey")
fig = go.Figure(data)
fig.write_html(f'generated/icicle.html')

# see https://plotly.com/python/employees-sunburst-charts/
data = go.Sunburst(
    ids=labels,
    labels=labels,
    parents=parents,
    insidetextorientation='horizontal')
fig = go.Figure(data)
fig.write_html(f'generated/sunburst.html')

# see https://plotly.com/python/sankey-diagram/
data = go.Sankey(
    node=dict(label=labels),
    link=dict(
        source=[list(labels).index(x) for x in labels],
        target=[-1 if pd.isna(x) else list(labels).index(x) for x in parents],
        label=labels,
        value=list(range(1, len(labels)))))
fig = go.Figure(data)
fig.write_html(f'generated/sankey.html')
