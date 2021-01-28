# List all properties on an object
X | Format-List -Property *

# Make anything an array by wrapping it in `@(X)`
@("Just one thing") # is an array of that one string

# Get the length of an array piped (vs. `(X | Y).Length`)
 | Measure-Object # Returns an object, though, with a Count property
 | Measure-Object | % { $_.Count } # Bit of a hack, but single item arrays will output the only item as a string

# Get list of numbers to pass/pipe to something else
[System.Linq.Enumerable]::Range(0,40)

# String of length `i`, composed of `a`s (mostly just calling `new string('a', i)`)
New-Object string -ArgumentList @('a', i)

# Create file with variable name of `x`
New-Item x -Type file

# Limit to first/last/whatever X items from a previous command's enumerable
{some list} | Select-Object -First 1
{some list} | Select-Object -Last 1
{some list} | Select-Object -Skip 5 | Select-Object -First 1

# Access a field/property with an unusual name (e.g., contains a period in the name itself)
# Wrap name in curly braces. This is not a placeholder like `{some list}` usage above.
$X.{Some.Property.With.Period}

# Bulk change of file extension
# In this case, I'm changing a bunch of audiobook CD files from .m4a to .m4b to use them in the audiobook portion of the iTunes/Music app on macOS
Get-ChildItem . -Recurse -Filter *.m4a | Rename-Item -NewName {[System.IO.Path]::ChangeExtension($_.Name, ".m4b")}
# Equivalent with an explicit setting of the `-Path` parameter (implied above)
Get-ChildItem . -Recurse -Filter *.m4a | % { Rename-Item -Path $_ -NewName ([System.IO.Path]::ChangeExtension($_.Name, ".m4b")) }

# Line breaks in strings (\n or \r\n in C# and friends)
"First line`nSecond line"
"First line`r`nSecond line"