#!/usr/bin/env python3

import re
import sys

def filter_good_bench(errorfile, goodbenchfile):
    """
    filter only good benchmarks in error.txt
    """
    s=set()
    with open(goodbenchfile) as f:
        for line in f:
            s.add(line.strip())
    # process the error.txt file
    canprint = False
    with open(errorfile) as f:
        err = 1
        for line in f:
            if line.startswith("HEBI: RUNNING"):
                name=line.split()[2]
                if name in s:
                    canprint = True
                else:
                    canprint = False
            # open print
            if canprint:
                print (line, end="")


if __name__ == "__main__":
    # ./a.py errorfile goodbench
    filter_good_bench(sys.argv[1], sys.argv[2])
