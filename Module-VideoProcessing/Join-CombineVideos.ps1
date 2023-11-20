Set-StrictMode -Version Latest

function Join-CombineVideos
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$false,
            HelpMessage="Path of folder to use for video files. If not provided, the current directory is used."
        )]
        [string] $VideoFolderPath,
        # [Parameter(
        #     Mandatory=$false,
        #     HelpMessage="Override video extension to use. If not provided, the default is `.mp4`."
        # )]
        # [string] $VideoExtension,
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

        # Get the passed in folder's name.
        $videoFolderToProcess = Get-Item ([string]::IsNullOrEmpty($VideoFolderPath) ? "." : $VideoFolderPath)
        if (-not (Test-Path $videoFolderToProcess -PathType Container)) {
            Write-Error "Video folder path must be a directory."
            return
        }
        $videoFolderName = $videoFolderToProcess.Name
        # Set it up to run from within the target folder to simplify file paths.
        Set-Location $videoFolderToProcess

        # Video file extensions to look for (default is what my GoPro produces).
        $videoExtensions = @(".mp4")
        # Other possible video extensions...not sure what FFmpeg would support?
        # ".mov", ".avi", ".wmv", ".mkv", ".flv", ".webm", ".m4v", ".mpg", ".mpeg", ".m2v", ".vob", ".3gp", ".3g2", ".mxf", ".ts", ".mts", ".m2ts", ".dv", ".f4v", ".gifv", ".gif", ".ogv", ".ogg", ".drc", ".rm", ".rmvb", ".mng", ".avi", ".MTS", ".m2ts", ".ts", ".mts", ".m2t", ".mts", ".m2p", ".m2v", ".mpg", ".mpeg", ".mpe", ".mpv", ".mp2", ".mpeg", ".mpeg1", ".mpeg2", ".mpeg4", ".m4v", ".m4p", ".m4b", ".m4r", ".m4a", ".3gp", ".3g2"

        # Check if folder has video files.
        # FUTURE: Check for all allowed video extensions, though we probably want to assume merging only of same-extension video files.
        $videoFiles = Get-ChildItem . -Filter "*$($videoExtensions[0])" -File

        $videoExtensionToMerge = $videoExtensions[0]
        # Output file will be based on the input folder name.
        $outputVideoPath = "${videoFolderName}-combined${videoExtensionToMerge}"

        if ($videoFiles.Count -eq 0) {
            Write-Error "No video files found in folder."
            return
        }

        # Path to temp file that will contain a list of all video files for FFmpeg to merge.
        $concatFileListPath = "$videoFolderName-concatfiles.txt"

        # # Dump current variables for debugging.
        # Get-Variable -Scope Local
    }
    Process
    {
        # Get all video files in folder, sorted by last write time, for an FFmpeg concat file.
        Get-ChildItem . | Where-Object { $_.Name -like "*$videoExtensionToMerge" } | Sort-Object -Property LastWriteTime | ForEach-Object { "file '" + $_.FullName + "'" } > $concatFileListPath

        # Combine all the videos found into a single video file.
        &$FFmpegPath -f concat -safe 0 -i "$concatFileListPath" -c copy "$outputVideoPath"
    }
    End
    {
        # Clean up temp file(s)
        Remove-Item -Path $concatFileListPath
        # Restore location to where we started (grabbed in Begin).
        Set-Location $previousLocation
    }
}

# Join-CombineVideos -VideoFolderPath="." -StartRemoveTime="00:01:05" -EndRemoveTime="01:14:32"
# -FFmpegPath "C:\ProgramData\chocolatey\bin\ffmpeg.exe"