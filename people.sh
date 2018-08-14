#!/bin/bash
# JQ required

rm bin/people/*

### Click commented out URL to see if an extra 100 needs to be added to the set (and to the end of the commented out URL)
# https://community.healthcatalyst.com/api/core/v3/people?count=100&startIndex=2100

for set in 0 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/people?fields=-resources&count=100&startIndex="$set"&directive=silent" > bin/people/"$set".json

done

### ASSEMBLE THEM
cd bin/people

# Remove return header
sed -i '1,22d' *.json

# Merge all to prep for jq (jq won't iterate over `*.json`)
cat *.json > 1.json

jq -s '.[] | .list[]' <1.json >2.json

jq '{ id, followerCount, published, updated, displayName, mentionName, email: .emails[].value, followingCount, lastProfileUpdate: .jive.lastProfileUpdate, level: .jive.level.name, points: .jive.level.points, locale: .jive.locale, timeZone: .jive.timeZone, username: .jive.username, firstName: .name.givenName, lastName: .name.familyName, fullName: .name.formatted, type, typeCode }' <2.json >3.json

jq -s . <3.json >people.json
