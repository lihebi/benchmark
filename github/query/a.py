#!/usr/bin/env python3

from urllib import request
import json


def get_repo():
    url = 'https://api.github.com'
    api = '/search/repositories'
    query_str = ['language:C',
                 # 'sort=stars',
                 # 'order=desc',
                 # 'stars:>10',
                 # 'stars:1..384',
                 'stars:1..64',
    ]
    query = url + api + '?q=' + '+'.join(query_str) + '&per_page=100'
    token = '995b6274688ce47a82ce72cd09bb7866eca1e460'
    objs = []
    for i in range(1,11):
        print ("page ", i, "...")
        paged_query = query + '&page=' + str(i);
        print (paged_query)
        req = request.Request(paged_query)
        req.add_header("Authorization", "token " + token)
        response = request.urlopen(req)
        s = response.read().decode('utf8')
        j = json.loads(s);

        for item in j['items']:
            obj={}
            obj['name'] = item['name']
            obj['full_name'] = item['full_name']
            obj['stars'] = item['stargazers_count']
            obj['language'] = item['language']
            obj['size'] = item['size']
            objs.append(obj)
    return objs

def connect():
    repo=[]
    s=set()
    for i in range(1,7):
        j=json.load(open('result-' + str(i) + '.json'))
        for item in j:
            # remove duplicate
            if item['name'] in s: continue
            s.add(item['name'])
            repo.append(item)
        # repo.extend(j)
    json.dump(repo, open('all.json', 'w'), indent=2)
    return repo

repo=connect()
# objs=get_repo()
# json.dump(objs, open('repos.json', 'w'), indent=2)

# if __name__ == '__main__':
#     # TODO multi-thread
#     search("C", 1);

