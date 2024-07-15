def getPath(node, nodes=[], path=""):

    # append full path to the top of the current node
    path += node["name"] if len(path) == 0 else f'.{node["name"]}'
    nodes.append({ "id": path })

    if "employees" in node:
        for child in node["employees"]:
            nodes = getPath(child, nodes, path)
    return nodes

import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)

path = getPath(root)
with open("../../../data/employees-path.json", "w") as f:
    f.writelines(json.dumps(path, indent=2))

with open("templates/radial-dendrogram.html", "r") as file:
    content = file.read()
filename = 'generated/radial-dendrogram.html'
with open(filename, "w") as file:
    file.write(content.replace('"{{data}}"', json.dumps(root, indent=4)))
