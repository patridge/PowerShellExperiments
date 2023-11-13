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
        $FFmpegPath = [string]::IsNullOrEmpty($FFmpegPath) ? "C:\ProgramData\chocolatey\bin\ffmpeg.exe" : $FFmpegPath
        $operationRandom = Get-Random

        # NOTE: Switched to `Get-ChildItem` after `[System.IO.Path]::GetFullPath` wasn't working as expected for relative filenames. (Starting PS in C:\dev, `cd` to C:\somewhere\else, but GetFullPath is still `C:\dev\`.)
        $videoFullPath = Get-ChildItem $VideoPath
        $videoPathWithoutExtension = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($videoFullPath), [System.IO.Path]::GetFileNameWithoutExtension($videoFullPath))
        $videoPathExtension = [System.IO.Path]::GetExtension($videoFullPath)
        $outputVideoPath = "${videoPathWithoutExtension}-shortened${videoPathExtension}"

        $operationTempPath = "${videoPathWithoutExtension}-${operationRandom}"
        $startClipPath = "${operationTempPath}-start${videoPathExtension}"
        $endClipPath = "${operationTempPath}-end${videoPathExtension}"
        $concatTempFilePaths = @($startClipPath, $endClipPath)
        $concatFileListPath = "${operationTempPath}-concatfiles.txt"

        # Dump current variables for debugging.
        #Get-Variable -Scope Local
        # TODO: Use `Write-Verbose` for extra debugging help.
    }
    Process
    {
        # Truncate video to a specific start/end
        # &$FFmpegPath -i "`"$VideoPath`"" -ss $StartTime -to $EndTime -c copy "`"${VideoPath}-trimmed.mp4`""

        # Truncate from start of video to start of removed section.
        &$FFmpegPath -i "`"$videoFullPath`"" -ss 00:00:00 -to $StartRemoveTime -c copy "`"$startClipPath`""
        # Truncate from end of removed section to end.
        &$FFmpegPath -i "`"$videoFullPath`"" -ss $EndRemoveTime -c copy "`"$endClipPath`""
        # Create temp file of video paths for FFmpeg to concatenate.
        $concatTempFilePaths | ForEach-Object { "file `'$_`'" } | Out-File $concatFileListPath

        # TODO: Allow custom output file name
        &$FFmpegPath -f concat -safe 0 -i "`"$concatFileListPath`"" -c copy "`"$outputVideoPath`""
    }
    End
    {
        # TODO: Clean up temp files
        # Remove-Item -Path $startClipPath
        # Remove-Item -Path $endClipPath
        # Remove-Item -Path $concatFileListPath
    }
}

# Resize-RemoveVideoSection -VideoPath . -StartRemoveTime "00:01:05" -EndRemoveTime "01:14:32"
# -FFmpegPath "C:\ProgramData\chocolatey\bin\ffmpeg.exe"