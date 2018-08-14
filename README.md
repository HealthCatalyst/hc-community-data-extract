# hc-community-data-extract

Jive is the platform for HC Community. Using the Jive API, more data can be extracted than what is surfaced in the analytics boxed up with Jive. The scripts in this project extract the following:

**contents.sh** - Extracts a JSON file with an object for each discussion, doc, file, idea, poll, post, and video (not included: direct messages, external objects like RSS feed items); includes counts of favorites, likes, views, downloads, etc.

**places.sh** - Extracts a JSON file with an object for each Jive space (aka group or place); includes number of followers and other counts

**place-followers.sh** - Extracts a JSON file with names of users following a specified space

**people.sh** - Extracts a JSON file with an object for each user; includes number of followers, location, join date, etc.

**too-100-search-terms.sh** - Extracts a JSON file with an object for the top 100 *successful* search terms

The JSON files are uploaded to an Azure blob with an AZURE CLI script and the blob is connected to a Power BI report.
