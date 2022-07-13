# List the branch and state/status from upstream
$upstreamRemote = "upstream"; `
Get-ChildItem -Directory `
  | Where-Object Name -NotIn @("_myprojects", "NetduinoSamples") `
  | ForEach {  `
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
  | ForEach { `
    Set-Location $_; `
    $currentBranch = (git branch --show-current); `
    $commitsAhead = (git rev-list $currentBranch --not $upstreamRemote/$currentBranch --count); `
    $commitsBehind = (git rev-list $upstreamRemote/$currentBranch --not $currentBranch --count); `
    # Write-Host "$($_.Name): $(git branch --show-current) ↓$commitsAhead ↑$commitsBehind"; `
    Set-Location .. `
  }
