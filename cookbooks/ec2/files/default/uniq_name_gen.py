#!/usr/bin/env python

import boto
import sys
import os

if len(sys.argv) != 4:
    print "Usage: uniq_name_gen.py <namespace> <key> <secret key>"
    sys.exit(1)

namespace = sys.argv[1]
sdb = boto.connect_sdb(sys.argv[2], sys.argv[3])

# myuuid creates a uniq nonce for ensuring ownership
myuuid = os.popen("uuidgen").read().rstrip()

# How many times to try given collisions
retries = 3

domain = sdb.create_domain(namespace)

def get_an_id(uuid):
    max_id = 5

    for item in domain:
        if int(item['id']) > max_id:
            max_id = int(item['id'])

    max_id = max_id + 1
    itemname = 'new_name_id_' + str(max_id)
    item = domain.new_item(itemname)
    item['id'] = max_id
    item['owner'] = uuid
    item.save()

    item = domain.get_item(itemname, consistent_read=True)
    if item == None or item['owner'] != uuid:
        return None
    else:
        return max_id

for i in range(retries):
    id = get_an_id(myuuid)
    if id == None:
        continue
    else:
        print id
        sys.exit(0)

sys.exit(1)
