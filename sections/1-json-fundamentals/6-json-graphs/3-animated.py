# keep only name-children keys
def simplify(node, labels=[], parents=[]):
    del node["id"]
    del node["phone"]
    del node["hiredate"]
    del node["salary"]
    del node["job"]
    del node["department"]
    if "employees" in node:
        for child in node["employees"]:
            simplify(child)
        node["children"] = node.pop("employees")


import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)
simplify(root)
jsn = json.dumps(root, indent=2)
with open("../../../data/employees-simplified.json", "w") as f:
    f.writelines(jsn)

with open("templates/collapsible-tree.html", "r") as file:
    content = file.read()
with open("generated/collapsible-tree.html", "w") as file:
    file.write(content.replace('"{{data}}"', jsn))

with open("templates/linear-dendrogram.html", "r") as file:
    content = file.read()
with open("generated/linear-dendrogram.html", "w") as file:
    file.write(content.replace('"{{data}}"', jsn))

with open("templates/circular-packing.html", "r") as file:
    content = file.read()
with open("generated/circular-packing.html", "w") as file:
    file.write(content.replace('"{{data}}"', jsn))
