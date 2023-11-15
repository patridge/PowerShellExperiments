# Add a shortcut to create a new tab in the current directory
## Edit the current profile
code $PROFILE
## Add this shortcut to the profile
### Via Nick Craver (https://twitter.com/nick_craver/status/1584407350235910144)
function New-Tab { wt --window 0 new-tab --startingDirectory . }
