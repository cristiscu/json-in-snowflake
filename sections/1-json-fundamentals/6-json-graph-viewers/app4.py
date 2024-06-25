import json
with open("../../../data/employees-path.json") as fin:
    root = json.load(fin)

with open("templates/radial-dendrogram.html", "r") as file:
    content = file.read()
filename = 'generated/radial-dendrogram.html'
with open(filename, "w") as file:
    file.write(content.replace('"{{data}}"', json.dumps(root, indent=4)))
