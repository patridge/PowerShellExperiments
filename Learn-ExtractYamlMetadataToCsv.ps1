Install-Module powershell-yaml

# Extracting to CSV to incorporate into a query exported from Azure DevOps into CSV, opened in Excel.
# Changes made to exported CSV can be re-imported for a bulk edit (you can review before changes are made).
Get-ChildItem -Recurse index.yml | % { Get-Content $_ | ConvertFrom-Yaml } | % { "$($_.uid),$($_.metadata["ms.author"]),<$($_.metadata["ms.author"])@microsoft.com>" } | Set-Clipboard