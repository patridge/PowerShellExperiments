# 1. Get a list of the .yml files (which are the page endpoints, vs. .md include files, which may include sub-page embed content)
# 2. For each, replace .yml with .md, because that's what the redirect tool expects
# 3. For each, generate a redirect JSON section
Get-ChildItem *.yml | % { $_.Name.Replace(".yml", ".md") } | % { "{ ""source_path"": ""physical/repo/path/to/whatever-module-is-being-retired/$_"", ""redirect_url"": ""https://docs.microsoft.com/learn/new-module-replacing-the-retired-content"", ""redirect_document_id"": false }," }

Get-ChildItem -Directory | % { Get-ChildItem $_ -Filter *.yml | % { Write-Output $_.Name } }

# To generate Microsoft Docs redirects (.openpublishing.redirection.json) entries for a folder of modules, load this script into a .ps1 file and run it from the folder location.
ForEach ($moduleDirectory in Get-ChildItem -Directory) {
    $unitYamlFiles = Get-ChildItem $moduleDirectory -Filter *.yml
    $unitYamlFiles | % {
        $ymlName = $_.Name
        $mdName = $ymlName.Replace(".yml", ".md")
        $noExtensionName = $_.Name.Replace(".yml", "")
        $redirectLastSegment = "$noExtensionName"
        Write-Output "    {`n      ""source_path"": ""learn-pr/languages/$($moduleDirectory.Name)/$mdName"",`n      ""redirect_url"": ""https://docs.microsoft.com/learn/modules/$($moduleDirectory.Name)/$redirectLastSegment"",`n      ""redirect_document_id"": true`n    },"
    }
}

# Notes
# * The `source_path` is the local file path and may not look remotely similar to the web URL.
# * Even though modules and paths don't have an index.md file locally, you still write the redirect against a `source_path` that includes `index.md`.
