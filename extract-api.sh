#!/bin/bash

# This script extracts the following objects from HC Community and uploads them to an Azure blob:
# - Contents (discussions, documents, files, ideas [i.e., feature requests] polls, posts [i.e., blog posts], and videos; categories; tags)
# - People
# - Places (i.e., spaces and groups)
# - A list of categories and tags used across the community
# - Top 100 successful search terms (default is all-time; date range can be modified)

# Requirements
# - JQ
# - Azure CLI (`az`)

# Prerequisites
# - Create an Azure blob
# - Collect the container name, account name, account key

set -x

# Create directory of files to be uploaded to the Azure blob
rm -r bin
mkdir -p bin/uploads

###### Contents, people, places
for type in contents people places; do

cd bin
mkdir "$type"
cd "$type"

for ((i=0; ; i+=100)); do
    objects=$(curl -u "username:password" -H "Content-Type: application/json" "https://<yourinstance>.jiveon.com/api/core/v3/"$type"?fields=-resources,-content.text&count=100&directive=silent&startIndex=$i")
    echo "$objects" > $i.json
    if jq -e '.list | length == 0' >/dev/null; then 
       break
    fi <<< "$objects"
    jq -s '.[] | .list[]' <<< "$objects" > $i.json
done

# Concatenate all objects
cat *.json >"$type"-1.json

# Select keys/values
jq -s . <"$type"-1.json >"$type"-2.json

## Contents
if [[ "$type" == "contents" ]] ;
then
jq '.[] | { id, contentID, subject, fileName: .name, status, type, typeCode, publishedDateTime: .publishDate, lastActivityDate, version, attachments, question, questionArchived: .archived, questionResolved: .resolved, sameQuestionCount, viewCount, likeCount, favoriteCount, replyCount, commentCount, followerCount, helpfulCountOutcome: .outcomeCounts.helpful, helpfulCount, unhelpfulCount, voteCount, ideaScore: .score, ideaStage: .stage, fileSize: .size, fileContentType: .contentType, pollStartDate: .startDate, pollEndDate: .endDate, pollOptions: .options, pollVotes: .votes, pollVoteDates: .voteDates, videoInline: .inline, videoEmbedded: .embedded, videoDuration: .duration, videoHours: .hours, videoMinutes: .minutes, videoSeconds: .seconds, videoType, tags, categories, parentPlaceName: .parentPlace.name, parentPlaceType: .parentPlace.type, parentPlaceID: .parentPlace.id, parentPlacePlaceID: .parentPlace.placeID, authorID: .author.id, authorFollowerCount: .author.followerCount, authorDisplayName: .author.displayName, authorFollowingCount: .author.followingCount, authorLevel: .author.jive.level.name, authorPoints: .author.jive.level.points, authorTimeZone: .author.jive.timeZone, authorUsername: .author.jive.username, authorLocation: .author.location, authorLastName: .author.name.familyName, authorFirstName: .author.name.givenName, authorFullName: .author.name.formatted, authorTypeCode: .author.typeCode }?' <"$type"-2.json >"$type"-3.json
fi

## People
if [[ "$type" == "people" ]] ;
then
jq '.[] | { id, followerCount, published, updated, displayName, mentionName, followingCount, lastProfileUpdate: .jive.lastProfileUpdate, level: .jive.level.name, points: .jive.level.points, locale: .jive.locale, timeZone: .jive.timeZone, username: .jive.username, firstName: .name.givenName, lastName: .name.familyName, fullName: .name.formatted, type, typeCode }?' <"$type"-2.json >"$type"-3.json
fi

## Places
if [[ "$type" == "places" ]] ;
then
jq '.[] | { id, followerCount, published, updated, placeID, contentTypes, displayName, name, parent, status, viewCount, placeTopics, type, typeCode }?' <"$type"-2.json >"$type"-3.json
fi

jq -s . <"$type"-3.json >"$type".json

# Copy to directory of files to be uploaded to the Azure blob
cd ..
cd ..
cp bin/"$type"/"$type".json bin/uploads

done

###### Categories and tags
cd bin/contents

# Export list of categories
jq '.[] | .categories[]?' <contents.json >b.json
jq . -s <b.json >categories.json

# Export list of tags
jq '.[] | .tags[]?' <contents.json >a.json
jq . -s <a.json >tags.json

# Copy to directory of files to be uploaded to the Azure blob
cd ..
cd ..
cp bin/contents/categories.json bin/uploads
cp bin/contents/tags.json bin/uploads



###### Top 100 search terms
# - The default date range is all time until present day. To customize the date range, change `after` and `before` dates in the cURL command (e.g., `after=2018-01-01T00:00:00.000Z&before=2019-01-01T00:00:00.000Z`).
query="top-100-search-terms"

cd bin
mkdir "$query"
cd "$query"

curl -u "username:password" -H "Content-Type: application/json" "https://<yourinstance>.jiveon.com/api/core/ext/community-manager-reports/v1/aggregation/top/searches?after=2016-04-01T00:00:00.000Z&before=$(date +%F)T00:00:00.000Z&count=100&directive=silent" >"$query"-1.json

# Select keys/values
jq -s '.[] | .result' <"$query"-1.json >"$query".json

# Copy to directory of files to be uploaded to the Azure blob
cd ..
cd ..
cp bin/"$query"/"$query".json bin/uploads


###### Upload to Azure blob
#chmod +x blob.cmd
#./blob.cmd
