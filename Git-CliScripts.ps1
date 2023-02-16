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

# Get the latest dev commits for each repo.
# Multi-line commands are marked with the continuation character for ease of use in a CLI, but are not needed for a full script file.
$upstreamRemoteDefault = "upstream";
$upstreamDevelopBranchDefault = "develop";
# Start with a list of all the repos we want to check.
$repoNames = @(
  "DefCon-Badge-2022",
  "Meadow.CLI",
  "Meadow.Contracts",
  "Meadow.Core",
  "Meadow.Core.Samples",
  "Meadow.Foundation",
  "Meadow.Foundation.Grove",
  "Meadow.Foundation.Featherwings",
  "Meadow.Foundation.MikroBus",
  "Meadow.Linux",
  "Meadow.Logging",
  #...
);
# Create a list of all repo default overrides to the defaults.
# NOTE: Not using [PSCustomObject] because `Add-Member -NotePropertyMembers` doesn't work with those objects.
$repoCustomDetails = @(
  @{
    RepoName = "DefCon-Badge-2022";
    UpstreamDevelopBranch = "main";
  },
  #...
);
# Build up a list of repo details using the defaults.
$repoDetailList = $repoNames
  | ForEach-Object {
    [PSCustomObject]@{
      RepoName = $_;
      RepoUrl = "https://github.com/WildernessLabs/$_.git";
      UpstreamRemoteName = $upstreamRemoteDefault;
      UpstreamDevelopBranch = $upstreamDevelopBranchDefault;
      LocalDirectory = $_;
    }
  };
# Merge any custom repo overrides with the bulk-generated defaults.
$repoCustomDetails
  | ForEach-Object {
    $repoName = $_.RepoName;
    $repoDefaults = $repoDetailList | Where-Object { $_.RepoName -eq $repoName };
    if ($repoDefaults -ne $null) {
      $repoDefaults | Add-Member -NotePropertyMembers $_ -PassThru -Force;
    }
  } | Out-Null; # Disregard normal console output from this command.

Write-Host "Current state:";
$repoDetailList | Select-Object -First 3 #| Select-Object -Skip 10 #| Select-Object -First 2
  | ForEach-Object {

    if (Test-Path -Path $_.LocalDirectory) {
      Set-Location $_.LocalDirectory;

      $currentBranch = (git branch --show-current);
      Write-Host "$($_.RepoName) [$($currentBranch)]: " -ForegroundColor White -NoNewline;
      if ($currentBranch -eq $_.UpstreamDevelopBranch) {
        (git fetch $($_.UpstreamRemoteName) | Out-Null);
        $repoDevelopSha = (git rev-parse --short $_.UpstreamDevelopBranch);
        $repoCurrentBranchSha = (git rev-parse --short HEAD);
        if ($repoDevelopSha -ne $repoCurrentBranchSha) {
          $branchAheadCount = $(git rev-list --left-only --count $_.UpstreamDevelopBranch $_.UpstreamRemoteName/$_.UpstreamDevelopBranch);
          $branchBehindCount = $(git rev-list --right-right --count $_.UpstreamDevelopBranch $_.UpstreamRemoteName/$_.UpstreamDevelopBranch);
          Write-Host "↑$($branchAheadCount), ↓$($branchBehindCount)" -ForegroundColor Yellow;
        }
        else {
          Write-Host "up-to-date" -ForegroundColor Green;
        }
      }
      else {
        Write-Host "not on [$($_.UpstreamDevelopBranch)]" -ForegroundColor Yellow;
      }

      Set-Location ..;
    }
  }

Write-Host "Continue with updates? (Y|[N])" -NoNewline;
$continueAfterStatus = (Read-Host).ToUpper();
Write-Host $continueAfterStatus
if ($continueAfterStatus -ne "Y" && $continueAfterStatus -ne "y") {
  Return
}

