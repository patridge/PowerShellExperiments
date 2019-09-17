# A bunch of commands I was using to migrate the Xamarin University content to new open source repositories.

Get-ChildItem | % { $_.Name } | ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } | ? { -Not (@("LICENSE", "README.md") -Contains $_) } | clip

Get-ChildItem -Directory | % { $_.Name } | ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } | ? { -Not (@("AND101") -Contains $_) } | % {  }

Get-ChildItem -Directory | % { $_.Name } | ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } | ? { -Not (@("AND101") -Contains $_) } | % { cd .\$_; git mv LICENSE LICENSE-CODE; git add -A; git commit -m "Make current license code-specific"; cd .. }

Get-ChildItem -Directory | % { $_.Name } | ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } | ? { -Not (@("AND101") -Contains $_) } | % { Copy-Item .\AND101\LICENSE .\$_; cd .\$_; git add -A; git commit -m "Add license for instructions"; cd .. }

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
#| ? { -Not (@("AND101") -Contains $_) } `
| Select -Skip 2 | Select -First 1 `
| % { Copy-Item -Force -Recurse "C:\dev\xamu-ilt\Course_Materials\$_ - *\Lab Materials\*" ".\$_\docs" } `
#| % { Move-Item ".\$_\docs\StartHere.html" ".\$_\docs\index.html" } `
#| % { Move-Item ".\$_\docs\Start Here.html" ".\$_\docs\index.html" } `
#| % { Remove-Item ".\$_\docs\LICENSE" }

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
| Select -Skip 1 `
| % { Copy-Item -Force -Recurse "C:\dev\xamu-ilt\Course_Materials\$_ - *\Lab Materials\*" ".\$_\docs" }

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
| Select -Skip 1 `
| % { Move-Item -Force ".\$_\docs\StartHere.html" ".\$_\docs\index.html" }

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
| Select -Skip 1 `
| % { Move-Item -Force ".\$_\docs\Start Here.html" ".\$_\docs\index.html" }

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
| Select -Skip 1 `
| % { Remove-Item -Force ".\$_\docs\LICENSE" }

# Get-ChildItem -Directory C:\dev\xamu-labs\ `
# | % { $_.Name } `
# | ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
# | ? { -Not (@("AND101") -Contains $_) } `
# | % { cd .\$_; git add docs\index.html; git add docs/parts/*; git commit -m "Add instructions for GitHub Pages use"; cd .. }

# Iterate over each repo manually...

# See last commit, to see if I borked it
git log --name-status HEAD^..HEAD

# Borked some git commits (didn't have -Recurse for the part files), so we amend when a commit is already there
git add -A; git commit --amend -m "Add instructions for GitHub Pages use"; git push --set-upstream origin add-instructions-pages

# Clean up after we merge PR
git fetch origin master:master; git checkout master; git branch -D add-instructions-pages; git fetch --prune

Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy") -Or $_.StartsWith("AND")) } `
| ? { -Not (@("AZR101", "PXF101", "ENT301", "FSC101", "XTC201") -Contains $_) } `
| % { cd $_; git pull; git checkout -b readme-retire-updates; git add README.md; git commit -m "Add course video, instructions link, and retirement note"; git push --set-upstream origin readme-retire-updates; cd .. }

$chrome = (gi ~\AppData\Local\Google\Chrome\Application\chrome.exe).FullName
@("https://github.com/XamarinUniversity/FSC101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/FSC102/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/FSC103/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/FSC104/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/FSC105/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS102/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS103/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS104/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS110/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS115/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS205/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS210/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS211/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS215/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS220/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS230/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS231/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS240/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS300/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS350/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS450/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/IOS451/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/PXF101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/UWP101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/WP220/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM110/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM120/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM130/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM135/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM140/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM150/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM151/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM160/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM205/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM220/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM250/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM270/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM280/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM290/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM301/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM312/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM320/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM330/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM335/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XAM370/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XTC101/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XTC102/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XTC103/compare/readme-retire-updates?expand=1", "https://github.com/XamarinUniversity/XTC201/compare/readme-retire-updates?expand=1") | % { & $chrome $_ }

# Update submodules in meta repo
Get-ChildItem -Directory C:\dev\xamu-labs\ `
| % { $_.Name } `
| ? { -Not ($_.StartsWith(".") -Or $_.StartsWith("Udemy")) } `
| ? { -Not (@("PXF101") -Contains $_) } `
| % { git add $_; git commit -m "Update $_"; }
