# Get longest path length in a folder.
(Get-ChildItem -Recurse | % { $_.FullName } | Sort-Object -Descending -Property Length | Select-Object -First 1).Length
# Get longest path length in a folder, less any path additions to this version (e.g., "SomeProject - short" vs. "SomeProject").
# also equivalent to OrderBy(x => x.Length)
(Get-ChildItem -Recurse | % { $_.FullName } | Sort-Object -Descending -Property Length | Select-Object -First 1).Length - " - short".Length

# List all items sorted by full-name path length.
Get-ChildItem | %{ @{ Length = $_.FullName.Length; Name = $_.FullName } } | Sort-Object -Descending -Property Length
