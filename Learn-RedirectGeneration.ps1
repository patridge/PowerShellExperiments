# 1. Get a list of the .yml files (which are the page endpoints, vs. .md include files, which may include sub-page embed content)
# 2. For each, replace .yml with .md, because that's what the redirect tool expects
# 3. For each, generate a redirect JSON section
Get-ChildItem *.yml | % { $_.Name.Replace(".yml", ".md") } | % { "{ ""source_path"": ""physical/repo/path/to/whatever-module-is-being-retired/$_"", ""redirect_url"": ""https://docs.microsoft.com/learn/new-module-replacing-the-retired-content"", ""redirect_document_id"": false }," }

# Notes
# * The `source_path` is the local file path and may not look remotely similar to the web URL.
# * Even though modules and paths don't have an index.md file locally, you still write the redirect against a `source_path` that includs `index.md`.