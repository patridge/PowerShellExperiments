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
        [Parameter(
            Mandatory=$false,
            HelpMessage="Override default file extension to use when looking for video files to combine. If not provided, the default is `.mp4`."
        )]
        [string] $VideoExtension,
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

        # Video file extension to look for (default is .mp4 that GoPro produces, though default OBS is .mkv).
        # Other possible video extensions...not sure what FFmpeg would support?
        # ".mov", ".avi", ".wmv", ".flv", ".webm", ".m4v", ".mpg", ".mpeg", ".m2v", ".vob", ".3gp", ".3g2", ".mxf", ".ts", ".mts", ".m2ts", ".dv", ".f4v", ".gifv", ".gif", ".ogv", ".ogg", ".drc", ".rm", ".rmvb", ".mng", ".avi", ".MTS", ".m2ts", ".ts", ".mts", ".m2t", ".mts", ".m2p", ".m2v", ".mpg", ".mpeg", ".mpe", ".mpv", ".mp2", ".mpeg", ".mpeg1", ".mpeg2", ".mpeg4", ".m4v", ".m4p", ".m4b", ".m4r", ".m4a", ".3gp", ".3g2"
        $VideoExtension = [string]::IsNullOrEmpty($VideoExtension) ? ".mp4" : $VideoExtension
        $videoExtensionToMerge = $VideoExtension

        # Check if folder has video files.
        $videoFiles = Get-ChildItem . -Filter "*$($videoExtensionToMerge)" -File

        # Output file will be based on the input folder name.
        $outputVideoPath = "${videoFolderName}-combined${videoExtensionToMerge}"

        # TODO: If there aren't any video files found, this fails entirely on no `.Count` field rather than this error handler.
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
        # TODO: Get this to work with multiple file extensions.
        # Get all video files in folder, sorted by create date, for an FFmpeg concat file.
        Get-ChildItem . | Where-Object { $_.Name -like "*$videoExtensionToMerge" } | Sort-Object -Property CreationTime | ForEach-Object { "file '" + $_.FullName + "'" } > $concatFileListPath

        # Combine all the videos found into a single video file.
        &$FFmpegPath -f concat -safe 0 -i "$concatFileListPath" -c copy "$outputVideoPath"

        # & ffmpeg -f concat -safe 0 -i $concatFileListPath -c:v libx264 -c:a aac $outputVideoPath

        # NOTE: Combining multiple video file types (multiple extensions) requires re-encoding.
        # &$FFmpegPath -f concat -safe 0 -i "$concatFileListPath" -c:v libx264 -c:a aac "$outputVideoPath"
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