#!/bin/bash
# JQ required
# Find a list of placeIDs:
## Option 1: https://<yourinstance>.com/api/core/v3/places?filter=type(space,group)&fields=-resources,placeID,displayName,-id,-typeCode&count=100&startIndex=0
## Option 2: After you have run `extract-api.sh`, inside `bin/places` run `jq -r '.[].placeID' < places-2.json > jq.txt`. In `jq.txt` replace hard returns with spaces.

cd bin
mkdir space-followers
cd space-followers

for place in 1234 5678 ; do

curl -u "username:password" -H "Content-Type: application/json" "https://<yourinstance>.jiveon.com/api/core/v3/places/"$place"/followers?fields=-resources&count=100&startIndex=0&directive=silent" > "$place".json

done

# Merge all to prep for jq (jq won't iterate over the string `*.json` in this script)
cat *.json > 1.json

jq -s . < 1.json > space-followers.json
