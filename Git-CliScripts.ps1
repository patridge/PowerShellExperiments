# List the branch and state/status from upstream
$upstreamRemote = "upstream"; `
Get-ChildItem -Directory `
  | Where-Object Name -NotIn @("_myprojects", "NetduinoSamples") `
  | ForEach-Object {  `
    Set-Location $_; `
    $currentBranch = (git branch --show-current); `
    $commitsAhead = (git rev-list $currentBranch --not $upstreamRemote/$currentBranch --count); `
    $commitsBehind = (git rev-list $upstreamRemote/$currentBranch --not $currentBranch --count); `
    Write-Host "$($_.Name): $(git branch --show-current) ↓$commitsAhead ↑$commitsBehind"; `
    Set-Location .. `
  }

$upstreamRemote = "upstream"; `
Get-ChildItem -Directory `
  | Where-Object Name -NotIn @("_myprojects", "NetduinoSamples") `
  | ForEach-Object { `
    Set-Location $_; `
    $currentBranch = (git branch --show-current); `
    $commitsAhead = (git rev-list $currentBranch --not $upstreamRemote/$currentBranch --count); `
    $commitsBehind = (git rev-list $upstreamRemote/$currentBranch --not $currentBranch --count); `
    # Write-Host "$($_.Name): $(git branch --show-current) ↓$commitsAhead ↑$commitsBehind"; `
    Set-Location .. `
  }

# Do something for each repo
$upstreamRemoteDefault = "upstream";
$upstreamDevelopBranchDefault = "develop";
$repoDetails = @( `
  [pscustomobject]@{ `
    Name = "DefCon-Badge-2022"; `
    RepoName = "https://github.com/WildernessLabs/DefCon-Badge-2022.git"; `
    DevBranch = "main"; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.CLI"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.CLI.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Contracts"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Contracts.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Core"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Core.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Core.Samples"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Core.Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Foundation"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Foundation.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Logging"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Logging.git"; `
    DevBranch = "main"; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Project.Samples"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Project.Samples.git"; `
    DevBranch = "b6.5"; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.ProjectLab.Samples"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.ProjectLab.Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow.Units"; `
    RepoName = "https://github.com/WildernessLabs/Meadow.Units.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "Meadow_Samples"; `
    RepoName = "https://github.com/WildernessLabs/Meadow_Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  }, `
  [pscustomobject]@{ `
    Name = "VSCode_Meadow_Extension"; `
    RepoName = "https://github.com/WildernessLabs/VSCode_Meadow_Extension.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemote = $upstreamRemoteDefault; `
  } `
);
$repoDetails `
#| Select-Object -First 1 
| ForEach-Object { `
  Set-Location $_.Name; `
  Write-Host "Repo: $(Get-Location)"; `
  # TODO: Get current branch
  $currentBranch = (git branch --show-current); `
  if ($currentBranch -eq $_.DevBranch) { `
    git pull $_.UpstreamRemote $_.DevBranch; `
  } else { `
    Write-Information "Repo $_.Name not on expected dev branch"; `
  } `
  Write-Host "  Branch: $currentBranch"; `
  # TODO: If currently on $_.DevBranch, pull latest from $_DevBranch
  # TODO: Else display some output
  Set-Location .. `
}

# Generate the initial array of repo details.
$repoNames = @( `
  "DefCon-Badge-2022", `
  "Meadow.CLI", `
  "Meadow.Contracts", `
  "Meadow.Core", `
  "Meadow.Core.Samples", `
  "Meadow.Foundation", `
  "Meadow.Logging", `
  "Meadow.Project.Samples", `
  "Meadow.ProjectLab.Samples", `
  "Meadow.Units", `
  "Meadow_Samples", `
  "VSCode_Meadow_Extension" `
);
$repoNames | ForEach-Object { "  [pscustomobject]@{ ```n    Name = ""$_""; ```n    RepoName = ""https://github.com/WildernessLabs/$_.git""; ```n    DevBranch = `$upstreamDevelopBranchDefault; ```n    UpstreamRemote = `$upstreamRemoteDefault; ```n  }, ``" } | Set-Clipboard