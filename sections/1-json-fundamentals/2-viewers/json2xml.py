# JSON to XML

def getXmlList(obj, key=None, level=0):

    indent0 = '  ' * level
    indent1 = indent0 + '  '

    s = ""
    if len(obj) == 0:
        s += f"{indent0}<{key}/>\n"
    elif isinstance(obj[0], dict):
        s += f"{indent0}<{key}_coll>\n"
        for child in obj:
            s += getXml(child, key, level+1)
        s += f"{indent0}</{key}_coll>\n"
    else:
        s += f"{indent0}<{key}>\n"
        for child in obj:
            s += f"{indent1}<value>{str(child)}</value>\n"
        s += f"{indent0}</{key}>\n"
    return s

def getXml(node, node_key=None, level=0):

    indent0 = '  ' * level
    indent1 = indent0 + '  '

    if node_key is None: node_key = "root"
    s = '<?xml version="1.0" encoding="utf-8"?>\n' if level == 0 else ''
    if isinstance(node, list):
        s += getXmlList(node, node_key, level)
    else:
        s += f"{indent0}<{node_key}>\n"
        for key in node:
            obj = node[key]
            if isinstance(obj, dict):
                s += getXml(obj, key, level+1)
            elif isinstance(obj, list):
                s += getXmlList(obj, key, level+1)
            else:
                s += f"{indent1}<{key}>{obj}</{key}>\n"
        s += f"{indent0}</{node_key}>\n"
    return s
