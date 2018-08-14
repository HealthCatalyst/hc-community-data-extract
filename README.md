# hc-community-data-extract

Jive is the platform for HC Community. Using the Jive API, more data can be extracted than what is surfaced in the analytics boxed up with Jive. Extracting data with the API makes it possible to distinguish customer from team member usage, something the analytics boxed up with Jive does not.

The JSON and .csv files extracted using the scripts below are uploaded to an Azure blob with the Azure CLI scripts. The blob is connected to a Power BI report. 

For continually up-to-date data, load the scripts on a VM and use a timer like Windows Task Scheduler to execute the scripts at set intervals.

To assign an organization to a user, separate the user's email address at the `@` delimiter and use the last half of the address as the organization field.

| Script | What it does |
|--------|--------------|
| `contents.sh` | Extracts a JSON file with an object for each discussion, doc, file, idea, poll, post, and video (not included: direct messages, external objects like RSS feed items); includes counts of favorites, likes, views, downloads, etc.; also extracts JSON files for counts of categories and tags |
| `places.sh` | Extracts a JSON file with an object for each Jive space (aka group or place); includes number of followers and other counts |
| `place-followers.sh` | Extracts a JSON file with names of users following a specified space |
| `people.sh` | Extracts a JSON file with an object for each user; includes number of followers, location, join date, etc. |
| `too-100-search-terms.sh` | Extracts a JSON file with an object for each of the top 100 *successful* search terms |
| `activities/data` and `activities/data.sh` | A .csv file with an all-time history of activities data can be exported with a script that queries Jive Cloud Analytics. It provides a detailed record of which actor performed which action when. Follow the instructions at the top of `data`. Execute `data.sh`.|
| `azure-cli-blob-file.cmd` | Uploads a file to an Azure blob |
| `azure-cli-blob-batch.cmd` | Uploads a directory of files to an Azure blob |