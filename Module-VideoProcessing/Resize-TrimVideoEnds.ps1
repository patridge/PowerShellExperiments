Set-StrictMode -Version Latest

function Resize-TrimVideoEnds
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $VideoPath,
        [Parameter(
            Mandatory=$false,
            HelpMessage="Time to start trimming from the beginning of the video. If not provided, the new video will start at the beginning of the current video using a start time of 00:00:00.")]
        [string] $StartKeepTime = "00:00:00",
        [Parameter(
            Mandatory=$false,
            HelpMessage="Time to start trimming from the end of the video. If not provided, the entire video is kept by using an end time of 999,999,999 hours, which won't work if the video you are trimming is ridiculously long.")]
        [string] $EndKeepTime = "999999999",
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

        $videoFileToProcess = Get-Item $VideoPath
        if (-not (Test-Path $videoFileToProcess -PathType Leaf)) {
            Write-Error "Video path must be a file."
            return
        }
        # Set it up to run from within the target folder to simplify file paths.
        Set-Location $videoFileToProcess.Directory

        $videoPathWithoutExtension = $videoFileToProcess.BaseName
        $videoPathExtension = $videoFileToProcess.Extension
        $outputVideoPath = "${videoPathWithoutExtension}-trimmed${videoPathExtension}"

        # Dump current variables for debugging.
        #Get-Variable -Scope Local
    }
    Process
    {
        # Trim video down to start-to-end time, removing before start and after end.
        &$FFmpegPath -i "$videoFileToProcess" -ss $StartKeepTime -to $EndKeepTime -c copy "$outputVideoPath"
    }
    End
    {
        # Restore location to where we started (grabbed in Begin).
        Set-Location $previousLocation
    }
}

# Resize-TrimVideoEnds -VideoPath . -StartKeepTime "00:01:05" -EndKeepTime "01:14:32"
# -FFmpegPath "C:\ProgramData\chocolatey\bin\ffmpeg.exe"