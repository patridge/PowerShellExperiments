# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Resize-RemoveVideoSection.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Resize-RemoveVideoSection.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Join-CombineVideos.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Join-CombineVideos.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Resize-TrimVideoEnds.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Resize-TrimVideoEnds.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Compress-ProcessForYouTubeUpload.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Compress-ProcessForYouTubeUpload.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\VideoProcessing.psm1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\VideoProcessing.psm1" -Force

# New changes need to be reloaded, either by forced import or remove and re-import.
# Remove-Module VideoProcessing
# Import-Module VideoProcessing -Force

. $PSScriptRoot\Join-CombineVideos.ps1
. $PSScriptRoot\Resize-RemoveVideoSection.ps1
. $PSScriptRoot\Resize-TrimVideoEnds.ps1
. $PSScriptRoot\Compress-ProcessForYouTubeUpload.ps1
