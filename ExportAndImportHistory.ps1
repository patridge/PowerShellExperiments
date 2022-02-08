## NOTE: History and the lines you see when you press the up arrow are different. Exporting your history will not necessarily include everything you see when you press the up arrow.

## Export history to XML format
Get-History | Export-Clixml -Path ~/Desktop/pwsh-history.xml

## [untested] Import the history from exported XML
Add-History -InputObject (Import-Clixml -Path ~\Desktop\pwsh-history.xml)

## If you have PSReadline installed, there's a whole lot of console history to be found in log files it maintains.
code "${env:APPDATA}\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
code "${env:APPDATA}\Microsoft\Windows\PowerShell\PSReadline\Visual Studio Code Host_history.txt"
