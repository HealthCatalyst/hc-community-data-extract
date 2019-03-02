# hc-community-data-extract

Using the Jive API, more data can be extracted than what is surfaced in the analytics boxed up with Jive. Extracting data with the API makes it possible to distinguish customer from employee usage, something the analytics boxed up with Jive does not.

The JSON and .csv files extracted using the scripts below are uploaded to an Azure blob with the Azure CLI scripts. An Azure blob can be connected to a Power BI report. These lines can be removed from the scripts easily if upload to an Azure blob is not desired.

For continually up-to-date data, two options are to:
- Load the scripts on a VM and use a timer like Windows Task Scheduler to execute the scripts at set intervals.
- Create a recurring Azure DevOps build that executes the scripts and publishes them to a destination.

Tip: If an organization a user belongs to is unclear, separate the user's email address at the `@` delimiter and use the last half of the address as an organization field.

## Scripts
## `extract-api.sh`
| Extract | What it includes | 
|---------|------------------|
| Contents | A JSON file with an object for each discussion, doc, file, idea, poll, post, and video (not included: direct messages, external objects like RSS feed items); includes counts of favorites, likes, views, downloads, etc.; also extracts JSON files for counts of categories and tags
| Places | A JSON file with an object for each Jive space (aka group or place); includes number of followers and other counts |
| People | A JSON file with an object for each user; includes number of followers, location, join date, etc. |
| Tags and categories | A JSON file for each that lists all in use across the community |
| Top 100 search terms | a JSON file with an object for each of the top 100 *successful* search terms |

Remove Azure CLI lines if uploading to an Azure blob is not desired.

## `place-followers.sh`
Extracts a file for each named `placeID` that has an object for each place follower. The JSON returned does not include the `placeID` when returned, which is why these are separated into individual files named with the `placeID`.

## /activities scripts
A .csv file with an all-time history of activities data can be exported with a script that queries Jive Cloud Analytics. It provides a highly useful detailed record of which actor performed which action when. Follow the instructions at the top of `data`. Execute `data.sh`.

## Azure CLI uploads (optional)
| `azure-cli-blob-file.cmd` | Uploads a file to an Azure blob |
| `azure-cli-blob-batch.cmd` | Uploads a directory of files to an Azure blob |
