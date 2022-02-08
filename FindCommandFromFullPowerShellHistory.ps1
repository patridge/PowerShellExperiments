# This is to help find a prior command you know you ran based on some word within it.
# Get-History is just for the current session, and not really that useful.
# If you have PSReadline installed, the contents of the file saved at `(Get-PSReadlineOption).HistorySavePath` is the real history.
# In this case, I'm looking for a command I ran that included a call to `Remove-Item` somewhere within it.
Get-Content (Get-PSReadlineOption).HistorySavePath | ? { $_ -like '*Remove-Item*' }

# Also, there are also more comprehensive history locations that may be worth searching.
Get-Content "${env:APPDATA}\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt" | ? { $_ -like '*Remove-Item*' }
Get-Content "${env:APPDATA}\Microsoft\Windows\PowerShell\PSReadline\Visual Studio Code Host_history.txt" | ? { $_ -like '*Remove-Item*' }
