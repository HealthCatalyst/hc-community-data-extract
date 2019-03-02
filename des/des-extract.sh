#!/bin/bash

# Data Export Service extracts

# Prerequisites
# - Create a file inside the `des` directory named `client-id` (no filename extension) that contains the client ID
# - Create a file at root inside the `des` directory named `client-secret` (no filename extension) that contains the client secret
# To find the client ID and secret: Inside HC Community, click your avatar dropdown > Add-Ons > the cog next to Cloudalytics Dashboard > View Client ID and Secret
# Available filters for additional reports: https://community.jivesoftware.com/docs/DOC-99916#jive_content_id_List_of_All_Data_Export_Events

## Relationships
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_APPROVE_USERRELATIONSHIP,ACTIVITY_REJECT_USERRELATIONSHIP)&directive=silent' > des-relationships.json

## Searches
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_MAINSEARCH,ACTIVITY_PEOPLE_SEARCH,ACTIVITY_CONTENT_OR_PLACES_SEARCH,ACTIVITY_SPOTLIGHT_SEARCH)&directive=silent' > des-search.json

## Profiles
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_LOGIN_USER)&directive=silent' > des-logins.json

## Views of space and group home pages
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_VIEW_COMMUNITY,ACTIVITY_VIEW_SOCIALGROUP)&directive=silent' > des-home-pages.json

## Direct messages
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_DIRECTMESSAGE,ACTIVITY_COMMENT_DIRECTMESSAGE)&directive=silent' > des-dm.json

## Views of user profiles
./des-export-json 2016-01-01 $(date +%F) 'filter=name(ACTIVITY_VIEW_USER)&directive=silent' > des-user-views.json
