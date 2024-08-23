# For an array of URL strings, map each to an index and URL, then run a VLC command to stream that URL to a file with a specific format like this.
# I was doing this for an offline copy of my Headspace meditation sessions. Each session was its own m3u8 file loading a single audio file.

# Array of URLs
$urlsAndIndices = @(
    # @{ Name = "Pro Level 1.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000703/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000714/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000725/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000736/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000747/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000758/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000769/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000780/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000791/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 1.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000802/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000813/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000824/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000835/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000846/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000857/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000868/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000879/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000890/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000901/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 2.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000912/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000923/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000926/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000929/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000932/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000935/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000938/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000941/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000944/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000947/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 3.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000950/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000953/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000956/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000959/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000962/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000965/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000968/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000971/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000974/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000977/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 4.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000980/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000983/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000986/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000989/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000992/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000995/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800000998/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001001/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001004/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001007/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 5.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001010/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001013/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001016/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001019/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001022/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001025/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001028/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001031/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001034/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001037/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 6.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20200910094800001040/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/3ED338AZMT4NH601qzyHal/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/7bYwwvAiyOHCBi3y2wLE7P/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/64Aq56R0GYpVHTL36gljGM/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/6JQLCvijgC0mmMuwDjow3f/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/5HhM31LMu4FMSdnOlVtCyk/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/7e2AxZEhs5tegFUVnPJGlJ/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/aCiob4o4rUYk7XPiuyFD3/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/769VbyX2LH6lVoTvnnwRVP/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/3c0QjUAhUszg3aB18yBNZF/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 7.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/4w8VUdL0iuJJa7NpStFdEk/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.1, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/eNrbVrKVYN7Ye8rOTv8M7/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.2, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/6qULE6Z3kUFZctTsQHRzve/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.3, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/42MsK9FrOZ1wsI4VpMn21d/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.4, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/7r6BvVFPkfOOXC7gVA3mdF/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.5, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/zQzrQXnRq0FM9HkQ6uFkW/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.6, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/ag6D8DR9sEkyrHRmUMWXu/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.7, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/7cmkPSZjiz01jACJiuBBOm/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.8, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/VCkgL2yNGgfQeIISCgCqH/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.9, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/2JRkBEuLF4opL2vvg2q3OK/en-US/highest.m3u8" },
    # @{ Name = "Pro Level 8.10, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/6f548kKUhvHVcYqtRpW37Y/en-US/highest.m3u8" },
    # @{ Name = "Stiffness, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000012/en-US/highest.m3u8" },
    # @{ Name = "Swallowing, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000013/en-US/highest.m3u8" },
    # @{ Name = "Itching, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000017/en-US/highest.m3u8" },
    # @{ Name = "Pain, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000018/en-US/highest.m3u8" },
    # @{ Name = "Numbness, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000019/en-US/highest.m3u8" },
    # @{ Name = "Cramps, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000020/en-US/highest.m3u8" },
    # @{ Name = "Dizziness, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000021/en-US/highest.m3u8" },
    # @{ Name = "Spasms, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000022/en-US/highest.m3u8" },
    # @{ Name = "Under Effort, Andy"; Url = "https://d3jyalop6jpmn2.cloudfront.net/private/encoded/hls/HS20210331102053000010/en-US/highest.m3u8" }
    # @{ Name = ", Andy"; Url = "" }
    @{ Name = ", Andy"; Url = "" }
) | ForEach-Object { [PSCustomObject]$_ }
    # | Select-Object -Skip 5

$vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"

# # This will show a separate VLC window for each download, but the `-I dummy` version seems to run hidden in the background where you can't control it.

$urlsAndIndices | ForEach-Object { &$vlcPath "$($_.Url)" --sout "#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100,scodec=none}:file{dst=`"$($_.Name).mp3`",no-overwrite}" }
