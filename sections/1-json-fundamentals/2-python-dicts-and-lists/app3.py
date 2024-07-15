import json

with open("../../../data/store-raw.json") as fin:
    data = json.load(fin)
print(data)
print(json.dumps(data, indent=2))

with open("../../../data/store-raw-2.json", "w")  as fout:
    json.dump(data, fout, indent=2)
