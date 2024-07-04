def getLinks(node, s=""):
    if "employees" in node:
        for child in node["employees"]:
            parent_name = node['name']
            child_name = child['name']
            s += getLinks(child, f'\t"{parent_name}" -> "{child_name}";\n')
    return s


import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)
dot = f"digraph {{\n{getLinks(root)}}}"
print(dot)

import webbrowser, urllib.parse
url = f'http://magjac.com/graphviz-visual-editor/?dot={urllib.parse.quote(dot)}'
webbrowser.open(url)