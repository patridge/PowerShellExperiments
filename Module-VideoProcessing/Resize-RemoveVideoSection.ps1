Set-StrictMode -Version Latest

function Resize-RemoveVideoSection
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $VideoPath,
        [Parameter(Mandatory=$true)]
        [string] $StartRemoveTime,
        [Parameter(Mandatory=$true)]
        [string] $EndRemoveTime,
        [Parameter(
            Mandatory=$false,
            HelpMessage="Override path to FFmpeg install location. If not provided, the default Chocolatey install location is used."
        )]
        [string] $FFmpegPath
    )

    Begin
    {
        $previousLocation = Get-Location
        $FFmpegPath = [string]::IsNullOrEmpty($FFmpegPath) ? "C:\ProgramData\chocolatey\bin\ffmpeg.exe" : $FFmpegPath
        $operationRandom = Get-Random

        $videoFileToProcess = Get-Item $VideoPath
        if (-not (Test-Path $videoFileToProcess -PathType Leaf)) {
            Write-Error "Video path must be a file."
            return
        }
        $videoPathWithoutExtension = $videoFileToProcess.BaseName
        $videoPathExtension = $videoFileToProcess.Extension
        $outputVideoPath = "${videoPathWithoutExtension}-shortened${videoPathExtension}"

        # Set it up to run from within the target folder to simplify file paths.
        Set-Location $videoFileToProcess.Directory

        $operationTempPath = "${videoPathWithoutExtension}-${operationRandom}"
        $startClipPath = "${operationTempPath}-start${videoPathExtension}"
        $endClipPath = "${operationTempPath}-end${videoPathExtension}"
        $concatTempFilePaths = @($startClipPath, $endClipPath)
        $concatFileListPath = "${operationTempPath}-concatfiles.txt"

        # Dump current variables for debugging.
        #Get-Variable -Scope Local
    }
    Process
    {
        # Truncate from start of video to start of removed section.
        &$FFmpegPath -i "$videoFileToProcess" -ss 00:00:00 -to $StartRemoveTime -c copy "$startClipPath"
        # Truncate from end of removed section to end.
        &$FFmpegPath -i "$videoFileToProcess" -ss $EndRemoveTime -c copy "$endClipPath"
        # Create temp file of video paths for FFmpeg to concatenate.
        $concatTempFilePaths | ForEach-Object { "file `'$_`'" } | Out-File $concatFileListPath

        &$FFmpegPath -f concat -safe 0 -i "$concatFileListPath" -c copy "$outputVideoPath"
    }
    End
    {
        # Clean up temp file(s)
        Remove-Item -Path $startClipPath
        Remove-Item -Path $endClipPath
        Remove-Item -Path $concatFileListPath
        # Restore location to where we started (grabbed in Begin).
        Set-Location $previousLocation
    }
}

# Resize-RemoveVideoSection -VideoPath . -StartRemoveTime "00:01:05" -EndRemoveTime "01:14:32"
# -FFmpegPath "C:\ProgramData\chocolatey\bin\ffmpeg.exe"