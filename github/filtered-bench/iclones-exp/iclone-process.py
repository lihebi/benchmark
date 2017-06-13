#!/usr/bin/env python3

import json


def process():
    iclone_result_file = "/home/hebi/.helium.d/iclones-result-javaout.txt"
    ID=1
    wholesel=[]
    with open(iclone_result_file) as f:
        vaild = False
        # sel = []
        for line in f:
            if (line.startswith("-- Type")):
                t = int(line.split()[2])
                if (t == 1):
                    # type 1 is omitted
                    valid = False
                    pass
                else:
                    valid = True
            if (line.startswith("File:")):
                filename = line.split()[1]
                filename = filename.replace("/iclones/", "/cache/")
            if (line.startswith("Position:")):
                start,end = line.split()[1].split(",")
                start = int(start)
                end = int(end)
                if valid:
                    # add to result
                    lines = [{"line": i} for i in range(start,end+1)]
                    # sel.append({"file": filename, "sel": lines})
                    obj={"file": filename, "sel": lines}
                    obj["ID"]=ID
                    wholesel.append(obj)
                    # dump each into a seperate file
                    # the file should be put into the corresponding folder
                    selfile = filename.split("/cpp/")[0]
                    selfile += "/iclonesel"
                    # create the folder
                    if not os.path.exists(selfile):
                        os.mkdir(selfile)
                    selfile += "/sel-" + str(ID) + ".json"
                    with open(selfile, "w") as jsonfile:
                        json.dump([obj], jsonfile, indent=2)
                    ID+=1
    with open("wholesel.json", "w") as f:
        json.dump(wholesel, f, indent=2)

def get_pairs():
    """
    [
    {
    type: 2,
    IDs: [343,451,12]
    },
    {
    }
    ]
    """
    iclone_result_file = "/home/hebi/.helium.d/iclones-result-javaout.txt"
    ID=1
    ret=[]
    with open(iclone_result_file) as f:
        vaild = False
        # sel = []
        tmp={}
        for line in f:
            if (line.startswith("-- Type")):
                # dump current tmp
                if tmp:
                    ret.append(tmp)
                    tmp={}
                t = int(line.split()[2])
                if (t == 1):
                    # type 1 is omitted
                    valid = False
                    pass
                else:
                    valid = True
                    tmp['type']=t
                    tmp['IDs']=[]
            if (line.startswith("Position:")):
                if valid:
                    tmp['IDs'].append(ID)
                    ID+=1
        if tmp:
            ret.append(tmp)
    # dump ret
    with open("pairs.json", "w") as f:
        json.dump(ret, f, indent=2)



def gen_result_json():
    result_file = 'iclones-exp/ioidpath.txt'
    ret = {}
    with open(result_file) as f:
        for line in f:
            [ID,Input,Output,path] = line.split()
            obj = {}
            obj['ID'] = ID
            obj['input'] = Input
            obj['output'] = Output
            obj['path'] = path
            ret[ID] = obj
    with open('ioidpath.json', 'w') as f:
        json.dump(ret, f, indent=2)
    # return ret
            
def compare():
    """
    compare for the pairs of clones, if the IO data is the same
    The output should be:
    - how many in total
    - how many have same amount of input/output
    - how many match the type of variable
    - how many match all IO data

    The output present format:
    
    """
    # res = gen_result_json()
    res = json.load(open('ioidpath.json'))
    pairs = json.load(open('pairs.json'))
    classID = 0
    ret = []
    for pair in pairs:
        objs = []
        for ID in pair['IDs']:
            if str(ID) in res:
                obj = res[str(ID)]
                objs.append(obj)
        # now everything is in objs, compare them
        print ("One class: ")
        classObj = {}
        classObj['classID'] = classID
        classID+=1
        classObj['type'] = pair['type']
        pairsObj = []
        for i in range(len(objs)):
            for j in range(i+1,len(objs)):
                pairObj = {}
                pairObj['ID1'] = objs[i]['ID']
                pairObj['ID2'] = objs[j]['ID']
                # compare i and j
                print ("comparing " + objs[i]['ID'] + ' and ' + objs[j]['ID'] + ' ...')
                clone=compare_file(objs[i]['path'], objs[j]['path'])
                pairObj['clone'] = clone
                pairsObj.append(pairObj)
                # if (clone):
                #     print ("is clone")
                # else:
                #     print ("is NOT clone")
        if pairsObj:
            classObj['pairs'] = pairsObj
            ret.append(classObj)
    # dump ret into file
    with open('clone_compare_result.json', 'w') as f:
        json.dump(ret, f, indent=2)
    return ret
        # for obj in objs:
        #     print (obj['input'] + '/' + obj['output'])

def compare_file(file1, file2):
    """
    comparing file1 and file2
    The format is
    input: int a=8
    output: char c=e
    """
    with open(file1) as f1, open(file2) as f2:
        f1_inputs = []
        f1_outputs = []
        f2_inputs = []
        f2_outputs = []
        # get input from f1
        # get output from f1
        # get input from f2
        # get output from f2
        for line in f1:
            t=line.split()[1] # type
            v=line.split('=')[1] # value
            if line.startswith('input'):
                f1_inputs.append({'type': t, 'value': v})
            if line.startswith('output'):
                f1_outputs.append({'type': t, 'value': v})
        for line in f2:
            t=line.split()[1] # type
            v=line.split('=')[1] # value
            if line.startswith('input'):
                f2_inputs.append({'type': t, 'value': v})
            if line.startswith('output'):
                f2_outputs.append({'type': t, 'value': v})
        # comparing f1 and f2
        # now only compare in alphabetical order
        # i'll do a arbitrary combination later
        if not len(f1_inputs) == len(f2_inputs): return False
        if not len(f1_outputs) == len(f2_outputs): return False
        for i in range(len(f1_inputs)):
            if not f1_inputs[i]['value'] == f2_inputs[i]['value']: return False
        for i in range(len(f1_outputs)):
            if not f1_outputs[i]['value'] == f2_outputs[i]['value']: return False
        return True

def analyze_whole():
    j=json.load(open("wholesel.json"))
    len(j)
if __name__ == '__hebi__':
    # process()
    analyze_whole()
    get_pairs()
    gen_result_json()
    compare_res = compare()
    pass
