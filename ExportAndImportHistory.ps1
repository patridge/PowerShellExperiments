## Export history to XML format
Get-History | Export-Clixml -Path ~/Desktop/pwsh-history.xml

## [untested] Import the history from exported XML
Add-History -InputObject (Import-Clixml -Path ~\Desktop\pwsh-history.xml)
