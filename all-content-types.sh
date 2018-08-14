#!/bin/bash
# JQ required
# Click URL in commented out section under each content type to see if an extra 100 needs to be added to the set (and to the end of the commented out URL)

rm bin/all-content-types/*

### DISCUSSION
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(discussion)&fields=-content.text&count=100&startIndex=700

for set in 0 100 200 300 400 500 600 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(discussion)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/discussion_"$set".json

done

### DOC
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(document)&fields=-content.text&count=100&startIndex=600

for set in 0 100 200 300 400 500 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(document)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/doc_"$set".json

done

### FILE
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(file)&count=100&startIndex=1000

for set in 0 100 200 300 400 500 600 700 800 900 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(file)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/file_"$set".json

done

### IDEA
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(idea)&fields=-content.text&count=100&startIndex=600

for set in 0 100 200 300 400 500 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(idea)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/idea_"$set".json

done

### POLL
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(poll)&fields=-content.text&count=100&startIndex=100

for set in 0 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(poll)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/poll_"$set".json

done

### POST
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(post)&fields=-content.text&count=100&startIndex=200
for set in 0 100 ; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(post)&fields=-content.text&count=100&startIndex="$set"&directive=silent" > bin/all-content-types/post_"$set".json

done

### VIDEO
# https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(video)&fields=-content.text,-videoMetadata&startIndex=300

for set in 0 100 200; do

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/v3/contents?sort=latestActivityDesc&filter=type(video)&fields=-content.text,-videoMetadata&startIndex="$set"&count=100&directive=silent" > bin/all-content-types/video_"$set".json

done

### ASSEMBLE THEM
cd bin/all-content-types

# Remove return header
sed -i '1,22d' *.json

# Merge all to prep for jq (jq won't iterate over `*.json`)
cat *.json > 1.json

jq -s '. | .[] | .list[]' <1.json >2.json
jq . -s <2.json >3.json

jq '.[] | { id, contentID, subject, fileName: .name, status, type, typeCode, publishedDateTime: .publishDate, lastActivityDate, version, attachments, question, questionArchived: .archived, questionResolved: .resolved, sameQuestionCount, viewCount, likeCount, favoriteCount, replyCount, commentCount, followerCount, helpfulCountOutcome: .outcomeCounts.helpful, helpfulCount, unhelpfulCount, voteCount, ideaScore: .score, ideaStage: .stage, fileSize: .size, fileContentType: .contentType, pollStartDate: .startDate, pollEndDate: .endDate, pollOptions: .options, pollVotes: .votes, pollVoteDates: .voteDates, videoInline: .inline, videoEmbedded: .embedded, videoDuration: .duration, videoHours: .hours, videoMinutes: .minutes, videoSeconds: .seconds, videoType, tags, categories, parentPlaceName: .parentPlace.name, parentPlaceType: .parentPlace.type, parentPlaceID: .parentPlace.id, parentPlacePlaceID: .parentPlace.placeID, authorID: .author.id, authorFollowerCount: .author.followerCount, authorDisplayName: .author.displayName, authorEmail: .author.emails[].value, authorFollowingCount: .author.followingCount, authorLevel: .author.jive.level.name, authorPoints: .author.jive.level.points, authorTimeZone: .author.jive.timeZone, authorUsername: .author.jive.username, authorLocation: .author.location, authorLastName: .author.name.familyName, authorFirstName: .author.name.givenName, authorFullName: .author.name.formatted, authorTypeCode: .author.typeCode }' <3.json >4.json

jq -s . <4.json >all-content-types.json

# Export list of tags
jq '.[] | .tags[]' <all-content-types.json >a.json
jq . -s <a.json >tags.json

# Export list of categories
jq '.[] | .categories[]' <all-content-types.json >b.json
jq . -s <b.json >categories.json
