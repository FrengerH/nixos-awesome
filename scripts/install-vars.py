import json

# Read example vars file
with open("vars.example", "r") as vars:
    data = json.load(vars)
    for key, value in data.items():
        data[key] = input(key + " (" + value + "): ") or value

# Writing to vars file
with open("/etc/nixos/vars", "w") as outfile:
    json.dump(data, outfile)
