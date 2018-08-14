#!/bin/bash
# JQ required
# List of placeIDs:
# https://community.healthcatalyst.com/api/core/v3/places?filter=type(space,group)&fields=-resources,placeID,displayName,-id,-typeCode&count=100&startIndex=0

rm bin/space-followers/*

for place in <PLACEID>; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/places/"$place"/followers?fields=-resources&count=100&startIndex=0&directive=silent" > bin/space-followers/"$place".json

done

### Assemble them
cd bin/space-followers

# Remove return header
sed -i '1,22d' *.json

# Merge all to prep for jq (jq won't iterate over `*.json`)
cat *.json > 1.json

jq -s '.[] | .list[]' <1.json >2.json

jq '{ id, followerCount, published, updated, displayName, mentionName, email: .emails[].value, followingCount, lastProfileUpdate: .jive.lastProfileUpdate, level: .jive.level.name, points: .jive.level.points, locale: .jive.locale, timeZone: .jive.timeZone, username: .jive.username, firstName: .name.givenName, lastName: .name.familyName, fullName: .name.formatted, type, typeCode }' <2.json >3.json

jq -s . <3.json >space-followers.json
