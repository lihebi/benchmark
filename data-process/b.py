#!/usr/bin/env python3

"""
This script produce reason-xxx.csv
"""

def reason_file(IDMap, filename):
    with open(filename + ".txt") as f, open (filename + ".csv", 'w') as csv:
        csv.write("ID, Num\n")
        for line in f:
            line.strip()
            num = line.split(':')[0]
            reason = line.split(':')[1]
            num = int(num)
            reason = reason.strip()
            assert(reason in IDMap)
            # id, num
            # print (IDMap[reason], num, sep=",")
            csv.write(str(IDMap[reason]) + "," + str(num) + "\n")

# 1. sort all reasons
# 2. assign ID for each,
#   - output a txt file for the mapping
#   - Produce a mapping graph.
# 3. for each file, get a CSV:
def sort_reason():
    d = {}
    l = []
    with open("reason-0.txt") as f:
        for line in f:
            line.strip()
            num = line.split(':')[0]
            reason = line.split(':')[1]
            num = int(num)
            reason = reason.strip()
            l.append((num, reason))
    # assign ID
    l = sorted(l, key=lambda p: p[0], reverse=True)
    # from reason to ID
    IDMap = {}
    for i in range(len(l)):
        IDMap[l[i][1]] = i+1
        print (i+1, ":", l[i][1])
    # output reason and its ID
    
    reason_file(IDMap, "reason-0")
    reason_file(IDMap, "reason-0.3")
    reason_file(IDMap, "reason-0.6")
    reason_file(IDMap, "reason-0.9")
    # with open("reason-0.txt") as f:
    #     print ("ID, Num")
    #     for line in f:
    #         line.strip()
    #         num = line.split(':')[0]
    #         reason = line.split(':')[1]
    #         num = int(num)
    #         reason = reason.strip()
    #         assert(reason in IDMap)
    #         # id, num
    #         print (IDMap[reason], num, sep=",")



if __name__ == '__hebi__':
    sort_reason()
