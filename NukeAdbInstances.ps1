# If VS left an ADB instance around that prevents you from deleting or moving your Xamarin.Android projects, this will kill the process.
# You might also be able to get away with `adb kill-server`.

# This will find "adb" processes and stop them, then do a list of any it finds to verify you got them all.
Get-Process | ? { $_.ProcessName -eq "adb" } | % { Stop-Process -Id $_.Id }; Get-Process | ? { $_.ProcessName -eq "adb" }
