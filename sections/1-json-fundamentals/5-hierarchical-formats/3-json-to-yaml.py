def getYaml(node, level=0, first=False):

    indent0 = '  ' * level
    s = f"{node['name']}\n"

    # recursively append the inner children
    if "employees" in node:
        first = True
        for child in node["employees"]:
            s += f"{indent0}- " if first else indent0 + '  '
            s += getYaml(child, level+1, first)
            first = False

    return s


import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)

# convert and save as YAML, validate at https://www.yamllint.com/
yaml = getYaml(root)
with open("../../../data/employees.yaml", "w") as f:
    f.writelines(yaml)
