# validate at https://toolkitbay.com/tkb/tool/csv-validator
import pandas as pd
df = pd.read_csv("../../../data/employees.csv", header=0).convert_dtypes()

# collect all nodes
nodes = {}
for _, row in df.iterrows():
    nodes[row.iloc[0]] = {
        "id": int(row.iloc[2]),
        "name": row.iloc[0],
        "phone": row.iloc[4],
        "hiredate": row.iloc[5],
        "salary": int(row.iloc[6]),
        "job": row.iloc[7],
        "department": row.iloc[8]
    }

# move children under parents, and detect root
root = None
for _, row in df.iterrows():
    node = nodes[row.iloc[0]]
    isRoot = pd.isna(row.iloc[1])
    if isRoot: root = node
    else:
        parent = nodes[row.iloc[1]]
        if "employees" not in parent: parent["employees"] = []
        parent["employees"].append(node)

# convert and save as JSON, validate at https://jsonlint.com/
import json
with open("../../../data/employees.json", "w") as f:
    f.writelines(json.dumps(root, indent=2))