$repoDetailList
  | ForEach-Object {
    # Try to get the latest changes from all upstream repos.
    Write-Host "Repo: $($_.RepoName)";
    if (Test-Path -Path $_.LocalDirectory) {
      Set-Location $_.LocalDirectory;
      $currentBranch = (git branch --show-current);
      if ($currentBranch -eq $_.UpstreamDevelopBranch) {
        # Found expected dev branch currently checked out; proceeding...
        $expectedRemoteName = $_.UpstreamRemoteName;
        $availableRemoteNames = git remote;
        if ($LASTEXITCODE -eq 1) {
          # External `git` call failed (git remote).
          Write-Warning "`tError getting repo remotes: $($_.RepoName).";
          $availableRemoteNames = @();
        }
        $hasExpectedRemote = ($availableRemoteNames | Where-Object { $_ -eq $expectedRemoteName }).Count -eq 1;
        Write-Host $hasExpectedRemote;
        if (!$hasExpectedRemote) {
          # Didn't find expected Git remote.
          Write-Warning "`tRemote not available: $($_.UpstreamRemoteName).";
          Write-Warning "`tSkipped update: $($_.RepoName).";
        } else {
          Write-Host "`tPulling latest from $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          git pull $($_.UpstreamRemoteName) $($_.UpstreamDevelopBranch);
          if ($LASTEXITCODE -eq 1) {
            # External `git` call failed (git pull).
            Write-Warning "`tError pulling latest upstream changes: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          } else {
            # External `git` call succeeded (git pull).
            Write-Host "`tUpdated with latest upstream changes: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).";
          }
        }
      } else {
        # Not on the desired dev branch. Requesting an update to the dev branch without impacting current branch.
        Write-Warning "`tRepo $($_.RepoName) not on expected dev branch ($($currentBranch) vs. $($_.UpstreamDevelopBranch)).`n`tAttempting to update adjacent dev branch.";
        git fetch $($_.UpstreamRemoteName) $($_.UpstreamDevelopBranch):$($_.UpstreamDevelopBranch);
        if ($LASTEXITCODE -eq 1) {
          # External `git` call failed (git fetch).
          Write-Warning "`tError updating adjacent dev branch: $($_.RepoName) $($_.UpstreamRemoteName)/$($_.UpstreamDevelopBranch).`n`t`tMake sure your dev branch isn't ahead of the upstream dev branch.";
        } else {
          Write-Host "`tUpdated adjacent dev branch: $($_.RepoName) $($_.UpstreamDevelopBranch).`n`t`tYour current branch was unaffected ($($currentBranch)).";
        }
      }
      Set-Location ..
    } else {
      # Repo not found; cloning new...
      Write-Host "`tRepo folder not found: cloning new copy...";
      git clone --branch $($_.UpstreamDevelopBranch) --origin $($_.UpstreamRemoteName) $($_.RepoUrl) $($_.LocalDirectory);
      if ($LASTEXITCODE -eq 1) {
        # External `git` call failed (git clone).
        Write-Warning "`tError cloning repo: $($_.RepoName)";
      } else {
        # External `git` call succeeded (git clone).
        Write-Host "`tCloned new repo: $($_.RepoName)";
      }
    }
  };


# Original version that generated code to then customize manually before running
$repoDetails = @( `
  [PSCustomObject]@{ `
    Name = "DefCon-Badge-2022"; `
    RepoUrl = "https://github.com/WildernessLabs/DefCon-Badge-2022.git"; `
    DevBranch = "main"; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.CLI"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.CLI.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Contracts"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Contracts.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Core"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Core.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Core.Samples"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Core.Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Foundation"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Foundation.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Foundation.Grove"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Foundation.Grove.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Foundation.Featherwings"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Foundation.Featherwings.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Foundation.MikroBus"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Foundation.MikroBus.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Logging"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Logging.git"; `
    DevBranch = "main"; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Project.Samples"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Project.Samples.git"; `
    DevBranch = "b6.5"; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.ProjectLab.Samples"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.ProjectLab.Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow.Units"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow.Units.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "Meadow_Samples"; `
    RepoUrl = "https://github.com/WildernessLabs/Meadow_Samples.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  }, `
  [PSCustomObject]@{ `
    Name = "VSCode_Meadow_Extension"; `
    RepoUrl = "https://github.com/WildernessLabs/VSCode_Meadow_Extension.git"; `
    DevBranch = $upstreamDevelopBranchDefault; `
    UpstreamRemoteName = $upstreamRemoteDefault; `
  } `
);
$repoDetails `
# | Select-Object -First 1 
  | ForEach-Object { `
    Set-Location $_.Name; `
    Write-Host "Repo: $(Get-Location)"; `
    # TODO: Get current branch
    $currentBranch = (git branch --show-current); `
    if ($currentBranch -eq $_.DevBranch) { `
      git pull $_.UpstreamRemoteName $_.DevBranch; `
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
  "Meadow.Foundation.Grove", `
  "Meadow.Foundation.Featherwings", `
  "Meadow.Foundation.MikroBus", `
  "Meadow.Logging", `
  "Meadow.Project.Samples", `
  "Meadow.ProjectLab.Samples", `
  "Meadow.Units", `
  "Meadow_Samples", `
  "VSCode_Meadow_Extension" `
);
$repoNames | ForEach-Object { "  [PSCustomObject]@{ ```n    RepoName = ""$_""; ```n    RepoUrl = ""https://github.com/WildernessLabs/$_.git""; ```n    DevBranch = `$upstreamDevelopBranchDefault; ```n    UpstreamRemote = `$upstreamRemoteDefault; ```n  }, ``" } | Set-Clipboard

# Add members to existing object.
# TODO: Hoping to start with a repo array of names and defaults and override only the members in a modifications array of objects.
[PSCustomObject]@{ x = 5; y = "d" } | Add-Member -NotePropertyMembers @{ z = 3; a = "e" } -PassThru
