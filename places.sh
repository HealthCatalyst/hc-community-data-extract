#!/bin/bash
# JQ required

rm bin/places/*

### Click commented out URL to see if an extra 100 needs to be added to the set (and to the end of the commented out URL)
# https://community.healthcatalyst.com/api/core/v3/places?count=100&startIndex=400

for set in 0 100 200 300; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/places?&fields=-resources&count=100&startIndex="$set"&directive=silent" > bin/places/"$set".json

done

### Assemble them
cd bin/places

# Remove return header
sed -i '1,22d' *.json

# Merge all to prep for jq (jq won't iterate over `*.json`)
cat *.json > 1.json

jq -s '.[] | .list[]' <1.json >2.json

jq '{ id, followerCount, published, updated, placeID, contentTypes, displayName, name, parent, status, viewCount, placeTopics, type, typeCode }' <2.json >3.json

jq -s . <3.json >places.json
