# Notes
# * In a redirect JSON block, the `source_path` is the local file path and may not look remotely similar to the web URL.
# * Even though Learn modules and learning paths don't have an index.md file locally, you still write the redirect against a `source_path` that includes `index.md`.

# Prerequisites:
# * Run in PowerShell command line from the locally cloned repo folder.
# * Create module entries for each module to process
#
# Script process:
# 0. Given a set of modules to process…
# 1. Get a list of the .yml files (which are the page endpoints, vs. .md include files, which may include sub-page embed content).
# 2. For each, replace .yml with .md, because that's what the redirect tool expects.
# 3. For each, generate a redirect JSON section with whitespace.
@(
    # Include as many modules as you need here.
    # [PSCustomObject]@{
    #     OldModulePath = "learn-pr/azure/old-module-path";
    #     NewModuleUrl = "new-module-folder-name"
    # },
    [PSCustomObject]@{
        OldModulePath = "learn-pr/azure/predict-costs-and-optimize-spending";
        NewModuleUrl = "plan-manage-azure-costs"
    }
) | % { $module = $_; Get-ChildItem -Path $module.OldModulePath *.yml | % { $_.Name.Replace(".yml", ".md") } | % { $unit = $_; $oldPath = $module.OldModulePath; $newUrl = $module.NewModuleUrl; "    {`n      ""source_path"": ""$oldPath/$unit"",`n      ""redirect_url"": ""https://docs.microsoft.com/learn/modules/$newUrl"",`n      ""redirect_document_id"": false`n    }" } } | Join-String -Separator ",`n"

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
