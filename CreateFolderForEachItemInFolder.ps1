## Create a folder for each item we find in the current directory that match a criteria
## For example, for all *.txt files, create a folder of the filename without the .txt extension (./somefile.txt -> ./somefile/)
Get-ChildItem *.txt | % { New-Item -Path $_.PSParentPath -Name $_.BaseName -ItemType "Directory" }

## I also had to do this for my media on Plex, creating a folder for each video and then copying the files into the new folder.
Get-ChildItem *.txt | Select-Object -First 1 | % { New-Item -Path $_.PSParentPath -Name $_.BaseName -ItemType "Directory"; Move-Item -Path $_ -Destination $_.BaseName }
