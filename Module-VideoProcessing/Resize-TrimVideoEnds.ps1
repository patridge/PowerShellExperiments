Set-StrictMode -Version Latest

function Resize-TrimVideoEnds
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $VideoPath,
        [Parameter(Mandatory=$false)]
        [string] $StartKeepTime,
        [Parameter(Mandatory=$false)]
        [string] $EndKeepTime,
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
        # TODO: Use `Write-Verbose` for extra debugging help.
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