#!/bin/bash
# JQ required
# Jive limits search-term objects returned to 100

rm bin/top-100-search-terms/*

todaysdate="2018-08-13"

curl GET -i -v -u "USERNAME:PASSWORD" -H "Content-Type: application/json" "https://community.healthcatalyst.com/api/core/ext/community-manager-reports/v1/aggregation/top/searches?after=2016-04-01T00:00:00.000Z&before="$todaysdate"T00:00:00.000Z&count=100&directive=silent" > bin/top-100-search-terms/1.json

cd bin/top-100-search-terms

sed -i '1,22d' 1.json
jq -s '.[] | .result' <1.json >top-100-search-terms.json
