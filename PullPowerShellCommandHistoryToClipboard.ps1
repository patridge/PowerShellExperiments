# These use OS-specific commands to get the data to the clipboad, so pick the platform of your choice.

# Get _all_ the history

# Windows
Get-History | % { $_.CommandLine } | clip
# macOS
Get-History | % { $_.CommandLine } | pbcopy

# Get a few of the history (up to `-Count`)

# Windows
Get-History -Count 5 | % { $_.CommandLine } | clip
# macOS
Get-History -Count 5 | % { $_.CommandLine } | pbcopy
