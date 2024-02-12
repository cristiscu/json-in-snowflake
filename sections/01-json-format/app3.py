import json

with open("../../data-in/store-raw.json") as fin:
    data = json.load(fin)
print(data)
print(json.dumps(data, indent=2))

with open("../../data-out/store-raw.json", "w")  as fout:
    json.dump(data, fout, indent=2)
