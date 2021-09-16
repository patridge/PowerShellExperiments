# Create file with variable name of `x`
New-Item x -Type file

# Bulk change of file extension
# In this case, I'm changing a bunch of audiobook CD files from .m4a to .m4b to use them in the audiobook portion of the iTunes/Music app on macOS
Get-ChildItem . -Recurse -Filter *.m4a | Rename-Item -NewName {[System.IO.Path]::ChangeExtension($_.Name, ".m4b")}
# Equivalent with an explicit setting of the `-Path` parameter (implied above)
Get-ChildItem . -Recurse -Filter *.m4a | % { Rename-Item -Path $_ -NewName ([System.IO.Path]::ChangeExtension($_.Name, ".m4b")) }

# Get name of current folder (without full path)
# Example: C:\whatever -> "whatever"
# (???: There may be some difference between the current location and where the command was run.)
[System.IO.Path]::GetFileName((Get-Location).Path)
[System.IO.Path]::GetFileName($PWD.Path)

# Are two file byte arrays equal (Note: diff output when not the same is not really useful on byte arrays)
-not (Compare-Object -ReferenceObject ([System.IO.File]::ReadAllBytes("path\to\file1")) -DifferenceObject ([System.IO.File]::ReadAllBytes("path\to\file2")))
Get-ChildItem -Recurse -File | Sort-Object -Property Name | % { Get-FileHash -Path $_ -Algorithm MD5 }
Get-ChildItem -Recurse -File | Sort-Object -Property Name | % { Get-FileHash -Path $_ -Algorithm SHA256 }

# Compare file hash to known valid value
$ValidHash = "ABC123"
$CalculatedHash = Get-FileHash -Path '~\Downloads\SomeFile.zip' -Algorithm MD5 # Or SHA256, etc.
$ValidHash -eq $CalculatedHash.Hash
