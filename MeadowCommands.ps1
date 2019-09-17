# Reformat [beta] Meadow board
# (These are not PowerShell, specific.)
mono MeadowCLI.exe --EraseFlash
mono MeadowCLI.exe --PartitionFileSystem -n 2
mono MeadowCLI.exe --MountFileSystem
mono MeadowCLI.exe --InitializeFileSystem
# Wait 20 minutes for formatting
# Reset board after 20 minutes

# PowerShell to test path length limit

## Assembled call (doesn't shortcut fail on first error!)
[System.Linq.Enumerable]::Range(1,40) `
 | % { New-Object string -ArgumentList @('a', $_) } `
 | % { New-Item ./temp-file-length-testing/$_ -Type file } `
 | % { mono ./MeadowCLI.exe --WriteFile -f $_ }

## Clean up after test
[System.Linq.Enumerable]::Range(1,40) `
 | % { New-Object string -ArgumentList @('a', $_) } `
 | % { mono ./MeadowCLI.exe --DeleteFile --TargetFileName $_ }
