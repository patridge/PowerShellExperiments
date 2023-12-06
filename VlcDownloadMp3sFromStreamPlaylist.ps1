# For an array of URL strings, map each to an index and URL, then run a VLC command to stream that URL to a file with a specific format like this.
# I was doing this for an offline copy of my Headspace meditation sessions. Each session was its own m3u8 file loading a single audio file.

# Array of URLs
$urlsAndIndices = @(
    "https://somewhere.com/first.m3u8",
    "https://somewhere.com/second.m3u8",
    "...",
    "https://somewhere.com/last.m3u8"
) | ForEach-Object -Begin { $i = 1 } -Process { [PSCustomObject]@{ Index = ($i++); Url = $_ } }

$vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"

# This will show a separate VLC window for each download, but the `-I dummy` version seems to run hidden in the background where you can't control it.

$urlsAndIndices | ForEach-Object { &$vlcPath "$($_.Url)" --sout "#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100,scodec=none}:file{dst=basics-$("{0:D2}" -f $_.Index)-andy.mp3,no-overwrite}" }
