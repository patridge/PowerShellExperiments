# Get all files in /media. Any files that can't be found in Markdown files within the /includes folder get deleted.
# NOTE: Run this from the folder containing a single module.
Get-ChildItem .\media\ | Where { (Get-ChildItem .\includes\*.md | Select-String $_.Name).Count -eq 0 } | ForEach { $_.FullName } | Remove-Item