# Find all modules and paths with publish date of Nov/Dec 2019
Get-ChildItem -Path .\learn-pr\ -Filter index.yml -Recurse | % { [pscustomobject]@{ File = $_; Uid = (Select-String -Path $_ -Pattern "^uid"); MsDateLine = (Select-String -Path $_ -Pattern "ms.date") } } | ? { $_.MsDateLine -Match ".*((11)|(12))/.*/2019.*" } | % { $_.Uid.Line + ": " + $_.MsDateLine.Line } | clip

# Find all modules and paths with publish date of Dec 2019-Jan 2020
Get-ChildItem -Path .\learn-pr\ -Filter index.yml -Recurse | % { [pscustomobject]@{ File = $_; Uid = (Select-String -Path $_ -Pattern "^uid"); MsDateLine = (Select-String -Path $_ -Pattern "ms.date") } } | ? { $_.MsDateLine -Match ".*12/.*/2019.*" -Or $_.MsDateLine -Match ".*01/.*/2020.*" } | % { $_.Uid.Line + ": " + $_.MsDateLine.Line } | clip

# Find all paths with publish date of Nov/Dec 2019
Get-ChildItem -Path .\learn-pr\paths -Filter index.yml -Recurse | % { [pscustomobject]@{ File = $_; Uid = (Select-String -Path $_ -Pattern "^uid"); MsDateLine = (Select-String -Path $_ -Pattern "ms.date") } } | ? { $_.MsDateLine -Match ".*((11)|(12))/.*/2019.*" } | % { $_.Uid.Line + ": " + $_.MsDateLine.Line } | clip

# Find all paths with publish date of Dec 2019-Jan 2020
Get-ChildItem -Path .\learn-pr\paths -Filter index.yml -Recurse | % { [pscustomobject]@{ File = $_; Uid = (Select-String -Path $_ -Pattern "^uid"); MsDateLine = (Select-String -Path $_ -Pattern "ms.date") } } | ? { $_.MsDateLine -Match ".*12/.*/2019.*" -Or $_.MsDateLine -Match ".*01/.*/2020.*" } | % { $_.Uid.Line + ": " + $_.MsDateLine.Line } | clip
