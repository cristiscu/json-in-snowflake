# JSON to YAML

def getYamlList(obj, key=None, level=0, isArray=False):

    indent0 = '  ' * level

    s = f"{indent0}{key}:\n" if key is not None else ""
    isArray = isinstance(obj[0], dict)
    for child in obj:
        s += (getYaml(child, None, level+1, True)
            if isArray
            else f"{indent0}- {child}\n")
    return s

def getYaml(node, node_key=None, level=0, isArray=False):

    indent0 = '  ' * level

    s = f"{indent0}{node_key}:\n" if node_key is not None else ""
    if isinstance(node, list):
        s += getYamlList(node, node_key, level) if len(node) > 0 else ""
    else:
        for key in node:
            obj = node[key]
            if isinstance(obj, dict):
                s += getYaml(obj, key, level+1)
            elif isinstance(obj, list):
                s += getYamlList(obj, key, level+1) if len(obj) > 0 else ""
            else:
                s += f"{indent0}- " if isArray else f"{indent0}  "
                s += f"{key}: {obj}\n"
                isArray = False
    return s
