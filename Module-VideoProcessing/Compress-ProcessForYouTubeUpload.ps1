Set-StrictMode -Version Latest

function Compress-ProcessForYouTubeUpload
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string] $VideoPath,
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
        $videoPathWithoutExtension = $videoFileToProcess.BaseName
        $videoPathExtension = $videoFileToProcess.Extension
        $outputVideoPath = "${videoPathWithoutExtension}-transcoded${videoPathExtension}"

        # Set it up to run from within the target folder to simplify file paths.
        Set-Location $videoFileToProcess.Directory

        # # Dump current variables for debugging.
        # Get-Variable -Scope Local
    }
    Process
    {
        &$FFmpegPath -i "$videoFileToProcess" -vf yadif,format=yuv420p -force_key_frames "expr:gte(t,n_forced/2)" -c:v libx264 -crf 20 -preset slow -bf 2 -c:a aac -q:a 1 -ac 2 -ar 48000 -use_editlist 0 -movflags +faststart "$outputVideoPath"
    }
    End
    {
        # Restore location to where we started (grabbed in Begin).
        Set-Location $previousLocation
    }
}
