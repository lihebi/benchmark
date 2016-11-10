#!/usr/bin/env python3


"""
This script process the output of preprocess, and try to extract the projects that successed.
The output format will be

(benchmarkID time)

on each line

Comment out the specific file to select different files.
"""

def process(file):
    all_benchmarks=[]
    data={}
    """
    data can have:
    - id
    - success
    - time
    """
    data['id']=''
    data['time']=''
    data['success']=False
    for line in open(file):
        if line.startswith('Processing'):
            ID=line.split()[1]

            if 'time' in data and not data['time']:
                data['success'] = False
            all_benchmarks.append(data)
            data={}
            # data.clear()
            data['id']=ID
            data['time']=''
            data['success']=True
        elif line.startswith('Compiler'):
            continue
        elif line.startswith('Creating'):
            continue
        elif line.startswith('opening'):
            continue
        elif line.startswith('Outputing'):
            continue
        elif line.startswith('creating'):
            continue
        elif not line:
            continue
        elif not line.strip():
            continue
        elif line.startswith('real'):
            data['time']=line.split()[1]
        elif line.startswith('user'):
            pass
        elif line.startswith('sys'):
            pass
        else:
            # print(line)
            data['success']=False
    return all_benchmarks

if __name__ == '__main__':
    # file='preprocess-log-1.txt'
    file='preprocess-log-2.txt'
    all_benchmarks=process(file)
    for bench in all_benchmarks:
        if bench['success']:
            print(bench['id'], bench['time'])
            pass
        # else:
        #     print('failed: ', bench['id'], bench['time'])

