# When GoPro recordings fill a 4GB file, they continue into additional sequential files differentiatedby the second and third characters, such as "GH010136.MP4" to "GH040136.MP4" when recording "0136" spans four files (GH01, GH02, GH03, GH04).
# Group all MP4 files of that GH*.MP4 format by the recording number (last four numbers) and filter by any grouping that contains more than one file, indicating it spans multiple files.

# TODO: Edit for your own FFmpeg install location
$ffmpegLocation = "~/Tools/ffmpeg/ffmpeg.exe"
$outputCombinedVideoSuffix = "-combined"

# Get all appropriate GoPro video segments without getting any previously generated combined video files (`-Exclude`).
foreach ($group in (Get-ChildItem GH*.MP4 -Exclude GH*${outputCombinedVideoSuffix}.MP4 | Group-Object -Property { $_.Name.Substring($_.Name.Length - ".MP4".Length - 4, 4) } | ? { ($_.Group | Measure-Object).Count -gt 1 })) {
    # The ffmpeg utility can concatenate a bunch of video files if they are in a text file with a filename list syntax. For each group, we generate that list in a text file, concatenate all the videos within that list via ffmpeg, and then delete the text file.
    $groupName = $group.Name # e.g., "0136" from "GH030136.MP4"
    $groupFiles = $group.Group # e.g., "GH010136.MP4", "GH020136.MP4", "GH030136.MP4"
    $concatFileListName = "${groupName}_files.txt"
    $concatFileListOutput = $groupFiles | Sort-Object -Property LastWriteTime | % { $_.Name } | % { "file '${_}'" }
    $concatFileListOutput > $concatFileListName
    $concatFileOutputName = "GH${groupName}${outputCombinedVideoSuffix}.mp4"
    & ${ffmpegLocation} -f concat -safe 0 -i ./$concatFileListName -c copy $concatFileOutputName
    Remove-Item $concatFileListName
}
