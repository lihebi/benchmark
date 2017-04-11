#!/usr/bin/env python3


# read json
# if empty headers, remove


import json
import sys

for repo in ["core", "extra", "community", "multilib"]:
    fp = open(repo + ".json")
    doc = json.load(fp)
    fp.close()
    newj = [j for j in doc if len(j["includes"]) > 0]
    fp = open(repo + ".new.json", "w")
    json.dump(newj, fp, indent=2)
    fp.close()
# perform size check
