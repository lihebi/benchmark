#!/usr/bin/env python3
def tosecond(s):
    """
    0m2.194s to second
    """
    m = int(s.split('m')[0])
    n = float(s.split('m')[1][:-1])
    return m*60+n;

# print(tosecond("0m2.194s"))


print ("bench, time")

with open("perf.txt") as f:
    for line in f:
        # print (line)
        sec = tosecond(line.split()[-1])
        file = line.split()[0].split('/')[-1]
        print (file, ",", sec)


