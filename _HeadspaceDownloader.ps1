# For an array of URL strings, map each to an index and URL, then run a VLC command to stream that URL to a file with a specific format like this.
# I was doing this for an offline copy of my Headspace meditation sessions. Each session was its own m3u8 file loading a single audio file.

# To get the .m3u8 file, use your browser's developer tools to find the network request for a file with the .m3u8 extension, in this case `highest.m3u8` within a particular CloudFront static file hosting system.
# Since these files appear to be common across all users, I will not be sharing these URLs here. You'll have to get them from using your own subscription.

# Array of URLs and titles
$urlsAndIndices = @(
    # @{ Name = "Pro Level 1.1, Andy"; Url = "https://xxx.cloudfront.net/private/encoded/hls/xxx/en-US/highest.m3u8" },
    @{ Name = "Some sessions, Andy"; Url = "{.m3u8 url from browser dev tools}" },
    # ... more sessions to download ...
) | ForEach-Object { [PSCustomObject]$_ }

# Wherever you've installed VLC
$vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"

# While this will launch a separate VLC window for each download, the alternative of using `-I dummy` seems to run hidden in the background where you can't control it and it doesn't always close itself when done.

# Launch a VLC instance for each session to download, letting VLC do the download work itself.
$urlsAndIndices | ForEach-Object { &$vlcPath "$($_.Url)" --sout "#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100,scodec=none}:file{dst=`"$($_.Name).mp3`",no-overwrite}" }
