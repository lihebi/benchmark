#!/usr/bin/env python3

import json



if __name__ == '__main__':
    # the 0 is the same as 1
    # the valid data is from 1 to 10
    for i in range(1,11):
        filename='c-' + str(i) + '.json'
        j=json.load(open(filename))
        # print(len(j['items']))
        # https://github.com/lihebi/cs572-project/archive/master.zip
        prefix='https://github.com/'
        suffix='/archive/master.zip'
        for it in j['items']:
            # print(it['full_name'])
            fullname=it['full_name']
            star=it['stargazers_count']
            outputname=fullname.replace('/','--')
            # print(fullname + ' ' + str(star))
            print(prefix + fullname + suffix + ' -O ' + outputname + '.zip')
