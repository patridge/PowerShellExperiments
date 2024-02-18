# Windows development install commands
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Resize-RemoveVideoSection.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Resize-RemoveVideoSection.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Join-CombineVideos.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Join-CombineVideos.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Resize-TrimVideoEnds.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Resize-TrimVideoEnds.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\Compress-ProcessForYouTubeUpload.ps1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\Compress-ProcessForYouTubeUpload.ps1" -Force
# New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\Documents\PowerShell\Modules\VideoProcessing\VideoProcessing.psm1" -Target "C:\dev\PowerShellExperiments\Module-VideoProcessing\VideoProcessing.psm1" -Force

# macOS development install commands
# The symbolic link effort doesn't seem to work on macOS, despite creating symbolic links correctly. When you import the module, it will complain that the .pms1 file doesn't exist still.
# Instead, you can import the module by its full path as a `-Name` parameter.
# Import-Module -Name "~/dev/PowerShellExperiments/Module-VideoProcessing/VideoProcessing.psm1" -Force
# macOS also doesn't appear to load Microsoft.PowerShell.Utility and will fail on the `Sort-Object` cmdlet.
# Import-Module Microsoft.PowerShell.Utility

. $PSScriptRoot\Join-CombineVideos.ps1
. $PSScriptRoot\Resize-RemoveVideoSection.ps1
. $PSScriptRoot\Resize-TrimVideoEnds.ps1
. $PSScriptRoot\Compress-ProcessForYouTubeUpload.ps1
