## NOTE: History and the lines you see when you press the up arrow are different. Exporting your history will not necessarily include everything you see when you press the up arrow.

## Export history to XML format
Get-History | Export-Clixml -Path ~/Desktop/pwsh-history.xml

## [untested] Import the history from exported XML
Add-History -InputObject (Import-Clixml -Path ~\Desktop\pwsh-history.xml)
