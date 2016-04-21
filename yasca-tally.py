#!/usr/bin/python
#
# Tally vulnerability category counts from a saved 
# YASCA (http:yasca.org) report json file
#
import json

with open('results.json') as data_file:
	data = json.load(data_file)

cats = []
for record in data:
	cats.append(str(record['severity']) + ', ' + record['category'])

out = [[x, cats.count(x)] for x in set(cats)]

for record in out:
	print("%s, %s" % (record[0],  record[1]))
