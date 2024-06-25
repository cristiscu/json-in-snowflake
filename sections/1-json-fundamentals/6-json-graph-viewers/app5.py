import pandas as pd
df = pd.read_csv("../../../data/employees.csv", header=0).convert_dtypes()

from pyvis.network import Network
data = Network(notebook=True, heading='')
data.barnes_hut(
    gravity=-80000,
    central_gravity=0.3,
    spring_length=10.0,
    spring_strength=1.0,
    damping=0.09,
    overlap=0)

for _, row in df.iterrows():
    src = str(row.iloc[0])
    dst = str(row.iloc[1])
    data.add_node(src)
    data.add_node(dst)
    data.add_edge(src, dst)

# set node size to number of child nodes
map = data.get_adj_list()
for node in data.nodes:
    node["value"] = len(map[node["id"]])

filename = 'generated/network-graph.html'
data.show(filename)
