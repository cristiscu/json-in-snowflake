def getXml(node, level=0):

    indent0 = '  ' * level
    s = '<?xml version="1.0" encoding="utf-8"?>\n' if level == 0 else ''

    s += f"{indent0}<employee>\n"
    for key in node:
        if key == "employees":
            # recursively append the inner children
            s += f"  {indent0}<{key}>\n"
            for child in node[key]:
                s += getXml(child, level+2)
            s += f"  {indent0}</{key}>\n"
        else:
            s += f"  {indent0}<{key}>{node[key]}</{key}>\n"
    s += f"{indent0}</employee>\n"
    return s


import json
with open("../../../data/employees.json") as fin:
    root = json.load(fin)

# convert and save as XML
# validate at https://www.liquid-technologies.com/online-xml-validator
xml = getXml(root)
with open("../../../data/employees.xml", "w") as f:
    f.writelines(xml)
